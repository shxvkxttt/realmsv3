fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
    'server/sv_exports.lua',
    'server/sv_commands.lua',
}
server_exports {
    'GetPlayerData',
    'SetPlayerMoney',
    'AddPlayerMoney',
    'RemovePlayerMoney',
    'GetPlayerDataFromUID',
    'GetPlayerIDFromUID',
}


client_scripts {
    'client/cl_exports.lua',
    'client/cl_main.lua',
    'client/cl_commands.lua',
}
export 'TriggerServerCallback'

shared_script {
    'config.lua',
    '@ox_lib/init.lua'
}

dependencies {
	'oxmysql',
    'ox_lib'
}