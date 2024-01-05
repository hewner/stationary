local base = require("packages.base")
local package = pl.class(base)
package._name = "mypkg"
function package:_init (options)
-- Things you might want to do before the parent initialization.
base._init(self)
-- Things you might want to do after the parent initialization.
end
-- Additional methods will later come here.

function package:registerCommands ()
   -- Our own commands here
  self:registerCommand("hrule", function (options, _)
    local width = SU.cast("length", options.width)
    local height = SU.cast("length", options.height)
    local depth = SU.cast("length", options.depth)
    SILE.typesetter:pushHbox({
      width = width:absolute(),
      height = height:absolute(),
      depth = depth:absolute(),
      value = options.src,
      outputYourself = function (node, typesetter, line)
        local outputWidth = SU.rationWidth(node.width, node.width, line.ratio)
        typesetter.frame:advancePageDirection(-node.height)
        local oldx = typesetter.frame.state.cursorX
        local oldy = typesetter.frame.state.cursorY
        typesetter.frame:advanceWritingDirection(outputWidth)
        typesetter.frame:advancePageDirection(node.height + node.depth)
        local newx = typesetter.frame.state.cursorX
        local newy = typesetter.frame.state.cursorY
        SILE.outputter:drawRule(oldx, oldy, newx - oldx, newy - oldy)
        typesetter.frame:advancePageDirection(-node.depth)
      end
    })
  end, "Draws a blob of ink of width <width>, height <height> and depth <depth>")
   
end

package.documentation = [[
\begin{document}
...
\end{document}
]]
return package
