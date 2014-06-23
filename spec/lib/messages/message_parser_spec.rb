require 'spec_helper'

module Messages
  describe MessageParser do

    xit 'should parse sqs message and create an error message' do
      msg = Messages::MessageParser.parse(error_message).to_response
      msg.has_key?(:subject).should eq true
    end

    xit 'should create event message' do
      message = Messages::MessageParser.parse(event_message).to_response

      message[:payload].has_key?(:error_message).should eq false
    end
  end
end