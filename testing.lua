local T = require "tableObj"
local PreHandle = require "preHandle"
local Game = require "game"
local CompareAction = require "compare"
local Count = require "findValue"
local Special = require "specialCase"
local Find = require "findCards"

t = T:new()
p = PreHandle:new()
g = Game:new()
f = Find:new()
c = CompareAction:new()
countValue = Count:new()
specialCase = Special:new()

array = {
  { color = 1, val = 14, att = 4 }, --
  { color = 0, val = 12, att = 2 }, --
  { color = 1, val = 12, att = 3 }, --
  { color = 0, val = 12, att = 1 }, --
  { color = 1, val = 12, att = 4 }, --
  { color = 0, val = 9, att = 2 }, --
  { color = 0, val = 9, att = 1 },
  { color = 1, val = 9, att = 4 }, --
  { color = 1, val = 5, att = 3 },
  { color = 1, val = 4, att = 4 }, --
  { color = 0, val = 3, att = 2 }, --
  { color = 0, val = 2, att = 1 }, --
  { color = 1, val = 2, att = 4 }, --
}

local r = g:findThu(array)

-- for i = 1, #r do
--   print('---m---')
--   for j = 1, #r[i] do
--     print(r[i][j]['val'], r[i][j]['att'])
--   end
-- end

local chiOne = {
  { color = 0, val = 12, att = 2 }, --
  { color = 1, val = 12, att = 3 }, --
  { color = 0, val = 12, att = 1 }, --
  { color = 1, val = 12, att = 4 }, --
  { color = 1, val = 3, att = 4 }, --
}
local chiTwo = {
  { color = 0, val = 12, att = 2 }, --
  { color = 1, val = 12, att = 3 }, --
  -- { color = 1, val = 2, att = 4 }, --
  -- { color = 1, val = 2, att = 4 }, --
  -- { color = 0, val = 3, att = 2 }, --
}
local chiThree = {
  { color = 0, val = 12, att = 1 }, --
  { color = 1, val = 12, att = 4 }, --
}

print(p:isTuQuy(chiOne))
-- local racs = t:filterValuesInArray(array, chiOne)
-- racs = t:filterValuesInArray(racs, chiTwo)
-- racs = t:filterValuesInArray(racs, chiThree)

-- local x = p:divideRacsTo3Chi(chiOne, chiTwo, chiThree, racs)

-- local newChiOne = x[1]
-- local newChiTwo = x[2]
-- local newChiThree = x[3]

-- for i = 1, #newChiOne do
--   print(newChiOne[i]['val'])
-- end

-- for i = 1, #newChiTwo do
--   print(newChiTwo[i]['val'])
-- end

-- for i = 1, #newChiThree do
--   print(newChiThree[i]['val'])
-- end
