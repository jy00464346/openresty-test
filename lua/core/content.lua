--
-- User: muzhongyuan
-- Date: 2017/7/10 10:38
-- Comm: 
--
local ngx = ngx

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "content"


function _M.handle(self)
    ngx.log(ngx.ERR, 'content...')
end



return _M

