module Documents
  class PurchaseOrderReceipt
    attr_reader :type

    def initialize(xml)
      @doc = Nokogiri::XML(xml).remove_namespaces!
      @type = :purchase_order
      @business_unit = @doc.xpath("//@BusinessUnit").first.text
      @po_number = @doc.xpath("//@PONumber").first.value
    end

    def to_h
      {
        id: @po_number,
        status: 'received',
        business_unit: @business_unit,
        items: assemble_items,
      }
    end

    private

    def assemble_items
      @doc.xpath('//PoLine').collect { |child|
          { line_number: child['Line'],
            itemno: child['ItemNumber'],
            quantity: child['ReceiveQuantity'],
            receivedate: child['ReceiveDate'] } }
    end
  end
end