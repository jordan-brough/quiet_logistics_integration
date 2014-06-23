module Messages
  class IncomingEventMessage

    def initialize(doc, id)
      @sqs_id = id
      @type = doc.xpath("//@DocumentType").first.text
      @document_name = doc.xpath("//@DocumentName").first.text
      @warehouse = doc.xpath("//@Warehouse").first.text
      @message_date = doc.xpath("//@MessageDate").first.text
      @business_unit = doc.xpath("//@BusinessUnit").first.text
    end

    def to_h
      {
        id: @sqs_id,
        document_type: @type,
        document_name: @document_name,
        business_unit: @business_unit
      }
    end
  end
end