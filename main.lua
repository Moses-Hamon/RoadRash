-- Library for serialising to and from file
local name = require("ser")
lib = require("lib")
require("scoreManager")
function love.load(arg)
  -- love.load is a callback that gets executed once
  -- when the game launches
  -- use it for once off loading and configuration like
  -- loading assets (sounds, images, etc)
  -- think of it like a constructor

  --Background--
  backgroundSpeed = 150
  testBackGround = {x=0,y=0,h=600,w=800}
  testBackGround2 = {x=800,y=0,h=600,w=800}
  -- Game Music --
music_scores = love.audio.newSource("bensound_sadday.mp3", "stream")
music = love.audio.newSource("Shaolin_Dub_Hermes.mp3", "stream")
-- table for holding all obstacles
obstacles = {}
--Game Screens
  screens = { MENU = 1, GAME = 2, SCORES = 3}
-- Sets the active screen
activeScreen = screens.MENU
-- Player properties
player = {}
player.x = 150
player.y = 400
player.h = 20
player.w = 100
player.speed = 300
player.name = ""
-- Obstacle Speeds
diagonalSpeed = 100
-- Sound button
soundButton = {x=670, y=10, w=120, h=30, text="Sound ON"}
-- scoreboard
scoreboard = ""
score = 0
-- initial loading of scores
read_scores()
music:setVolume(0.5)
music:play()
test = "TEST"

end
----------------------------------------------------------------------END OF love.LOAD------------------------------------------------------------------
function love.update(dt)
  -- this function is for all your game logic
  -- physics calculations, moving characters, spawning enemies
  -- but it needs to be written synchronised to each frame
  -- while also considering how much time has passed
  -- the dt parameter (short for Delta Time) is the Time
  -- elapsed since the last update cycle, which helps your
  -- make your game smooth and consistant across al performance.
-- Created a scrolling background
if activeScreen == screens.MENU or activeScreen == screens.GAME then
  scrollbackground(dt)
end
  -- Controls the player up and down
  if activeScreen == screens.GAME then
    if love.keyboard.isDown("w") and player.y > 200 then
      player.y = player.y - 1 * player.speed * dt
    elseif love.keyboard.isDown("s") and player.y < 500 then
      player.y = player.y + 1 * player.speed * dt
    end
  end
-- scrolls objects across screen --
  for i, o in pairs(obstacles) do
    o.x = o.x - 1 * o.speed * dt
    randomMovement(o, dt)
    if lib.checkCollision(player, o) then
      activeScreen = screens.SCORES
      music:stop()
      music_scores:play()
    end
    if o.x < -65 then
      table.remove(obstacles, i)
      score = score + 1
    end
  end


end
----------------------------------------------------------------------END OF love.UPDATE------------------------------------------------------------------
function randomMovement(self, dt)

  -- select a direction
  if self.direction == 1 then
    -- if it's still in the road
    if self.y < 500 then
      self.y = self.y + 1 * diagonalSpeed * dt
    else
      self.direction = 2
    end
  elseif self.direction == 2 then
    if self.y > 200 then
      self.y = self.y - 1 * diagonalSpeed * dt
    else
      self.direction = 1
    end
  end

end
function love.draw()
    -- use this function for anything to do with drawing
  -- (putting stuff on the screen)
  -- any draw-related function won't do anything if its elsewhere
  -- avoid putting game logic in here - only draw calls
  -- draws the background

  if activeScreen == screens.MENU or activeScreen == screens.GAME then
    drawBackGrounds()
  end
  drawButton()
  if activeScreen == screens.MENU then
    drawScoreWindow(300)
    drawPLayer(216,10,27)
    drawScore()
  end
  if activeScreen == screens.GAME then
    love.graphics.setNewFont(30)
    love.graphics.print(score, 10, 10)
    love.graphics.print(test, 50, 50) -- TEST
    drawPLayer(216,10,27)

-- For drawing the obstacles --
    for i, o in pairs(obstacles) do
      love.graphics.rectangle("fill", o.x, o.y, o.w, o.h)
    end
  end

  if activeScreen == screens.SCORES then
    drawScoreWindow(150)
    player.y = 450
    player.x = 325
    drawPLayer(216,10,27)
    drawScore()
    love.graphics.print(player.name, 150, 150, r, sx, sy, ox, oy, kx, ky)
  end

end
----------------------------------------------------------------------END OF love.DRAW------------------------------------------------------------------

-- Keypress events --
function love.keypressed(key, scancode, isrepeat)
  if key == "return" and activeScreen == screens.MENU then
    activeScreen = screens.GAME
    backgroundSpeed = 300
  end
  if activeScreen == screens.GAME then
    gameKeypressed(key)
  end
  if activeScreen == screens.SCORES then
    scoresKeypressed(key)
  end
end
-- Mouse Pressed Events --
function love.mousepressed(x, y, button, isTouch)
    toggleSound(x,y,button)
end
-- Keypressed for Scores Screens
function scoresKeypressed(key)
  if key == "return" then
    if player.name ~= "" then
          append_score(score, player.name)
          resetGame()
          activeScreen = 1

    end
  end
end
--Key events for entering Name
function love.textinput(text)
  if activeScreen == screens.SCORES then
    player.name = player.name .. text
  end
end

-- Spawn the obstacle
function spawnObstacle()
  obstacle = {}
  obstacle.x = 0
  obstacle.y = 0
  obstacle.h = 15
  obstacle.w = 60
  obstacle.speed = love.math.random(350, 600)
  obstacle.dead = false
  obstacle.direction = love.math.random(0, 3)

  obstacle.y = love.math.random(200, 500)
  obstacle.x = love.graphics.getWidth() - 120

table.insert(obstacles, obstacle)
end
function gameKeypressed(key)
  if key == "space" then
    spawnObstacle()
  end
end


-- toggles sound for the game
function toggleSound(x,y,button)
  if activeScreen == screens.MENU or activeScreen == screens.GAME then
    if mouseButtonClick(x,y,button) then
      if music:isPlaying() then
        music:pause()
        soundButton.text = "Sound OFF"
      else
        music:setVolume(0.6)
        music:play()
        soundButton.text = "Sound ON"
      end
    end
  end
  if activeScreen == screens.SCORES then
    if mouseButtonClick(x,y,button) then
      if music_scores:isPlaying() then
        music_scores:pause()
        soundButton.text = "Sound OFF"
      else
        music_scores:setVolume(0.6)
        music_scores:play()
        soundButton.text = "Sound ON"
      end
    end
  end
end
-- checker for button clicked
function mouseButtonClick(x,y,button)
  if button == 1 then
    if (x >= soundButton.x) and (x <= soundButton.x + soundButton.w) and (y >= soundButton.y) and (y <= soundButton.y + soundButton.h) then
      return true
    end
  end
  return false
end
-- Draws brackgrounds
function drawBackGrounds()
  love.graphics.setColor(1, 0, 1)
  love.graphics.rectangle("fill", testBackGround.x, testBackGround.y, testBackGround.w, testBackGround.h)
  love.graphics.setColor(1, 1, 0)
  love.graphics.rectangle("fill", testBackGround2.x, testBackGround2.y, testBackGround2.w, testBackGround2.h)
  love.graphics.print(xcoord, 100, 100)
end
-- Draws button
function drawButton()
  love.graphics.push()
  love.graphics.setNewFont(20)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('fill', soundButton.x, soundButton.y, soundButton.w, soundButton.h)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(soundButton.text, soundButton.x +5, soundButton.y+5)
  love.graphics.pop()
end
--resets player stats--
function resetGame()
  player = {}
  player.x = 150
  player.y = 400
  player.h = 20
  player.w = 100
  player.speed = 300
  player.name = ""
  score = 0
  music_scores:stop()
  music:play()
  read_scores()
end
-- Draws the player
function drawPLayer(r, b, g)
  love.graphics.push()
  love.graphics.setColor(r/255, b/255, g/255)
  love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
  love.graphics.pop()
end

-- Draws the window for displaying HIGHSCORES
function drawScoreWindow(height)
  love.graphics.push()
  love.graphics.setColor(61/255, 121/255, 219/255)
  love.graphics.rectangle("fill", 50, 50, 650, height)
  love.graphics.pop()
end
-- Draws the scoreboard
function drawScore()
-- title for scoreboard
  local heading
  -- will show different title for MENU
  if activeScreen == screens.MENU then
    heading = "HIGHSCORES"
    -- Print Scores
    love.graphics.push()
    love.graphics.setNewFont(20)
    love.graphics.setColor(208/255, 122/255, 8/255)
    love.graphics.print(scoreboard, 60, 100)
    love.graphics.pop()
  elseif activeScreen == screens.SCORES then
    heading = "YOUR SCORE WAS"
    love.graphics.push()
    love.graphics.setNewFont(40)
    love.graphics.setColor(17/255, 168/255, 6/255)
    love.graphics.print("Your Score: " .. score, 200, 80)
    love.graphics.pop()
  end
  -- Prints Title
  love.graphics.push()
  love.graphics.setNewFont(40)
  love.graphics.setColor(17/255, 168/255, 6/255)
  love.graphics.print(heading, 200, 60)
  love.graphics.pop()

end

-- Scrolls background --
function scrollbackground(dt)

    -- Scrolling Background 1 --
    testBackGround2.x = testBackGround2.x - 1 * backgroundSpeed * dt
    if testBackGround2.x <= 0 then
      testBackGround2.x = 800
    end
    -- Scrolling Background 2 --
    testBackGround.x = testBackGround.x - 1 *backgroundSpeed * dt
    xcoord = testBackGround.x
    if testBackGround.x <= -testBackGround.w then
      testBackGround.x = 0
    end

end
