local helpers = {}

helpers.api_url = 'http://localhost:8080/kv'

helpers.random_key = function()
    return require('digest').urandom(12):hex()
end

helpers.url_join = function(key)
    return string.format('%s/%s', helpers.api_url, key)
end

return helpers
