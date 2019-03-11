local http_client = require("http.client")
local json = require("json")
local tap = require("tap")

local case = {}

local test = tap.test('api_test')
local url = 'http://89.223.94.187:8080/kv'

local test_data = {
    {key = "1", value = {}},
    {key = "2", value = {a = 'b'}}
}

function test_post_succes()    
    for test_index = 1, #test_data do
        test:is(
            http_client.post(url, json.encode(test)).status, 200, "Succes POST")
    end
end

case.tests = {
    test_post_succes
}










function run()
    for case_index = 1, #case.tests do
        case.tests[case_index]()
    end
end

run()
