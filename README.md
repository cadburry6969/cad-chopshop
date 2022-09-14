# cad-chopshop
Chopshop with radio which provides you hotvehicle on time to time. just have radio and it will provide you hotvehicle in chatbox.

# Preview

[Video](https://youtu.be/I0GqpBkloK0)

# Dependencies

* qb-core
* qb-target

# How to Install

1) Add Below lines to `qb-core/shared/items.lua`

 ```lua
["chopradio"] = {["name"] = "chopradio", ["label"] = "Chop Radio", ["weight"] = 500, ["type"] = "item", ["image"] = "chopradio.png", ["unique"] = false, ["useable"] = true,     ["shouldClose"] = true, ["combinable"] = nil, ["description"] = "Special radio which informs you about cool stuff"},
```
 
2) Add `chopradio.png` to `qb-inventory/html/images`
3) Add `ensure cad-chopshop` to server.cfg
4) Done!

# Config

* Add Vehicles in `server.lua`
* Change items reward in `server.lua`
* Change ped coords and chop location in `client.lua`

# Support

https://discord.gg/qxGPARNwNP
