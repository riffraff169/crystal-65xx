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
OUTFILE="opcodes.cr"

File.open(INFILE)
