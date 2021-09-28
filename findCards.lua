Find = {}

local PreHandle = require "preHandle"
local Game = require "game"
local CompareAction = require "compare"
local T = require "tableObj"
t = T:new()
p = PreHandle:new()
g = Game:new()
c = CompareAction:new()

local TYPES = {
  'thungPhaSanh', 'tuQuy', 'cuLu', 'thung', 'sanh', 'samCo', 'thu', 'doi',
  'mauThau'
}

local tuQuyChiOne = 8
local sanhChiOne = 10
local tuQuyChiTwo = 16
local sanhChiTwo = 20
local cuLuChiTwo = 4
local samCoChiThree = 6

local SAU_DOI = 8
local HAI_PHAY_NAM_SANH = 8
local HAI_PHAY_NAM_THUNG = 8
local NAM_DOI_MOT_SAM = 10
local DONG_HOA = 30
local LIEN_MINH_RONG = 50
local LIEN_MINH_TOC_RONG = 100

function Find:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

local function findCurrentKindInNewVersion(type, currentCards, isFindChiTwo)
  local currentKind = {}

  if type == 'thungPhaSanh' then
      currentKind = g:findThungPhaSanh(currentCards)
  elseif type == 'tuQuy' then
      currentKind = p:findBaHoacBon(currentCards, true)
  elseif type == 'cuLu' then
      currentKind = g:findCuLu(currentCards)
  elseif type == 'thung' then
      currentKind = g:findThung(currentCards)
  elseif type == 'sanh' then
      currentKind = g:findSanh(currentCards)
  elseif type == 'samCo' then
      currentKind = p:findBaHoacBon(currentCards, false)
  elseif type == 'thu' then
      currentKind = p:findThu(currentCards)
  elseif type == 'doi' then
      currentKind = p:findDoi(currentCards)
  elseif type == 'mauThau' then
      currentKind = g:findMauThau(currentCards)
  end

  return currentKind
end

local function findIndexInTypes(type)
  for i = 1, #TYPES do
    if (TYPES[i] == type) then
      return i
    end
  end
end

local function readableData(array, types, scores)
  print(#array, types[1], types[2], types[3])

  local result = tostring(scores) .. '| chi 3: ' .. types[3] .. ' | ' ..
                     'chi 2: ' .. types[2] .. ' | ' .. 'chi 1: ' .. types[1] ..
                     '\n'

  local text = '\n-- '
  for i = 11, 13 do
      text = text .. tostring(array[i]['val']) .. '(' ..
                 tostring(array[i]['att']) .. ')' .. ' | '
  end
  result = result .. text

  text = '\n-- '
  for i = 6, 10 do
      text = text .. tostring(array[i]['val']) .. '(' ..
                 tostring(array[i]['att']) .. ')' .. ' | '
  end
  result = result .. text

  text = '\n-- '
  for i = 1, 5 do
      text = text .. tostring(array[i]['val']) .. '(' ..
                 tostring(array[i]['att']) .. ')' .. ' | '
  end
  result = result .. text

  return result
end

local function writeEvents(content)
  file = io.open("myCards.lua", "a")

  io.output(file)
  io.write('--****--\n')
  io.write(content .. '\n')

  -- closes the open file
  io.close(file)
end

local function writeResults(content)

  file = io.open("write.lua", "a")


  -- sets the default output file as test.lua
  io.output(file)

  io.write('\nFIND MY CARDS...\n')

  -- appends a word test to the last line of the file
  io.write('--****--\n')
  io.write(content .. '\n')

  -- closes the open file
  io.close(file)
end

local function isOneBiggerThanTwo(one, two)
  local saveIdxOne = 0
  local saveIdxTwo = 0

  for i = 1, #TYPES do
    if TYPES[i] == one then
      saveIdxOne = i
    end
    if TYPES[i] == two then
      saveIdxTwo = i
    end
  end

  return saveIdxOne < saveIdxTwo
end

-- local tuQuyChiOne = 8
-- local sanhChiOne = 10
-- local tuQuyChiTwo = 16
-- local sanhChiTwo = 20
-- local cuLuChiTwo = 4
-- local samCoChiThree = 6

local function calculateValue(type, chiIndex)
  if type == 'tuQuy' then
    if (chiIndex == 1) then
      return tuQuyChiOne
    else
      return tuQuyChiTwo
    end
  elseif type == 'sanh' then
    if (chiIndex == 1) then
      return sanhChiOne
    else
      return sanhChiTwo
    end
  elseif type == 'cuLu' and chiIndex == 2 then
    return cuLuChiTwo
  elseif type == 'samCo' and chiIndex == 3 then
    return samCoChiThree
  end

  return 1
end

local function soTungChi(myCards, myTypes, oppCards, oppTypes)
  local score = 0
  local countMy = 0
  local countOpp = 0

  local myCardsSplited = t:splitByChi(myCards)
  print('12xxxx', #oppCards)
  local oppCardsSplited = t:splitByChi(oppCards)

  local myChiOne = myCardsSplited[1]
  local myChiTwo = myCardsSplited[2]
  local myChiThree = myCardsSplited[3]

  local oppChiOne = oppCardsSplited[1]
  local oppChiTwo = oppCardsSplited[2]
  local oppChiThree = oppCardsSplited[3]

  for i = 1, 3 do
    if (myTypes[i] == oppTypes[i]) then
      if c:isFirstStronger(myCardsSplited[i], oppCardsSplited[i], myTypes[i]) then
        score = score + calculateValue(myTypes[i], i)
        countMy = countMy + 1
      else
        score = score - calculateValue(oppTypes[i], i)
        countOpp = countOpp + 1
      end
    elseif isOneBiggerThanTwo(myTypes[i], oppTypes[i]) then
      score = score + calculateValue(myTypes[i], i)
      countMy = countMy + 1
    else
      score = score - calculateValue(oppTypes[i], i)
      countOpp = countOpp + 1
    end
  end

  if countMy == 3 or countOpp == 3 then
    return score * 2
  end

  return score

end

local function handleToiTrang(results, chiTypes, myCards)
  local kq = specialCase:soToiTrang(myCards)

  if (kq ~= nil) then
    local text = readableData(kq[1], { kq[3], kq[3], kq[3] }, kq[2])
    writeResults(text)
  end
end

local function writeEventsToFile(results, chiTypes, scores)
  for i = 1, #results do
    local text = readableData(results[i], chiTypes[i], scores[i])
    writeEvents(text)
  end
end

local function handleFindFinalResult(results, chiTypes, scores, cards, saveIdx, saveScore)
  local kq = specialCase:soToiTrang(cards)
  local text = ''

  if (kq ~= nil) then
    if (kq[2] >= saveScore) then
      text = readableData(kq[1], { kq[3], kq[3], kq[3] }, kq[2])
    else
      text = readableData(results[saveIdx], chiTypes[saveIdx], scores[saveIdx])
    end
  end

  writeResults(text)

end

function Find:findCards(cards, oppCards, oppTypes)
  local results = {}
  local chiTypes = {}
  -- scores is meaning less but hard code
  local scores = {}

  local chiOneType = oppTypes[1]
  local chiTwoType = oppTypes[2]
  local chiThreeType = oppTypes[3]

  local idxChiOneOpp = findIndexInTypes(chiOneType)

  for i = 1, #TYPES do
    local currentKind = findCurrentKindInNewVersion(TYPES[i], cards)
        print('[CHI ONE]', TYPES[i], #currentKind)
    if #currentKind > 0 then
      for j = 1, #currentKind do
        local chiOne = currentKind[j]
                local currentCards = t:filterValuesInArray(cards, chiOne)
        if TYPES[i] == 'thungPhaSanh' then
          g:handleChiOneThungPhaSanh(chiOne, currentCards, results,
                                    chiTypes, scores)
        elseif TYPES[i] == 'tuQuy' then
            g:handleChiOneTuQuy(chiOne, currentCards, results, chiTypes,
                              scores)
        elseif TYPES[i] == 'cuLu' then
            g:handleChiOneCuLu(chiOne, currentCards, results, chiTypes,
                            scores)
        elseif TYPES[i] == 'thung' then
            g:handleChiOneThung(chiOne, currentCards, results, chiTypes,
                              scores)
        elseif TYPES[i] == 'sanh' then
            g:handleChiOneSanh(chiOne, currentCards, results, chiTypes,
                            scores)
        elseif TYPES[i] == 'samCo' then
            g:handleChiOneSamCo(chiOne, currentCards, results, chiTypes,
                              scores)
        end
      end
    end
  end

  local saveScore = -1000
  local saveIdx = 0

  for i = 1, #(results) do
    local text = ''
    local score = soTungChi(results[i], chiTypes[i], oppCards, oppTypes)
    table.insert(scores, score)
    if (score > saveScore) then
      saveScore = score
      saveIdx = i
    end
  end

  handleFindFinalResult(results, chiTypes, scores, cards, saveIdx, saveScore)

  writeEventsToFile(results, chiTypes, scores)
end

return Find