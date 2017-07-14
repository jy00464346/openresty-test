--
-- User: muzhongyuan
-- Date: 2017/7/10 10:37
-- Comm: 
--

local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "init_worker"

function _M.handle(self)
    ngx.log(ngx.ERR, 'init_worker...')
end


return _M

