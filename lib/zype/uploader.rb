require 'aws-sdk'
require 'zype/file_reader'

module Zype
  class Uploader
    CHUNK_SIZE = 5 * 1024 * 1024
    PART_SIZE = 5 * 1024 * 1024
    MULTIPART_MINIMUM = 10 * 1024 * 1024 # 10 MB

    def initialize(client)
      @client = client

      init_aws_client
    end

    def init_aws_client
      account = @client.account

      @aws = AWS::S3.new(
        access_key_id: account.upload_key,
        secret_access_key: account.upload_secret
      )
    end

    def process(upload,file)
      progress_bar = Zype::ProgressBar.new(upload["filename"], file.size)

      file = Zype::FileReader.new(file) do |reader|
        progress_bar.set(reader.pos)
      end

      uri = URI.parse(upload.path)

      bucket = @aws.buckets[upload.bucket]
      object = bucket.objects[upload.path]

      object.write(file, :multipart_min_part_size => MULTIPART_MINIMUM)
    end
  end
end
