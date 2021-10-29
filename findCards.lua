Find = {}

local PreHandle = require "preHandle"
local Game = require "game"
local CompareAction = require "compare"
local T = require "tableObj"
local Special = require "specialCase"

t = T:new()
p = PreHandle:new()
g = Game:new()
c = CompareAction:new()
specialCase = Special:new()

local TYPES = {
  'thungPhaSanh', 'tuQuy', 'cuLu', 'thung', 'sanh', 'samCo', 'thu', 'doi',
  'mauThau'
}
local TOITRANG_TYPES = {
  'lienMinhTocRong', 'lienMinhRong', 'dongHoa', 'namDoiMotSam', 'haiPhayNamThung', 'haiPhayNamSanh', 'sauDoi'
}

local tuQuyChiOne = 8
local thungPhaSanhChiOne = 10
local tuQuyChiTwo = 16
local thungPhaSanhChiTwo = 20
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
  -- print(#array, types[1], types[2], types[3])

  -- hard code
  if #array ~= 13 or #types ~= 3 then
    -- for i = 1, #array do
    --   print(array[i]['val'], array[i]['att'])
    -- end
    -- os.exit()
    return 'error'
  end

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

local function isOneBiggerThanTwo(one, two, types)
  local saveIdxOne = 0
  local saveIdxTwo = 0

  for i = 1, #types do
    if types[i] == one then
      saveIdxOne = i
    end
    if types[i] == two then
      saveIdxTwo = i
    end
  end

  return saveIdxOne < saveIdxTwo
end

-- local tuQuyChiOne = 8
-- local thungPhaSanhChiOne = 10
-- local tuQuyChiTwo = 16
-- local thungPhaSanhChiTwo = 20
-- local cuLuChiTwo = 4
-- local samCoChiThree = 6

local function calculateValue(type, chiIndex)
  if type == 'tuQuy' then
    if (chiIndex == 1) then
      return tuQuyChiOne
    else
      return tuQuyChiTwo
    end
  elseif type == 'thungPhaSanh' then
    if (chiIndex == 1) then
      return thungPhaSanhChiOne
    else
      return thungPhaSanhChiTwo
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

  -- print('----cccc-----', myTypes[1], myTypes[2], myTypes[3])
  -- for k = 1, #myCards do
  --   print(myCards[k]['val'])
  -- end
  -- print('----cccc-----')


  local myCardsSplited = t:splitByChi(myCards)
  -- print('12xxxx', #oppCards)
  local oppCardsSplited = t:splitByChi(oppCards)

  local myChiOne = myCardsSplited[1]
  local myChiTwo = myCardsSplited[2]
  local myChiThree = myCardsSplited[3]

  local oppChiOne = oppCardsSplited[1]
  local oppChiTwo = oppCardsSplited[2]
  local oppChiThree = oppCardsSplited[3]

  for i = 1, 3 do
    if (myTypes[i] == oppTypes[i]) then
      -- print('hello', oppTypes[i])
      for k = 1, #myCardsSplited[i] do
        -- print(myCardsSplited[i][k]['val'])
      end
      -- print('----')

      for l = 1, #oppCardsSplited[i] do
        -- print(oppCardsSplited[i][l]['val'])
      end
      -- print(#myCardsSplited[i])
      -- print(#oppCardsSplited[i])

      if c:isFirstStronger(myCardsSplited[i], oppCardsSplited[i], myTypes[i]) then
        score = score + calculateValue(myTypes[i], i)
        countMy = countMy + 1
      else
        score = score - calculateValue(oppTypes[i], i)
        countOpp = countOpp + 1
      end
    elseif isOneBiggerThanTwo(myTypes[i], oppTypes[i], TYPES) then
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

local function findBinhLung(results)
  local cardsChoiced = results[1]
  local result = { cardsChoiced[6], cardsChoiced[7], cardsChoiced[8], cardsChoiced[9], cardsChoiced[10], cardsChoiced[1], cardsChoiced[2], cardsChoiced[3], cardsChoiced[4], cardsChoiced[5], cardsChoiced[11], cardsChoiced[12], cardsChoiced[13] }

  return result
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
  local res = {}

  text = readableData(results[saveIdx], chiTypes[saveIdx], saveScore)

  if (kq ~= nil) then
    if (kq[2] >= saveScore) then
      text = readableData(kq[1], { kq[3], kq[3], kq[3] }, kq[2])
      res = { kq[1], { kq[3], kq[3], kq[3] }, kq[2] }
    else
      text = readableData(results[saveIdx], chiTypes[saveIdx], scores[saveIdx])
      res = { results[saveIdx], chiTypes[saveIdx], scores[saveIdx] }
    end
  end

  if (saveScore < -6) then
    local binhLung = findBinhLung(results)
    text = readableData(binhLung, { 'binhLung', 'binhLung', 'binhLung' }, -6)
    res = { binhLung, { 'binhLung', 'binhLung', 'binhLung' }, -6 }
  end

  -- writeResults(text)

  return res
end

local function isToiTrang(types)
  if (t:hasValue(TOITRANG_TYPES, types[1])) then
    return true
  end

  return false
end

local function handleOppToiTrang(oppType, cards)
  local kq = specialCase:soToiTrang(cards)

  if (kq ~= nil) then
    if oppType == kq[3] or (isOneBiggerThanTwo(kq[3], oppType, TOITRANG_TYPES)) then
      return { kq[1], kq[3] }
    end
  end

  return nil
end

local function findToiTrangScore(type)
  if (type == 'lienMinhTocRong') then
    return LIEN_MINH_TOC_RONG
  end
  if (type == 'lienMinhRong') then
    return LIEN_MINH_RONG
  end
  if (type == 'dongHoa') then
    return DONG_HOA
  end
  if (type == 'namDoiMotSam') then
    return NAM_DOI_MOT_SAM
  end
  if (type == 'haiPhayNamThung') then
    return HAI_PHAY_NAM_THUNG
  end
  if (type == 'haiPhayNamSanh') then
    return HAI_PHAY_NAM_SANH
  end
  if (type == 'sauDoi') then
    return SAU_DOI
  end
end

local function convertChiToResult(chiOne, chiTwo, chiThree)
  local result = {}

  for i = 1, #(chiOne) do table.insert(result, chiOne[i]) end
  for i = 1, #(chiTwo) do table.insert(result, chiTwo[i]) end
  for i = 1, #(chiThree) do table.insert(result, chiThree[i]) end

  return result
end

local function findResultsWithOldVersion(cards, results, chiTypes, scores)
  for i = 1, #TYPES do
    local currentKind = findCurrentKindInNewVersion(TYPES[i], cards)
        -- print('[CHI ONE]', TYPES[i], #currentKind)
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
end


local function findIndexOfType(type, types)
  for i = 1, #(types) do
    if types[i] == type then
      return i    
    end
  end
end

local function findNextKind(currentType, array)
  -- print('find next cua ', currentType, #(array))
  -- print('---------CURRENT CARDS IN NEXT----------')
  -- for i = 1, #(array) do
  --   print(array[i]['val'], array[i]['att'])
  -- end
  -- print('--------------------------------')
  if currentType == 'thungPhaSanh' then
    return g:findTuQuy(array)
  elseif currentType == 'tuQuy' then
    return g:findCuLu(array)
  elseif currentType == 'cuLu' then
    return g:findThung(array)
  elseif currentType == 'thung' then
    return g:findSanh(array)
  elseif currentType == 'sanh' then
    return g:findSamCo(array)
  elseif currentType == 'samCo' then
    return g:findThu(array)
  elseif currentType == 'thu' then
    return g:findDoi(array)
  else
    return g:findMauThau(array)
  end

end

local function checkBinhLung(array)
  local types = {
    thungPhaSanh = 9,
    tuQuy = 8,
    cuLu = 7,
    thung = 6,
    sanh = 5,
    samCo = 4,
    thu = 3,
    doi = 2,
    mauThau = 1
  }

  -- hard code binh lung
  if (#array ~= 3) then
    return true
  end

  if types[array[1]] < types[array[2]] or types[array[2]] < types[array[3]] then
    return true
  else 
    return false
  end
end

local function findNextWithChiOne(results, chiOne, type, currentCards, chiType, chiTypes, scores, cards)
  -- print('currrr: ', #currentCards);
  -- print('chi 1:', #chiOne)
  local currentKind = {}

  while #currentKind == 0 and type ~= 'mauThau' do
    currentKind = findNextKind(type, currentCards)

    if type == 'thungPhaSanh' then
          type = 'tuQuy'
    elseif type == 'tuQuy' then
      type = 'cuLu'
    elseif type == 'cuLu' then
      type = 'thung'
    elseif type == 'thung' then
      type = 'sanh'
    elseif type == 'sanh' then
      type = 'samCo'
    elseif type == 'samCo' then
      type = 'thu'
    elseif type == 'thu' then
      type = 'doi'
    else
      type = 'mauThau'
    end
  end

  if type == 'mauThau' and #currentKind > 0 then
    local result = specialCase:handle2ChiRac(chiOne, currentCards)

    if result ~= nil then
      local cards = result[1]

      local chiTwo = { cards[6], cards[7], cards[8], cards[9], cards[10] }
      local chiThree = { cards[11], cards[12], cards[13] }
      local tmp = convertChiToResult(chiOne, chiTwo, chiThree)
      local copyChiType = { chiType[1], 'mauThau', 'mauThau' }

      table.insert(results, tmp)
      table.insert(chiTypes, copyChiType)
    end

    return
  end

  for i = 1, #(currentKind) do
    local copyChiType = t:shallowCopy(chiType)
    local chiTwo = currentKind[i]
    -- print('chi 2 :', #chiTwo)

    -- if c:isFirstStronger(chiOne, chiTwo) then
    table.insert(copyChiType, type)
    local chiThree = {}
    local currentCardsAfterTwo = t:shallowCopy(currentCards)
    chiThree = t:filterValuesInArray(currentCardsAfterTwo, chiTwo)
    -- print('chi 3 :', #chiThree)
    table.insert(copyChiType, p:checkType(chiThree))

    if checkBinhLung(copyChiType) ~= true then
      local tmp = convertChiToResult(chiOne, chiTwo, chiThree)

      -- if (#tmp ~= 13) then
      --   print('########', #tmp)
      --   print('########', copyChiType[1], copyChiType[2], copyChiType[3])

      --   os.exit()
      -- end
      table.insert(results, tmp)
      table.insert(chiTypes, copyChiType)
    end
    -- else 
      -- break
  end  
end

local function findResultsWithNewVersion(cards, results, chiTypes, scores)
  for i = 1, #TYPES - 1 do
    local currentKind = g:findCurrentKind(TYPES[i], cards)
    local tmp = t:shallowCopy(currentKind)

    for k = 1, #currentKind do
      local c = t:shallowCopy(currentKind[k])
      local tmpC = {}

      local chiOne = c
      local chiType = { TYPES[i] }
      local chiTwo = {}
      local chiThree = {}
      local currentCards = t:shallowCopy(cards)
      -- print('currrrrrrr:', #currentCards, #chiOne)
      currentCards = t:filterValuesInArray(currentCards, chiOne)
      -- print('currrrrssss:', #currentCards)

      tmpC = g:findCurrentKind(TYPES[i], currentCards)

      if (#tmpC) >= 1 then
        for j = 1, #tmpC do
          local copyChiType = t:shallowCopy(chiType)
          chiTwo = tmpC[j]

          if compare:isFirstStronger(chiOne, chiTwo, TYPES[i]) then
            local currentCardsAfterTwo = t:shallowCopy(currentCards)
            chiThree = t:filterValuesInArray(currentCardsAfterTwo, chiTwo)
            local typeThree = p:checkType(chiThree)
            table.insert(copyChiType, TYPES[i])
            table.insert(copyChiType, typeThree)

            if typeThree == TYPES[i] then
              if compare:isFirstStronger(chiTwo, chiThree, p:checkType(chiThree)) == true then
                  local tmp = convertChiToResult(chiOne, chiTwo, chiThree)

                  table.insert(results, tmp)
                  table.insert(chiTypes, copyChiType)
              end
            else
              -- if #(copyChiType) == 2 then
              --   print(#(chiOne))
              --   print(#(chiTwo))
              --   print(#(chiThree))
              -- end
              if checkBinhLung(copyChiType) ~= true then
                  local tmp = convertChiToResult(chiOne, chiTwo, chiThree)
                  -- local score = Game:countValue(chiOne, copyChiType[1], 1)
                  -- score = score + Game:countValue(chiTwo, copyChiType[2], 2)
                  -- score = score + Game:countValue(chiThree, copyChiType[3])

                  table.insert(results, tmp)
                  table.insert(chiTypes, copyChiType)
              end
            end
          else
            break
          end
        end
      end

      for idx = findIndexOfType(TYPES[i], TYPES) + 1, #(TYPES) do
        chiType = { TYPES[i] }
        findNextWithChiOne(results, chiOne, TYPES[idx], currentCards, chiType, chiTypes, scores, t:shallowCopy(cards))
      end
    end
  end
end

function Find:findCards(cards, oppCards, oppTypes)
  local results = {}
  local chiTypes = {}
  -- scores is meaning less but hard code
  local scores = {}

  local chiOneType = oppTypes[1]
  local chiTwoType = oppTypes[2]
  local chiThreeType = oppTypes[3]

  -- findResultsWithOldVersion(cards, results, chiTypes, scores)
  findResultsWithNewVersion(cards, results, chiTypes, scores)

  -- print('opp Cards: ')
  -- for i = 1, #oppCards do
  --   -- print(oppCards[i]['val'])
  -- end

  if isToiTrang(oppTypes) then
    local curr = handleOppToiTrang(oppTypes[1], cards)
    local text = ''

    if (curr == nil) then
      local binhLung = findBinhLung(results)
      text = readableData(binhLung, { 'binhLung', 'binhLung', 'binhLung' }, -6)
    else
      if (curr[2] == oppTypes[1]) then
        text = readableData(curr[1], { curr[2], curr[2], curr[2] }, 0)
      else
        text = readableData(curr[1], { curr[2], curr[2], curr[2] }, findToiTrangScore(curr[2]))
      end
    end

    writeResults(text)

    return
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

  local finalResult = handleFindFinalResult(results, chiTypes, scores, cards, saveIdx, saveScore)

  -- WRITE TO FILE
  -- writeEventsToFile(results, chiTypes, scores)

  return finalResult
end

return Find