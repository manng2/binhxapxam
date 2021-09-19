local Special = {
  containsSamCoTu2Den12 = false
}

local T = require "tableObj"
t = T:new()
local PreHandle = require "preHandle"
p = PreHandle:new()

-- mark zone


function Special:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

local function isLonXon(array, startNumber)
  for i = startNumber, #(array) - 1 do
    for j = i + 1, #(array) do
      if (array[j]['val'] == array[i]['val']) then
        return false
      end
    end
  end

  if #(array) > 3 then
    print('check ne dit me may')
    local markAtt = array[startNumber]['att']

    for i = startNumber + 1, #(array) do
      if (array[i]['att'] ~= markAtt) then
        return true
      end
    end
  end

  return false
end

-- tìm giá trị của đôi 3
local function find3Value(array)
  local newArray = t:sortDesc(array)
  local value = 0

  for i = 1, #(newArray) - 2 do
    print(newArray[i]['val'])
    if (
       newArray[i]['val'] ==  newArray[i + 1]['val'] and
       newArray[i + 2]['val'] ==  newArray[i + 1]['val']
    ) then
      if i == #(newArray) - 2 then
        value = newArray[i]['val']
      elseif newArray[i + 3]['val'] ~=  newArray[i + 2]['val'] then
        value = newArray[i]['val']
      end
    end
  end

  return value
end

local function convertChiToResult(chiOne, chiTwo, chiThree)
  local result = {}

  for i = 1, #(chiOne) do
    table.insert(result, chiOne[i])
  end
  for i = 1, #(chiTwo) do
    table.insert(result, chiTwo[i])
  end
  for i = 1, #(chiThree) do
    table.insert(result, chiThree[i])
  end

  return result
end

-- 14 14 14 13 13 13 ...
function Special:checkIsMauThauXivaGia(array)
  local newArray = t:sortDesc(array)

  if (
    newArray[1]['val'] == 14 and
    newArray[2]['val'] == 14 and
    newArray[3]['val'] == 14 and
    newArray[4]['val'] == 13 and
    newArray[5]['val'] == 13 and
    newArray[6]['val'] == 13
  ) then
    return isLonXon(newArray, 7)
  end

  return false
end

function Special:mauThauXivaGia(array)
  local newArray = t:sortDesc(array)

  local chiOne = { newArray[1], newArray[4], newArray[7], newArray[12], newArray[13]}
  local chiTwo = { newArray[2], newArray[5], newArray[8], newArray[10], newArray[11]}
  local chiThree = { newArray[3], newArray[6], newArray[9]}
  
  local chiType = { 'mauThau', 'mauThau', 'mauThau' }
  local converted = convertChiToResult(chiOne, chiTwo, chiThree)

  local result = { converted, chiType }

  return result
end

-- 3 lá giống nhau (2 -> 12)
function Special:checkIsSamCoTu2Den12(array)
  local value3 = find3Value(array)
  print('value3 ne: ', value3)
  local newArray = t:sortDesc(array)
  local checkArray = {}

  for i = 1, #(newArray) do
    if newArray[i]['val'] ~= value3 then
      table.insert(checkArray, newArray[i])
    end
  end

  return isLonXon(checkArray, 1)
end

function Special:samCoTu2Den12(array)
  local newArray = t:sortDesc(array)
  local value3 = find3Value(array)

  local chiOne = {}
  local chiTwo = {}
  local chiThree = {}

  for i = 1, #(newArray) do
    if newArray[i]['val'] == value3 then
      table.insert(chiOne, newArray[i])
    end
  end

  local lonXonArray = t:filterValuesInArray(newArray, chiOne)

  table.insert(chiOne, lonXonArray[9])
  table.insert(chiOne, lonXonArray[10])

  table.insert(chiTwo, lonXonArray[1])
  table.insert(chiTwo, lonXonArray[5])
  table.insert(chiTwo, lonXonArray[6])
  table.insert(chiTwo, lonXonArray[7])
  table.insert(chiTwo, lonXonArray[8])

  table.insert(chiThree, lonXonArray[2])
  table.insert(chiThree, lonXonArray[3])
  table.insert(chiThree, lonXonArray[4])

  local chiType = { 'samCo', 'mauThau', 'mauThau' }
  local converted = convertChiToResult(chiOne, chiTwo, chiThree)

  local result = { converted, chiType }

  return result
end

-- xử lý 2 chi rác và 1 chi bất kỳ
function Special:handle2ChiRac(chiOne, currentCards)
  local chiTwo = {}
  local chiThree = {}
  local sortedCards = t:sortDesc(currentCards)

  -- print('111111111')
  -- for i = 1, #(chiOne) do
  --   print(chiOne[i]['val'])
  -- end
  -- print('111111111')

  -- for i = 1,#(currentCards) do
  --   print(currentCards[i]['val'])
  -- end
  table.insert(chiTwo, sortedCards[1])
  table.insert(chiThree, sortedCards[2])

  for i = 3, #(sortedCards) do
    if #(chiThree) < 3 then
      table.insert(chiThree, sortedCards[i])
    else
      table.insert(chiTwo, sortedCards[i])
    end
  end

  if isLonXon(chiTwo, 1) ~= true or isLonXon(chiThree, 1) ~= true then
    return nil
  end

  local converted = convertChiToResult(chiOne, chiTwo, chiThree)

  local result = { converted }

  return result
end

-- 3, 4, 5 đôi
function Special:checkIsManyDoi(array, numberDoi)
  local doiCards = p:findDoi(array)
  local saveValues = {}

  for i = 1, #(array) - 1 do
    for j = i + 1, #(array) do
      if (array[j]['val'] == array[i]['val']) and t:hasValue(saveValues, array[j]['val']) ~= true then
        print(array[i]['val'])
        table.insert(saveValues, array[i]['val'])
      end
    end
  end

  return #(saveValues) == #(doiCards) and #(saveValues) == numberDoi
end

-- 4 đôi sẽ có 2 trường hợp

local function handle4Doi2Thu1MauThau(doiCards, currentCards)

  local chiOne = { doiCards[1], doiCards[2], doiCards[7], doiCards[8], currentCards[5] }
  local chiTwo = { doiCards[3], doiCards[4], doiCards[5], doiCards[6], currentCards[4] }
  local chiThree = { currentCards[1], currentCards[2], currentCards[3] }

  local converted = convertChiToResult(chiOne, chiTwo, chiThree)
  local types = { 'thu', 'thu', 'mauThau' }
  local result = { converted, types }

  return result
end

local function handle4Doi1Thu2Doi(doiCards, currentCards)

  local chiOne = { doiCards[5], doiCards[6], doiCards[7], doiCards[8], currentCards[5] }
  local chiTwo = { doiCards[1], doiCards[2], currentCards[2], currentCards[3], currentCards[4] }
  local chiThree = { doiCards[3], doiCards[4], currentCards[1] }

  local converted = convertChiToResult(chiOne, chiTwo, chiThree)
  local types = { 'thu', 'doi', 'doi' }
  local result = { converted, types }

  return result
end

function Special:handle4Doi(array)
  local doiCards = {}
  local newArray = t:sortDesc(array)

  print('-------')
  for i = 1, #(newArray) do
    print(newArray[i]['val'])
  end
  print('-------')

  for i = 1, #(newArray) - 1 do
    for j = i + 1, #(newArray) do
      if (newArray[i]['val'] == newArray[j]['val']) then
        table.insert(doiCards, newArray[i])
        table.insert(doiCards, newArray[j])
      end
    end
  end

  local currentCards = t:filterValuesInArray(array, doiCards)

  print('-------')
  for i = 1, #(currentCards) do
    print(currentCards[i]['val'])
  end
  print('-------')

  local results = { handle4Doi2Thu1MauThau(doiCards, currentCards), handle4Doi1Thu2Doi(doiCards, currentCards) }

  return results
end

return Special
