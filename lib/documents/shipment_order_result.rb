module Documents
  class ShipmentOrderResult
    attr_reader :type

    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      @type = :shipment
      @shipment_number = @doc.xpath("//@OrderNumber").first.text
      @date_shipped = @doc.xpath("//@DateShipped").first.text
      @freight_cost = @doc.xpath("//@FreightCost").first.text
      @carton_count = @doc.xpath("//@CartonCount").first.text
      @tracking_number = @doc.xpath('//@TrackingId').first.value
      @business_unit = @doc.xpath('//@BusinessUnit').first.value
      @warehouse = @doc.xpath("//@Warehouse").first.text
    end

    def to_h
      {
        id: @shipment_number,
        tracking: @tracking_number,
        warehouse: @warehouse,
        status: 'shipped',
        business_unit: @business_unit,
        shipped_at: @date_shipped
      }
    end

    private

    def items_hash(child)
      { line: child['Line'],
        item_number: child['ItemNumber'],
        quantity: child['Quantity'],
        exception_code: child['ExceptionCode'],
        tax: child['Tax'],
        total: child['Total'],
        substituted_item: child['substituted_item'] }
    end

    def create_carton_hash(child)
      @carton = { carton_id: child['CartonId'],
                  tracking_id: child['TrackingId'],
                  carrier: child['Carrier'],
                  carton_number: child['CartonNumber'],
                  service_level: child['ServiceLevel'],
                  weight: child['Weight'],
                  freight_cost: @freight_cost,
                  line_items: [] }

      @carton[:line_items] << child.children.collect { |ch|
        { line: ch['Line'],
          item_number: ch['ItemNumber'],
          quantity: ch['Quantity'] }}
    end
  end
end

