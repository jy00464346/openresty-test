--
-- User: muzhongyuan
-- Date: 2017/7/12 15:41
-- Comm: 
--

-- Copyright (C) Mashape, Inc.


local ffi = require "ffi"
local cjson = require "cjson"

local ngx_timer = ngx.timer.at
local now = ngx.now
local update = ngx.update_time

local O_CREAT = 0x0200
local O_WRONLY = 0x0001
local O_APPEND = 0x0008
local S_IRUSR = 00400
local S_IWUSR = 00200
local S_IRGRP = 00040
local S_IROTH = 00004

local oflags = bit.bor(O_WRONLY, O_CREAT, O_APPEND)
local mode = bit.bor(S_IRUSR, S_IWUSR, S_IRGRP, S_IROTH)

ffi.cdef [[
int open(const char * filename, int flags, int mode);
int write(int fd, const void * ptr, int numbytes);
int close(int fd);
char *strerror(int errnum);
]]

-- fd tracking utility functions
local file_descriptors = {}

local times = 0
local FileLogHandler = {}


-- Log to a file. Function used as callback from an nginx timer.
-- @param `premature` see OpenResty `ngx.timer.at()`
-- @param `conf`     Configuration table, holds http endpoint details
-- @param `message`  Message to be logged
function FileLogHandler.log(premature, conf, message)
    if premature then
        return
    end
    local fd = file_descriptors[conf.path]
    times = times + 1
    if fd and conf.reopen then
        -- close fd, we do this here, to make sure a previously cached fd also
        -- gets closed upon dynamic changes of the configuration
        ffi.C.close(fd)
        file_descriptors[conf.path] = nil
        fd = nil
    end

    if not fd then
        ngx.log(ngx.ERR, oflags, mode, conf.path)
        fd = ffi.C.open(conf.path, oflags, mode)
        if fd < 0 then
            local errno = ffi.errno()
            ngx.log(ngx.ERR, "[file-log] failed to open the file: ", ffi.string(ffi.C.strerror(errno)))
        else
            file_descriptors[conf.path] = fd
        end
    end
    ffi.C.write(fd, message, #message)
    if times >= 10000 then
        update()
        ngx.log(ngx.ERR,"end ..." .. now())
    end
end



--[[function FileLogHandler:log(conf, message)
    local ok, err = ngx_timer(0, log, conf, message)
    if not ok then
        ngx.log(ngx.ERR, "[file-log] failed to create timer: ", err, "---" .. ngx.timer.pending_count(), "----" .. ngx.timer.running_count())
    end
end]]

return FileLogHandler
