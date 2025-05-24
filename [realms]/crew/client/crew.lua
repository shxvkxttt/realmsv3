-- Menu principal
RegisterCommand("crew", function()
    local data = lib.callback.await("crew:getData", false)
    if not data or not data.label then
        return lib.notify({ title = "Crew", description = "Tu n'es dans aucun crew.", type = "error" })
    end

        local options = {}
    if data.isLeader then
        options[#options+1] = { label = "Gérer les rôles", icon = "sliders", iconColor = "#e74c3c", args = { action = "roles", label = data.label } }
    end
    if data.permissions.canInvite or data.isLeader then
        options[#options+1] = { label = "Recruter un joueur", icon = "user-plus", iconColor = "#c0392b", args = { action = "recruit", label = data.label } }
    end
    if data.permissions.canKick or data.permissions.canEditRoles then
        options[#options+1] = { label = "Voir les membres", icon = "users", iconColor = "#bd2c2c", args = { action = "members", label = data.label, rank_id = data.rank_id, isLeader = data.isLeader } }
    end
    options[#options+1] = { label = "Quitter le crew", icon = "door-open", iconColor = "#ff3f3f", args = { action = "leave" } }

    lib.registerMenu({
        id = 'crew_main_menu',
        title = 'Mon crew : ' .. data.label,
        position = 'top-right',
        options = options
    }, function(_, _, args)
        if not args or type(args) ~= "table" then return end
        if args.action == "roles" then
            TriggerEvent("crew:openRoleManager", args.label)
        elseif args.action == "recruit" then
            TriggerEvent("crew:recruitPlayer", args.label)
        elseif args.action == "members" then
            TriggerEvent("crew:viewMembers", args.label, args.rank_id, args.isLeader)
        elseif args.action == "leave" then
            TriggerServerEvent("crew:leave")
        end
    end)

    lib.showMenu("crew_main_menu")
end)

RegisterKeyMapping('crew', 'Ouvrir menu Crew', 'keyboard', 'F7')


RegisterNetEvent("crew:viewMembers", function(crewLabel, myRankId, isLeader)
    local members = lib.callback.await("crew:getMembers", false, crewLabel)
    if not members then return end

    local options = {}
    for _, member in pairs(members) do
        local isSelf = member.isYou and " (Toi)" or ""
        options[#options+1] = {
            iconColor = "#ff3f3f",
            label = member.name .. isSelf,
            description = "Rang : " .. (member.rank_name or "Inconnu"),
            icon = member.isYou and "user-check" or "user",
            disabled = member.isYou,
            args = { action = "manageMember", crewLabel = crewLabel, member = member }
        }
    end

    lib.registerMenu({
        id = 'crew_members_menu',
        title = 'Membres du crew',
        menu = 'crew_main_menu',
        position = 'top-right',
        options = options,
        onClose = function()
            lib.showMenu('crew_main_menu') -- revient au parent
        end
    }, function(_, _, args)
        if args.action == "manageMember" then
            TriggerEvent("crew:manageMember", args.crewLabel, args.member)
        end
    end)

    lib.showMenu("crew_members_menu")
end)

RegisterNetEvent("crew:manageMember", function(crewLabel, member)
    local myData = lib.callback.await("crew:getData", false)
    if not myData then return end

    local options = {}
    if myData.permissions.canEditRoles or myData.isLeader then
        options[#options+1] = {
            iconColor = "#2949d8",
            label = "Changer le rôle",
            icon = "chevron-right",
            args = { action = "changeRank", crewLabel = crewLabel, member = member }
        }
    end
    if myData.permissions.canKick or myData.isLeader then
        options[#options+1] = {
            iconColor = "#ff3f3f",
            label = "Expulser",
            icon = "user-xmark",
            args = { action = "kick", member = member }
        }
    end

    lib.registerMenu({
        id = 'crew_manage_member_' .. member.identifier,
        title = 'Gérer : ' .. member.name,
        menu = 'crew_members_menu',
        position = 'top-right',
        options = options,
        onClose = function()
            TriggerEvent('crew:viewMembers', crewLabel, myData.rank_id, myData.isLeader) -- revient au parent
        end
    }, function(_, _, args)
        if args.action == "changeRank" then
            TriggerEvent("crew:changeMemberRank", args.crewLabel, args.member)
        elseif args.action == "kick" then
            TriggerServerEvent("crew:kickMember", args.member.identifier)
        end
    end)

    lib.showMenu('crew_manage_member_' .. member.identifier)
end)

RegisterNetEvent("crew:refreshMembers", function(crewLabel, rank_id, isLeader)
    TriggerEvent("crew:viewMembers", crewLabel, rank_id, isLeader)
end)


RegisterNetEvent("crew:changeMemberRank", function(crewLabel, member)
    local ranks = lib.callback.await("crew:getRanks", false, crewLabel)
    if not ranks or #ranks == 0 then return end

    local options = {}
    for _, r in pairs(ranks) do
        options[#options+1] = {
            iconColor = "#ff3f3f",
            label = r.name .. " (ID: " .. r.rank_id .. ")",
            args = { rank_id = r.rank_id, member = member }
        }
    end

    lib.registerMenu({
        id = 'crew_select_rank_' .. member.identifier,
        title = 'Sélectionner un rôle',
        menu = 'crew_manage_member_' .. member.identifier,
        position = 'top-right',
        options = options,
        onClose = function()
            TriggerEvent('crew:manageMember', crewLabel, member) -- revient au parent
        end
    }, function(_, _, args)
        TriggerServerEvent("crew:setMemberRank", args.member.identifier, args.rank_id)
        TriggerEvent("crew:manageMember", crewLabel, args.member)
    end)

    lib.showMenu('crew_select_rank_' .. member.identifier)
end)

RegisterNetEvent("crew:createRole", function(crewLabel)
    local input = lib.inputDialog("Créer un rôle", {
        { type = "input", label = "Nom du rôle", placeholder = "ex: Recruteur", required = true },
        { type = "number", label = "ID (1 à 100)", default = 2, required = true },
        { type = "checkbox", label = "Peut recruter", default = false },
        { type = "checkbox", label = "Peut kicker", default = false },
        { type = "checkbox", label = "Peut modifier les rôles", default = false }
    })
    if not input then return lib.showMenu('crew_role_manager') end -- retour si annulé

    local rankData = {
        name = input[1],
        rank_id = tonumber(input[2]),
        permissions = {
            canInvite = input[3],
            canKick = input[4],
            canEditRoles = input[5]
        }
    }

    TriggerServerEvent("crew:createRank", crewLabel, rankData)

    -- retour au menu des rôles
    Wait(150)
    TriggerEvent("crew:openRoleManager", crewLabel)
end)

RegisterNetEvent("crew:editRole", function(crewLabel, rank_id)
    local rank = lib.callback.await("crew:getRankData", false, crewLabel, rank_id)
    if not rank then
        lib.notify({ title = "Erreur", description = "Rôle introuvable.", type = "error" })
        return TriggerEvent("crew:openRoleManager", crewLabel)
    end

    lib.registerMenu({
        id = 'crew_edit_role_menu_' .. rank_id,
        title = "Rôle : " .. rank.name,
        menu = 'crew_role_manager',
        position = 'top-right',
        options = {
            {
                label = "✏️ Modifier les permissions",
                icon = "pen",
                iconColor = "#3498db",
                args = { action = "edit", rank = rank }
            },
            {
                label = "🗑 Supprimer le rôle",
                icon = "trash",
                iconColor = "#e74c3c",
                args = { action = "delete", rank = rank }
            }
        },
        onClose = function()
            TriggerEvent("crew:openRoleManager", crewLabel)
        end
    }, function(_, _, args)
        if not args or not args.rank then return end

        if args.action == "edit" then
            local decoded = json.decode(args.rank.permissions or "{}")

            local input = lib.inputDialog("Modifier les permissions", {
                { type = "input", label = "Nom du rôle", default = args.rank.name, required = true },
                { type = "checkbox", label = "Peut recruter", default = decoded.canInvite or false },
                { type = "checkbox", label = "Peut kicker", default = decoded.canKick or false },
                { type = "checkbox", label = "Peut modifier les rôles", default = decoded.canEditRoles or false }
            })

            local update = {
                name = input[1],
                permissions = {
                    canInvite = input[2],
                    canKick = input[3],
                    canEditRoles = input[4]
                }
            }

            TriggerServerEvent("crew:updateRank", crewLabel, args.rank.rank_id, update)
            Wait(150)
            TriggerEvent("crew:openRoleManager", crewLabel)

        elseif args.action == "delete" then
            local confirm = lib.alertDialog({
                header = "Supprimer le rôle",
                content = "Tu veux vraiment supprimer ce rôle ?",
                centered = true,
                cancel = true
            })

            if confirm == "confirm" then
                TriggerServerEvent("crew:deleteRank", crewLabel, args.rank.rank_id)
            end

            Wait(150)
            TriggerEvent("crew:openRoleManager", crewLabel)
        end
    end)

    lib.showMenu('crew_edit_role_menu_' .. rank_id)
end)



RegisterNetEvent("crew:openRoleManager", function(crewLabel)
    local ranks = lib.callback.await("crew:getRanks", false, crewLabel)
    if not ranks or #ranks == 0 then
        return lib.notify({ title = "Crew", description = "Aucun rôle trouvé.", type = "error" })
    end

    local options = {}
    for _, rank in pairs(ranks) do
        options[#options+1] = {
            label = rank.name .. " (ID: " .. rank.rank_id .. ")",
            description = "Modifier les permissions",
            icon = "pen",
            iconColor = "#ff3f3f",
            args = { action = "editRole", crewLabel = crewLabel, rank_id = rank.rank_id }
        }
    end
    options[#options+1] = {
        label = "Créer un nouveau rôle",
        icon = "plus",
        iconColor = "#ff3f3f",
        args = { action = "createRole", crewLabel = crewLabel }
    }

    lib.registerMenu({
        id = 'crew_role_manager',
        title = 'Gérer les rôles',
        menu = 'crew_main_menu',
        position = 'top-right',
        options = options,
        onClose = function()
        lib.showMenu('crew_main_menu') -- revient au parent
        end
    }, function(_, _, args)
        if args.action == "editRole" then
            if args.rank_id == 3 then
                lib.notify({
                    title = "Crew",
                    description = "Vous ne pouvez pas modifier ce rôle.",
                    type = "error"
                })
                return TriggerEvent('crew:openRoleManager', args.crewLabel)
            end
            TriggerEvent("crew:editRole", args.crewLabel, args.rank_id)
        elseif args.action == "createRole" then
            TriggerEvent("crew:createRole", args.crewLabel)
        end
    end)

    lib.showMenu("crew_role_manager")
end)


