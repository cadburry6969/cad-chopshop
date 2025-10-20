Chopshop with radio which provides you hotvehicle on time to time. just have radio and it will provide you hotvehicle in chatbox.

# Preview

[Video](https://youtu.be/I0GqpBkloK0)
[![Click Here](https://img.youtube.com/vi/I0GqpBkloK0/maxresdefault.jpg)](https://youtu.be/I0GqpBkloK0)

# Required
- ox_lib

# Supported

- qbox, qb, esx
- qb-target, ox_target
- qb-inventory, lj-inventory, ps-inventory, ox_inventory

# Install Inventory Items

> QB/PS/LJ inventory
1) Add Below lines to `qb-core/shared/items.lua`

```lua
chopradio = {
    name = "chopradio",
    label = "Chop Radio",
    weight = 500,
    type = "item",
    image = "chopradio.png",
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = "Special radio which informs you about cool stuff"
},
```
2) Add images inside `[images]` to `qb-inventory/html/images` / `ps-inventory/html/images` / `lj-inventory/html/images`

> Ox Inventory
1) Add Below lines to `ox_inventory/data/items.lua`

```lua
['chopradio'] = {
    label = "Chop Radio",
    description = "Special radio which informs you about cool stuff",
    weight = 500,
    close = true,
    server = {
        export = 'cad-chopshop.useItem'
    }
},
```
2) Add images inside `[images]` to `ox_inventory/web/images`