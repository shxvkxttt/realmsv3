-- 📦 Fonction utilitaire propre
local function getPlayerCrewData(src)
    local player = exports["framework"]:GetPlayerData(src)
    if not player then 
        print('aucun joueur trouver')
        return nil 
    end

    local identifier = player.identifier
    print('identifier :', identifier)
    if not identifier then return nil end

    local user = MySQL.single.await('SELECT crew, crew_rank FROM users WHERE identifier = ?', {
        identifier
    })
    print('user :', json.encode(user))

    if not user or not user.crew then
        return nil
    end

    local rank = MySQL.single.await('SELECT * FROM crew_rank WHERE crew_label = ? AND rank_id = ?', {
        user.crew, user.crew_rank
    })

    print('rank :', json.encode(rank))

    local perms = {}
    if rank and rank.permissions then
        local ok, decoded = pcall(json.decode, rank.permissions)
        if ok and decoded then
            perms = decoded
        end
    end
    print('perms :', json.encode(perms))

    return {
        label = user.crew,
        rank_id = user.crew_rank,
        isLeader = (user.crew_rank == 1),
        permissions = perms
    }
end

RegisterServerEvent("crew:createRank", function(crewLabel, rankData)
    local src = source
    local player = exports["framework"]:GetPlayerData(src)
    if not player then return end

    local identifier = player.identifier

    -- Check si le rank_id existe déjà
    local existing = MySQL.single.await('SELECT 1 FROM crew_rank WHERE crew_label = ? AND rank_id = ?', {
        crewLabel, rankData.rank_id
    })

    if existing then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Erreur",
            description = "Un rôle avec cet ID existe déjà.",
            type = "error"
        })
        return
    end

    MySQL.insert.await('INSERT INTO crew_rank (crew_label, rank_id, name, permissions) VALUES (?, ?, ?, ?)', {
        crewLabel,
        rankData.rank_id,
        rankData.name,
        json.encode(rankData.permissions)
    })

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Rôle créé",
        description = "Le rôle a été ajouté.",
        type = "success"
    })
end)

RegisterServerEvent("crew:updateRank", function(crewLabel, rank_id, updateData)
    local src = source
    local player = exports["framework"]:GetPlayerData(src)
    if not player then return end

    MySQL.update.await('UPDATE crew_rank SET name = ?, permissions = ? WHERE crew_label = ? AND rank_id = ?', {
        updateData.name,
        json.encode(updateData.permissions),
        crewLabel,
        rank_id
    })

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Rôle modifié",
        description = "Le rôle a bien été mis à jour.",
        type = "success"
    })
end)

lib.callback.register("crew:getMembers", function(src, crewLabel)
    local players = MySQL.query.await([[
        SELECT u.id, u.identifier, u.crew_rank, u.crew, u.prename, u.name, cr.name as rank_name
        FROM users u
        LEFT JOIN crew_rank cr ON cr.crew_label = u.crew AND cr.rank_id = u.crew_rank
        WHERE u.crew = ?
    ]], { crewLabel })

    local requester = exports["framework"]:GetPlayerData(src)
    local requesterId = requester and requester.identifier

    local members = {}

    for _, player in ipairs(players) do
        members[#members+1] = {
            identifier = player.identifier,
            name = ((player.name or "") .. " " .. (player.prename or player.identifier:sub(1, 8)) .. " | ID : " .. (player.id or "")),
            rank_id = player.crew_rank,
            rank_name = player.rank_name,
            isYou = (player.identifier == requesterId)
        }
    end

    return members
end)

RegisterServerEvent("crew:setMemberRank", function(targetIdentifier, newRankId)
    local src = source
    local player = exports["framework"]:GetPlayerData(src)
    if not player then return end

    -- sécurité : vérif que le joueur qui demande peut modifier les rangs
    local data = getPlayerCrewData(src)
    if not data or (not data.isLeader and not data.permissions.canEditRoles) then
        print("[CREW] Refus de changement de rôle - non autorisé")
        return
    end

    -- appliquer le nouveau rang
    MySQL.update.await('UPDATE users SET crew_rank = ? WHERE identifier = ?', {
        newRankId, targetIdentifier
    })

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Rang modifié",
        description = "Le joueur a changé de rôle.",
        type = "success"
    })
end)

RegisterServerEvent("crew:kickMember", function(targetIdentifier)
    local src = source
    local player = exports["framework"]:GetPlayerData(src)
    if not player then return end

    local data = getPlayerCrewData(src)
    if not data or (not data.isLeader and not data.permissions.canKick) then
        print("[CREW] Tentative de kick non autorisée")
        return
    end

    MySQL.update.await('UPDATE users SET crew = NULL, crew_rank = NULL WHERE identifier = ?', {
        targetIdentifier
    })

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Membre expulsé",
        description = "Le joueur a été retiré du crew.",
        type = "success"
    })
    TriggerClientEvent("crew:refreshMembers", src, data.label, data.rank_id, data.isLeader)
end)

RegisterServerEvent("crew:leave", function()
    local src = source
    local player = exports["framework"]:GetPlayerData(src)
    if not player then return end

    MySQL.update.await('UPDATE users SET crew = NULL, crew_rank = NULL WHERE identifier = ?', {
        player.identifier
    })

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Crew",
        description = "Tu as quitté ton crew.",
        type = "info"
    })
end)

RegisterServerEvent("crew:deleteRank", function(crewLabel, rank_id)
    local src = source
    local player = exports["framework"]:GetPlayerData(src)
    if not player then return end

    -- sécurité : s'assurer que c’est bien un leader
    local data = getPlayerCrewData(src)
    if not data or not data.isLeader then
        print("[CREW] Suppression de rôle refusée : non leader")
        return
    end

    -- Ne pas supprimer le rang leader (rank_id == 1)
    if rank_id == 1 then
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Erreur",
            description = "Tu ne peux pas supprimer le rôle de leader.",
            type = "error"
        })
        return
    end

    -- Supprimer tous les utilisateurs associés à ce rang
    MySQL.update.await('UPDATE users SET crew_rank = 3 WHERE crew_label = ? AND crew_rank = ?', {
        crewLabel, rank_id
    })

    -- Supprimer le rang de la table crew_rank
    MySQL.update.await('DELETE FROM crew_rank WHERE crew_label = ? AND rank_id = ?', {
        crewLabel, rank_id
    })

    TriggerClientEvent("ox_lib:notify", src, {
        title = "Rôle supprimé",
        description = "Le rôle a bien été supprimé.",
        type = "success"
    })
end)





lib.callback.register("crew:getData", function(source)
    return getPlayerCrewData(source)
end)

lib.callback.register("crew:getRanks", function(src, crewLabel)
    local ranks = MySQL.query.await('SELECT * FROM crew_rank WHERE crew_label = ? ORDER BY rank_id ASC', { crewLabel })
    return ranks
end)

lib.callback.register("crew:getRankData", function(src, crewLabel, rank_id)
    local rank = MySQL.single.await('SELECT * FROM crew_rank WHERE crew_label = ? AND rank_id = ?', { crewLabel, rank_id })
    return rank
end)