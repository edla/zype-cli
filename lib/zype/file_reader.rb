module Zype
  class FileReader
    attr_reader :current
    
    def initialize(data, chunk_size, &block)
      @size = chunk_size
      if data.respond_to? :read
        @file = data
      end
    
      @block = block
      @current = 0
    end
  
    def read(foo)
      if @file
        @block.call(self) if @block
        if chunk = @file.read(@size)
          @current += chunk.size
        end
        chunk
      end
    end
    def eof!
      @file.eof!
    end
    def eof?
      @file.eof?
    end
  end
end