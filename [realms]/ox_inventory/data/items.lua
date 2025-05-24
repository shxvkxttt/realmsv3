return	{
	['money242344'] = {
		label = 'Argentsfwe wfwfefewf',
	},
	['money'] = {
		label = 'Argents',
	},
	['sabot'] = {
		label = 'Sabot Police',
		weight = 0,
		stack = false,
		close = false,
	},

	['clesabot'] = {
		label = 'Clé Sabot',
		weight = 0,
		stack = false,
		close = false,
	},
	--- AMMO BOX
    ['box-ammo-9'] = {
		label = 'Boîte de munition de pistolet',
		weight = 200,
		stack = true
	},

	['box-ammo-45'] = {
		label = 'Boîte de munition de SMG',
		weight = 200,
		stack = true
	},

	['box-ammo-rifle'] = {
		label = 'Boîte de unition de fusil d\'assaut',
		weight = 200,
		stack = true
	},

	['box-ammo-rifle2'] = {
		label = 'Boîte de munition de sniper',
		weight = 200,
		stack = true
	},

	['box-ammo-shotgun'] = {
		label = 'Boîte de munition de fusil à pompe',
		weight = 200,
		stack = true
	},
		['lockpick'] = {
			label = 'Lockpick',
			weight = 0,
		},
		['fish_cooked'] = {
			label = 'Poisson cuit',
			description = "",
			weight = 200,
			allowArmed = false,
			close = false,
			stack = false,
			degrade = 48*60,
			client = {
				status = { hunger = 200000 },
				anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
				prop = {
					model = 'prop_cs_steak',
					pos = { x = 0.02, y = 0.02, y = -0.02},
					rot = { x = 0.0, y = 0.0, y = 0.0}
				},
				usetime = 2500,
			}
		},
	["tshirt"] = {
		label = "T-shirt",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["pants"] = {
		label = "Pantalon",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["shoes"] = {
		label = "Chaussure",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["helmet"] = {
		label = "Chapeau",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["glasses"] = {
		label = "Lunette",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["mask"] = {
		label = "Mask",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["bags"] = {
		label = "Sac",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	["bproof"] = {
		label = "Gilet par balle",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["watches"] = {
		label = "Montre",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["bracelets"] = {
		label = "Bracelets",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["chain"] = {
		label = "Chaine",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},

	["arms"] = {
		label = "Bras",
		weight = 0.05,
		stack = false,
		close = true,
		consume = 0,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},
	["torso"] = {
		label = "Veste",
		weight = 0.05,
		consume = 0,
		stack = false,
		close = true,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		},
		server= {
			export = 'cfx-clohtingStore.useskin'
		},
		buttons = {
			{
				label = 'Renommer',
				action = function(slot)
					local input = lib.inputDialog('Renommer', {
						{type = 'input', label = '', description = '', required = true, min = 1, max = 7},
					})
					TriggerServerEvent('cfx-clohtingStore:rename', slot, input[1])
				end
			},
		},
	},
	["bread"] = {
		label = "Bread",
		weight = 1,
		stack = true,
		close = true,
	},
	["fixkit"] = {
		label = "Repair Kit",
		weight = 3,
		stack = true,
		close = true,
	},
--weed
	["maleseed"] = {
		label = "MaleSeedItem",
		weight = 2,
		stack = true,
		close = true,
	},
	["fertilizer"] = {
		label = "MaleSeedItem",
		weight = 2,
		stack = true,
		close = true,
	},
	["weed"] = {
		label = "MaleSeedItem",
		weight = 2,
		stack = true,
		close = true,
	},

---brutal ambulance
	["medikit"] = {
		label = "Medikit",
		weight = 2,
		stack = true,
		close = true,
	},
	["bandage"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},
	["head_bandage"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},
	["arm_wrap"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},
	["leg_plaster"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},
	["body_bandage"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},
	["small_heal"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},
	["big_heal"] = {
		label = "Bandage",
		weight = 2,
		stack = true,
		close = true,
	},

	---brutal ambulance
	["phone"] = {
		label = "Téléphone",
		weight = 1,
		stack = true,
		close = true,
	},

	['radio'] = {
		label = 'Radio',
		weight = 100,
		stack = true,
		close = true,
		client = {
			export = 'es_extended',
			remove = function(total)
				-- Disconnets a player from the radio when all his radio items are removed.
				if total < 1 and GetConvar('radio:disconnectWithoutRadio', 'true') == 'true' then
					exports.es_extended:leaveRadio()
				end
			end
		}
	},
	["water"] = {
		label = "Water",
		weight = 1,
		stack = true,
		close = true,
	},
	--- key 
	["key-1"] = {
		label = "Clé (1)",
		weight = 1,
		stack = true,
		close = true,
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Body Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Repair Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},
}