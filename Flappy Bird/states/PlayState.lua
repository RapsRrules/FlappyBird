PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

local spawnDT = math.random()*1.5 + 1.2

function PlayState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.timer = 0
  self.score = 0
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
  if scrolling then
  self.timer = self.timer + dt
  if self.timer > spawnDT then
    local y = math.max(-PIPE_HEIGHT + 10,
    math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - math.random(65, 140) - PIPE_HEIGHT))
    self.lastY = y
    table.insert(self.pipePairs, PipePair(y))
    self.timer = 0
    spawnDT = math.random()*1.5 + 1.2
  end

  for k, pair in pairs(self.pipePairs) do
    if not pair.scored then
      if pair.x + PIPE_WIDTH < self.bird.x then
        self.score = self.score + 1
        pair.scored = true
      end
    end
    pair:update(dt)
  end

  for k, pair in pairs(self.pipePairs) do
    if pair.remove then
      table.remove(self.pipePairs, k)
    end
  end

  for k, pair in pairs(self.pipePairs) do
    for l, pipe in pairs(pair.pipes) do
      if self.bird:collides(pipe) then
        gStateMachine:change('score', {
        score = self.score
      })
      end
    end
  end

  self.bird:update(dt)

  if self.bird.y > VIRTUAL_HEIGHT - 15 then
    gStateMachine:change('score', {
    score = self.score
  })
  end
end


  if love.keyboard.wasPressed('p') then
    if scrolling then
      scrolling = false
      BACKGROUND_SCROLL_SPEED = 0
      GROUND_SCROLL_SPEED = 0
      sounds['log']:pause()
      sounds['bleed']:play()
    else
      scrolling = true
      BACKGROUND_SCROLL_SPEED = 30
      BACKGROUND_SCROLL_SPEED = 60
      sounds['log']:play()
      sounds['bleed']:pause()
    end
  end
end

function PlayState:render()
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end

  love.graphics.setFont(flappyFont)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
  self.bird:render()
  if scrolling == false then
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Pause', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to resume', 0, 160, VIRTUAL_WIDTH, 'center')
  end
end

function PlayState:enter()
  scrolling = true
end

function PlayState:exit()
  scrolling = false
end
