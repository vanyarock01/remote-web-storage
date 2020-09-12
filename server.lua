#!/usr/bin/env tarantool

local json = require('json')
local handler = require('handler')
local conf = require('config')

box.cfg{
    listen = conf.listen,
    log_format = conf.log_format,
    log = conf.log_file,
    background = conf.back,
    pid_file = conf.pid
}

box.once('init', function()
    box.schema.create_space('dict')
    box.space.dict:create_index(
        'primary', {type = 'hash', parts = {1, 'string'}})
end)

local http_router = require('http.router')
local http_server = require('http.server')

local server = http_server.new(
    nil,conf.port, { log_requests = true, log_errors = true })

local router = http_router.new()

router:route({
    path = handler.path_get, method = 'GET'}, handler.get_method)

router:route({
    path = handler.path_post, method = 'POST'}, handler.post_method)

router:route({
    path = handler.path_put, method = 'PUT'}, handler.put_method)

router:route({
    path = handler.path_delete, method = 'DELETE'}, handler.delete_method)

server:set_router(router)
server:start()
