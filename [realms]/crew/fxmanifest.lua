fx_version 'cerulean'

games { 'gta5' }

lua54 'yes'


shared_script {
    '@ox_lib/init.lua'
}


client_scripts {
    'client/client.lua',
    'client/crew.lua'
}

server_scripts {
    'server/server.lua',
    'server/crew.lua',
    '@oxmysql/lib/MySQL.lua'
}

dependencies {
	'oxmysql',
    'ox_lib'
}