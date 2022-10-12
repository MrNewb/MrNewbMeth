-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

name 'MrNewbMeth'
author 'MrNewb#6475'
description 'Qb-Core MrNewbMeth <3'
version '3.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
	'@ox_lib/init.lua',
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}

client_scripts {
    "client/*.lua"
}

lua54 'yes'
