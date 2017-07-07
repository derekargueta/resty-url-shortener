FROM openresty/openresty:xenial

# Lua linter
RUN luarocks install luacheck

