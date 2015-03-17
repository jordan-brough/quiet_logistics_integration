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

end
