RegisterServerEvent("crew:create", function(label, name, crewType)
    local src = source
    local player = exports["framework"]:GetPlayerData(src) -- adapte le nom de ta ressource

    if not player then
        print("[CREW] Erreur : joueur introuvable.")
        return
    end

    local identifier = player.identifier or player.license or player.uid
    if not identifier then
        print("[CREW] Erreur : aucun identifiant dans player data.")
        return
    end

    if not label or not name or not crewType then
        print("[CREW] Données invalides reçues.")
        return
    end

    -- Vérifie si le label existe déjà
    local existing = MySQL.query.await('SELECT 1 FROM crew WHERE label = ?', { label })
    if existing and #existing > 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Création du crew',
            description = 'Ce label est déjà utilisé.',
            type = 'error'
        })
        return
    end

    -- Insère le nouveau crew
    local inserted = MySQL.insert.await('INSERT INTO crew (label, name, leader_identifier, type) VALUES (?, ?, ?, ?)', {
        label, name, identifier, crewType
    })

    if inserted then
        -- Met à jour les champs dans ta table utilisateurs
        MySQL.update.await('UPDATE users SET crew = ?, crew_rank = ? WHERE identifier = ?', {
            label, 1, identifier
        })

        MySQL.insert.await('INSERT INTO crew_rank (crew_label, rank_id, name, permissions) VALUES (?, ?, ?, ?)', {
            label, 1, "Leader", json.encode({
                canInvite = true,
                canKick = true,
                canEditRoles = true
            })
        })

        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Crew créé',
            description = 'Tu es maintenant leader du crew : ' .. name,
            type = 'success'
        })

        print(("[CREW] %s a créé le crew '%s' (label: %s)"):format(identifier, name, label))
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Erreur',
            description = 'Impossible de créer le crew.',
            type = 'error'
        })
    end
end)
