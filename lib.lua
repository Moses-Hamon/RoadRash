local engine = {}
--roughly equivalent to a static method helloWorld in type lib
function engine.helloWorld()
	print("hello, world")
end

-- Prints table to console
function engine.dumpTable(tbl)
	for key, value in pairs(tbl) do
		print(key, value)
	end
end

-- provides a base entity for all objects in application.
function engine.entity()
-- base object of all entities
  local tbl = {}
  tbl.x = 0; tbl.y = 0
  tbl.w = 0; tbl.h = 0
end

-- Checks the collision
function engine.checkCollision(box1, box2)
  return box1.x < box2.x + box2.w and
         box2.x < box1.x + box1.w and
         box1.y < box2.y + box2.h and
         box2.y < box1.y + box1.h
end

return engine
