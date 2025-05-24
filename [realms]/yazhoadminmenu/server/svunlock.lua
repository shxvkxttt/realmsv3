ESX = nil



RegisterServerEvent('yazho:givecash')
AddEventHandler('yazho:givecash', function(givecash)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	xPlayer.addMoney(givecash)
end)

RegisterServerEvent('yazho:givecash2')
AddEventHandler('yazho:givecash2', function(givecash, target)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xTarget = ESX.GetPlayerFromId(target)

	xTarget.addMoney(givecash)
end)

RegisterServerEvent('yazho:retraitcash')
AddEventHandler('yazho:retraitcash', function(retraitcash)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	xPlayer.removeMoney(retraitcash)
end)

RegisterServerEvent('yazho:retraitcash2')
AddEventHandler('yazho:retraitcash2', function(retraitcash, target)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xTarget = ESX.GetPlayerFromId(target)

	xTarget.removeMoney(retraitcash)
end)

RegisterServerEvent("yazho:givebank")
AddEventHandler("yazho:givebank", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.addAccountMoney('bank', money)
end)

RegisterServerEvent("yazho:givebank2")
AddEventHandler("yazho:givebank2", function(money, target)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xTarget = ESX.GetPlayerFromId(target)
    
    xTarget.addAccountMoney('bank', money)
end)

RegisterServerEvent("yazho:removebank2")
AddEventHandler("yazho:removebank2", function(money, target)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xTarget = ESX.GetPlayerFromId(target)
    
    xTarget.removeAccountMoney('bank', money)
end)

RegisterServerEvent("yazho:retraitbank")
AddEventHandler("yazho:retraitbank", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    
    xPlayer.removeAccountMoney('bank', money)
end)


RegisterServerEvent("yazho:giveblack")
AddEventHandler("yazho:giveblack", function(amountBlack)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = amountBlack
    
    xPlayer.addAccountMoney('black_money', amountBlack)
end)

RegisterServerEvent("yazho:giveblack2")
AddEventHandler("yazho:giveblack2", function(amountBlack, target)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xTarget = ESX.GetPlayerFromId(target)
    
    xTarget.addAccountMoney('black_money', amountBlack)
end)

RegisterServerEvent("yazho:retraitblack")
AddEventHandler("yazho:retraitblack", function(amountBlack)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = amountBlack
    
    xPlayer.removeAccountMoney('black_money', amountBlack)
end)

RegisterServerEvent("yazho:retraitblack2")
AddEventHandler("yazho:retraitblack2", function(amountBlack, target)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local xTarget = ESX.GetPlayerFromId(target)
    
    xTarget.removeAccountMoney('black_money', amountBlack)
end)

RegisterServerEvent('yazho:addlicense')
AddEventHandler('yazho:addlicense', function(target, permis)
	local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = permis,
        ['@owner'] = xPlayer.identifier
    })

end)

RegisterServerEvent('yazho:suplicense')
AddEventHandler('yazho:suplicense', function(target, permis)
	local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
        ['@type'] = permis,
        ['@owner'] = xPlayer.identifier
    })

end)

ESX.RegisterServerCallback('yazho:getInv', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
			money = xPlayer.getMoney(),
            weapons = xPlayer.getLoadout(),
        }

        cb(data)
    end
end)

RegisterNetEvent("yazho:ModifDateOfBirth")
AddEventHandler("yazho:ModifDateOfBirth", function(IdSelected, newdateofbirth)
    local srcid = GetPlayerIdentifier(IdSelected)

    MySQL.Async.execute('UPDATE users SET dateofbirth = @dateofbirth WHERE identifier = @identifier', {
		['@identifier'] = srcid,
		['@dateofbirth'] = newdateofbirth
	})
end)

RegisterNetEvent("yazho:ModifSexe")
AddEventHandler("yazho:ModifSexe", function(IdSelected, newsexe)
    local srcid = GetPlayerIdentifier(IdSelected)

    MySQL.Async.execute('UPDATE users SET sex = @sex WHERE identifier = @identifier', {
		['@identifier'] = srcid,
		['@sex'] = newsexe
	})
end)

RegisterServerEvent('yazho:annonceserviceprise')
AddEventHandler('yazho:annonceserviceprise', function(playergroup, namestaff, onservice)
	onservicestaff = true
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if playergroup >= "0" then
			if onservicestaff == true then
				if Config.NotifPriseService == true then
					ShowNotificationServer(xPlayers[i], "(~r~"..namestaff.."~s~) vient de prendre son service.")
				end
			end
		end
	end
end)