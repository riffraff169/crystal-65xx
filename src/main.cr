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
tokens = [] of Token
File.open(filename) do |file|
  tokens = lexer.parse(file.gets_to_end)
end
#puts tokens.class
tokens.each do |tok|
  #puts tok.class
  #puts tok.keys
  puts "TOKEN: #{tok[:type]}"
end
#puts tokens

parser = Parser.new(tokens)
parser.parse
