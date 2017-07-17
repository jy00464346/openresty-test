--
-- User: muzhongyuan
-- Date: 2017/7/10 10:38
-- Comm: 
--
local ngx = ngx

local logger_m = require "core.file_log"
local b = require "core.buffer"

--local logger = require "core.logging.rolling_file"("logs/test.log", 50 * 1024 * 1024, 100, "%message\n")
local now = ngx.now
local update = ngx.update_time

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "log"

local conf = {}
conf.path = "logs/test.log"
local logger

local function entry_handle(buffer, entries)
    local logs = ''
    for i = 1, #entries do
        logs = logs .. entries[i] .. "\n"
    end
    logger:log(logs)
    return true
end

local buffer


function _M.handle(self)
    if not logger then
        logger = logger_m.new(conf)
    end
    if not buffer then
        buffer = b.new({
            entry_handle = entry_handle
        })
    end
    update()
    local b = now()
    ngx.log(ngx.ERR, "begin ....", b)
    for i = 1, 10000 do
        --        logger.log(false, conf, i .. "-log test....\n")
        --        logger:log(conf, i .. "-log test....")
        buffer:add_entry(i .. '-log test....')
    end
    --    update()
    local c = now()
    ngx.log(ngx.ERR, "@@@@@@", c)
end



return _M