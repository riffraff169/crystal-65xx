require "./aliases.cr"
require "./opcodes6502.cr"

class Parser
  include Opcodes6502
  def initialize(@lexemes : Array(Lexeme))
    @lp = 0
  end

  def parse
    @lexemes.each do |lex|
      puts "LEXEME: #{lex}"
      @lp+=1
    end

    #while @tp < @tokens.size
    #  puts "TOKEN: #{@tokens[@tp]}"
    #  @tp+=1
    #end
  end
end
