RegisterNetEvent('framework:cl:exports:server_callbacks:response')
local callbacks = {}
local callbackid = 0

local function TriggerServerCallback(name, cb, ...)
    callbackid = callbackid + 1
    local id = callbackid

    callbacks[id] = cb

    TriggerServerEvent('framework:sv:exports:server_callbacks:trigger', name, id, ...)
end

local function server_callbacks_response(id, ...)
    if callbacks[id] then
        callbacks[id](...)
        callbacks[id] = nil
    end
end
AddEventHandler('framework:cl:exports:server_callbacks:response', server_callbacks_response)

local function get_player_data(pid)
    local dt = nil
    exports.framework:TriggerServerCallback("GetPlayerData", function(data)
        dt = data
    end, pid)
    while not dt do
        Wait(10)
    end
    return dt
end

exports('TriggerServerCallback', TriggerServerCallback)
exports('GetPlayerData', get_player_data)