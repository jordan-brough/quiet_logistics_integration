require 'spec_helper'

module Documents
  describe RMA do

    describe '#to_xml' do
      it 'should convert to rma document' do
        shipment = Factories.shipment
        doc = RMA.new(shipment, {})
        xml = Nokogiri::XML(doc.to_xml)
        xsd = Nokogiri::XML::Schema(File.read('./spec/schemas/rma.xsd'))

        errors = xsd.validate(xml).collect { |error| error }

        expect(doc.name).to match /^RMA_#{shipment['id']}_/
        expect(errors).to eq []
      end
    end
  end
end