Game = {}

local T = require "tableObj"
local PreHandle = require "preHandle"
local CompareAction = require "compare"
local Count = require "findValue"
local Special = require "specialCase"
t = T:new()
p = PreHandle:new()
compare = CompareAction:new()
countValue = Count:new()
specialCase = Special:new()

function Game:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- START RED ZONE

local stopCases = {{'thungPhaSanh', 'thungPhaSanh', 'xam'}}

local TYPES = {
    'thungPhaSanh', 'tuQuy', 'cuLu', 'thung', 'sanh', 'samCo', 'thu', 'doi',
    'mauThau'
}

local SPECIAL_TYPE = {
    { 'thungPhaSanh', 'thungPhaSanh', 'samCo' },
    { 'thungPhaSanh', 'tuQuy', 'samCo' },
    { 'tuQuy', 'tuQuy', 'samCo' },
    { 'tuQuy', 'cuLu', 'samCo' },
    { 'cuLu', 'cuLu', 'samCo' },
    { 'cuLu', 'thung', 'samCo' },
    { 'thung', 'thung', 'samCo' },
    { 'thung', 'sanh', 'samCo' },
    { 'sanh', 'sanh', 'samCo' },
    { 'sanh', 'samco', 'samCo' },
}

-- END RED ZONE

local function isValidDoi(array, checkValue)
    local count = 0
    for i = 1, #(array) do
        if array[i]['val'] == checkValue then count = count + 1 end
    end

    return count == 2
end

function Game:findDoi(array)
    local doiArray = p:findDoi(array)

    local results = {}

    for i = 1, #(doiArray) do
        local currItems = t:filterValuesInArray(array, doiArray[i])
        for a = 1, #(currItems) - 2 do
            for b = a + 1, #(currItems) - 1 do
                for c = b + 1, #(currItems) do
                    if currItems[a]['val'] ~= currItems[b]['val'] and
                        currItems[c]['val'] ~= currItems[b]['val'] and
                        currItems[a]['val'] ~= currItems[c]['val'] then
                        local tmp = {
                            doiArray[i][1], doiArray[i][2], currItems[a],
                            currItems[b], currItems[c]
                        }
                        if isValidDoi(tmp, doiArray[i][1]['val']) then
                            table.insert(results, tmp)
                            -- print(doiArray[i][1]['val'], doiArray[i][2]['val'], currItems[a]['val'], currItems[b]['val'], currItems[c]['val'])
                        end
                    end
                end
            end
        end
    end

    -- print('chi doi: ', #(results))
    return results
end

local function isThu(array)
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

function Game:findThu(array)
    local doiArray = p:findDoi(array)
    local diffItems = t:splitItemsInArray(array, false)
    local results = {}

    for i = 1, #(doiArray) - 1 do
        for j = i + 1, #(doiArray) do
            for k = 1, #(diffItems) do
                if doiArray[i][1]['val'] ~= doiArray[j][1]['val'] then
                    local tmp = {
                        doiArray[i][1], doiArray[i][2], doiArray[j][1],
                        doiArray[j][2], diffItems[k]
                    }
                    -- print('----')
                    -- for i = 1, #(tmp) do
                    --   print(tmp[i]['val'])
                    -- end
                    -- print('----')
                    table.insert(results, tmp)
                end

            end
        end
    end

    -- print('chi thu: ', #(results))
    return results
end

local function isSamCo(array)
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

function Game:findSamCo(array)
    local samcoArray = p:findBaHoacBon(array, false)
    print('sam co: ', #(samcoArray))

    local results = {}

    -- for i = 1, #(samcoArray) do
    --     print('----')
    --   for j = 1, #(samcoArray[i]) do
    --     print(samcoArray[i][j]['val'], samcoArray[i][j]['att'])
    --   end
    --   print('----')

    -- end
    for i = 1, #(samcoArray) do
        local compareNumber = samcoArray[i][1]['val']
        -- print('compareNumber: ', compareNumber)
        -- print('tat ca la: ', #(samcoArray[i]))
        for a = 1, #(array) - 1 do
            if array[a]['val'] ~= compareNumber then
                for b = a + 1, #(array) do
                    if array[b]['val'] ~= compareNumber and array[b]['val'] ~=
                        array[a]['val'] then
                        local tmp = {}
                        if array[a]['val'] > array[b]['val'] then
                            tmp = {
                                samcoArray[i][1], samcoArray[i][2],
                                samcoArray[i][3], array[a], array[b]
                            }
                        else
                            tmp = {
                                samcoArray[i][1], samcoArray[i][2],
                                samcoArray[i][3], array[b], array[a]
                            }
                        end

                        -- print('----')
                        -- for i = 1, #(tmp) do
                        --   print(tmp[i]['val'])
                        -- end
                        -- print('----')
                        table.insert(results, tmp)
                    end
                end
            end

        end
    end

    print('sam co: ', #(results))
    for i = 1, #(results) do
        print(results[i][1]['val'], results[i][2]['val'], results[i][3]['val'],
              results[i][4]['val'], results[i][5]['val'])
    end
    return results
end

function Game:findSanh(array)
    local results = p:findSanh(array)

    for i = 1, #results do
        print('-------')
        for j = 1, #results[i] do
            print(results[i][j]['val'], results[i][j]['att'])
        end
    end
    return results
end

local function isSanh(array)
    local tmp = t:shallowCopy(array)
    tmp = t:sortAsc(tmp)

    for i = 1, #(tmp) - 1 do
        if tmp[i + 1]['val'] - tmp[i]['val'] > 1 then return false end
    end

    return true
end

local function isValidInThung(array)
    local arrSize = #(array)

    -- check exist DOI
    for i = 1, arrSize - 1 do
        for j = i + 1, arrSize do
            if array[i]['val'] == array[j]['val'] then return false end
        end
    end

    -- check exist SANH
    if isSanh(array) then
        return false
    else
        return true
    end

end

function Game:findThung(array)
    -- local redThung = p:findThung(array)[1]
    -- local blackThung = p:findThung(array)[2]

    -- local results = t:mergeDataInTwoArray(redThung, blackThung)
    local results = p:findThung(array)
    local finalResults = {}

    for i = 1, #(results) do
        if isValidInThung(results[i]) then
            table.insert(finalResults, results[i])
        end
    end

    -- print('thung: ', #(finalResults))

    return finalResults;
end

local function isCuLu(array)
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

function Game:findCuLu(array)
    local samcoArray = p:findBaHoacBon(array, false)
    -- print('len ne ', #(samcoArray))
    local doiArray = p:findDoi(array)
    local results = {}

    for i = 1, #(samcoArray) do
        for j = i, #(doiArray) do
            if doiArray[j][1]['val'] ~= samcoArray[i][1]['val'] then
                local tmp = t:mergeDataInTwoArray(samcoArray[i], doiArray[j])

                table.insert(results, tmp)
            end
        end
    end

    -- print('cu lu: ', #(results))

    return results

end

-- local function isTuQuy(array)
--   local count = 1
--   for i = 1, #(array) - 1 do
--     for j = i + 1, #(array) do
--       if array[j]['val'] == array[i]['val'] then
--         count = count + 1
--       end
--     end
--   end

--   return count == 6
-- end

function Game:findTuQuy(array)
    local tuquyArray = p:findBaHoacBon(array, true)
    -- local diffItems = t:splitItemsInArray(array, false)
    local results = {}

    for i = 1, #(tuquyArray) do
        local diffItems = t:filterValuesInArray(array, tuquyArray[i])
        for j = 1, #(diffItems) do
            local tmp = {
                tuquyArray[i][1], tuquyArray[i][2], tuquyArray[i][3],
                tuquyArray[i][4], diffItems[j]
            }

            table.insert(results, tmp)
        end
    end

    -- print('tu quy: ', #(results))

    return results
end

local function isThung(array)
    local flagAtt = array[1]['att']

    for i = 1, #(array) do
        if array[i]['att'] ~= flagAtt then return false end
    end

    return true
end

local function isThungPhaSanh(array) return isThung(array) and isSanh(array) end

function Game:findThungPhaSanh(array)
    local sanhArray = p:findSanh(array)
    print('co sanh array:', #(sanhArray))
    local results = {}

    for i = 1, #(sanhArray) do
        if isThung(sanhArray[i]) then table.insert(results, sanhArray[i]) end
    end

    print('thung pha sanh: ', #(results))

    for i = 1, #(results) do
        print('----xx---')
        for j = 1, #(results[i]) do print(results[i][j]['val']) end
        print('----xx---')

    end
    return results;
end

local function isValidInMauThau(array)
    local arrSize = #(array)

    for i = 1, arrSize - 1 do
        for j = i + 1, arrSize do
            if array[i]['val'] == array[j]['val'] then return false end
        end
    end

    if arrSize == 5 then
        if isThung(array) ~= true and isSanh(array) ~= true then
            return true
        else
            return false
        end
    end

    return true
end

local function isMauThau(array) return isValidInMauThau(array) end

function Game:findMauThau(array)
    -- local diffItems = t:splitItemsInArray(array, false)
    -- local arrSize = #(diffItems)
    -- print('hien tai co: ', #array)
    local arrSize = #(array)
    local results = {}

    if arrSize >= 5 then
        for a = 1, arrSize - 4 do
            for b = a + 1, arrSize - 3 do
                for c = b + 1, arrSize - 2 do
                    for d = c + 1, arrSize - 1 do
                        for e = d + 1, arrSize do
                            local tmp = {
                                array[a], array[b], array[c], array[d], array[e]
                            }
                            if isValidInMauThau(tmp) then
                                table.insert(results, tmp)
                            end
                        end
                    end
                end
            end
        end
    else
        local tmpArray = t:sortDesc(array)
        local x = { tmpArray[1] }

        for i = 2, #tmpArray do
            if (tmpArray[i]['val'] ~= tmpArray[i-1]['val']) then
                table.insert(x, tmpArray[i])
            end

            if #x == 3 then
                break
            end
        end

        table.insert(results, x)
    end

    -- print('mau thau: ', #(results))

    return results
end

function Game:findCurrentKind(currentType, array)
    -- print('find current cua ', currentType, #(array))
    -- print('---------CURRENT CARDS IN CURRENT----------')
    -- for i = 1, #(array) do
    --   print(array[i]['val'], array[i]['att'])
    -- end
    -- print('--------------------------------')
    if currentType == 'thungPhaSanh' then
        return Game:findThungPhaSanh(array)
    elseif currentType == 'tuQuy' then
        return Game:findTuQuy(array)
    elseif currentType == 'cuLu' then
        return Game:findCuLu(array)
    elseif currentType == 'thung' then
        return Game:findThung(array)
    elseif currentType == 'sanh' then
        return Game:findSanh(array)
    elseif currentType == 'samCo' then
        return Game:findSamCo(array)
    elseif currentType == 'thu' then
        return Game:findThu(array)
    elseif currentType == 'doi' then
        return Game:findDoi(array)
    else
        return Game:findMauThau(array)
    end
end

function Game:findNextKind(currentType, array)
    -- print('find next cua ', currentType, #(array))
    -- print('---------CURRENT CARDS IN NEXT----------')
    -- for i = 1, #(array) do
    --   print(array[i]['val'], array[i]['att'])
    -- end
    -- print('--------------------------------')
    if currentType == 'thungPhaSanh' then
        return Game:findTuQuy(array)
    elseif currentType == 'tuQuy' then
        return Game:findCuLu(array)
    elseif currentType == 'cuLu' then
        return Game:findThung(array)
    elseif currentType == 'thung' then
        return Game:findSanh(array)
    elseif currentType == 'sanh' then
        return Game:findSamCo(array)
    elseif currentType == 'samCo' then
        return Game:findThu(array)
    elseif currentType == 'thu' then
        return Game:findDoi(array)
    else
        return Game:findMauThau(array)
    end

end

local function checkType(array)
    if #(array) == 5 then
        if p:isThungPhaSanh(array) then
            return 'thungPhaSanh'
        elseif p:isTuQuy(array) then
            return 'tuQuy'
        elseif p:isCuLu(array) then
            return 'cuLu'
        elseif p:isThung(array) then
            return 'thung'
        elseif p:isSanh(array) then
            return 'sanh'
        elseif p:isThu(array) then
            return 'thu'
        end
    end

    if p:isMauThau(array) then
        return 'mauThau'
    elseif p:isSamCo(array) then
        return 'samCo'
    elseif p:isDoi(array) then
        return 'doi'
    end
    -- return 'mauThau'
end

local x = {
    {val = 6, att = 3}, {val = 6, att = 3}, {val = 9, att = 3},
    {val = 7, att = 4}, {val = 6, att = 2}
}
-- print(checkType({
-- }))

local function convertChiToResult(chiOne, chiTwo, chiThree)
    local result = {}

    for i = 1, #(chiOne) do table.insert(result, chiOne[i]) end
    for i = 1, #(chiTwo) do table.insert(result, chiTwo[i]) end
    for i = 1, #(chiThree) do table.insert(result, chiThree[i]) end

    return result
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

    if types[array[1]] < types[array[2]] or types[array[2]] < types[array[3]] then
        return true
    else
        return false
    end
end

function Game:countValue(array, type, index)
    local score = 0
    -- for i = 1, #(array) do
    if type == 'thungPhaSanh' then
        score = score + countValue:thungPhaSanh(array, index, true)
    elseif type == 'tuQuy' then
        score = score + countValue:tuQuy(array, index)
    elseif type == 'cuLu' then
        score = score + countValue:cuLu(array, index)
    elseif type == 'thung' then
        score = score + countValue:thung(array, index)
    elseif type == 'sanh' then
        -- print(#(array))
        score = score + countValue:thungPhaSanh(array, index, false)
    elseif type == 'samCo' and #((array)) == 3 then
        score = score + countValue:samCo3(array)
    elseif type == 'samCo' and #(array) == 5 then
        score = score + countValue:samCo5(array, index)
    elseif type == 'thu' then
        score = score + countValue:thu(array, index)
    elseif type == 'doi' and #((array)) == 3 then
        score = score + countValue:doi3((array))
    elseif type == 'doi' and #((array)) == 5 then
        score = score + countValue:doi5(array, index)
    elseif type == 'mauThau' and #((array)) == 3 then
        score = score + countValue:mauThau3((array))
    elseif type == 'mauThau' and #((array)) == 5 then
        score = score + countValue:thung((array))
    else
        score = score + 0
    end
    -- end
    -- print('score ne: ', score)
    -- if score < -500000 then
    --   print('---------------')
    --   print(array[1]['val'], array[2]['val'], array[3]['val'], ' .. ', type)
    --   os.exit()
    -- end
    return score
end

local function writeEvents(content)
    file = io.open("oppCards.lua", "a")

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

    -- appends a word test to the last line of the file
    io.write('--****--\n')
    io.write(content .. '\n')

    -- closes the open file
    io.close(file)
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

function Game:isValidInThu(array)
    if isTuQuy(array) ~= true and isCuLu(array) ~= true and isSamCo(array) ~=
        true and isThung(array) then

        return true
    else
        return false
    end
end

-- find


local function findOneOtherCardsInChiTwo(cards)
    local results = {}

    for i = 1, #cards do table.insert(results, cards[i]) end

    return results
end

local function findTwoOtherCardsInChiTwo(cards)
    local results = {}

    for i = 1, #cards - 1 do
        for j = i + 1, #cards do
            table.insert(results, {cards[i], cards[j]})
        end
    end

    return results
end

local function findThreeOtherCardsInChiThree(cards)
    local results = {}

    for i = 1, #cards - 2 do
        for j = i + 1, #cards - 1 do
            for k = j + 1, #cards do
                table.insert(results, {cards[i], cards[j], cards[k]})
            end
        end
    end

    return results
end

local function findTheOtherCardsInChiTwo(cards, number)
    if number == 1 then
        return findOneOtherCardsInChiTwo(cards)
    elseif number == 2 then
        return findTwoOtherCardsInChiTwo(cards)
    elseif number == 3 then
        return findThreeOtherCardsInChiThree(cards)
    else
        return {}
    end

end

local function handleFromTopToBottom(currentType, chiOne, currentCards, results,
                                     chiTypes, scores)
    local idx = 0
    local saveChiOne = t:shallowCopy(chiOne)

    for i = 1, #(TYPES) do
        -- if (TYPES[i] == 'thu' or TYPES[i] == 'doi') then

        -- end
        if (TYPES[i] == currentType) then
            idx = i
            break
        end
    end

    for i = idx, #(TYPES) do
        local currentKind = {}

        if TYPES[i] == 'tuQuy' then
            currentKind = p:findBaHoacBon(currentCards, true)
        elseif TYPES[i] == 'cuLu' then
            currentKind = Game:findCuLu(currentCards)
        elseif TYPES[i] == 'thung' then
            currentKind = Game:findThung(currentCards)
        elseif TYPES[i] == 'sanh' then
            currentKind = Game:findSanh(currentCards)
        elseif TYPES[i] == 'samCo' then
            currentKind = p:findBaHoacBon(currentCards, false)
        elseif TYPES[i] == 'thu' then
            currentKind = p:findThu(currentCards)
        elseif TYPES[i] == 'doi' then
            currentKind = p:findDoi(currentCards)
        end

        print('[CHECK] ', TYPES[i])
        print('[CHECK] CurrentKind: ', #currentKind)

        if #(currentKind) > 0 then
            print('check currentKind i', #(currentKind), TYPES[i])
            print('chiOne len: ', #chiOne)
            for j = 1, #(currentKind) do
                -- print('check currentKind i', #(currentKind[i]))
                local chiTwo = t:spreadArray(currentKind[j])

                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)
                local afterCurrentCardsLength = #(afterCurrentCards)
                afterCurrentCards = t:sortDesc(afterCurrentCards)

                local spaceChiTwo = 5 - #(chiTwo)
                local tmpChiTwo = t:shallowCopy(chiTwo)
                local savePreCards = {}

                p:handleChiThreeMauThau(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes, scores)
                if (TYPES[i] ~= 'doi' and TYPES[i] ~= 'mauThau') then
                    p:handleChiThreeSamCo(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes, scores)
                end
                if (TYPES[i] ~= 'mauThau') then
                    p:handleChiThreeDoi(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes, scores)
                end

                -- UPDATE CHI ONE TO OLD
                chiOne = t:shallowCopy(saveChiOne)
            end
            -- handleChiThreeMauThau(chiOne, chiTwo)
        end
    end

    p:handleChiTwoAndThreeMauThau(chiOne, currentType, currentCards, results, chiTypes)
    -- if currentType == 'cuLu' then
    --     os.exit()
    -- end
end

function Game:handleChiOneThungPhaSanh(chiOne, currentCards, results, chiTypes,
                                        scores, saveSpecialType)
    local currentKind = Game:findThungPhaSanh(currentCards)
    print('[CARDS] Co ', #currentKind, ' thungPhaSanh')
    if #(currentKind) > 0 then
        local saveTheLastTypes = {}
        for i = 1, #(currentKind) do
            local chiTwo = currentKind[i]
            local chiThree = t:filterValuesInArray(currentCards, chiTwo)

            if compare:isFirstStronger(chiOne, chiTwo, 'thungPhaSanh') then
                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                local types = {'thungPhaSanh', 'thungPhaSanh', typeThree}
                saveTheLastTypes = {'thungPhaSanh', 'thungPhaSanh', typeThree}

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            table.insert(saveSpecialType, saveTheLastTypes)
            return
        end
    else
        local tuquyArray = p:findBaHoacBon(currentCards, true)

        -- print('co tu quy array: ', #(tuquyArray))
        if #tuquyArray > 0 then
            for i = 1, #(tuquyArray) do
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, tuquyArray[i])
                afterCurrentCards = t:sortDesc(afterCurrentCards)

                -- print('after curr', #afterCurrentCards)
                -- note
                local samCoArray = p:findBaHoacBon(afterCurrentCards, false)
                local saveTheLastTypes = {}

                for j = 1, #samCoArray do
                    local racCards = t:filterValuesInArray(afterCurrentCards,
                                                           samCoArray[j])
                    racCards = t:sortDesc(racCards)

                    local chiTwo = {
                        tuquyArray[i][1], tuquyArray[i][2], tuquyArray[i][3],
                        tuquyArray[i][4], racCards[1]
                    }
                    local chiThree = t:spreadArray(samCoArray[j])

                    local converted = convertChiToResult(chiOne, chiTwo,
                                                         chiThree)
                    local types = {'thungPhaSanh', 'tuQuy', 'samCo'}
                    -- saveTheLastTypes = {'thungPhaSanh', 'tuquy', 'samCo'}

                    table.insert(results, converted)
                    table.insert(chiTypes, types)
                    print('---------SPECIAL CASE---------')

                    table.insert(saveSpecialType, types)
                    return
                end
            end
        end
    end

    handleFromTopToBottom('thungPhaSanh', chiOne, currentCards, results,
                          chiTypes, scores)
end

function Game:findCurrentKindInNewVersion(type, currentCards, isFindChiTwo)
    local currentKind = {}

    if type == 'thungPhaSanh' then
        currentKind = Game:findThungPhaSanh(currentCards)
    elseif type == 'tuQuy' then
        currentKind = p:findBaHoacBon(currentCards, true)
    elseif type == 'cuLu' then
        currentKind = Game:findCuLu(currentCards)
    elseif type == 'thung' then
        currentKind = Game:findThung(currentCards)
    elseif type == 'sanh' then
        currentKind = Game:findSanh(currentCards)
    elseif type == 'samCo' then
        currentKind = p:findBaHoacBon(currentCards, false)
    elseif type == 'thu' then
        currentKind = p:findThu(currentCards)
    elseif type == 'doi' then
        currentKind = p:findDoi(currentCards)
    elseif type == 'mauThau' then
        currentKind = Game:findMauThau(currentCards)
    end

    return currentKind
end

local function handleFromTopToBottomTuQuy(chiOne, currentCards, results,
                                          chiTypes, scores)
    -- start from tu quy
    local saveTmpChiOne = t:shallowCopy(chiOne)

    for i = 2, #TYPES - 1 do
        chiOne = t:shallowCopy(saveTmpChiOne)
        local currentKind = Game:findCurrentKindInNewVersion(TYPES[i], currentCards)
        print('len curr: ', #currentKind, TYPES[i])
        if #currentKind > 0 then
            for j = 1, #currentKind do
                local chiTwo = currentKind[j]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)

                print('len chiTwo', #chiTwo)
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)

                for k = i, #TYPES do
                    local theLast = Game:findCurrentKindInNewVersion(TYPES[k],
                                                                afterCurrentCards)

                    print('CHECK TIME', 'tuQuy', TYPES[i], TYPES[k], #theLast)
                    if #theLast > 0 then
                        for l = 1, #theLast do
                            local chiThree = theLast[l]

                            if #chiThree > 3 then
                                print('ngu ne', #chiThree, #chiTwo, #chiOne)
                                -- os.exit()
                                break
                            end
                            print('len chiThree: ', #chiThree)

                            local racs =
                                t:filterValuesInArray(afterCurrentCards,
                                                      chiThree)
                            racs = t:sortDesc(racs)
                            print('racs', #racs)
                            local types = {
                                'tuQuy', TYPES[i], TYPES[k]
                            }
                            local arrayAfterFillRacs = p:divideRacsTo3Chi(
                                                           chiOne, chiTwo,
                                                           chiThree, racs, types)
                            if #arrayAfterFillRacs > 0 then
                                print('kinhh')
                                chiOne = arrayAfterFillRacs[1]
                                chiTwo = arrayAfterFillRacs[2]
                                chiThree = arrayAfterFillRacs[3]

                                if (TYPES[i] == 'tuQuy') then
                                    if compare:isFirstStronger(chiOne, chiTwo,
                                                               'tuQuy') then
                                        local converted = convertChiToResult(
                                                              chiOne, chiTwo,
                                                              chiThree)
                                        -- local types = {
                                        --     'tuQuy', TYPES[i], TYPES[k]
                                        -- }

                                        table.insert(results, converted)
                                        table.insert(chiTypes, types)

                                    end
                                else
                                    local converted =
                                        convertChiToResult(chiOne, chiTwo,
                                                           chiThree)
                                    local types = {'tuQuy', TYPES[i], TYPES[k]}

                                    table.insert(results, converted)
                                    table.insert(chiTypes, types)
                                end

                                chiTwo = t:shallowCopy(saveTmpChiTwo)
                                chiOne = t:shallowCopy(saveTmpChiOne)
                            end
                        end
                    end

                    -- handle truong hop mau thau
                    -- if compare:isFirstStronger(chiOne, chiTwo, 'tuQuy') then
                    --     p:handleChiThreeMauThau(chiOne, chiTwo, 'tuQuy',
                    --                             TYPES[k], afterCurrentCards,
                    --                             results, chiTypes, scores)
                    -- end
                    chiTwo = t:shallowCopy(saveTmpChiTwo)
                    chiOne = t:shallowCopy(saveTmpChiOne)
                end
            end
        end
    end

    p:handleChiTwoAndThreeMauThau(chiOne, 'tuQuy', currentCards, results, chiTypes)

end

function Game:handleChiOneTuQuy(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
    local currentKind = p:findBaHoacBon(currentCards, true)

    if #currentKind > 0 then
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local saveTheLastTypes = {}
            local afterCurrentCards =
                t:filterValuesInArray(currentCards, chiTwo)
            local samCoArray = p:findBaHoacBon(afterCurrentCards, false)

            if #samCoArray > 0 then
                local shouldStop = false
                for j = 1, #samCoArray do
                    local chiThree = samCoArray[j]
                    local racs = t:filterValuesInArray(afterCurrentCards,
                                                       chiThree)
                    racs = t:sortDesc(racs)

                    table.insert(chiOne, racs[2])
                    table.insert(chiTwo, racs[1])

                    if compare:isFirstStronger(chiOne, chiTwo, 'tuQuy') ~= true then
                        local tmp = t:shallowCopy(chiOne)
                        chiOne = t:shallowCopy(chiTwo)
                        chiTwo = t:shallowCopy(tmp)
                    end

                    local converted = convertChiToResult(chiOne, chiTwo,
                                                         chiThree)
                    local types = {'tuQuy', 'tuQuy', 'samCo'}
                    shouldStop = true

                    table.insert(results, converted)
                    table.insert(chiTypes, types)
                    table.insert(saveSpecialType, types)

                end

                if shouldStop then
                    return
                end
            end
        end

    else
        currentKind = Game:findCuLu(currentCards)

        print('xx', #currentKind)
        if #currentKind > 0 then
            for i = 1, #currentKind do
                local chiTwo = currentKind[i]
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)
                local samCoArray = p:findBaHoacBon(afterCurrentCards, false)

                if #samCoArray > 0 then
                    for j = 1, #samCoArray do
                        local chiThree = samCoArray[j]
                        local racs = t:filterValuesInArray(afterCurrentCards,
                                                           chiThree)

                        table.insert(chiOne, racs[1])

                        local converted =
                            convertChiToResult(chiOne, chiTwo, chiThree)
                        local types = {'tuQuy', 'cuLu', 'samCo'}

                        table.insert(results, converted)
                        table.insert(chiTypes, types)
                        table.insert(saveSpecialType, types)
                    end

                    return
                end
            end

        end

    end

    handleFromTopToBottomTuQuy(chiOne, currentCards, results, chiTypes, scores)
end

function Game:handleChiOneCuLu(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
    local currentKind = Game:findCuLu(currentCards)
    print('[CARDS] Co ', #currentKind, ' cu Lu')
    if (#currentKind) > 0 then
        local saveTheLastTypes = {}
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local chiThree = t:filterValuesInArray(currentCards, chiTwo)

            if compare:isFirstStronger(chiOne, chiTwo, 'cuLu') then
                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                local types = {'cuLu', 'cuLu', typeThree}
                saveTheLastTypes = {'cuLu', 'cuLu', typeThree}

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            table.insert(saveSpecialType, saveTheLastTypes)

            return
        end
    else
        local thungArray = Game:findThung(currentCards)
        print('[CARDS] Co ', #thungArray, ' thung')

        if (#thungArray) > 0 then
            local saveTheLastTypes = {}
            for i = 1, #thungArray do
                print('thung', #thungArray[i])
                local chiTwo = thungArray[i]
                print('chiTwo', #chiTwo)

                local chiThree = t:filterValuesInArray(currentCards, chiTwo)

                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                print('chiThree', #chiThree)
                print('typeThree', typeThree)
                local types = {'cuLu', 'thung', typeThree}
                saveTheLastTypes = {'cuLu', 'thung', typeThree}

                table.insert(results, converted)
                table.insert(chiTypes, types)

                print('LEN NE: ', #types)
            end

            if (saveTheLastTypes[3] == 'samCo') then
                table.insert(saveSpecialType, saveTheLastTypes)

                return
            end
        end
    end

    handleFromTopToBottom('cuLu', chiOne, currentCards, results, chiTypes,
                          scores)
end

function Game:handleChiOneThung(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
    local currentKind = Game:findThung(currentCards)
    print('[CARDS] Co ', #currentKind, ' thung')
    if (#currentKind) > 0 then
        local saveTheLastTypes = {}
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local chiThree = t:filterValuesInArray(currentCards, chiTwo)

            if compare:isFirstStronger(chiOne, chiTwo, 'thung') then
                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                local types = {'thung', 'thung', typeThree}
                saveTheLastTypes = {'thung', 'thung', typeThree}

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            table.insert(saveSpecialType, saveTheLastTypes)

            return
        end
    else
        local sanhArray = p:findSanh(currentCards)

        if (#sanhArray) > 0 then
            local saveTheLastTypes = {}
            for i = 1, #sanhArray do
                local chiTwo = sanhArray[i]
                local chiThree = t:filterValuesInArray(currentCards, chiTwo)

                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                local types = {'thung', 'sanh', typeThree}
                saveTheLastTypes = {'thung', 'sanh', typeThree}

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end

            if (saveTheLastTypes[3] == 'samCo') then
                table.insert(saveSpecialType, saveTheLastTypes)
                return
            end
        end
    end

    handleFromTopToBottom('thung', chiOne, currentCards, results, chiTypes,
                          scores)
end

function Game:handleChiOneSanh(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
    local currentKind = Game:findSanh(currentCards)
    print('[CARDS] Co ', #currentKind, ' sanh')
    if (#currentKind) > 0 then
        local saveTheLastTypes = {}
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local chiThree = t:filterValuesInArray(currentCards, chiTwo)

            if compare:isFirstStronger(chiOne, chiTwo, 'sanh') then
                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                local types = {'sanh', 'sanh', typeThree}
                saveTheLastTypes = {'sanh', 'sanh', typeThree}

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            table.insert(saveSpecialType, saveTheLastTypes)
            return
        end
    else
        local samCoArray = p:findBaHoacBon(currentCards, false)

        if (#samCoArray) > 0 then
            local saveTheLastTypes = {}
            for i = 1, #samCoArray do
                local chiTwo = samCoArray[i]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)
                local samCoArrayInChiThree =
                    p:findBaHoacBon(afterCurrentCards, false)

                if #samCoArrayInChiThree > 0 then
                    for j = 1, #samCoArrayInChiThree do
                        chiTwo = t:shallowCopy(saveTmpChiTwo)

                        local chiThree = samCoArrayInChiThree[j]
                        local racs = t:filterValuesInArray(afterCurrentCards,
                                                           chiThree)
                        racs = t:sortDesc(racs)

                        if (racs[1]['val'] ~= racs[2]['val']) then
                            table.insert(chiTwo, racs[1])
                            table.insert(chiTwo, racs[2])

                            local converted =
                                convertChiToResult(chiOne, chiTwo, chiThree)
                            local typeThree = checkType(chiThree)
                            local types = {'sanh', 'samCo', typeThree}

                            if (p:isResultValid(chiOne, chiTwo, chiThree, types) == true and c:isFirstStronger(chiTwo, chiThree, 'samCo')) then
                                table.insert(results, converted)
                                table.insert(chiTypes, types)
                                saveTheLastTypes = {'sanh', 'samCo', typeThree}
                            end
                        end
                    end
                end
            end

            if (saveTheLastTypes[3] == 'samCo') then
                table.insert(saveSpecialType, saveTheLastTypes)
                return
            end
        end
    end

    handleFromTopToBottom('sanh', chiOne, currentCards, results, chiTypes,
                          scores)
end

local function handleFromTopToBottomSamCo(chiOne, currentCards, results,
                                          chiTypes, scores)
    p:handleChiTwoAndThreeMauThau(chiOne, 'samCo', currentCards, results, chiTypes)
    -- start from thu
    local saveTmpChiOne = t:shallowCopy(chiOne)


    for i = 7, #TYPES - 1 do
        local currentKind = Game:findCurrentKindInNewVersion(TYPES[i], currentCards)
        print('len curr: ', #currentKind, TYPES[i])

        if #currentKind > 0 then
            for j = 1, #currentKind do
                local chiTwo = currentKind[j]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)

                print('len chiTwo', #chiTwo)
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)

                p:handleChiThreeMauThau(chiOne, chiTwo, 'samCo', TYPES[i], afterCurrentCards, results, chiTypes, scores)

                if (TYPES[i] ~= 'doi' and TYPES[i] ~= 'mauThau') then
                    p:handleChiThreeSamCo(chiOne, chiTwo, 'samCo', TYPES[i], afterCurrentCards, results, chiTypes, scores)
                end
                if (TYPES[i] ~= 'mauThau') then
                    p:handleChiThreeDoi(chiOne, chiTwo, 'samCo', TYPES[i], afterCurrentCards, results, chiTypes, scores)
                end
                chiTwo = t:shallowCopy(saveTmpChiTwo)
                chiOne = t:shallowCopy(saveTmpChiOne)
            end
        end
    end
end

function Game:handleChiOneSamCo(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
    local currentKind = p:findBaHoacBon(currentCards, false)
    local saveTmpChiOne = t:shallowCopy(chiOne)

    if #currentKind > 0 then
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local saveTmpChiTwo = t:shallowCopy(chiTwo)
            local afterCurrentCards =
                t:filterValuesInArray(currentCards, chiTwo)
            local samCoArray = p:findBaHoacBon(afterCurrentCards, false)

            if #samCoArray > 0 then
                local shouldStop = false
                for j = 1, #samCoArray do
                    local chiThree = samCoArray[j]
                    local racs = t:filterValuesInArray(afterCurrentCards,
                                                       chiThree)
                    racs = t:sortDesc(racs)

                    table.insert(chiOne, racs[3])
                    if racs[4]['val'] ~= racs[3]['val'] then
                        table.insert(chiOne, racs[4])
                        table.insert(chiTwo, racs[1])
                        table.insert(chiTwo, racs[2])
                    else
                        table.insert(chiOne, racs[2])
                        table.insert(chiTwo, racs[3])
                        table.insert(chiTwo, racs[4])
                    end

                    if compare:isFirstStronger(chiOne, chiTwo, 'samCo') then
                        local converted =
                            convertChiToResult(chiOne, chiTwo, chiThree)
                        local types = {'samCo', 'samCo', 'samCo'}
                        shouldStop = true

                        if p:isResultValid(chiOne, chiTwo, chiThree, types) then
                            table.insert(saveSpecialType, types)
                            table.insert(results, converted)
                            table.insert(chiTypes, types)
                        end

                        chiOne = t:shallowCopy(saveTmpChiOne)
                        chiTwo = t:shallowCopy(saveTmpChiTwo)
                    end
                end

                if shouldStop then return end
            end
        end
    else
        currentKind = p:findThu(currentCards)
        local saveTmpChiOne = t:shallowCopy(chiOne)

        if #currentKind > 0 then
            for i = 1, #currentKind do
                local chiTwo = currentKind[i]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)
                local doiArray = p:findDoi(afterCurrentCards)

                if #doiArray > 0 then
                    for j = 1, #doiArray do
                        local chiThree = doiArray[j]
                        local racs = t:filterValuesInArray(afterCurrentCards,
                                                           chiThree)
                        racs = t:sortDesc(racs)
                        local saveTmp = {}

                        -- if racs[1]['val'] ~= chiThree[1]['val'] then
                        --     table.insert(chiThree, racs[1])
                        --     table.insert(saveTmp, racs[1])
                        -- elseif racs[2]['val'] ~= chiThree[1]['val'] then
                        --     table.insert(chiThree, racs[2])
                        --     table.insert(saveTmp, racs[2])
                        -- elseif racs[3]['val'] ~= chiThree[1]['val'] then
                        --     table.insert(chiThree, racs[3])
                        --     table.insert(saveTmp, racs[3])
                        -- end

                        -- racs = t:filterValuesInArray(racs, saveTmp)

                        -- table.insert(chiTwo, racs[1])
                        -- table.insert(chiOne, racs[2])
                        -- table.insert(chiOne, racs[3])
                        local types = {'samCo', 'thu', 'doi'}

                        local arrayAfterFillRacs = p:divideRacsTo3Chi(
                                                           chiOne, chiTwo,
                                                           chiThree, racs, types)
                        if (#arrayAfterFillRacs > 0) then
                            chiOne = arrayAfterFillRacs[1]
                            chiTwo = arrayAfterFillRacs[2]
                            chiThree = arrayAfterFillRacs[3]

                            local converted =
                            convertChiToResult(chiOne, chiTwo, chiThree)
                            -- local types = {'samCo', 'thu', 'doi'}

                            if p:isResultValid(chiOne, chiTwo, chiThree, types) then
                                table.insert(results, converted)
                                table.insert(chiTypes, types)
                            end
                        end

                        chiOne = t:shallowCopy(saveTmpChiOne)
                        chiTwo = t:shallowCopy(saveTmpChiTwo)
                    end

                    return
                end
            end
        end
    end

    handleFromTopToBottomSamCo(chiOne, currentCards, results, chiTypes, scores)
end

local function handleSpecialCase(array, results, chiTypes, scores)
    local converted = {}
    local types = {}
    local r = {}

    -- if true then
    --     return
    -- end
    if specialCase:checkIsThreeMauThau(array) then
        print('RIGHT threeMauthau')
        specialCase:threeMauThau(array, results, chiTypes, scores)
    elseif specialCase:checkIsSamCoTu2Den12(array) then
        print('RIGHT samCoTu2Den12')
        specialCase:samCoTu2Den12(array, results, chiTypes, scores)
    elseif specialCase:checkIsManyDoi(array, 4) then
        print('RIGHT handle4Doi')
        -- os.exit()

        specialCase:handle4Doi(array, results, chiTypes, scores)
    elseif specialCase:checkIsManyDoi(array, 5) then
        print('RIGHT handle5Doi')
        -- os.exit()

        specialCase:handle5Doi(array, results, chiTypes, scores)
    elseif specialCase:checkIsManyDoi(array, 3) then
        print('RIGHT handle3Doi')
        -- os.exit()

        specialCase:handle3Doi(array, results, chiTypes, scores)
    elseif specialCase:checkIsManyDoi(array, 2) then
        print('RIGHT handle2Doi')
        -- os.exit()
        specialCase:handle2Doi(array, results, chiTypes, scores)
    end
end

local function calculateResultValue(result, type)
    local chiOne = {result[1], result[2], result[3], result[4], result[5]}
    local chiTwo = {result[6], result[7], result[8], result[9], result[10]}
    local chiThree = {result[11], result[12], result[13]}

    local score = -100000
    -- print('typee: ', type[1], type[2], type[3])
    for i = 1, #result do
        print(result[i]['val'], result[i]['att'])
    end
    -- print('-----')

    if (p:isResultValid(chiOne, chiTwo, chiThree, type)) then
        score = Game:countValue(chiOne, type[1], 1) + Game:countValue(chiTwo, type[2], 2) + Game:countValue(chiThree, type[3])
    end

    return score;

end

local function checkShouldStopFindResults(saveSpecialType)
    for i = 1, #saveSpecialType do
        for j = 1, #SPECIAL_TYPE do
            if SPECIAL_TYPE[j][1] == saveSpecialType[i][1] and
                SPECIAL_TYPE[j][2] == saveSpecialType[i][2] and
                SPECIAL_TYPE[j][3] == saveSpecialType[i][3]
            then
                return true
            end
        end
    end

    return false
end

function Game:findResults(array, results, chiTypes, scores)
    local saveSpecialType = {}

    for i = 1, #TYPES - 3 do
        local currentKind = Game:findCurrentKindInNewVersion(TYPES[i], array)
        print('[CHI ONE]', TYPES[i], #currentKind)
        if #currentKind > 0 then
            for j = 1, #currentKind do
                local chiOne = currentKind[j]
                local currentCards = t:filterValuesInArray(array, chiOne)

                if TYPES[i] == 'thungPhaSanh' and checkShouldStopFindResults(saveSpecialType) ~= true then
                    Game:handleChiOneThungPhaSanh(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
                elseif TYPES[i] == 'tuQuy' and checkShouldStopFindResults(saveSpecialType) ~= true then
                    Game:handleChiOneTuQuy(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
                elseif TYPES[i] == 'cuLu' and checkShouldStopFindResults(saveSpecialType) ~= true then
                    Game:handleChiOneCuLu(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
                elseif TYPES[i] == 'thung' and checkShouldStopFindResults(saveSpecialType) ~= true then
                    Game:handleChiOneThung(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
                elseif TYPES[i] == 'sanh' and checkShouldStopFindResults(saveSpecialType) ~= true then
                    Game:handleChiOneSanh(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
                elseif TYPES[i] == 'samCo' and checkShouldStopFindResults(saveSpecialType) ~= true then
                    Game:handleChiOneSamCo(chiOne, currentCards, results, chiTypes, scores, saveSpecialType)
                end
            end
        end
    end
end

local function writeEventsToFile(results, chiTypes, scores)
    for i = 1, #results do
        local text = readableData(results[i], chiTypes[i], scores[i])
        writeEvents(text)
    end
end

local function handleFindFinalResult(results, chiTypes, scores, array, saveIdx, saveScore)
    local kq = specialCase:soToiTrang((array))
    local text = ''
    local RESULT = t:shallowCopy(results[saveIdx])
    local types = t:shallowCopy(chiTypes[saveIdx])

    text = readableData(RESULT, types, saveScore)

    if (kq ~= nil) then
        local scoreToiTrang = countValue:toiTrang(kq[3])
        -- print('scoreToiTrang', scoreToiTrang)
        -- print('saveScore', saveScore)

        if (scoreToiTrang >= saveScore) then
            table.insert(results, kq[1])
            table.insert(chiTypes, { kq[3], kq[3], kq[3] })
            table.insert(scores, scoreToiTrang)

            RESULT = t:shallowCopy(kq[1])
            types = t:shallowCopy({ kq[3], kq[3], kq[3] })
            saveScore = scoreToiTrang

            text = readableData(kq[1], { kq[3], kq[3], kq[3] }, scoreToiTrang)
        end
    end

    -- writeResults(text)

    return { RESULT, types, saveScore }
end

local function handleFromTopToBottomBlackTable(currentType, chiOne, currentCards, results, chiTypes)

    local idx = nil;

    for i = 1, #TYPES do
        if (TYPES[i] == currentType) then
            idx = i
            break
        end
    end

    -- we only need to run to doi (mauThau will be handled later)
    for i = idx, #TYPES - 1 do
        local currentKind = Game:findCurrentKindInNewVersion(TYPES[i], currentCards)

        if (#currentKind) > 0 then
            for j = 1, #currentKind do
                local chiTwo = currentKind[j]
                local chiThree = {}

                local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)

                if (TYPES[i] == 'thu') then
                    print('THU NE')
                    for k = 1, #chiTwo do
                        print(chiTwo[k]['val'], chiTwo[k]['att'])
                    end
                end

                if (TYPES[i] == 'samCo') then
                    if (compare:isFirstStronger(chiOne, chiTwo, 'samCo')) then
                        p:handleChiThreeSamCo(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                        p:handleChiThreeDoi(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                        p:handleChiThreeMauThau(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                    end
                end

                if (TYPES[i] == 'thu') then
                    if (compare:isFirstStronger(chiOne, chiTwo, 'thu')) then
                        p:handleChiThreeDoi(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                        p:handleChiThreeMauThau(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                    end
                end
                if (TYPES[i] == 'doi') then
                    if (compare:isFirstStronger(chiOne, chiTwo, 'doi')) then
                        p:handleChiThreeDoi(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                        p:handleChiThreeMauThau(chiOne, chiTwo, currentType, TYPES[i], afterCurrentCards, results, chiTypes)
                    end
                end
            end
        end
    end

    -- GOT SOME BUGS ON THIS FUNCTION
    -- print(#results, #chiTypes)
    -- os.exit()
    p:handleChiTwoAndThreeMauThau(chiOne, currentType, currentCards, results, chiTypes)

end

local function saveValueToArray(chi)
    local result = {}

    for i = 1, #chi do
        table.insert(result, chi[i]['val'])
    end

    return result
end
local function handleBlackTableCase(array, results, chiTypes, scores)
    -- BECAUSE OF SAM CO IS HANDLED IN THE PAST SO WE CAN IGNORE IT

    local saveValue = {}

    for i = 7, #TYPES - 1 do
        local currentKind = Game:findCurrentKindInNewVersion(TYPES[i], array)

        if (#currentKind) > 0 then
            for j = 1, #currentKind do
                local chiOne = currentKind[j]

                if (#saveValue ~= 0) then
                    local curr = saveValueToArray(chiOne)

                    if (t:compareTwoArray(curr, saveValue) ~= true) then
                        local currentCards = t:filterValuesInArray(array, chiOne)

                        handleFromTopToBottomBlackTable(TYPES[i], chiOne, currentCards, results, chiTypes)
                        saveValue = t:shallowCopy(curr)
                    end
                else
                    local currentCards = t:filterValuesInArray(array, chiOne)

                    handleFromTopToBottomBlackTable(TYPES[i], chiOne, currentCards, results, chiTypes)
                    saveValue = saveValueToArray(chiOne)
                end
            end
        end
    end

end

function Game:play(array)
    local results = {}
    local chiTypes = {}
    local scores = {}

    local RESULT = nil

    local types = {
        'thungPhaSanh', 'tuQuy', 'cuLu', 'thung', 'sanh', 'samCo', 'thu', 'doi',
        'mauThau'
    }

    Game:findResults(array, results, chiTypes, scores)

    -- [START] HANDLE SPECIAL CASE ZONE
    -- bugs in this function
    -- handleSpecialCase(array, results, chiTypes, scores)
    -- [END] HANDLE SPECIAL CASE ZONE

    -- print(chiTypes[#chiTypes][1], chiTypes[#chiTypes][2], chiTypes[#chiTypes][3])
    -- print(chiTypes[#chiTypes - 1][1], chiTypes[#chiTypes][2], chiTypes[#chiTypes][3])

    -- os.exit()

    -- [START] HANDLE BLACK CASE
    handleBlackTableCase(array, results, chiTypes, scores)
    -- [END] HANDLE BLACK CASE

    for i = 1, #results do
        score = calculateResultValue(results[i], chiTypes[i])
        -- score = 0
        table.insert(scores, score)
    end

    -- [END] HANDLE COUNT VALUE

    -- print('RESULTS', #(results))
    -- print('TYPES', #(chiTypes))
    -- print('SCORES', #scores)

    -- print(chiTypes[#chiTypes][1], chiTypes[#chiTypes][2], chiTypes[#chiTypes][3])
    -- os.exit()
    local saveScore = scores[1]
    local saveIdx = 1

    for i = 1, #(results) do
        local text = ''
        if (scores[i] > saveScore) then
            saveScore = scores[i]
            saveIdx = i
        end
    end
    RESULT = results[saveIdx]


    local finalResult = handleFindFinalResult(results, chiTypes, scores, array, saveIdx, saveScore)

    -- writeEventsToFile(results, chiTypes, scores)

    return finalResult
end

return Game
