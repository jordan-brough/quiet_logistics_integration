require 'spec_helper'

module Documents
  describe PurchaseOrder do
    let(:purchase_order) { Factories.purchase_order }

    subject { PurchaseOrder.new(purchase_order) }

    describe "#to_xml" do
      xit "should respond convert to xml doc" do
        xml = subject.to_xml
        xml.include?('<PurchaseOrderMessage').should eq true
      end
    end
  end
end