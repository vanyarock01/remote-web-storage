#!/usr/bin/env tarantool

local json = require('json')
local handler = require('handler')
local conf = require('config')

box.cfg{log_format = conf.log_format, log = conf.log_file}
box.once('init', function()
    box.schema.create_space('dict')
    box.space.dict:create_index(
        "primary", {type = 'hash', parts = {1, 'string'}}
    )
    end
)

local server = require('http.server').new(nil, conf.port)

server:route({path = '/kv/:key', method = "GET"}, handler.get_method)
server:route({path = '/kv', method = "POST"}, handler.post_method)

server:start()
