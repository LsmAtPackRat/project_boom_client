--片头
local titles = class("titles")
local game_state = require("libs.hump.gamestate")
local cam = require("boom.camera")
local camera = cam:instance()
local img_advise = love.graphics.newImage("/assets/title_advise.jpg")
local img_studio9 = love.graphics.newImage("/assets/title_studio9.png")

local phases
local current_phase = "phase1"
local window_w = 960
local window_h = 640

--合理游戏说明
function titles.phase1_update(dt)
  local cp = phases["phase1"]
  --cp中记录了当前phase1需要的各种数据
  cp.timer = cp.timer + dt
  if cp.timer >= cp.duration then
    --切换到下一个阶段
    current_phase = cp.nextphase
  else
    --此时进行更新
    if cp.timer < cp.duration / 2 then --第一阶段
      local delta_alpha = dt * 255 / (2*cp.duration/3)
      cp.alpha = cp.alpha - delta_alpha
    else
      local delta_alpha = dt * 255 / (cp.duration/3)
      cp.alpha = cp.alpha + delta_alpha
    end
  end
end

function titles.phase2_update(dt)
  local cp = phases["phase2"]
  --cp中记录了当前phase1需要的各种数据
  cp.timer = cp.timer + dt
  if cp.timer >= cp.duration then
    --切换到下一个阶段
    current_phase = cp.nextphase
  else
    --此时进行更新
    if cp.timer < cp.duration / 2 then --第一阶段
      local delta_alpha = dt * 255 / (2*cp.duration/3)
      cp.alpha = cp.alpha - delta_alpha
    else
      local delta_alpha = dt * 255 / (cp.duration/3)
      cp.alpha = cp.alpha + delta_alpha
    end
  end
end

function titles.phase3_update(dt)
  print("phase3_update()")
  local cp = phases["phase3"]
  --cp中记录了当前phase1需要的各种数据
  cp.timer = cp.timer + dt
  if cp.timer >= cp.duration then
    --切换到下一个阶段
    current_phase = cp.nextphase
  else
    --此时进行更新
  end
end

function titles.phase1_draw()
  love.graphics.setBackgroundColor(0,0,0,255)
  local r,g,b,a = love.graphics.getColor()
  love.graphics.draw(img_advise)
  --加一个透明蒙板盖在上面
  local cp = phases["phase1"]
  love.graphics.setColor(0, 0, 0, cp.alpha)
  love.graphics.rectangle("fill", 0, 0, window_w, window_h)
  love.graphics.setColor(r,g,b,a)
end

function titles.phase2_draw()
  love.graphics.setBackgroundColor(255,255,255,255)
  local r,g,b,a = love.graphics.getColor()
  love.graphics.draw(img_studio9)
  --加一个透明蒙板盖在上面
  local cp = phases["phase2"]
  love.graphics.setColor(0, 0, 0, cp.alpha)
  love.graphics.rectangle("fill", 0, 0, window_w, window_h)
  love.graphics.setColor(r,g,b,a)
end

function titles.phase3_draw()
end


phases = {--有哪些阶段
  phase1 = {update = titles.phase1_update, draw = titles.phase1_draw, nextphase = "phase2", alpha = 255, timer = 0, duration = 6},  --合理游戏说明
  phase2 = {update = titles.phase2_update, draw = titles.phase2_draw, nextphase = "phase3", alpha = 255, timer = 0, duration = 6},  --studio9 logo
  phase3 = {update = titles.phase3_update, draw = titles.phase3_draw, nextphase = "endphase", alpha = 255, timer = 0, duration = 3},  --游戏title
  endphase = {},  --用于终结},  
}  

function titles:enter()
  print("titles:enter()")
  local zm = math.max(love.graphics.getWidth()/window_w, love.graphics.getHeight()/window_h)
  camera:zoom(zm)
  camera:lookAt(window_w/2, window_h/2)
end

function titles:update(dt)
  print("titles:update()")
  local cp = phases[current_phase]
  print(current_phase)
  if cp["update"] then 
    print("cp.update()")
    cp.update(dt)
  else
    local login = require "boom.scenes.login"
    game_state.switch(login)
  end
end


function titles:draw()
  love.graphics.print(current_phase)
  local cp = phases[current_phase]
  if cp["draw"] then 
    camera:attach()
    cp.draw()
    camera:detach()
  end
end

return titles