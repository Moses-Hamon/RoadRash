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
player.h = 50
player.w = 100
player.speed = 100
-- Sound button
soundButton = {x=650, y=400, w=120, h=30, text="Sound OFF"}
-- scoreboard
scoreboard = ""
-- initial loading of scores
read_scores()


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
  scrollbackground(dt)


end
----------------------------------------------------------------------END OF love.UPDATE------------------------------------------------------------------

function love.draw()
    -- use this function for anything to do with drawing
  -- (putting stuff on the screen)
  -- any draw-related function won't do anything if its elsewhere
  -- avoid putting game logic in here - only draw calls
  -- draws the background
  drawBackGrounds()
  if activeScreen == screens.MENU then
    drawScoreWindow()
    drawPLayer(216,10,27)
    drawScore()
    drawButton()
  end
  if activeScreen == screens.GAME then
    drawPLayer(216,10,27)
  end

end
----------------------------------------------------------------------END OF love.DRAW------------------------------------------------------------------

-- Keypress events --
function love.keypressed(key, scancode, isrepeat)
  if key == "return" then
    activeScreen = screens.GAME
    backgroundSpeed = 300
  end
end
-- Mouse Pressed Events --
function love.mousepressed(x, y, button, isTouch)
  toggleSound(x,y,button)
end

-- toggles sound for the game
function toggleSound(x,y,button)
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
  love.graphics.rectangle('fill', soundButton.x, soundButton.y, soundButton.w, soundButton.h)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(soundButton.text, soundButton.x +5, soundButton.y+5)
end

-- Draws the player
function drawPLayer(r, b, g)
  love.graphics.push()
  love.graphics.setColor(r/255, b/255, g/255)
  love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
  love.graphics.pop()
end

-- Draws the window for displaying HIGHSCORES
function drawScoreWindow()
  love.graphics.push()
  love.graphics.setColor(61/255, 121/255, 219/255)
  love.graphics.rectangle("fill", 50, 50, 650, 300)
  love.graphics.pop()
end
-- Draws the scoreboard
function drawScore()
-- title for scoreboard
  local heading
  -- will show different title for MENU
  if activeScreen == screens.MENU then
    heading = "HIGHSCORES"
  else
    heading = "YOUR SCORE WAS"
  end
  -- Prints Title
  love.graphics.push()
  love.graphics.setNewFont(40)
  love.graphics.setColor(17/255, 168/255, 6/255)
  love.graphics.print(heading, 200, 60)
  -- Print Scores
  love.graphics.setNewFont(20)
  love.graphics.setColor(208/255, 122/255, 8/255)
  love.graphics.print(scoreboard, 60, 100)
  love.graphics.pop()
end

-- Scrolls background --
function scrollbackground(dt)
  if activeScreen == screens.MENU or screens.GAME then
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
end
