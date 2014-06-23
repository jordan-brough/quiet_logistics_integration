require 'spec_helper'

describe EventMessage do

  it 'converts to xml' do
    xml = EventMessage.new('ShipmentOrder', 'test.xml', '').to_xml
    xml.should match /EventMessage/
  end
end
