--
-- User: muzhongyuan
-- Date: 2017/7/10 10:37
-- Comm: 
--
require "resty.core"
init_worker = require "core.init_worker"
access = require "core.access"
balancer = require "core.balancer"
body_filter = require "core.body_filter"
content = require "core.content"
header_filter = require "core.header_filter"
log = require "core.log"
rewrite = require "core.rewrite"
set = require "core.set"


local _M = {}
_M._VERSION = "1.0.0"
_M._NAME = "init"

function _M.handle(self)
    local verbose = false
    if verbose then
        local dump = require "jit.dump"
        dump.on(nil, "logs/jit.log")
    else
        local v = require "jit.v"
        v.on("logs/jit.log")
    end
    ngx.log(ngx.ERR, '@@@@@@@@@@@@@@@@@@@@@')
end
return _M

