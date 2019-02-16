local class = require('lib.middleclass')

-------------------------------------------
-- Entity: base class for all game objects.
-- essentially a container for components.
-------------------------------------------

local Entity = class('Entity')

Entity.static.ID_COUNTER = 0
function Entity.static:getId()
    local val = Entity.static.ID_COUNTER
    Entity.static.ID_COUNTER = Entity.static.ID_COUNTER + 1
    return val
end

function Entity:initialize(arg)
    -- unique identifier for this entity
    self.id = Entity.getId()
    -- reference stage this entity is in
    self.stage = nil
    -- entity's parent, and therefore parent coordinate system
    self.parent = arg.parent or nil
    -- table of entity's children
    self.children = {}
    -- entity transform (position, rotation, scale) in local coordinates
    self.localTransform = love.math.newTransform(
        arg.x or 0,
        arg.y or 0,
        arg.angle or 0,
        arg.sx or 1,
        arg.sy or 1)

    -- list of this entity's components
    self.components = {}

    -- za warudo
    self.world = love.physics.newWorld(0, 0, true)
end

-- called by containing Stage to update objects recursively
function Entity:updateChildren(dt)
    for eid, child in pairs(self.children) do
        child:update(dt)
        child:updateChildren(dt)
    end
end

-- call each component's update method
--  dt [number] time delta in seconds since last frame
function Entity:update(dt)
    for name, component in pairs(self.components) do
        component:update(dt)
    end
end

function Entity:draw()
    for name, component in pairs(self.components) do
        component:draw()
    end
end

-- converts an x, y position in local space to world space
function Entity:localToWorld(x, y)
    if self.parent == nil then
        return x, y
    end
    return self.parent:localToWorld(self.localTransform:transformPoint(x, y))
end

-- converts an x, y position in world space to local space
function Entity:worldToLocal(x, y)
    if self.parent == nil then
        return x, y
    end
    return self.localTransform:inverseTransformPoint(self.parent:worldToLocal(x, y))
end

function Entity:getTransform(transform)
    if self.parent == nil then
        return
    end
    self.parent:getTransform(transform)
    transform:apply(self.localTransform)
end

-- Component manipulation

function Entity:addComponent(component)
    component.entity = self
    local name = component.class.name
    self.components[name] = component
end

function Entity:removeComponent(component)
    local name = component.class.name
    self.components[name] = nil
end

-- exports
return Entity