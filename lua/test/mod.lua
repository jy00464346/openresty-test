--
-- User: muzhongyuan
-- Date: 2017/7/4 16:41
-- Comm: 
--

local M = {}

local function sayMyName()
    print("muzy")
end

function M.sayHello()
    print('Why hello there')
    sayMyName()
end

return M