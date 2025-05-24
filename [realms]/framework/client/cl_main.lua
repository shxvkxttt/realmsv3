TriggerServerEvent('fmw:test')

local function onClientResourceStart(name)
    if name == GetCurrentResourceName() then
        if Config.disable_idle_camera then
            DisableIdleCamera(true)
        end
    end
end

AddEventHandler('onClientResourceStart', onClientResourceStart)