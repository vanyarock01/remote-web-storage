#!/usr/bin/env tarantool

local json = require('json')
local handler = require('handler')

box.cfg{log_format = 'json', log = 'server.log'}
box.once('init', function()
    box.schema.create_space('dict')
    box.space.base:create_index(
        "primary", {type = 'hash', parts = {1, 'string'}}
    )
    end
)

local server = require('http.server').new(nil, 8080)

server:route({path = '/', method = "GET"}, handler.get_method)

server:start()
