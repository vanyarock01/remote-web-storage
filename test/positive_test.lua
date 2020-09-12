local t = require('luatest')
local g = t.group('positive')

local helpers = require('test.helpers')

local http_client = require("http.client")
local json = require("json")

g.test_post = function()
    local body = {key = helpers.random_key(), value = {'a', 'a'}}
    t.assert_equals(http_client.post(helpers.api_url, json.encode(body)).status, 200)
end

g.test_get = function()
    local body = {key = helpers.random_key(), value = {a = 'str'}}
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 200, "Error during POST req")

    local resp = http_client.get(helpers.url_join(body.key))
    t.assert_equals(resp.status, 200)
    t.assert_equals(resp.body, json.encode(body.value), "Incorrect body")
end


g.test_put = function()
    local body = {key = helpers.random_key(), value = {}}
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 200, "Error during POST req")

    body.value = {'1','2'}

    t.assert_equals(
        http_client.put(helpers.url_join(body.key), json.encode(body)).status, 200)

    local resp = http_client.get(helpers.url_join(body.key))
    t.assert_equals(resp.status, 200, "Error during GET req")
    t.assert_equals(resp.body, json.encode(body.value), "Incorrect body")
end


g.test_delete = function()
    local body = {key = helpers.random_key(), value = {a = 'string'}}
    http_client.post(helpers.api_url, json.encode(body))

    local resp = http_client.delete(helpers.url_join(body.key))
    t.assert_equals(resp.status, 200, head_status)
    t.assert_equals(resp.body, json.encode(body.value))

    t.assert_equals(
        http_client.get(helpers.url_join(body.key)).status, 404, "The record has not been deleted")
end
