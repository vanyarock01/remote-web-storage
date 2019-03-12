local http_client = require("http.client")
local json = require("json")
local tap = require("tap")

local case = {}

local test = tap.test('api_test')
local url = 'http://89.223.94.187:8080/kv'


function test_post_succes()
    local body = {key = '1', value = {'a', 'a'}}
    test:is(
        http_client.post(url, json.encode(body)).status, 200, "Succes: POST")
end

function test_post_alredy_exist()    
    local body = {key = '2', value = {c = 'd'}}
    test:is(
        http_client.post(url, json.encode(body)).status, 200, "Succes: POST")
    test:is(
        http_client.post(url, json.encode(body)).status, 409, "Key alredy exist: POST")
end

function test_post_invalid_data()
    local data = {
        {key = 3, value = {}},
        {keys = '4', value = {'a', 'b'}},
        {key = '5', val = {}},
        {key = '6', value = '10'}
    }
    test:is(
        http_client.post(url, json.encode(data[1])).status, 400, "Invalid_data: POST")
    test:is(
        http_client.post(url, json.encode(data[2])).status, 400, "Invalid_data: POST")
    test:is(
        http_client.post(url, json.encode(data[3])).status, 400, "Invalid_data: POST")
    test:is(
        http_client.post(url, json.encode(data[4])).status, 400, "Invalid_data: POST")
end

case.tests = {
    test_post_succes,
    test_post_alredy_exist,
    test_post_invalid_data
}


function run()
    for case_index = 1, #case.tests do
        case.tests[case_index]()
    end
end

run()