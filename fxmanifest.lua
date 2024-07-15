fx_version "cerulean"
game "gta5"
lua54 'yes'

author "Cadburry (ByteCode Studios)"
description "ChopShop with radio which provides hot vehicles"
version "1.2"

shared_scripts {
    "config.lua"
}

client_scripts {
    "bridge/client.lua",
    "module/client.lua"
}

server_scripts {
    "bridge/server.lua",
    "module/server.lua"
}
