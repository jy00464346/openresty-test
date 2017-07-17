--
-- User: muzhongyuan
-- Date: 2017/7/17 08:59
-- Comm: 
--
local remove = table.remove
local concat = table.concat

local array = {}

for i = 1, 10 do
    array[i] = i
end

local re = remove(array, 1)
print(re)
for k, v in pairs(array) do
    print(k, v)
end

local c = concat(array,',',1,5)
print(type(c))
print(c)
