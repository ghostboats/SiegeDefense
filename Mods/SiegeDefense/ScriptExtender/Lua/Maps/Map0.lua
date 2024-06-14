local map0 = {}

---------------------- Debug Stuff ----------------------
map0.DEBUG_ENEMY = 'debug_Goblins_Female_Caster_451ba53a-9070-4d9e-b7f8-6322b64277ea'
map0.INITIAL = 'S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6'
map0.exclude = {
    ["Spawn_Ally"] = false,
    ["Map0"] = false,
    ["LeaveTut"] = false,
    ["Debug_Spawn_Enemy_Status"] = false,
    ["DYING"] = false,
    ["Debug_Fake_Status"] = false,
    ["TEMPORARILY_HOSTILE"] = true,
    ["INSURFACE"] = true,
    ["Ally_Generic"] = true,
    ["HEAL"] = true
}

------------------------ Ally RT ------------------------
------------------------ Goblins ------------------------
map0.GOB_RAN = 'SD_Goblins_Male_Ranger_d9990b6e-c7c0-4534-aee5-12540d8ff44f'
map0.GOB_CAS = 'SD_Goblins_Female_Caster_bdb41598-98a3-44dd-a287-6c8882ea0441'

map0.SKE_RAN = 'Undead_Skeleton_Ranger_4f45e5ab-b93c-4afd-8a21-9c87d653d4b8'
map0.SKE_MEL = 'Undead_Skeleton_Melee_145fc868-9353-4ef1-8a1d-419fe96533fb'

map0.MEP_MUD = 'SD_Mephit_Mud_A_18431c73-c15e-45e3-b6c0-323b1137acb9'

------------------------ Faction ------------------------
map0.f_enemy = '64321d50-d516-b1b2-cfac-2eb773de1ff6'
map0.f_ally = '6545a015-1b3d-66a4-6a0e-6ec62065cdb7'

---------------------- Coordinates ----------------------
map0.MAP_0 = {224.95590209961,16.6357421875,324.15930175781}
map0.enemy_spawn1 = {218.16305541992, 16.377229690552, 319.40869140625}
map0.Crate1 = {220.62478637695,15.830078125,322.23071289062}
map0.Crate2 = {220.62478637695,15.830078125,317.23071289062}

----------------------- Object RT -----------------------
map0.CRATE = "97cdac50-9435-4174-b3bc-fe16fad7b169"

map0.enemySpawns = {
    ["Round 1"] = {
    --    {enemyName = "S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6", coords = {x = 218.16305541992, y = 16.377229690552, z = 319.40869140625}},
        {enemyName = "S_UND_GnomeWorkerQuiet_Trapped_56f89b9d-c9f7-45ff-9159-12e770cbb0a6", coords = {x = 218.16305541992, y = 16.377229690552, z = 319.40869140625}},
    },
    ["Round 2"] = {
        {enemyName = "S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6", coords = {x = 218.16305541992, y = 16.377229690552, z = 319.40869140625}},
    --    {enemyName = "S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6", coords = {x = 218.16305541992, y = 16.377229690552, z = 319.40869140625}},
    --    {enemyName = "S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6", coords = {x = 218.16305541992, y = 16.377229690552, z = 319.40869140625}},
    },
    -- Add more rounds as necessary
}

-- Define an array of target positions
map0.targetPositions = {
    {x = 226.49760437012, y = 16.8076171875, z = 319.62942504883},
    {x = 226.82446289062, y = 16.294921875, z = 314.53106689453},
    {x = 228.50514221191, y = 17.233882904053, z = 314.84921264648},
    {x = 231.50514221191, y = 17.233882904053, z = 314.84921264648},
    {x = 236.56643676758, y = 17.2421875, z = 314.7282409668},
    {x = 237.89315795898, y = 17.375, z = 322.44702148438},
    {x = 242.06414794922, y = 16.872695922852, z = 323.54721069336},
    {x = 247.55337524414, y = 16.945487976074, z = 323.60067749023},
    {x = 247.86380004883, y = 16.833940505981, z = 317.37200927734},
    {x = 243.72398376465, y = 17.106002807617, z = 316.67788696289},
    {x = 242.19059753418, y = 18.058263778687, z = 312.05377197266},
    {x = 242.19059753418, y = 18.058263778687, z = 340.05377197266}
}

-- Placing boxes with multiple directions and distances
map0.placements_left = {
    {direction = 'east', distance = 8, height = 4},
    {direction = 'south', distance = 5, height = 4},
    {direction = 'east', distance = 6, height = 4},
    {direction = 'north', distance = 8, height = 4},
    {direction = 'east', distance = 15, height = 4},
    {direction = 'south', distance = 11, height = 4},
    {direction = 'west', distance = 4, height = 4},
    {direction = 'south', distance = 2, height = 4},
}

map0.placements_right = {
    {direction = 'east', distance = 3, height = 4},
    {direction = 'south', distance = 5, height = 4},
    {direction = 'east', distance = 16, height = 4},
    {direction = 'north', distance = 8, height = 4},
    {direction = 'east', distance = 6, height = 4},
    {direction = 'south', distance = 1, height = 4},
    {direction = 'west', distance = 5, height = 4},
    {direction = 'south', distance = 12, height = 4},
}

return map0