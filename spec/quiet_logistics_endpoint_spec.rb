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

  describe 'error handling' do
    context "when an exception occurs" do
      before do
        expect(Processor).to receive(:new).and_raise('crash')
        post '/get_data', {}.to_json, auth
      end

      describe 'response' do
        specify do
          expect(last_response.status).to eq 500

          expect(json_response['summary']).to eq 'crash'
        end
      end
    end
  end

  describe '/get_messages' do
    let(:config) do
      super().merge(
        'ql_incoming_queue' => 'some-ql-queue',
      )
    end

    def make_request
      post '/get_messages', post_data, auth
    end

    def post_data
      {
        'request_id' => '123',
        'parameters' => config,
      }.to_json
    end

    let(:message) do
      {
        "id" => "c76dfc90-96ba-4239-a2b3-0f0ff800e502",
        "document_type" => "ShipmentOrderResult",
        "document_name" => "SoResultV2_BONOBOS_H47763445062_20150316_164132538.xml",
        "business_unit" => "BONOBOS",
      }
    end

    describe 'response' do
      before do
        expect_any_instance_of(Receiver).to receive(:receive_messages).and_yield(message)
        expect_any_instance_of(Receiver).to receive(:count).and_return(1)
        make_request
      end

      specify do
        expect(last_response.status).to eq 200

        expect(json_response['summary']).to eq 'received 1 messages'

        expect(json_response['messages']).to be_a Array
        expect(json_response['messages'].size).to eq 1

        received_message = json_response['messages'].first

        expect(received_message).to eq message
      end
    end
  end

  describe '/get_data' do
    let(:config) do
      super().merge(
        'ql_incoming_bucket' => 'some-ql-bucket',
      )
    end

    def make_request(document_type:)
      post '/get_data', post_data(document_type: document_type), auth
    end

    def stub_s3_response(response)
      stub_request(
        :get, "https://some-ql-bucket.s3.amazonaws.com/filename.xml"
      ).to_return(response)
    end

    def post_data(document_type:)
      {
        'request_id' => '123',
        'parameters' => config,
        'message' => {
          'id' => '5128fb15-b1cb-f466-7b9d-49ded61c6817',
          'document_type' => document_type,
          'document_name' => 'filename.xml',
          'business_unit' => 'MYBIZ',
        },
      }.to_json
    end

    context 'with an unhandled document type' do
      before do
        stub_s3_response(status: 200, body: "doesn't matter")
        make_request(document_type: 'FooBar')
      end

      describe 'response' do
        specify do
          expect(last_response.status).to eq 200

          expect(json_response['summary']).to eq "Cannot handle document of type FooBar"
        end
      end
    end

    context 'with a ShipmentOrderResult' do
      before do
        stub_s3_response(status: 200, body: s3_response_body)
        make_request(document_type: 'ShipmentOrderResult')
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

      describe 'response' do
        specify do
          expect(last_response.status).to eq 200

          expect(json_response['summary']).to eq "Got Data for filename.xml"

          expect(json_response['shipments'].size).to eq 1
          expect(json_response['shipments'][0]['id']).to eq 'H13088556647'

          expect(json_response['cartons'].size).to eq 1
          expect(json_response['cartons'][0]['id']).to eq 'S11111111'
        end
      end
    end

    context 'with an RMAResultDocument' do
      before do
        stub_s3_response(status: 200, body: s3_response_body)
        make_request(document_type: 'RMAResultDocument')
      end

      let(:s3_response_body) do
        <<-XML
          <?xml version="1.0" encoding="utf-8"?>
          <RMAResultDocument
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:xsd="http://www.w3.org/2001/XMLSchema"
              xmlns="http://schemas.quietlogistics.com/V2/RMAResultDocument.xsd">
            <RMAResult
                ClientID="BONOBOS"
                BusinessUnit="BONOBOS"
                RMANumber="H11111111111"
                ReceiptDate="2015-03-16T13:02:08.667Z"
                Warehouse="DVN">
              <Line
                  LineNo="1"
                  ItemNumber="1111111"
                  ReturnUOM="EA"
                  Quantity="1"
                  ProductStatus="GOOD"
                  Notes=""
                  OrderNumber="H11111111111"
                  Reason="01" />
            </RMAResult>
          </RMAResultDocument>
        XML
      end

      describe 'response' do
        specify do
          expect(last_response.status).to eq 200

          expect(json_response['summary']).to eq "Got Data for filename.xml"

          expect(json_response['rmas'].size).to eq 1
          expect(json_response['rmas'][0]['id']).to match /^H11111111111-\d+/
        end
      end
    end
  end

end
