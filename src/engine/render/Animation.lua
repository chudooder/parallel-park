local class = require('lib.middleclass')

local Animation = class('Animation')

-- represents a list of quads in a spritesheet
function Animation:initialize(name, spriteSheet, frames, length)
    -- name of animation used to lookup in spritesheet
    self.name = name
    -- spritesheet containing this animation
    self.spriteSheet = spriteSheet
    -- reference to spritesheet's image, for shorthand
    self.image = self.spriteSheet.image
    -- a list of quads representing the frames of this animation
    self.frames = frames
    -- number of frames in this animation
    self.numFrames = #frames
    -- length of this animation in seconds
    self.length = length
end

return Animation