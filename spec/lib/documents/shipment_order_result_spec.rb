require 'spec_helper'

module Documents
  describe ShipmentOrderResult do

    xit 'should convert document to a shipment message' do
      xml = xml('T123456')
      message = ShipmentOrderResult.new(xml).to_message
      message[:messages].first[:message].should eq 'ql:shipment:confirm'
    end
  end
end
