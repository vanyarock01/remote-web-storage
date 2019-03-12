local http_client = require("http.client")
local json = require("json")
local tap = require("tap")

local case = {}

local test = tap.test('api_test')
local url = 'http://89.223.94.187:8080/kv'


function test_post_succes()
    local head = 'POST: succes'
    local body = {key = '1', value = {'a', 'a'}}
    test:is(
        http_client.post(url, json.encode(body)).status, 200, head)
end

function test_post_alredy_exist()
    local head = 'POST: already exist'
    local body = {key = '2', value = {c = 'd'}}
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
    local head_status = 'GET: succes status'
    local head_data = 'GET: succes data'
    local data = {
        {key = '7', value = {a = 'string'}},
        {key = '8', value = {'1', '2', '3', 'a', 'v', 'b'}}
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
    head = 'GET: Key not found'
    local body = {key = 'null', value = {}}
    test:is(
        http_client.get(string.format('%s/%s', url, body.key)).status, 404, head)
end

case.tests = {
    test_post_succes,
    test_post_alredy_exist,
    test_post_invalid_data,
    test_get_succes,
    test_get_not_found
}


function run()
    for case_index = 1, #case.tests do
        case.tests[case_index]()
    end
end

run()
