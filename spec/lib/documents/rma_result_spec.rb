require 'spec_helper'

module Documents
  describe RMAResult do

    describe '#to_message' do
      it 'should add timestamp to id' do
        xml = '<?xml version="1.0" encoding="utf-8"?><RMAResultDocument
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns="http://schemas.quietlogistics.com/V2/RMAResultDocument.xsd"><RMAResult RMANumber="1234" OrderNumber="1234" ReceiptDate="" Warehouse="" BusinessUnit=""/>
               </RMAResult></RMAResultDocument>'

        expect_any_instance_of(Time).to receive("strftime").and_return("20140722132344642")
        h = described_class.new(xml).to_h
        expect(h[:id]).to eq "1234-20140722132344642"
      end
    end
  end
end