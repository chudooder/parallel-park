local class = require('lib.middleclass')
local json = require('lib.json')
local Animation = require('src.engine.render.Animation')

-- Loads a spritesheet, a collection of individual sprites in
-- one image. The spritesheet requires a .json file that defines
-- the individual quad boundaries and specifies animations.

local SpriteSheet = class('SpriteSheet')

-- filePrefix: prefix of the spritesheet / json file
--  ex. passing in "res/tank" would load
--      res/tank.png and res/tank.json.
function SpriteSheet:initialize(filePrefix)
    self.image = love.graphics.newImage(filePrefix .. '.png')
    self.metadata = json.parse(io.open(filePrefix .. '.json', 'r'):read('*all'))

    self.quads = {}
    self.animations = {}
    self:_parseMetadata()
end

function SpriteSheet:_parseMetadata()
    local sw, sh = self.image:getDimensions()
    local defaults = self.metadata.defaults

    -- load quads
    for name, quadDef in pairs(self.metadata.quads) do
        self.quads[name] = love.graphics.newQuad(
            quadDef.x or defaults.x,
            quadDef.y or defaults.y,
            quadDef.width or defaults.width,
            quadDef.height or defaults.height,
            sw, sh)
    end

    -- load animations
    for name, animDef in pairs(self.metadata.animations) do
        local frames = {}
        for i, quadName in pairs(animDef.frames) do
            frames[i] = self.quads[quadName]
        end
        self.animations[name] = Animation:new(name, self, frames, animDef.length)
    end
end

function SpriteSheet:getQuad(name)
    return self.quads[name]
end

-- Convert a single quad into a single-frame animation, and use a cache to avoid doing
-- this multiple times for the same quad.
--
-- If we make SpriteRenderer deal with animations exclusively,
-- this will be useful since we won't have to define all those
-- single-quad sprites (like terrain pieces) as animations manually.
function SpriteSheet:getQuadAsAnim(name)
    local keyName = '__auto__' .. name
    -- put in cache if missing
    if self.animations[keyName] == nil then
        local anim = Animation:new(keyName, self, {self.quads[name]}, 1)
        self.animations[keyName] = anim
    end
    return self.animations[keyName]
end

function SpriteSheet:getAnimation(name)
    return self.animations[name]
end

return SpriteSheet