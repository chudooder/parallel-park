local class = require('lib.middleclass')
local Resources = require('src.engine.Resources')
local Entity = require('src.engine.Entity')
local Component = require('src.engine.component.Component')
local SpriteRenderer = require('src.engine.component.SpriteRenderer')
local SpriteSheet = require('src.engine.render.SpriteSheet')

-- Subclasses of entities are intended to be used as convenient ways
-- to create certain arrangements of components, and not as a way
-- to define new behavior directly.

local TestEntity = class('TestEntity', Entity)

-- As we are using components to define entity behavior, we do NOT 
-- override Entity.update or Entity.draw. Instead, we can
-- define a component here and add it in this class's initializer.

local Spinner = class('Spinner', Component)
function Spinner:update(dt)
    self.entity.localTransform:rotate(dt * 3.14159 * 0.01)
end

local Mover = class('Mover', Component)
function Mover:update(dt)
    self.entity.localTransform:translate(10 * dt, 0)
end

function TestEntity:initialize(arg)
    Entity.initialize(self, arg)
    self.text = "Hello world!"

    -- add components
    local tankSheet = Resources:loadSpriteSheet('res/tank')
    local sr = SpriteRenderer:new(
            {tankSheet:getAnimation('tank-right')},
            'tank-right')
    
    local spinner = Spinner:new()
    local mover = Mover:new()

    self:addComponent(sr)
    self:addComponent(spinner)
    self:addComponent(mover)
end


-- exports
return TestEntity
