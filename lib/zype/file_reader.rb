module Zype
  class FileReader
    attr_reader :current

    def initialize(data, &block)
      if data.respond_to? :read
        @file = data
      end

      @block = block
    end

    def read(*args)
      if @file
        chunk = @file.read(*args)
        @block.call(self) if @block
        chunk
      end
    end

    def pos
      @file.pos
    end

    def eof!
      @file.eof!
    end

    def eof?
      @file.eof?
    end

    def size
      @file.size
    end

    def size_left
      @file.size - pos
    end
  end
end
