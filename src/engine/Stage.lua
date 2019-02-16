local class = require('lib.middleclass')
local struct = require('src.common.struct')
local Entity = require('src.engine.Entity')

---------------------------------
-- Stage: container for entities.
---------------------------------

local Stage = class('Stage')

function Stage:initialize()
    -- map of eid[num] -> entity[Entity] for all entities in the stage
    self.entities = {}
    -- dummy entity acting as the root of the entity hierarchy
    self.rootEntity = Entity:new({})
    self.rootEntity.stage = self
    self.addEntityQueue = struct.Queue:new()
    self.removeEntityQueue = struct.Queue:new()
    self.world = love.physics.newWorld(0, 0, true)
end

function Stage:update()
    -- get delta time
    dt = love.timer.getDelta()

    -- process all current entities
    self.rootEntity:updateChildren(dt)

    -- add entities that have been queued up
    while not self.addEntityQueue:empty() do
        e = self.addEntityQueue:dequeue()
        self.entities[e.id] = e
        e.parent.children[e.id] = e
    end

    -- remove entities that have been queued up
    while not self.removeEntityQueue:empty() do
        e = self.removeEntityQueue:dequeue()
        self.entities[e.id] = nil
        e.parent.children[e.id] = nil
    end

    self.world:update(dt)
end

function Stage:draw()
    for eid, entity in pairs(self.entities) do
        entity:draw()
    end
end

function Stage:addEntity(entity)
    entity.stage = self;
    if entity.parent == nil then
        entity.parent = self.rootEntity
    end

    self.addEntityQueue:enqueue(entity)
end

function Stage:removeEntity(entity)
    self.removeEntityQueue:enqueue(entity)
end

-- exports
return Stage