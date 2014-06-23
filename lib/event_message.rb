class EventMessage
  attr_accessor :document_type, :document_name, :warehouse,
                :message_date, :message_id

  def initialize(document_type, document_name, config)
    @document_type = document_type
    @document_unit = config['business_unit']
    @document_client = config['client_id']
    @document_name = document_name
    @message_date = Time.now.utc.iso8601
    @message_id = SecureRandom.uuid
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.EventMessage('xmlns' => "http://schemas.quietlogistics.com/V2/EventMessage.xsd",
                       'ClientId' => @document_client,
                       'BusinessUnit' => @document_unit,
                       'DocumentName' => document_name,
                       'DocumentType' => document_type,
                       'MessageId' => message_id,
                       'Warehouse' => 'DVN',
                       'MessageDate' => message_date)
    end
    builder.to_xml
  end

  def to_payload
    { document_type: document_type,
      document_name: document_name }
  end
end
