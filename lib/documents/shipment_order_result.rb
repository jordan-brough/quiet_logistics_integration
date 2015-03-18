#
# A ShipmentOrderResult lists items shipped, tracking number, carrier
# information, and packaging details.
#
# The structure of the XML document is:
#
=begin
  <SOResult ...>
    <Line ... />
    <Line ... />
    <Line ... />
    <Carton ... >
      <Content ... />
      <Content ... />
    </Carton>
    <Carton ... >
      <Content ... />
    </Carton>
    <Extension />
  </SOResult>
=end
#
# See the specs for a full example.

module Documents
  class ShipmentOrderResult
    NAMESPACE = 'http://schemas.quiettechnology.com/V2/SOResultDocument.xsd'

    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      @shipment_number = @doc.xpath("//@OrderNumber").first.text
      @date_shipped = @doc.xpath("//@DateShipped").first.text
      @tracking_number = @doc.xpath('//@TrackingId').first.value
      @business_unit = @doc.xpath('//@BusinessUnit').first.value
      @warehouse = @doc.xpath("//@Warehouse").first.text
    end

    def to_h
      {
        shipments: [shipment],
      }
    end

    private

    def shipment
      {
        id: @shipment_number,
        # NOTE: There may multiple tracking numbers. This is just the first.
        tracking: @tracking_number,
        warehouse: @warehouse,
        status: 'shipped',
        business_unit: @business_unit,
        shipped_at: @date_shipped,
        cartons: cartons,
      }
    end

    def cartons
      cartons = @doc.xpath('ql:SOResult/ql:Carton', 'ql' => NAMESPACE)
      cartons.map do |carton|
        {
          :id => carton['CartonId'],
          :tracking => carton['TrackingId'],
          :line_items => carton_line_items(carton),
        }
      end
    end

    def carton_line_items(carton)
      contents = carton.xpath('ql:Content', 'ql' => NAMESPACE)
      contents.map do |content|
        {
          :ql_item_number => content['ItemNumber'],
          :quantity => Integer(content['Quantity']),
        }
      end
    end

  end
end

