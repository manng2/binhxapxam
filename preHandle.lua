PreHandle = {}

local T = require "tableObj"
t = T:new()

-- Derived class method new

function PreHandle:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PreHandle:findDoi(array)
    local results = {}
    local newArray = t:shallowCopy(array)
    local saveIdxes = {}

    for i = 1, #(newArray) - 1 do
        if newArray[i] ~= nil then
            for j = i + 1, #(newArray) do
                if newArray[j] ~= nil then
                    if newArray[i]['val'] == newArray[j]['val'] and t:hasValue(saveIdxes, i) ~= true then
                        -- print(newArray[i]['color'], newArray[i]['val'])
                        -- print(newArray[j]['color'], newArray[j]['val'])
                        table.insert(results, {newArray[i], newArray[j]})
                        -- lọc ra những đôi có thể giống nhau
                        table.insert(saveIdxes, i)
                        table.insert(saveIdxes, j)

                        -- newArray[i] = nil
                        -- newArray[j] = nil
                    end
                end
            end
        end
    end

    -- print('Doi: ', #(results))
    for i = 1, #results do
        print('-----')
        for j = 1, #results[i] do
            print(results[i][j]['val'], results[i][j]['att'])
        end
        print('-----')

    end
    return results
end

function PreHandle:findThu(array)
    local arrayDoi = PreHandle:findDoi(array)
    local results = {}

    if (#(arrayDoi) == 1) then return {} end

    for i = 1, #(arrayDoi) - 1 do
        for j = i + 1, #(arrayDoi) do
            if arrayDoi[i][1]['val'] ~= arrayDoi[j][1]['val'] then
                table.insert(results,
                             t:mergeDataInTwoArray(arrayDoi[i], arrayDoi[j]))
            end
        end
    end

    -- print('Thu: ', #(results))

    return results;
end

-- special case when find Sanh because of Xi
local function findSanhWithXi(array)
    local newArray = t:shallowCopy(array)

    if newArray[#(newArray)]['val'] ~= 14 then return {} end

    local idxXi = #(newArray)

    for i = #(newArray) - 1, 1, -1 do
        if newArray[i]['val'] == 14 then
            idxXi = i
        else
            break
        end
    end

    local result = {}

    for i = idxXi, #(newArray) do table.insert(result, newArray[i]) end

    local checkTwo, checkThree, checkFour, checkFive = false

    for i = 1, idxXi - 1 do
        if newArray[i]['val'] == 2 then
            table.insert(result, newArray[i])
            checkTwo = true
        elseif newArray[i]['val'] == 3 then
            table.insert(result, newArray[i])
            checkThree = true
        elseif newArray[i]['val'] == 4 then
            table.insert(result, newArray[i])
            checkFour = true
        elseif newArray[i]['val'] == 5 then
            table.insert(result, newArray[i])
            checkFive = true
        end
    end

    if checkTwo and checkThree and checkFour and checkFive then
        return result
    else
        return {}
    end
end

function PreHandle:findBaHoacBon(array, isFindTuQuy)
    local results = {}
    local newArray = t:shallowCopy(array)
    local count = 0
    local saveIdx = {}

    for i = 1, #(newArray) - 1 do
        count = 0
        local saveIdxTmp = {i}
        if newArray[i] ~= nil then
            count = count + 1
            for j = i + 1, #(newArray) do
                if newArray[j] ~= nil then
                    if newArray[j]['val'] == newArray[i]['val'] then
                        count = count + 1
                        table.insert(saveIdxTmp, j)
                        -- newArray[j] = nil
                    end
                end
            end

            if count >= 3 then
                for k = 1, #(saveIdxTmp) do
                    table.insert(saveIdx, saveIdxTmp[k])
                end
                -- print('xx', #(saveIdx), count)
                if count == 4 then
                    t:handleTuQuy(newArray, results, saveIdx, isFindTuQuy)
                elseif isFindTuQuy ~= true then
                    -- table.insert(saveIdx, i)

                    local tmp = {}
                    for k = 1, #(saveIdx) do
                        table.insert(tmp, newArray[saveIdx[k]])
                    end

                    local copyTmp = t:shallowCopy(tmp)
                    table.insert(results, copyTmp)
                end

                for k = 1, #(saveIdx) do
                    newArray[saveIdx[k]] = nil
                end

                saveIdx = {}
            end
        end
    end

    -- if isFindTuQuy then
    --   print('Tu Quy: ', #(results))
    -- else
    --   print('Sam Co: ', #(results))
    -- end

    -- for i = 1, #(results) do
    --   for j = 1, #(results[i]) do
    --     print(results[i][j]['val'], results[i][j]['att'])
    --   end
    --   print('-----')
    -- end
    return results
end

function PreHandle:findSanh(array)
    -- need improve to sortDesc
    local sortedArray = t:sortAsc(array)
    local results = {}
    local finalResults = {}
    local itr = 1

    -- for i = 1, #(sortedArray) do
    --   print(sortedArray[i]['val'], sortedArray[i]['att'])
    -- end
    -- print('-----')
    local i = 1

    while itr <= #(sortedArray) - 4 do
        i = itr
        -- print('now: ', sortedArray[i]['val'], i)
        local j = i + 1
        local tmp = {sortedArray[i]}
        local count = 1

        while (count < 5 and sortedArray[j]['val'] - sortedArray[i]['val'] <= 1) do
            if (sortedArray[j]['val'] - sortedArray[i]['val'] == 0) then
                table.insert(tmp, sortedArray[j])
                i = j
                j = j + 1
            else
                table.insert(tmp, sortedArray[j])
                i = j
                j = j + 1
                count = count + 1
            end

            if j > #(sortedArray) then break end
        end
        if (count == 5) then
            print(j, i)
            if j <= #(sortedArray) then
                while (sortedArray[j]['val'] == sortedArray[i]['val']) do
                    table.insert(tmp, sortedArray[j])
                    i = j
                    j = j + 1

                    if (j > #(sortedArray)) then break end
                end
            end

            if #(tmp) > 5 then
                local count = 1;
                while (tmp[1 + count]['val'] == tmp[1]['val']) do
                    count = count + 1
                end
                if count > 1 then itr = itr + count - 1 end
            end

            itr = itr + 1
            -- print('ne he', i)
            table.insert(results, t:shallowCopy(tmp))
            -- print('results: ', #(results))
        else
            itr = itr + 1
        end
    end

    -- for i = 1, #(results) do
    --   print('***************')
    --   for j = 1, #(results[i]) do
    --     print(results[i][j]['val'], results[i][j]['att'])
    --   end
    --   print('***************')
    -- end

    -- in case Xi
    local specialCase = findSanhWithXi(sortedArray)

    if #(specialCase) > 0 then table.insert(results, specialCase) end

    for i = 1, #(results) do
        local tmp = t:splitSanh(results[i])

        for j = 1, #(tmp) do table.insert(finalResults, tmp[j]) end
    end
    -- print('Sanh: ', #(finalResults))

    return finalResults

end

function PreHandle:findThung(array)
    local splittedArray = t:splitByColor(array)
    local redCards = splittedArray[1]
    local blackCards = splittedArray[2]
    local redThung = t:findThungByColorAndAtt(redCards)
    local blackThung = t:findThungByColorAndAtt(blackCards)

    local results = {}
    table.insert(results, redThung)
    table.insert(results, blackThung)
    -- print(#(redThung))
    -- print(#(blackThung))

    return results
end

function PreHandle:findCuLuComponents(array)
    local newArray = t:sortDesc(array)
    local value3 = newArray[1]['val']
    local value2 = newArray[#(newArray)]['val']
    local result = {}

    table.insert(result, value3)
    table.insert(result, value2)

    return result
end

-- is Valid

function PreHandle:isTuQuy(array)
    local count = 1
    for i = 1, #(array) - 1 do
        for j = i + 1, #(array) do
            if array[j]['val'] == array[i]['val'] then
                count = count + 1
            end
        end
    end

    return count == 6
end

function PreHandle:isCuLu(array)
    local count = 1

    for i = 1, #(array) - 1 do
        for j = i + 1, #(array) do
            if array[j]['val'] == array[i]['val'] then
                count = count + 1
            end
        end
    end

    return count == 5
end

function PreHandle:isSamCo(array)
    local count = 1

    for i = 1, #(array) - 1 do
        for j = i + 1, #(array) do
            if array[j]['val'] == array[i]['val'] then
                count = count + 1
            end
        end
    end

    return count == 4
end

function PreHandle:isThung(array)
    local flagAtt = array[1]['att']

    for i = 1, #(array) do
        if array[i]['att'] ~= flagAtt then return false end
    end

    return true
end

function PreHandle:isThungPhaSanh(array)
    return PreHandle:isThung(array) and PreHandle:isSanh(array)
end

function PreHandle:isSanh(array)
    local tmp = t:shallowCopy(array)
    tmp = t:sortAsc(tmp)

    for i = 1, #(tmp) - 1 do
        if tmp[i + 1]['val'] - tmp[i]['val'] > 1 then return false end
    end

    return true
end

function PreHandle:isThu(array)
    local count = 1

    for i = 1, #(array) - 1 do
        for j = i + 1, #(array) do
            if array[j]['val'] == array[i]['val'] then
                count = count + 1
            end
        end
    end

    return count == 3
end

function PreHandle:isValidInMauThau(array)
    local arrSize = #(array)

    for i = 1, arrSize - 1 do
        for j = i + 1, arrSize do
            if array[i]['val'] == array[j]['val'] then return false end
        end
    end

    if arrSize == 5 then
        if PreHandle:isThung(array) ~= true and PreHandle:isSanh(array) ~= true then
            return true
        else
            return false
        end
    end

    return true
end

function PreHandle:isMauThau(array) return PreHandle:isValidInMauThau(array) end

function PreHandle:isValidInThu(array)
    if PreHandle:isTuQuy(array) ~= true and PreHandle:isCuLu(array) ~= true and
        PreHandle:isSamCo(array) ~= true and PreHandle:isThung(array) then

        return true
    else
        return false
    end
end

function PreHandle:isValidDoi(array, checkValue)
    local count = 0
    for i = 1, #(array) do
        if array[i]['val'] == checkValue then count = count + 1 end
    end

    return count == 2
end

function PreHandle:isDoi(array)
    local count = 1
    for i = 1, #(array) - 1 do
        for j = i + 1, #(array) do
            if array[j]['val'] == array[i]['val'] then
                count = count + 1
            end
        end
    end

    return count == 2
end

function PreHandle:isValidInThung(array)
    local arrSize = #(array)

    -- check exist DOI
    for i = 1, arrSize - 1 do
        for j = i + 1, arrSize do
            if array[i]['val'] == array[j]['val'] then return false end
        end
    end

    -- check exist SANH
    if PreHandle:isSanh(array) then
        return false
    else
        return true
    end

end

-- sort zone
function PreHandle:sortTuQuy(array)
    local newArray = t:shallowCopy(array)
    local result = {}
    local tuQuyValue = nil
    local diffCard = nil

    for i = 1, #(newArray) - 1 do
        if newArray[i]['val'] == newArray[i + 1]['val'] then
            tuQuyValue = newArray[i]['val']
            break
        end
    end

    for i = 1, #(newArray) do
        if newArray[i]['val'] == tuQuyValue then
            table.insert(result, newArray[i])
        else
            diffCard = newArray[i]
        end
    end

    table.insert(result, diffCard)

    return result
end

function PreHandle:sortSamCo(array)
    -- da sort theo Desc
    local newArray = t:shallowCopy(array)
    local result = {}
    local samCoValue = nil
    local diffCards = {}

    for i = 1, #(newArray) - 1 do
        if newArray[i]['val'] == newArray[i + 1]['val'] then
            samCoValue = newArray[i]['val']
            break
        end
    end

    for i = 1, #(newArray) do
        if newArray[i]['val'] == samCoValue then
            table.insert(result, newArray[i])
        else
            table.insert(diffCards, newArray[i])
        end
    end

    table.insert(result, diffCards[1])
    table.insert(result, diffCards[2])

    return result
end

function PreHandle:sortThu(array)
    local newArray = t:shallowCopy(t:sortDesc(array))
    local result = {}
    local saveSame = {}
    local saveValueSame = {}

    for i = 1, #(newArray) - 1 do
        for j = i + 1, #(newArray) do
            if newArray[i]['val'] == newArray[j]['val'] then
                local tmp = {newArray[i], newArray[j]}
                table.insert(saveSame, tmp)
                table.insert(saveValueSame, newArray[i]['val'])

                break
            end
        end
    end

    for i = 1, #(saveSame) do
        for j = 1, #(saveSame[i]) do table.insert(result, saveSame[i][j]) end
    end

    for i = 1, #(newArray) do
        if t:hasValue(saveValueSame, newArray[i]['val']) ~= true then
            table.insert(result, newArray[i])
            break
        end
    end

    return result
end

function PreHandle:sortDoi(array)
    local newArray = t:shallowCopy(t:sortDesc(array))
    local result = {}
    local saveDoi = {}
    local doiValue = nil

    for i = 1, #(newArray) - 1 do
        for j = i + 1, #(newArray) do
            if array[i]['val'] == array[j]['val'] then
                table.insert(result, newArray[i])
                table.insert(result, newArray[j])
                doiValue = newArray[i]['val']

                break
            end
        end
    end

    for i = 1, #(newArray) do
        if newArray[i]['val'] ~= doiValue then
            table.insert(result, newArray[i])
        end
    end

    return result
end

local function convertChiToResult(chiOne, chiTwo, chiThree)
    local result = {}

    for i = 1, #(chiOne) do table.insert(result, chiOne[i]) end
    for i = 1, #(chiTwo) do table.insert(result, chiTwo[i]) end
    for i = 1, #(chiThree) do table.insert(result, chiThree[i]) end

    return result
end

function PreHandle:checkType(array)
    if #(array) == 5 then
        if PreHandle:isThungPhaSanh(array) then
            return 'thungPhaSanh'
        elseif PreHandle:isTuQuy(array) then
            return 'tuQuy'
        elseif PreHandle:isCuLu(array) then
            return 'cuLu'
        elseif PreHandle:isThung(array) then
            return 'thung'
        elseif PreHandle:isSanh(array) then
            return 'sanh'
        elseif PreHandle:isThu(array) then
            return 'thu'
        end
    end

    if PreHandle:isMauThau(array) then
        return 'mauThau'
    elseif PreHandle:isSamCo(array) then
        return 'samCo'
    elseif PreHandle:isDoi(array) then
        return 'doi'
    end
    -- return 'mauThau'
end

function PreHandle:handleChiThreeMauThau(chiOne, chiTwo, typeChiOne, typeChiTwo, afterCurrentCards, results, chiTypes, scores)
    print('current cards: ', #afterCurrentCards)
    afterCurrentCards = t:sortDesc(afterCurrentCards)
    local chiThree = {}
    local saveTmpThree = {}
    local saveTmpTwo = {}

    for i = 1, #chiThree do
        table.insert(saveTmpThree, chiThree[i]['val'])
    end

    for i = 1, #chiTwo do
        table.insert(saveTmpTwo, chiTwo[i]['val'])
    end

    print('------')
        print('hien tai chi One', #chiOne)
        print('hien tai chi Two', #chiTwo)
        print('hien tai chi Three', #chiThree)
    print('------')

    for i = 1, #afterCurrentCards do
        if t:hasValue(saveTmpThree, afterCurrentCards[i]['val']) ~= true and #chiThree < 3 then
            table.insert(chiThree, afterCurrentCards[i])
            table.insert(saveTmpThree, afterCurrentCards[i]['val'])
        end

        if #chiThree == 3 then
            break
        end
    end
    local typeChiThree = PreHandle:checkType(chiThree)

    print('1-----')
        print('hien tai chi One', #chiOne)
        print('hien tai chi Two', #chiTwo)
        print('hien tai chi Three', #chiThree)
    print('1-----')

    afterCurrentCards = t:filterValuesInArray(afterCurrentCards, chiThree)
    print('current cards: ', #afterCurrentCards)

    for i = 1, #afterCurrentCards do
        if t:hasValue(saveTmpTwo, afterCurrentCards[i]['val']) ~= true and #chiTwo < 5 then
            table.insert(chiTwo, afterCurrentCards[i])
            table.insert(saveTmpTwo, afterCurrentCards[i]['val'])
        end

        if #chiTwo == 5 then
            break
        end
    end

    if (typeChiTwo ~= PreHandle:checkType(chiTwo)) then
        print(PreHandle:checkType(chiTwo))
        return
    end

    print('2-----')
        print('hien tai chi One', #chiOne)
        print('hien tai chi Two', #chiTwo)
        print('hien tai chi Three', #chiThree)
    print('2-----')

    afterCurrentCards = t:filterValuesInArray(afterCurrentCards, chiTwo)
    print('current cards: ', #afterCurrentCards)

    for i = 1, #afterCurrentCards do
        table.insert(chiOne, afterCurrentCards[i])
    end

    if (typeChiOne ~= PreHandle:checkType(chiOne)) then
        return
    end

    print('3-----')
        print('hien tai chi One', #chiOne)
        print('hien tai chi Two', #chiTwo)
        print('hien tai chi Three', #chiThree)
    print('3-----')

    local converted = convertChiToResult(chiOne, chiTwo, chiThree)
    local types = { typeChiOne, typeChiTwo, PreHandle:checkType(chiThree) }

    table.insert(results, converted)
    table.insert(chiTypes, types)

    print('AFTER ADD')

    for i = 1, #converted do
        print(converted[i]['val'])
        if (i == 5) or i == 10 then
            print('--')
        end
    end

    print('END AFTER ADD')
end

function PreHandle:divideRacsTo3Chi(chiOne, chiTwo, chiThree, racs)
    local saveTmpChiOne = {}
    local saveTmpChiTwo = {}
    local saveTmpChiThree = {}

    local newChiOne = t:shallowCopy(chiOne)
    local newChiTwo = t:shallowCopy(chiTwo)
    local newChiThree = t:shallowCopy(chiThree)

    local saveTmp = {}

    for i = 1, #chiOne do
        table.insert(saveTmpChiOne, chiOne[i]['val'])
    end

    for i = 1, #chiTwo do
        table.insert(saveTmpChiTwo, chiTwo[i]['val'])
    end

    for i = 1, #chiThree do
        table.insert(saveTmpChiThree, chiThree[i]['val'])
    end

    print('1. len racs: ', #racs)

    print('chi 1: ', #newChiOne)
    print('chi 2: ', #newChiTwo)
    print('chi 3: ', #newChiThree)

    for i = 1, #racs do
        if #newChiThree == 3 then
            break
        end

        if t:hasValue(saveTmpChiThree, racs[i]['val']) ~= true then
            table.insert(newChiThree, racs[i])
            table.insert(saveTmp, racs[i])
            table.insert(saveTmpChiThree, racs[i]['val'])
        end
    end

    racs = t:filterValuesInArray(racs, saveTmp)
    saveTmp = {}

    print('2. len racs: ', #racs)

    print('chi 1: ', #newChiOne)
    print('chi 2: ', #newChiTwo)
    print('chi 3: ', #newChiThree)

    for i = 1, #racs do
        if #newChiTwo == 5 then
            break
        end

        if t:hasValue(saveTmpChiTwo, racs[i]['val']) ~= true then
            table.insert(newChiTwo, racs[i])
            table.insert(saveTmp, racs[i])
            table.insert(saveTmpChiTwo, racs[i]['val'])
        end
    end

    racs = t:filterValuesInArray(racs, saveTmp)
    saveTmp = {}

    print('3. len racs: ', #racs)

    print('chi 1: ', #newChiOne)
    print('chi 2: ', #newChiTwo)
    print('chi 3: ', #newChiThree)

    for i = 1, #racs do
        if #newChiOne == 5 then
            break
        end

        if t:hasValue(saveTmpChiOne, racs[i]['val']) ~= true then
            table.insert(newChiOne, racs[i])
            table.insert(saveTmp, racs[i])
            table.insert(saveTmpChiOne, racs[i]['val'])
        end
    end

    racs = t:filterValuesInArray(racs, saveTmp)

    print('len racs: ', #racs)
    print('-----------------')
    if (#newChiOne + #newChiTwo + #newChiThree == 13 and #racs == 0 ) then
        return { newChiOne, newChiTwo, newChiThree }
    end

    return {}
end

function PreHandle:isResultValid(chiOne, chiTwo, chiThree, types)
    -- if types[1] == 'samCo' and types[2] == 'samCo' and types[3] == 'samCo' then
    --     os.exit()
    -- end
    print(types[1], types[2], types[3])
    -- os.exit()
    return PreHandle:checkType(chiOne) == types[1] and
        PreHandle:checkType(chiTwo) == types[2] and
        PreHandle:checkType(chiThree) == types[3]
end

return PreHandle
