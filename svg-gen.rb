require 'ruby-units' # sudo gem install ruby-units
require 'erb'

RubyUnits.configure do |config|
  config.separator = false
end

class Lines

  attr_accessor :overall_height, :overall_width, :line_height, :line_spacing, :guide_angle, :stroke

  def initialize()

    @overall_height = Unit.new("6.5in")
    @overall_width = Unit.new("6.5in")
    @line_height = Unit.new("6mm")
    @line_spacing = @line_height * 0.5
    @guide_angle = 52
    @stroke = Unit.new("0.1pt")

  end

  def to_svg

    guide_angle_rads = 52 / 180.0 * Math::PI
    guide_angle_x = (@line_height * 0.333 / Math.tan(guide_angle_rads)) * 1.0
    current_y = Unit.new("0mm")


    svg_template = %(<?xml version="1.0" standalone="no"?>
<svg width="6.5in" height="<%= overall_height %>" version="1.1" xmlns="http://www.w3.org/2000/svg">

  <%
        while current_y + line_height < overall_height
             line_top = current_y
             line_bottom = current_y + line_height
             a_height = line_bottom - 0.333 * line_height
  %>

  <line x1="0" y1="<%= line_top %>" x2="<%= overall_width %>" y2="<%= line_top %>" stroke="black" stroke-width="<%= stroke %>"/>
  <line x1="0" y1="<%= a_height %>" x2="<%= overall_width %>" y2="<%= a_height %>" stroke="black" stroke-width="<%= stroke %>"/>
  <line x1="0" y1="<%= line_bottom %>" x2="<%= overall_width %>" y2="<%= line_bottom %>" stroke="black" stroke-width="<%= stroke %>"/>

  <%
  current_x = Unit.new("0mm")
  while current_x + guide_angle_x < overall_width
  %>

  <line x1="<%= current_x %>" y1="<%= line_bottom %>" x2="<%= current_x + guide_angle_x %>" y2="<%= a_height %>" stroke="black" stroke-width="<%= stroke %>"/>

  <% current_x = current_x + guide_angle_x * 4 # dont space them too close
     end %>

  <%
     current_y = current_y + line_height + line_spacing

     end
     %>

</svg>
)

    renderer = ERB.new(svg_template)
    return renderer.result(binding)
  end
end

lines = Lines.new
puts lines.to_svg
