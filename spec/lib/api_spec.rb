require 'spec_helper'

describe Api do

  it 'sends shipment order transfer to QL' do
    Uploader.any_instance.stub(:process)
    Sender.any_instance.stub(:send_message)

    message = Api.send_document('ShipmentOrder', Factories.shipment, 'test', 'test', {})
    expect(message).to eq "Succesfully Sent Shipment 12836 to Quiet Logistics"
  end

  xit 'send purchase order to QL' do
    message =  Api.send_document('PurchaseOrder', Factories.purchase_order, 'test', 'test')
    message[:messages].first[:message].should eq "purchase_order:transmit"
  end

  xit 'sends item profile document/message to QL' do
    message = Api.send_document('ItemProfile', Factories.item, 'test', 'test')
  end

  xit 'sends purchase order transfer to QL' do
      message = Api.send_document('PurchaseOrder', Factories.to_purchase_order, 'test', 'test')
      message[:messages].first[:message].should eq "purchase_order:transmit"
  end

  xit 'sends rma doc to QL' do
    Uploader.any_instance.stub(:process)
    Sender.any_instance.stub(:send_message)

    message = Api.send_document('RMADocument', Factories.shipment, 'test', 'test')
    expected = { "notifications"=> [{:level=>"info", :subject=>"RMA Document Successfuly Sent", :description=>"SQS Id:  S3 url: "}]}

    expect(message).to eq expected
  end
end