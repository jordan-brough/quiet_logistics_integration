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

  end
end

