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

-- END RED ZONE

local function isValidDoi(array, checkValue)
    local count = 0
    for i = 1, #(array) do
        if array[i]['val'] == checkValue then count = count + 1 end
    end

    return count == 2
end

local function isDoi(array)
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
    -- print('sam co: ', #(samcoArray))
    local results = {}

    -- for i = 1, #(samcoArray) do
    --   for j = 1, #(samcoArray[i]) do
    --     print(samcoArray[i][j]['val'])
    --   end
    -- end
    for i = 1, #(samcoArray) do
        local compareNumber = samcoArray[i][1]['val']
        print('compareNumber: ', compareNumber)
        print('tat ca la: ', #(samcoArray[i]))
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

    -- print('sam co: ', #(results))
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
            print(results[i][j]['val'])
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
    local redThung = p:findThung(array)[1]
    local blackThung = p:findThung(array)[2]

    local results = t:mergeDataInTwoArray(redThung, blackThung)
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
    local sanhArray = Game:findSanh(array)
    print('co sanh array:', #(sanhArray))
    local results = {}

    for i = 1, #(sanhArray) do
        if isThung(sanhArray[i]) then table.insert(results, sanhArray[i]) end
    end

    print('thung pha sanh: ', #(results))

    for i = 1, #(results) do
        for j = 1, #(results[i]) do print(results[i][j]['val']) end
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
    end

    -- print('mau thau: ', #(results))

    return results
end

local function findCurrentKind(currentType, array)
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

local function findNextKind(currentType, array)
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

-- find with different type (chiTwo # chiOne)
local function findNextWithChiOne(results, chiOne, type, currentCards, chiType,
                                  chiTypes, scores, cards)
    local currentKind = {}

    while #(currentKind) == 0 and type ~= 'mauThau' do
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
    -- check special case zone
    if chiType[1] == 'samCo' and type == 'mauThau' then
        print('--------')
        print(chiType[1], type)
        if specialCase.containsSamCoTu2Den12 ~= true then
            if specialCase:checkIsSamCoTu2Den12(cards) then
                specialCase.containsSamCoTu2Den12 = true
                print('watsashi no')
                local result = specialCase:samCoTu2Den12(array)
                table.insert(results, result[1])
                table.insert(chiTypes, result[2])

                print('=-=-=-=-=-')
                for i = 1, #(result[1]) do
                    print(result[1][i]['val'])
                end
                local chiOne = {
                    result[1][1], result[1][2], result[1][3], result[1][4],
                    result[1][5]
                }
                local chiTwo = {
                    result[1][6], result[1][7], result[1][8], result[1][9],
                    result[1][10]
                }
                local chiThree = {result[1][11], result[1][12], result[1][13]}

                local score = Game:countValue(chiOne, 'samCo', 1)
                print('score 1: ', score)
                score = score + Game:countValue(chiTwo, 'mauThau', 2)
                score = score + Game:countValue(chiThree, 'mauThau')
                print('calm down')

                table.insert(scores, score)
                -- print('log ra roi ne')
            end
            -- return
        end

        return
    end

    if type == 'mauThau' and #(currentKind) > 0 then
        print('xxxxxx', chiType[1])
        local result = specialCase:handle2ChiRac(chiOne, currentCards)

        if result ~= nil then
            local cards = result[1]

            local chiTwo = {cards[6], cards[7], cards[8], cards[9], cards[10]}
            local chiThree = {cards[11], cards[12], cards[13]}

            print('xxxxxxx')
            for i = 1, #(chiTwo) do print(chiTwo[i]['val']) end
            print('xxxxxxx')

            print('xxxxxxx')
            for i = 1, #(chiThree) do print(chiThree[i]['val']) end
            print('xxxxxxx')

            local score = Game:countValue(chiOne, chiType[1], 1)
            score = score + Game:countValue(chiTwo, 'mauThau', 2)
            score = score + Game:countValue(chiThree, 'mauThau')

            table.insert(results, tmp)
            table.insert(chiTypes, copyChiType)
            table.insert(scores, score)
        end

        return
    end

    -- end zone
    print('types ne', chiType[1], type)
    for i = 1, #(currentKind) do
        print('man iu')
        local copyChiType = t:shallowCopy(chiType)
        local chiTwo = currentKind[i]
        -- if c:isFirstStronger(chiOne, chiTwo) then
        table.insert(copyChiType, type)
        local chiThree = {}
        local currentCardsAfterTwo = t:shallowCopy(currentCards)
        chiThree = t:filterValuesInArray(currentCardsAfterTwo, chiTwo)
        table.insert(copyChiType, checkType(chiThree))

        if checkBinhLung(copyChiType) ~= true then
            local tmp = convertChiToResult(chiOne, chiTwo, chiThree)
            local score = Game:countValue(chiOne, copyChiType[1], 1)
            score = score + Game:countValue(chiTwo, copyChiType[2], 2)
            score = score + Game:countValue(chiThree, copyChiType[3])

            table.insert(results, tmp)
            table.insert(chiTypes, copyChiType)
            table.insert(scores, score)
        end
        -- else 
        -- break
    end
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
    -- for i = 1, #(array) do
    --   print(array[i]['val'])
    -- end
    -- print('--0-0-0-0-0-0--')

    if scores == nil then
        print(array[1]['val'], array[2]['val'], array[3]['val'], ' .. ',
              types[1])
        os.exit()
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

local function findIndexOfType(type, types)
    for i = 1, #(types) do if types[i] == type then return i end end
end

-- function Game:isValidInSamCo(array)
--   -- print('----')
--   -- for i = 1, 5 do
--   --   print(array[i]['val'])
--   -- end
--   -- print('----')

--   if 
--     isTuQuy(array) ~= true and
--     isCuLu(array) ~= true and
--     isSamCo(array) then

--     return true
--   else
--     return false
--   end
-- end

function Game:isValidInThu(array)
    if isTuQuy(array) ~= true and isCuLu(array) ~= true and isSamCo(array) ~=
        true and isThung(array) then

        return true
    else
        return false
    end
end

-- find

local function checkIsRightType(cards, type)
    local cardsType = checkType(cards)

    return cardsType == type
end

-- print(checkIsRightType(x, 'doi'))
local function isTwoResultSame(arrayOne, arrayTwo)
    if #arrayOne == 0 or #arrayTwo == 0 then return false end

    for i = 1, #(arrayOne) do
        if (arrayOne[i]['val'] ~= arrayTwo[i]['val']) then return false end
    end

    return true
end

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

    for i = 1, #(TYPES) do
        if (TYPES[i] == currentType) then
            idx = i
            break
        end
    end

    for i = idx + 1, #(TYPES) do
        local currentKind = {}

        if TYPES[i] == 'tuQuy' then
            currentKind = p:findBaHoacBon(currentCards, true)
        elseif TYPES[i] == 'cuLu' then
            currentKind = Game:findCuLu(currentCards)
        elseif TYPES[i] == 'thung' then
            currentKind = Game:findThung(currentCards)
        elseif TYPES[i] == 'sanh' then
            currentKind = p:findSanh(currentCards)
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
            for j = 1, #(currentKind) do
                -- print('check currentKind i', #(currentKind[i]))
                local chiTwo = t:spreadArray(currentKind[j])
                local afterCurrentCards =
                    t:filterValuesInArray(currentCards, chiTwo)
                local afterCurrentCardsLength = #(afterCurrentCards)
                afterCurrentCards = t:sortDesc(afterCurrentCards)

                -- print('---------')
                -- for i = 1, #chiTwo do
                --     print(chiTwo[i]['val'])
                -- end
                -- print('---------')

                local spaceChiTwo = 5 - #(chiTwo)
                local tmpChiTwo = t:shallowCopy(chiTwo)
                local savePreCards = {}

                local theOthersInChiTwo =
                    findTheOtherCardsInChiTwo(afterCurrentCards, spaceChiTwo)

                print('the other', #theOthersInChiTwo)
                if #theOthersInChiTwo > 0 then
                    for k = 1, #theOthersInChiTwo do
                        chiTwo = t:shallowCopy(tmpChiTwo)
                        chiTwo = t:mergeDataInTwoArray(chiTwo,
                                                       theOthersInChiTwo[k])

                        if checkIsRightType(chiTwo, TYPES[i]) then
                            local chiThree =
                                t:filterValuesInArray(afterCurrentCards,
                                                      theOthersInChiTwo[k])
                            chiThree = t:sortDesc(chiThree)

                            local converted =
                                convertChiToResult(chiOne, chiTwo, chiThree)
                            local typeThree = checkType(chiThree)

                            if isTwoResultSame(converted, savePreCards) ~= true then
                                local shouldStop = false
                                if TYPES[i] == typeThree then
                                    if compare:isFirstStronger(chiTwo, chiThree,
                                                               typeThree) ~=
                                        true then
                                        shouldStop = true
                                    end
                                end

                                if shouldStop ~= true then
                                    savePreCards = t:shallowCopy(converted)
                                    print('[TYPES] add to types', currentType,
                                          TYPES[i], checkType(chiThree))
                                    local types = {
                                        currentType, TYPES[i],
                                        checkType(chiThree)
                                    }

                                    table.insert(results, converted)
                                    table.insert(chiTypes, types)
                                end
                            end
                        end
                    end
                else
                    if checkIsRightType(chiTwo, TYPES[i]) then
                        local chiThree = t:spreadArray(afterCurrentCards)
                        chiThree = t:sortDesc(chiThree)

                        local converted =
                            convertChiToResult(chiOne, chiTwo, chiThree)
                        local typeThree = checkType(chiThree)

                        if isTwoResultSame(converted, savePreCards) ~= true then
                            local shouldStop = false
                            if TYPES[i] == typeThree then
                                if compare:isFirstStronger(chiTwo, chiThree,
                                                           typeThree) ~= true then
                                    shouldStop = true
                                end
                            end

                            if shouldStop ~= true then
                                savePreCards = t:shallowCopy(converted)
                                print('[TYPES] add to types', currentType,
                                      TYPES[i], checkType(chiThree))
                                local types = {
                                    currentType, TYPES[i], checkType(chiThree)
                                }

                                table.insert(results, converted)
                                table.insert(chiTypes, types)
                            end
                        end
                    end
                end

                print('xxxxxxxx')
                for i = 1, #chiTwo do print(chiTwo[i]['val']) end
                print('xxxxxxxx')
            end
        end
    end
end

local function handleChiOneThungPhaSanh(chiOne, currentCards, results, chiTypes,
                                        scores)
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
                local types = {
                    'thungPhaSanh', 'thungPhaSanh', typeThree
                }
                saveTheLastTypes = {
                    'tuQuy', 'tuQuy', typeThree
                }

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            return
        end
    else
        local tuquyArray = p:findBaHoacBon(currentCards, true)

        -- print('co tu quy array: ', #(tuquyArray))
        if #tuquyArray > 0 then
            for i = 1, #(tuquyArray) do
                local afterCurrentCards = t:filterValuesInArray(currentCards,
                                                                tuquyArray[i])
                afterCurrentCards = t:sortDesc(afterCurrentCards)

                -- print('after curr', #afterCurrentCards)
                -- note
                local samCoArray = p:findBaHoacBon(afterCurrentCards, false)
                local saveTheLastTypes = {}

                for j = 1, #samCoArray do
                    local racCards = t:filterValuesInArray(afterCurrentCards,
                                                           samCoArray[j])
                    racCards = t:sortDesc(racCards)

                    -- print('\nrac ne: ')
                    -- for o = 1, #racCards do
                    --   print(racCards[o]['val'])
                    -- end

                    local chiTwo = {
                        tuquyArray[i][1], tuquyArray[i][2], tuquyArray[i][3],
                        tuquyArray[i][4], racCards[1]
                    }
                    local chiThree = t:spreadArray(samCoArray[j])

                    local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                    local types = {'thungPhaSanh', 'tuQuy', 'samCo'}
                    saveTheLastTypes = { 'tuQuy', 'cuLu', typeThree }

                    table.insert(results, converted)
                    table.insert(chiTypes, types)
                    print('---------SPECIAL CASE---------')

                    return
                end
            end
        end
    end

    handleFromTopToBottom('thungPhaSanh', chiOne, currentCards, results,
                          chiTypes, scores)
end

local function findCurrentKindInNewVersion(type, currentCards)
    local currentKind = {}

    if type == 'tuQuy' then
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
    -- elseif type == 'mauThau' then
    --     currentKind = Game:findMauThau()
    end

    return currentKind
end

local function handleFromTopToBottomTuQuy(chiOne, currentCards, results, chiTypes, scores)
    -- start from tu quy
    local saveTmpChiOne = t:shallowCopy(chiOne)

    for i = 2, #TYPES do
        chiOne = t:shallowCopy(saveTmpChiOne)
        local currentKind = findCurrentKindInNewVersion(TYPES[i], currentCards)
        print('len curr: ', #currentKind, TYPES[i])
        if #currentKind > 0 then
            for j = 1, #currentKind do
                local chiTwo = currentKind[j]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)

                print('len chiTwo', #chiTwo)
                local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)

                for k = i, #TYPES do
                    local theLast = findCurrentKindInNewVersion(TYPES[k], afterCurrentCards)

                    if #theLast > 0 then
                        for l = 1, #theLast do
                            local chiThree = theLast[l]
                            print('len chiThree: ', #chiThree)
                            local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
                            racs = t:sortDesc(racs)

                            print('racs:', #racs)
                            for rac = 1, #racs do
                                print('---rac: ', racs[rac]['val'])
                            end
                            print('-----')
                            local itr = 1
                            while itr ~= #racs + 1 do
                                print('---------')
                                print('chiThree', #chiThree)
                                print('chiTwo', #chiTwo)
                                print('chiOne', #chiOne)
                                print('---------')
                                if #chiThree < 3 then
                                    table.insert(chiThree, racs[itr])
                                    print('added to chi Three', racs[itr]['val'])
                                elseif #chiTwo < 5 then
                                    table.insert(chiTwo, racs[itr])
                                    print('added to chi Two', racs[itr]['val'])
                                elseif #chiOne < 5 then
                                    table.insert(chiOne, racs[itr])
                                    print('added to chi One', racs[itr]['val'])
                                end

                                itr = itr + 1

                            end

                            local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                            local types = { 'tuQuy', TYPES[i], TYPES[k] }

                            table.insert(results, converted)
                            table.insert(chiTypes, types)

                            chiTwo = t:shallowCopy(saveTmpChiTwo)
                            chiOne = t:shallowCopy(saveTmpChiOne)
                        end
                    end
                end
            end
        end
    end
end

local function handleChiOneTuQuy(chiOne, currentCards, results, chiTypes, scores)
    local currentKind = p:findBaHoacBon(currentCards, true)

    if #currentKind > 0 then
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local saveTheLastTypes = {}
            local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)
            local samCoArray = p:findBaHoacBon(afterCurrentCards, false)

            if #samCoArray > 0 then
                local shouldStop = false
                for j = 1, #samCoArray do
                    local chiThree = samCoArray[j]
                    local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
                    racs = t:sortDesc(racs)

                    table.insert(chiOne, racs[2])
                    table.insert(chiTwo, racs[1])

                    if compare:isFirstStronger(chiOne, chiTwo, 'tuQuy') ~= true then
                        local tmp = t:shallowCopy(chiOne)
                        chiOne = t:shallowCopy(chiTwo)
                        chiTwo = t:shallowCopy(tmp)
                    end

                    local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                    local types = { 'tuQuy', 'tuQuy', 'samCo' }
                    shouldStop = true

                    table.insert(results, converted)
                    table.insert(chiTypes, types)
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
                local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)
                local samCoArray = p:findBaHoacBon(afterCurrentCards, false)

                if #samCoArray > 0 then
                    for j = 1, #samCoArray do
                        local chiThree = samCoArray[j]
                        local racs = t:filterValuesInArray(afterCurrentCards, chiThree)

                        table.insert(chiOne, racs[1])

                        local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                        local types = { 'tuQuy', 'cuLu', 'samCo' }

                        table.insert(results, converted)
                        table.insert(chiTypes, types)
                    end

                    return
                end
            end

        end

    end

    handleFromTopToBottomTuQuy(chiOne, currentCards, results, chiTypes, scores)
end

local function handleChiOneCuLu(chiOne, currentCards, results, chiTypes, scores)
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
                local types = {
                    'cuLu', 'cuLu', typeThree
                }
                saveTheLastTypes = {
                    'tuQuy', 'tuQuy', typeThree
                }

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            return
        end
    else
        local thungArray = p:findThung(currentCards)

        if (#thungArray) > 0 then
            local saveTheLastTypes = {}
            for i = 1, #thungArray do
                local chiTwo = thungArray[i]
                local chiThree = t:filterValuesInArray(currentCards, chiTwo)

                local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                local typeThree = checkType(chiThree)
                local types = {
                    'cuLu', 'thung', typeThree
                }
                saveTheLastTypes = {
                    'cuLu', 'thung', typeThree
                }

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end

            if (saveTheLastTypes[3] == 'samCo') then
                return
            end
        end
    end

    handleFromTopToBottom('cuLu', chiOne, currentCards, results,
                          chiTypes, scores)
end

local function handleChiOneThung(chiOne, currentCards, results, chiTypes, scores)
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
                local types = {
                    'thung', 'thung', typeThree
                }
                saveTheLastTypes = {
                    'thung', 'thung', typeThree
                }

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
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
                local types = {
                    'thung', 'sanh', typeThree
                }
                saveTheLastTypes = {
                    'thung', 'sanh', typeThree
                }

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end

            if (saveTheLastTypes[3] == 'samCo') then
                return
            end
        end
    end

    handleFromTopToBottom('thung', chiOne, currentCards, results,
                          chiTypes, scores)
end

local function handleChiOneSanh(chiOne, currentCards, results, chiTypes, scores)
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
                local types = {
                    'sanh', 'sanh', typeThree
                }
                saveTheLastTypes = {
                    'sanh', 'sanh', typeThree
                }

                table.insert(results, converted)
                table.insert(chiTypes, types)
            end
        end

        if (saveTheLastTypes[3] == 'samCo') then
            return
        end
    else
        local samCoArray = p:findBaHoacBon(currentCards, false)

        if (#samCoArray) > 0 then
            local saveTheLastTypes = {}
            for i = 1, #samCoArray do
                local chiTwo = samCoArray[i]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)
                local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)
                local samCoArrayInChiThree = p:findBaHoacBon(afterCurrentCards, false)

                if #samCoArrayInChiThree > 0 then
                    for j = 1, #samCoArrayInChiThree do
                        chiTwo = t:shallowCopy(saveTmpChiTwo)

                        local chiThree = samCoArrayInChiThree[j]
                        local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
                        racs = t:sortDesc(racs)

                        if (racs[1]['val'] ~= racs[2]['val']) then
                            table.insert(chiTwo, racs[1])
                            table.insert(chiTwo, racs[2])

                            local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                            local typeThree = checkType(chiThree)
                            local types = {
                                'sanh', 'samCo', typeThree
                            }
                            saveTheLastTypes = {
                                'sanh', 'samCo', typeThree
                            }

                            print('GOOD NIGHT')
                            table.insert(results, converted)
                            table.insert(chiTypes, types)
                        end
                    end
                end
            end

            if (saveTheLastTypes[3] == 'samCo') then
                return
            end
        end
    end

    handleFromTopToBottom('sanh', chiOne, currentCards, results,
                          chiTypes, scores)
end

local function handleFromTopToBottomSamCo(chiOne, currentCards, results, chiTypes, scores)
    -- start from sam co
    local saveTmpChiOne = t:shallowCopy(chiOne)

    for i = 6, #TYPES do
        local currentKind = findCurrentKindInNewVersion(TYPES[i], currentCards)
        print('len curr: ', #currentKind, TYPES[i])

        if #currentKind > 0 then
            for j = 1, #currentKind do
                local chiTwo = currentKind[j]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)

                print('len chiTwo', #chiTwo)
                local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)

                for k = i, #TYPES do
                    local theLast = findCurrentKindInNewVersion(TYPES[k], afterCurrentCards)

                    if #theLast > 0 then
                        for l = 1, #theLast do
                            local chiThree = theLast[l]
                            print('len chiThree: ', #chiThree)
                            local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
                            racs = t:sortDesc(racs)

                            print('racs: ', #racs)
                            local itr = 1
                            while itr ~= #racs + 1 do
                                print('---------')
                                print('chiThree', #chiThree)
                                print('chiTwo', #chiTwo)
                                print('chiOne', #chiOne)
                                print('---------')
                                if #chiThree < 3 then
                                    table.insert(chiThree, racs[itr])
                                    print('added to chi Three', racs[itr]['val'])
                                elseif #chiTwo < 5 then
                                    table.insert(chiTwo, racs[itr])
                                    print('added to chi Two', racs[itr]['val'])
                                elseif #chiOne < 5 then
                                    table.insert(chiOne, racs[itr])
                                    print('added to chi One', racs[itr]['val'])
                                end

                                itr = itr + 1

                            end

                            local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                            local types = { 'samCo', TYPES[i], TYPES[k] }

                            table.insert(results, converted)
                            table.insert(chiTypes, types)

                            chiTwo = t:shallowCopy(saveTmpChiTwo)
                            chiOne = t:shallowCopy(saveTmpChiOne)
                        end
                    end
                end
            end
        end
    end
end

local function handleChiOneSamCo(chiOne, currentCards, results, chiTypes, scores)
    local currentKind = p:findBaHoacBon(currentCards, false)
    local saveTmpChiOne = t:shallowCopy(chiOne)

    if #currentKind > 0 then
        for i = 1, #currentKind do
            local chiTwo = currentKind[i]
            local saveTmpChiTwo = t:shallowCopy(chiTwo)
            local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)
            local samCoArray = p:findBaHoacBon(afterCurrentCards, false)

            if #samCoArray > 0 then
                local shouldStop = false
                for j = 1, #samCoArray do
                    local chiThree = samCoArray[j]
                    local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
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

                    if compare:isFirstStronger(chiOne, chiTwo, 'tuQuy') then
                        local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                        local types = { 'samCo', 'samCo', 'samCo' }
                        shouldStop = true

                        table.insert(results, converted)
                        table.insert(chiTypes, types)

                        chiOne = t:shallowCopy(saveTmpChiOne)
                        chiTwo = t:shallowCopy(saveTmpChiTwo)
                    end
                end

                if shouldStop then
                    return
                end
            end
        end
    else
        currentKind = p:findThu(currentCards)
        local saveTmpChiOne = t:shallowCopy(chiOne)

        if #currentKind > 0 then
            for i = 1, #currentKind do
                local chiTwo = currentKind[i]
                local saveTmpChiTwo = t:shallowCopy(chiTwo)
                local afterCurrentCards = t:filterValuesInArray(currentCards, chiTwo)
                local doiArray = p:findDoi(afterCurrentCards)

                if #doiArray > 0 then
                    for j = 1, #doiArray do
                        local chiThree = doiArray[j]
                        local racs = t:filterValuesInArray(afterCurrentCards, chiThree)
                        racs = t:sortDesc(racs)
                        local saveTmp = {}

                        if racs[1]['val'] ~= chiThree[1]['val'] then
                            table.insert(chiThree, racs[1])
                            table.insert(saveTmp, racs[1])
                        elseif racs[2]['val'] ~= chiThree[1]['val'] then
                            table.insert(chiThree, racs[2])
                            table.insert(saveTmp, racs[2])
                        elseif racs[3]['val'] ~= chiThree[1]['val'] then
                            table.insert(chiThree, racs[3])
                            table.insert(saveTmp, racs[3])
                        end

                        racs = t:filterValuesInArray(racs, saveTmp)

                        table.insert(chiTwo, racs[1])
                        table.insert(chiOne, racs[2])
                        table.insert(chiOne, racs[3])

                        local converted = convertChiToResult(chiOne, chiTwo, chiThree)
                        local types = { 'samCo', 'thu', 'doi' }

                        table.insert(results, converted)
                        table.insert(chiTypes, types)

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

function Game:play(array)
    local results = {}
    local chiTypes = {}
    local scores = {}

    local types = {
        'thungPhaSanh', 'tuQuy', 'cuLu', 'thung', 'sanh', 'samCo', 'thu', 'doi',
        'mauThau'
    }

    -- local currentKind = Game:findThungPhaSanh(array)

    -- for i = 1, #(currentKind) do
    --     local chiOne = currentKind[i]
    --     local currentCards = t:filterValuesInArray(array, chiOne)
    --     handleChiOneThungPhaSanh(chiOne, currentCards, results, chiTypes, scores)
    -- end

    -- local currentKind = p:findBaHoacBon(array, true)

    -- for i = 1, #(currentKind) do
    --     local chiOne = currentKind[i]
    --     local currentCards = t:filterValuesInArray(array, chiOne)
    --     handleChiOneTuQuy(chiOne, currentCards, results, chiTypes, scores)
    -- end

    -- local currentKind = Game:findCuLu(array)
    -- print('Ghe nha', #currentKind)
    -- for i = 1, #currentKind do
    --     local chiOne = currentKind[i]
    --     local currentCards = t:filterValuesInArray(array, chiOne)
    --     handleChiOneCuLu(chiOne, currentCards, results, chiTypes, scores)
    -- end

    -- local currentKind = Game:findThung(array)
    -- print('Ghe nha', #currentKind)
    -- for i = 1, #currentKind do
    --     local chiOne = currentKind[i]
    --     local currentCards = t:filterValuesInArray(array, chiOne)
    --     handleChiOneThung(chiOne, currentCards, results, chiTypes, scores)
    -- end

    -- local currentKind = Game:findSanh(array)
    -- print('Ghe nha', #currentKind)
    -- for i = 1, #currentKind do
    --     local chiOne = currentKind[i]
    --     local currentCards = t:filterValuesInArray(array, chiOne)
    --     handleChiOneSanh(chiOne, currentCards, results, chiTypes, scores)
    -- end

    local currentKind = p:findBaHoacBon(array, false)
    print('Ghe nha', #currentKind)
    for i = 1, #currentKind do
        local chiOne = currentKind[i]
        local currentCards = t:filterValuesInArray(array, chiOne)
        handleChiOneSamCo(chiOne, currentCards, results, chiTypes, scores)
    end

    print('RESULTS', #(results))
    print('TYPES', #(chiTypes))

    print('CHECK ZONE')
    for i = 1, #(results) do
        print('------')
        -- print('len: ', #(results[i]))
        print(chiTypes[i][1], chiTypes[i][2], chiTypes[i][3])
        for j = 1, #(results[i]) do
            print(results[i][j]['val'], results[i][j]['att'])
            if j == 5 or j == 10 then print('-') end
        end
        print('------')

    end

end

return Game
