module Zype
  module Helpers
    def home_directory
      running_on_windows? ? ENV['USERPROFILE'].gsub("\\","/") : ENV['HOME']
    end
    
    def running_on_windows?
      RUBY_PLATFORM =~ /mswin32|mingw32/
    end
    
    def echo_off
      with_tty do
        system "stty -echo"
      end
    end

    def echo_on
      with_tty do
        system "stty echo"
      end
    end
    
    def with_tty(&block)
      return unless $stdin.isatty
      begin
        yield
      rescue
        # fails on windows
      end
    end
    
    def ask
      $stdin.gets.to_s.strip
    end
    
    def ask_silent_on_windows
      require "Win32API"
      char = nil
      password = ''

      while char = Win32API.new("crtdll", "_getch", [ ], "L").Call do
        break if char == 10 || char == 13 # received carriage return or newline
        if char == 127 || char == 8 # backspace and delete
          password.slice!(-1, 1)
        else
          # windows might throw a -1 at us so make sure to handle RangeError
          (password << char.chr) rescue RangeError
        end
      end
      puts
      return password
    end

    def ask_silent
      echo_off
      password = ask
      puts
      echo_on
      return password
    end
  end
end