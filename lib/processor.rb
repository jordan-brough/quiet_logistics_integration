class Processor
  class UnknownDocType < StandardError; end

  def initialize(bucket)
    @bucket = bucket
  end

  def process_doc(msg)
    name = msg['document_name']
    type = msg['document_type']

    downloader = Downloader.new(@bucket)
    data = downloader.download(name)

    # downloader.delete_file(name)

    parse_doc(type, data)
  end

  private

  def parse_doc(type, data)
    case type
    when 'ShipmentOrderResult'
      Documents::ShipmentOrderResult.new(data)
    when 'PurchaseOrderReceipt'
      # Temporarily track whether we are actually processing these
      Rollbar.info("Proceesing #{type.inspect}")
      Documents::PurchaseOrderReceipt.new(data)
    when 'RMAResultDocument'
      Documents::RMAResult.new(data)
    else
      raise UnknownDocType, type.inspect
    end
  end
end