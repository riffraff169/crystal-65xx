require "./aliases.cr"
class Parser
  #@tokens = Array(String,String).new
  def initialize(@tokens : Array(Token))
    #@tokens = tokens
    @tp = 0
  end

  def parse
    @tokens.each do |tok|
      puts "TOKEN: #{tok}"
      @tp+=1
    end

    #while @tp < @tokens.size
    #  puts "TOKEN: #{@tokens[@tp]}"
    #  @tp+=1
    #end
  end
end
