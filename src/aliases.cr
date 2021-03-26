
abstract struct Token
  getter line : Int32

  def initialize(@line : Int32); end
end

struct NumberToken < Token
  getter value : Int32

  def initialize(@value : Int32, line : Int32)
    super line
  end
end

struct WordToken < Token
  getter value : String

  def initialize(@value : String, line : Int32)
    super line
  end
end

struct OpToken < Token
  getter value : String

  def initialize(@value : String, line : Int32)
    super line
  end
end

struct PragmaToken < Token
  getter value : String

  def initialize(@value : String, line : Int32)
    super line
  end
end

struct StringToken < Token
  getter value : String

  def initialize(@value : String, line : Int32)
    super line
  end
end

struct CharToken < Token
  getter value : String

  def initialize(@value : String, line : Int32)
    super line
  end
end
