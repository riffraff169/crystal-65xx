require "./enum.cr"

class Token
  property mode : Mode
  def initialize(@token : String)
  end
end
