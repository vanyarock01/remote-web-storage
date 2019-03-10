local log = require('log')
local json = require('json')

local handler = {}
    
handler.post_method = function(self)
    log.info("POST_METHOD")
    return {}
end

handler.put_method = function(self)
    log.info("PUT_METHOD")
    return {}
end

handler.get_method = function(self)
    log.info("GET_METHOD")
    return {}
end

handler.delete_method = function(self)
    log.info("DELETE_METHOD")
    return {}
end

return handler
