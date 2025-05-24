local crewName, crewLabel, crewType = "", "", "gang"
local types = { "gang", "orga" }

RegisterCommand("createCrew", function()
    lib.registerContext({
        id = 'create_crew_menu',
        title = 'Créer un crew',
        options = {
            {
                title = 'Nom du crew',
                description = crewName ~= "" and ("Nom : " .. crewName) or "Nom visible par tout le monde",
                icon = 'pen',
                onSelect = function()
                    local input = lib.inputDialog("Nom du crew", {
                        { type = "input", label = "Nom", placeholder = "ex: Ballas", required = true }
                    })
                    if input then
                        crewName = input[1]
                        TriggerEvent("createCrew") -- Recharge le menu
                    end
                end
            },
            {
                title = 'Label (unique)',
                description = crewLabel ~= "" and ("Label : " .. crewLabel) or "Utilisé en base",
                icon = 'hashtag',
                onSelect = function()
                    local input = lib.inputDialog("Label du crew", {
                        { type = "input", label = "Label", placeholder = "ex: ballas", required = true }
                    })
                    if input then
                        crewLabel = input[1]
                        TriggerEvent("createCrew") -- Recharge le menu
                    end
                end
            },
            {
                title = "Type de crew",
                description = "Actuel : " .. crewType,
                icon = 'users',
                onSelect = function()
                    local choix = lib.inputDialog("Choisir un type", {
                        {
                            type = "select",
                            label = "Type",
                            options = {
                                { label = "Gang", value = "gang" },
                                { label = "Organisation", value = "orga" }
                            }
                        }
                    })
                    if choix then
                        crewType = choix[1]
                        TriggerEvent("createCrew") -- Recharge le menu
                    end
                end
            },
            {
                title = 'Créer le crew',
                icon = 'check',
                disabled = (crewName == "" or crewLabel == ""),
                onSelect = function()
                    print('nom : '..crewLabel .." | name : "..crewName .. " | type : ".. crewType)
                    TriggerServerEvent("crew:create", crewLabel, crewName, crewType)
                    lib.notify({ title = 'Crew', description = 'Crew créé avec succès !', type = 'success' })
                end
            }
        }
    })

    lib.showContext('create_crew_menu')
end)

RegisterNetEvent("createCrew", function()
    ExecuteCommand("createCrew")
end)

RegisterKeyMapping('createCrew', 'Créer un crew', 'keyboard', 'F6')
