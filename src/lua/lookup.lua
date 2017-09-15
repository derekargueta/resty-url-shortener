
function get_redis_conn()
  local redis = require("resty.redis")
  local red = redis:new()
  red:set_timeout(1000) -- 1 sec
  -- host "redis" is defined by docker-compose
  local ok, err = red:connect("redis", 6379)
  if not ok then
    ngx.say("failed to connect: ", err)
    return
  end

  return red
end

function lookup_url(url, redis)
  local res, err = redis:get(url)
  if not res then
    ngx.say("failed to get URL: ", err)
    return
  end

  return res
end

local lookup_candidate = string.sub(ngx.var.request_uri, 2, -1)

local red = get_redis_conn()
local url = lookup_url(lookup_candidate, red)
if url == ngx.null then
  ngx.say("Couldn't find URL for hash " .. lookup_candidate)
else
  ngx.redirect(url)
  -- ngx.say('Found ' .. url .. ' for hash ' .. lookup_candidate)
end
