require 'ruby-units' # sudo gem install ruby-units
require 'erb'

class LinesSvg

  attr_accessor :margins,
                :overall_height,
                :overall_width,
                :line_height,
                :min_guide_height,
                :diag_guide_height,
                :diag_guide_spacing,
                :line_spacing,
                :guide_angle,
                :stroke

  def initialize()

    @margins = Unit.new("1in")
    @overall_height = Unit.new("11in")
    @overall_width = Unit.new("8.5in")
    @line_height = Unit.new("6mm")
    @line_spacing = @line_height * 0.5
    @min_guide_height = @line_height * 0.33
    @diag_guide_height = @min_guide_height
    @diag_guide_spacing = Unit.new("1in")
    @guide_angle = 52
    @stroke = Unit.new("0.15pt")

  end

  def to_svg

    guide_angle_rads = 52 / 180.0 * Math::PI
    guide_angle_x = diag_guide_height / Math.tan(guide_angle_rads)
    current_y = margins


    svg_template = %(<?xml version="1.0" standalone="no"?>
<svg width="<%= overall_width %>" height="<%= overall_height %>" version="1.1" xmlns="http://www.w3.org/2000/svg">

  <%
        while current_y + line_height < overall_height - margins
             line_top = current_y
             line_bottom = current_y + line_height
             a_height = line_bottom - min_guide_height
  %>

  <line x1="<%= margins %>" y1="<%= line_top %>" x2="<%= overall_width - margins %>" y2="<%= line_top %>" stroke="black" stroke-width="<%= stroke %>"/>
  <line x1="<%= margins %>" y1="<%= a_height %>" x2="<%= overall_width - margins %>" y2="<%= a_height %>" stroke="black" stroke-width="<%= stroke %>"/>
  <line x1="<%= margins %>" y1="<%= line_bottom %>" x2="<%= overall_width - margins %>" y2="<%= line_bottom %>" stroke="black" stroke-width="<%= stroke %>"/>

  <%
  current_x = margins
  while current_x + guide_angle_x < overall_width - margins
  %>

  <line x1="<%= current_x %>" y1="<%= line_bottom %>" x2="<%= current_x + guide_angle_x %>" y2="<%= line_bottom - diag_guide_height %>" stroke="black" stroke-width="<%= stroke %>"/>

  <% current_x = current_x + @diag_guide_spacing
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


# define "pt" length for line thickness
Unit.define("point") do |foobar|
  foobar.definition   = Unit.new("1 in") / 72
  foobar.aliases      = %w{pt}                   # array of synonyms for the unit
  foobar.display_name = "pt"                        # How unit is displayed when output
end


# bit of a hack.  This forces units to always be in inches and to
# never be fractional which messes with svg parse.
class RubyUnits::Unit

  alias_method :old_to_s, :to_s

  def to_s()
      "%0.4fin" % [ convert_to("in").scalar ]
  end
end
