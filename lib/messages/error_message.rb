module Messages
  class ErrorMessage

    def initialize(doc, id)
      @sqs_id = id
      @error_message = doc.xpath("//@ResultDescription").first.value
      @response_date = doc.xpath("//@ResponseDate").first.value
      @result_code = doc.xpath("//@ResultCode").first.value
      @result_description = doc.xpath("//@ResultDescription").first.value
    end

    def to_h
      {
        id: @sqs_id,
        document_type: 'error',
        error_code: @result_code,
        error_description: @result_description
      }
    end
  end
end