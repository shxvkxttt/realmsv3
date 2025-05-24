ESX = nil
local dogtoggle = false
local superJumpactive = false
local superSprintactive = false
local vitessesprint = 1.00
local SelectedJob = {}
local tableBlip = {}
local joueurTP = false
local spectate = false
local ServerIDSess = false
local blipsActive = false
local start = true
local itemlimit = true
local actif = true
local ShowName = false
local gamerTags = {}
local GetBlips = false
local joueurenligne = 0
local kmh = 3.6
local mph = 2.23693629
local carspeed = 0
local driftmode = false
local speed = 3.6
local drift_speed_limit = 100.0 
local toggle = 118
listereport = {}
listereportTraite = {}
listewarnJoueur = {}
listebanJoueur = {}
listebanJoueurActif = {}
listekickJoueur = {}
listegradeJoueur = {}
listestaffJoueur = {}
local playergroup = {}
onservicestaff = false

function RefreshPlayerGroup()
	ESX.TriggerServerCallback('yazho:getgroup', function(group)
		playergroup = group
	end)
end

Citizen.CreateThread(function()
    while ESX == nil do
        if Config.ESextendedLegacy == true then
            ESX = exports["es_extended"]:getSharedObject()
        else
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

local ServersIdSession = {}

CreateThread(function()
    while true do
        Wait(1000)
        if ServerIDSess == true then
            for k,v in pairs(GetActivePlayers()) do
                local found = false
                for _,j in pairs(ServersIdSession) do
                    if GetPlayerServerId(v) == j then
                        found = true
                    end
                end
                if not found then
                    table.insert(ServersIdSession, GetPlayerServerId(v))
                    joueurenligne = joueurenligne + 1
                end
            end
        end
    end
end)

local Items = {}      
local Armes = {}
local ArgentSale = {}  
local ArgentBank = {}
local function getPlayerInv(player)
	Items = {}
	Armes = {}
    ArgentSale = {}
	ArgentBank = {}

	ESX.TriggerServerCallback('yazho:getInv', function(data)
	for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
			table.insert(ArgentSale, {
				label    = ESX.Math.Round(data.accounts[i].money),
				value    = 'black_money',
				itemType = 'item_standard',
				amount   = data.accounts[i].money
			})

			break
		end
	end
	for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'bank' and data.accounts[i].money > 0 then
			table.insert(ArgentBank, {
				label    = ESX.Math.Round(data.accounts[i].money),
				value    = 'bank',
				itemType = 'item_account',
				amount   = data.accounts[i].money
			})

			break
		end
	end
		for i=1, #data.weapons, 1 do
			table.insert(Armes, {
				label    = ESX.GetWeaponLabel(data.weapons[i].name),
				value    = data.weapons[i].name,
				right    = data.weapons[i].ammo,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end
		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(Items, {
					label    = data.inventory[i].label,
					right    = data.inventory[i].count,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
	end
	end, player)
end

function admin_vehicle_flip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
    if carTargetDep ~= nil then
            platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
    
    SetEntityCoords(carTargetDep, playerCoords)
    
    ESX.ShowNotification("Véhicule retourné.") 

end

local arrayIndex5 = 1
local arraycar = {
    "Noir", --1
    "Rouge",--2
    "Vert",--3
    "Blanc",--4
    "Jaune",--5
    "Violet",--6
    "Orange",--7
    "Bleu"--8
}
local couleur = {
    [1] = {color = 0, color2 = 0},
    [2] = {color = 27, color2 = 27},
    [3] = {color = 50, color2 = 50},
    [4] = {color = 112, color2 = 112},
    [5] = {color = 88, color2 = 88},
    [6] = {color = 71, color2 = 71},
    [7] = {color = 38, color2 = 38},
    [8] = {color = 64, color2 = 64},
}
local arrayIndexcar = 1

local ActionAdmin = {
    SpwanCarMySelf = {'Sultan', 'Bf400', 'BMX'}, 
    ListeSpwanCarMySelf = 1,
    ActionAdmin = {'Marqueur', 'LSPD', 'Club de Strip'}, 
    ListeActionAdmin = 1,
    ActionMoteur = {'Niveau usinage', 'Niveau 1', 'Niveau 2', 'Niveau 3', 'Niveau 4'}, 
    ListeActionMoteur = 1,
    TintNeon = {'Rouge','Vert', "Jaune", "Rose", "Bleu", "Orange", "Violet"}, 
    ListeTintNeon = 1,
    TintPhare = {'Blanc','Bleu', "Bleu clair", "Bleu/vert", "Vert", "Jaune", "Orange", "Rouge", "Rose Clair", "Rose", "Violet"}, 
    ListeTintPhare = 1,
    ActionSpawn = {'Spawn + TP', 'Spawn'}, 
    ListeActionSpawn = 1,
    ActionVehEnFace = {'Réparer', 'Supprimer', 'Nettoyer', 'Retourner'}, 
    ListeActionVehEnFace = 1,
    ActionPermis = {'Code de la route', 'PPA', 'Permis voiture', 'Permis camion', 'Permis moto', 'Permis bateau', 'Permis avion'}, 
    ListeActionPermis = 1,
    ActionArgent = {'Cash', 'Banque', 'Argent sale'}, 
    ListeActionArgent = 1,
    ActionMarkerType = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43'}, 
    ListeActionMarkerType = 1,
    ActionScaleX = {'0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'}, 
    ListeActionScaleX = 1,
    ActionScaleY = {'0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'}, 
    ListeActionScaleY = 1,
    ActionScaleZ = {'0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'}, 
    ListeActionScaleZ = 1,
    ActionColorMarker = {'Rouge', 'Orange', 'Jaune', 'Vert', 'Cyan', 'Bleu', 'Violet', 'Rose'}, 
    ListeActionColorMarker = 1,
    ActionDirt = {'0', '1', '2', '3', '4', '~r5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15'}, 
    ListeActionDirt = 1,
    ActionColorBlip = {'Blanc', 'Rouge', 'Vert Claire', 'Bleu Claire', 'Jaune', 'Violet', 'Rose', 'Bleu Foncé', 'Vert Foncé', 'Orange', 'Orange Claire', 'Cyan', 'Rose Claire', 'Medium Violet', 'Salmon', 'Rouge Claire', 'Vert Melon', 'Bleu', 'Marron Claire', 'Beige'},
    ListeActionColorBlip = 1,
    ActionTailleBlip = {'0.5', '0.6', '0.7', '0.8', '0.9', '1.0', '1.1', '1.2', '1.3', '1.4', '1.5'}, 
    ListeActionTailleBlip = 1,
    ActionTypeBlip = {'Maison', 'Drapeau d\'arrivé', 'Hélicoptère', 'Garage', 'Médicamment', 'Panier supérette', 'Taxi', 'Police', 'EMS', 'Camion', 'Coiffeur','Bombe de peinture', 'Tee-Shirt', 'Tatouage', 'Tête de mort', 'Avion', 'Cocktail', 'Car-Wash', 'Pistolet', 'Weed', 'Appareil Photo', 'Dollards', 'Moto', 'Petit Bonhomme', 'Jerrycan d\'essence', 'Malette', 'Clé à molette', 'Drapeau Américain', 'Benny\'s', 'Immeuble'}, ListeActionTypeBlip = 1,
    ActionTeleportation = {'LSPD', 'Club de Strip'}, 
    ListeActionTeleportation = 1,
    ActionResources = {'Start', 'Stop'}, 
    ListeActionResources = 1,
    ActionDesResources = {'Start', 'Re-Start', 'Stop'}, 
    ListeActionDesResources = 1,
    ActionGestionSanctions = {'Warn', 'Kick', 'Ban'}, 
    ListeActionGestionSanctions = 1,
    ActionReport = {'Report un joueur', 'Bug', 'Question'}, 
    ListeActionReport = 1,
    ActionDesReport = {'Prendre en charge', 'Fermer'}, 
    ListeActionDesReport = 1,
    ActionDesReport2 = {'Supprimer', 'Ré-ouvrir'}, 
    ListeActionDesReport2 = 1,
    ActionStatusDesReport = {'Non traité','Déjà traité'}, 
    ListeActionStatusDesReport = 1,
    ActionModifs = {'Prénom', 'Nom', 'Date de naissance', 'Sexe'}, 
    ListeActionModifs = 1,
    ActionGestionGrade = {'Supprimer','Modifier le nom','Modifier le grade'}, 
    ListeActionGestionGrade = 1,
    ActionGestionStaff = {'Supprimer','Modifier le grade'}, 
    ListeActionGestionStaff = 1,
    ActionCouleurVeh = {'Noir', 'Gris', "Blanc", "Rouge", "Orange", "Jaune", "Vert", "Cyan", "Bleu", "Rose", "Violet"}, 
    ListeActionCouleurVeh = 1,
}

local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
ItemData = nil
Itemindex = 0

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

players = {}

for _, player in ipairs(GetActivePlayers()) do
    local ped = GetPlayerPed(player)
    table.insert(players, player)
end

function GetStaff()
    ESX.TriggerServerCallback('yazho:listestaff', function(listestaff)
        listestaffJoueur = listestaff
    end)
end

function GetGrades()
    ESX.TriggerServerCallback('yazho:listegrade', function(listegrade)
        listegradeJoueur = listegrade
    end)
    return
end

function GetBanActif()
    if Config.SystemeBan == true then
        ESX.TriggerServerCallback('yazho:listebanJoueurActif', function(listebanActif)
            listebanJoueurActif = listebanActif
        end)
    end
    return
end

function GetBanJoueur()
    if Config.SystemeBan == true then
        ESX.TriggerServerCallback('yazho:listebanJoueur', function(listeban)
            listebanJoueur = listeban
        end)
    end
    return
end

function GetKickJoueur()
    if Config.SystemeKick == true then
        ESX.TriggerServerCallback('yazho:listeKickJoueur', function(listkick)
            listekickJoueur = listkick
        end)
    end
    return
end

function GetWarnJoueur()
    if Config.SystemeWarn == true then
        ESX.TriggerServerCallback('yazho:listewarnJoueur', function(listewarn)
            listewarnJoueur = listewarn
        end)
    end
    return
end

function GetReportTraite()
    if Config.SystemeReport == true then
        ESX.TriggerServerCallback('yazho:listereportTraite', function(listetraite)
            listereportTraite = listetraite
        end)
    end
    return
end

function GetReport()
    if Config.SystemeReport == true then
        ESX.TriggerServerCallback('yazho:listereport', function(liste)
            listereport = liste
        end)
    end
end

function MenuAdmin(playergroup)
	local AdminMenu = RageUI.CreateMenu("MENU ADMIN", "MENU D'INTERACTIONS")
	local GestionPersonnel = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionDev = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local Infos = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionGrades = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionStaffs = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local AddStaff = RageUI.CreateSubMenu(GestionStaffs, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionVeh = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuPed = RageUI.CreateSubMenu(GestionPersonnel, "MENU ADMIN", "MENU D'INTERACTIONS")
    local Armas = RageUI.CreateSubMenu(GestionPersonnel, "MENU ADMIN", "MENU D'INTERACTIONS")
    local Viosionas = RageUI.CreateSubMenu(GestionPersonnel, "MENU ADMIN", "MENU D'INTERACTIONS")
    local Racc = RageUI.CreateSubMenu(GestionPersonnel, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuMarker = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuBlips = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuResource = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuCreateItem = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionJoueur = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionJoueur2 = RageUI.CreateSubMenu(GestionJoueur, "MENU ADMIN", "MENU D'INTERACTIONS")
    local Administration = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuLivery = RageUI.CreateSubMenu(GestionVeh, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuGestionSanction = RageUI.CreateSubMenu(GestionJoueur2, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuItemJoueur = RageUI.CreateSubMenu(GestionJoueur2, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionBanActif = RageUI.CreateSubMenu(GestionDev, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuInv = RageUI.CreateSubMenu(GestionJoueur2, "MENU ADMIN", "MENU D'INTERACTIONS")
    local MenuItem = RageUI.CreateSubMenu(GestionPersonnel, "MENU ADMIN", "MENU D'INTERACTIONS")
    local GestionReport = RageUI.CreateSubMenu(AdminMenu, "MENU ADMIN", "MENU D'INTERACTIONS")
    local AddStaffJoueur = RageUI.CreateSubMenu(GestionJoueur2, "MENU ADMIN", "MENU D'INTERACTIONS")

    if Config.Bannierperso == true then
        AdminMenu:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionPersonnel:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionDev:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        Infos:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionGrades:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionStaffs:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        AddStaff:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        AddStaffJoueur:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionVeh:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuPed:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        Armas:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        Viosionas:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        Racc:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuMarker:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuBlips:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuResource:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuCreateItem:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionJoueur:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionJoueur2:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        Administration:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuLivery:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuGestionSanction:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuItemJoueur:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionBanActif:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuInv:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        MenuItem:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
        GestionReport:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
    else
        AdminMenu:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionPersonnel:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionDev:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        Infos:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionGrades:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionStaffs:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        AddStaff:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        AddStaffJoueur:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionVeh:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuPed:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        Armas:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        Viosionas:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        Racc:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuMarker:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuBlips:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuResource:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuCreateItem:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionJoueur:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionJoueur2:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        Administration:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuLivery:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuGestionSanction:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuItemJoueur:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionBanActif:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuInv:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        MenuItem:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
        GestionReport:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    end

    local label = "Gestion Administration"
	RageUI.Visible(AdminMenu, not RageUI.Visible(AdminMenu))

			while AdminMenu do
				Citizen.Wait(0)

				RageUI.IsVisible(AdminMenu, true, true, true, function()

                    RageUI.Checkbox(label, nil, adminserv, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        adminserv = Checked;
                    end, function()
                        onservice = true
                        label = "Gestion Administration"
                        local namestaff = GetPlayerName(PlayerId())
                        TriggerServerEvent("yazho:priseservicenotif", playergroup, namestaff, onservice)
                        TriggerServerEvent('yazho:logsEvent', "(STEAM) {"..GetPlayerName(PlayerId()).."} a pris son service.", Config.Logs.PriseFinService)
                    end, function()
                        label = "Gestion Administration"
                        local namestaff = GetPlayerName(PlayerId())
                        TriggerServerEvent("yazho:annonceservicefin", playergroup, namestaff, onservice)
                        TriggerServerEvent('yazho:logsEvent', "(STEAM) {"..GetPlayerName(PlayerId()).."} a terminé son service.", Config.Logs.PriseFinService)
                        onservice = false
                    end)

                    if onservice then

                        RageUI.Line()

                        if Config.GestionPersonnel == true then
                            if playergroup >= Config.PermGestionPersonnel then
                                RageUI.Button("Gestion Personnel", nil, {RightLabel = "→→→"}, true, {}, GestionPersonnel)
                            end
                        end

                        if Config.GestionJoueur == true then
                            if playergroup >= Config.PermGestionJoueur then
                                RageUI.Button("Liste des Joueurs", nil, {RightLabel = "→→→"}, true, {}, GestionJoueur)
                            end
                        end

                        if Config.SystemeReport == true then
                            if playergroup >= Config.PermGestionReport then
                                RageUI.Button("Liste des Reports", nil, {RightLabel = "→→→"}, true, {
                                    onSelected = function()
                                        GetReportTraite()
                                        GetReport()
                                    end
                                }, GestionReport)
                            end
                        end

                        if Config.GestionVeh == true then
                            if playergroup >= Config.PermGestionVeh then
                                RageUI.Button("Gestion Véhicule(s)", nil, {RightLabel = "→→→"}, true, {}, GestionVeh)
                            end
                        end

                        if Config.GestionGrade == true then
                            if playergroup >= Config.PermGestionGrade then
                                RageUI.Button("Gérer les Grades", nil, {RightLabel = "→→→"}, true, {
                                    onSelected = function()
                                        GetGrades()
                                    end
                                }, GestionGrades)
                            end
                        end

                        if Config.GestionStaff == true then
                            if playergroup >= Config.PermGestionStaff then
                                RageUI.Button("Gérer les Staffs", nil, {RightLabel = "→→→"}, true, {
                                    onSelected = function()
                                        GetStaff()
                                    end
                                }, GestionStaffs)                 
                            end
                        end

                        if Config.GestionDev == true then
                            if playergroup >= Config.PermGestionDev then
                                RageUI.Button("Gestions Supplémentaires", nil, {RightLabel = "→→→"}, true, {}, GestionDev)
                            end
                        end

                    end

                end, function()
                end)
                
                RageUI.IsVisible(GestionPersonnel, true, true, true, function()
                    if Config.AfficherNom == true then
                        if playergroup >= Config.PermAfficherNom then
                            RageUI.Separator("Administrations")
                            RageUI.Checkbox("Afficher les Noms",nil, getname,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    getname = Checked
                                    if Checked then
                                        ShowName = true
                                    else
                                        ShowName = false
                                    end
                                end
                            end)
                        end
                    end

                    if Config.AfficherBlips == true then
                        if playergroup >= Config.PermAfficherBlips then
                            RageUI.Checkbox("Afficher les Blips",nil, setblips,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    setblips = Checked
                                    if Checked then
                                        blipsActive = true
                                    else
                                        blipsActive = false
                                    end
                                end
                            end)
                        end
                    end

                    if Config.Raccourcis == true then
                        if playergroup >= Config.PermRaccourcis then
                            RageUI.Button("Différents Raccourcis", nil, {RightLabel = "→→"},true, {}, Racc)
                        end
                    end

                    if Config.Invisible == true then
                        if playergroup >= Config.PermInvisible then
                            RageUI.Checkbox("Mode Invisible",nil, invisible,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    invisible = Checked
            
                                    if Checked then
                                        SetEntityVisible(GetPlayerPed(-1), 0, 0)
                                        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), 1)
                                    else
                                        SetEntityVisible(GetPlayerPed(-1), 1, 0)
                                        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), 0)
                                    end
                                end
                            end)
                        end
                    end

                    if Config.NoClip == true then
                        if playergroup >= Config.PermNoClip then
                            RageUI.Checkbox("NoClip", "F2", noclip,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    noclip = Checked
            
                                    if Checked then
                                        NoCLIP(true)
                                    else
                                        NoCLIP(false)
                                    end
                                end
                            end)
                        end
                    end

                    

                    if Config.Heal == true then
                        if playergroup >= Config.PermHeal then
                            RageUI.Separator("Immunité(s)")
                            RageUI.Button("Se Heal", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est heal", Config.Logs.ActionPersonnel)
                                    SetEntityHealth(GetPlayerPed(-1), GetEntityMaxHealth(GetPlayerPed(-1)))
                                    cooldowncool(100)
                                end
                            })
                        end
                    end

                    if Config.GodMod == true then
                        if playergroup >= Config.PermGodMod then
                            RageUI.Checkbox("GodMod",nil, godmod,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    godmod = Checked
                                    if Checked then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a activé le GodMod.", Config.Logs.ActionPersonnel)
                                        local ped = GetPlayerPed(-1)
                                        SetEntityInvincible(ped, true)
                                    else
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a désactivé le GodMod.", Config.Logs.ActionPersonnel)
                                        local ped = GetPlayerPed(-1)
                                        SetEntityInvincible(ped, false)
                                    end
                                end
                            end)
                        end
                    end
                    
                    if Config.GPB == true then
                        if playergroup >= Config.PermGPB then
                            RageUI.Checkbox("Protection PB",nil, parballe,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    parballe = Checked
            
                                    if Checked then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est mit un GPB", Config.Logs.ActionPersonnel)
                                        SetPedArmour(PlayerPedId(), 100)
                                    else
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est retiré un GPB", Config.Logs.ActionPersonnel)
                                        SetPedArmour(PlayerPedId(), 0)
                                    end
                                end
                            end)
                        end
                    end

                    if Config.Armas == true then
                        RageUI.Separator("Don(s)")
                        if playergroup >= Config.PermArmas then
                            RageUI.Button("Give d'Arme(s)", nil, {RightLabel = "→→"}, true, {}, Armas)
                        end
                    end

                    if playergroup >= Config.PermGive then
                        if Config.GiveItem == true then
                            RageUI.Button("Give d'Item(s)",nil, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    ItemData = nil
                                    TriggerServerEvent("yazho:GetItem")
                                end
                            }, MenuItem)
                        end

                        if Config.GivePermis == true then

                            RageUI.List("Donner le", ActionAdmin.ActionPermis, ActionAdmin.ListeActionPermis, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le code de la route", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.CodeDeLaRoute)
                                        ShowNotification("Le code de la route vous a bien été give.")
                                    elseif Index == 2 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le PPA", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.PPA)
                                        ShowNotification("Le PPA vous a bien été give.")
                                    elseif Index == 3 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le Permis de condurie", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.Drive)
                                        ShowNotification("Le permis voiture vous a bien été give.")
                                    elseif Index == 4 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le permis camion", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.Truck)
                                        ShowNotification("Le permis camion vous a bien été give.")
                                    elseif Index == 5 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le permis moto", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.Moto)
                                        ShowNotification("Le permis moto vous a bien été give.")
                                    elseif Index == 6 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le permis bateau", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.Boat)
                                        ShowNotification("Le permis bateau vous a bien été give.")
                                    elseif Index == 7 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give le permis avion", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:addlicense', PlayerPedId(), Config.Plane)
                                        ShowNotification("Le permis avion vous a bien été give.")
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionPermis = Index;              
                            end)

                            RageUI.List("Retirer le", ActionAdmin.ActionPermis, ActionAdmin.ListeActionPermis, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le code de la route", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.CodeDeLaRoute)
                                        ShowNotification("Le code de la route vous a bien été supprimé.")
                                    elseif Index == 2 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le PPA", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.PPA)
                                        ShowNotification("Le PPA vous a bien été supprimé.")
                                    elseif Index == 3 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le permis voiture", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.Drive)
                                        ShowNotification("Le permis voiture vous a bien été supprimé.")
                                    elseif Index == 4 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le permis camion", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.Truck)
                                        ShowNotification("Le permis camion vous a bien été supprimé.")
                                    elseif Index == 5 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le permis moto", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.Moto)
                                        ShowNotification("Le permis moto vous a bien été supprimé.")
                                    elseif Index == 6 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le permis bateau", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.Boat)
                                        ShowNotification("Le permis bateau vous a bien été supprimé.")
                                    elseif Index == 7 then
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est supprimé le permis avion", Config.Logs.ActionPersonnel)
                                        TriggerServerEvent('yazho:suplicense', PlayerPedId(), Config.Plane)
                                        ShowNotification("Le permis avion vous a bien été supprimé.")
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionPermis = Index;              
                            end)
                        end

                        if Config.GiveArgent == true then
                            RageUI.List("Donner du", ActionAdmin.ActionArgent, ActionAdmin.ListeActionArgent, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local givecash = KeyboardInput("Combien ? ", "", 25)
                                        TriggerServerEvent("yazho:givecash", givecash)
                                        ShowNotification(givecash.."$ ajouté dans votre portefeuille.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give **"..givecash.."** en cash", Config.Logs.ActionPersonnel)
                                    elseif Index == 2 then
                                        local amount = KeyboardInput("Somme", "", 25)

                                        if amount ~= nil then
                                            amount = tonumber(amount)
                                            
                                            if type(amount) == 'number' then
                                                TriggerServerEvent('yazho:givebank', amount)
                                                ShowNotification(amount.."$ ajouté sur votre compte en banque.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give **"..amount.."** en banque", Config.Logs.ActionPersonnel)
                                            end
                                        end
                                    elseif Index == 3 then
                                        local amountBlack = KeyboardInput("Somme", "", 25)

                                        if amountBlack ~= nil then
                                            amountBlack = tonumber(amountBlack)
                                            
                                            if type(amountBlack) == 'number' then
                                                TriggerServerEvent('yazho:giveblack', amountBlack)
                                                ShowNotification(amountBlack.."$ d'argent sale give.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est give **"..amountBlack.."** en argent sale", Config.Logs.ActionPersonnel)
                                            end
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionArgent = Index;              
                            end)

                            RageUI.List("Retirer du", ActionAdmin.ActionArgent, ActionAdmin.ListeActionArgent, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local retraitcash = KeyboardInput("Combien ? ", "", 25)
                                        TriggerServerEvent("yazho:retraitcash", retraitcash)
                                        ShowNotification(retraitcash.."$ retiré de votre portefeuille.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est retiré **"..retraitcash.."** en cash", Config.Logs.ActionPersonnel)
                                    elseif Index == 2 then
                                        local amount = KeyboardInput("Somme", "", 25)

                                        if amount ~= nil then
                                            amount = tonumber(amount)
                                            
                                            if type(amount) == 'number' then
                                                TriggerServerEvent('yazho:retraitbank', amount)
                                                ShowNotification(amount.."$ retiré de votre compte en banque.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est retiré **"..amount.."** en banque", Config.Logs.ActionPersonnel)
                                            end
                                        end
                                    elseif Index == 3 then
                                        local amountBlack = KeyboardInput("Somme", "", 25)

                                        if amountBlack ~= nil then
                                            amountBlack = tonumber(amountBlack)
                                            
                                            if type(amountBlack) == 'number' then
                                                TriggerServerEvent('yazho:retraitblack', amountBlack)
                                                ShowNotification(amountBlack.."$ d'argent sale retiré.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est retiré **"..amountBlack.."** en argent sale", Config.Logs.ActionPersonnel)
                                            end
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionArgent = Index;              
                            end)
                        end
                    end

                    if Config.MenuPed == true then
                        if playergroup >= Config.PermMenuPed then
                            RageUI.Separator("Apparence")
                            RageUI.Button("Changer d'Apparence", nil, {RightLabel = "→→"},true, {}, MenuPed)
                        end
                    end

                    if Config.Vision == true then
                        if playergroup >= Config.PermVision then
                            RageUI.Separator("Autres")
                            RageUI.Button("Gestion Visions", nil, {RightLabel = "→→"},true, {}, Viosionas)
                        end
                    end

                    if Config.Super == true then
                        if playergroup >= Config.PermSuper then
                            RageUI.Checkbox("SuperJump",nil, superjump,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    superjump = Checked
            
                                    if Checked then
                                        superJumpactive = true
                                    else
                                        superJumpactive = false
                                    end
                                end
                            end)

                            RageUI.Checkbox("SuperSprint",nil, supersprint,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    supersprint = Checked
            
                                    if Checked then
                                        superSprintactive = true
                                        vitessesprint = 2.50
                                    else
                                        superSprintactive = false
                                        vitessesprint = 1.00
                                    end
                                end
                            end)

                            RageUI.Checkbox("SuperNage",nil, supernage,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    supernage = Checked
            
                                    if Checked then
                                        SetSwimMultiplierForPlayer(PlayerId(), 2.49)
                                    else
                                        SetSwimMultiplierForPlayer(PlayerId(), 1.0)
                                    end
                                end
                            end)
                        end
                    end

                    if Config.Drift == true then
                        if playergroup >= Config.PermDrift then
                            RageUI.Checkbox("Mode Drift",nil, driftmode,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    driftmode = Checked
            
                                    if Checked then
                                        driftmodeactive = true
                                    else
                                        driftmodeactive = false
                                    end
                                end
                            end)
                        end
                    end

                    if Config.DelGun == true then
                        if playergroup >= Config.PermDelGun then
                            RageUI.Checkbox("DelGun",nil, delgun,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    delgun = Checked
            
                                    if Checked then
                                        dogtoggle = true
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a activé le Del Gun", Config.Logs.ActionPersonnel)
                                        RageUI.CloseAll()
                                    else
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a désactivé le Del Gun", Config.Logs.ActionPersonnel)
                                        dogtoggle = false
                                    end
                                end
                            end)
                        end
                    end
            
                end, function()
                end)

                RageUI.IsVisible(MenuItem, true, true, true, function()
                    RageUI.Info("Recherche en fonction du label donc en anglais", {nil}, {nil})
                    RageUI.List("Filtre :", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
    
                    if ItemData == nil then
                        RageUI.Separator("")
    
                    else
                        RageUI.Line()
                        for index,cj in pairs(ItemData) do
                            if starts(cj.name:lower(), filterArray[filter]:lower()) then
                                RageUI.Button("- "..cj.label, nil, {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = "→→" }, true, {
                                    onSelected = function()
                                        local quantity = KeyboardInput("Quantité", "", 5)
                                        local nameItem = cj.name
                                        if quantity == nil then
                                            ShowNotification("Quantité incorrecte.")
                                        else
                                            TriggerServerEvent("yazho:GiveItem", nameItem, quantity)
                                        end
                                    end
                                })
                            end
                        end
                        
                    end
            
                end, function()
                end)

                RageUI.IsVisible(MenuPed, true, true, true, function()
                    RageUI.Button("Remettre son Skin",nil, {RightLabel = "→"}, true, {
                        onSelected = function()   
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                local isMale = skin.sex == 0        
                                TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                    TriggerEvent('esx:restoreLoadout')
                                end)
                            end)
                        end)
                        end
                    })
            
                    RageUI.Line()
                    RageUI.Button("Changer d'Apparence",nil, {RightLabel = "→"}, true, {
                        onSelected = function()   
                            ExecuteCommand("skin")
                            RageUI.CloseAll()
                        end
                    })
                    for k,v in pairs(menu.menuped.menuped) do
                        if v.separator ~= nil then 
                            RageUI.Separator(v.separator)
                        else
                            RageUI.Button(v.minidesc, v.description, {RightLabel = v.touche}, true, {
                            onSelected = function()
                            local j1 = PlayerId()
                            local p1 = GetHashKey(v.ped)
                            RequestModel(p1)
                            while not HasModelLoaded(p1) do
                                Wait(500)
                                end
                                Wait(200)
                                SetPlayerModel(j1, p1)
                                SetModelAsNoLongerNeeded(p1)
                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a changé d'apparence pour être en **"..v.ped.."**", Config.Logs.ActionPersonnel)
                            end
                            })
                        end
                    end
            
                end, function()
                end)

                RageUI.IsVisible(Racc, true, true, true, function()
                    if Config.Teleportation == true then
                        if playergroup >= Config.PermTeleportation then
                            RageUI.List("Se Téléporter sur", ActionAdmin.ActionAdmin, ActionAdmin.ListeActionAdmin, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local WaypointHandle = GetFirstBlipInfoId(8)

                                        if DoesBlipExist(WaypointHandle) then
                                            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                                    
                                            for height = 1, 1000 do
                                                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                    
                                                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                    
                                                if foundGround then
                                                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                    
                                                    break
                                                end
                                    
                                                Citizen.Wait(0)
                                            end
                                            ShowNotification("Téléporté sur le marqueur.")
                                        else
                                            ShowNotification("Pas de marqueur sur la carte.")
                                        end
                                    elseif Index == 2 then
                                        SetPedCoordsKeepVehicle(PlayerPedId(), vector3(Config.Police.position))
                                    elseif Index == 3 then
                                        SetPedCoordsKeepVehicle(PlayerPedId(), vector3(Config.Strip.position))
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionAdmin = Index;              
                            end)
                        end
                        if Config.SpawnCar == true then
                            if playergroup >= Config.PermSpawnCar then
                                RageUI.List("Apparitions Rapides", ActionAdmin.SpwanCarMySelf, ActionAdmin.ListeSpwanCarMySelf, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                    if (Selected) then 
                                        if Index == 1 then
                                            ExecuteCommand("dv")
                                            ExecuteCommand("car sultan")
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                                SetVehicleDirtLevel(plyVeh, 0.0)
                                        elseif Index == 2 then
                                            ExecuteCommand("dv")
                                            ExecuteCommand("car bf400")
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                                SetVehicleDirtLevel(plyVeh, 0.0)
                                        elseif Index == 3 then
                                            ExecuteCommand("dv")
                                            ExecuteCommand("car bmx")
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                                SetVehicleDirtLevel(plyVeh, 0.0)
                                        end
                                        cooldowncool(500)
                                    end
                                    ActionAdmin.ListeSpwanCarMySelf = Index;              
                                end)
                            end
                        end
                    end
                end, function()
                end)

                RageUI.IsVisible(Armas, true, true, true, function()
                    for k,v in pairs(armes.arme.arme) do
                        if v.separator ~= nil then 
                            RageUI.Separator(v.separator)
                        else
                    RageUI.Button(v.nom,nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ExecuteCommand('giveweapon '..GetPlayerServerId(PlayerId())..' '..v.arme..' 99999999') 
                        end
                    })
                end
            end
                end, function()
                end)

                RageUI.IsVisible(Viosionas, true, true, true, function()
                    RageUI.Checkbox("Vision Nocturne",nil, nightvision,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            nightvision = Checked
    
                            if Checked then
                                SetNightvision(true)
                            else
                                SetNightvision(false)
                            end
                        end
                    end)
                    RageUI.Checkbox("Vision Thermique",nil, thermalvision,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            thermalvision = Checked
    
                            if Checked then
                                SetSeethrough(true)
                            else
                                SetSeethrough(false)
                            end
                        end
                    end)
                    RageUI.Checkbox("Vision Underwater",nil, underwatervision,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            underwatervision = Checked
    
                            if Checked then
                                SetTimecycleModifier("underwater")
                            else
                                ClearTimecycleModifier()
                            end
                        end
                    end)
                    RageUI.Checkbox("Vision de Drogue",nil, droguevision,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            droguevision = Checked
    
                            if Checked then
                                SetTimecycleModifier("DRUG_gas_huffin")
                            else
                                ClearTimecycleModifier()
                            end
                        end
                    end)
                end, function()
                end)

                RageUI.IsVisible(GestionJoueur, true, true, true, function()
                    ServerIDSess = true
                    RageUI.Button("Rechercher un (ID)",nil,{RightLabel = "→"},true, {
                        onSelected = function()
                            filterid = KeyboardInput('Entrez un (ID) :', "", 25)
                            if filterid == "" then
                                ShowNotification("Merci d'indiquer une valeur.")
                            else
                                if filterid == nil then

                                    ShowNotification("Merci d'indiquer une valeur.")
                               
                                else
                                  ShowNotification("Recherche effectuée.")
                                end
                            end
                        end
                   })
                   RageUI.Button("Rechercher un [NOM]",nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        filtername = KeyboardInput('Entrez le nom d\'un joueur', "", 25)
                        if filtername == "" then
                            ShowNotification("Merci d'indiquer une valeur.")
                        else
                            if filtername == nil then
                              ShowNotification("Merci d'indiquer une valeur.")
                           
                            else
                              ShowNotification("Recherche effectuée.")
                            end
                        end
                    end
                })
                RageUI.Line()
                for k,v in ipairs(ServersIdSession) do
                    if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
                    if filterid == nil or string.find(v,filterid) then
                    if filtername == nil or string.find(GetPlayerName(GetPlayerFromServerId(v)), filtername) then    
                            RageUI.ButtonWithStyle("("..v.. ") - "..GetPlayerName(GetPlayerFromServerId(v)),nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                                if Selected then
                                    IdSelected = v
                                end
                            end, GestionJoueur2)
                        end
                    end
                end
                if filterid or filtername then
                    RageUI.Button("Annuler la Recherche" , false, {}, true, {
                        onSelected = function()
                            filterid = nil
                            filtername = nil
                        end
                    })
                end
            end, function()
            end)

                RageUI.IsVisible(GestionJoueur2, true, true, true, function()
                RageUI.Info("Information de l'ID : ("..IdSelected..")", {"Steam :", "ID :"}, {""..GetPlayerName(GetPlayerFromServerId(IdSelected)).."", ""..tostring(IdSelected)})
                    if Config.TPJoueur == true then
                        if playergroup >= Config.PermTPJoueur then
                            RageUI.Separator("Téléportations")
                            RageUI.Button("Se TP au Joueur",nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
                                    ShowNotification("Téléportation à l'[ID] : "..IdSelected.." réussi.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." s'est TP à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            })

                            RageUI.Button("Bring le Joueur",nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local coordsID = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected)))
                                    TriggerServerEvent("adminmenu:bring", IdSelected, GetEntityCoords(PlayerPedId()), coordsID)
                                    ShowNotification("Téléportation de l'[ID] : "..IdSelected.." réussi.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à  TP l'id "..IdSelected.." à lui", Config.Logs.GestionJoueur)
                                    joueurTP = true
                                end
                            })

                            if joueurTP == true then
                                RageUI.Button("TP-Back le Joueur",nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("adminmenu:bringback", IdSelected, GetEntityCoords(PlayerPedId()))
                                        ShowNotification("Téléportation de l'[ID] : "..IdSelected.." réussi.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à re-téléporté l'id "..IdSelected.." à son ancienne position", Config.Logs.GestionJoueur)
                                        joueurTP = false
                                    end
                                })
                            end

                            RageUI.List("TP le Joueur à", ActionAdmin.ActionTeleportation, ActionAdmin.ListeActionTeleportation, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local coords = vector3(Config.Police.position)
                                        TriggerServerEvent("adminmenu:tpendroit", IdSelected, coords)
                                        ShowNotification("Téléportation de l'[ID] : "..IdSelected.." réussi.")
                                    elseif Index == 2 then
                                        local coords = vector3(Config.Strip.position)
                                        TriggerServerEvent("adminmenu:tpendroit", IdSelected, coords)
                                        ShowNotification("Téléportation de l'[ID] : "..IdSelected.." réussi.")
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionTeleportation = Index;              
                            end)
                        end
                    end

                    

                    if Config.Revive == true then
                        if playergroup >= Config.PermRevive then
                            RageUI.Separator("Immunité(s)")
                            RageUI.Button("Heal le Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    target = IdSelected
                                    TriggerEvent('esx_status:healPlayer', target)
                                    ShowNotification("Heal de l'[ID] : "..IdSelected.." réussi.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à heal l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            })

                            RageUI.Button("Revive le Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand(Config.CommandRevive.." "..IdSelected.."")
                                    ShowNotification("Revive de l'[ID] : "..IdSelected.." réussi.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à revive l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            })
                        end
                    end
                    if Config.GPBJoueur == true then
                        if playergroup >= Config.PermGPBJoueur then
                            RageUI.Checkbox("Protection PB sur le Joueur",nil, parballe,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    parballe = Checked
            
                                    if Checked then
                                        local armour = 100
                                        TriggerServerEvent("yazho:setgpb", IdSelected, armour)
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à ajouté un GPB à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    else
                                        local armour = 0
                                        TriggerServerEvent("yazho:setgpb", IdSelected, armour)
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à retiré un GPB à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    end
                                end
                            end)
                        end
                    end

                    if Config.Freeze == true then
                        if playergroup >= Config.PermFreeze then
                            RageUI.Separator("Administrations")
                            RageUI.Checkbox("Freeze le Joueur",nil, freeze,{},function(Hovered,Ative,Selected,Checked)
                                if Selected then
                                    freeze = Checked
            
                                    if Checked then
                                        local active = true
                                        TriggerServerEvent("yazho:freezJoueur", IdSelected, active)
                                        ShowNotification("L'[ID] : "..IdSelected.." est freeze.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à freeze l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    else
                                        local active = false
                                        TriggerServerEvent("yazho:freezJoueur", IdSelected, active)
                                        ShowNotification("L'[ID] : "..IdSelected.." n'est plus freeze.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à unfreeze l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    end
                                end
                            end)
                        end
                    end

                    if Config.SendMessage == true then
                        if playergroup >= Config.PermSendMessage then
                            RageUI.Button("Envoyer un Message au Joueur",nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local sendmessagejoueur = KeyboardInput("Entrez le contenu du message.", "", 99)
                                    TriggerServerEvent('yazho:SendMessage', IdSelected, sendmessagejoueur)
                                    ShowNotification("Message envoyé à l'[ID] : "..IdSelected..".")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à envoyé un message l'id "..IdSelected.." : **"..sendmessagejoueur.."**", Config.Logs.GestionJoueur)
                                end
                            })
                        end
                    end

                    if Config.OpenInventaire == true then
                        if playergroup >= Config.PermOpenInventaire then
                            RageUI.Button("Voir l'Inventaire du Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    getPlayerInv(IdSelected)
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." regarde l'inventaire de l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            }, MenuInv)
                        end
                    end

                    if Config.Spectate == true then
                        if playergroup >= Config.PermSpectate then
                            local coordsjoueur = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected)))
                            local posplayer = GetEntityCoords(PlayerPedId())

                            RageUI.Button("Spectate le Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    spectate = true
                                    local playerId = GetPlayerFromServerId(IdSelected)
                                    SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." spec l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            })
                        end
                    end

                    if Config.License == true then
                        if playergroup >= Config.PermLicense then
                            RageUI.Button("Obtenir les Licenses du Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local namesteam = GetPlayerName(GetPlayerFromServerId(IdSelected))
                                    TriggerServerEvent("yazho:GetLicenseSteam", IdSelected, namesteam)
                                    ShowNotification("La license steam a été envoyé sur Discord.")
                                end
                            })
                        end
                    end

                    if Config.PositionGPS == true then
                        if playergroup >= Config.PermGPS then
                            RageUI.Button("Obtenir la Localisation du Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local positionJoueur = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected)))
                                    SetNewWaypoint(positionJoueur)
                                    ShowNotification("Position trouvée.")
                                end
                            })
                        end
                    end

                    if playergroup >= Config.PermGiveJoueur then
                        if Config.GiveItemJoueur == true then
                            RageUI.Separator("Don(s)")
                            RageUI.Button("Donner Item(s) au Joueur",nil, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    ItemData = nil
                                    TriggerServerEvent("yazho:GetItem")
                                end
                            }, MenuItemJoueur)
                        end

                        if Config.GivePermisJoueur == true then
                            RageUI.List("Donner le", ActionAdmin.ActionPermis, ActionAdmin.ListeActionPermis, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.CodeDeLaRoute)
                                        ShowNotification("Le code de la route a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le code de la route à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 2 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.PPA)
                                        ShowNotification("Le PPA a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le PPA à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 3 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.Drive)
                                        ShowNotification("Le permis voiture a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le permis voiture à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 4 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.Truck)
                                        ShowNotification("Le permis camion a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le permis camion à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 5 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.Moto)
                                        ShowNotification("Le permis moto a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le permis moto à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 6 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.Boat)
                                        ShowNotification("Le permis bateau a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le permis bateau à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 7 then
                                        TriggerServerEvent('yazho:addlicense', IdSelected, Config.Plane)
                                        ShowNotification("Le permis avion a bien été give à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give le permis avion à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionPermis = Index;              
                            end)

                            RageUI.List("Retirer le", ActionAdmin.ActionPermis, ActionAdmin.ListeActionPermis, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "dmv")
                                        ShowNotification("Le code de la route a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le code de la route à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 2 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "ppa")
                                        ShowNotification("Le PPA a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le PPA à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 3 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "drive")
                                        ShowNotification("Le permis voiture a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le permis voiture à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 4 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "truck")
                                        ShowNotification("Le permis camion a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le permis camion à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 5 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "moto")
                                        ShowNotification("Le permis moto a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le permis moto à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 6 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "boat")
                                        ShowNotification("Le permis bateau a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le permis bateau à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 7 then
                                        TriggerServerEvent('yazho:suplicense', IdSelected, "plane")
                                        ShowNotification("Le permis avion a bien été supprimé à l'id "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé le permis avion à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionPermis = Index;              
                            end)
                        end

                        if Config.GiveArgentJoueur == true then
                            RageUI.List("Donner du", ActionAdmin.ActionArgent, ActionAdmin.ListeActionArgent, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local givecash2 = KeyboardInput("Combien ? ", "", 25)
                                        TriggerServerEvent("yazho:givecash2", givecash2, IdSelected)
                                        ShowNotification(givecash2.."$ ajouté au portefeuille de l'ID "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give "..givecash2.." en cash à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 2 then
                                        local amount = KeyboardInput("Somme", "", 25)

                                        if amount ~= nil then
                                            amount = tonumber(amount)
                                            
                                            if type(amount) == 'number' then
                                                TriggerServerEvent('yazho:givebank2', amount, IdSelected)
                                                ShowNotification(amount.."$ ajouté sur le compte de l'ID "..IdSelected..".")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give "..amount.." en banque à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                            end
                                        end
                                    elseif Index == 3 then
                                        local amountBlack = KeyboardInput("Somme", "", 25)

                                        if amountBlack ~= nil then
                                            amountBlack = tonumber(amountBlack)
                                            
                                            if type(amountBlack) == 'number' then
                                                TriggerServerEvent('yazho:giveblack2', amountBlack, IdSelected)
                                                ShowNotification(amountBlack.."$ d'argent sale give.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à give "..amountBlack.." en argent sale à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                            end
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionArgent = Index;              
                            end)

                            RageUI.List("Retirer du", ActionAdmin.ActionArgent, ActionAdmin.ListeActionArgent, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local retraitcash2 = KeyboardInput("Combien ? ", "", 25)
                                        TriggerServerEvent("yazho:retraitcash2", retraitcash2, IdSelected)
                                        ShowNotification(retraitcash2.."$ retiré du portefeuille de l'ID "..IdSelected..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé "..retraitcash2.." en cash à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                    elseif Index == 2 then
                                        local amount = KeyboardInput("Somme", "", 25)

                                        if amount ~= nil then
                                            amount = tonumber(amount)
                                            
                                            if type(amount) == 'number' then
                                                TriggerServerEvent('yazho:removebank2', amount, IdSelected)
                                                ShowNotification(amount.."$ retiré du compte de l'ID "..IdSelected..".")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé "..amount.." en banque à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                            end
                                        end
                                    elseif Index == 3 then
                                        local amountBlack = KeyboardInput("Somme", "", 25)

                                        if amountBlack ~= nil then
                                            amountBlack = tonumber(amountBlack)
                                            
                                            if type(amountBlack) == 'number' then
                                                TriggerServerEvent('yazho:retraitblack2', amountBlack, IdSelected)
                                                ShowNotification(amountBlack.."$ d'argent sale retiré.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." à supprimé "..amountBlack.." en argent sale à l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                            end
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionArgent = Index;              
                            end)
                        end
                    end

                    if Config.SetJob == true then
                        if playergroup >= Config.PermSetJob then
                            RageUI.Button("SetJob le Joueur", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local job = KeyboardInput("Choississez le Job (label)", "", 99)
                                    local grade = KeyboardInput("Choisissez le Grade.", "", 1)
                                    ExecuteCommand("setjob "..IdSelected.." "..job.." "..grade)
                                end
                            })
                        end
                    end

                    if Config.Sanctions == true then
                        if playergroup >= Config.PermSanctions then
                            RageUI.Separator("~r~Sanctions")
                            RageUI.Button("Voir les Sanctions du Joueur", nil, {RightLabel = "→→"}, true, {
                                onSelected = function()
                                    if Config.SystemeBan == true then
                                        GetBanJoueur()
                                    end
                                    if Config.SystemeKick == true then
                                        GetKickJoueur()
                                    end
                                    if Config.SystemeWarn == true then
                                        GetWarnJoueur()
                                    end
                                end
                            }, MenuGestionSanction)
                        end
                    end

                    if Config.SystemeWype == true then
                        if playergroup >= Config.PermWype then
                            RageUI.Button("Wype le Joueur" , nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("yazho:WypePlayer", IdSelected)
                                end
                            })
                        end
                    end
                    
                    if Config.SystemeWarn == true then
                        if playergroup >= Config.PermWarn then
                            RageUI.Button("Warn le Joueur" , nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local messagedewarnjoueur = KeyboardInput("Message de warn (ECHAP POUR ANNULER)", "", 25)
                                    if messagedewarnjoueur ~= nil then
                                        messagedewarnjoueur = tostring(messagedewarnjoueur)
                                        if type(messagedewarnjoueur) == 'string' then
                                            local namekiker = GetPlayerName(PlayerId())
                                            local nameplayer = GetPlayerName(GetPlayerFromServerId(IdSelected))
                                            TriggerServerEvent("yazho:warn", IdSelected, messagedewarnjoueur, namekiker, nameplayer)
                                            ShowNotification("L'id "..IdSelected.." a été warn pour : "..messagedewarnjoueur..".")
                                        end
                                    end
                                end
                            })
                        end
                    end

                    if Config.SystemeKick == true then
                        if playergroup >= Config.PermKick then
                            RageUI.Button("Kick le Joueur" , nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local messagedekickjoueur = KeyboardInput("Message de kick (ECHAP POUR ANNULER)", "", 25)
                                    if messagedekickjoueur ~= nil then
                                        messagedekickjoueur = tostring(messagedekickjoueur)
                                        if type(messagedekickjoueur) == 'string' then
                                            local namekiker = GetPlayerName(PlayerId())
                                            local nameplayer = GetPlayerName(GetPlayerFromServerId(IdSelected))
                                            TriggerServerEvent("yazho:kick", IdSelected, messagedekickjoueur, namekiker, nameplayer)
                                            ShowNotification("L'id "..IdSelected.." a été kick pour : "..messagedekickjoueur..".")
                                        end
                                    end
                                end
                            })
                        end
                    end

                    if Config.SystemeBan == true then
                        if playergroup >= Config.PermBan then
                            RageUI.Button("Ban le Joueur" , nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local namestaff = GetPlayerName(PlayerId())
                                    local idstaff = GetPlayerServerId(PlayerId())
                                    local nombrejour = KeyboardInput("Nombre de jour de Ban (ECHAP POUR ANNULER)", "", 25)
                                    local raisonban = KeyboardInput("Raison du Ban (ECHAP POUR ANNULER)", "", 99)
                                    if nombrejour == nil then
                                        ShowNotification("Veuillez indiquer une valeur.")
                                    elseif raisonban == nil then
                                        ShowNotification("Veuillez indiquer une valeur.")
                                    else
                                        TriggerServerEvent("yazho:ban", source, IdSelected, nombrejour, raisonban, namestaff, idstaff)
                                    end
                                end
                            })
                        end
                    end

                    if playergroup >= Config.PermAddStaff then
                        RageUI.Line()
                        RageUI.Button("Ajouter le Joueur dans le Staff", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                GetGrades()
                                AddStaffJoueur.name = GetPlayerName(GetPlayerFromServerId(IdSelected))
                                AddStaffJoueur.grade_name = "Aucun"
                                AddStaffJoueur.grade = "Aucun"
                                AddStaffJoueur.idstaff = tostring(IdSelected)
                            end
                        }, AddStaffJoueur)
                    end
                    
            
                end, function()
                end)

                RageUI.IsVisible(MenuInv, true, true, true, function()
                    if Config.VoirItem == true then
                        RageUI.Separator('ITEM(S)')

                        for k,v  in pairs(Items) do
                            RageUI.Button(v.label, nil, {RightLabel = "x"..v.right}, true, {})
                        end
                    end

                    if Config.VoirArme == true then
                        RageUI.Line()
                        RageUI.Separator('ARME(S)')

                        for k,v  in pairs(Armes) do
                            RageUI.Button(v.label, nil, {RightLabel = "x"..v.right.." balle(s)"}, true, {})
                        end
                    end

                    if playergroup >= Config.PermClearInventaire then
                        RageUI.Line()

                        if Config.ViderInventaire == true then
                            RageUI.Button("Vider l'inventaire", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand(Config.CommandClearInventory.." "..IdSelected.."")
                                    ShowNotification("Inventaire vidé.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a vidé l'inventaire de l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            })
                        end

                        if Config.ViderArme == true then
                            RageUI.Button("Vider les armes", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand(Config.CommandClearLoadout.." "..IdSelected.."")
                                    ShowNotification("Inventaire retiré.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a vidé vidé les armes de l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                end
                            })
                        end
                    end
                end, function()
                end)

                RageUI.IsVisible(MenuItemJoueur, true, true, true, function()
                    RageUI.Info("Recherche en fonction du label donc en anglais", {nil}, {nil})
                    RageUI.List("Filtre :", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
    
                    if ItemData == nil then
                        RageUI.Separator("")
    
                    else
                        RageUI.Line()
                        for index,cj in pairs(ItemData) do
                            if starts(cj.name:lower(), filterArray[filter]:lower()) then
                                RageUI.Button("- "..cj.label, nil, {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = "→" }, true, {
                                    onSelected = function()
                                        local quantity = KeyboardInput("Quantité", "", 5)
                                        local nameItem = cj.name
                                        if quantity == nil then
                                            ShowNotification("Quantité incorrecte.")
                                        else
                                            TriggerServerEvent("yazho:GiveItemJoueur", IdSelected, nameItem, quantity)
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a give x"..quantity.." "..nameItem.." l'id "..IdSelected.."", Config.Logs.GestionJoueur)
                                        end
                                    end
                                })
                            end
                        end
                        
                    end
            
                end, function()
                end)

                RageUI.IsVisible(MenuGestionSanction, true, true, true, function()
                    RageUI.List("Sujer du Report", ActionAdmin.ActionGestionSanctions, ActionAdmin.ListeActionGestionSanctions, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                            local player = IdSelected
                                Warn = true
                                Kick = false
                                Ban = false
                            elseif Index == 2 then
                                Warn = false
                                Kick = true
                                Ban = false
                            elseif Index == 3 then
                                Warn = false
                                Kick = false
                                Ban = true
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionGestionSanctions = Index;              
                    end)

                    if Warn then
                        if Config.SystemeWarn == true then
                            RageUI.Line()

                            for i = 1, #listewarnJoueur, 1 do
                                local author = listewarnJoueur[i].author
                                local date = listewarnJoueur[i].date
                                local steam = listewarnJoueur[i].steam
                                local reason = listewarnJoueur[i].reason
                                local staff = listewarnJoueur[i].staff
                                local id = listewarnJoueur[i].id

                                RageUI.ButtonWithStyle(date, "Appuyez [ENTREE] pour supprimer le warn", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
                                    if (Active) then
                                        RageUI.Info("Information du warn du : "..date.."", {"Auteur du warn :","Date :", "Raison du warn :", ""..reason..""}, {""..staff.."",""..date.."", "↓", ""})
                                    end
                                    if Selected then
                                        if playergroup >= Config.PermDeleteWarn then
                                            TriggerServerEvent("yazho:DeleteWarn", id)
                                            ShowNotification("Le warn est bien supprimé.")
                                            RageUI.CloseAll()
                                        else
                                            ShowNotification("Vous n'avez pas la permission de faire cette action.")
                                        end
                                    end
                                end)
                            end
                        else
                            RageUI.Separator("Les warns ne sont pas activés...")
                        end

                    elseif Kick then
                        if Config.SystemeKick == true then
                            RageUI.Line()

                            for i = 1, #listekickJoueur, 1 do
                                local author = listekickJoueur[i].author
                                local date = listekickJoueur[i].date
                                local steam = listekickJoueur[i].steam
                                local reason = listekickJoueur[i].reason
                                local staff = listekickJoueur[i].staff
                                local id = listekickJoueur[i].id

                                RageUI.ButtonWithStyle(date, "Appuyez [ENTREE] pour supprimer le kick", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
                                    if (Active) then
                                        RageUI.Info("Information du kick du : "..date.."", {"Auteur du kick :","Date :", "Raison du kick :", ""..reason..""}, {""..staff.."",""..date.."", "↓", ""})
                                    end
                                    if Selected then
                                        if playergroup >= Config.PermDeleteKick then
                                            TriggerServerEvent("yazho:DeleteKick", id)
                                            ShowNotification("Le kick est bien supprimé.")
                                            RageUI.CloseAll()
                                        else
                                            ShowNotification("Vous n'avez pas la permission de faire cette action.")
                                        end
                                    end
                                end)
                                
                            end
                        else
                            RageUI.Separator("Les kicks ne sont pas activés...")
                        end

                    elseif Ban then
                        if Config.SystemeBan == true then
                            RageUI.Line()

                            for i = 1, #listebanJoueur, 1 do
                                local license = listebanJoueur[i].license
                                local identifier = listebanJoueur[i].identifier
                                local liveid = listebanJoueur[i].liveid
                                local xblid = listebanJoueur[i].xblid
                                local discord = listebanJoueur[i].discord
                                local playerip = listebanJoueur[i].playerip
                                local targetplayername = listebanJoueur[i].targetplayername
                                local sourceplayername = listebanJoueur[i].sourceplayername
                                local reason = listebanJoueur[i].reason
                                local timeat = listebanJoueur[i].timeat
                                local added = listebanJoueur[i].added
                                local expiration = listebanJoueur[i].expiration
                                local tempsban = listebanJoueur[i].tempsban

                                RageUI.ButtonWithStyle(added, "Appuyez [ENTREE] pour supprimer le ban", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
                                    if (Active) then
                                        RageUI.Info("Information du ban du : "..added.."", {"Auteur du ban :", "Joueur Ban :", "Raison :", ""..reason.."", "Date du ban :", "Date du déban :", "Steam :", "Discord :"}, {""..sourceplayername.."", ""..targetplayername.."", "↓", "", ""..added.."", ""..tempsban.." jours", ""..identifier.."",""..discord..""})
                                    end
                                    if Selected then
                                        if playergroup >= Config.PermDeleteBan then
                                            TriggerServerEvent("yazho:DeleteBan", id)
                                            ShowNotification("Le ban est bien supprimé.")
                                            RageUI.CloseAll()
                                        else
                                            ShowNotification("Vous n'avez pas la permission de faire cette action.")
                                        end
                                    end
                                end)
                            end
                        else
                            RageUI.Separator("Les bans ne sont pas activés...")
                        end

                    else
                        RageUI.Separator("")
                        RageUI.Separator("SELECTIONNE UNE SANCTION")
                    end
            
                end, function()
                end)

                RageUI.IsVisible(Administration, true, true, true, function()
                    

                    if Config.Meteo == true then
                        if playergroup >= Config.PermMeteo then
                            RageUI.Button("Reset", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("weather clear")
                                end
                            })
                            RageUI.Line()
                            RageUI.Button("Définir une Heure", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local heure = KeyboardInput("Choisissez une Heure.", "", 99)
                                    local min = KeyboardInput("Choisissez les minutes.", "", 99)
                                    ExecuteCommand("time "..heure.." "..min)
                                end
                            })
                            RageUI.Button("Soleil", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("weather extrasunny")
                                end
                            })
                            RageUI.Button("Pluie", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("weather rain")
                                end
                            })
                            RageUI.Button("Matin (09:00)", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("morning")
                                end
                            })
                            RageUI.Button("Night (23:00)", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("night")
                                end
                            })
                            RageUI.Button("Halloween", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("weather halloween")
                                end
                            })
                            RageUI.Button("BlackOut", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("blackout")
                                end
                            })
                        end
                    end

        
                end, function()
                end)

                RageUI.IsVisible(GestionBanActif, true, true, true, function()
                    for i = 1, #listebanJoueurActif, 1 do
                        local id = listebanJoueurActif[i].id
                        local license = listebanJoueurActif[i].license
                        local identifier = listebanJoueurActif[i].identifier
                        local iveid = listebanJoueurActif[i].liveid
                        local xblid = listebanJoueurActif[i].xblid
                        local discord = listebanJoueurActif[i].discord
                        local playerip = listebanJoueurActif[i].playerip
                        local targetplayername = listebanJoueurActif[i].targetplayername
                        local sourceplayername = listebanJoueurActif[i].sourceplayername
                        local reason = listebanJoueurActif[i].reason
                        local timeat = listebanJoueurActif[i].timeat
                        local expiration = listebanJoueurActif[i].expiration
                        local added = listebanJoueurActif[i].added
                        local tempsban = listebanJoueurActif[i].tempsban

                        RageUI.ButtonWithStyle(targetplayername, "Appuyez [ENTREE] pour supprimer le ban", {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected)
                            if (Active) then
                                RageUI.Info("Information du ban de : "..targetplayername.."", {"Auteur du ban :", "Joueur Ban :", "Raison :", ""..reason.."", "Date du ban :", "Jour de ban :"}, {""..sourceplayername.."", ""..targetplayername.."", "↓", "", ""..added.."",""..tempsban.." jours"})
                            end
                            if Selected then
                                if playergroup >= Config.PermDeleteBanActif then
                                    TriggerServerEvent("yazho:DeleteBan2", id)
                                    ShowNotification("Le ban est bien supprimé.")
                                    RageUI.CloseAll()
                                else
                                    ShowNotification("Vous n'avez pas la permission de faire cette action.")
                                end
                            end
                        end)
                    end
            
                  end, function()    
                  end)

                  RageUI.IsVisible(GestionReport, true, true, true, function()

                    RageUI.List("Status", ActionAdmin.ActionStatusDesReport, ActionAdmin.ListeActionStatusDesReport, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                actif = true
                            elseif Index == 2 then
                                actif = false
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionStatusDesReport = Index;              
                    end)

                    RageUI.Line()

                    if actif == true then
                        for i = 1, #listereport, 1 do
                            local type = listereport[i].type
                            local author = listereport[i].author
                            local date = listereport[i].date
                            local steam = listereport[i].steam
                            local sujet = listereport[i].sujet
                            local desc = listereport[i].desc
                            local status = listereport[i].status
                            local staff = listereport[i].staff
                            local id = listereport[i].id
                            local idjoueur = listereport[i].idjoueur
                            
                            RageUI.List(sujet, ActionAdmin.ActionDesReport, ActionAdmin.ListeActionDesReport, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Active) then
                                    RageUI.Info("Report numéro "..id.."", {"Type :", "Auteur :", "ID :", "Sujet :", "Description :", ""..desc.."", "Date :", "Steam :", "Staff :", "Status :"}, {"~h~"..type.."~h~", ""..author.."", ""..idjoueur.."", ""..sujet.."", "↓", "", ""..date.."", ""..steam.."", ""..staff.."", "~g~"..status..""})
                                end
                                if (Selected) then 
                                    if Index == 1 then
                                        if playergroup >= Config.PermPrendreEnCharge then
                                            if staff == "Aucun" then
                                                local staffquibosse = GetPlayerName(PlayerId())
                                                TriggerServerEvent("yazho:PriseEnChargeReport", id, staffquibosse)
                                                ShowNotification("Vous venez de prendre en charge le report numéro "..id..".")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a prit en charge le report numéro "..id.."", Config.Logs.Divers)
                                                RageUI.CloseAll()
                                            else
                                                ShowNotification("Le report est déjà pris en charge par un staff.")
                                            end
                                        else
                                            ShowNotification("Vous n'avez pas la permission de faire cette action.")
                                        end
                                    elseif Index == 2 then
                                        if playergroup >= Config.PermTraiterReport then
                                            if staff == "Aucun" then
                                                ShowNotification("Impossible de faire cette action car aucun staff s'occuper de ce report.")
                                            else
                                                TriggerServerEvent("yazho:TraiterReport", id)
                                                ShowNotification("Vous venez de placer le report numéro "..id.." dans les reports traités.")
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a placé le report numéro "..id.." dans les reports traités", Config.Logs.Divers)
                                                RageUI.CloseAll()
                                            end
                                        else
                                            ShowNotification("Vous n'avez pas la permission de faire cette action.")
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionDesReport = Index;              
                            end) 
                            
                        end
                    else
                        for i = 1, #listereportTraite, 1 do
                            local type = listereportTraite[i].type
                            local author = listereportTraite[i].author
                            local date = listereportTraite[i].date
                            local steam = listereportTraite[i].steam
                            local sujet = listereportTraite[i].sujet
                            local desc = listereportTraite[i].desc
                            local status = listereportTraite[i].status
                            local staff = listereportTraite[i].staff
                            local id = listereportTraite[i].id
                            local idjoueur = listereportTraite[i].idjoueur
                            
                            RageUI.List(sujet, ActionAdmin.ActionDesReport2, ActionAdmin.ListeActionDesReport2, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Active) then
                                    RageUI.Info("Report numéro "..id.."", {"Type :", "Auteur :", "ID :", "Sujet :", "Description :", ""..desc.."", "Date :", "Steam :", "Staff :", "Status :"}, {"~h~"..type.."~h~", ""..author.."", ""..idjoueur.."", ""..sujet.."", "↓", "", ""..date.."", ""..steam.."", ""..staff.."", ""..status..""})
                                end
                                if (Selected) then 
                                    if Index == 1 then
                                        if playergroup >= Config.PermDeleteReport then
                                            TriggerServerEvent("yazho:DeleteReport", id)
                                            ShowNotification("Vous venez de supprimer le report numéro "..id..".")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a supprimé le report numéro "..id.."", Config.Logs.Divers)
                                            RageUI.CloseAll()
                                        else
                                            ShowNotification("Le report est déjà pris en charge par un staff.")
                                        end
                                    elseif Index == 2 then
                                        if playergroup >= Config.PermReouvrirReport then
                                            TriggerServerEvent("yazho:OuvertureReport", id)
                                            ShowNotification("Vous venez de placer le report numéro "..id.." dans les reports non traité.")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a placé le report numéro "..id.." dans les reports non traités", Config.Logs.Divers)
                                            RageUI.CloseAll()
                                        else
                                            ShowNotification("Le report est déjà pris en charge par un staff.")
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionDesReport2 = Index;              
                            end) 
                            
                        end
                    end
                end, function()
                end)

                RageUI.IsVisible(GestionDev, true, true, true, function()
                    RageUI.Separator("Globales")
                    RageUI.Button("Informations", nil, {RightLabel = "→"}, true, {},Infos)

                    if Config.KickAll == true then
                        if playergroup >= Config.PermKickAll then
                            RageUI.Button("Kick All", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local messagedekick = KeyboardInput("Entrez la raison du /kickall (ECHAP pour annuler)", "", 25)
                                    TriggerServerEvent("yazho:kickall", messagedekick)
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a kick tout le monde "..messagedekick.."", Config.Logs.Administration)
                                end
                            })
                        end
                    end

                    if Config.ReviveAll == true then
                        if playergroup >= Config.PermReviveAll then
                            RageUI.Button("Revive All", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand("reviveall")
                                end
                            })
                        end
                    end

                    if Config.SystemeBan == true then
                        if playergroup >= Config.PermBanActif then
                            RageUI.Button("Gestion Bans", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    GetBanActif()
                                end
                            }, GestionBanActif)
                        end
                    end

                    if Config.ClearChat == true then
                        if playergroup >= Config.PermClearChat then
                            RageUI.Button("Clear le Chat", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ExecuteCommand(Config.ClearAllCommand)
                                    ShowNotification("Chat réinitialisé avec succés.")
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a clear le chat", Config.Logs.Administration)
                                end
                            })
                        end
                    end
                    RageUI.Separator("Intéractions (EN JEU)")
                    if Config.Annonce == true then
                        if playergroup >= Config.PermAnnonce then
                            RageUI.Button("Faire une Annonce", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local petiteannonce = KeyboardInput("Entrez le contenu de votre annonce.", "", 99)
                                    TriggerServerEvent('Test:adminannonce', petiteannonce)
                                    TriggerServerEvent('yazho:annonce')
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a fais une annonce : "..petiteannonce.."", Config.Logs.Administration)
                                end
                            })
                        end
                    end
                    RageUI.Button("Gestion Météo", false, {RightLabel = "→→"}, true, {}, Administration)
                    if Config.Coords == true then
                        RageUI.Separator("Développement")
                        RageUI.Button("Obtenir les Coordonnées",nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local playerCoords = GetEntityCoords(PlayerPedId())
                                local x = string.sub(playerCoords.x, 0, 8) 
                                local y = string.sub(playerCoords.y, 0, 8)
                                local z = string.sub(playerCoords.z, 0, 6)
                                local handing = GetEntityHeading(PlayerPedId())
                                TriggerServerEvent('yazho:logsEvent', "*Coordonnée 1 :*\n x = " .. x .. ", y = ".. y ..", z = " .. z .."\n\n*Coordonnée 2 :*\n ".. x .. ", " .. y .. ", " .. z .."\n\n*Coordonnée 3 :*\n vector3(" .. x .. ", " .. y .. ", " .. z .. ") \n\n*Heading :* \n"..handing.."", Config.Logs.GestionDev)
                                ShowNotification("Coordonnées envoyées avec succès.")
                            end
                        })
                    end

                    if Config.NameStreet == true then
                        if playergroup >= Config.PermNameStreet then
                            RageUI.Button("Obtenir le Nom de la Rue",nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local playerCoords = GetEntityCoords(PlayerPedId())
                                    local StreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
                                    local Street = GetStreetNameFromHashKey(StreetHash)
                                    TriggerServerEvent('yazho:logsEvent', "**NOM DE RUE :**\n\n*"..Street.."*", Config.Logs.GestionDev)
                                    ShowNotification("Le nom de la rue a été envoyé sur discord.")
                                end
                            })
                        end
                    end

                    if Config.CreerMarker == true then
                        if playergroup >= Config.PermCreerMarker then
                            RageUI.Button("Créer un Marker",nil, {RightLabel = "→→"}, true, {}, MenuMarker)
                        end
                    end

                    if Config.CreerBlips == true then
                        if playergroup >= Config.PermCreerBlips then
                            RageUI.Button("Créer un Blips",nil, {RightLabel = "→→"}, true, {}, MenuBlips)
                        end
                    end

                    if Config.CreerItem == true then
                        if playergroup >= Config.PermCreerItem then
                            RageUI.Button("Créer un Item",nil, {RightLabel = "→→"}, true, {}, MenuCreateItem)
                        end
                    end

                    if Config.GestionRessource == true then
                        if playergroup >= Config.PermGestionRessource then
                            RageUI.Button("Gestion des Ressources",nil, {RightLabel = "→→"}, true, {}, MenuResource)
                        end
                    end
            
                end, function()
                end)

                RageUI.IsVisible(Infos, true, true, true, function()
                    RageUI.Separator('Steam : ('..GetPlayerName(PlayerId())..')')
                    RageUI.Separator('[ID] : ('..GetPlayerServerId(PlayerId())..')')
                    RageUI.Separator("("..#players..") Joueur(s) en ligne.")
                end, function()
                end)

                RageUI.IsVisible(GestionGrades, true, true, true, function()
                    RageUI.Button("Ajouter un Grade",nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            local grade_name = KeyboardInput('Indiquez le nom du grade (ex : Fondateur)', "", 25)
                            local grade = KeyboardInput('Indiquez le grade (ex : 5)', "", 25)
                            local idstaff = GetPlayerServerId(PlayerId())
                            if grade_name == nil then
                                ShowNotification("Veuillez indiquer une valeur.")
                            elseif grade == nil then
                                ShowNotification("Veuillez indiquer une valeur.")
                            else
                                TriggerServerEvent("yazho:AddGrade", grade_name, grade, idstaff)
                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a ajouté le grade : "..grade_name.." "..grade.."", Config.Logs.Divers)
                            end
                        end
                    })


                    RageUI.Line()

                        for i = 1, #listegradeJoueur, 1 do
                            local id = listegradeJoueur[i].id
                            local grade_name = listegradeJoueur[i].grade_name
                            local grade = listegradeJoueur[i].grade

                            RageUI.List(grade_name, ActionAdmin.ActionGestionGrade, ActionAdmin.ListeActionGestionGrade, "Grade : "..grade, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        TriggerServerEvent("yazho:deletegrade", id)
                                        ShowNotification("Le grade "..grade_name.." a correctement été supprimé.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a supprimé le grade "..grade_name.."", Config.Logs.Divers)
                                        RageUI.CloseAll()
                                    elseif Index == 2 then
                                        local grade_name2 = KeyboardInput('Indiquez le nom du grade (ex : Fondateur)', "", 25)
                                        if grade_name2 == nil then
                                            ShowNotification("Veuillez indiquer une valeur.")
                                        else
                                            TriggerServerEvent("yazho:ModifNameGrade", id, grade_name2)
                                            ShowNotification("Le grade "..grade_name.." a été modifié en ~b~"..grade_name2..".")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a modifié le grade "..grade_name.." en "..grade_name2.."", Config.Logs.Divers)
                                        end
                                    elseif Index == 3 then
                                        local grade2 = KeyboardInput('Indiquez le grade (ex : 5)', "", 25)
                                        if grade2 == nil then
                                            ShowNotification("Veuillez indiquer une valeur.")
                                        else
                                            TriggerServerEvent("yazho:ModifGrade", id, grade2)
                                            ShowNotification("Le grade "..grade.." a été modifié en "..grade2..".")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a modifié le grade "..grade.." en "..grade2.."", Config.Logs.Divers)
                                        end
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionGestionGrade = Index;              
                            end)
                            
                        end
            
                end, function()
                end)

                RageUI.IsVisible(GestionStaffs, true, true, true, function()
                        for i = 1, #listestaffJoueur, 1 do
                            local id = listestaffJoueur[i].id
                            local steam = listestaffJoueur[i].steam
                            local name = listestaffJoueur[i].name
                            local grade_name = listestaffJoueur[i].grade_name
                            local grade = listestaffJoueur[i].grade

                            RageUI.List(name, ActionAdmin.ActionGestionStaff, ActionAdmin.ListeActionGestionStaff, "Nom du staff : "..name.."~n~Grade : "..grade_name, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        TriggerServerEvent("yazho:deletestaff", id)
                                        ShowNotification(""..name.." a correctement été supprimé de l'équipe staff.")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a supprimé "..name.." du staff", Config.Logs.Divers)
                                        RageUI.CloseAll()
                                    elseif Index == 2 then
                                        RageUI.Button("Rechercher une ressource",nil, {RightLabel = "→"}, true, {
                                            onSelected = function()
                                                AddStaff.name = listestaffJoueur[i].name
                                                AddStaff.grade_name = listestaffJoueur[i].grade_name
                                                AddStaff.grade = listestaffJoueur[i].grade
                                                AddStaff.idstaff = listestaffJoueur[i].id
                                            end
                                        }, AddStaff)
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionGestionStaff = Index;              
                            end)
                            
                        end
            
                end, function()
                end)

                RageUI.IsVisible(AddStaffJoueur, true, true, true, function(name,grade_name, grade)
                        for i = 1, #listegradeJoueur, 1 do
                            local grade_name = listegradeJoueur[i].grade_name
                            local grade = listegradeJoueur[i].grade

                            local idstaff = AddStaffJoueur.idstaff
                            local namestaff = AddStaffJoueur.name

                            RageUI.Button(grade_name, "Information :~n~Nom du grade : "..grade_name.."~n~Grade : "..grade.."", {RightLabel = "~g~Ajouter"}, true, {
                                onSelected = function()
                                    ShowNotification(""..namestaff.." a bien été ajouté dans le staff.")
                                    TriggerServerEvent("yazho:AddStaff", idstaff, grade_name, grade, namestaff)
                                    TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a ajouté "..idstaff.." dans le staff", Config.Logs.Divers)
                                    RageUI.CloseAll()
                                end
                            })
                        end
            
                end, function()
                end)

                RageUI.IsVisible(AddStaff, true, true, true, function(name,grade_name, grade)
                        for i = 1, #listegradeJoueur, 1 do
                            local grade_name = listegradeJoueur[i].grade_name
                            local grade = listegradeJoueur[i].grade

                            local idstaff = AddStaff.idstaff

                            RageUI.Button(grade_name, "Information :~n~Nom du grade : "..grade_name.."~n~Grade : "..grade.."", {RightLabel = "~g~Ajouter"}, true, {
                                onSelected = function()
                                    ShowNotification("Grade changé.")
                                    TriggerServerEvent("yazho:ModifStaffGrade", idstaff, grade_name, grade)
                                end
                            })
                            
                        end
            
                end, function()
                end)

                RageUI.IsVisible(MenuResource, true, true, true, function()
                    RageUI.Separator('Nombre de Ressources Start : '..GetNumResources())
                    RageUI.Button("Rechercher une Ressource",nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            filterresource = KeyboardInput('Entrez le nom d\'une ressource', "", 25)
                            if filterresource == "" then
                                ShowNotification("Veuillez indiquer une valeur.")
                            else
                                if filterresource == nil then
                                  ShowNotification("Veuillez indiquer une valeur.")
                               
                                else
                                  ShowNotification("Vous avez cherché la ressource :~n~ "..filterresource..".")
                                end
                            end
                        end
                    })

                    RageUI.List("Status de la Ressource :", ActionAdmin.ActionResources, ActionAdmin.ListeActionResources, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                start = true
                            elseif Index == 2 then
                                start = false
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionResources = Index;              
                    end)

                    RageUI.Line()

                    local resourceList = {}

                    if start == true then
                        for i = 0, GetNumResources(), 1 do
                        
                        local resource_name = GetResourceByFindIndex(i)
                        
                        if resource_name then

                            if resource_name and GetResourceState(resource_name) == "started" then
                                if filterresource == nil or string.find(resource_name,filterresource) then
                                    etatResource = "~g~Start~s~"
                                    RageUI.List(resource_name, ActionAdmin.ActionDesResources, ActionAdmin.ListeActionDesResources, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                        if (Selected) then 
                                            if Index == 1 then
                                                TriggerServerEvent("yazho:startresource", resource_name)
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a start la ressource "..resource_name.."", Config.Logs.GestionDev)
                                                RageUI.CloseAll()
                                            elseif Index == 2 then
                                                TriggerServerEvent("yazho:restartresource", resource_name)
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a restart la ressource "..resource_name.."", Config.Logs.GestionDev)
                                                RageUI.CloseAll()
                                            elseif Index == 3 then
                                                TriggerServerEvent("yazho:stopresource", resource_name)
                                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a stop la ressource "..resource_name.."", Config.Logs.GestionDev)
                                                RageUI.CloseAll()
                                            end
                                            cooldowncool(500)
                                        end
                                        ActionAdmin.ListeActionDesResources = Index;              
                                    end)
                                end
                            end
                        
                        end
                    end 
                else
                    for i = 0, GetNumResources(), 1 do
                        
                        local resource_name = GetResourceByFindIndex(i)
                        
                        if resource_name then

                            if resource_name and GetResourceState(resource_name) == "stopped" then
                                if filterresource == nil or string.find(resource_name,filterresource) then
                                    etatResource = "Stop"
                                    RageUI.List(resource_name, ActionAdmin.ActionDesResources, ActionAdmin.ListeActionDesResources, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                        if (Selected) then 
                                            if Index == 1 then
                                                TriggerServerEvent("yazho:startresource", resource_name)
                                                RageUI.CloseAll()
                                            elseif Index == 2 then
                                                TriggerServerEvent("yazho:stopresource", resource_name)
                                                RageUI.CloseAll()
                                            end
                                            cooldowncool(500)
                                        end
                                        ActionAdmin.ListeActionDesResources = Index;              
                                    end)
                                end
                            end
                        
                        end
                    end 
                    end

                    if filterresource then
                        RageUI.Button("Annuler la Recherche" , false, { Color = { BackgroundColor = { 175, 0, 0, 160 } } }, true, {
                            onSelected = function()
                                filterresource = nil
                            end
                        })
                    end
            
                end, function()
                end)

                RageUI.IsVisible(MenuCreateItem, true, true, true, function()

                    if nameitem == nil then
                        nameitem = "aucun nom"
                    end

                    if labelitem == nil then
                        labelitem = "Aucun label"
                    end

                    if limititem == nil then
                        limititem = ""
                    end

                    if poidsitem == nil then
                        poidsitem = "1"
                    end
                    
                    RageUI.Checkbox("Limit/weight",nil, limitouweight,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            limitouweight = Checked
    
                            if Checked then
                                itemlimit = false
                            else
                                itemlimit = true
                            end
                        end
                    end)

                    if itemlimit == true then
                        RageUI.Line()

                        RageUI.Button("Name", "Attention :~n~Ne pas mettre de majuscule", {RightLabel = ""..nameitem}, true, {
                            onSelected = function()
                                nameitem = KeyboardInput("Name :", "", 25)
                            end
                        })

                        RageUI.Button("Label", "Attention :~n~Mettre de majuscule", {RightLabel = ""..labelitem}, true, {
                            onSelected = function()
                                labelitem = KeyboardInput("Label :", "", 25)
                            end
                        })

                        RageUI.Button("Limit d'item", "~o~Exemple :~n~5", {RightLabel = ""..limititem}, true, {
                            onSelected = function()
                                limititem = KeyboardInput("Limit :", "", 25)
                            end
                        })

                        RageUI.Line()

                        RageUI.Button("Valider l'item" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                            onSelected = function()
                                TriggerServerEvent("yazho:createitemlimit", nameitem, labelitem, limititem)
                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a créer un item ("..nameitem..")", Config.Logs.GestionDev)
                            end
                        })

                    elseif itemlimit == false then
                        RageUI.Line()

                        RageUI.Button("Name", "Attention :~n~Ne pas mettre de majuscule", {RightLabel = ""..nameitem}, true, {
                            onSelected = function()
                                nameitem = KeyboardInput("Name :", "", 25)
                            end
                        })

                        RageUI.Button("Label", "Attention :~n~Mettre de majuscule", {RightLabel = ""..labelitem}, true, {
                            onSelected = function()
                                labelitem = KeyboardInput("Label :", "", 25)
                            end
                        })

                        RageUI.Button("Poids de l'item", "~o~Exemple :~n~1", {RightLabel = ""..poidsitem}, true, {
                            onSelected = function()
                                poidsitem = KeyboardInput("Poids :", "", 25)
                            end
                        })

                        RageUI.Line()

                        RageUI.Button("Valider l'item" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                            onSelected = function()
                                TriggerServerEvent("yazho:createitemweight", nameitem, labelitem, poidsitem)
                                TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a créer un item ("..nameitem..")", Config.Logs.GestionDev)
                            end
                        })
                    end

            
                end, function()
                end)

                RageUI.IsVisible(MenuBlips, true, true, true, function()

                    local pedCoords = GetEntityCoords(PlayerPedId())

                    if tailleblip == nil then
                        tailleblip = 0.7
                    end

                    if textedublip == nil then
                        textedublip = "Aucun nom"
                    end

                    if typeblip == nil then
                        typeblip = 0
                    end

                    RageUI.List("Type :", ActionAdmin.ActionTypeBlip, ActionAdmin.ListeActionTypeBlip, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 40
                            elseif Index == 2 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 38
                            elseif Index == 3 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 43
                            elseif Index == 4 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 50
                            elseif Index == 5 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 51
                            elseif Index == 6 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 52
                            elseif Index == 7 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 56
                            elseif Index == 8 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 60
                            elseif Index == 9 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 61
                            elseif Index == 10 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 67
                            elseif Index == 11 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 71
                            elseif Index == 12 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 72
                            elseif Index == 13 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 73
                            elseif Index == 14 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 75
                            elseif Index == 15 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 84
                            elseif Index == 16 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 90
                            elseif Index == 17 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 93
                            elseif Index == 18 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 100
                            elseif Index == 19 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 110
                            elseif Index == 20 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 140
                            elseif Index == 21 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 184
                            elseif Index == 22 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 207
                            elseif Index == 23 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 226
                            elseif Index == 24 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 280
                            elseif Index == 25 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 361
                            elseif Index == 26 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 351
                            elseif Index == 27 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 402
                            elseif Index == 28 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 419
                            elseif Index == 29 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 446
                            elseif Index == 30 then
                                TriggerEvent("yazho:ClearMission")
                                typeblip = 475
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionTypeBlip = Index;              
                    end)

                    RageUI.List("Couleur :", ActionAdmin.ActionColorBlip, ActionAdmin.ListeActionColorBlip, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 0
                            elseif Index == 2 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 1
                            elseif Index == 3 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 2
                            elseif Index == 4 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 3
                            elseif Index == 5 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 5
                            elseif Index == 6 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 7
                            elseif Index == 7 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 8
                            elseif Index == 8 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 29
                            elseif Index == 9 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 52
                            elseif Index == 10 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 17
                            elseif Index == 11 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 9
                            elseif Index == 12 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 15
                            elseif Index == 13 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 23
                            elseif Index == 14 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 50
                            elseif Index == 15 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 51
                            elseif Index == 16 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 35
                            elseif Index == 17 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 24
                            elseif Index == 18 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 38
                            elseif Index == 19 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 10
                            elseif Index == 20 then
                                TriggerEvent("yazho:ClearMission")
                                colorblip = 36
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionColorBlip = Index;              
                    end)

                    RageUI.List("Taille :", ActionAdmin.ActionTailleBlip, ActionAdmin.ListeActionTailleBlip, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 0.5
                            elseif Index == 2 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 0.6
                            elseif Index == 3 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 0.7
                            elseif Index == 4 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 0.8
                            elseif Index == 5 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 0.9
                            elseif Index == 6 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 1.0
                            elseif Index == 7 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 1.1
                            elseif Index == 8 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 1.2
                            elseif Index == 9 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 1.3
                            elseif Index == 10 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 1.4
                            elseif Index == 11 then
                                TriggerEvent("yazho:ClearMission")
                                tailleblip = 1.5
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionTailleBlip = Index;              
                    end)

                    RageUI.Button("Nom blip",nil, {RightLabel = ""..textedublip}, true, {
                        onSelected = function()
                            local texteblip = KeyboardInput("Nom :", "", 25)
                            textedublip = texteblip
                            TriggerEvent("yazho:ClearMission")
                        end
                    })

                    RageUI.Line()

                    local blip = AddBlipForCoord(pedCoords.x + 8, pedCoords.y + 8, pedCoords.z)
                    SetBlipSprite(blip, typeblip)
                    SetBlipColour(blip, colorblip)
                    SetBlipScale(blip, tailleblip)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(textedublip)
                    EndTextCommandSetBlipName(blip)
                    table.insert(tableBlip, blip)

                    RageUI.Button("Valider le blips" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                        onSelected = function()
                            ShowNotification("Blips créé avec succès.")
                            TriggerServerEvent('yazho:logsEvent', "Citizen.CreateThread(function()\n  local blip = AddBlipForCoord("..pedCoords.x..", "..pedCoords.y..", "..pedCoords.z..")\n  SetBlipSprite(blip, "..typeblip..")\n  SetBlipColour(blip, "..colorblip..")\n  SetBlipScale(blip, "..tailleblip..")\n  SetBlipAsShortRange(blip, true)\n  BeginTextCommandSetBlipName('STRING')\n  AddTextComponentString('"..textedublip.."')\n  EndTextCommandSetBlipName(blip)\nend)", Config.Logs.GestionDev)
                        end
                    })

                    if IsControlJustPressed(1,177) then
                        TriggerEvent("yazho:ClearMission")
                    end
            
                end, function()
                end)

                RageUI.IsVisible(MenuMarker, true, true, true, function()

                    local pedCoords = GetEntityCoords(PlayerPedId())

                    if hauteurmarker == nil then
                        hauteurmarker = 0
                    end

                    if rotateXmarker == nil then
                        rotateXmarker = 0
                    end
                
                    if rotateYmarker == nil then
                        rotateYmarker = 0
                    end

                    if rotateZmarker == nil then
                        rotateZmarker = 0
                    end

                    if scaleX == nil then
                        scaleX = 1.0
                    end

                    if scaleY == nil then
                        scaleY = 1.0
                    end

                    if scaleZ == nil then
                        scaleZ = 1.0
                    end

                    if colorR == nil then
                        colorR = 234
                    end

                    if colorG == nil then
                        colorG = 0
                    end

                    if colorB == nil then
                        colorB = 0
                    end

                    if opacitymarker == nil then
                        opacitymarker = 50
                    end

                    if markerype == nil then
                        markerype = 0
                    end

                    RageUI.List("Type de marker", ActionAdmin.ActionMarkerType, ActionAdmin.ListeActionMarkerType, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                           if Index == 1 then
                            markerype = 0
                           elseif Index == 2 then
                            markerype = 1
                           elseif Index == 3 then
                            markerype = 2
                           elseif Index == 4 then
                            markerype = 3
                           elseif Index == 5 then
                            markerype = 4
                           elseif Index == 6 then
                            markerype = 5
                           elseif Index == 7 then
                            markerype = 6
                           elseif Index == 8 then
                            markerype = 7
                           elseif Index == 9 then
                            markerype = 8
                           elseif Index == 10 then
                            markerype = 9
                           elseif Index == 11 then
                            markerype = 10
                           elseif Index == 12 then
                            markerype = 11
                           elseif Index == 13 then
                            markerype = 12
                           elseif Index == 14 then
                            markerype = 13
                           elseif Index == 15 then
                            markerype = 14
                           elseif Index == 16 then
                            markerype = 15
                           elseif Index == 17 then
                            markerype = 16
                           elseif Index == 18 then
                            markerype = 17
                           elseif Index == 19 then
                            markerype = 18
                           elseif Index == 20 then
                            markerype = 19
                           elseif Index == 21 then
                            markerype = 20
                        elseif Index == 22 then
                            markerype = 21
                           elseif Index == 23 then
                            markerype = 22
                           elseif Index == 24 then
                            markerype = 23
                           elseif Index == 25 then
                            markerype = 24
                           elseif Index == 26 then
                            markerype = 25
                           elseif Index == 27 then
                            markerype = 26
                           elseif Index == 28 then
                            markerype = 27
                           elseif Index == 29 then
                            markerype = 28
                           elseif Index == 30 then
                            markerype = 29
                           elseif Index == 31 then
                            markerype = 30
                           elseif Index == 32 then
                            markerype = 31
                           elseif Index == 33 then
                            markerype = 32
                        elseif Index == 34 then
                            markerype = 33
                           elseif Index == 35 then
                            markerype = 34
                           elseif Index == 36 then
                            markerype = 35
                           elseif Index == 37 then
                            markerype = 36
                           elseif Index == 38 then
                            markerype = 37
                           elseif Index == 39 then
                            markerype = 38
                           elseif Index == 40 then
                            markerype = 39
                           elseif Index == 41 then
                            markerype = 40
                           elseif Index == 42 then
                            markerype = 41
                           elseif Index == 43 then
                            markerype = 42
                           elseif Index == 44 then
                            markerype = 43
                           end
                           cooldowncool(200)
                        end
                        ActionAdmin.ListeActionMarkerType = Index;              
                     end)

                    RageUI.Button("Hauteur du blips", "INFO :~n~Si vous souhaitez baisser ajouter - devant le nombre (ex : -2)", {RightLabel = ""..hauteurmarker..""}, true, {
                        onSelected = function()
                            hauteurmarker = KeyboardInput("Nom du véhicule ", "", 25)
                        end
                    })

                    RageUI.Button("Rotation du marker [X]", "INFO :~n~Mettre .0 après la valeur (ex : 5.0)", {RightLabel = ""..rotateXmarker..""}, true, {
                        onSelected = function()
                            rotateXmarker = KeyboardInput("Nom du véhicule ", "", 25)
                        end
                    })

                    RageUI.Button("Rotation du marker [Y]", "INFO :~n~Mettre .0 après la valeur (ex : 5.0)", {RightLabel = ""..rotateYmarker..""}, true, {
                        onSelected = function()
                            rotateYmarker = KeyboardInput("Nom du véhicule ", "", 25)
                        end
                    })

                    RageUI.Button("Rotation du marker [Z]", "INFO :~n~Mettre .0 après la valeur (ex : 5.0)", {RightLabel = ""..rotateZmarker..""}, true, {
                        onSelected = function()
                            rotateZmarker = KeyboardInput("Nom du véhicule ", "", 25)
                        end
                    })

                    RageUI.List("Taille [X]:", ActionAdmin.ActionScaleX, ActionAdmin.ListeActionScaleX, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                scaleX = 0.5
                            elseif Index == 2 then
                                scaleX = 1.0
                            elseif Index == 3 then
                                scaleX = 1.5
                            elseif Index == 4 then
                                scaleX = 2.0
                            elseif Index == 5 then
                                scaleX = 2.5
                            elseif Index == 6 then
                                scaleX = 3.0
                            elseif Index == 7 then
                                scaleX = 3.5
                            elseif Index == 8 then
                                scaleX = 4.0
                            elseif Index == 9 then
                                scaleX = 4.5
                            elseif Index == 10 then
                                scaleX = 5
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionScaleX = Index;              
                    end)

                    RageUI.List("Taille [Y]:", ActionAdmin.ActionScaleY, ActionAdmin.ListeActionScaleY, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                scaleY = 0.5
                            elseif Index == 2 then
                                scaleY = 1.0
                            elseif Index == 3 then
                                scaleY = 1.5
                            elseif Index == 4 then
                                scaleY = 2.0
                            elseif Index == 5 then
                                scaleY = 2.5
                            elseif Index == 6 then
                                scaleY = 3.0
                            elseif Index == 7 then
                                scaleY = 3.5
                            elseif Index == 8 then
                                scaleY = 4.0
                            elseif Index == 9 then
                                scaleY = 4.5
                            elseif Index == 10 then
                                scaleY = 5
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionScaleY = Index;              
                    end)

                    RageUI.List("Taille [Z]:", ActionAdmin.ActionScaleZ, ActionAdmin.ListeActionScaleZ, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                scaleZ = 0.5
                            elseif Index == 2 then
                                scaleZ = 1.0
                            elseif Index == 3 then
                                scaleZ = 1.5
                            elseif Index == 4 then
                                scaleZ = 2.0
                            elseif Index == 5 then
                                scaleZ = 2.5
                            elseif Index == 6 then
                                scaleZ = 3.0
                            elseif Index == 7 then
                                scaleZ = 3.5
                            elseif Index == 8 then
                                scaleZ = 4.0
                            elseif Index == 9 then
                                scaleZ = 4.5
                            elseif Index == 10 then
                                scaleZ = 5
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionScaleZ = Index;              
                    end)

                    RageUI.List("Couleur du marker:", ActionAdmin.ActionColorMarker, ActionAdmin.ListeActionColorMarker, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                                colorR = 234
                                colorG = 0
                                colorB = 0
                            elseif Index == 2 then
                                colorR = 234
                                colorG = 135
                                colorB = 0
                            elseif Index == 3 then
                                colorR = 231
                                colorG = 234
                                colorB = 0
                            elseif Index == 4 then
                                colorR = 5
                                colorG = 209
                                colorB = 24
                            elseif Index == 5 then
                                colorR = 0
                                colorG = 227
                                colorB = 234
                            elseif Index == 6 then
                                colorR = 3
                                colorG = 35
                                colorB = 196
                            elseif Index == 7 then
                                colorR = 93
                                colorG = 3
                                colorB = 201
                            elseif Index == 8 then
                                colorR = 213
                                colorG = 2
                                colorB = 200
                            end
                            cooldowncool(500)
                        end
                        ActionAdmin.ListeActionColorMarker = Index;              
                    end)

                    RageUI.Button("Opacité du marker", nil, {RightLabel = ""..opacitymarker..""}, true, {
                        onSelected = function()
                            opacitymarker = KeyboardInput("Nom du véhicule ", "", 25)
                        end
                    })
                    
                    RageUI.Line()

                    RageUI.Button("Valider le marker" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                        onSelected = function()
                            ShowNotification("Logs envoyé.")
                            TriggerServerEvent('yazho:logsEvent', "DrawMarker("..markerype..", "..pedCoords.x..", "..pedCoords.y..", "..pedCoords.z + hauteurmarker..", 0.0, 0.0, 0.0, "..rotateXmarker..", "..rotateYmarker..", "..rotateZmarker..", "..scaleX..", "..scaleY..", "..scaleZ..", "..colorR..", "..colorG..", "..colorB..", "..opacitymarker..", true, false, 2, nil, nil, false)", Config.Logs.GestionDev)
                        end
                    })

                    DrawMarker(markerype, pedCoords.x, pedCoords.y, pedCoords.z + hauteurmarker, 0.0, 0.0, 0.0, rotateXmarker, rotateYmarker, rotateZmarker, scaleX, scaleY, scaleZ, colorR, colorG, colorB, opacitymarker, bubUpMarker, faceCamMarker, 2, nil, nil, false)
            
                end, function()
                end)

                RageUI.IsVisible(GestionVeh, true, true, true, function()
                    local playerPed = PlayerPedId()

                    if Config.SpawnVeh == true then
                        if playergroup >= Config.PermSpawnVeh then
                            RageUI.List("Spawn un Véhicule", ActionAdmin.ActionSpawn, ActionAdmin.ListeActionSpawn, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local spawnvehicle = KeyboardInput("Nom du véhicule ", "", 25)
                                        local playerPed = PlayerPedId()
                                        local coords    = GetEntityCoords(playerPed)
                                        local handing  = GetEntityHeading(playerPed)
                                    
                                        ESX.Game.SpawnVehicle(spawnvehicle, coords, handing, function(vehicle)
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 0.0)
                                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                                            ShowNotification(spawnvehicle.." spawn avec succès.")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a fais spawn "..spawnvehicle.."", Config.Logs.GestionVeh)
                                        end)
                                    elseif Index == 2 then
                                        local spawnvehicle = KeyboardInput("Nom du véhicule ", "", 25)
                                        local playerPed = PlayerPedId()
                                        local coords    = GetEntityCoords(playerPed)
                                        local handing  = GetEntityHeading(playerPed)
                                    
                                        ESX.Game.SpawnVehicle(spawnvehicle, coords, handing, function(vehicle)
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 0.0)
                                            ShowNotification(spawnvehicle.." spawn avec succès.")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a fais spawn "..spawnvehicle.."", Config.Logs.GestionVeh)
                                        end)
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionSpawn = Index;              
                            end)
                        end
                    end

                    if Config.VehEnFace == true then
                        if playergroup >= Config.PermVehEnFace then
                            RageUI.List("Véhicule en Face", ActionAdmin.ActionVehEnFace, ActionAdmin.ListeActionVehEnFace, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                if (Active) then 
                                    GetCloseVehi()
                                end
                                if (Selected) then 
                                    if Index == 1 then
                                        local playerPed = PlayerPedId()
                                        local vehicle   = ESX.Game.GetVehicleInDirection()
                                        if DoesEntityExist(vehicle) then
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDirtLevel(vehicle, 0.0) 
                                            ShowNotification("Véhicule réparé avec succès.")
                                        else
                                            ShowNotification("Une erreur est survenu.")
                                        end
                                    elseif Index == 2 then
                                        local playerPed = PlayerPedId()
                                        local vehicle   = ESX.Game.GetVehicleInDirection()
                                        if DoesEntityExist(vehicle) then
                                            ESX.Game.DeleteVehicle(vehicle)
                                            ShowNotification("Véhicule supprimé avec succès.")
                                        else
                                            ShowNotification("Une erreur est survenu.")
                                        end
                                    elseif Index == 3 then
                                        local playerPed = PlayerPedId()
                                        local vehicle   = ESX.Game.GetVehicleInDirection()
                                        if DoesEntityExist(vehicle) then
                                            SetVehicleDirtLevel(vehicle, 0.0)
                                            ShowNotification("Véhicule nettoyé avec succès.")
                                        else
                                            ShowNotification("Une erreur est survenu.")
                                        end
                                    elseif Index == 4 then
                                        admin_vehicle_flip()
                                    end
                                    cooldowncool(500)
                                end
                                ActionAdmin.ListeActionVehEnFace = Index;              
                            end)
                        end
                    end

                    if IsPedSittingInAnyVehicle(playerPed) then

                        if Config.DeleteVeh == true then
                            if playergroup >= Config.PermDeleteVeh then
                                RageUI.Separator("Intéractions")
                                RageUI.Button("Supprimer le Véhicule",nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        local playerPed = PlayerPedId()
                                        local vehicle   = ESX.Game.GetVehicleInDirection()

                                        if IsPedInAnyVehicle(playerPed, true) then
                                            vehicle = GetVehiclePedIsIn(playerPed, false)
                                        end

                                        if DoesEntityExist(vehicle) then
                                            ESX.Game.DeleteVehicle(vehicle)
                                            ShowNotification("Véhicule supprimé avec succès.")
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a supprimé un véhicule", Config.Logs.GestionVeh)
                                        end
                                    end
                                })
                            end
                        end

                        if Config.Repair == true then
                            if playergroup >= Config.PermRepair then
                                RageUI.Button("Réparer le Véhicule",nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                        SetVehicleFixed(plyVeh)
                                        SetVehicleDirtLevel(plyVeh, 0.0) 
                                    end
                                })

                                RageUI.Button("Nettoyer le Véhicule",nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                        SetVehicleDirtLevel(plyVeh, 0.0)
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a nettoyé un véhicule", Config.Logs.GestionVeh)
                                    end
                                })
                            end
                        end

                        if Config.ModifSale == true then
                            if playergroup >= Config.PermModifSale then
                                RageUI.Separator("Modifications")
                                RageUI.List("Modifier le Niveau de Saleté", ActionAdmin.ActionDirt, ActionAdmin.ListeActionDirt, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                                    if (Selected) then 
                                        if Index == 1 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 0.0)
                                        elseif Index == 2 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 1.0)
                                        elseif Index == 3 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 2.0)
                                        elseif Index == 4 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 3.0)
                                        elseif Index == 5 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 4.0)
                                        elseif Index == 6 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 5.0)
                                        elseif Index == 7 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 6.0)
                                        elseif Index == 8 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 7.0)
                                        elseif Index == 9 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 8.0)
                                        elseif Index == 10 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 9.0)
                                        elseif Index == 11 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 10.0)
                                        elseif Index == 12 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 11.0)
                                        elseif Index == 13 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 12.0)
                                        elseif Index == 14 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 13.0)
                                        elseif Index == 15 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 14.0)
                                        elseif Index == 16 then
                                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleDirtLevel(plyVeh, 15.0)
                                        end
                                        cooldowncool(500)
                                    end
                                    ActionAdmin.ListeActionDirt = Index;              
                                end)
                            end
                        end

                        if Config.PleinVeh == true then
                            if playergroup >= Config.PermPleinVeh then
                                RageUI.Button("Plein du Véhicule",nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                        SetVehicleFuelLevel(plyVeh, 100.0)
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a fais le plein un véhicule", Config.Logs.GestionVeh)
                                    end
                                })
                            end
                        end

                        RageUI.List("Changer la Couleur", arraycar, arrayIndexcar, nil, {}, true, function(Hovered, Active, Selected, i) arrayIndexcar = i
                            if (Selected) then
                                local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                if couleur[arrayIndexcar] then
                                    SetVehicleColours(plyVeh, couleur[arrayIndexcar].color, couleur[arrayIndexcar].color2)
                                    ESX.ShowNotification("Couleur du Véhicule changé.")
                                end
                            end
                        end)
                        

                        RageUI.Button("Améliorer le Véhicule", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                if vehicle ~= 0 then
                                    SetVehicleModKit(vehicle, 0)
                                    for i = 0, 49 do
                                        local modCount = GetNumVehicleMods(vehicle, i)
                                        if modCount > 0 then
                                            SetVehicleMod(vehicle, i, modCount - 1, false)
                                        end
                                    end
                                    SetVehicleWindowTint(vehicle, 1)
                                    SetVehicleTyresCanBurst(vehicle, false)
                                    SetVehicleNumberPlateText(vehicle, "ADMIN")
                                    ESX.ShowNotification("Véhicule customisé au maximum.")
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option.")
                                end
                            end
                        })
        
                        if Config.VehInvisible == true then
                            if playergroup >= Config.PermVehInvisible then
                                RageUI.Checkbox("Mode Invisible",nil, invisible,{},function(Hovered,Ative,Selected,Checked)
                                    if Selected then
                                        invisible = Checked
                                        local vehicle   = GetVehiclePedIsIn(playerPed, false)
                
                                        if Checked then
                                            SetEntityVisible(GetPlayerPed(-1), 0, 0)
                                            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), 1)
                                            SetEntityVisible(vehicle, 0, 0)
                                            NetworkSetEntityInvisibleToNetwork(vehicle, 1)
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a le véhicule en invisible", Config.Logs.GestionVeh)
                                        else
                                            SetEntityVisible(GetPlayerPed(-1), 1, 0)
                                            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), 0)
                                            SetEntityVisible(vehicle, 1, 0)
                                            NetworkSetEntityInvisibleToNetwork(vehicle, 0)
                                            TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a le véhicule en visibel", Config.Logs.GestionVeh)
                                        end
                                    end
                                end)
                            end
                        end

                        if Config.Plaque == true then
                            if playergroup >= Config.PermPlaque then
                                RageUI.Button("Changer la Plaque du Véhicule",nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        local newplaque = KeyboardInput("Nom du véhicule ", "", 8)
                                        SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , newplaque)
                                        ShowNotification("Plaque changée en : "..newplaque..".")
                                        TriggerServerEvent('yazho:logsEvent', GetPlayerName(PlayerId()).." a changé la plaque en "..newplaque.."", Config.Logs.GestionVeh)
                                    end
                                })
                            end
                        end

                        if Config.Livery == true then
                            if playergroup >= Config.PermLivery then
                                RageUI.Line()
                                RageUI.Button("Livery & Extras",nil, {RightLabel = "→→"}, true, {}, MenuLivery)
                            end
                        end
                        
                    end
            
                end, function()
                end)

                RageUI.IsVisible(MenuLivery, true, true, true, function()

                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                    local liveryCount = GetVehicleLiveryCount(vehicle)

                    for i = 1, liveryCount do
                        local state = GetVehicleLivery(vehicle) 
                        
                        if state == i then
                            RageUI.Button("Livery: "..i, nil, {RightLabel = "~g~ON"}, true, {
                                onSelected = function()   
                                    SetVehicleLivery(vehicle, i, not state)
                                end      
                            })
                        else
                            RageUI.Button("Livery: "..i, nil, {RightLabel = "OFF"}, true, {
                                onSelected = function() 
                                    SetVehicleLivery(vehicle, i, state)
                                end      
                            })
                        end
                    end

                    for id=0, 12 do
                        if DoesExtraExist(vehicle, id) then
                            local state2 = IsVehicleExtraTurnedOn(vehicle, id)
                        
                        if state2 then
                            RageUI.Button("Extra: "..id, nil, {RightLabel = "~g~ON"}, true, {
                                onSelected = function() 
                                    SetVehicleExtra(vehicle, id, state2)
                                end      
                            })
                        else
                            RageUI.Button("Extra: "..id, nil, {RightLabel = "OFF"}, true, {
                                onSelected = function() 
                                    SetVehicleExtra(vehicle, id, state2)
                                end      
                            })
                        end
                    end
                end
            
                end, function()
                end)

		if not RageUI.Visible(AdminMenu) and not RageUI.Visible(GestionPersonnel) and not RageUI.Visible(GestionDev) and not RageUI.Visible(Infos) and not RageUI.Visible(GestionGrades) and not RageUI.Visible(Viosionas) and not RageUI.Visible(Racc) and not RageUI.Visible(GestionStaffs) and not RageUI.Visible(AddStaff) and not RageUI.Visible(AddStaffJoueur) and not RageUI.Visible(GestionReport) and not RageUI.Visible(GestionVeh) and not RageUI.Visible(MenuPed) and not RageUI.Visible(Armas) and not RageUI.Visible(MenuMarker) and not RageUI.Visible(MenuBlips) and not RageUI.Visible(MenuResource) and not RageUI.Visible(MenuCreateItem) and not RageUI.Visible(GestionJoueur) and not RageUI.Visible(GestionJoueur2) and not RageUI.Visible(Administration) and not RageUI.Visible(MenuLivery) and not RageUI.Visible(MenuGestionSanction) and not RageUI.Visible(MenuItemJoueur) and not RageUI.Visible(GestionBanActif) and not RageUI.Visible(MenuInv) and not RageUI.Visible(MenuItem) then
            AdminMenu = RMenu:DeleteType(AdminMenu, true, ServerIDSess == false)
		end
	end
end


Keys.Register(Config.KeyMenu, 'Admin', 'Ouvrir le MENU ADMIN', function()
    ESX.TriggerServerCallback('yazho:getgroup', function(group)
		playergroup = group
        if playergroup >= Config.PermOpenMenu then
            MenuAdmin(playergroup)
        end
        return
	end)
end)

Keys.Register('F2', 'Noclip', 'NoClip', function()
    ESX.TriggerServerCallback('yazho:getgroup', function(group)
		playergroup = group
        if playergroup >= Config.PermOpenMenu then
            NoCLIP(playergroup)
        end
        return
	end)
end)


RegisterCommand("yazhoadminmenu", function()
    ESX.TriggerServerCallback('yazho:getgroup', function(group)
		playergroup = group
        if playergroup >= Config.PermOpenMenu then
            MenuAdmin(playergroup)
        end
        return
    MenuAdmin(playergroup)
end)
end)

RegisterCommand('yazhonoclip', function()
    ESX.TriggerServerCallback('yazho:getgroup', function(group)
        playergroup = group
        if playergroup >= Config.PermOpenMenu then
            NoCLIP(playergroup)
        end
    end)
end)


Citizen.CreateThread(function ()
	while true do
		local waitmax = 800
		if dogtoggle then
			waitmax = 0
			if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                if GetEntityType(getEntity(PlayerId())) == 2 or 3 then
                    if aimCheck(GetPlayerPed(-1)) then
                        SetEntityAsMissionEntity(entity, true, true)
                        DeleteEntity(entity)
                    end
                end
            end
		end
		Citizen.Wait(waitmax)
	end
end)

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

Citizen.CreateThread(function ()
	while true do
		local waitmax = 800
		if superJumpactive then
			waitmax = 0
            SetSuperJumpThisFrame(PlayerId())
		end
        if superSprintactive then
			waitmax = 0
            SetPedMoveRateOverride(PlayerPedId(), vitessesprint)
		end
		Citizen.Wait(waitmax)
	end
end)



RegisterNetEvent("yazho:ClearMission")
AddEventHandler("yazho:ClearMission", function()
	for k, v in pairs(tableBlip) do
		RemoveBlip(v)
        DeleteEntity(v)
        DeletePed(v)
	end
end)

RegisterNetEvent("yazho:freezeplayer")
AddEventHandler("yazho:freezeplayer", function(state)
    FreezeEntityPosition(PlayerPedId(), state)
end)

RegisterNetEvent("yazho:GetItem")
AddEventHandler("yazho:GetItem", function(result)
    local found = 0
    for k,v in pairs(result) do
        found = found + 1
    end
    if found > 0 then ItemData = result end
end)

if Config.SystemeReport == true then
    RegisterCommand("report", function()
        MenuReport()
    end)
end

function MenuReport()
    local menureport = RageUI.CreateMenu("Menu Report", "MENU D'INTERACTIONS")

    if Config.Bannierperso == true then
        menureport:SetSpriteBanner(Config.BannerPerso, Config.BannerPerso2)
    else
        menureport:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    end

    RageUI.Visible(menureport, not RageUI.Visible(menureport))
    while menureport do
        Citizen.Wait(0)
            RageUI.IsVisible(menureport, true, true, true, function()

                if sujetreport == nil then
                    sujetreport = "Aucun"
                end

                if descreport == nil then
                    descreport = "Aucun"
                end

                RageUI.List("Sujer du Report", ActionAdmin.ActionReport, ActionAdmin.ListeActionReport, nil, {RightLabel = ""}, not cooldown, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                            ReportJoueur = true
                            ReportBug = false
                            ReportQuestion = false
                        elseif Index == 2 then
                            ReportJoueur = false
                            ReportBug = true
                            ReportQuestion = false
                        elseif Index == 3 then
                            ReportJoueur = false
                            ReportBug = false
                            ReportQuestion = true
                        end
                        cooldowncool(500)
                    end
                    ActionAdmin.ListeActionReport = Index;              
                end)

                if ReportJoueur then

                    RageUI.Button("Raison du Report", nil, {RightLabel = ""..sujetreport}, true, {
                        onSelected = function()
                            sujetreport = KeyboardInput("Raison du Report", "", 25)
                        end
                    })

                    RageUI.Button("Description du Report", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            descreport = KeyboardInput("Description du Report", "", 200)
                        end
                    })

                    RageUI.Line()

                    local id = GetPlayerServerId(PlayerId())
                    local name = GetPlayerName(PlayerId())

                    RageUI.Button("Envoyer le Report" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                        onSelected = function()
                            TriggerServerEvent("yazho:annonceReport", playergroup, onservice)
                            TriggerServerEvent("yazho:ReportJoueur", sujetreport, descreport, id, name)
                            sujetreport = nil
                            descreport = nil
                            ReportJoueur = false
                            ShowNotification("Report envoyé.")
                            RageUI.CloseAll()
                        end
                    })

                elseif ReportBug then

                    RageUI.Button("Raison du Report", nil, {RightLabel = ""..sujetreport}, true, {
                        onSelected = function()
                            sujetreport = KeyboardInput("Raison du Report", "", 25)
                        end
                    })

                    RageUI.Button("Description du Report", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            descreport = KeyboardInput("Description du Report", "", 150)
                        end
                    })

                    local id = GetPlayerServerId(PlayerId())
                    local name = GetPlayerName(PlayerId())
                    RageUI.Line()
                    RageUI.Button("Envoyer le Report" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                        onSelected = function()
                            TriggerServerEvent("yazho:annonceReport", playergroup)
                            TriggerServerEvent("yazho:ReportBug", sujetreport, descreport, id, name)
                            sujetreport = nil
                            descreport = nil
                            ReportBug = false
                            ShowNotification("Report envoyé.")
                            RageUI.CloseAll()
                        end
                    })

                elseif ReportQuestion then

                    RageUI.Button("Raison du Report", nil, {RightLabel = ""..sujetreport}, true, {
                        onSelected = function()
                            sujetreport = KeyboardInput("Raison du Report", "", 25)
                        end
                    })

                    RageUI.Button("Description du Report", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            descreport = KeyboardInput("Description du Report", "", 150)
                        end
                    })

                    local id = GetPlayerServerId(PlayerId())
                    local name = GetPlayerName(PlayerId())

                    RageUI.Line()
                    RageUI.Button("Envoyer le Report" , nil, { Color = { BackgroundColor = { 0, 175, 27, 160 } } }, true, {
                        onSelected = function()
                            TriggerServerEvent("yazho:annonceReport", playergroup)
                            TriggerServerEvent("yazho:ReportQuestion", sujetreport, descreport, id, name)
                            sujetreport = nil
                            descreport = nil
                            ReportQuestion = false
                            ShowNotification("Report envoyé.")
                            RageUI.CloseAll()
                        end
                    })
                end

			end, function()    
			end)

		if not RageUI.Visible(menureport) then
            menureport = RMenu:DeleteType(menureport, true)
		end
	end
end

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

Citizen.CreateThread(function ()
	while true do
		local waitmax = 800
		if drawInfo then
			waitmax = 0
			local text = {}
            local targetPed = GetPlayerPed(drawTarget)
            
            table.insert(text,"Appuyez [E] pour annuler.")
            
            for i,theText in pairs(text) do
                SetTextFont(4)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(theText)
                EndTextCommandDisplayText(0.3, 0.7+(i/30))
            end
            
            if IsControlJustPressed(0,103) then
                local targetPed = PlayerPedId()
                local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
    
                RequestCollisionAtCoord(targetx,targety,targetz)
                NetworkSetInSpectatorMode(false, targetPed)
    
                StopDrawPlayerInfo()
                
            end
		end
		Citizen.Wait(waitmax)
	end
end)

function SpectatePlayer(targetPed,target,name)
    local playerPed = PlayerPedId()
    enable = true
    if targetPed == playerPed then enable = false end

    if(enable)then

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
        DrawPlayerInfo(target)
        ESX.ShowNotification('Mode spectateur activé.')
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
        StopDrawPlayerInfo()
        ESX.ShowNotification('Mode spectateur arrêté.')
    end
end


Citizen.CreateThread(function ()
	while true do
		local waitmax = 800
		if driftmodeactive then
			waitmax = 0
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				CarSpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * speed
				if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
					if CarSpeed <= drift_speed_limit then  
						if IsControlPressed(1, 21) then
							SetVehicleReduceGrip(GetVehiclePedIsIn(PlayerPedId(), false), true)
						else
							SetVehicleReduceGrip(GetVehiclePedIsIn(PlayerPedId(), false), false)
						end
					end
				end
			end
		end
		Citizen.Wait(waitmax)
	end
end)

function GetPed() 
    return GetPlayerPed(-1) 
end
function GetCar() 
    return GetVehiclePedIsIn(PlayerPedId(), false) 
end

RegisterNetEvent('yazho:Respond')
AddEventHandler('yazho:Respond', function()
	TriggerServerEvent("yazho:CheckMe")
end)

function GetCloseVehi()
    local player = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
    local vCoords = GetEntityCoords(vehicle)
    DrawMarker(1, vCoords.x, vCoords.y, vCoords.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 3.5, 3.5, 182, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
end

Citizen.CreateThread(function ()
	while true do
		if onservice then
            if ShowName then
                local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
                for _, v in pairs(GetActivePlayers()) do
                    local otherPed = GetPlayerPed(v)
                    local job = ESX.PlayerData.job.name
                    local job2 = ESX.PlayerData.job2.name
                
                    if otherPed ~= pPed then
                        if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                            gamerTags[v] = CreateFakeMpGamerTag(otherPed, ("("..GetPlayerServerId(v)..") - "..GetPlayerName(v)), false, false, '', 0)
                        else
                            RemoveMpGamerTag(gamerTags[v])
                            gamerTags[v] = nil
                        end
                    end
                end
            else
                for _, v in pairs(GetActivePlayers()) do
                    RemoveMpGamerTag(gamerTags[v])
                end
            end
            for k,v in pairs(GetActivePlayers()) do
                if NetworkIsPlayerTalking(v) then
                    local pPed = GetPlayerPed(v)
                    local pCoords = GetEntityCoords(pPed)
                    DrawMarker(20, pCoords.x, pCoords.y, pCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                end
            end
		end
		Citizen.Wait(waitmax)
	end
end)

RegisterNetEvent("adminmenu:setCoords")
AddEventHandler("adminmenu:setCoords", function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

RegisterNetEvent("yazho:setgpb")
AddEventHandler("yazho:setgpb", function(armour)
    SetPedArmour(PlayerPedId(), armour)
end)

RegisterNetEvent("yazho:freezJoueur")
AddEventHandler("yazho:freezJoueur", function(active)
    FreezeEntityPosition(PlayerPedId(), active)
end)

RegisterNetEvent("yazho:delallveh")
AddEventHandler("yazho:delallveh", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)

Citizen.CreateThread(function ()
	while true do
		if onservice then
            if blipsActive == true then
                for _, player in pairs(GetActivePlayers()) do
                    local found = false
                    if player ~= PlayerId() then
                        local ped = GetPlayerPed(player)
                        local blip = GetBlipFromEntity(ped)
                        if not DoesBlipExist(blip) then
                            blip = AddBlipForEntity(ped)
                            SetBlipCategory(blip, 7)
                            SetBlipScale(blip, 0.85)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipSprite(blip, 1)
                            SetBlipColour(blip, 1)
                        end
    
                        SetBlipNameToPlayerName(blip, player)
    
                        local veh = GetVehiclePedIsIn(ped, false)
                        local blipSprite = GetBlipSprite(blip)
    
                        if IsEntityDead(ped) then
                            if blipSprite ~= 303 then
                                SetBlipSprite(blip, 303)
                                SetBlipColour(blip, 1)
                                ShowHeadingIndicatorOnBlip(blip, false)
                            end
                        elseif veh ~= nil then
                            if IsPedInAnyBoat(ped) then
                                if blipSprite ~= 427 then
                                    SetBlipSprite(blip, 427)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyHeli(ped) then
                                if blipSprite ~= 43 then
                                    SetBlipSprite(blip, 43)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyPlane(ped) then
                                if blipSprite ~= 423 then
                                    SetBlipSprite(blip, 423)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyPoliceVehicle(ped) then
                                if blipSprite ~= 137 then
                                    SetBlipSprite(blip, 137)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnySub(ped) then
                                if blipSprite ~= 308 then
                                    SetBlipSprite(blip, 308)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            elseif IsPedInAnyVehicle(ped) then
                                if blipSprite ~= 225 then
                                    SetBlipSprite(blip, 225)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, false)
                                end
                            else
                                if blipSprite ~= 1 then
                                    SetBlipSprite(blip, 1)
                                    SetBlipColour(blip, 0)
                                    ShowHeadingIndicatorOnBlip(blip, true)
                                end
                            end
                        else
                            if blipSprite ~= 1 then
                                SetBlipSprite(blip, 1)
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip(blip, true)
                            end
                        end
                        if veh then
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(veh)))
                        else
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                        end
                    end
                end
            end
		end
		Citizen.Wait(waitmax)
	end
end)

local AnnounceTime = 10

RegisterNetEvent('annonce:sendAnnounceMessage')
AddEventHandler('annonce:sendAnnounceMessage', function(grosseannonce)
	PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)

	local time = 0

    local function setcountdown(x) time = GetGameTimer() + x*1000 end
    local function getcountdown() return math.floor((time-GetGameTimer())/1000) end
    
    setcountdown(AnnounceTime)

    while getcountdown() > 0 do
        Citizen.Wait(1)
		local scaleform = Initialize("mp_big_message_freemode", grosseannonce)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end
end)

function Initialize(scaleform, grosseannonce)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~c~ANNONCE")
    PushScaleformMovieFunctionParameterString(grosseannonce) 
	PopScaleformMovieFunctionVoid()
    return scaleform
end

