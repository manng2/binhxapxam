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

        for j = 1, #(tmp) do table.insert(finalResults, t:sortDesc(tmp[j])) end
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

    for i = 1, #redThung do
        if (PreHandle:isSanh(redThung[i]) ~= true) then
            table.insert(results, redThung[i])
        end
    end
    for i = 1, #blackThung do
        if (PreHandle:isSanh(blackThung[i]) ~= true) then
            table.insert(results, blackThung[i])
        end
    end

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
    local count = 0
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

    if (tmp[1]['val'] == 2 and tmp[2]['val'] == 3 and tmp[3]['val'] == 4 and tmp[4]['val'] == 5 and tmp[5]['val'] == 14) then
        return true
    end

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



function PreHandle:divideRacsTo3Chi(chiOne, chiTwo, chiThree, racs, types)
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

    -- hard code when cannot fill to chi Two

    if (#newChiTwo < 5) then
        return {}
    end

    -- end hard code

    for i = 1, #racs do
        if #newChiOne == 5 then
            break
        end

        if t:hasValue(saveTmpChiOne, racs[i]['val']) then

            local tmp = t:shallowCopy(newChiTwo[5])
            newChiTwo[5] = t:shallowCopy(racs[i])
            racs[i] = t:shallowCopy(tmp)
        end
        table.insert(newChiOne, racs[i])
        table.insert(saveTmp, racs[i])
        table.insert(saveTmpChiOne, racs[i]['val'])
        -- if t:hasValue(saveTmpChiOne, racs[i]['val']) ~= true then
            -- table.insert(newChiOne, racs[i])
            -- table.insert(saveTmp, racs[i])
            -- table.insert(saveTmpChiOne, racs[i]['val'])
        -- end
    end

    racs = t:filterValuesInArray(racs, saveTmp)

    print('len racs: ', #racs)
    print('-----------------')

    for i = 1, #newChiOne do
        print(types[1])
        print(newChiOne[i]['val'])
    end
    for i = 1, #newChiTwo do
        print(types[2])
        print(newChiTwo[i]['val'])
    end
    for i = 1, #newChiThree do
        print(types[3])
        print(newChiThree[i]['val'])
    end
    print('-----------------')

    if (#newChiOne + #newChiTwo + #newChiThree == 13 and #racs == 0 ) then
        if (types ~= nil) then
            if (PreHandle:isResultValid(newChiOne, newChiTwo, newChiThree, types)) then
                return { newChiOne, newChiTwo, newChiThree }
            end
        end
    end

    return {}
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

function PreHandle:handleChiThreeSamCo(chiOne, chiTwo, typeChiOne, typeChiTwo, afterCurrentCards, results, chiTypes, scores)
    afterCurrentCards = t:sortDesc(afterCurrentCards)
    local samCoArray = PreHandle:findBaHoacBon(afterCurrentCards, false)
    local chiThree = {}
    local types = { typeChiOne, typeChiTwo, 'samCo' }

    for i = 1, #samCoArray do
        chiThree = samCoArray[i]
        local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
        local arrayAfterFillRacs = PreHandle:divideRacsTo3Chi(chiOne, chiTwo, chiThree, racs, types)

        if (#arrayAfterFillRacs > 0) then
            local newChiOne = arrayAfterFillRacs[1]
            local newChiTwo = arrayAfterFillRacs[2]
            local newChiThree = arrayAfterFillRacs[3]

            local converted = convertChiToResult(newChiOne, newChiTwo, newChiThree)

            table.insert(results, converted)
            table.insert(chiTypes, types)
        end
    end
end

function PreHandle:divideRacsTo3ChiWithChiTwoQKA(chiOne, chiTwo, chiThree, racs, types, results, chiTypes)

    -- THIS IS SEPCIAL CASE, CHI THREE ALWAYS HAVE 2 ELEMENTS
    print('vai lz')
    print(#chiOne, #chiTwo, #chiThree)
    local saveTmpChiOne = {}
    local saveTmpChiTwo = {}
    local saveTmpChiThree = {}

    local newChiOne = t:shallowCopy(chiOne)
    local newChiTwo = t:shallowCopy(chiTwo)
    local newChiThree = t:shallowCopy(chiThree)

    local saveTmp = {}

    print('CHI 1 NE')
    for i = 1, #chiOne do
        print(chiOne[i]['val'], chiOne[i]['att'])
        table.insert(saveTmpChiOne, chiOne[i]['val'])
    end
    print('end chi 1')

    print('CHI 2 NE')
    for i = 1, #chiTwo do
        print(chiTwo[i]['val'], chiTwo[i]['att'])
        table.insert(saveTmpChiTwo, chiTwo[i]['val'])
    end
    print('end chi 2')

    print('CHI 3 NE')
    for i = 1, #chiThree do
        print(chiThree[i]['val'], chiThree[i]['att'])
        table.insert(saveTmpChiThree, chiThree[i]['val'])
    end
    print('end chi 3')

    for i = #racs, 1, -1 do
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
    saveTmp = {}

    for i = 1, #racs do
        if (t:hasValue(saveTmpChiThree, racs[i]['val']) ~= true and #newChiThree ~= 3) then
            table.insert(newChiThree, racs[i])
            print('con lai: ', #racs)
            print('insert chi 3: ', racs[i]['val'], ' - ', racs[i]['att'])

            local currentCards = t:filterValuesInArray(racs, { racs[i] })
            local copySaveTmpChiTwo = t:shallowCopy(saveTmpChiTwo)

            print('currentCards: ', #currentCards)
            for j = 1, #currentCards do
                if (t:hasValue(saveTmpChiTwo, currentCards[j]['val']) ~= true) then
                    table.insert(newChiTwo, currentCards[j])
                    print('insert: ', currentCards[j]['val'], ' - ', currentCards[j]['att'])
                    print('INSERTED TO CHI 2', #newChiTwo)
                    table.insert(saveTmpChiTwo, currentCards[j]['val'])
                else
                    print('ko hop le', #newChiTwo)
                    break
                end
            end

            print('len chi 2', #newChiTwo)
            -- in case add success
            if #newChiTwo == 5 then
                local converted = convertChiToResult(newChiOne, newChiTwo, newChiThree)
                table.insert(results, converted)
                table.insert(chiTypes, types)
                print('ADDED')
            end
            saveTmpChiTwo = t:shallowCopy(copySaveTmpChiTwo)
            newChiTwo = t:shallowCopy(chiTwo)
            newChiThree = t:shallowCopy(chiThree)
        end
        print('-----------------')
    end
end

function PreHandle:handleChiThreeDoi(chiOne, chiTwo, typeChiOne, typeChiTwo, afterCurrentCards, results, chiTypes, scores)
    afterCurrentCards = t:sortDesc(afterCurrentCards)
    local doiArray = PreHandle:findDoi(afterCurrentCards)
    local chiThree = {}
    local types = { typeChiOne, typeChiTwo, 'doi' }

    for i = 1, #doiArray do
        chiThree = doiArray[i]
        local racs = t:filterValuesInArray(afterCurrentCards, chiThree)

        for k = 1, #chiOne do
            print(chiOne[k]['val'], chiOne[k]['att'])
        end
        print('-----', typeChiOne)
        for x = 1, #chiTwo do
            print(chiTwo[x]['val'], chiTwo[x]['att'])
        end
        print('-----', typeChiTwo)
        for n = 1, #chiThree do
            print(chiThree[n]['val'], chiThree[n]['att'])
        end
        -- print('-----')
        -- print('xxxxxx')
        -- os.exit()
        local arrayAfterFillRacs = {}

        if (specialCase:checkChiTwoIsQKA(chiTwo)) then
            PreHandle:divideRacsTo3ChiWithChiTwoQKA(chiOne, chiTwo, chiThree, racs, types, results, chiTypes)

            return;
        else
            arrayAfterFillRacs = PreHandle:divideRacsTo3Chi(chiOne, chiTwo, chiThree, racs, types)
        end

        print('spnds', #arrayAfterFillRacs)
        if (#arrayAfterFillRacs > 0) then
            -- print('brohhhh')
            -- os.exit()
            local newChiOne = arrayAfterFillRacs[1]
            local newChiTwo = arrayAfterFillRacs[2]
            local newChiThree = arrayAfterFillRacs[3]

            local converted = convertChiToResult(newChiOne, newChiTwo, newChiThree)
            print('---m---')
            for i = 1, #converted do
                print(converted[i]['val'], converted[i]['att'])
            end
            print('---m---')

            table.insert(results, converted)
            table.insert(chiTypes, types)
        end
    end
end

function PreHandle:handleChiThreeMauThau(chiOne, chiTwo, typeChiOne, typeChiTwo, afterCurrentCards, results, chiTypes, scores)
    -- print('current cards: ', #afterCurrentCards)
    local copyChiOne = t:shallowCopy(chiOne)
    local copyChiTwo = t:shallowCopy(chiTwo)

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
        print('hien tai chi One', #copyChiOne)
        print('hien tai chi Two', #copyChiTwo)
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
        print('hien tai chi One', #copyChiOne)
        print('hien tai chi Two', #copyChiTwo)
        print('hien tai chi Three', #chiThree)
    print('1-----')

    afterCurrentCards = t:filterValuesInArray(afterCurrentCards, chiThree)
    print('current cards: ', #afterCurrentCards)

    for i = 1, #afterCurrentCards do
        if t:hasValue(saveTmpTwo, afterCurrentCards[i]['val']) ~= true and #chiTwo < 5 then
            table.insert(copyChiTwo, afterCurrentCards[i])
            table.insert(saveTmpTwo, afterCurrentCards[i]['val'])
        end

        if #copyChiTwo == 5 then
            break
        end
    end

    if (typeChiTwo ~= PreHandle:checkType(copyChiTwo)) then
        print(PreHandle:checkType(copyChiTwo))
        return
    end

    print('2-----')
        print('hien tai chi One', #chiOne)
        print('hien tai chi Two', #copyChiTwo)
        print('hien tai chi Three', #chiThree)
    print('2-----')

    afterCurrentCards = t:filterValuesInArray(afterCurrentCards, copyChiTwo)
    print('current cards: ', #afterCurrentCards)

    for i = 1, #afterCurrentCards do
        table.insert(copyChiOne, afterCurrentCards[i])
    end

    if (typeChiOne ~= PreHandle:checkType(copyChiOne)) then
        return
    end

    print('3-----')
        print('hien tai chi One', #copyChiOne)
        print('hien tai chi Two', #copyChiTwo)
        print('hien tai chi Three', #chiThree)
    print('3-----')

    local converted = convertChiToResult(copyChiOne, copyChiTwo, chiThree)
    local types = { typeChiOne, typeChiTwo, PreHandle:checkType(chiThree) }

    table.insert(results, converted)
    table.insert(chiTypes, types)

    -- print('AFTER ADD')

    -- for i = 1, #converted do
    --     print(converted[i]['val'])
    --     if (i == 5) or i == 10 then
    --         print('--')
    --     end
    -- end

    -- print('END AFTER ADD')
end

-- function PreHandle:divideRacsTo3Chi(chiOne, chiTwo, chiThree, racs)
--     local itr = 1
--     local saveTmpChiOne = {}
--     local saveTmpChiTwo = {}
--     local saveTmpChiThree = {}

--     local newChiOne = t:shallowCopy(chiOne)
--     local newChiTwo = t:shallowCopy(chiTwo)
--     local newChiThree = t:shallowCopy(chiThree)

--     local saveTmp = {}

--     for i = 1, #chiOne do
--         table.insert(saveTmpChiOne, chiOne[i]['val'])
--     end

--     for i = 1, #chiTwo do
--         table.insert(saveTmpChiTwo, chiTwo[i]['val'])
--     end

--     for i = 1, #chiThree do
--         table.insert(saveTmpChiThree, chiThree[i]['val'])
--     end

--     while itr ~= #racs do
--         if (#chiThree < 3 and t:hasValue(saveTmpChiThree, racs[itr]['val']) ~= true) then
--             table.insert(chiThree, racs[itr])
--             table.insert(saveTmpChiThree, racs[itr]['val'])

--             racs = t:filterValuesInArray(racs[itr])

--             if #chiThree == 3 then
--                 itr = 1
--             end
--         elseif (#chiThree < 3 and t:hasValue(saveTmpChiThree, racs[itr]['val'])) then
--             itr = itr + 1
--         elseif (#chiTwo < 5 and t:hasValue(saveTmpChiTwo, racs[itr]['val']) ~= true) then
--             table.insert(chiTwo, racs[itr])
--             table.insert(saveTmpChiTwo, racs[itr]['val'])

--             racs = t:filterValuesInArray(racs[itr])

--             if #chiTwo == 5 then
--                 itr = 1
--             end
--         elseif (#chiTwo < 5 and t:hasValue(saveTmpChiTwo, racs[itr]['val'])) then
--             itr = itr + 1
--         elseif 
--         end

--         itr = itr + 1

--         if (#chiTwo < 5 and t:hasValue(saveTmpChiTwo, racs[itr]['val']) ~= true) then
--             table.insert(chiTwo, racs[itr])
--             table.insert(saveTmpChiTwo, racs[itr]['val'])

--             racs = t:filterValuesInArray(racs[itr])
--         end

--         if (#chiOne < 5) and 
--     end
-- end

function PreHandle:isResultValid(chiOne, chiTwo, chiThree, types)
    -- if types[1] == 'samCo' and types[2] == 'samCo' and types[3] == 'samCo' then
    --     os.exit()
    -- end
    -- print(types[1], types[2], types[3])
    -- os.exit()
    print(PreHandle:checkType(chiOne))
    print(PreHandle:checkType(chiTwo))
    print(PreHandle:checkType(chiThree))

    return PreHandle:checkType(chiOne) == types[1] and
        PreHandle:checkType(chiTwo) == types[2] and
        PreHandle:checkType(chiThree) == types[3]
end

function PreHandle:findDoiValue(chi)
    for i = 1, #chi - 1 do
        for j = i + 1, #chi do
        if (chi[i]['val'] == chi[j]['val']) then
            return chi[i]['val']
        end
        end
    end
end

function PreHandle:handleChiTwoAndThreeMauThau(chiOne, typeChiOne, currentCards, results, chiTypes)
    local chiTwo = {}
    local chiThree = {}
    local saveTmpChiTwo = {}
    local saveTmpChiThree = {}

    for i = 1, #currentCards do
        if t:hasValue(saveTmpChiThree, currentCards[i]['val']) ~= true then
            table.insert(chiThree, currentCards[i])
            table.insert(saveTmpChiThree, currentCards[i]['val'])
        elseif t:hasValue(saveTmpChiTwo, currentCards[i]['val']) ~= true then
            table.insert(chiTwo, currentCards[i])
            table.insert(saveTmpChiTwo, currentCards[i]['val'])
        else
            return
        end
    end

    if PreHandle:isThung(chiTwo) and PreHandle:isThung(chiThree) then
        local converted = convertChiToResult(chiOne, chiTwo, chiThree)
        local types = { typeChiOne, 'mauThau', 'mauThau' }

        table.insert(results, converted)
        table.insert(chiTypes, types)
    end
end

return PreHandle
