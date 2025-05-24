RegisterNetEvent("fmw:test")
RegisterNetEvent('framework:sv:exports:server_callbacks:trigger')
RegisterNetEvent('framework:sv:main:wipe')

local server_callbacks = {}

local function isBanned(id)
    local player = id
end


isBanned(30)

local function playerConnecting(name, setKickReason, deferrals)
    local player = source
    local license = GetPlayerIdentifierByType(player, 'license')
    local license2 = GetPlayerIdentifierByType(player, 'license2')
    local steam = GetPlayerIdentifierByType(player, 'steam')
    local discord = GetPlayerIdentifierByType(player, 'discord')
    local xbl = GetPlayerIdentifierByType(player, 'xbl')
    local live = GetPlayerIdentifierByType(player, 'live')
    local fivem = GetPlayerIdentifierByType(player, 'fivem')
    local ip = GetPlayerIdentifierByType(player, 'ip')
    local hwid = {}

    local playernumtokens = GetNumPlayerTokens(player)
    for i = 0, playernumtokens - 1 do
        hwid[i] = GetPlayerToken(player, i)
    end

    -- license = license or nil
    -- license2 = license2 or nil
    -- steam = steam or nil
    -- discord = discord or nil
    -- xbl = xbl or nil
    -- live = live or nil
    -- fivem = fivem or nil
    -- ip = ip or nil

    local connected_license = nil

    deferrals.defer()

    Wait(0)

    deferrals.update("License en cours de verification ...")

    local user = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        {['identifier'] = license}
    )

    if not user[1] then
        local affectedRows = MySQL.Sync.execute('INSERT INTO users (identifier, registered) VALUES (@identifier, 0)', {['identifier'] = license})

        local result = nil
        if affectedRows then
            result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['identifier'] = license})
        else
            deferrals.done("An error has occured")
        end

        local affectedRows2 = nil
        if result[1] then
            affectedRows2 = MySQL.Sync.execute('INSERT INTO usersinfo (id, license, license2, steam, discord, xbl, live, fivem, ip, hwid) VALUES (@id, @license, @license2, @steam, @discord, @xbl, @live, @fivem, @ip, @hwid)', {['id'] = result[1].id, ['license'] = license, ['license2'] = license2, ['steam'] = steam, ['discord'] = discord, ['xbl'] = xbl, ['live'] = live, ['fivem'] =  fivem, ['ip'] = ip, ['hwid'] = json.encode(hwid)})
        else
            deferrals.done("An error has occured")
        end

        -- MySQL.Async.execute('INSERT INTO users (identifier, registered) VALUES (@identifier, 0)',
        --     {['identifier'] = license},
        --     function(affectedRows)
        --         if affectedRows then
        --             MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
        --                 {['identifier'] = license},
        --                 function(result)
        --                     if result[1] then
        --                         MySQL.Async.execute('INSERT INTO usersinfo (id, license, license2, steam, discord, xbl, live, fivem, ip, hwid) VALUES (@id, @license, @license2, @steam, @discord, @xbl, @live, @fivem, @ip, @hwid)',
        --                             {['id'] = result[1].id, ['license'] = license, ['license2'] = license2, ['steam'] = steam, ['discord'] = discord, ['xbl'] = xbl, ['live'] = live, ['fivem'] =  fivem, ['ip'] = ip, ['hwid'] = json.encode(hwid)},
        --                             function(affectedRows2)
        --                                 if not affectedRows2 then
        --                                     deferrals.done("An error has occured")
        --                                 end
        --                             end
        --                         )
        --                     else
        --                         deferrals.done("An error has occured")
        --                     end
        --                 end
        --             )
        --         else
        --             deferrals.done("An error has occured")
        --         end
        --     end
        -- )
    -- else
    --     MySQL.Async.fetchAll('SELECT * FROM usersinfo WHERE license = @license',
    --         {['license'] = license},
    --     )
    end



    -- local create_user_baninfo = MySQL.Sync.execute('INSERT INTO users (identifier, license2, steam, discord, xbl, live, fivem, ip, reason, author, duration) VALUES (@identifier, @license2, @steam, @discord, @xbl, @live, @fivem, @ip)',
    --     {['identifier'] = license, ['license2'] = license2, ['steam'] = steam, ['discord'] = discord, ['xbl'] = xbl, ['live'] = live, ['fivem'] =  fivem, ['ip'] = ip, ['reason'] = reason, ['author'] = author, ['duration'] = formatted}
    -- )



    for k, v in pairs(GetPlayers()) do
        local player_license = GetPlayerIdentifierByType(v, 'license')

        if license == player_license then
            connected_license = player_license
            break
        end
    end

    if license == connected_license then
        deferrals.done("Votre license est déja connectée au serveur")
    elseif isBanned(player) then
        deferrals.done("Votre license est déja connectée au serveur")
    else
        deferrals.done()
    end
end

local function playerDropped()
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')
    local player_ped = GetPlayerPed(player)
    local entity_coords = GetEntityCoords(player_ped)
    local coords = {
        x = entity_coords.x,
        y = entity_coords.y,
        z = entity_coords.z,
    }

    while not MySQL do
        Wait(100)
    end
    
    MySQL.Async.execute('UPDATE users SET coords = @coords, health = @health WHERE identifier = @identifier', {['coords'] = json.encode(coords), ['health'] = GetEntityHealth(player_ped), ['identifier'] = identifier})
end

local function register_server_callback(name, fn)
    server_callbacks[name] = fn
end

register_server_callback("GetPlayerData", function(source, cb, pid)
    local player = pid
    local data = exports['framework']:GetPlayerData(player)
    cb(data)
end)

local function triggerservercallback(name, callbackid, ...)
    local src = source

    if server_callbacks[name] then
        server_callbacks[name](src, function(...)
            TriggerClientEvent('framework:cl:exports:server_callbacks:response', src, callbackid, ...)
        end, ...)
    else
        TriggerClientEvent('framework:cl:exports:server_callbacks:response', src,  callbackid, nil)   
    end
end

local function wipeplayer(uid)
    local player = uid
    while not MySQL do
        Wait(100)
    end

    MySQL.Async.execute('UPDATE users SET prename = ?, name = ?, dob = ?, height = ?, health = ?, coords = ?, appearance = ?, cash = 0, bank = 0, items = ?, admrk = DEFAULT, wipe = 1  WHERE id = @uid', {['uid'] = player})

    local id = exports.framework:GetPlayerIDFromUID(player)
    if id then
        DropPlayer(id, "Vous avez été wipe par un membre du staff")
    else
        print("player not online")    
    end
end

AddEventHandler("playerConnecting", playerConnecting)

AddEventHandler('playerDropped', playerDropped)
AddEventHandler('fmw:test', playerDropped)
AddEventHandler('framework:sv:exports:server_callbacks:trigger', triggerservercallback)
AddEventHandler('framework:sv:main:wipe', wipeplayer)