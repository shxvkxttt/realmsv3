RegisterServerEvent("identity:sv:check_license")
RegisterServerEvent("identity:sv:register")
RegisterServerEvent("identity:sv:save_appearance")

local function check_license()
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", { ['identifier'] = identifier } )

    if not result[1] then
        DropPlayer(player, "An error has occured")
    elseif result[1].wipe then
        TriggerClientEvent("identity:cl:register", player)
    elseif not result[1].registered then
        TriggerClientEvent("identity:cl:register", player)
    else
        exports.ox_inventory:setPlayerInventory(exports.framework:GetPlayerData(player))
        SetPlayerRoutingBucket(player, 0)
        TriggerClientEvent("identity:cl:login", player, result[1])
    end
end

local function register(data)
    local player = source
    local player_data = exports.framework:GetPlayerData(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    local registered = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", { ['identifier'] = identifier })

    SetPlayerRoutingBucket(player, player)

    if not registered[1] then
        local executed = MySQL.Sync.execute('INSERT INTO users (identifier, prename, name, dob, height, wipe, registered) VALUES (@identifier, @prename, @name, @dob, @height, 0, 1)',
            {['identifier'] = identifier, ['prename'] = data.prename, ['name'] = data.name, ['dob'] = data.dob, ['height'] = data.height}
        )

        if executed then
            TriggerClientEvent("identity:cl:finish_register", player)
            exports.ox_inventory:setPlayerInventory(exports.framework:GetPlayerData(player))
        end
    elseif registered[1].wipe then
        local executed = MySQL.Sync.execute('UPDATE users SET prename = @prename, name = @name, dob = @dob, height = @height, cash = 0, bank = 0, admrk = DEFAULT, wipe = 0, registered = 1  WHERE id = @uid', {
            ['uid'] = player_data.id,
            ['prename'] = data.prename,
            ['name'] = data.name,
            ['dob'] = data.dob,
            ['height'] = data.height}
        )

        if executed then
            TriggerClientEvent("identity:cl:finish_register", player)
            exports.ox_inventory:setPlayerInventory(exports.framework:GetPlayerData(player))
        end
    elseif not registered[1].registered then
        local executed = MySQL.Sync.execute('UPDATE users SET prename = @prename, name = @name, dob = @dob, height = @height, cash = 0, bank = 0, admrk = DEFAULT, wipe = 0, registered = 1  WHERE id = @uid', {
            ['uid'] = player_data.id,
            ['prename'] = data.prename,
            ['name'] = data.name,
            ['dob'] = data.dob,
            ['height'] = data.height}
        )

        if executed then
            TriggerClientEvent("identity:cl:finish_register", player)
            exports.ox_inventory:setPlayerInventory(exports.framework:GetPlayerData(player))
        end
    end
end

local function save_appearance(appearance)
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    MySQL.Async.execute('UPDATE users SET appearance = @appearance WHERE identifier = @identifier', {['appearance'] = json.encode(appearance), ['identifier'] = identifier})
end

AddEventHandler("identity:sv:register", register)
AddEventHandler("identity:sv:check_license", check_license)
AddEventHandler("identity:sv:save_appearance", save_appearance)