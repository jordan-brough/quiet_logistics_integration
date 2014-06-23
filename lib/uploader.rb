class Uploader
  def initialize(bucket)
    @bucket = bucket
  end

  def process(name, xml)
    file = StringIO.new(xml)
    upload(name, file)
  end

  private
  def upload(name, file)
    s3 = AWS::S3.new
    bucket = s3.buckets[@bucket]

    s3_object = bucket.objects[name]
    s3_object.write(:file => file)

    s3_object.url_for(:read)
  end
end