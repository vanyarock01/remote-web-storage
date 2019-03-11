local log = require('log')
local json = require('json') 

local handler = {}

handler.path_post = '/kv'
handler.post_method = function(req)
    
    local status, body = pcall(req.json, req)
    local key, val = body['key'], body['value']
    
    
    if (not status) or (type(key) ~= 'string') or
            (type(val) ~= 'table') then
        log.info('ER: invalid data')
        return { status = 400 }
    end

    local status, data = pcall(
        box.space.dict.insert, box.space.dict, {key, val})
    
    if status then
        log.info('OK')
        log.info(data)
        return { status = 200 }
    else
        log.info('ER: ' .. data.message)
        if data.code == 3 then -- ER_TUPLE_FOUND 
            return { status = 409 }
        else
            return { status = 500 }
        end
    end
end

handler.path_put = '/kv/:key'
handler.put_method = function(self)
    return {}
end

handler.path_get = '/kv/:key'
handler.get_method = function(req)
    local key = req:stash('key')
    local status, data = pcall(
        box.space.dict.get, box.space.dict, key) 

    if status and data then
        log.info('OK')
        log.info(data)
        return {
            status = 200,
            body = json.encode(data[2])
        }
    elseif data == nil then
        log.info('ER: key not found: ' .. key )
      	return { status = 404 }
    else
        log.info('ER: ' .. data.message)
        return { status = 500 } -- может быть ER_NO_SUCH_SPACE 
    end
end

handler.path_delete = '/kv/:key'
handler.delete_method = function(self)
    log.info('DELETE_METHOD')
    return {}
end

return handler

