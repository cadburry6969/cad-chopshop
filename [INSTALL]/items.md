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
2) Add `chopradio.png` to `qb-inventory/html/images` / `ps-inventory/html/images` / `lj-inventory/html/images`

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
2) Add `chopradio.png` to `ox_inventory/web/images`