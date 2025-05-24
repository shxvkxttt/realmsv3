RegisterNetEvent("admin:sv:update_players")

local function update_players()
    local players = {}
    local g_player = source
    for k, v in pairs(GetPlayers()) do
        local sql_data = exports.framework:GetPlayerData(v)
        if sql_data then
            players[v] = {
                uid = sql_data.id,
                username = GetPlayerName(v),
                prename = sql_data.prename,
                name = sql_data.prename,
                crew = sql_data.crew,
            }
        end
    end
    TriggerClientEvent("admin:cl:update_players", g_player, players)
end

AddEventHandler("admin:sv:update_players", update_players)