local t = require('luatest')
local g = t.group('positive')

local helpers = require('test.helpers')

local http_client = require("http.client")
local json = require("json")

local value = {a = 'str'}

g.test_post_string = function()
    local body = {key = helpers.random_key(), value = 'value'}
    t.assert_equals(http_client.post(helpers.api_url, json.encode(body)).status, 200)
end

g.test_post_nubmer = function()
    local body = {key = helpers.random_key(), value = 1}
    t.assert_equals(http_client.post(helpers.api_url, json.encode(body)).status, 200)
end

g.test_post_map = function()
    local body = {key = helpers.random_key(), value = {a = 'a'}}
    t.assert_equals(http_client.post(helpers.api_url, json.encode(body)).status, 200)
end

g.test_post_array = function()
    local body = {key = helpers.random_key(), value = {'a', 'a'}}
    t.assert_equals(http_client.post(helpers.api_url, json.encode(body)).status, 200)
end

g.test_get = function()
    local body = {key = helpers.random_key(), value = value}
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 200, "Error during POST req")

    local resp = http_client.get(helpers.url_join(body.key))
    t.assert_equals(resp.status, 200)
    t.assert_equals(resp.body, json.encode(body.value), "Incorrect body")
end


g.test_put = function()
    local body = {key = helpers.random_key(), value = {x=0}}
    t.assert_equals(
        http_client.post(helpers.api_url, json.encode(body)).status, 200, "Error during POST req")

    body.value = value

    t.assert_equals(
        http_client.put(helpers.url_join(body.key), json.encode(body)).status, 200)

    local resp = http_client.get(helpers.url_join(body.key))
    t.assert_equals(resp.status, 200, "Error during GET req")
    t.assert_equals(resp.body, json.encode(body.value), "Incorrect body")
end


g.test_delete = function()
    local body = {key = helpers.random_key(), value = value}
    http_client.post(helpers.api_url, json.encode(body))

    local resp = http_client.delete(helpers.url_join(body.key))
    t.assert_equals(resp.status, 200, head_status)
    t.assert_equals(resp.body, json.encode(body.value))

    t.assert_equals(
        http_client.get(helpers.url_join(body.key)).status, 404, "The record has not been deleted")
end
