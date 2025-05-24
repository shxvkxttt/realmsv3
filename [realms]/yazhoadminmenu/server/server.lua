ESX = nil


local savedCoords   = {}

function csLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://cdn.discordapp.com/attachments/1307336179712131142/1313936742977507391/logo_sans_fond_blanc.png?ex=67529b33&is=675149b3&hm=ce0db172ad1b00cf75ca8d2839b6d90b27a9496ab9237c3493e2398a47d7a578&", username = "LOGS	", content = "```"..message.."```"}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('yazho:logsEvent')
AddEventHandler('yazho:logsEvent', function(message, url)
	csLogsDiscord(message,url)
end)

RegisterServerEvent('yazho:SendMessage')
AddEventHandler('yazho:SendMessage', function(id, sendmessagejoueur)
	ShowNotificationServer(id, "[ADMINISTRATION]\n"..sendmessagejoueur..".")
end)

RegisterServerEvent('Test:adminannonce')
AddEventHandler('Test:adminannonce', function(petiteannonce)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		ShowNotificationServer(xPlayers[i], "[ADMINISTRATION] "..petiteannonce..".")
	end
end)

RegisterNetEvent('yazho:annonce')
AddEventHandler('yazho:annonce', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
end)

RegisterNetEvent("yazho:kickall")
AddEventHandler("yazho:kickall", function(messagedekick)
	kickPl(messagedekick)
end)

function kickPl (messagedekick)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        xPlayer.kick(""..messagedekick.."")
    end
end

RegisterNetEvent("yazho:kick")
AddEventHandler("yazho:kick", function(id, mess, namekiker, nameplayer)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcid = GetPlayerIdentifier(id)
    local date = os.date(" %d/%m/20%y")

    MySQL.Async.execute('INSERT INTO yazho_kick (author, date, steam, name, reason) VALUES (@author, @date, @steam, @name, @reason)',
    { 
        ['author'] = namekiker,
        ['date'] = date,
        ['steam'] = srcid,
        ['name'] = nameplayer,
        ['reason'] = mess
    },

    function()
    end)

    DropPlayer(id, "\n\nVous avez été kick pour : \""..mess.."\", par "..GetPlayerName(source))
end)

RegisterNetEvent("yazho:warn")
AddEventHandler("yazho:warn", function(id, mess, namekiker, nameplayer)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcid = GetPlayerIdentifier(id)
    local date = os.date(" %d/%m/20%y")

    MySQL.Async.execute('INSERT INTO yazho_warn (author, date, steam, name, reason) VALUES (@author, @date, @steam, @name, @reason)',
    { 
        ['author'] = namekiker,
        ['date'] = date,
        ['steam'] = srcid,
        ['name'] = nameplayer,
        ['reason'] = mess
    },

    function()
    end)

	ShowNotificationServer(id, "Administration :\n"..mess..".")
end)

RegisterServerEvent('yazho:SavedPlayer')
AddEventHandler('yazho:SavedPlayer', function(id, message)
    ESX.SavePlayers()
end)

RegisterServerEvent('yazho:stopresource')
AddEventHandler('yazho:stopresource', function(resource_name)
    local _src = source
    StopResource(resource_name)
	ShowNotificationServer(_src, "La ressource "..resource_name.." à été stop.")
end)

RegisterServerEvent('yazho:startresource')
AddEventHandler('yazho:startresource', function(resource_name)
    local _src = source
    StartResource(resource_name)
	ShowNotificationServer(_src, "La ressource "..resource_name.." à été start.")
end)

RegisterServerEvent('yazho:restartresource')
AddEventHandler('yazho:restartresource', function(resource_name)
    local _src = source
    StopResource(resource_name)
    Wait(500)
    StartResource(resource_name)
	ShowNotificationServer(_src, "La ressource "..resource_name.." à été re-start.")
end)

RegisterNetEvent("yazho:createitemlimit")
AddEventHandler("yazho:createitemlimit", function(nameitem, labelitem, limititem)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("INSERT INTO items (`name`, `label`, `limit`) VALUES (@a, @b, @c)", {
        ["@a"] = nameitem,
        ["@b"] = labelitem,
        ["@c"] = limititem,
        }, function()
    end)

	ShowNotificationServer(source, "L'item "..labelitem.." a correctement été créer.")
end)

RegisterNetEvent("yazho:createitemweight")
AddEventHandler("yazho:createitemweight", function(nameitem, labelitem, poidsitem)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("INSERT INTO items (`name`, `label`, `weight`) VALUES (@a, @b, @c)", {
        ["@a"] = nameitem,
        ["@b"] = labelitem,
        ["@c"] = poidsitem,
        }, function()
    end)

	ShowNotificationServer(source, "L'item "..labelitem.." a correctement été créer.")
end)

RegisterNetEvent("yazho:GetItem")
AddEventHandler("yazho:GetItem", function()
    local _src = source
    local table = {}
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
        for k,v in pairs(result) do
            table[v.name] = v
        end
        TriggerClientEvent("yazho:GetItem", _src, table)
    end)
end)

RegisterNetEvent("yazho:GiveItem")
AddEventHandler("yazho:GiveItem", function(nameItem, quantity)
	local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(nameItem, quantity)
	ShowNotificationServer(source, "Vous venez de vous give x"..quantity.." "..nameItem..".")
end)

RegisterNetEvent("yazho:GiveItemJoueur")
AddEventHandler("yazho:GiveItemJoueur", function(IdSelected, nameItem, quantity)
	local xPlayer = ESX.GetPlayerFromId(IdSelected)

    xPlayer.addInventoryItem(nameItem, quantity)
	ShowNotificationServer(source, "Vous venez de vous give x"..quantity.." "..nameItem.." à l'(ID)"..IdSelected..".")
end)

RegisterNetEvent("yazho:ReportJoueur")
AddEventHandler("yazho:ReportJoueur", function(sujetreport, descreport, id, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcid = GetPlayerIdentifier(id)
    local date = os.date(" %d/%m/20%y")

    MySQL.Async.execute("INSERT INTO yazho_report (`type`, `author`, `idjoueur`, `date`, `steam`, `sujet`, `desc`, `status`, `staff`) VALUES (@type, @author, @idjoueur, @date, @steam, @sujet, @desc, @status, @staff)", {
        ["@type"] = "Report Joueur",
        ["@author"] = name,
        ["@idjoueur"] = id,
        ["@date"] = date,
        ["@steam"] = srcid,
        ["@sujet"] = sujetreport,
        ["@desc"] = descreport,
        ["@status"] = "Actif",
        ["@staff"] = "Aucun"
        }, function()
    end)

end)

RegisterNetEvent("yazho:ReportBug")
AddEventHandler("yazho:ReportBug", function(sujetreport, descreport, id, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcid = GetPlayerIdentifier(id)
    local date = os.date(" %d/%m/20%y")

    MySQL.Async.execute("INSERT INTO yazho_report (`type`, `author`, `idjoueur`, `date`, `steam`, `sujet`, `desc`, `status`, `staff`) VALUES (@type, @author, @idjoueur, @date, @steam, @sujet, @desc, @status, @staff)", {
        ["@type"] = "Report Bug",
        ["@author"] = name,
        ["@idjoueur"] = id,
        ["@date"] = date,
        ["@steam"] = srcid,
        ["@sujet"] = sujetreport,
        ["@desc"] = descreport,
        ["@status"] = "Actif",
        ["@staff"] = "Aucun"
        }, function()
    end)

end)

RegisterNetEvent("yazho:ReportQuestion")
AddEventHandler("yazho:ReportQuestion", function(sujetreport, descreport, id, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcid = GetPlayerIdentifier(id)
    local date = os.date(" %d/%m/20%y")

    MySQL.Async.execute("INSERT INTO yazho_report (`type`, `author`, `idjoueur`, `date`, `steam`, `sujet`, `desc`, `status`, `staff`) VALUES (@type, @author, @idjoueur, @date, @steam, @sujet, @desc, @status, @staff)", {
        ["@type"] = "Question",
        ["@author"] = name,
        ["@idjoueur"] = id,
        ["@date"] = date,
        ["@steam"] = srcid,
        ["@sujet"] = sujetreport,
        ["@desc"] = descreport,
        ["@status"] = "Actif",
        ["@staff"] = "Aucun"
        }, function()
    end)

end)


ESX.RegisterServerCallback('yazho:listereport', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local listereport = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_report WHERE status = @status', {
	  ['@status'] = "Actif"
	}, function(result)
	  for i = 1, #result, 1 do
		table.insert(listereport, {
		  type = result[i].type,
		  author = result[i].author,
          idjoueur = result[i].idjoueur,
		  date = result[i].date,
          steam = result[i].steam,
          sujet = result[i].sujet,
          desc = result[i].desc,
          status = result[i].status,
          staff = result[i].staff,
          id = result[i].id,
		})
	  end
  
	  cb(listereport)
	end)
end)

ESX.RegisterServerCallback('yazho:listereportTraite', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local listereportTraite = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_report WHERE status = @status', {
	  ['@status'] = "Inactif"
	}, function(result)
	  for i = 1, #result, 1 do
		table.insert(listereportTraite, {
		  type = result[i].type,
		  author = result[i].author,
          idjoueur = result[i].idjoueur,
		  date = result[i].date,
          steam = result[i].steam,
          sujet = result[i].sujet,
          desc = result[i].desc,
          status = result[i].status,
          staff = result[i].staff,
          id = result[i].id,
		})
	  end
  
	  cb(listereportTraite)
	end)
end)

RegisterNetEvent("yazho:PriseEnChargeReport")
AddEventHandler("yazho:PriseEnChargeReport", function(id, staffquibosse)

    MySQL.Async.execute('UPDATE yazho_report SET staff = @staff WHERE id = @id', {
		['@id'] = id,
		['@staff'] = staffquibosse
	})

end)

RegisterNetEvent("yazho:TraiterReport")
AddEventHandler("yazho:TraiterReport", function(id)

    MySQL.Async.execute('UPDATE yazho_report SET status = @status WHERE id = @id', {
		['@id'] = id,
		['@status'] = "Inactif"
	})

end)

RegisterNetEvent("yazho:OuvertureReport")
AddEventHandler("yazho:OuvertureReport", function(id)

    MySQL.Async.execute('UPDATE yazho_report SET status = @status WHERE id = @id', {
		['@id'] = id,
		['@status'] = "Actif"
	})

end)

RegisterNetEvent("yazho:DeleteReport")
AddEventHandler("yazho:DeleteReport", function(id)

    MySQL.Async.execute('DELETE FROM yazho_report WHERE id = @id', {
        ['id'] = id 
    })

end)

ESX.RegisterServerCallback('yazho:listewarnJoueur', function(IdSelected, cb)
    local srcid = GetPlayerIdentifier(IdSelected)
	local listewarnJoueur = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_warn WHERE steam = @steam', {
        ['@steam'] = srcid
      }, function(result)
        for i = 1, #result, 1 do
          table.insert(listewarnJoueur, {
            author = result[i].author,
            date = result[i].date,
            steam = result[i].steam,
            reason = result[i].reason,
            staff = result[i].name,
            id = result[i].id,
          })
        end
  
	  cb(listewarnJoueur)
	end)
end)

RegisterNetEvent("yazho:DeleteWarn")
AddEventHandler("yazho:DeleteWarn", function(id)

    MySQL.Async.execute('DELETE FROM yazho_warn WHERE id = @id', {
        ['id'] = id 
    })

end)

ESX.RegisterServerCallback('yazho:listebanJoueur', function(IdSelected, cb)
    local srcid = GetPlayerIdentifier(IdSelected)
    local listebanJoueur = {}

    MySQL.Async.fetchAll('SELECT * FROM yazho_banlisthistory WHERE identifier = @identifier', {
        ['@identifier'] = srcid
      }, function(result)
        for i = 1, #result, 1 do
          table.insert(listebanJoueur, {
            id = result[i].id,
            license = result[i].license,
            identifier  = result[i].identifier ,
            liveid = result[i].liveid,
            xblid = result[i].xblid,
            discord = result[i].discord,
            playerip = result[i].playerip,
            targetplayername = result[i].targetplayername,
            sourceplayername = result[i].sourceplayername,
            reason = result[i].reason,
            timeat = result[i].timeat,
            added = result[i].added,
            expiration = result[i].expiration,
            tempsban = result[i].tempsban,
          })
        end
  
	  cb(listebanJoueur)
	end)
end)

ESX.RegisterServerCallback('yazho:listebanJoueurActif', function(IdSelected, cb)
	local listebanJoueurActif = {}

	MySQL.Async.fetchAll('SELECT * FROM yazho_banlist', {

	},
	function (result)
	  for i=1, #result, 1 do
		table.insert(listebanJoueurActif, {
			id    = result[i].id,
			license    = result[i].license,
			identifier = result[i].identifier,
			liveid     = result[i].liveid,
			xblid      = result[i].xblid,
			discord    = result[i].discord,
			playerip   = result[i].playerip,
			targetplayername = result[i].targetplayername,
			sourceplayername = result[i].sourceplayername,
			reason     = result[i].reason,
			timeat   = result[i].timeat,
			expiration = result[i].expiration,
			added = result[i].added,
			tempsban = result[i].tempsban
		  })
	  end
	  cb(listebanJoueurActif)
    end)
end)

ESX.RegisterServerCallback('yazho:listeKickJoueur', function(IdSelected, cb)
    local srcid = GetPlayerIdentifier(IdSelected)
	local listekickJoueur = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_kick WHERE steam = @steam', {
        ['@steam'] = srcid
      }, function(result)
        for i = 1, #result, 1 do
          table.insert(listekickJoueur, {
            author = result[i].author,
            date = result[i].date,
            steam = result[i].steam,
            reason = result[i].reason,
            staff = result[i].name,
            id = result[i].id,
          })
        end
  
	  cb(listekickJoueur)
	end)
end)

RegisterNetEvent("yazho:DeleteKick")
AddEventHandler("yazho:DeleteKick", function(id)

    MySQL.Async.execute('DELETE FROM yazho_kick WHERE id = @id', {
        ['id'] = id 
    })

end)

RegisterNetEvent("yazho:GetLicenseSteam")
AddEventHandler("yazho:GetLicenseSteam", function(IdSelected, namesteam)
    local srcid = GetPlayerIdentifier(IdSelected)

    for k,v in ipairs(GetPlayerIdentifiers(IdSelected))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifier = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            playerip = v
        end
    end

    csLogsDiscord("```Voici les licenses du joueur : *"..namesteam.."\nFiveM : "..license.."\nDiscord : "..discord.."\nIP : "..playerip.."```", Config.Logs.Divers)
end)

RegisterNetEvent("yazho:WypePlayer")
AddEventHandler("yazho:WypePlayer", function(IdSelected)
    local srcid = GetPlayerIdentifier(IdSelected)

    CSWipeTable(srcid)
    DropPlayer(IdSelected, "Vous avez été wipe...")
end)

RegisterNetEvent("yazho:ban")
AddEventHandler("yazho:ban", function(source, IdSelected, nombrejour, raisonban, namestaff, idstaff)
    local license,identifier,liveid,xblid,discord,playerip
    local target = IdSelected
    local sourceplayername = namestaff
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    if raisonban == "" then
        raisonban = "Raison Inconnue"
    end
    if target and target > 0 then
        local ping = GetPlayerPing(target)
    
        if ping and ping > 0 then
            local targetplayername = GetPlayerName(target)
                for k,v in ipairs(GetPlayerIdentifiers(target))do
                    if string.sub(v, 1, string.len("license:")) == "license:" then
                        license = v
                    elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                        identifier = v
                    elseif string.sub(v, 1, string.len("live:")) == "live:" then
                        liveid = v
                    elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                        xblid  = v
                    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                        discord = v
                    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                        playerip = v
                    end
                end
        
                TriggerEvent("yazho:FunctionBan",license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,nombrejour,raisonban, idstaff)
                DropPlayer(target, "Vous avez ete ban pour : "..raisonban)
        else
			ShowNotificationServer(idstaff, "(ID) du joueur incorrect.")
        end
    else
		ShowNotificationServer(idstaff, "(ID) du joueur incorrect.")
    end
end)

Text               = {}
BanList            = {}
BanListLoad        = false
BanListHistory     = {}
BanListHistoryLoad = false

RegisterNetEvent("yazho:FunctionBan")
AddEventHandler("yazho:FunctionBan", function(license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,nombrejour,raisonban, idstaff)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM yazho_banlist WHERE targetplayername like @playername', 
	{
		['@playername'] = ("%"..targetplayername.."%")
	}, function(data)
		if not data[1] then
			local expiration = nombrejour * 86400 
			local timeat     = os.time()
			local added      = os.date()

			if expiration < os.time() then
				expiration = os.time()+expiration
			end
			
			table.insert(BanList, {
				license    = license,
				identifier = identifier,
				liveid     = liveid,
				xblid      = xblid,
				discord    = discord,
				playerip   = playerip,
				reason     = raisonban,
				expiration = expiration
			})

			MySQL.Async.execute(
					'INSERT INTO yazho_banlist (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,added,tempsban) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@added,@tempsban)',
					{ 
					['@license']          = license,
					['@identifier']       = identifier,
					['@liveid']           = liveid,
					['@xblid']            = xblid,
					['@discord']          = discord,
					['@playerip']         = playerip,
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason']           = raisonban,
					['@expiration']       = expiration,
					['@timeat']           = timeat,
					['@added']            = added,
					['@tempsban']         = nombrejour,
					},
					function ()
			end)

			ShowNotificationServer(idstaff, "Vous avez banni : " ..targetplayername.." pendant : "..nombrejour.." jours. Pour : "..raisonban..".")

			MySQL.Async.execute(
					'INSERT INTO yazho_banlisthistory (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,added,expiration,timeat,tempsban) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@tempsban)',
					{ 
					['@license']          = license,
					['@identifier']       = identifier,
					['@liveid']           = liveid,
					['@xblid']            = xblid,
					['@discord']          = discord,
					['@playerip']         = playerip,
					['@targetplayername'] = targetplayername,
					['@sourceplayername'] = sourceplayername,
					['@reason']           = raisonban,
					['@added']            = added,
					['@expiration']       = expiration,
					['@timeat']           = timeat,
                    ['@tempsban']          = nombrejour,
					},
					function ()
			end)
			
			BanListHistoryLoad = false
		else
			ShowNotificationServer(idstaff, targetplayername.." est déjà bannie pour : ".. raisonban..".")
		end
	end)
end)

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print("[BANLIST] chargée vec succès.")
				BanListLoad = true
			else
				print("ERREUR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.")
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				print("[BANLISTHISTORY] chargée avec succès.")
				BanListHistoryLoad = true
			else
				print("ERREUR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.")
			end
		end
	end
end)

CreateThread(function()
	while Config.MultiServerSync do
		Wait(30000)
		MySQL.Async.fetchAll(
		'SELECT * FROM yazho_banlist',
		{},
		function (data)
			if #data ~= #BanList then
			  BanList = {}

			  for i=1, #data, 1 do
				table.insert(BanList, {
					license    = data[i].license,
					identifier = data[i].identifier,
					liveid     = data[i].liveid,
					xblid      = data[i].xblid,
					discord    = data[i].discord,
					playerip   = data[i].playerip,
					reason     = data[i].reason,
					added      = data[i].added,
					expiration = data[i].expiration
				  })
			  end
			loadBanListHistory()
			TriggerClientEvent('yazho:Respond', -1)
			end
		end
		)
	end
end)

RegisterServerEvent('yazho:CheckMe')
AddEventHandler('yazho:CheckMe', function()
	doublecheck(source)
end)

AddEventHandler('playerConnecting', function (playerName, setKickReason, deferrals)
	local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

	if Config.SystemeBan == true then
		for k,v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		if (Banlist == {}) then
			Citizen.Wait(1000)
		end

		if steamID == "n/a" then
			setKickReason("Vous devriez ouvrir steam")
			CancelEvent()
		end

		for i = 1, #BanList, 1 do
			if 
				((tostring(BanList[i].license)) == tostring(license) 
				or (tostring(BanList[i].identifier)) == tostring(steamID) 
				or (tostring(BanList[i].liveid)) == tostring(liveid) 
				or (tostring(BanList[i].xblid)) == tostring(xblid) 
				or (tostring(BanList[i].discord)) == tostring(discord) 
				or (tostring(BanList[i].playerip)) == tostring(playerip)) 
			then

				if (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant >= 1440 then
						local day        = (tempsrestant / 60) / 24
						local hrs        = (day - math.floor(day)) * 24
						local minutes    = (hrs - math.floor(hrs)) * 60
						local txtday     = math.floor(day)
						local txthrs     = math.floor(hrs)
						local txtminutes = math.ceil(minutes)
							setKickReason("Vous avez ete ban pour : " .. BanList[i].reason .. ". Il reste : " .. txtday .. " Jours " ..txthrs .. " heures " ..txtminutes .. " minutes.")
							CancelEvent()
							break
					elseif tempsrestant >= 60 and tempsrestant < 1440 then
						local day        = (tempsrestant / 60) / 24
						local hrs        = tempsrestant / 60
						local minutes    = (hrs - math.floor(hrs)) * 60
						local txtday     = math.floor(day)
						local txthrs     = math.floor(hrs)
						local txtminutes = math.ceil(minutes)
						setKickReason("Vous avez ete ban pour : " .. BanList[i].reason .. ". Il reste : " .. txtday .. " Jours " ..txthrs .. " heures " ..txtminutes .. " minutes.")
							CancelEvent()
							break
					elseif tempsrestant < 60 then
						local txtday     = 0
						local txthrs     = 0
						local txtminutes = math.ceil(tempsrestant)
						setKickReason("Vous avez ete ban pour : " .. BanList[i].reason .. ". Il reste : " .. txtday .. " Jours " ..txthrs .. " heures " ..txtminutes .. " minutes.")
							CancelEvent()
							break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() then

					deletebanned(license)
					break
				end
			end
		end
	end
end)

AddEventHandler('es:playerLoaded',function(source)
	if Config.SystemeBan == true then
		CreateThread(function()
		Wait(5000)
			local license,steamID,liveid,xblid,discord,playerip
			local playername = GetPlayerName(source)

			for k,v in ipairs(GetPlayerIdentifiers(source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
				elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
					steamID = v
				elseif string.sub(v, 1, string.len("live:")) == "live:" then
					liveid = v
				elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
					xblid  = v
				elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
					discord = v
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					playerip = v
				end
			end

			MySQL.Async.fetchAll('SELECT * FROM `yazho_baninfo` WHERE `license` = @license', {
				['@license'] = license
			}, function(data)
			local found = false
				for i=1, #data, 1 do
					if data[i].license == license then
						found = true
					end
				end
				if not found then
					MySQL.Async.execute('INSERT INTO yazho_baninfo (license,identifier,liveid,xblid,discord,playerip,playername) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@playername)', 
						{ 
						['@license']    = license,
						['@identifier'] = steamID,
						['@liveid']     = liveid,
						['@xblid']      = xblid,
						['@discord']    = discord,
						['@playerip']   = playerip,
						['@playername'] = playername
						},
						function ()
					end)
				else
					MySQL.Async.execute('UPDATE `yazho_baninfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `license` = @license', 
						{ 
						['@license']    = license,
						['@identifier'] = steamID,
						['@liveid']     = liveid,
						['@xblid']      = xblid,
						['@discord']    = discord,
						['@playerip']   = playerip,
						['@playername'] = playername
						},
						function ()
					end)
				end
			end)
			if Config.MultiServerSync then
				doublecheck(source)
			end
		end)
	end
end)

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM yazho_banlist',
		{},
		function (data)
		  BanList = {}

		  for i=1, #data, 1 do
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expiration = data[i].expiration
			  })
		  end
    end)
end

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM yazho_banlisthistory',
		{},
		function (data)
		  BanListHistory = {}

		  for i=1, #data, 1 do
			table.insert(BanListHistory, {
				license          = data[i].license,
				identifier       = data[i].identifier,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				playerip         = data[i].playerip,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				timeat           = data[i].timeat
			  })
		  end
    end)
end

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM yazho_banlist WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
			loadBanList()
	end)
end

function doublecheck(player)
	if GetPlayerIdentifiers(player) then
		local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end

		for i = 1, #BanList, 1 do
			if 
				  ((tostring(BanList[i].license)) == tostring(license) 
				or (tostring(BanList[i].identifier)) == tostring(steamID) 
				or (tostring(BanList[i].liveid)) == tostring(liveid) 
				or (tostring(BanList[i].xblid)) == tostring(xblid) 
				or (tostring(BanList[i].discord)) == tostring(discord) 
				or (tostring(BanList[i].playerip)) == tostring(playerip)) 
			then

				if (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
						DropPlayer(player, "Vous avez ete ban pour : " .. BanList[i].reason)
						break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() then

					deletebanned(license)
					break

				end
			end
		end
	end
end

RegisterNetEvent("yazho:DeleteBan")
AddEventHandler("yazho:DeleteBan", function(id)

    MySQL.Async.execute('DELETE FROM yazho_banlisthistory WHERE id = @id', {
        ['id'] = id 
    })

end)

RegisterNetEvent("yazho:DeleteBan2")
AddEventHandler("yazho:DeleteBan2", function(id)

    MySQL.Async.execute('DELETE FROM yazho_banlist WHERE id = @id', {
        ['id'] = id 
    })

end)

RegisterServerEvent('yazho:AddGrade')
AddEventHandler('yazho:AddGrade', function(grade_name, grade, idstaff)

	MySQL.Async.fetchAll('SELECT * FROM yazho_gradestaff WHERE grade_name like @grade_name', {
		['@grade_name'] = ("%"..grade_name.."%")
	}, function(data)
		if not data[1] then
			MySQL.Async.fetchAll('SELECT * FROM yazho_gradestaff WHERE grade like @grade', {
				['@grade'] = ("%"..grade.."%")
			}, function(data)
				if not data[1] then
					MySQL.Async.execute('INSERT INTO yazho_gradestaff (grade_name, grade) VALUES (@grade_name, @grade)', {
						['@grade_name'] = grade_name,
						['@grade'] = grade
					})

					ShowNotificationServer(idstaff, "Le grade "..grade_name.." à correctement été créer !")
				else
					ShowNotificationServer(idstaff, "Le grade "..grade.." existe déja...")
				end
			end)
		else
			ShowNotificationServer(idstaff, "Le grade "..grade_name.." existe déja...")
		end
	end)

end)

ESX.RegisterServerCallback('yazho:listegrade', function(IdSelected, cb)
    local srcid = GetPlayerIdentifier(IdSelected)
	local listegradeJoueur = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_gradestaff', {

      }, function(result)
        for i = 1, #result, 1 do
          table.insert(listegradeJoueur, {
            id = result[i].id,
            grade_name = result[i].grade_name,
            grade = result[i].grade
          })
        end
  
	  cb(listegradeJoueur)
	end)
end)

RegisterServerEvent('yazho:deletegrade')
AddEventHandler('yazho:deletegrade', function(id)

	MySQL.Async.execute('DELETE FROM yazho_gradestaff WHERE id = @id', {
        ['@id'] = id
    })

end)

RegisterNetEvent("yazho:ModifNameGrade")
AddEventHandler("yazho:ModifNameGrade", function(id, grade_name2)

    MySQL.Async.execute('UPDATE yazho_gradestaff SET grade_name = @grade_name WHERE id = @id', {
		['@id'] = id,
		['@grade_name'] = grade_name2
	})
end)

RegisterNetEvent("yazho:ModifGrade")
AddEventHandler("yazho:ModifGrade", function(id, grade2)

    MySQL.Async.execute('UPDATE yazho_gradestaff SET grade = @grade WHERE id = @id', {
		['@id'] = id,
		['@grade'] = grade2
	})
end)

ESX.RegisterServerCallback('yazho:listestaff', function(IdSelected, cb)
    local srcid = GetPlayerIdentifier(IdSelected)
	local listestaffJoueur = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_joueurstaff', {

      }, function(result)
        for i = 1, #result, 1 do
          table.insert(listestaffJoueur, {
            id = result[i].id,
            steam = result[i].steam,
			name = result[i].name,
			grade_name = result[i].grade_name,
			grade = result[i].grade
          })
        end
	  cb(listestaffJoueur)
	end)
end)

RegisterServerEvent('yazho:deletestaff')
AddEventHandler('yazho:deletestaff', function(id)

	MySQL.Async.execute('DELETE FROM yazho_joueurstaff WHERE id = @id', {
        ['@id'] = id
    })
end)

RegisterNetEvent("yazho:ModifStaffGrade")
AddEventHandler("yazho:ModifStaffGrade", function(id, grade_name, grade)

    MySQL.Async.execute('UPDATE yazho_joueurstaff SET grade_name = @grade_name, grade = @grade WHERE id = @id', {
		['@id'] = id,
		['@grade_name'] = grade_name, 
		['@grade'] = grade
	})
end)

ESX.RegisterServerCallback('yazho:listedesstaff', function(source, cb)
    local srcid = GetPlayerIdentifier(source)
	local listestaffJoueur = {}
  
	MySQL.Async.fetchAll('SELECT * FROM yazho_joueurstaff', {

      }, function(result)
        for i = 1, #result, 1 do
          table.insert(listestaffJoueur, {
            steam = result[i].steam,
			grade = result[i].grade,
          })
		if result[i].steam == srcid then
			cb = true
		else
			cb = false
		end
        end
	  if cb == true then
		print("OK")
	  else
		print("NON")
	  end
	end)
end)

local notifstaff = false

ESX.RegisterServerCallback('yazho:getgroup', function(source, cb)
	local srcid = GetPlayerIdentifier(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM yazho_joueurstaff', {

	}, function(result)
	for i = 1, #result, 1 do
		local data = {
			steam = result[i].steam,
			grade = result[i].grade,
        }

		if result[i].steam == srcid then
			group = result[i].grade
        	cb(group)
		end
	end
  	end)
end)

RegisterServerEvent('yazho:AddStaff')
AddEventHandler('yazho:AddStaff', function(idstaff, grade_name, grade, namestaff)
	local srcid = GetPlayerIdentifier(idstaff)

    MySQL.Async.execute('INSERT INTO yazho_joueurstaff (steam, name, grade_name, grade) VALUES (@steam, @name, @grade_name, @grade)', {
        ['@steam'] = srcid,
        ['@name'] = namestaff,
		['@grade_name'] = grade_name,
		['@grade'] = grade
    })

end)

local onservicestaff = false

RegisterServerEvent('yazho:priseservicenotif')
AddEventHandler('yazho:priseservicenotif', function(playergroup, namestaff, onservice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		local srcid = GetPlayerIdentifier(xPlayers[i])
		MySQL.Async.fetchAll('SELECT * FROM yazho_joueurstaff', {

		}, function(result)
		for i = 1, #result, 1 do
			local data = {
				steam = result[i].steam,
				grade = result[i].grade,
			}
	
			if result[i].steam == srcid then
				group = result[i].grade
				ShowNotificationServer(xPlayers[i], "("..namestaff..") est en service.")
			end
		end
		  end)
	end
end)

RegisterServerEvent('yazho:annonceservicefin')
AddEventHandler('yazho:annonceservicefin', function(playergroup, namestaff, onservice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		local srcid = GetPlayerIdentifier(xPlayers[i])
		MySQL.Async.fetchAll('SELECT * FROM yazho_joueurstaff', {

		}, function(result)
		for i = 1, #result, 1 do
			local data = {
				steam = result[i].steam,
				grade = result[i].grade,
			}
	
			if result[i].steam == srcid then
				group = result[i].grade
				ShowNotificationServer(xPlayers[i], "("..namestaff..") n'est plus en service.")
			end
		end
		  end)
	end
end)

RegisterServerEvent('yazho:annonceReport')
AddEventHandler('yazho:annonceReport', function(playergroup, onservice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	if Config.SystemeReport == true then
		for i=1, #xPlayers, 1 do
			local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			local srcid = GetPlayerIdentifier(xPlayers[i])
			MySQL.Async.fetchAll('SELECT * FROM yazho_joueurstaff', {

			}, function(result)
			for i = 1, #result, 1 do
				local data = {
					steam = result[i].steam,
					grade = result[i].grade,
				}
		
				if result[i].steam == srcid then
					group = result[i].grade
					ShowNotificationServer(xPlayers[i], "[REPORT]~n~Un nouveau report à été envoyé.")
				end
			end
			end)
		end
	end
end)

RegisterServerEvent('yazho:tpid')
AddEventHandler('yazho:tpid', function(IdSelected)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetId = IdSelected
	local xTarget = ESX.GetPlayerFromId(targetId)
	local targetCoords = xTarget.getCoords()
	local playerCoords = xPlayer.getCoords()
	savedCoords[targetId] = targetCoords
	xTarget.setCoords(playerCoords)
end)

RegisterServerEvent('yazho:tpback')
AddEventHandler('yazho:tpback', function(IdSelected)
	local targetId = IdSelected
	local xTarget = ESX.GetPlayerFromId(targetId)
	local playerCoords = savedCoords[targetId]
	xTarget.setCoords(playerCoords)
	savedCoords[targetId] = nil
end)

RegisterNetEvent("adminmenu:bring")
AddEventHandler("adminmenu:bring", function(target, coords, coordsID)
    local source = source
	savedCoords[target] = coordsID
    TriggerClientEvent("adminmenu:setCoords", target, coords)
end)

RegisterNetEvent("adminmenu:bringback")
AddEventHandler("adminmenu:bringback", function(target)
    local source = source
	local playerCoords = savedCoords[target]
    TriggerClientEvent("adminmenu:setCoords", target, playerCoords)
	savedCoords[target] = nil
end)

RegisterNetEvent("adminmenu:tpendroit")
AddEventHandler("adminmenu:tpendroit", function(target, coords)
    local source = source
    TriggerClientEvent("adminmenu:setCoords", target, coords)
end)

RegisterNetEvent("yazho:setgpb")
AddEventHandler("yazho:setgpb", function(target, armour)
    local source = source
    TriggerClientEvent("yazho:setgpb", target, armour)
end)

RegisterNetEvent("yazho:freezJoueur")
AddEventHandler("yazho:freezJoueur", function(target, active)
    local source = source
    TriggerClientEvent("yazho:freezJoueur", target, active)
end)


RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local source = source
	TriggerClientEvent("adminmenu:updatePlayers", source, players)
end)

RegisterNetEvent("yazho:specjoueur")
AddEventHandler("yazho:specjoueur", function(target, name)
    local source = source
    TriggerClientEvent("yazho:specjoueur", target, name)
end)

AddEventHandler('onResourceStart', function(resourceName, vehicleProps)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
        Wait(100)
	print("Le menu admin est correctement start")
end)