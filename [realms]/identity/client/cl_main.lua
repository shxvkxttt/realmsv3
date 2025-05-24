RegisterNetEvent("identity:cl:login")
RegisterNetEvent("identity:cl:register")
RegisterNetEvent("identity:cl:finish_register")

local function onClientResourceStart(name)
    if name == GetCurrentResourceName() then
        exports.spawnmanager:spawnPlayer({
            x = Config.register.coords.x,
            y = Config.register.coords.y,
            z = Config.register.coords.z - 1,
            heading = Config.register.coords.w,
            model = 'a_m_m_farmer_01',
            skipFade = false
        })
        exports.spawnmanager:setAutoSpawn(false)
    end
end

local function playerSpawned()
    TriggerServerEvent("identity:sv:check_license")
end

local function login(data)
    local pped = PlayerPedId()
    local coords = json.decode(data.coords)

    --exports['fivem-appearance']:setPlayerAppearance(json.decode(data.appearance))
    SetEntityCoords(pped, coords.x, coords.y, coords.z)
    SetEntityHealth(pped, data.health)
end

local function register()
    local pped = PlayerPedId()
    FreezeEntityPosition(pped, true)

    SetNuiFocus(true, true)
    SendNUIMessage({
         type = "show"
    })
end

local function finish_register()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "hide"
    })

    -- local config = {
    --     ped = true,
    --     headBlend = true,
    --     faceFeatures = true,
    --     headOverlays = true,
    --     components = true,
    --     props = true,
    --     tattoos = true
    -- }
    
    -- exports['fivem-appearance']:startPlayerCustomization(function (appearance)
    --     local gender

    --     if (appearance.model == "mp_f_freemode_01") then
    --         gender = "female"
    --     else if (appearance.model == "mp_m_freemode_01") then
    --         gender = "male"
    --     end

    --     if (appearance) then
    --         if (appearance.model == "mp_f_freemode_01" or appearance.model == "mp_m_freemode_01") then
    --             TriggerServerEvent("identity:sv:save_appearance", appearance, gender)
    --         end    
    --     end
    -- end, config)
end

RegisterCommand("test", function()
end)

RegisterCommand("skin", function()
    exports['fivem-appearance']:startPlayerCustomization()
end)

RegisterNUICallback('register', function(data, cb)
    TriggerServerEvent("identity:sv:register", data)
end)

AddEventHandler("identity:cl:login", login)
AddEventHandler("identity:cl:register", register)
AddEventHandler("identity:cl:finish_register", finish_register)
AddEventHandler("onClientResourceStart", onClientResourceStart)
AddEventHandler("playerSpawned", playerSpawned)