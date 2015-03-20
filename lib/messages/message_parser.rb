module Messages
  class MessageParser

    def self.parse(sqs_message)
      doc  = Nokogiri::XML(sqs_message.body)
      id   = sqs_message.id
      type = doc.children[0].name

      msg = if type == 'ErrorMessage'
              ErrorMessage.new(doc, id)
            elsif type == 'Acknowledgment'
              AcknowledgmentMessage.new(doc, id)
            elsif type == "EventMessage"
              IncomingEventMessage.new(doc, id)
            else
              {}
            end

      msg.to_h
    end
  end
end