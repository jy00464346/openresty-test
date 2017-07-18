--
-- User: muzhongyuan
-- Date: 2017/7/10 10:38
-- Comm: 
--

local ngx = ngx
local bls = require "ngx.balancer"

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "balancer"


function _M.handle(self)
--    ngx.log(ngx.ERR, 'blancer...',ngx.ctx.balance_uri)
    local ok, err = bls.set_current_peer('127.0.0.1', 81);
    if not ok then
        ngx.log(ngx.ERR, "[balancer] failed to set the current peer: ", err)
--        ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
end


return _M