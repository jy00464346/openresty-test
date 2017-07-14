--
-- User: muzhongyuan
-- Date: 2017/7/10 10:37
-- Comm: 
--
local ngx = ngx

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "rewrite"


function _M.handle(self)
    ngx.log(ngx.ERR, 'rewrite...')
end



return _M


