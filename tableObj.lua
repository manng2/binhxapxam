local T = {}

function T:new (o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function T:shallowCopy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function T:mergeDataInTwoArray(arrayOne, arrayTwo)
  local newArrayOne = T:shallowCopy(arrayOne)
  local newArrayTwo = T:shallowCopy(arrayTwo)
  local results = {}

  for i = 1, #(newArrayOne) do
    table.insert(results, newArrayOne[i])
  end

  for i = 1, #(newArrayTwo) do
    table.insert(results, newArrayTwo[i])
  end

  return results
end

function T:handleTuQuy(array, results, indexesArray, isFindTuQuy)
  local newArray = T:shallowCopy(array)

  -- for i = 1, #(indexesArray) do
  --   print('haizzz', indexesArray[i])
  -- end
  if isFindTuQuy ~= true then
    -- lọc ra những bộ ba
    table.insert(results, { newArray[indexesArray[1]], newArray[indexesArray[2]], newArray[indexesArray[3]] })
    -- table.insert(results, { newArray[indexesArray[1]], newArray[indexesArray[2]], newArray[indexesArray[4]] })
    -- table.insert(results, { newArray[indexesArray[1]], newArray[indexesArray[3]], newArray[indexesArray[4]] })
    -- table.insert(results, { newArray[indexesArray[2]], newArray[indexesArray[3]], newArray[indexesArray[4]] })
  else
    local tuquy = {}
    for i = 1, #(indexesArray) do
      table.insert(tuquy, newArray[indexesArray[i]])
    end

    table.insert(results, tuquy)
  end
end

function T:sortDesc(array)
  local newArray = T:shallowCopy(array)
  
  for i = 1, #(newArray) - 1 do
    for j = i + 1, #(newArray) do
      if newArray[j]['val'] > newArray[i]['val'] then
        local tmp = T:shallowCopy(newArray[i])
        newArray[i] = T:shallowCopy(newArray[j])
        newArray[j] = T:shallowCopy(tmp)
      end
    end
  end

  return newArray
end

function T:sortDescWithValueArray(array)
  local newArray = T:shallowCopy(array)
  
  for i = 1, #(newArray) - 1 do
    for j = i + 1, #(newArray) do
      if newArray[j] > newArray[i] then
        local tmp = (newArray[i])
        newArray[i] = (newArray[j])
        newArray[j] = (tmp)
      end
    end
  end

  return newArray
end

function T:sortAsc(array)
  local newArray = T:shallowCopy(array)

  for i = 1, #(newArray) - 1 do
    for j = i + 1, #(newArray) do
      if newArray[j]['val'] < newArray[i]['val'] then
        local tmp = T:shallowCopy(newArray[i])
        newArray[i] = T:shallowCopy(newArray[j])
        newArray[j] = T:shallowCopy(tmp)
      end
    end
  end

  return newArray
end

function T:hasValue(table, val)
  for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

function T:splitItemsInArray(arr, isSameItems)
  local newArray = T:shallowCopy(arr)
  local sameItems = {}
  local diffItems = {}
  local saveSameItemsValue = {}

  for i = 1, #(newArray) - 1 do
    if T:hasValue(saveSameItemsValue, newArray[i]['val']) ~= true then
      local tmp = { newArray[i] }

      for j = i + 1, #(newArray) do
        if newArray[j]['val'] == newArray[i]['val'] then
          table.insert(tmp, newArray[j])
          table.insert(saveSameItemsValue, newArray[j]['val'])

        end
      end

      if (#(tmp) > 1) then
        table.insert(sameItems, T:shallowCopy(tmp))
      else
        table.insert(diffItems, newArray[i])
      end
    end
    
  end

  if T:hasValue(saveSameItemsValue, newArray[#(newArray)]['val']) ~= true then
    table.insert(diffItems, newArray[#(newArray)])
  end

  -- print('Diff: ', #(diffItems))
  -- print('Same: ', #(sameItems))

  if isSameItems == true then
    return sameItems
  end

  return diffItems
end

function T:spreadArray(array)
  local result = {}
  for i = 1, #(array) do
    table.insert(result, array[i])
  end

  return result
end

function T:findIndex(arr, value)
  for i = 1, #(arr) do
    if arr[i] == value then
      return i
    end
  end
end


function T:filterItemWithLen(arr, len)
  local result = {}
  
  for i = 1, #(arr) do
    if #(arr[i]) == len then
      table.insert(result, arr[i])
    end
  end

  return result
end

function T:mergeDiffItemsAndSameItems(sameItems, diffItems)
  if #(sameItems) == 0 then
    return diffItems
  end

  local indexes = {}
  local infiniteValues = {}
  local tmp = {}

  table.insert(tmp, T:shallowCopy(diffItems))
  
  -- print('tmp len: ', #(tmp))
  -- print('diff len: ', #(diffItems))
  -- print('same len: ', #(sameItems))
  print('\n')

  local saves = {}
  -- table.insert(saves, T:shallowCopy(tmp))

  for i = 1, #(sameItems) do
    if #(saves) > 0 then
      tmp = T:shallowCopy(saves)
    end
    saves = {}
  
    for j = 1, #(sameItems[i]) do
      -- print('before insert: ', #(tmp))
      -- print('----len tmp', #(tmp))
      local childTmp = {}
      for k = 1, #(tmp) do
        local x = T:shallowCopy(tmp[k])
        -- print('insert ', sameItems[i][j]['val'], 'to ', 'tmp[', k, ']')
        table.insert(x, sameItems[i][j])
        -- print('len x: ', #(x))
        table.insert(childTmp, x)
        -- print('len childTmp: ', #(childTmp))
        
      end
      for idx = 1, #(childTmp) do
        table.insert(saves, childTmp[idx])
      end
      -- print('after insert: ', #(saves), '\n')
    end
  end  

  for i = 1, #(saves) do
    saves[i] = T:sortAsc(saves[i])
  end

  -- for i = 1, #(saves) do
  --   print('++++++++++++++++++++++')
  --   for j = 1, #(saves[i]) do
  --     print(saves[i][j]['val'])
  --   end
  --   print('++++++++++++++++++++++')
  -- end
  -- print('len tmp now: ', #(saves))
  print('\n')

  return saves;
end

function T:splitSanh(sanhArray)
  local newArray = T:shallowCopy(sanhArray)
  local results = {}

  if #(newArray) > 5 then
    local sameItems = T:splitItemsInArray(newArray, true)
    -- print('sameeee')
    -- for i = 1, #(sameItems) do
    --   for j = 1, #(sameItems[i]) do
    --     print(sameItems[i][j]['val'])
    --   end
    -- end
    -- print('sameeee')

    local diffItems = T:splitItemsInArray(newArray, false)

    -- print('diff')
    -- for i = 1, #(diffItems) do
    --   print(diffItems[i]['val'])
    -- end
    -- print('diff')

    results = T:mergeDiffItemsAndSameItems(sameItems, diffItems)
  else
    local x = {}
    table.insert(x, T:shallowCopy(newArray))
    results = x
  end

  -- print('do dai: ', #(results))

  return results;
end 

function T:splitByColor(array)
  -- 0: red
  -- 1: black

  local newArray = T:shallowCopy(array)
  local blackCards = {}
  local redCards = {}
  local results = {}

  for i = 1, #(newArray) do
    local card = newArray[i]

    if card['color'] == 0 then
      table.insert(redCards, card)
    else
      table.insert(blackCards, card)
    end
  end

  table.insert(results, redCards)
  table.insert(results, blackCards)

  return results
end

-- function T:splitByAtt(array)
--   local newArray = T:shallowCopy(array)
--   local 
-- end

function T:removeItemFromArray(array, item)
  local results = {}

  for i = 1, #(array) do
    if array[i]['val'] ~= item['val'] then
      table.insert(results, array[i])
    elseif array[i]['att'] ~= item['att'] then
      table.insert(results, array[i])
    end
  end

  return results
end

function T:filterValuesInArray(array, target)

  print('RRAY: ')
  for i = 1, #array do
    print(array[i]['val'], array[i]['att'])
  end
  print('end')

  print('target: ')
  for i = 1, #target do
    print(target[i]['val'], target[i]['att'])
  end
  print('end')
  local results = T:shallowCopy(array)

  for i = 1, #(target) do
    results = T:removeItemFromArray(results, target[i])
    -- print('after', #(results))
  end

  return T:sortDesc(results)
end

function T:splitByChi(cards)
  local chiOne = { cards[1], cards[2], cards[3], cards[4], cards[5] }
  local chiTwo = { cards[6], cards[7], cards[8], cards[9], cards[10] }
  local chiThree = { cards[11], cards[12], cards[13] }

  return {
    chiOne, chiTwo, chiThree
  }
end


local function isSameAtt(array)
  local newArray = T:shallowCopy(array)

  for i = 1, #(newArray) - 1 do
    for j = i + 1, #(newArray) do
      if newArray[j]['att'] ~= newArray[i]['att'] then
        return false
      end
    end
  end

  return true
end

function T:findThungByColorAndAtt(array)
  local arraySize = #(array)

  if arraySize < 5 then
    return {}
  end

  local results = {}

  for a = 1, arraySize - 4 do
    for b = a + 1, arraySize - 3 do
      for c = b + 1, arraySize - 2 do
        for d = c + 1, arraySize - 1 do
          for e = d + 1, arraySize do
            local tmp = { array[a], array[b], array[c], array[d], array[e] }

            if isSameAtt(tmp) then
              table.insert(results, tmp)
            end
          end
        end
      end
    end
  end

  return results
end

function T:compareTwoArray(arrayOne, arrayTwo)
  print('VIEW ZONE')
  for i = 1, #arrayOne do
    print(arrayOne[i])
  end
  print('----')
  for i = 1, #arrayTwo do
    print(arrayTwo[i])
  end

  for i = 1, #arrayOne do
    if (arrayOne[i] ~= arrayTwo[i]) then
      -- os.exit()
      return false
    end
  end

  return true
end

return T
