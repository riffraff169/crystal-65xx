#!/usr/bin/env crystal
require "./lexer.cr"
require "./parser.cr"

lexer = Lexer.new
tokens = [] of Array(String|Int32)
File.open("hello1.c6") do |file|
  tokens += lexer.parse(file.gets_to_end)
end
#puts tokens

parser = Parser.new(tokens)
parser.parse
