require "string_scanner"

class Lexer
  #reg = /(\$\d+)|(\w+)|("[^"]+")/
  def parse(text : String)
    tokens = [] of Array(String|Int32)
    text.split(/\n/) do |line|
      s = StringScanner.new(line)
      #puts "Lexer::LINE #{line}"
      skip_comment(s)
      skip_spaces(s)
      until s.eos?
        token = check_token(s)
        #puts "TOK: #{token}"
        tokens << token
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
    #puts "NEXTCHAR: #{nextchar}"
    if nextchar == "."
      s.scan(/\.(\w+)/)
      token = ["PRAGMA",s[1]]
    elsif nextchar == ","
      s.scan(/,/)
      token = ["COMMA",","]
    elsif nextchar == "<"
      s.scan(/</)
      token = ["LESSTHAN","<"]
    elsif nextchar == ">"
      s.scan(/>/)
      token = ["GREATERTHAN",">"]
    elsif nextchar == "#"
      s.scan(/#/)
      token = ["CROSSHATCH","#"]
    elsif nextchar == ":"
      s.scan(/:/)
      token = ["COLON",":"]
    elsif nextchar == "0"
      # octal
      #puts "Scanning octal"
      s.scan(/\d+/)
      token = ["VAL",s[0].to_i(8)]
    elsif s.check(/\w|_/)
      #puts "WORD"
      s.scan(/([\w_][\w\d_]*)/)
      token = ["WORD",s[1]]
    elsif s.check(/;/)
      # skip comment to end of line
      s.scan(/;.*/)
    elsif s.check(/\$/)
      # hex
      s.scan(/\$([\dabcdefABCDEF]+)/)
      token = ["VAL",s[1].to_i(16)]
    elsif s.check(/%/)
      # binary
      s.scan(/%(\d+)/)
      token = ["VAL",s[1].to_i(2)]
    elsif s.check(/\d/)
      # decimal
      s.scan(/(\d+)/)
      token = ["VAL",s[1].to_i]
    elsif nextchar == "\""
      #puts "Scanning string"
      s.scan(/"([^"]+)"/)
      token = ["STRING",s[1]]
    else
      #puts "TOKEN: #{nextchar}"
      s.scan(/./)
      token = ["CHAR",s[0]]
    end
    token||["NONE","NONE"]
  end
end
