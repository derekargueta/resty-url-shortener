
-- local redis = require("resty.redis")
-- local red = redis:new()

-- red:set_timeout(1000) -- 1 sec

-- local ok, err = red:connect("127.0.0.1", 6379)
-- if not ok then
--   ngx.say("failed to connect: ", err)
--   return
-- end

-- ok, err = red:set("dog", "animal")
-- if not ok then
--   ngx.say("failed to set dog: ", err)
--   return
-- end

-- ngx.say("set result: ", ok)

-- local res, err = red:get("dog")
-- if not res then
--   ngx.say("failed to get dog: ", err)
--   return
-- end

-- if res == ngx.null then
--   ngx.say("dog not found.")
--   return
-- end

ngx.say('<p>Hello, world!</p>')
