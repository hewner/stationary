#!/usr/bin/env ruby

load 'lines_svg.rb'

lines = LinesSvg.new
lines.line_height = Unit.new("8mm")
lines.min_guide_height = lines.line_height / 4
lines.diag_guide_height = lines.line_height * 0.666
lines.diag_guide_spacing = Unit.new("0.5in")
File.write('/tmp/tmpsvg.svg', lines.to_svg)
system('rsvg-convert -f pdf -o /tmp/tmpsvg.pdf /tmp/tmpsvg.svg')
system('qpdf -empty --pages /tmp/tmpsvg.pdf /tmp/tmpsvg.pdf -- output.pdf')
puts "wrote output.pdf"
