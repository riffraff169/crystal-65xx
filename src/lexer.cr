require "string_scanner"
require "./aliases.cr"

class Lexer
  #reg = /(\$\d+)|(\w+)|("[^"]+")/
  def initialize
    @lineno = 0
  end
  def parse(text : String)
    tokens = [] of Token
    text.split(/\n/) do |line|
      @lineno+=1
      s = StringScanner.new(line)
      #puts "Lexer::LINE #{line}"
      skip_comment(s)
      skip_spaces(s)
      until s.eos?
        token = check_token(s)
        #puts "TOK: #{token}"
        # comments aren't tokens
        unless token[:type] == :comment
          tokens << token
        end
      end
      #puts "TOKENS: #{tokens}"
    end
    tokens
  end
  def skip_comment(s)
    s.scan(/;.*/)
  end
  def skip_spaces(s)
    s.scan(/\s*/)
  end
  def check_token(s)
    skip_spaces(s)
    #if s.scan(/^$/)
    nextchar = s.peek(1)
    #token = [] of Token
    if nextchar == "."
      s.scan(/\.(\w+)/)
      token = {:type => :pragma, :value => s[1], :line => @lineno}
    elsif nextchar == ","
      s.scan(/,/)
      token = {:type => :comma, :value => ",", :line => @lineno}
    elsif nextchar == "<"
      s.scan(/</)
      token = {:type => :lessthan, :value => "<", :line => @lineno}
    elsif nextchar == ">"
      s.scan(/>/)
      token = {:type => :greaterthan, :value => ">", :line => @lineno}
    elsif nextchar == "#"
      s.scan(/#/)
      token = {:type => :crosshatch, :value => "#", :line => @lineno}
    elsif nextchar == ":"
      s.scan(/:/)
      token = {:type => :colon, :value => ":", :line => @lineno}
    elsif nextchar == "0"
      # octal
      #puts "Scanning octal"
      s.scan(/\d+/)
      token = {:type => :number, :value => s[0].to_i(8), :line => @lineno}
    elsif s.check(/\w|_/)
      #puts "WORD"
      s.scan(/([\w_][\w\d_]*)/)
      token = {:type => :word, :value => s[1], :line => @lineno}
    elsif s.check(/;/)
      # skip comment to end of line
      s.scan(/;.*/)
      token = {:type => :comment, :value => ";", :line => @lineno}
    elsif s.check(/\$/)
      # hex
      s.scan(/\$([\dabcdefABCDEF]+)/)
      token = {:type => :number, :value => s[1].to_i(16), :line => @lineno}
    elsif s.check(/%/)
      # binary
      s.scan(/%(\d+)/)
      token = {:type => :number, :value => s[1].to_i(2), :line => @lineno}
    elsif s.check(/\d/)
      # decimal
      s.scan(/(\d+)/)
      token = {:type => :number, :value => s[1].to_i, :line => @lineno}
    elsif nextchar == "\""
      #puts "Scanning string"
      s.scan(/"([^"]+)"/)
      token = {:type => :string, :value => s[1], :line => @lineno}
    else
      #puts "TOKEN: #{nextchar}"
      s.scan(/./)
      token = {:type => :char, :value => s[0], :line => @lineno}
    end
    token
  end
end
