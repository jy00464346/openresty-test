--
-- User: muzhongyuan
-- Date: 2017/7/17 14:07
-- Comm: 用于检测在一段时间内事件发生是否过于频繁
--
local setmetatable = setmetatable
local now = ngx.now

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "frequency_detector"

local _mt = {
    __index = _M
}

function _M.new(conf)
    local detector = {
        max_times = conf.max_times,
        duration = conf.duration,
        queue = {},
        count = 0
    }
    return setmetatable(detector, _mt)
end

function _M:frequently()
    local c = self.count
    local max_times = self.max_times
    if c >= max_times then
        local e = self.queue[c % max_times]
        local s = self.queue[(c - max_times + 1) % max_times]
        if e - s < self.duration then --过于频率发生
            return true
        else
            return false
        end
    else
        return false
    end
end

function _M:occur()
    local next = self.count + 1
    self.queue[next % self.max_times] = now() * 1000
    self.count = next;
    return self:frequently()
end

return _M

