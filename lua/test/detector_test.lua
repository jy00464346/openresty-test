--
-- User: muzhongyuan
-- Date: 2017/7/17 14:24
-- Comm: 
--
local f = require "lua.core.frequency_detector"

local detector = f.new({
    max_times = 1000,
    duration = 100
})

for i = 1, 10000 do
    local t = detector:occur()
    if t then
        print('frequency_detector..')
    end
end

