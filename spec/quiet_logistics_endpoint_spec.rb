require 'spec_helper'

describe QuietLogisticsEndpoint do
  include Rack::Test::Methods

  before :all do
    ENV['ENDPOINT_KEY'] = 'x123'
  end

  def auth
    { 'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json" }
  end

  def app
    QuietLogisticsEndpoint
  end

  let(:config) {{'amazon_access_key' => '123',
                 'amazon_secret_key' => '123',
                 'ql_outgoing_queue' => 'test_outgoing_queue',
                 'ql_incoming_queue' => 'test_incoming_queue',
                 'quiet_logistics.ql_outgoing_bucket' => 'test-outgoing-bucket',
                 'quiet_logistics.ql_incoming_bucket' => 'test-incoming-bucket' }}

  it 'receives new messages' do

  end

  it 'responds to send_shipment_order' do
   message = {  'parameters' => config,
                'payload' => {
                  'shipment' => Factories.shipment
                  },
                'request_id' => '123' }

    Api.should_receive(:send_document).and_return('456')

    post '/send_shipment_order', message.to_json, auth
    last_response.body.should match /456/
  end

  xit 'responds to send_purchase_order' do
    message = { 'message_id' => '123456',
                'message' => 'message:purchase_order:new',
                'payload' => {
                  'parameters' => config,
                  'purchase_order' => Factories.purchase_order }}

    Api.should_receive(:send_document).and_return('123')

    post '/send_purchase_order', message.to_json, auth
    last_response.body.should match /123/
  end

  xit 'returns error notification when sending shipment order' do
      message = { 'payload' => {
                    'parameters' => config,
                     'shipment_order' => Factories.to_shipment_order },
                  'message_id' => 'abc',
                  'message' => 'shipment:new' }

    Api.should_receive(:send_document).and_raise(StandardError)

    post '/send_shipment_order', message.to_json, auth
    last_response.body.include?("StandardError").should eq true
  end

  xit 'responds to send_rma' do
    message = { 'message' => 'shipment:ready',
                'payload' => { 'parameters' => config }.merge(Factories.shipment) }

    Api.should_receive(:send_document).and_return({notifcaions: [{subject: 'succesfully sent'}]})

    post '/send_rma', message.to_json, auth

    expect(last_response.status).to eq 200
    expect(last_response.body).to match /succesfully sent/
  end
end
