local class = require('lib.middleclass')
local Component = require('src.engine.component.Component')

local SpriteRenderer = class('SpriteRenderer', Component)
function SpriteRenderer:initialize(animations, startingAnimName)
    Component.initialize(self)
    -- maintain a transform object to calculate where to draw
    self.transform = love.math.newTransform()
    
    self.animations = {}
    for i, animation in pairs(animations) do
        self.animations[animation.name] = animation
    end
    self:setCurrentAnimation(startingAnimName)

    -- time counter used to update animation 
    self.currentTime = 0
end

function SpriteRenderer:draw()
    -- calculate the entity's combined transformation 
    self.transform:reset()
    self.entity:getTransform(self.transform)
    -- draw the frame
    if self.currentAnim == nil then
        return
    end
    
    local frameNum = math.floor(self.currentTime / self.currentAnim.length * self.currentAnim.numFrames) + 1
    love.graphics.draw(self.currentAnim.image, self.currentAnim.frames[frameNum], self.transform)
end

function SpriteRenderer:update(dt)
  --update animationtimer reset once reaches duration
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.currentAnim.length then
        self.currentTime = self.currentTime - self.currentAnim.length
    end
end

function SpriteRenderer:setCurrentAnimation(animName)
    self.currentAnim = self.animations[animName]
end

return SpriteRenderer
