
local args = ngx.req.get_uri_args()
local template = require('resty.template')


-- Returns true if `String` starts with `Start`
function string.starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

-- Returns true if the string `url` starts with a correct HTTP scheme
function url_has_scheme(url)
  return string.starts(url, "http://") or string.starts(url, "https://")
end

function create_md5()
  local resty_md5 = require("resty.md5")
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
  local md5 = create_md5()
  local red = get_redis_conn()
  local ok = md5:update(url)
  if not ok then
    ngx.say("failed to add data")
    return
  end

  local str = require("resty.string")
  local digest = str.to_hex(md5:final())

  local first_six = string.sub(digest, 0, 6)

  ok, err = red:set(first_six, url)
  if not ok then
    ngx.say("Failed to save URL hash: ", err)
    return
  end

  template.render("result.html", { url = url, first_six = first_six })
end

------- Main logic
local url_arg = args["url"]
if url_arg then
  if not url_has_scheme(url_arg) then
    url_arg = "http://" .. url_arg
  end
  hash_url(url_arg)
else
  template.render('index.html')
end

