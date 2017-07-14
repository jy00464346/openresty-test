--
-- User: muzhongyuan
-- Date: 2017/7/10 10:38
-- Comm: 
--
local ngx = ngx

local logger = require "core.file-log"
local b = require "core.buffer"

--local logger = require "core.logging.rolling_file"("logs/test.log", 50 * 1024 * 1024, 100, "%message\n")
local now = ngx.now
local update = ngx.update_time

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "log"

local conf = {}
conf.path = "logs/test.log"

local function entry_handle(buffer, entries)
    local logs = ''
    local size = #entries
    for i = 1, size do
        logs = logs .. entries[i] .. "\n"
    end
    logger.log(false, conf, logs)
    return true
end

local buffer = b.new({
    entry_handle = entry_handle
})


function _M.handle(self)
    update()
    local b = now()
    ngx.log(ngx.ERR, "begin ....", b)
    for i = 1, 10000 do
        logger.log(false, conf, i .. "-log test....\n")
        --        logger:log(conf, i .. "-log test....")
        --        buffer:add_entry(i .. '-log test....')
    end
    --    local c = now()
end



return _M