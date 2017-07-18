--
-- User: muzhongyuan
-- Date: 2017/7/10 10:37
-- Comm: 
--
local ngx = ngx

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "access"

function _M.handle(self)
    ngx.ctx.balance_uri = ngx.var.uri
--    ngx.log(ngx.ERR, 'access...')
end

return _M

