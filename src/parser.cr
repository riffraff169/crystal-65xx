class Parser
  #@tokens = Array(String,String).new
  def initialize(@tokens : Array(Array(String|Int32)))
    #@tokens = tokens
    @tp = 0
  end

  def parse
    while @tp < @tokens.size
      puts "TOKEN: #{@tokens[@tp]}"
      @tp+=1
    end
  end
end
