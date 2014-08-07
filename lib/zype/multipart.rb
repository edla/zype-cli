require 'aws-sdk'
require 'thread'
require 'thwait'
require 'pry'

module Zype
  class Multipart
    CHUNK_SIZE = 5 * 1024 * 1024
    PART_SIZE = 5 * 1024 * 1024
    MULTIPART_MINIMUM = 10 * 1024 * 1024 # 10 MB

    def initialize(upload, file)
      @upload = upload

      @progress_bar = Zype::ProgressBar.new(@upload["filename"], file.size)

      @file = Zype::FileReader.new(file) do |reader|
        @progress_bar.set(reader.pos)
      end

      @threads = []
    end

    def process
      uri = URI.parse(@upload["path"])

      s3 = AWS::S3.new(
        access_key_id: 'AKIAJ7HUL5YSUMT7BU7Q',
        secret_access_key: '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'
      )

      bucket = s3.buckets[@upload["bucket"]]
      object = bucket.objects[@upload["path"]]

      if use_multipart?
        write_with_multipart(object)
      else
        write_with_single_request(object)
      end
    end

    def write_with_multipart(object)

      # parts_number = (@file.size.to_f / PART_SIZE).ceil.to_i
      current_part = 0

      progress = 0.0
      last_check_in = Time.now


      object.multipart_upload do |multipart|
        until @file.eof?
          buffer = ''
          while buffer.size < PART_SIZE && !@file.eof?
            buffer << @file.read([CHUNK_SIZE, @file.size_left].min)
          end
          upload_part(multipart,buffer)
        end

        ThreadsWait.all_waits(*@threads)
      end
    end

    def upload_part(multipart,buffer)
      multipart.add_part(buffer, :async => true)
    end

    def write_with_single_request(object)
      object.write(@file, :single_request => true)
    end

    def use_multipart?
      @file.size > MULTIPART_MINIMUM
    end
  end
end
