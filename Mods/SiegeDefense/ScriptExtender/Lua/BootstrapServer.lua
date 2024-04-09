--Ext.Osiris.RegisterListener("CastedSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)end)

-- Table to store the current target index for each character
local characterTargets = {}
-- Global table to store entity states
local entityStates = {}
local turnCount = 2
local siegePoints = 5
local mapConfig0 = Ext.Require('Maps/Map0.lua')

-- LevelLoaded Listener
Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
	Ext.Utils.Print("Level Loaded: " .. level)
	if level == "WLD_Main_A" then
        Ext.Utils.Print('about to remove spells from host')
		Osi.RemoveSpell(Osi.GetHostCharacter(), "Start_Game_Leave_Tut", 0)
		Osi.OpenMessageBox(Osi.GetHostCharacter(), "level loaded wld main a")
        Osi.UseSpell(Osi.GetHostCharacter(), 'Start_Game', Osi.GetHostCharacter())
	elseif level == "TUT_Avernus_C" then
		Osi.AddSpell(Osi.GetHostCharacter(), "Start_Game_Leave_Tut", 1, 0) 
	end
end)

Ext.Osiris.RegisterListener("CombatRoundStarted", 2, "before", function(combatGuid, round)
    Ext.Utils.Print("ROUND " .. tostring(round) .. " STARTING FOR COMBATGUID: " .. combatGuid)
    Ext.Utils.Print("ENTITYSTATES TABLE:")
    for cguid, state in pairs(entityStates) do
        local coords = "{" .. state.x .. ", " .. state.y .. ", " .. state.z .. "}"
        local allegiance = state.type or "Unknown"
        Ext.Utils.Print("--------------------------------\n"..
                        "GUID: "..cguid.."\n".."Coords: " .. coords .. "\n" .."Allegiance: "..allegiance.."\n"
                        .."--------------------------------")
    end
end)


-- StatusApplied Listener
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(guid, status, causee, storyactionid)
    if not mapConfig0.exclude[status] then
        Ext.Utils.Print('Status applied: '.. status)
    end
    if string.find(status, 'Spawn_Ally') then
        local spawnX, spawnY, spawnZ = Osi.GetPosition(guid)
        local parts = {}
        for part in string.gmatch(status, "[^_]+") do
            table.insert(parts, part)
        end

        if #parts >= 4 then--get & summon ally from name of RT mapkey variable in Map{#}.lua
            local part3 = parts[3]:sub(1, 3):upper()
            local part4 = parts[4]:sub(1, 3):upper()
            local variableName = part3 .. "_" .. part4
            local valueFromMapConfig0 = mapConfig0[variableName]

            if valueFromMapConfig0 then
                local ally_template = valueFromMapConfig0
                Osi.RemovePassive(guid, "DeathRewards")
                Osi.Die(guid)
                local allyID = CreateAt(ally_template, spawnX, spawnY + 3, spawnZ, 0, 0, "")
                siegePoints = siegePoints - 1
                Osi.SetFaction(allyID, mapConfig0.f_ally)
                --Osi.SetCombatGroupAndEnterCombat(allyID, Osi.CombatGetGuidFor(Osi.GetHostCharacter()),)
                Osi.SetCombatGroupID(allyID, Osi.CombatGetGuidFor(Osi.GetHostCharacter()))
                ---enabled integer
                ---function Osi.SetCanJoinCombat(entity, enabled) end
                local x, y, z = Osi.GetPosition(allyID)
                entityStates[allyID] = {x = x, y = y, z = z, type = 'ally'}
            else
                Ext.Utils.Print('No value found in mapConfig0 for key: ' .. tostring(variableName))
            end
        end
	elseif status == "Map0" then
        HandleStartGameMap(guid, mapConfig0)
	elseif status == "LeaveTut" then
        Osi.TeleportToPosition(guid, -84.692207336426, 19.01319694519, -387.45742797852, "", 1, 1, 1, 1, 1)
    elseif status == "Debug_Spawn_Enemy_Status" then
        local spawnX, spawnY, spawnZ = Osi.GetPosition(guid)
        Osi.RemovePassive(guid, "DeathRewards")
        Osi.Die(guid)
        local debugID = CreateAt(mapConfig0.DEBUG_ENEMY, spawnX, spawnY + 3, spawnZ, 0, 0, "")
        Osi.SetFaction(debugID, mapConfig0.f_enemy)
        local x, y, z = Osi.GetPosition(debugID)
        entityStates[debugID] = {x = x, y = y, z = z, type = 'enemy'}
    elseif status == "DYING" then
        if Osi.HasPassive(guid, 'DeathRewards') == 1 then
            siegePoints = siegePoints + 1
            Ext.Utils.Print('Siege Points Rewarded, Current Count: '.. tostring(siegePoints))
            --adjust state value for character aka delete it now that its dying.
        end
    elseif status == "Debug_Fake_Status" then
        local x,y,z = Osi.GetPosition(guid)
        Ext.Utils.Print('Guid of summoned object: '..guid)
        Ext.Utils.Print("local targetPosition1 = {"..tostring(x)..","..tostring(y)..","..tostring(z).."}")
        Ext.Utils.Print("local targetPosition2 = {x = "..tostring(x)..", y = "..tostring(y)..", z = "..tostring(z).."}")
	end
end)

-- Listener for turn start
Ext.Osiris.RegisterListener("TurnStarted", 1, "before", function(characterGuid)
    Ext.Utils.Print("Turn has started for character: " .. characterGuid)
    local factionID = Osi.GetFaction(characterGuid)
    local trimmedFactionID = factionID:gsub("^Evil NPC_", "")
    if string.find(characterGuid, 'Squ') then
        if turnCount == 1 then
            local mephitID = CreateAt(Osi.GetTemplate("S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6"), 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
            Osi.SetFaction(mephitID, mapConfig0.f_enemy)
            local x, y, z = Osi.GetPosition(mephitID)
            entityStates[mephitID] = {x = x, y = y, z = z, type = 'enemy'}
        end
    elseif trimmedFactionID == mapConfig0.f_enemy then
        Ext.Utils.Print('Adding into characterTargers')
        if not characterTargets[characterGuid] then-- Create target index for new chars
            characterTargets[characterGuid] = 1
        end

        local currentTargetIndex = characterTargets[characterGuid]
        local movementLeft = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
        local currentX, currentY, currentZ = Osi.GetPosition(characterGuid)
        Ext.Utils.Print("Current Position: {" .. currentX .. ", " .. currentY .. ", " .. currentZ .. "}")
        while movementLeft > 0 do
            local currentTarget = mapConfig0.targetPositions[currentTargetIndex]
            local distanceToTarget = Osi.GetDistanceToPosition(characterGuid, currentTarget.x, currentTarget.y, currentTarget.z)
            if  movementLeft > distanceToTarget then--will overshoot position, need to move to next position and repeat
                if currentTargetIndex < #mapConfig0.targetPositions then-- Move to the next target
                    Ext.Utils.Print("Moving towards Target #" .. currentTargetIndex .. ": {" .. currentTarget.x .. ", " .. currentTarget.y .. ", " .. currentTarget.z .. "}")
                    Osi.CharacterMoveToPosition(characterGuid, currentTarget.x, currentTarget.y, currentTarget.z, '10', "", 1)
                    currentTargetIndex = currentTargetIndex + 1
                else
                    -- When final destination is reached
                    Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
                    Osi.Die(characterGuid)
                    break
                end
                movementLeft = movementLeft - distanceToTarget
            else-- not enough movemet to carry on, breaking loop
                break
            end
        end

        -- Update the target index in the table
        characterTargets[characterGuid] = currentTargetIndex
        local x,y,z = Osi.GetPosition(characterGuid)

        -- Find the closest ally entity
        local closestAllyGUID = nil
        local minDistance = math.huge
        for guid, state in pairs(entityStates) do
            if state.type == 'ally' and guid ~= characterGuid then
                local distance = math.sqrt((x - state.x)^2 + (y - state.y)^2 + (z - state.z)^2)
                if distance < minDistance then
                    minDistance = distance
                    closestAllyGUID = guid
                end
            end
        end

        -- Attack the closest ally entity
        if closestAllyGUID then
            Ext.Utils.Print("Character " .. characterGuid .. " is attacking closest ally: " .. closestAllyGUID)
            Osi.Attack(characterGuid, closestAllyGUID, 1)
        end
        entityStates[characterGuid] = {x = x, y = y, z = z, type = 'enemy'}
        Ext.Utils.Print("Entity state updated: GUID=" .. characterGuid .. ", Position={" .. x .. ", " .. y .. ", " .. z .. "}")
    elseif not string.find(characterGuid, 'Player') then
        Osi.ApplyStatus(characterGuid, 'Ally_Generic', 10, 1, characterGuid)
    elseif string.find(characterGuid, 'Player') then
        turnCount = turnCount + 1
    end
end)

------------------ functions ------------------------
-- Function to handle startgame status
function HandleStartGameMap(guid, mapConfig)
    Osi.TeleportToPosition(guid, mapConfig.MAP_0[1], mapConfig.MAP_0[2], mapConfig.MAP_0[3], "", 1, 1, 1, 1, 1)
    local lx, ly, lz = mapConfig.Crate1[1], mapConfig.Crate1[2], mapConfig.Crate1[3]
    squirrelID = Osi.CreateAt(Osi.GetTemplate("S_DEN_Squirrel_35ed8eab-1e0b-4ec8-92f2-1b8510cb3ad8"), lx, ly, lz, 0, 1, "")
    new_item_left = Osi.CreateAt(mapConfig.CRATE, lx, ly, lz, 0, 1, "")
    last_item_left = PlaceBoxes(new_item_left, mapConfig.placements_left, mapConfig)

    local rx, ry, rz = mapConfig.Crate2[1], mapConfig.Crate2[2], mapConfig.Crate2[3]
    new_item_right = Osi.CreateAt(mapConfig.CRATE, rx, ry, rz, 0, 1, "")
    last_item_right = PlaceBoxes(new_item_right, mapConfig.placements_right, mapConfig)

    local initialID = CreateAt("debug_Goblins_Female_Caster_451ba53a-9070-4d9e-b7f8-6322b64277ea", 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
    Osi.SetFaction(initialID, mapConfig.f_enemy)

    local x, y, z = Osi.GetPosition(initialID)
    entityStates[initialID] = {x = x, y = y, z = z, type = 'enemy'}
end

function PlaceBoxes(item, placements, mapConfig)
    local new_item = item
    local first_row_last_item = nil
    local x, y, z = Osi.GetPosition(new_item)

    for _, placement in ipairs(placements) do
        local direction = placement.direction or "east"
        local distance = placement.distance or 0
        local height = placement.height or 1

        for current_height = 0, height - 1 do
            for current_distance = 1, distance do
                if direction == 'north' then
                    new_item = Osi.CreateAt(mapConfig.CRATE, x, y + current_height, z + current_distance, 0, 1, "")
                elseif direction == 'east' then
                    new_item = Osi.CreateAt(mapConfig.CRATE, x + current_distance, y + current_height, z, 0, 1, "")
                elseif direction == 'south' then
                    new_item = Osi.CreateAt(mapConfig.CRATE, x, y + current_height, z - current_distance, 0, 1, "")
                elseif direction == 'west' then
                    new_item = Osi.CreateAt(mapConfig.CRATE, x - current_distance, y + current_height, z, 0, 1, "")
                end

                if current_height == 0 and current_distance == distance then-- Storing last item of first row
                    first_row_last_item = new_item
                end
            end
            Ext.Utils.Print('Row Created At Height: ' .. tostring(current_height) .. '    Direction: ' .. direction)
        end
        -- Update x, y, z for the next placement
        x, y, z = Osi.GetPosition(first_row_last_item)
    end

    return first_row_last_item
end


function sleep(seconds)
    local start = os.time()
    repeat until os.time() > start + seconds
end