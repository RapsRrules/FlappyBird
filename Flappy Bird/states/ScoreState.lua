ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score

  self.goldMedal = love.graphics.newImage("medal_gold.png")
  self.silverMedal = love.graphics.newImage("medal_silver.png")
  self.bronzeMedal = love.graphics.newImage("medal_bronze.png")

end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function ScoreState:render()
  love.graphics.setFont(flappyFont)
  love.graphics.printf('Game Over!', 0, 30, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 70, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press Enter to Play Again!', 0, 210, VIRTUAL_WIDTH, 'center')

  local medal = nil
  local mname = nil

  if self.score >= 20 then
    medal = self.goldMedal
    mname = 'gold'
  elseif self.score >= 10 then
    medal = self.silverMedal
    mname = 'silver'
  elseif self.score >= 5 then
    medal = self.bronzeMedal
    mname = 'bronze'
  end

  if medal ~= nil then
    love.graphics.printf('Congratulations!!! You won a ' .. mname .. ' medal!', 0, 90, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(medal, VIRTUAL_WIDTH / 2 - medal:getWidth() / 2, 120)
  end
end
