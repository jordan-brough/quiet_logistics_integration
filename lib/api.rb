#TODO add business_unit / client_id to docs and event_messages
class Api

  def self.send_document(type, content, bucket, queue, config)
    document =
    case type
    when 'ShipmentOrder'
      Documents::ShipmentOrder.new(content, config)
    when 'PurchaseOrder'
      Documents::PurchaseOrder.new(content, config)
    when 'ItemProfile'
      Documents::ItemProfile.new(content, config)
    when 'RMADocument'
      Documents::RMA.new(content, config)
    end

    uploader = Uploader.new(bucket)
    url = uploader.process(document.name, document.to_xml)

    event_message = EventMessage.new(type, document.name, config)
    sender = Sender.new(queue)
    msg_id = sender.send_message(event_message)

    document.message
  end
end
