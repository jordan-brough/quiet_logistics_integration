class Downloader
  def initialize(bucket)
    @bucket = bucket
  end

  def download(file_name)
    s3 = AWS::S3.new
    bucket = s3.buckets[@bucket]
    object = bucket.objects[file_name]

    buffer = StringIO.new("", 'w')
    object.read do |chunk|
      buffer << chunk
    end
    buffer.close

    buffer.string
  end

  def delete_file(name)
    s3 = AWS::S3.new
    bucket = s3.buckets[@bucket]
    object = bucket.objects[name]
    object.delete

    return !object.exists?
  end
end
