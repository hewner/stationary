require 'erb'
simple_template = "Value of x is: is <%= x %>."
x = 400
renderer = ERB.new(simple_template)
puts output = renderer.result(binding)
