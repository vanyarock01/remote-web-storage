local t = require('luatest')
local g = t.group('negative')

local helpers = require('test.helpers')

local http_client = require("http.client")
local json = require("json")

g.test_post_already_exist = function()
    local body = {key = helpers.random_key(), value = {c = 'd'}}
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 200, "Error during OK POST req")
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 409)
end

g.test_post_invalid_data = function()
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode({key = 3, value = {}})).status,
        400, "Invalid key type")

    t.assert_equals(
        http_client.post(helpers.api_url, json.encode({keys = '4', value = {'a', 'b'}})).status,
        400, "Inavlid body structure")

    t.assert_equals(
        http_client.post(helpers.api_url, json.encode({key = '5', val = {}})).status,
        400, "Invalid value: array") -- #WARN: lua json table conversion ('{}' -> [])

    t.assert_equals(
        http_client.post(helpers.api_url, json.encode({key = '6', value = '10'})).status,
        400, "Ivalid value: number")
end

g.test_get_not_found = function()
    t.assert_equals(http_client.get(helpers.url_join(helpers.random_key())).status, 404)
end

g.test_delete_not_found = function()
    t.assert_equals(http_client.delete(helpers.url_join(helpers.random_key())).status, 404)
end

g.test_put_not_found = function()
    t.assert_equals(
        http_client.put(helpers.url_join(helpers.random_key()), json.encode({value = {'data'}})).status, 404)
end

function test_put_invalid_data()
    local body = {key = helpers.random_key(), value = {c = 'd'}}
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 200, "Error during OK POST req")

    t.assert_equals(
        http_client.put(route, json.encode({val = {}})).status,
        400, "Invalid value: array")

    t.assert_equals(
        http_client.put(route, json.encode({value = 1})).status,
        400, "Invalid value: number")

    t.assert_equals(
        http_client.put(route, json.encode({value = 'string'})).status,
        400, "Invalid value: string")
end
