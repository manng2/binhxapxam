CompareAction = {}

local T = require "tableObj"
t = T:new()

local thungPhaSanhNearMax = { 14, 5, 4, 3, 2 }
local sanhMin = { 14, 5, 4, 3, 2 }
local thungPhaSanhMax = { 14, 13, 12, 11, 10 }

function CompareAction:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

local function doi(firstArray, secondArray) 
  local cardsDoiOne = {}
  local cardsDoiTwo = {}

  print(#firstArray, #secondArray)
  for i = 1, #(firstArray) - 1 do
    for j = i + 1, #(firstArray) do
      if firstArray[i]['val'] == firstArray[j]['val'] then
        table.insert(cardsDoiOne, firstArray[i])
        table.insert(cardsDoiOne, firstArray[j])
        break
      end
    end
  end

  for i = 1, #(secondArray) - 1 do
    for j = i + 1, #(secondArray) do 
      if secondArray[i]['val'] == secondArray[j]['val'] then
        table.insert(cardsDoiTwo, secondArray[i])
        table.insert(cardsDoiTwo, secondArray[j])

        break;
      end
    end
  end

  firstArray = t:filterValuesInArray(firstArray, cardsDoiOne)
  secondArray = t:filterValuesInArray(secondArray, cardsDoiTwo)

  if cardsDoiOne[1]['val'] > cardsDoiTwo[1]['val'] then
    return true
  elseif cardsDoiOne[1]['val'] < cardsDoiTwo[1]['val'] then
    return false
  else
    local minLen = #firstArray

    if (#secondArray < #firstArray) then
      minLen = #secondArray
    end

    for i = 1, minLen do
      print(firstArray[i]['val'], secondArray[i]['val'])
      if firstArray[i]['val'] > secondArray[i]['val'] then
        return true
      elseif firstArray[i]['val'] < secondArray[i]['val'] then
        return false
      end
    end
  end
end

local function thu(firstArray, secondArray)
  local cardsDoiOne = {}
  local cardsDoiTwo = {}

  for i = 1, #(firstArray) - 1 do
    for j = i + 1, #(firstArray) do
      if firstArray[i]['val'] == firstArray[j]['val'] then
        local tmp = { firstArray[i], firstArray[j] }
        table.insert(cardsDoiOne, tmp)
      end
      if secondArray[i]['val'] == secondArray[j]['val'] then
        local tmp = { secondArray[i], secondArray[j] }
        table.insert(cardsDoiTwo, tmp)
      end
    end
  end

  for i = 1, #(cardsDoiOne) do
    firstArray = t:filterValuesInArray(firstArray, cardsDoiOne[i])
  end
  for i = 1, #(cardsDoiTwo) do
    secondArray = t:filterValuesInArray(secondArray, cardsDoiTwo[i])
  end

  if cardsDoiOne[1][1]['val'] > cardsDoiTwo[1][1]['val'] then
    return true
  elseif cardsDoiOne[1][1]['val'] < cardsDoiTwo[1][1]['val'] then
    return false
  else
    if cardsDoiOne[2][1]['val'] > cardsDoiTwo[2][1]['val'] then
      return true
    elseif cardsDoiOne[2][1]['val'] < cardsDoiTwo[2][1]['val'] then
      return false
    else
      return firstArray[1]['val'] > secondArray[1]['val']
    end
  end
end

-- same to tu quy
local function samCo(firstArray, secondArray)
  local valueSamCoOne = 0
  local valueSamCoTwo = 0

  if #firstArray > #secondArray then
    return true
  end

  for i = 1, #(firstArray) - 1 do
    for j = i + 1, #(firstArray) do
      print(firstArray[i]['val'], firstArray[j]['val'])
      if firstArray[i]['val'] == firstArray[j]['val'] then
        valueSamCoOne = firstArray[i]['val']
        -- print('man', valueSamCoOne)
      end
      if secondArray[i]['val'] == secondArray[j]['val'] then
        valueSamCoTwo = secondArray[i]['val']
        -- print('ha', valueSamCoTwo)
      end
    end
  end

  return valueSamCoOne > valueSamCoTwo
end

local function checkIsSanhMin(array)
  for i = 1, 5 do
    if array[i]['val'] ~= sanhMin[i] then
      return false
    end
  end

  return true
end

-- same to thung
local function sanh(firstArray, secondArray, isCompareSanh)

  if isCompareSanh then
    local isSanhMinFirst = checkIsSanhMin(firstArray)
    local isSanhMinSecond = checkIsSanhMin(secondArray)

    if isSanhMinFirst and isSanhMinSecond then
      return true
    elseif isSanhMinFirst then
      return false
    elseif isSanhMinSecond then
      return true
    end
  end
  -- print('1', #(firstArray))
  -- print('2', #(secondArray))

  for i = 1, #(firstArray) do
    if firstArray[i]['val'] > secondArray[i]['val'] then
      return true
    elseif firstArray[i]['val'] < secondArray[i]['val'] then
      return false
    end
  end

end

local function checkIsThungPhaSanhNearMax(array)
  for i = 1, 5 do
    if array[i]['val'] ~= thungPhaSanhNearMax[i] then
      return false
    end
  end
end

local function checkIsThungPhaSanhMax(array)
  for i = 1, 5 do
    if array[i]['val'] ~=  thungPhaSanhMax[i] then
      return false
    end
  end
end

local function thungPhaSanh(firstArray, secondArray)
  local isFirstArrayNearMax = checkIsThungPhaSanhNearMax(firstArray)
  local isSecondArrayNearMax = checkIsThungPhaSanhNearMax(secondArray)
  local isFirstArrayMax = checkIsThungPhaSanhMax(firstArray)
  local isSecondArrayMax = checkIsThungPhaSanhMax(secondArray)

  if isFirstArrayNearMax and isSecondArrayNearMax then
    return true
  elseif isFirstArrayNearMax then
    if isSecondArrayMax then
      return false
    else
      return true
    end
  elseif isSecondArrayNearMax then
    if isFirstArrayMax then
      return true
    else
      return false
    end
  end

  if firstArray[1]['val'] >= secondArray[1]['val'] then
    return true
  else
    return false
  end
end

function CompareAction:isFirstStronger(firstArray, secondArray, type)
  local newFirstArray = t:sortDesc(firstArray)
  local newSecondArray = t:sortDesc(secondArray)
  local minSize = #(firstArray)

  if #(secondArray) < minSize then
    minSize = #(secondArray)
  end

  -- print('1', #(newFirstArray))
  -- print('2', #(newSecondArray))
  if type == 'doi' then
    return doi(newFirstArray, newSecondArray)
  elseif type == 'thu' then
    return thu(newFirstArray, newSecondArray)
  elseif type == 'samCo' or type == 'tuQuy' then
    return samCo(newFirstArray, newSecondArray)
  elseif type == 'sanh' then
    return sanh(newFirstArray, newSecondArray, true)
  elseif type == 'thung' then
    return sanh(newFirstArray, newSecondArray, false)
  elseif type == 'thungPhaSanh' then
    return thungPhaSanh(newFirstArray, newSecondArray)
  else
    for i = 1, minSize do
      -- if minSize == 3 then
      --   print('-----------------------------------------------')
      --   print('--', #(newFirstArray))
      --   print(newFirstArray[i]['val'], newFirstArray[i]['att'])
      --   print('--', #(newSecondArray))
      --   print(newSecondArray[i]['val'], newSecondArray[i]['att'])
      --   print('-----------------------------------------------')
      -- end
      if newFirstArray[i]['val'] == 11 and newFirstArray[i]['att'] == 2 and newSecondArray[i]['val'] == 13 and newSecondArray[i]['att'] == 2 then
        print('dm m', newFirstArray[i]['val'] > newSecondArray[i]['val'])
      end
      if newFirstArray[i]['val'] > newSecondArray[i]['val'] then
        return true
      elseif newFirstArray[i]['val'] < newSecondArray[i]['val'] then
        return false
      end
    end
  end
end

return CompareAction