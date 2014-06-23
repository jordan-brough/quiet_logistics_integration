module Documents
  class RMA
    attr_reader :name, :unit

    def initialize(rma, config)
      @rma    = rma
      @config = config
      @unit   = config['business_unit']
      @number = rma['id']
      @name   = "RMA_#{@number}_#{date_stamp}.xml"
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.RMADocument("xmlns" => "http://schemas.quietlogistics.com/V2/RMADocument.xsd") {
          xml.RMA('ClientID' => @config['client_id'], 'BusinessUnit' => @unit, 'RMANumber' => @number) {

            @rma['line_items'].collect.with_index { |item, i| xml.Line(line_hash item, i) }
          }
        }
      end

      builder.to_xml
    end

    def line_hash(item, index)
      {
        'LineNo'       => index + 1,
        'OrderNumber'  => @number,
        'ItemNumber'   => item['sku'],
        'Quantity'     => item['quantity'],
        'SaleUOM'      => 'EA',
        'ReturnReason' => 'general'
      }
    end

    def message
      "Sent RMA #{@number} to QL"
    end

    def date_stamp
      Time.now.strftime('%Y%m%d_%H%M%3N')
    end
  end
end