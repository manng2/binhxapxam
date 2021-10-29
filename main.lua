-- 1: den
-- 0: do

-- 1: co 2: ro 3: chuon 4: bich

array = {
  { color = 1, val = 2, att = 4 }, --
  { color = 1, val = 11, att = 4 }, --
  { color = 1, val = 9, att = 4 },
  { color = 1, val = 11, att = 3 }, --
  { color = 1, val = 8, att = 1 }, --
  { color = 1, val = 6, att = 3 }, --
  { color = 0, val = 11, att = 1 }, --
  { color = 0, val = 11, att = 2 },
  { color = 0, val = 3, att = 2 }, --
  { color = 1, val = 7, att = 3 }, --
  { color = 1, val = 2, att = 3 }, --
  { color = 0, val = 4, att = 2 }, --
  { color = 0, val = 12, att = 2 }, --
}

myArray = {
  { color = 1, val = 7, att = 4 },
  { color = 0, val = 14, att = 2 },
  { color = 1, val = 12, att = 3 }, --
  { color = 1, val = 12, att = 4 },
  { color = 1, val = 9, att = 3 },
  { color = 1, val = 5, att = 4 },
  { color = 0, val = 9, att = 2 },
  { color = 0, val = 7, att = 2 },
  { color = 1, val = 14, att = 4 }, --
  { color = 1, val = 13, att = 4 },
  { color = 1, val = 13, att = 3 }, --
  { color = 0, val = 6, att = 2 },
  { color = 0, val = 2, att = 2 }, --
}


testArray = {
  { color = 1, val = 14, att = 3 }, --
  { color = 1, val = 13, att = 4 }, --
  { color = 1, val = 12, att = 3 }, --
  { color = 1, val = 11, att = 3 },
  { color = 1, val = 10, att = 4 }, --
  { color = 1, val = 9, att = 3 }, --
  { color = 1, val = 8, att = 4 }, --
  { color = 1, val = 7, att = 4 },
  { color = 1, val = 6, att = 3 },
  { color = 1, val = 5, att = 4 },
  { color = 1, val = 4, att = 3 },
  { color = 1, val = 3, att = 3 },
  { color = 1, val = 2, att = 4 },
}

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

-- THAM SỐ oppCards LÀ BÀI CỦA ĐỐI PHƯƠNG, ourCards LÀ BÀI CỦA MÌNH

local function main(oppCards, ourCards)
  local opp = g:play(t:sortDesc(oppCards))
  local our = f:findCards(t:sortDesc(ourCards), opp[1], opp[2])

  print('[CARDS] BÀI CỦA ĐỐI PHƯƠNG')
  for i = 1, #opp[1] do
    print(opp[1][i]['val'])
  end
  print('------------------')

  print('[TYPES] LOẠI BÀI CỦA ĐỐI PHƯƠNG')
  for i = 1, #opp[2] do
    print(opp[2][i])
  end
  print('------------------')

  print('[CARDS] BÀI CỦA MÌNH')
  for i = 1, #our[1] do
    print(our[1][i]['val'])
  end
  print('------------------')

  print('[TYPES] LOẠI BÀI CỦA MÌNH')
  for i = 1, #our[2] do
    print(our[2][i])
  end
  print('------------------')

  print('[SCORES] SỐ ĐIỂM MÌNH ĂN ĐƯỢC', our[3])
  -- print(opp[1], opp[2])
  -- print(our[1], our[2], our[3])
end

main(array, myArray)
