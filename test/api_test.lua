#!/usr/bin/env tarantool

local http_client = require("http.client")
local json = require("json")
local tap = require("tap")

local case = {}

local test = tap.test('api_test')
local url = 'http://87.239.109.51:8080/kv'

local test_is = test.is
function test.is(...)
    require('fiber').sleep(1)
    return test_is(...)
end

local function rnd() return require('digest').urandom(12):hex() end

function test_post_succes()
    local head = 'POST: succes'
    local body = {key = rnd(), value = {'a', 'a'}}
    test:is(
        http_client.post(url, json.encode(body)).status, 200, head)
end


function test_post_alredy_exist()
    local head = 'POST: already exist'
    local body = {key = rnd(), value = {c = 'd'}}
    test:is(
        http_client.post(url, json.encode(body)).status, 200, head)
    test:is(
        http_client.post(url, json.encode(body)).status, 409, head)
end


function test_post_invalid_data()
    head = 'POST: invalid data'
    local data = {
        {key = 3, value = {}},
        {keys = '4', value = {'a', 'b'}},
        {key = '5', val = {}},
        {key = '6', value = '10'}
    }
    test:is(
        http_client.post(url, json.encode(data[1])).status, 400, head)
    test:is(
        http_client.post(url, json.encode(data[2])).status, 400, head)
    test:is(
        http_client.post(url, json.encode(data[3])).status, 400, head)
    test:is(
        http_client.post(url, json.encode(data[4])).status, 400, head)
end


function test_get_succes()
    local head_status = 'GET:  succes status'
    local head_data = 'GET:  succes data'
    local data = {
        {key = rnd(), value = {a = 'string'}},
        {key = rnd(), value = {'1', '2', '3', 'a', 'v', 'b'}}
    }
    http_client.post(url, json.encode(data[1]))
    http_client.post(url, json.encode(data[2]))

    local resp = http_client.get(string.format('%s/%s', url, data[1].key))
    test:is(resp.status, 200, head_status)
    test:is(resp.body, json.encode(data[1].value), head_data)

    resp = http_client.get(string.format('%s/%s', url, data[2].key))
    test:is(resp.status, 200, head_status)
    test:is(resp.body, json.encode(data[2].value), head_data)
end


function test_get_not_found()
    local head = 'GET:  key not found'
    local body = {key = 'null', value = {}}
    test:is(
        http_client.get(string.format('%s/%s', url, body.key)).status, 404, head)
end


function test_put_succes()
    local head = 'PUT:  succes'
    local data = {
        {key = rnd(), value = {}},
        {value = {'1','2'}}
    }
    http_client.post(url, json.encode(data[1]))
    test:is(http_client.put(
        string.format('%s/%s', url, data[1].key),
        json.encode(data[2])).status, 200, head)
end


function test_put_invalid_data()
    local head = 'PUT:  invalid data'
    local data = {
        {key = '10', value = {}},
        {val = {}},
        {value = 1},
        {value = 'string'}
    }
    route = string.format('%s/%s', url, data[1].key)
    http_client.post(url, json.encode(data[1]))

    test:is(
        http_client.put(route, json.encode(data[2])).status, 400, head)

    test:is(
        http_client.put(route, json.encode(data[3])).status, 400, head)

    test:is(
        http_client.put(route, json.encode(data[4])).status, 400, head)
end


function test_put_not_found()
    local head = 'PUT:  key not found'
    local key = 'null'
    local data = {value = {}}
    test:is(http_client.put(
        string.format('%s/%s', url, key), json.encode(data)).status, 404, head)
end


function test_delete_succes()
    local head_status = 'DEL:  succes status'
    local head_data = 'DEL:  succes data'

    local data = {key = rnd(), value = {a = 'string'}}
    http_client.post(url, json.encode(data))

    local resp = http_client.delete(string.format('%s/%s', url, data.key))
    test:is(resp.status, 200, head_status)
    test:is(resp.body, json.encode(data.value), head_data)
end


function test_delete_not_found()
    local head = 'DEL:  key not found'
    local body = {key = 'null', value = {}}
    test:is(
        http_client.delete(string.format('%s/%s', url, body.key)).status, 404, head)
end


case.tests = {
    test_post_succes,
    test_post_alredy_exist,
    test_post_invalid_data,

    test_get_succes,
    test_get_not_found,

    test_put_succes,
    test_put_invalid_data,
    test_put_not_found,

    test_delete_succes,
    test_delete_not_found
}


function run()
    for case_index = 1, #case.tests do
        case.tests[case_index]()
    end
end

run()
