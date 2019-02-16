local class = require('lib.middleclass')
local SpriteSheet = require('src.engine.render.SpriteSheet')

-- load and access resources from this static class, so that any given
-- resource is only loaded once
local Resources = class('Resources')

-- all the loaded resources go here
Resources.static.spriteSheets = {}

function Resources.static:loadSpriteSheet(filePrefix)
    if Resources.static.spriteSheets[filePrefix] == nil then
        Resources.static.spriteSheets[filePrefix] = SpriteSheet:new(filePrefix)
    end
    return Resources.static.spriteSheets[filePrefix]
end

return Resources