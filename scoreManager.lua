local serialise = require("ser")
----------------------------------------------------------------------SCORE MANAGER------------------------------------------------------------------
function append_score(score, player)
  -- load file contents
  local score_table = love.filesystem.load("score.txt")
  --If we got data
  if score_table ~= nil then
    --Deserialise the score_table
    score_table = score_table()
  else
    --Create a new score_table
    score_table = {}
  end
  --apend a new score to score table
  table.insert(score_table, {player = player, score = score})
  --serialise and write score table to file.
  love.filesystem.write("score.txt", serialise(score_table))
end

function read_scores()
  -- Load file contents
  score_table = love.filesystem.load("score.txt")

  -- IF file exists
  if score_table ~= nil then
    score_table = score_table()

    scoreboard = ""

    for i, entry in ipairs(score_table) do
      scoreboard = scoreboard .. "Score " .. entry.score .. "Name: " .. entry.player .. "\n"
    end
  end
end
