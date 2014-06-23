require 'spec_helper'

describe Processor do

  subject { Processor.new('text.xml', 'ShipmentOrderResult', 'test-from-ql-2') }

  it 'should return a valid document message' do

  end

  it 'should stuff' do
    # downloader = double('Downloader')
    # downloader.should_receive(:download).and_raise(AWS::S3::Errors::NoSuchKey)
    # res = subject.process_doc
    # binding.pry
  end
end