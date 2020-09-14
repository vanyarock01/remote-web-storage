local helpers = {}

assert(os.getenv('URI'), 'Usage:\n    URI="<HOST>:<PORT>" luatest')
helpers.api_url = string.format('http://%s/kv', os.getenv('URI'))

helpers.random_key = function()
    return require('digest').urandom(12):hex()
end

helpers.url_join = function(key)
    return string.format('%s/%s', helpers.api_url, key)
end

return helpers
