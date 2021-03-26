#!/usr/bin/env crystal
require "option_parser"
require "./aliases.cr"
require "./lexer.cr"
require "./parser.cr"

filename = "input.c65"
outfile = "out.prg"
OptionParser.parse do |parser|
  parser.banner = "Usage: compile65xx -f filename"
  parser.on("-f FILE", "--filename FILE", "Source file") { |name| filename = name }
  parser.on("-o FILE", "--out FILE", "Output file") { |name| outfile = name }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

lexer = Lexer.new
lexemes = [] of Token
File.open(filename) do |file|
  lexemes = lexer.parse(file.gets_to_end)
end
#puts lexemes.class
#lexemes.each do |lex|
  #puts lex.class
  #puts lex.keys
  #puts "LEXEME: #{lex[:type]}"
#end
#puts lexemes

parser = Parser.new(lexemes)
parser.parse
