local cjson = require "cjson.safe"
local encode = cjson.encode
local setmetatable = setmetatable
local timer_at = ngx.timer.at
local nlog = ngx.log
local remove = table.remove
--local huge = math.huge
local type = type
local now = ngx.now
local ERR = ngx.ERR
local pcall = pcall
local update_time = ngx.update_time


local def_buffer_max_bytes = 200 * 1024 * 1024 --200m TODO bytes limit
local def_buffer_max_size = 10000
local def_flush_interval = 100 -- ms
local def_batch_sizie = 2000 -- 1000 or 100ms flush buffer

local _M = {}

local _mt = {
    __index = _M
}

local function now_time()
    return now() * 1000
end

local _flush = function(premature, self)
    if premature then return
    else
        self:flush()
    end
end

local _flush_checker
_flush_checker = function(premature, self)
    if premature then return end
    if now_time() - self.last_flush >= self.flush_interval and self.buffer_size > 0 then
        local f_size = #self.flush_entries
        self.flush_entries[f_size + 1] = self.entries
        self.entries = {}
        --        nlog(ERR, "flush by timer ...", "buffer_size=", self.buffer_size, ",c_size=", idx, ",last_flush=", self.last_flush)
        local ok, err = timer_at(0, _flush, self)
        if not ok then
            nlog(ERR, "failed to create flush timer: ", err)
            return ok, err
        end
    end
    local ok, err = timer_at(self.flush_interval / 1000, _flush_checker, self)
    if not ok then
        nlog(ERR, "failed to create flush checker timer: ", err)
        return ok, err
    end
end

function _M.new(conf)
    local conf = conf or {}
    if not conf.entry_handle or type(conf.entry_handle) ~= "function" then
        return nil, "buffer's entry handle must be a function !"
    end
    if conf.data_handle and type(conf.data_handle) ~= "function" then
        return nil, "data handle must be a function !"
    end
    local buffer = {
        buffer_max_bytes = conf.buffer_max_bytes or def_buffer_max_bytes,
        buffer_max_size = conf.buffer_max_size or def_buffer_max_size,
        flush_interval = conf.flush_interval or def_flush_interval,
        batch_size = conf.batch_sizie or def_batch_sizie,
        buffer_bytes = 0,
        buffer_size = 0,
        entries = {},
        flush_entries = {},
        last_flush = now_time(),
        data_handle = conf.data_handle, -- data handle
        entry_handle = conf.entry_handle -- buffer handle
    }
    local m = setmetatable(buffer, _mt)
    local ok, err = timer_at(m.flush_interval / 1000, _flush_checker, m)
    if not ok then
        nlog(ERR, "failed to create flush checker timer: ", err)
        return ok, err
    end
    return m
end

function _M:flush()
    local size = #self.flush_entries
    if size == 0 then
        return true
    end
    local entries = remove(self.flush_entries, 1)
    local f_size = #entries
    if f_size == 0 then
        return true
    end
    --[[local bytes = 0
    for i = 1, size do
        local entry = remove(self.entries, 1)
        if entry then
            local json = type(entry) ~= "table" and entry or encode(entry)
            local s = #json
            if self.buffer_bytes + s > self.buffer_max_bytes then
                nlog(ERR, "buffer is full, discarding this entry :" .. json)
                break
            end
            entries[i] = json;
            self.buffer_bytes = self.buffer_bytes + s
            bytes = bytes + s
        end
    end]]
    local result, ok, err = pcall(self.entry_handle, self, entries)
    if not result or not ok then
        nlog(ERR, "buffer entry handle failed :", result and err or ok)
    end
    --    self.buffer_bytes = self.buffer_bytes - bytes
    self.buffer_size = self.buffer_size - f_size
    self.last_flush = now_time()
    --    nlog(ERR, "buffer flush end :", self.buffer_size, ",", self.last_flush)
    return true
end

function _M:add_entry(...)
    local buffer_size = self.buffer_size
    local c_size = #self.entries
    if buffer_size >= self.buffer_max_size then
        local err = "buffer overflow max size is " .. self.buffer_max_size
        nlog(ERR, err)
        return nil, err
    end
    local idx = c_size + 1
    local entry
    if self.data_handle then
        local result, ok, err = pcall(self.data_handle, ...)
        if not result or not ok then
            nlog(ERR, "buffer data handle failed :", result and err or ok)
            return result and ok, err
        end
        entry = ok
    end
    self.entries[idx] = entry or ...
    self.buffer_size = buffer_size + 1
    if idx >= self.batch_size then
        local f_size = #self.flush_entries
        self.flush_entries[f_size + 1] = self.entries
        self.entries = {}
        --        nlog(ERR, "flush by timer ...", "buffer_size=", self.buffer_size, ",c_size=", idx, ",last_flush=", self.last_flush)
        local ok, err = timer_at(0, _flush, self)
        if not ok then
            nlog(ERR, "failed to create flush timer: ", err)
            return ok, err
        end
    end
    return true
end


return _M
