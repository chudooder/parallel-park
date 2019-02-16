local class = require('lib.middleclass')

local Component = class('Component')

function Component:initialize()
    self.entity = nil
    self.enabled = true
end

-- custom components should subclass Component and implement these methods.
function Component:update(dt)
end

function Component:draw()
end

return Component