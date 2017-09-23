local Physic = require "boom.components.physic.Physic"
local ShaderPolygon = require("boom.components.graphic.ShaderPolygon")
local Light = require("boom.components.graphic.Light")
local CollisionCallbacks = require("boom.components.physic.CollisionCallbacks")
local DrawableImage = require("boom.components.graphic.DrawableImage")
local events = require("boom.events")
local AssetsManager = require("assets")
local IsItem = require("boom.components.identifier.IsItem")
local Explosive = require("boom.components.vehicle.Explosive")
local PSM = require "boom.particle"

-- shell entity
local createNuclearShellItem = function(x, y, r, world, light_world)
    local e = Entity()
    local image = AssetsManager:instance().images.item_nuclear_shell
    local w, h = image:getWidth(), image:getHeight()
    local sx, sy = x + w/2, y + h/2
    local body = love.physics.newBody(world, sx, sy, "dynamic")
    body:setAngle(r)
    local shape = love.physics.newRectangleShape(w, h)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setSensor(true)
    e:add(IsItem())
    e:add(Explosive(sx, sy, 0, 0, PSM:createParticleSystem("item_explosion")))
    e:add(Physic(body))
    e:add(DrawableImage(image, x, y, r))
    local t = light_world and e:add(ShaderPolygon(light_world, body))
    e:add(CollisionCallbacks(
        function(that_entity, coll)
            if that_entity:has("IsPlayer") and that_entity:has("Launchable") then
                local L = that_entity:get("Launchable")
                L.shell_name = "NuclearShell"
                L.shell_count = 1
                e:get("Explosive").is_exploded = true
                e:get("Explosive").explosion_ps:start()
            end
        end
    ))
    body:setUserData(e)
    return e
end
return createNuclearShellItem