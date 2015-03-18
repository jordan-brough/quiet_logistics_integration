require 'spec_helper'

describe QuietLogisticsEndpoint do
  include Rack::Test::Methods

  before do
    ENV['ENDPOINT_KEY'] = 'x123'
  end

  def auth
    { 'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json" }
  end

  def app
    QuietLogisticsEndpoint
  end

  def json_response
    JSON.parse(last_response.body)
  end

  let(:config) do
    {
      'amazon_access_key' => '123',
      'amazon_secret_key' => '123',
    }
  end

  describe '#get_data' do
    let(:config) do
      super().merge(
        'ql_incoming_bucket' => 'some-ql-bucket',
      )
    end

    def make_request
      post '/get_data', post_data.to_json, auth
    end

    def stub_s3_response(response)
      stub_request(
        :get, "https://some-ql-bucket.s3.amazonaws.com/filename.xml"
      ).to_return(response)
    end

    let(:post_data) do
      {
        'request_id' => '123',
        'parameters' => config,
        'message' => {
          'id' => '5128fb15-b1cb-f466-7b9d-49ded61c6817',
          'document_type' => document_type,
          'document_name' => 'filename.xml',
          'business_unit' => 'MYBIZ',
        },
      }
    end

    context 'with an unhandled document type' do
      let(:document_type) { 'FooBar' }
      before do
        stub_s3_response(status: 200, body: "doesn't matter")
      end

      describe 'response.status' do
        subject { last_response.status }
        before { make_request }
        it { should eq 200 }
      end

      describe 'response.body' do
        describe 'summary' do
          subject { json_response['summary'] }
          before { make_request }

          it { should eq "Cannot handle document of type FooBar" }
        end
      end
    end

    context 'with a ShipmentOrderResult' do
      let(:document_type) { 'ShipmentOrderResult' }
      before do
        stub_s3_response(status: 200, body: s3_response_body)
      end

      let(:s3_response_body) do
        <<-XML
          <?xml version="1.0" encoding="utf-8"?>
          <SOResult
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:xsd="http://www.w3.org/2001/XMLSchema"
              ClientID="BONOBOS"
              BusinessUnit="BONOBOS" OrderNumber="H13088556647"
              DateShipped="2015-02-24T15:51:31.0953088Z"
              FreightCost="0"
              CartonCount="1"
              Warehouse="DVN"
              xmlns="http://schemas.quiettechnology.com/V2/SOResultDocument.xsd">
            <Line Line="1" ItemNumber="1111111" Quantity="1" ExceptionCode="" Tax="0" Total="0" SubstitutedItem="" />
            <Carton
                CartonId="S11111111"
                TrackingId="1Z1111111111111111"
                Carrier="UPS"
                CartonNumber="1"
                ServiceLevel="GROUND"
                Weight="1.11"
                FreightCost="11.11"
                HandlingFee="0"
                Surcharge="0"
                PackageType="SINGLE">
              <Content Line="1" ItemNumber="1111111" Quantity="1" />
            </Carton>
            <Extension />
          </SOResult>
        XML
      end

      describe 'response.status' do
        subject { last_response.status }
        before { make_request }

        it { should eq 200 }
      end

      describe 'response.body' do
        describe 'summary' do
          subject { json_response['summary'] }
          before { make_request }

          it { should eq "Got Data for filename.xml" }
        end

        describe 'shipments' do
          subject { json_response['shipments'] }
          before { make_request }

          it { expect(subject.size).to eq 1 }
          it { expect(subject[0]['id']).to eq 'H13088556647' }
        end
      end
    end
  end

end
