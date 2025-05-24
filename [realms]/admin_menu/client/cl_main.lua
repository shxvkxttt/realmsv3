RegisterNetEvent("admin:cl:update_players")

local cam = nil
local players = {}
local gamerTags = {}

g_gamertags = false
g_invincible = false
g_noclip = false
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Admin")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled (false);
_menuPool:MouseEdgeEnabled (false);
_menuPool:ControlDisablingEnabled(false);


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function adminmenu(menu)
    local pped = PlayerPedId()

    local gamertags = NativeUI.CreateCheckboxItem("Gamertags", g_gamertags)
    local reload_gamertags = NativeUI.CreateItem("Reload Gamertags")
    local invincible = NativeUI.CreateCheckboxItem("Invincible", g_invincible)
    local noclip = NativeUI.CreateCheckboxItem("NoCip", g_noclip)
    menu:AddItem(gamertags)
    menu:AddItem(reload_gamertags)
    menu:AddItem(invincible)
    menu:AddItem(noclip)
    menu.OnItemSelect = function(sender, item, index)
        if item == reload_gamertags then
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end
    end
    menu.OnCheckboxChange = function(sender, item, checked_)
        if item == gamertags then
            g_gamertags = checked_
        end

        if item == invincible then
            g_invincible = checked_
            SetEntityInvincible(pped, g_invincible)
        end
        
        if item == noclip then
            g_noclip = checked_
            SetEntityVisible(pped, not g_noclip)
            FreezeEntityPosition(pped, g_noclip)
    
            if not g_noclip then
                RenderScriptCams(false, false, 0, true, false)
                DestroyCam(cam, false)
                cam = nil
            else
                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            end
        end
    end
end

function RotationToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

Citizen.CreateThread(function()
    adminmenu(mainMenu)
    _menuPool:RefreshIndex()

    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 57) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

Citizen.CreateThread(function () 
    local speed = 1.0
    while true do
        Citizen.Wait(1)
        local player = PlayerPedId()
        if g_gamertags then
            for _, p in ipairs(GetActivePlayers()) do
                local CurrentPlayer = PlayerId()
                local player = GetPlayerServerId(p)
                local player_data = players[tostring(player)]
                local ped = GetPlayerPed(p)
                local CurrentVehicle = GetVehiclePedIsIn(ped)
    
                if player_data then
                    if not IsMpGamerTagActive(gamerTags[p]) then
                        --RemoveMpGamerTag(gamerTags[p])
                        if player_data.crew then
                            gamerTag = CreateFakeMpGamerTag(ped, "UID: [" .. player_data.uid .. "]" .. " ID: [" .. player .. "] " .. player_data.username .. " | " .. player_data.prename .. " " .. player_data.name, false, false, string.sub(player_data.crew, 1, 5), 0)
                        else
                            gamerTag = CreateFakeMpGamerTag(ped, "UID: [" .. player_data.uid .. "]" .. " ID: [" .. player .. "] " .. player_data.username .. " | " .. player_data.prename .. " " .. player_data.name, false, false, "", 0)
                        end
                    end
    
    
                    if player_data.crew then
                        SetMpGamerTagVisibility(gamerTags[p], 1, true)
                    end
                    SetMpGamerTagVisibility(gamerTags[p], 2, true)
                    SetMpGamerTagVisibility(gamerTags[p], 4, NetworkIsPlayerTalking(p))
    
                    if IsPedSittingInVehicle(ped, CurrentVehicle) and GetPedInVehicleSeat(CurrentVehicle, -1) == ped then
                        SetMpGamerTagVisibility(gamerTags[p], 8, true)
                        SetMpGamerTagVisibility(gamerTags[p], 9, false)
                    elseif IsPedSittingInVehicle(ped, CurrentVehicle) and GetPedInVehicleSeat(CurrentVehicle, 0) == ped then
                        SetMpGamerTagVisibility(gamerTags[p], 8, false)
                        SetMpGamerTagVisibility(gamerTags[p], 9, true)
                    else
                        SetMpGamerTagVisibility(gamerTags[p], 8, false)
                        SetMpGamerTagVisibility(gamerTags[p], 9, false)
                    end
    
                    SetMpGamerTagAlpha(gamerTags[p], 2, 255)
                    SetMpGamerTagHealthBarColor(gamerTags[p], 0)
    
                    SetMpGamerTagColour(gamerTags[p], 0, 0)
                    SetMpGamerTagColour(gamerTags[p], 4, 0)
                    SetMpGamerTagAlpha(gamerTags[p], 4, 255)
                    SetMpGamerTagsUseVehicleBehavior(true)
    
                    gamerTags[p] = gamerTag
                else
                    if not IsMpGamerTagActive(gamerTags[p]) then
                        --RemoveMpGamerTag(gamerTags[p])
                        gamerTag = CreateFakeMpGamerTag(ped, "UID: [" .. player_data.uid .. "]" .. " ID: [" .. player .. "] " .. player_data.username, false, false, "", 0)
                    end
    
                    SetMpGamerTagVisibility(gamerTags[p], 2, true)
                    SetMpGamerTagVisibility(gamerTags[p], 4, NetworkIsPlayerTalking(p))
    
                    if IsPedSittingInVehicle(ped, CurrentVehicle) and GetPedInVehicleSeat(CurrentVehicle, -1) == ped then
                        SetMpGamerTagVisibility(gamerTags[p], 8, true)
                        SetMpGamerTagVisibility(gamerTags[p], 9, false)
                    elseif IsPedSittingInVehicle(ped, CurrentVehicle) and GetPedInVehicleSeat(CurrentVehicle, 0) == ped then
                        SetMpGamerTagVisibility(gamerTags[p], 8, false)
                        SetMpGamerTagVisibility(gamerTags[p], 9, true)
                    else
                        SetMpGamerTagVisibility(gamerTags[p], 8, false)
                        SetMpGamerTagVisibility(gamerTags[p], 9, false)
                    end
    
                    SetMpGamerTagAlpha(gamerTags[p], 2, 255)
                    SetMpGamerTagHealthBarColor(gamerTags[p], 0)
    
                    SetMpGamerTagColour(gamerTags[p], 0, 0)
                    SetMpGamerTagColour(gamerTags[p], 4, 0)
                    SetMpGamerTagAlpha(gamerTags[p], 4, 255)
                    SetMpGamerTagsUseVehicleBehavior(true)
    
                    gamerTags[p] = gamerTag
                end
            end
        else
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end

        if g_noclip then
            local camRot = GetGameplayCamRot(2)
            local camForward = RotationToDirection(camRot)
            local coords = GetEntityCoords(player)
            local newX = coords.x
            local newY = coords.y
            local newZ = coords.z

            SetCamCoord(cam, coords.x, coords.y, coords.z)
            SetCamActive(cam, true)
            SetCamRot(cam, camRot.x, camRot.y, camRot.z, 2)
            RenderScriptCams(true, false, 0, true, true)

            ClearPedTasksImmediately(player)
            SetEntityRotation(player, camRot.x, camRot.y, camRot.z, 2)

            if IsControlPressed(0, 32) then -- W
                newX = newX + camForward.x * speed
                newY = newY + camForward.y * speed
                newZ = newZ + camForward.z * speed
            end

            if IsControlPressed(0, 33) then -- S
                newX = newX - camForward.x * speed
                newY = newY - camForward.y * speed
                newZ = newZ - camForward.z * speed
            end

            local camRight = vector3(-camForward.y, camForward.x, 0.0)
            if IsControlPressed(0, 34) then -- A
                newX = newX + camRight.x * speed
                newY = newY + camRight.y * speed
            end

            if IsControlPressed(0, 35) then -- D
                newX = newX - camRight.x * speed
                newY = newY - camRight.y * speed
            end

            SetEntityCoordsNoOffset(player, newX, newY, newZ, true, true, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("admin:sv:update_players")
        Citizen.Wait(10000)
    end
end)

local function update_players(data)
    players = data
end

AddEventHandler("admin:cl:update_players", update_players)