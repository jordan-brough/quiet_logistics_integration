module Messages
  class AcknowledgmentMessage

    def initialize(doc, id)
      @sqs_id   = id
      @doc_type = doc.xpath("//@OriginalDocumentType").first.text
      @doc_name = doc.xpath("//@OriginalDocumentName").first.text
      @doc_key  = doc.xpath("//@OriginalDocumentKey").first.text
    end

    def to_h
      {
        id: @sqs_id,
        document_type: @type,
        doc_name: @doc_name
      }
    end
  end
end