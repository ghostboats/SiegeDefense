local map0 = {}

------------------------- Ally RT ----------------------
------------------------- Goblins ----------------------
map0.GOB_RAN = 'SD_Goblins_Male_Ranger_d9990b6e-c7c0-4534-aee5-12540d8ff44f'
map0.GOB_CAS = 'SD_Goblins_Female_Caster_bdb41598-98a3-44dd-a287-6c8882ea0441'

------------------ Coordinates and uuids ---------------
map0.MAP_0 = {224.95590209961,16.6357421875,324.15930175781}
map0.Crate1 = {220.62478637695,15.830078125,322.23071289062}
map0.Crate2 = {220.62478637695,15.830078125,317.23071289062}
map0.CRATE = "97cdac50-9435-4174-b3bc-fe16fad7b169"

-- Define an array of target positions
map0.targetPositions = {
    {x = 226.49760437012, y = 16.8076171875, z = 319.62942504883},
    {x = 226.82446289062, y = 16.294921875, z = 314.53106689453},
    {x = 231.50514221191, y = 17.233882904053, z = 314.84921264648},
    {x = 236.56643676758, y = 17.2421875, z = 314.7282409668},
    {x = 237.89315795898, y = 17.375, z = 322.44702148438},
    {x = 250.27450561523, y = 16.79296875, z = 322.64022827148}
}

-- Placing boxes with multiple directions and distances
map0.placements_left = {
    {direction = 'east', distance = 8, height = 5},
    {direction = 'south', distance = 5, height = 5},
    {direction = 'east', distance = 6, height = 5},
    {direction = 'north', distance = 8, height = 5},
    {direction = 'east', distance = 9, height = 5},
}

map0.placements_right = {
    {direction = 'east', distance = 3, height = 5},
    {direction = 'south', distance = 5, height = 5},
    {direction = 'east', distance = 16, height = 5},
    {direction = 'north', distance = 8, height = 5},
    {direction = 'east', distance = 4, height = 5},
}

return map0