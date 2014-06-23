module Documents
  class PurchaseOrder
    attr_reader :name, :unit

  	def initialize(purchase_order, config)
  		@purchase_order = purchase_order
      @config         = config
      @po_number      = purchase_order['id']
      @unit           = purchase_order['business_unit']
      @name           = "#{@config['business_unit']}_PurchaseOrder_#{@po_number}_#{date_stamp}.xml"

  	end

  	def to_xml
  		builder = Nokogiri::XML::Builder.new do |xml|
        xml.PurchaseOrderMessage('xmlns'        => 'http://schemas.quietlogistics.com/V2/PurchaseOrder.xsd',
                                 'ClientID'     => @config['client_id'],
                                 'BusinessUnit' => @config['business_unit']) {

          xml.POHeader('Comments'     => @purchase_order['comments'],
                       'AltPoNumber'  => @purchase_order['alt_po_number'],
                       'PoNumber'     => @po_number,
                       'OrderDate'    => @purchase_order['arrival_date']) {

            xml.Vendor('ID'         => @purchase_order['vendor']['vendorid'],
                       'Company'    => @purchase_order['vendor']['name'],
                       'Address1'   => @purchase_order['vendor']['address1'],
                       'City'       => @purchase_order['vendor']['city'],
                       'Contact'    => @purchase_order['vendor']['contact'],
                       'State'      => @purchase_order['vendor']['state'],
                       'Country'    => @purchase_order['vendor']['country'],
                       'Email'      => @purchase_order['vendor']['email'],
                       'PostalCode' => @purchase_order['vendor']['postal_code'])
          }

          @purchase_order['line_items'].each do |line_item|

            xml.PODetails('Line'            => line_item['line_item_number'],
                          'ItemNumber'      => line_item["itemno"],
                          'ItemDescription' => line_item['description'],
                          'OrderQuantity'   => line_item['quantity'],
                          'UnitCost'        => line_item['unit_price'])
          end
        }
      end
      builder.to_xml
    end

    def message
      "Succesfully Sent Purchase Order to QL"
    end

    def date_stamp
      Time.now.strftime('%Y%m%d_%H%M%3N')
    end
  end
end
