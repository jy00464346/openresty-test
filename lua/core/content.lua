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
    ngx.log(ngx.ERR,'request_length=',ngx.var.request_length)
    local args, err = ngx.req.get_uri_args()
    local res = ngx.location.capture('http://localhost:81/spe_md5?key=123123',
        {
            method = ngx.HTTP_POST,
            body = args.data
        })
    if 200 ~= res.status then
        ngx.exit(res.status)
    end

    for key, val in pairs(res.header) do
        if type(val) == "table" then
            ngx.log(ngx.ERR, key, "=>", table.concat(val, ","))
        else
            ngx.log(ngx.ERR, key, "=>", val)
        end
    end


    local h = ngx.resp.get_headers()
    for k, v in pairs(h) do
        ngx.log(ngx.ERR, k, '=', v)
    end

    ngx.print(res.body)
    --    if args.key == res.body then
    --        ngx.say("valid request")
    --    else
    --        ngx.say("invalid request")
    --    end
end



return _M

