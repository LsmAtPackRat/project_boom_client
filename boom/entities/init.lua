local Player = require "boom.entities.Player"
local Barrier = require "boom.entities.Barrier"
local Light = require "boom.entities.Light"
local Sun = require "boom.entities.Sun"
local Wall = require "boom.entities.Wall"
local Shell = require "boom.entities.Shell"
local Water = require "boom.entities.Water"

local EntityManager = {}

function EntityManager:init(layer, map, world, shader)
  self.entity_list = {}
  self.layer = layer
  self.map = map
  self.world = world
  self.shader = shader
end

function EntityManager:removeEntityFromList(gid)
  self.entity_list[gid] = nil
end

function EntityManager:createEntity(type, ...)
  local args = {...}
  local e = nil
  local x, y, w, h, r = args[1], args[2], args[3], args[4], args[5]
  if type == "Player" or type == "player" then
    local player_id, is_myself, is_room_master = args[6], args[7], args[8]
    e = Player(x, y, w, h, r, self.world, self.shader, player_id, is_myself, is_room_master)
  elseif type == "Barrier" or type == "barrier" then
    local object = args[1]
    e = Barrier(object, self.map, self.world, self.shader)
  elseif type == "Light" or type == "light" then
    local r, g, b, range = args[6], args[7], args[8], args[9]
    e = Light(x, y, w, h, r, self.world, self.shader, r, g, b, range)
  elseif type == "Sun" or type == "sun" then
    e = Sun(self.map, self.shader)
  elseif type == "Wall" or type == "wall" then
    e = Wall(x, y, w, h, r, self.world, self.shader)
  elseif type == "Shell" or type == "shell" then
    e = Shell(x, y, w, h, r, self.world, self.shader)
  elseif type == "Water" or type == "water" then
    e = Water(x, y, w, h, r, self.world, self.shader)
  end
  if e then
    local gid = e:get("GlobalEntityId").id
    self.entity_list[gid] = e
  end
  return e
end

return EntityManager
