--Ext.Osiris.RegisterListener("CastedSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)end)

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
        local targetIndex = state.currentTargetIndex or "N/A"
        Ext.Utils.Print("--------------------------------\n"..
                        "GUID: "..cguid.."\n".."currentTargetIndex: "..targetIndex.."\n".."Allegiance: "..allegiance.."\n".."Coords: "..coords.."\n"
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
                Osi.Die(guid)
                local allyID = CreateAt(ally_template, spawnX, spawnY + 3, spawnZ, 0, 0, "")
                siegePoints = siegePoints - 1
                Osi.SetFaction(allyID, mapConfig0.f_ally)
                Osi.SetCombatGroupID(allyID, Osi.CombatGetGuidFor(Osi.GetHostCharacter()))
                local x, y, z = Osi.GetPosition(allyID)
                entityStates[allyID] = {x = x, y = y, z = z, type = 'ally', currentTargetIndex = 'No Move'}
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
        Osi.Die(guid)
        local debugID = CreateAt(mapConfig0.DEBUG_ENEMY, spawnX, spawnY + 3, spawnZ, 0, 0, "")
        Osi.SetFaction(debugID, mapConfig0.f_enemy)
        local x, y, z = Osi.GetPosition(debugID)
        entityStates[debugID] = {x = x, y = y, z = z, type = 'enemy'}
    elseif status == "DYING" then
        local x, y, z = Osi.GetPosition(guid)
        local lastPosition = mapConfig0.targetPositions[#mapConfig0.targetPositions] -- Get the last position in the array
        local distanceToLast = Osi.GetDistanceToPosition(guid, lastPosition.x, lastPosition.y, lastPosition.z)
        local hasStatus = Osi.GetStatusCurrentLifetime(guid, 'Siege_Point_Recovery_Block')
        Ext.Utils.Print(hasStatus)
        if hasStatus >= 1 then
            Ext.Utils.Print('hasStatus >= 1')


        end
        --adjust state value for character aka delete it now that its dying.
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
            local mephitID = CreateAt(Osi.GetTemplate("S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6"), mapConfig.enemy_spawn1[1], mapConfig.enemy_spawn1[2], mapConfig.enemy_spawn1[3], 0,0,"")
            Osi.SetFaction(mephitID, mapConfig0.f_enemy)
            local x, y, z = Osi.GetPosition(mephitID)
            entityStates[mephitID] = {x = x, y = y, z = z, type = 'enemy', currentTargetIndex = 'initial'}
        end
    elseif trimmedFactionID == mapConfig0.f_enemy then
        Ext.Utils.Print('Adding into characterTargers')
        local currentTargetIndex = entityStates[characterGuid] and entityStates[characterGuid].currentTargetIndex or 0
        local movementLeft = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
        local currentX, currentY, currentZ = Osi.GetPosition(characterGuid)
        Ext.Utils.Print("Current Position: {" .. currentX .. ", " .. currentY .. ", " .. currentZ .. "}")
        while movementLeft > 0 do
            local nextTarget = mapConfig0.targetPositions[currentTargetIndex+1]
            if nextTarget == nil then
                Osi.ApplyStatus(characterGuid, 'Siege_Point_Recovery_Block', 10, 1, characterGuid)
                Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
                Osi.Die(characterGuid)
                break
            end
            local distanceToTarget = Osi.GetDistanceToPosition(characterGuid, nextTarget.x, nextTarget.y, nextTarget.z)
            if  movementLeft > distanceToTarget then--will overshoot position, need to move to next position and repeat
                if currentTargetIndex < #mapConfig0.targetPositions then-- Move to the next target
                    currentTargetIndex = currentTargetIndex + 1
                    Ext.Utils.Print("Moving towards Target #" .. currentTargetIndex .. ": {" .. nextTarget.x .. ", " .. nextTarget.y .. ", " .. nextTarget.z .. "}")
                    Osi.CharacterMoveToPosition(characterGuid, nextTarget.x, nextTarget.y, nextTarget.z, '10', "", 1)
                else
                    -- When final destination is reached
                    Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
                    Osi.Die(characterGuid)
                    break
                end
                movementLeft = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
            else-- not enough movemet to carry on, breaking loop
                break
            end
        end

        local x,y,z = Osi.GetPosition(characterGuid)
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
            local qx,qy,qz = Osi.GetPosition(characterGuid)
            --always saves start pos not end pos. use index for loc info.
            entityStates[characterGuid] = {x = qx, y = qy, z = qz, type = 'enemy', currentTargetIndex = currentTargetIndex}
        end
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

    Osi.SetFaction(CreateAt(mapConfig.DEBUG_ENEMY, 218.16305, 16.377229, 319.40869, 0,0,""), mapConfig.f_enemy)
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