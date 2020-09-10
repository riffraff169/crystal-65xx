#!/usr/bin/env crystal
require "./enum.cr"

modemap = {
  "Implied": Mode::Implied,
  "Immediate": Mode::Immediate,
  "ImmediateLong": Mode::ImmediateLong,
  "Zero Page": Mode::Zero_Page,
  "Zero Page, X": Mode::Zero_Page_X,
  "Zero Page, Y": Mode::Zero_Page_Y,
  "Absolute": Mode::Absolute,
  "Absolute, X": Mode::Absolute_X,
  "Absolute, Y": Mode::Absolute_Y,
  "(Absolute)": Mode::Absolute_,
  "(Absolute, X)": Mode::Absolute_X_,
  "(Absolute), Y": Mode::Absolute__Y,
  "(Absolute), Z": Mode::Absolute__Z,
  "(Zero Page)": Mode::Zero_Page_,
  "(Zero Page, X)": Mode::Zero_Page_X_,
  "(Zero Page), Y": Mode::Zero_Page__Y,
  "(Zero Page, SP), Y": Mode::Zero_Page_SP__Y,
  "(Zero Page), Z": Mode::Zero_Page__Z,
  "Relative": Mode::Relative,
  "RelativeLong": Mode::RelativeLong,
  "Zero Page, Relative": Mode::Zero_Page_Relative
}

INFILE="op6502.txt"

header = <<-EOF
module Opcodes6502
EOF
footer = <<-EOF
end
EOF

opcodes = Hash(String, Array(Int32)).new { |h, k| h[k] = Array(Int32).new(modemap.size,-1) }

puts header
File.open(INFILE) do |infile|
  infile.each_line do |line|
    data = line.match(/^(?<code>..):\s*(?<desc>.*)$/).not_nil!
    code = data["code"]
    desc = data["desc"]
    oplist = desc.split(/;/)
    oplist.each do |opitem|
      unless opitem.match(/^$/)
        opinfo = opitem.match(/\s*(?<op1>[\w\.]+)\s+-\s+(?<mode1>.+)/).not_nil!
        op1 = opinfo["op1"]
        mode1 = opinfo["mode1"]
        opcodes[op1.downcase][modemap[mode1].to_i] = code.to_i(16)
      end
    end
  end
  puts "  Opcodes6502 = {"
  str = opcodes.keys.sort.join(",\n") do |opcode|
    "      \"" + opcode + "\" => [" + opcodes[opcode].join(", ") do |val|
      val < 0 ? val : "0x" + val.to_s(16)
    end + "]"
  end
  puts str
  puts "  }"
end
puts footer
