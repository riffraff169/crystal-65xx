require "string_scanner"
require "./aliases.cr"

class Lexer
  #reg = /(\$\d+)|(\w+)|("[^"]+")/
  def initialize
    @lineno = 0
  end
  def parse(text : String)
    lexemes = [] of Token
    text.split(/\n/) do |line|
      @lineno+=1
      s = StringScanner.new(line)
      #puts "Lexer::LINE #{line}"
      skip_comment(s)
      skip_spaces(s)
      until s.eos?
        lexeme = check_lexeme(s)
        # comments aren't lexemes
        case { lexeme, lexeme.value }
        when {OpToken, ";"} then
          # skip
        else
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
    nextchar = s.peek(1)
    if nextchar == "."
      s.scan(/\.(\w+)/)
      lexeme = PragmaToken.new line: @lineno, value: s[1]
    elsif nextchar == ","
      s.scan(/,/)
      lexeme = OpToken.new line: @lineno, value: ","
    elsif nextchar == "<"
      if s.scan(/<</)
        lexeme = OpToken.new line: @lineno, value: "<<"
      else
        s.scan(/</)
        lexeme = OpToken.new line: @lineno, value: "<"
      end
    elsif nextchar == ">"
      if s.scan(/>>/)
        lexeme = OpToken.new line: @lineno, value: ">>"
      else
        s.scan(/>/)
        lexeme = OpToken.new line: @lineno, value: ">"
      end
    elsif nextchar == "#"
      s.scan(/#/)
      lexeme = OpToken.new line: @lineno, value: "#"
    elsif nextchar == ":"
      s.scan(/:/)
      lexeme = OpToken.new line: @lineno, value: ":"
    elsif nextchar == "&"
      s.scan(/&/)
      lexeme = OpToken.new line: @lineno, value: "&"
    elsif nextchar == "|"
      s.scan(/|/)
      lexeme = OpToken.new line: @lineno, value: "|"
    elsif nextchar == "["
      s.scan(/\[/)
      lexeme = OpToken.new line: @lineno, value: "["
    elsif nextchar == "]"
      s.scan(/\]/)
      lexeme = OpToken.new line: @lineno, value: "]"
    elsif nextchar == "("
      s.scan(/\(/)
      lexeme = OpToken.new line: @lineno, value: "("
    elsif nextchar == ")"
      s.scan(/\)/)
      lexeme = OpToken.new line: @lineno, value: ")"
    elsif nextchar == "*"
      s.scan(/\*/)
      lexeme = OpToken.new line: @lineno, value: "*"
    elsif nextchar == "+"
      s.scan(/\+/)
      lexeme = OpToken.new line: @lineno, value: "+"
    elsif nextchar == "/"
      s.scan(/\//)
      lexeme = OpToken.new line: @lineno, value: "/"
    elsif nextchar == "-"
      s.scan(/-/)
      lexeme = OpToken.new line: @lineno, value: "-"
    elsif nextchar == "^"
      s.scan(/^/)
      lexeme = OpToken.new line: @lineno, value: "^"
    elsif nextchar == "'"
      s.scan(/'/)
      lexeme = OpToken.new line: @lineno, value: "'"
    elsif nextchar == "0"
      # octal
      #puts "Scanning octal"
      s.scan(/\d+/)
      lexeme = NumberToken.new line: @lineno, value: s[0].to_i(8)
    elsif s.check(/\w|_/)
      #puts "WORD"
      s.scan(/([\w_][\w\d_]*)/)
      lexeme = WordToken.new line: @lineno, value: s[1]
    elsif s.check(/;/)
      # skip comment to end of line
      s.scan(/;.*/)
      lexeme = OpToken.new line: @lineno, value: ";"
    elsif s.check(/\$/)
      # hex
      s.scan(/\$([\dabcdefABCDEF]+)/)
      lexeme = NumberToken.new line: @lineno, value: s[1].to_i(16)
    elsif s.check(/%/)
      # binary
      s.scan(/%(\d+)/)
      lexeme = NumberToken.new line: @lineno, value: s[1].to_i(2)
    elsif s.check(/\d/)
      # decimal
      s.scan(/(\d+)/)
      lexeme = NumberToken.new line: @lineno, value: s[1].to_i
    elsif nextchar == "\""
      #puts "Scanning string"
      s.scan(/"([^"]+)"/)
      lexeme = StringToken.new line: @lineno, value: s[1]
    else
      #puts "LEXEME: #{nextchar}"
      s.scan(/./)
      lexeme = CharToken.new line: @lineno, value: s[0]
    end
    lexeme
  end
end
