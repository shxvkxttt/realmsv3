RegisterNetEvent('framework:sv:commands:bring')
RegisterNetEvent('framework:sv:commands:bringback')
RegisterNetEvent('framework:sv:commands:kick')
RegisterNetEvent('framework:sv:commands:ban')

local players = {}

local function bring(id)
    local s_pid = GetPlayerPed(source)
    local s_coords = GetEntityCoords(s_pid)
    local pid = GetPlayerPed(id)
    local coords = GetEntityCoords(pid)

    players[id] = {
        coords = coords
    }
    
    SetEntityCoords(pid, coords.x, coords.y, coords.z)
end

local function bringback(id)
    if players[id] then
        local pid = GetPlayerPed(id)
        local coords = players[id].coords
    
        players[id] = {
            coords = coords
        }
        
        SetEntityCoords(pid, coords.x, coords.y, coords.z)
    end

    players[id] = nil
end

local function kick(id, reason)
    DropPlayer(id, "You have been kicked for: " .. reason)
end

local function ban(id, datetype, duration, reason)
    reason = reason
    local author = GetPlayerName(source)
    local license = GetPlayerIdentifierByType(id, 'license')
    local license2 = GetPlayerIdentifierByType(id, 'license2')
    local steam = GetPlayerIdentifierByType(id, 'steam')
    local discord = GetPlayerIdentifierByType(id, 'discord')
    local xbl = GetPlayerIdentifierByType(id, 'xbl')
    local live = GetPlayerIdentifierByType(id, 'live')
    local fivem = GetPlayerIdentifierByType(id, 'fivem')
    local ip = GetPlayerIdentifierByType(id, 'ip')

    local formatted = nil

    if datetype == "h" then
        local dt = os.date("*t")
        dt.hour = dt.hour + duration
        local newtime = os.time(dt)
        formatted = os.date("%Y-%m-%d %H:%M:%S", newtime)
    elseif datetype == "d" then
        local dt = os.date("*t")
        dt.day = dt.day + duration
        local newtime = os.time(dt)
        formatted = os.date("%Y-%m-%d %H:%M:%S", newtime)
    end

    if not formatted then
        return
    end

    while not MySQL do
        Wait(100)
    end

    MySQL.Async.execute('INSERT INTO bans (license, license2, steam, discord, xbl, live, fivem, ip, reason, author, duration) VALUES (@license, @license2, @steam, @discord, @xbl, @live, @fivem, @ip, @reason, @author, @duration)',
            {['license'] = license, ['license2'] = license2, ['steam'] = steam, ['discord'] = discord, ['xbl'] = xbl, ['live'] = live, ['fivem'] =  fivem, ['ip'] = ip, ['reason'] = reason, ['author'] = author, ['duration'] = formatted}
        )

    --DropPlayer(id, "You have been banned for: " .. reason)
end

AddEventHandler('framework:sv:commands:bring', bring)
AddEventHandler('framework:sv:commands:bringback', bringback)
AddEventHandler('framework:sv:commands:kick', kick)
AddEventHandler('framework:sv:commands:ban', ban)