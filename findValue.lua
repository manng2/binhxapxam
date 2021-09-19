local Count = {}

local PreHandle = require "preHandle"
-- local Game = require "game"
local T = require "tableObj"
t = T:new()
p = PreHandle:new()
-- g = Game:new()

function Count:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

local thungPhaSanhMax = { 14, 13, 12, 11, 10 }
local tuQuyMax = { 14, 14, 14, 14, 13 }
local cuLuMax = { 14, 14, 14, 13, 13 }
local thungMax = { 14, 13, 12, 11, 9 }
local samCo5Max = { 14, 14, 14, 13, 12 }
local samCo3Max = { 14, 14, 14 }
local thuMax = { 14, 14, 13, 13, 12 }
local doi5Max = { 14, 14, 13, 12, 11 }
local doi3Max = { 14, 14, 13 }
local mauThau5Max = { 14, 13, 12, 11, 9 }
local mauThau3Max = { 14, 13, 12 }

-- [START] chi One zone
local thungPhaSanhInitPointChiOne = 4000
local thungPhaSanhInitStepChiOne = 5

local tuQuyInitPointChiOne = 3000
local tuQuyInitStepChiOne = 10

local cuLuInitPointChiOne = 2500
local cuLuInitStepChiOne = 10

local thungInitPointChiOne = 2000
local thungInitStepChiOne = 5

local samCo5InitPointChiOne = 1900
local samCo5InitStepChiOne = 3

local samCo3InitPointChiOne = 1850
local samCo3InitStepChiOne = 2

local thuInitPointChiOne = 1800
local thuInitStepChiOne = 7

local doi5InitPointChiOne = 1400
local doi5InitStepChiOne = 3

local doi3InitPointChiOne = 1000
local doi3InitStepChiOne = 4

local mauThau5InitPointChiOne = 700
local mauThau5InitStepChiOne = 3

local mauThau3InitPointChiOne = 300
local mauThau3InitStepChiOne = 3

-- [END] chi One zone

-- [START] chi Two zone
local thungPhaSanhInitPointChiTwo = 8000
local thungPhaSanhInitStepChiTwo = 10

local tuQuyInitPointChiOne = 6000
local tuQuyInitStepChiOne = 20

local cuLuInitPointChiTwo = 5000
local cuLuInitStepChiTwo = 15

local thungInitPointChiTwo = 4000
local thungInitStepChiTwo = 20

local samCo5InitPointChiTwo = 3800
local samCo5InitStepChiTwo = 7

local samCo3InitPointChiTwo = 3700
local samCo3InitStepChiTwo = 6

local thuInitPointChiTwo = 3600
local thuInitStepChiTwo = 12

local doi5InitPointChiTwo = 2800
local doi5InitStepChiTwo = 6

local doi3InitPointChiTwo = 2000
local doi3InitStepChiTwo = 9

local mauThau5InitPointChiTwo = 1400
local mauThau5InitStepChiTwo = 8

local mauThau3InitPointChiTwo = 600
local mauThau3InitStepChiTwo = 6
-- [END] chi Two zone

-- parameter array must be sort desc

local function copyArrayValue(array)
  local value = {}

  for i = 1, #(array) do
    table.insert(value, array[i]['val'])  
  end

  return value
end

function Count:thungPhaSanh(array, index, isFindThungPhaSanh)
  print('welcome thungPhaSanh')
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = thungPhaSanhInitPointChiOne
    stepInit = thungPhaSanhInitStepChiOne
  else
    maxInit = thungPhaSanhInitPointChiTwo
    stepInit = thungPhaSanhInitStepChiTwo
  end
  local newArray = t:sortDesc(array)
  local distance = (thungPhaSanhMax[1] - newArray[1]['val'])

  if distance == 0 then
    if (isFindThungPhaSanh) then
      if thungPhaSanhMax[2] ~= newArray[2]['val'] then
        distance = 1
      end
    else
      if thungPhaSanhMax[2] ~= newArray[2]['val'] then
        distance = 9
      end
    end
  end

  if (isFindThungPhaSanh) and thungPhaSanhMax[1] ~= newArray[1]['val'] then
    distance = distance + 1
  end  
  
  print('distance: ', distance)
  return maxInit - distance * stepInit

  -- return distance
end

function Count:tuQuy(array, index)
  print('welcome thungPhaSanh')

  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = tuQuyInitPointChiOne
    stepInit = tuQuyInitStepChiOne
  else
    maxInit = tuQuyInitPointChiTwo
    stepInit = tuQuyInitStepChiTwo
  end

  local sortedArray = p:sortTuQuy(array)
  local copyTuQuyMax = t:shallowCopy(tuQuyMax)
  local copyValueArray = copyArrayValue(sortedArray)
  local distance = 0

  -- for i = 1, #(copyValueArray) do
  --   print(copyValueArray[i], copyTuQuyMax[i])
  -- end

  if copyTuQuyMax[1] ~= copyValueArray[1] then
    while copyTuQuyMax[1] ~= copyValueArray[1] or copyTuQuyMax[5] ~= copyValueArray[5] do
      if copyTuQuyMax[5] - 1 >= 2 then
        copyTuQuyMax[5] = copyTuQuyMax[5] - 1
        if copyTuQuyMax[5] ~= copyTuQuyMax[1] then
          distance = distance + 1
          print(copyTuQuyMax[1], copyTuQuyMax[5])
        end
      else
        copyTuQuyMax[1] = copyTuQuyMax[1] - 1
        copyTuQuyMax[5] = 15
        repeat
          copyTuQuyMax[5] = copyTuQuyMax[5] - 1
          print('xxx', copyTuQuyMax[1], copyTuQuyMax[5])
        until copyTuQuyMax[1] ~= copyTuQuyMax[5]
        distance = distance + 1
      end
    end
  end

  -- distance = distance + copyTuQuyMax[5] - copyValueArray[5] + 1
  
  -- print('distance: ', distance)
  return maxInit - distance * stepInit

  -- return distance
end

function Count:cuLu(array, index)
  print('welcom cuLu: ')

  local newArray = t:sortDesc(array)

  local values = p:findCuLuComponents(newArray)
  local value3Max = cuLuMax[1]
  local value2Max = cuLuMax[5]
  local value3 = values[1]
  local value2 = values[2]

  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = cuLuInitPointChiOne
    stepInit = cuLuInitStepChiOne
  else
    maxInit = cuLuInitPointChiTwo
    stepInit = cuLuInitStepChiTwo
  end
  
  local distance = 0

  if value3 ~= value3Max then
    while value3 ~= value3Max or value2Max ~= value2 do
      if value2Max - 1 >= 2 then
        value2Max = value2Max - 1
        if (value2Max ~= value3Max) then
          distance = distance + 1
          print(value3Max, value2Max)
        end
      else 
        value3Max = value3Max - 1
        value2Max = 14
        print(value3Max, value2Max)
        distance = distance + 1
      end
    end
  end
  
  -- distance = distance + value2Max - value2

  print('distance: ', distance)

  return maxInit - distance * stepInit
end

local function checkIsMatching(arrayOne, arrayTwo)
  local newArrayOne = (arrayOne)
  local newArrayTwo = (arrayTwo)

  for i = 1, #(newArrayOne) do
    --array just contains value.
    -- print(newArrayOne[i], arrayTwo[i], '------', i)
    if newArrayOne[i] ~= newArrayTwo[i] then
      -- print('compare', arrayOne[i], arrayTwo[i])
      return false
    end
  end

  return true
end


function Count:thung(array, index)
  -- print('welcome thung')
  local newArray = t:sortDesc(array)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = thungInitPointChiOne
    stepInit = thungInitStepChiOne
  else
    maxInit = thungInitPointChiTwo
    stepInit = thungInitStepChiTwo
  end

  local copyThungMax = t:shallowCopy(thungMax)
  local copyValueArray = copyArrayValue(newArray)
  local distance = 0
    -- print(newArray[1], newArray[2], newArray[3], newArray[4], newArray[5])

  while checkIsMatching(copyThungMax, copyValueArray) ~= true do
    -- print(copyThungMax[1], copyThungMax[2], copyThungMax[3], copyThungMax[4], copyThungMax[5])
    if copyThungMax[5] - 1 >= 2 then
      distance = distance + 1
      copyThungMax[5] = copyThungMax[5] - 1
      -- print('xx', copyThungMax[5], distance)
    elseif copyThungMax[4] - 1 >= 3 then
      copyThungMax[4] = copyThungMax[4] - 1
      copyThungMax[5] = copyThungMax[4] - 1
      distance = distance + 1
      -- print('yy', copyThungMax[4], distance)
    elseif copyThungMax[3] - 1 >= 4 then
      copyThungMax[3] = copyThungMax[3] - 1
      copyThungMax[4] = copyThungMax[3] - 1
      copyThungMax[5] = copyThungMax[4] - 1
      distance = distance + 1
    elseif copyThungMax[2] - 1 >= 5 then
      copyThungMax[2] = copyThungMax[2] - 1
      copyThungMax[3] = copyThungMax[2] - 1
      copyThungMax[4] = copyThungMax[3] - 1
      copyThungMax[5] = copyThungMax[4] - 1
      distance = distance + 1
    elseif copyThungMax[1] - 1 >= 6 then
      copyThungMax[1] = copyThungMax[1] - 1
      copyThungMax[2] = copyThungMax[1] - 1
      copyThungMax[3] = copyThungMax[2] - 1
      copyThungMax[4] = copyThungMax[3] - 1
      copyThungMax[5] = copyThungMax[4] - 1
      
      distance = distance + 1
    end
  end
  -- print(copyThungMax[1], copyThungMax[2], copyThungMax[3], copyThungMax[4], copyThungMax[5])
  print('distance: ', distance)

  -- return distance
  return maxInit - distance * stepInit
end

local function findFailIndexSamCo5(array)
  -- print('-------')
  -- print(array[4], array[5])
  for i = 4, #(array) do
    if array[i] == array[1] then
      return i
    end
  end

  return 0
end

function Count:findNextInSamCo5(array)
  if (array[1] == 14 and array[2] == 14 and array[3] == 14 and array[4] == 3 and array[5] == 2) then
    array[1] = 13
    array[2] = 13
    array[3] = 13
    array[4] = 14
    array[5] = 12
  else
    if (array[5] - 1 == array[5] or array[5] - 1 < 2) and (array[5] - 2 == array[1] or array[5] - 2 < 2) then
      if (array[4] - 1 == array[1] or array[4] - 1 <= array[5]) and (array[4] - 2 == array[1] or array[4] - 2 <= array[5]) then
        array[1] = array[1] - 1
        array[2] = array[2] - 1
        array[3] = array[3] - 1
        array[4] = 14
        array[5] = 13
      elseif (array[4] - 1 == array[1]) then
        array[4] = array[4] - 2
      else
        array[4] = array[4] - 1
      end

      array[5] = array[4] - 1;
      while (array[5] == array[1]) do
        array[5] = array[5] - 1
      end

    elseif array[5] - 1 == array[1] then
      array[5] = array[5] - 2
    else
      array[5] = array[5] - 1
    end
  end

  -- print(array[1], array[2], array[3], array[4], array[5])

  return array
end

function Count:samCo5(array, index)
  local newArray = t:sortDesc(array)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = samCo5InitPointChiOne
    stepInit = samCo5InitStepChiOne
  else
    maxInit = samCo5InitPointChiTwo
    stepInit = samCo5InitStepChiTwo
  end

  local sortedArray = p:sortSamCo(newArray)
  local copysamCo5Max = t:shallowCopy(samCo5Max)
  local copyValueArray = copyArrayValue(sortedArray)
  local distance = 0

  local nextX = Count:findNextInSamCo5(copysamCo5Max)

  while checkIsMatching(nextX, copyValueArray) ~= true do
    -- print('sam co', distance)
    distance = distance + 1
    nextX = Count:findNextInSamCo5(nextX)
    
    -- print('------')
    -- print(nextX[1], nextX[2], nextX[3], nextX[4], nextX[5])
    -- print(copyValueArray[1], copyValueArray[2], copyValueArray[3], copyValueArray[4], copyValueArray[5])
    -- hard code
    if distance > 865 then
      break
    end
  end

  return maxInit - distance * stepInit
  -- return distance
end

function Count:samCo3(array, index)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = samCo3InitPointChiOne
    stepInit = samCo3InitStepChiOne
  else
    maxInit = samCo3InitPointChiTwo
    stepInit = samCo3InitStepChiTwo
  end

  local sortedArray = p:sortSamCo(array)
  local copysamCo3Max = t:shallowCopy(samCo3Max)
  local copyValueArray = copyArrayValue(sortedArray)
  local distance = copysamCo3Max[1] - copyValueArray[1]

  return maxInit - distance * stepInit
end

function Count:thu(array, index)
  local newArray = t:sortDesc(array)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = thuInitPointChiOne
    stepInit = thuInitStepChiOne
  else
    maxInit = thuInitPointChiTwo
    stepInit = thuInitStepChiTwo
  end
  
  local sortedArray = p:sortThu(newArray)
  local copyThuMax = t:shallowCopy(thuMax)
  local copyValueArray = copyArrayValue(sortedArray)
  local distance = 0

  while checkIsMatching(copyThuMax, copyValueArray) ~= true do
  -- print(copyThuMax[1], copyThuMax[2], copyThuMax[3], copyThuMax[4], copyThuMax[5])
    if copyThuMax[5] - 1 >= 2 then
      copyThuMax[5] = copyThuMax[5] - 1
      distance = distance + 1
      -- print('1212', copyThuMax[5])
    elseif copyThuMax[3] - 1 >= 2 then
      copyThuMax[5] = 15
      copyThuMax[3] = copyThuMax[3] - 1
      copyThuMax[4] = copyThuMax[4] - 1

      repeat
        copyThuMax[5] = copyThuMax[5] - 1
        local fakeData = {}
        for x = 1, 5 do
          local tmp = { val = copyThuMax[x] }
          -- print('---', copyThuMax[x])
          table.insert(fakeData, tmp)
        end
      until (p:isValidInThu(fakeData))
      distance = distance + 1
    elseif copyThuMax[1] - 1 >= 2 then
      copyThuMax[5] = 15
      copyThuMax[1] = copyThuMax[1] - 1
      copyThuMax[2] = copyThuMax[1]
      copyThuMax[3] = copyThuMax[2] - 1
      copyThuMax[4] = copyThuMax[3]

      repeat
        copyThuMax[5] = copyThuMax[5] - 1
        
        local fakeData = {}
        for x = 1, 5 do
          local tmp = { val = copyThuMax[x] }
          -- print('---', copyThuMax[x])
          table.insert(fakeData, tmp)
        end
        -- print(copyThuMax[1], copyThuMax[2], copyThuMax[3], copyThuMax[4], copyThuMax[5])
      until (p:isValidInThu(fakeData))
      distance = distance + 1
    end
  end

  -- return distance
  return maxInit - distance * stepInit

end

function findFailIndexInDoi5(array)
  for i = 3, #(array) do
    if array[i] == array[1] then
      return i
    end
  end

  return 0
end

function Count:findNextInDoi5(currentDoi5)

  --14 14 4 3 2 -> 13 13 14 12 11
  if (currentDoi5[1]== 14 and currentDoi5[2]== 14 and currentDoi5[3]== 4 and currentDoi5[4]== 3 and currentDoi5[5]== 2) then
      currentDoi5[1] = 13
      currentDoi5[2] = 13
      currentDoi5[3] = 14
      currentDoi5[4] = 12
      currentDoi5[5] = 11
  end

  --13 13 4 3 2 -> 12 12 14 13 11
  if (currentDoi5[1]== 13 and currentDoi5[2]== 13 and currentDoi5[3]== 4 and currentDoi5[4]== 3 and currentDoi5[5]== 2) then
      currentDoi5[1] = 12
      currentDoi5[2] = 12
      currentDoi5[3] = 14
      currentDoi5[4] = 13
      currentDoi5[5] = 11
  end
  
  if (currentDoi5[5] - 1 == currentDoi5[1] or currentDoi5[5] - 1 < 2) and (currentDoi5[5] - 2 == currentDoi5[1] or currentDoi5[5] - 2 < 2) then
    if (currentDoi5[4] - 1 == currentDoi5[1] or currentDoi5[4] - 1 <= currentDoi5[5]) and (currentDoi5[4] - 2 == currentDoi5[1] or currentDoi5[4] - 2 <= currentDoi5[5]) then
      if (currentDoi5[3] - 1 == currentDoi5[1] or currentDoi5[3] - 1 <= currentDoi5[4]) and (currentDoi5[3] - 2 == currentDoi5[1] or currentDoi5[3] - 2 <= currentDoi5[4]) then
        currentDoi5[1] = currentDoi5[1] - 1
        currentDoi5[2] = currentDoi5[2] - 1
        currentDoi5[3] = 14
        currentDoi5[4] = 13
        currentDoi5[5] = 12
      elseif currentDoi5[3] - 1 == currentDoi5[1] then
        currentDoi5[3] = currentDoi5[3] - 2
      else
        currentDoi5[3] = currentDoi5[3] - 1
      end

      currentDoi5[4] = currentDoi5[3] - 1;

      while (currentDoi5[4] == currentDoi5[1]) do
        currentDoi5[4] = currentDoi5[4] - 1
      end 
      currentDoi5[5] = currentDoi5[4] - 1;
    elseif currentDoi5[4] - 1 == currentDoi5[1] then
      currentDoi5[4] = currentDoi5[4] - 2
    else
      currentDoi5[4] = currentDoi5[4] - 1
    end

    currentDoi5[5] = currentDoi5[4] - 1
    while (currentDoi5[5] == currentDoi5[1]) do
      currentDoi5[5] = currentDoi5[5] - 1
    end 
  elseif currentDoi5[5] - 1 == currentDoi5[1] then
    currentDoi5[5] = currentDoi5[5] - 2
  else
    currentDoi5[5] = currentDoi5[5] - 1
    -- print(currentDoi5[1], currentDoi5[2], currentDoi5[3], currentDoi5[4], currentDoi5[5])
  end
  -- print(currentDoi5[1], currentDoi5[2], currentDoi5[3], currentDoi5[4], currentDoi5[5])
  
  return currentDoi5
end

function Count:doi5(array, index)
  local newArray = t:sortDesc(array)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = doi5InitPointChiOne
    stepInit = doi5InitStepChiOne
  else
    maxInit = doi5InitPointChiTwo
    stepInit = doi5InitStepChiTwo
  end

  local sortedArray = p:sortDoi(newArray)
  local copydoi5Max = t:shallowCopy(doi5Max)
  local copyValueArray = copyArrayValue(sortedArray)
  local distance = 0

  local nextX = Count:findNextInDoi5(copydoi5Max)

  while checkIsMatching(nextX, copyValueArray) ~= true do
    distance = distance + 1
    nextX = Count:findNextInDoi5(copydoi5Max)

  end

  -- return distance
  return maxInit - distance * stepInit
end

function Count:doi3(array, index)
  local newArray = t:sortDesc(array)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = doi3InitPointChiOne
    stepInit = doi3InitStepChiOne
  else
    maxInit = doi3InitPointChiTwo
    stepInit = doi3InitStepChiTwo
  end

  local sortedArray = p:sortDoi(newArray)
  local copydoi3Max = t:shallowCopy(doi3Max)
  local copyValueArray = copyArrayValue(sortedArray)
  local distance = 0
  
   if copydoi3Max[1] ~= copyValueArray[1] then
    while copydoi3Max[1] ~= copyValueArray[1] or copydoi3Max[3] ~= copyValueArray[3] do
      if copydoi3Max[3] - 1 >= 2 then
        copydoi3Max[3] = copydoi3Max[3] - 1
        distance = distance + 1
      else
        copydoi3Max[1] = copydoi3Max[1] - 1
        copydoi3Max[3] = 15
        repeat
          copydoi3Max[3] = copydoi3Max[3] - 1
          print(copydoi3Max[1], copydoi3Max[3])
        until copydoi3Max[1] ~= copydoi3Max[3]
        distance = distance + 1
      end
    end
  end

  -- distance = distance + copydoi3Max[3] - copyValueArray[3]

  return maxInit - distance * stepInit
  -- return distance

end
-- function Count:mauThau5(array, index)
--   local maxInit = nil
--   local stepInit = nil

--   if index == 1 then
--     maxInit = thuInitPointChiOne
--     stepInit = thuInitStepChiOne
--   else
--     maxInit = thuInitPointChiTwo
--     stepInit = thuInitStepChiTwo
--   end


-- end

function Count:mauThau3(array, index)
  local newArray = t:sortDesc(array)
  local maxInit = nil
  local stepInit = nil

  if index == 1 then
    maxInit = mauThau3InitPointChiOne
    stepInit = mauThau3InitStepChiOne
  else
    maxInit = mauThau3InitPointChiTwo
    stepInit = mauThau3InitStepChiTwo
  end

  local copyMauThau3Max = t:shallowCopy(mauThau3Max)
  local copyValueArray = copyArrayValue(newArray)
  local distance = 0

  while checkIsMatching(copyMauThau3Max, copyValueArray) ~= true do
      -- print(copyMauThau3Max[1], copyMauThau3Max[2], copyMauThau3Max[3])
    if copyMauThau3Max[3] - 1 >= 2 then
      copyMauThau3Max[3] = copyMauThau3Max[3] - 1
      distance = distance + 1
    elseif copyMauThau3Max[2] - 1 >= 3 then
      copyMauThau3Max[2] = copyMauThau3Max[2] - 1
      copyMauThau3Max[3] = copyMauThau3Max[2] - 1
      distance = distance + 1
    elseif copyMauThau3Max[1] - 1 >= 4 then
      copyMauThau3Max[1] = copyMauThau3Max[1] - 1
      copyMauThau3Max[2] = copyMauThau3Max[1] - 1
      copyMauThau3Max[3] = copyMauThau3Max[2] - 1
      distance = distance + 1
    end
  end
  print('distance: ', distance)
  return maxInit - distance * stepInit
end

return Count