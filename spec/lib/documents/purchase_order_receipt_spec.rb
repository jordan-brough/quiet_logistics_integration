require 'spec_helper'

module Documents
  describe PurchaseOrderReceipt do

    describe "#inspect" do
      xit 'should convert po document to a message' do
        xml = xml('123456')
        m = PurchaseOrderReceipt.new(xml).inspect
        m[:messages].first[:payload][:purchase_order][:items].count.should == 19
      end
    end
  end
end
