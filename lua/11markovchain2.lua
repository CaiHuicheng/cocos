-- --[[

-- 	马尔科夫链算法文本生成器
-- 	当给定一段文本，第一个单词作为后缀的对应前缀是“# #”

-- --]]
-- -- read input line and split into words for return
-- function returnWords ()
-- 	local line = io.read()
-- 	local pos = 1
-- 	return function ()
-- 		while line do
-- 			local _start , _end = string.find(line , "%w+" , pos)
-- 			if(_start) then
-- 				pos = _end + 1
-- 				return string.sub(line , _start , _end)
-- 			else
-- 				line = io.read()
-- 				pos = 1
-- 			end
-- 		end
-- 		return nil
-- 	end
-- end



-- function genpairs(w1 , w2)
-- 	return (w1.." "..w2)
-- end

-- stattable = {} --a global var which stands for the vocabulary table
-- --insert (key ,values) in stattable
-- function insert(index , value)
-- 	if not stattable[index] then
-- 		stattable[index] = {value}
-- 	else
-- 		table.insert(stattable[index] , value)
-- 	end
-- end
-- --build stattable
-- function init()
-- 	local placeholers1 = "#"
-- 	local placeholers2 = "#"
-- 	for value in returnWords() do
-- 		key = genpairs(placeholers1 , placeholers2)
-- 		insert(key , value)
-- 		placeholers1 = placeholers2
-- 		placeholers2 = value
-- 	end
-- 	insert(genpairs(placeholers1 , placeholers2) , "#")
-- end
-- --return num of elements of a table
-- function getn(table)
-- 	local MAXNUM = 100
-- 	local count = 0
-- 	for num = 1 , MAXNUM do
-- 		if table[num] ~= nil then
-- 			count = count + 1
-- 		else
-- 			break;
-- 		end
-- 	end
-- 	return count
-- end
-- --generate text
-- local MAXWORDS = 100
-- local word1 = "#"
-- local word2 = "#"
-- init()
-- for i = 1 , MAXWORDS do
-- 	local textunit = stattable[genpairs(word1 , word2)]
-- 	local num = getn(textunit)
-- 	local xx = math.random(num)
-- 	local textword = textunit[xx]
-- 	if "#" ~= textword then
-- 		io.write(textword , " ")
-- 		word1 = word2
-- 		word2 = textword
-- 	else
-- 		io.write("\n")
-- 		break
-- 	end
-- end

-- Auxiliary definitions for the Markov program

function allwords ()
    local line = io.read() -- current line
    local pos = 1 -- current position in the line
    return function () -- iterator function
        while line do -- repeat while there are lines
            local s, e = string.find(line, "%w+", pos)
            if s then -- found a word?
                pos = e + 1 -- update next position
                return string.sub(line, s, e) -- return the word
            else
                line = io.read() -- word not found; try next line
                pos = 1 -- restart from first position
            end
        end
        return nil -- no more lines: end of traversal
    end
end

function prefix (w1, w2)
    return w1 .. " " .. w2
end

local statetab = {}

function insert (index, value)
    local list = statetab[index]
    if list == nil then
        statetab[index] = {value}
    else
        list[#list + 1] = value
    end
end


-- The Markov program

local N = 2
local MAXGEN = 10000
local NOWORD = "\n"

-- build table
local w1, w2 = NOWORD, NOWORD
for w in allwords() do
    insert(prefix(w1, w2), w)
    w1 = w2; w2 = w;
end
insert(prefix(w1, w2), NOWORD)

-- generate text
w1 = NOWORD; w2 = NOWORD -- reinitialize
for i=1, MAXGEN do
    local list = statetab[prefix(w1, w2)]
    -- choose a random item from list
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then return end
    io.write(nextword, " ")
    w1 = w2; w2 = nextword
end