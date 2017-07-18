--
-- User: muzhongyuan
-- Date: 2017/7/12 15:41
-- Comm: 
--

local ffi = require "ffi"
--local cjson = require "cjson"

local nlog = ngx.log
local ERR = ngx.ERR
local setmetatable = setmetatable

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

local times = 0

local _M = {}

local _mt = {
    __index = _M
}

function _M.new(conf)
    local logger = {
        file_descriptor = nil,
        path = conf.path
    }
    return setmetatable(logger, _mt)
end

function _M:log(message)
    local fd = self.file_descriptor
    times = times + 1
    if not fd then
        nlog(ERR, oflags, mode, self.path)
        fd = ffi.C.open(self.path, oflags, mode)
        if fd < 0 then
            local errno = ffi.errno()
            nlog(ERR, "[file-log] failed to open the file: ", ffi.string(ffi.C.strerror(errno)))
        else
            self.file_descriptor = fd
        end
    end
    ffi.C.write(fd, message, #message)
end

return _M
