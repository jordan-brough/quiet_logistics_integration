module Messages
  class InventoryEventMessage
    attr_reader :type

    def initialize(doc, id)
      @id               = id
      @type             = 'InventoryEventMessage'
      @quantity         = doc.xpath("//@DeltaQuantity").first.text
      @item_number      = doc.xpath("//@ItemNumber").first.text
      @reason           = doc.xpath("//@ReasonCode").first.text
      @reference_number = doc.xpath("//@EventId").first.text
      @transaction_date = doc.xpath("//@EventTime").first.text
      @event_type       = doc.xpath("//@EventType").first.text
      @business_unit    = doc.xpath("//@BusinessUnit").first.text
    end

    def to_h
      {
        id: @id,
        document_type: @type,
        business_unit: @business_unit,
        inventory_transaction_quantity: @quantity,
        event_type: @event_type,
        item_number: @item_number,
        inventory_transaction_reason: @reason,
        reference_number: @reference_number,
        inventory_transaction_date: @transaction_date
      }
    end
  end
end