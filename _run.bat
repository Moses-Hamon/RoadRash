@ECHO OFF
REM the above line disables printing of commands

REM to run a game, you pass the directory of a love2d game
REM into the love2d executable
REM love2d is, from a game folder:
REM up a directory (into game dev), then into _love, then love.executable
..\_love\lovec.exe %CD% --console
REM the CD variable means "current directory" - which SHOULD be a game