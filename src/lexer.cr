require "string_scanner"
require "./aliases.cr"

class Lexer
  #reg = /(\$\d+)|(\w+)|("[^"]+")/
  def initialize
    @lineno = 0
  end
  def parse(text : String)
    lexemes = [] of Lexeme
    text.split(/\n/) do |line|
      @lineno+=1
      s = StringScanner.new(line)
      #puts "Lexer::LINE #{line}"
      skip_comment(s)
      skip_spaces(s)
      until s.eos?
        lexeme = check_lexeme(s)
        # comments aren't lexems
        unless lexeme[:type] == :comment
         lexemes << lexeme
        end
      end
      #puts "LEXEME: #{lexemes}"
    end
    lexemes
  end
  def skip_comment(s)
    s.scan(/;.*/)
  end
  def skip_spaces(s)
    s.scan(/\s*/)
  end
  def check_lexeme(s)
    skip_spaces(s)
    #if s.scan(/^$/)
    nextchar = s.peek(1)
    #lexeme = [] of Lexeme
    if nextchar == "."
      s.scan(/\.(\w+)/)
      lexeme = {:type => :pragma, :value => s[1], :line => @lineno}
    elsif nextchar == ","
      s.scan(/,/)
      lexeme = {:type => :comma, :value => ",", :line => @lineno}
    elsif nextchar == "<"
      s.scan(/</)
      lexeme = {:type => :lessthan, :value => "<", :line => @lineno}
    elsif nextchar == ">"
      s.scan(/>/)
      lexeme = {:type => :greaterthan, :value => ">", :line => @lineno}
    elsif nextchar == "#"
      s.scan(/#/)
      lexeme = {:type => :crosshatch, :value => "#", :line => @lineno}
    elsif nextchar == ":"
      s.scan(/:/)
      lexeme = {:type => :colon, :value => ":", :line => @lineno}
    elsif nextchar == "0"
      # octal
      #puts "Scanning octal"
      s.scan(/\d+/)
      lexeme = {:type => :number, :value => s[0].to_i(8), :line => @lineno}
    elsif s.check(/\w|_/)
      #puts "WORD"
      s.scan(/([\w_][\w\d_]*)/)
      lexeme = {:type => :word, :value => s[1], :line => @lineno}
    elsif s.check(/;/)
      # skip comment to end of line
      s.scan(/;.*/)
      lexeme = {:type => :comment, :value => ";", :line => @lineno}
    elsif s.check(/\$/)
      # hex
      s.scan(/\$([\dabcdefABCDEF]+)/)
      lexeme = {:type => :number, :value => s[1].to_i(16), :line => @lineno}
    elsif s.check(/%/)
      # binary
      s.scan(/%(\d+)/)
      lexeme = {:type => :number, :value => s[1].to_i(2), :line => @lineno}
    elsif s.check(/\d/)
      # decimal
      s.scan(/(\d+)/)
      lexeme = {:type => :number, :value => s[1].to_i, :line => @lineno}
    elsif nextchar == "\""
      #puts "Scanning string"
      s.scan(/"([^"]+)"/)
      lexeme = {:type => :string, :value => s[1], :line => @lineno}
    else
      #puts "LEXEME: #{nextchar}"
      s.scan(/./)
      lexeme = {:type => :char, :value => s[0], :line => @lineno}
    end
    lexeme
  end
end
