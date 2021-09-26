-- 1: den
-- 0: do

array = {
  { color = 1, val = 14, att = 4 }, --
  { color = 0, val = 14, att = 2 }, --
  { color = 1, val = 14, att = 3 },
  { color = 0, val = 13, att = 1 }, --
  { color = 1, val = 13, att = 4 }, --
  { color = 0, val = 13, att = 2 },
  { color = 0, val = 12, att = 1 },
  { color = 1, val = 8, att = 4 },
  { color = 1, val = 6, att = 4 },
  { color = 1, val = 5, att = 3 },
  { color = 1, val = 5, att = 4 },
  { color = 0, val = 5, att = 2 },
  { color = 0, val = 5, att = 1 },
}

local T = require "tableObj"
local PreHandle = require "preHandle"
local Game = require "game"
local CompareAction = require "compare"
local Count = require "findValue"
local Special = require "specialCase"

t = T:new()
p = PreHandle:new()
g = Game:new()
c = CompareAction:new()
countValue = Count:new()
specialCase = Special:new()
-- g:findDoi(array)
-- g:findThu(array)
-- g:findSamCo(array)
-- g:findSanh(array)
-- g:findThung(array)
-- g:findCuLu(array)
-- g:findTuQuy(array)
-- g:findThungPhaSanh(array)

-- local results = g:findThungPhaSanh(array)
-- local results = g:findTuQuy(array)
-- local results = g:findCuLu(array)
-- local results = g:findThung(array)
-- local results = g:findSanh(array)
-- local results = g:findSamCo(array)
-- local results = g:findThu(array)
-- local results = g:findDoi(array)
-- local results = g:findMauThau(array)

-- print(#results)
-- for i = 1, #(results) do
--   if #(results) == 4 or #(results) == 2 then
--     print('------')
--     for j = 1, #(results[i]) do
--       print(results[i][j]['val'])
--     end
--     print('------')
--   end
-- end
-- print(specialCase:checkIsMauThauXivaGia(array))

-- print(#p:findDoi(array, false))

g:play(array)
local x1 = { 
  { color = 0, val = 6, att = 2 },
  { color = 0, val = 5, att = 2 },
  { color = 1, val = 4, att = 2 },
  { color = 0, val = 3, att = 2 },
  { color = 0, val = 2, att = 2 }
}

local x2 = { 
  { color = 0, val = 14, att = 2 },
  { color = 0, val = 8, att = 1 },
  { color = 1, val = 2, att = 3 }
}
local doiMax = { 14, 14, 9, 3, 2 }
-- print(countValue:thungPhaSanh(x1, 1, true))
-- print(countValue:samCo5(x1, 1))
-- print(countValue:thung(x1, 1))
-- print(countValue:thu(x1, 1))
-- print(countValue:doi5(x1, 1))
-- print(countValue:doi3(x2, 1))
-- print(countValue:tuQuy(x1, 1))
-- print(countValue:cuLu(x1, 1))
-- print(countValue:mauThau3(x2, 1))
-- print(p:sortDoi(x2)[3]['val'])

-- print(specialCase:checkIsManyDoi(array, 4))
-- print(specialCase:handle4Doi(array))
-- local results = specialCase:handle4Doi(array)
-- print(results[1][1])

-- for i = 1, #(results[1][1]) do
--   print(results[1][1][i]['val'])
-- end
-- print(results[2][1])

-- print(specialCase:checkIsMauThauXivaGia(array))
-- local mauThauXiVaGia = specialCase:mauThauXivaGia(array)[1]
-- for i = 1, #(mauThauXiVaGia) do
--   print(mauThauXiVaGia[i]['val'])
-- end

-- print(countValue:findNextInDoi5(doiMax))
-- print(g:isValidInSamCo(x1))
