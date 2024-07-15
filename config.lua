Config = {}

Config.Framework = 'qb' -- 'qb', 'esx'

Config.Inventory = 'ox_inventory' -- 'qb-inventory', 'lj-inventory', 'ps-inventory', 'ox_inventory'

Config.Target = 'ox_target' -- 'qb-target', 'ox_target'

Config.ChopShopPed = false

Config.ChopShopPeds = {
    {
        model = `g_m_y_mexgoon_03`,
        coords = vector4(2342.21, 3055.63, 47.15, 162.86),
        scenario = 'WORLD_HUMAN_SMOKING'
    }
}

Config.ChopShopLocations = {
    vector3(2340.49, 3052.32, 48.15),
}

Config.MoneyType = 'cash' -- 'cash', 'dirtymoney'
Config.MoneyReward = { 3500, 6500 }

Config.RewardItems = {
    { item = "metalscrap", amount = { 20, 50 } },
    { item = "plastic", amount = { 20, 50 } },
    { item = "copper", amount = { 20, 50 } },
    { item = "iron", amount = { 20, 50 } },
    { item = "aluminum", amount = { 20, 50 } },
    { item = "steel", amount = { 20, 50 } },
    { item = "glass", amount = { 20, 50 } }
}

Config.Cooldown = 20

Config.Vehicles= {
    "fugitive", "surge", "sultan", "asea", "premier", "baller", "blista", "panto", "prairie",
    "rhapsody", "cogcabrio", "felon", "oracle", "sentinel", "blade", "buccaneer", "chino", "dominator", "dukes",
    "faction", "gauntlet", "moonbeam", "ratloader", "stalion", "tampa", "voodoo", "sandking", "rancherxl", "xls",
    "rocoto", "serrano", "cognoscenti", "emperor", "ingot", "regina", "surge", "primo", "comet", "carbonizzare",
    "banshee", "coquette", "futo", "jester", "massacro", "ninef", "schafter", "adder", "infernus", "voltic", "vacca",
    "sadler", "bison"
}

Config.Locations = {
    vector4( -2480.9, -212.0, 17.4, 90.0),
    vector4( -2723.4, 13.2, 15.1, 90.0),
    vector4( -3169.6, 976.2, 15.0, 90.0),
    vector4( -3139.8, 1078.7, 20.2, 90.0),
    vector4( -1656.9, -246.2, 54.5, 90.0),
    vector4( -1586.7, -647.6, 29.4, 90.0),
    vector4( -1036.1, -491.1, 36.2, 90.0),
    vector4( -1029.2, -475.5, 36.4, 90.0),
    vector4(75.2, 164.9, 104.7, 90.0),
    vector4( -534.6, -756.7, 31.6, 90.0),
    vector4(487.2, -30.8, 88.9, 90.0),
    vector4( -772.2, -1281.8, 4.6, 90.0),
    vector4( -663.8, -1207.0, 10.2, 90.0),
    vector4(719.1, -767.8, 24.9, 90.0),
    vector4( -971.0, -2410.4, 13.3, 90.0),
    vector4( -1067.5, -2571.4, 13.2, 90.0),
    vector4( -619.2, -2207.3, 5.6, 90.0),
    vector4(1192.1, -1336.9, 35.1, 90.0),
    vector4( -432.8, -2166.1, 9.9, 90.0),
    vector4( -451.8, -2269.3, 7.2, 90.0),
    vector4(939.3, -2197.5, 30.5, 90.0),
    vector4( -556.1, -1794.7, 22.0, 90.0),
    vector4(591.7, -2628.2, 5.6, 90.0),
    vector4(1654.5, -2535.8, 74.5, 90.0),
    vector4(1642.6, -2413.3, 93.1, 90.0),
    vector4(1371.3, -2549.5, 47.6, 90.0),
    vector4(383.8, -1652.9, 37.3, 90.0),
    vector4(27.2, -1030.9, 29.4, 90.0),
    vector4(229.3, -365.9, 43.8, 90.0),
    vector4( -85.8, -51.7, 61.1, 90.0),
    vector4( -4.6, -670.3, 31.9, 90.0),
    vector4( -111.9, 92.0, 71.1, 90.0),
    vector4( -314.3, -698.2, 32.5, 90.0),
    vector4( -366.9, 115.5, 65.6, 90.0),
    vector4( -592.1, 138.2, 60.1, 90.0),
    vector4( -1613.9, 18.8, 61.8, 90.0),
    vector4( -1709.8, 55.1, 65.7, 90.0),
    vector4( -521.9, -266.8, 34.9, 90.0),
    vector4( -451.1, -333.5, 34.0, 90.0),
    vector4(322.4, -1900.5, 25.8, 90.0),
    vector4( -2078.76, -331.44, 12.63, 90.0),
    vector4( -2949.47, 461.58, 14.7, 90.0),
    vector4( -2214.0, 4238.75, 47.0, 90.0),
    vector4( -356.99, 6067.1, 31.07, 90.0),
    vector4(1127.82, 2648.17, 37.49, 90.0),
    vector4(1869.78, 2557.07, 45.17, 90.0),
    vector4(1690.12, 3288.04, 40.64, 90.0),
    vector4(2058.21, 3887.32, 31.21, 90.0),
    vector4(2786.06, 3463.15, 54.91, 90.0),
    vector4(727.21, -208.16, 67.84, 90.0),
    vector4( -327.8, -2748.6, 6.02, 90.0),
    vector4(510.21, -3054.7, 6.07, 90.0),
    vector4(833.76, -1271.81, 26.28, 90.0),
    vector4(4.49, -1762.49, 29.3, 90.0),
    vector4(380.07, -739.98, 29.29, 90.0),
    vector4(178.47, -698.52, 33.13, 90.0),
    vector4(225.67, -776.58, 30.77, 90.0),
    vector4(236.73, -795.25, 30.5, 90.0),
    vector4( -1166.15, -888.1, 14.11, 90.0),
    vector4( -56.5, -1117.01, 26.44, 90.0),
    vector4(282.27, -327.14, 44.92, 90.0),
    vector4( -391.13, -122.16, 38.67, 90.0),
    vector4( -1329.0, -396.54, 36.45, 90.0),
    vector4(61.6, 19.35, 69.35, 90.0),
    vector4(362.87, 277.94, 103.25, 90.0),
    vector4(2774.65, 3471.37, 55.44, 90.0),
    vector4(2030.43, 3166.86, 45.24, 90.0),
    vector4(1245.01, 2713.15, 38.01, 90.0),
    vector4(627.56, 2731.54, 41.88, 90.0),
    vector4(1768.18, 3697.84, 34.21, 90.0),
    vector4(2150.18, 4797.54, 41.14, 90.0),
    vector4(2411.72, 4970.77, 46.11, 90.0),
    vector4(907.48, -54.72, 78.76, 90.0),
    vector4(880.41, -39.27, 78.76, 90.0),
    vector4( -723.8, -913.2, 19.01, 90.0),
    vector4( -1800.38, -1180.45, 13.02, 90.0),
    vector4( -1629.1, -888.81, 9.06, 90.0),
    vector4( -1643.01, -834.77, 9.99, 90.0),
    vector4( -1708.75, -899.46, 7.81, 90.0),
    vector4( -1737.96, -723.72, 10.45, 90.0),
    vector4( -2079.03, -335.51, 13.14, 90.0),
    vector4( -1510.41, 1490.02, 116.16, 90.0),
    vector4( -311.28, -757.9, 33.97, 90.0),
    vector4( -622.68, 201.27, 71.13, 90.0),
}
