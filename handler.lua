local log = require('log')
local json = require('json')

local handler = {}

handler.post_method = function(self)
    local body = self:json()
    local key, val = body['key'], body['value']

    if type(key) ~= 'string' or
            type(val) ~= 'table' then
        return {status = 400} 
    end
    status, ret = pcall(box.space.dict.insert, box.space.dict, {key, value})
    log.info(ret)
    if not status then
        if ret.code == 3 then -- ER_TUPLE_FOUND 
            return {status = 409}
        else
            return {status = 500}
        end
    end 

    return {status = 200}
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
