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

local a = 17
print(a % 17)
local b = {}
b[0] = 100

print(b[0])
for k, v in pairs(b) do
    print(k,v)
end
print(100/1000)

local abc = function (...)
    print(select(1,...))
end
abc(1,2,3,4,5)