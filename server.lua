box.cfg{log_format = 'json', log = 'server.log'}
box.once('init', function()
    box.schema.create_space('dict')
    box.space.base:create_index(
        "primary", {type = 'hash', parts = {1, 'string'}}
    )
    end
)

