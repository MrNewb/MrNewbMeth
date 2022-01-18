-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

name 'MrNewbMeth'
author 'MrNewb#6475'
description 'The completed version of MrNewbMeth - fucking finally'
version '1.0.1'

shared_scripts {
    '@es_extended/imports.lua'
}

server_scripts {
    "server/*.lua"
}

client_scripts {
    "client/*.lua"
}

dependencies {
    'es_extended',
    'esx_ambulancejob',
    'mythic_progbar'
}

