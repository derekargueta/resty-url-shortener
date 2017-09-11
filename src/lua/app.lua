
local args = ngx.req.get_uri_args()

function create_md5()
  local resty_md5 = require "resty.md5"
  local md5 = resty_md5:new()
  if not md5 then
    ngx.say("failed to create md5 object")
    return
  end

  return md5
end

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

function hash_url(url)
  local ok = md5:update(url)
  if not ok then
    ngx.say("failed to add data")
    return
  end

  local str = require "resty.string"
  local digest = str.to_hex(md5:final())

  local first_six = string.sub(digest, 0, 6)
  ngx.say("md5: ", first_six)

  ok, err = red:set(first_six, url)
  if not ok then
    ngx.say("Failed to save URL hash: ", err)
    return
  end
end

function lookup_url(url, redis)
  local res, err = redis:get(url)
  if not res then
    ngx.say("failed to get URL: ", err)
    return
  end

  return res
end

------- Main logic
local red = get_redis_conn()
local md5 = create_md5()
local url_arg = args["url"]
if url_arg then
  hash_url(url_arg)
end


local get = args["get"]
if get then

  local url = lookup_url(get, red)
  if url == ngx.null then
    ngx.say("Couldn't find URL for hash " .. get)
  else
    ngx.say('Found ' .. url .. ' for hash ' .. get)
  end
end

ngx.say('<p>Hello, world!</p>')
