-- Global table to store entity states
local entityStates = {}
local mapConfig0 = Ext.Require('Maps/Map0.lua')
local mapConfig1 = Ext.Require('Maps/Map1.lua')
local helperFunctions = Ext.Require('HelperFunctions.lua')

local mapConfigs = {
    Map0 = mapConfig0,
    Map1 = mapConfig1,
    Map2 = mapConfig2
}
local selectedMapConfig = nil

Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
	Ext.Utils.Print("Level Loaded: " .. level)
	if level == "WLD_Main_A" then
        --Osi.UseSpell(Osi.GetHostCharacter(), 'Start_Game', Osi.GetHostCharacter())
        Ext.Utils.Print("Level Loaded: " .. level)
	elseif level == "TUT_Avernus_C" then
		Osi.UseSpell(Osi.GetHostCharacter(), 'Start_Game_Leave_Tut', Osi.GetHostCharacter())
	end
end)

-- CombatRoundStarted Listener
Ext.Osiris.RegisterListener("CombatRoundStarted", 2, "before", function(combatGuid, round)
    if not selectedMapConfig then
        Ext.Utils.Print("No map configuration selected.")
        return
    end

    Ext.Utils.Print("ROUND " .. tostring(round) .. " STARTING FOR COMBATGUID: " .. combatGuid)
    Ext.Utils.Print("ENTITYSTATES TABLE:")
    for cguid, state in pairs(entityStates) do
        local coords = "{" .. state.x .. ", " .. state.y .. ", " .. state.z .. "}"
        local allegiance = state.type or "Unknown"
        local targetIndex = state.currentTargetIndex or "N/A"
        Ext.Utils.Print("--------------------------------\n" ..
            "GUID: " .. cguid .. "\n" .. "currentTargetIndex: " .. targetIndex .. "\n" .. "Allegiance: " .. allegiance .. "\n" .. "Coords: " .. coords .. "\n" ..
            "--------------------------------")
    end
    Ext.Utils.Print("SPAWNING")
    local spawnInfo = selectedMapConfig.enemySpawns["Round " .. tostring(round)]
    if spawnInfo then
        for _, enemy in ipairs(spawnInfo) do
            Ext.Utils.Print("Spawning " .. enemy.enemyName .. " at coordinates: {" .. enemy.coords.x .. ", " .. enemy.coords.y .. ", " .. enemy.coords.z .. "}")
            local enemyID = CreateAt(Osi.GetTemplate(enemy.enemyName), enemy.coords.x, enemy.coords.y, enemy.coords.z, 0, 0, "")
            Osi.SetFaction(enemyID, selectedMapConfig.f_enemy)
            local x, y, z = Osi.GetPosition(enemyID)
            entityStates[enemyID] = {x = x, y = y, z = z, type = 'enemy', currentTargetIndex = 0}
        end
    else
        Ext.Utils.Print("No enemies to spawn this round.")
    end
end)

-- Listener for turn start
Ext.Osiris.RegisterListener("TurnStarted", 1, "before", function(characterGuid)
    Ext.Utils.Print("Turn has started for character: " .. characterGuid)
    local factionID = Osi.GetFaction(characterGuid)
    local trimmedFactionID = factionID:gsub("^Evil NPC_", "")
    if trimmedFactionID == selectedMapConfig.f_enemy then
        Ext.Utils.Print('Adding into characterTargers')
        local currentTargetIndex = 0  -- Default value
        if entityStates[characterGuid] then
            currentTargetIndex = entityStates[characterGuid].currentTargetIndex  -- Keep existing value otherwise
        else
            Ext.Utils.Print('no entry maybe')
        end
        local movementLeft = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
        local currentX, currentY, currentZ = Osi.GetPosition(characterGuid)
        Ext.Utils.Print("Current Position: {" .. currentX .. ", " .. currentY .. ", " .. currentZ .. "}")
        
        while movementLeft > 0 do
            Ext.Utils.Print("starting loop again")
            local nextTarget = selectedMapConfig.targetPositions[currentTargetIndex+1]
            if nextTarget == nil then
                Ext.Utils.Print("num 1")
                Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
                Osi.Die(characterGuid)
                break
            end
            local distanceToTarget = Osi.GetDistanceToPosition(characterGuid, nextTarget.x, nextTarget.y, nextTarget.z)
            if  movementLeft > distanceToTarget then--will overshoot position, need to move to next position and repeat
                if currentTargetIndex < #selectedMapConfig.targetPositions then-- Move to the next target
                    currentTargetIndex = currentTargetIndex + 1
                    Ext.Utils.Print("Moving towards Target #" .. currentTargetIndex .. ": {" .. nextTarget.x .. ", " .. nextTarget.y .. ", " .. nextTarget.z .. "}")
                    Osi.CharacterMoveToPosition(characterGuid, nextTarget.x, nextTarget.y, nextTarget.z, '10', "", 1)
                end
                movementLeft = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
            else-- not enough movemet to carry on, breaking loop, added in this becausse of death before final spot issue
                if distanceToTarget > 20 then
                    Ext.Utils.Print("num 2")
                    Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
                    Osi.Die(characterGuid)
                end
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
        else
            local qx,qy,qz = Osi.GetPosition(characterGuid)
            entityStates[characterGuid] = {x = qx, y = qy, z = qz, type = 'enemy', currentTargetIndex = currentTargetIndex}
        end
    elseif not string.find(characterGuid, 'Player') then
        Osi.ApplyStatus(characterGuid, 'Ally_Generic', 10, 1, characterGuid)
    elseif string.find(characterGuid, 'Player') then
        Ext.Utils.Print("Player turn")
    end
end)

-- StatusApplied Listener
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(guid, status, causee, storyactionid)
    if status == 'Map0' then
        HandleStartGameMap(mapConfig)
    elseif status == 'Map1' then
        HandleStartGameMap(mapConfig)
    end
    local mapConfig = mapConfigs[status]
    if not mapConfig.exclude[status] then
        Ext.Utils.Print('Status applied: ' .. status .. ' to GUID: ' .. guid)
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
            local valueFromMapConfig = selectedMapConfig[variableName]

            if valueFromMapConfig then
                local ally_template = valueFromMapConfig
                Osi.Die(guid)
                local allyID = CreateAt(ally_template, spawnX, spawnY + 3, spawnZ, 0, 0, "")
                Osi.SetFaction(allyID, selectedMapConfig.f_ally)
                local currentCombat = Osi.CombatGetGuidFor(Osi.GetHostCharacter())
                if currentCombat then
                    Osi.SetCombatGroupID(allyID, currentCombat)
                end
                local x, y, z = Osi.GetPosition(allyID)
                entityStates[allyID] = {x = x, y = y, z = z, type = 'ally', currentTargetIndex = 'No Move'}
            else
                Ext.Utils.Print('No value found in selectedMapConfig for key: ' .. tostring(variableName))
            end
        end
    elseif status == "Upgrade_Weaponholder_Status" then
        Ext.Utils.Print('nice')
        Ext.Utils.Print('player guid:' .. Osi.GetHostCharacter())
        Ext.Utils.Print('guid:' ..guid)
        Ext.Utils.Print('template version of guid: ' .. Osi.GetTemplate(guid))
        --equipmentHandling(Osi.GetTemplate(guid), "d1082e88-b1e2-479d-913f-1413784d95a1")
        equipmentHandling(Osi.GetHostCharacter(), "d1082e88-b1e2-479d-913f-1413784d95a1")
    elseif status == "DYING" then
        local entityState = entityStates[guid]
        if entityState then
            local currentIndex = entityState.currentTargetIndex
            local positions = selectedMapConfig.targetPositions
            local lastPositionIndex = #positions - 1 -- Get the index of the last position in the array (sub by 1 since last position is far not intended to reach)

            -- Debugging outputs
            Ext.Utils.Print('Current Index: ' .. tostring(currentIndex))
            Ext.Utils.Print('Last Position Index: ' .. tostring(lastPositionIndex))
            Ext.Utils.Print('Current Entity Position: {' .. entityState.x .. ', ' .. entityState.y .. ', ' .. entityState.z .. '}')

            -- Check if the current index matches the last index in the target positions
            if currentIndex == lastPositionIndex then
                -- Entity has reached the final position
                Ext.Utils.Print('Entity reached final position before dying.')
            else
                -- Entity did not reach the final position and died
                Ext.Utils.Print('Entity did not reach final position and was likely killed by a friendly unit. Regaining siege point.')
                Osi.UseSpell(Osi.GetHostCharacter(), 'Regain_SiegePoint', Osi.GetHostCharacter())
            end
            entityStates[guid] = nil
            Ext.Utils.Print('Entity state removed for GUID: ' .. guid)
        else
            Ext.Utils.Print('Doesnt exist in entity states, not deleted | GUID: ' .. guid)
        end
    elseif status == "Debug_Fake_Status" then
        local x, y, z = Osi.GetPosition(guid)
        Ext.Utils.Print('Guid of summoned object: ' .. guid)
        Ext.Utils.Print("local targetPosition1 = {" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "}")
        Ext.Utils.Print("local targetPosition2 = {x = " .. tostring(x) .. ", y = " .. tostring(y) .. ", z = " .. tostring(z) .. "}")
        Osi.AddGold(Osi.GetHostCharacter(), 1000)
    elseif status == "Debug_Spawn_Enemy_Status" then
        local spawnX, spawnY, spawnZ = Osi.GetPosition(guid)
        Osi.Die(guid)
        local debugID = CreateAt(selectedMapConfig.DEBUG_ENEMY, spawnX, spawnY + 3, spawnZ, 0, 0, "")
        Osi.SetFaction(debugID, selectedMapConfig.f_enemy)
        local x, y, z = Osi.GetPosition(debugID)
        debugID = 'debug_Goblins_Female_Caster_' .. debugID --if i ever have a problem with this, note how i change debugID after setting id and getting position
        entityStates[debugID] = {x = x, y = y, z = z, type = 'enemy', currentTargetIndex = 0}
    elseif status == "LeaveTut" then
        Osi.TeleportToPosition(guid, -84.692207336426, 19.01319694519, -387.45742797852, "", 1, 1, 1, 1, 1)
    elseif status == 'Map0' then
        HandleStartGameMap(mapConfig)
    elseif status == 'Map1' then
        HandleStartGameMap(mapConfig)
    end
end)


------------------ functions ------------------------
-- Function to handle startgame status
function HandleStartGameMap(mapConfig)
    selectedMapConfig = mapConfig
    Ext.Utils.Print("Selected Map Config: " .. tostring(selectedMapConfig))
    Osi.TeleportToPosition(Osi.GetHostCharacter(), mapConfig.player_tp[1], mapConfig.player_tp[2], mapConfig.player_tp[3], "", 1, 1, 1, 1, 1)
    local lx, ly, lz = mapConfig.Crate1[1], mapConfig.Crate1[2], mapConfig.Crate1[3]
    squirrelID = Osi.CreateAt(Osi.GetTemplate("S_DEN_Squirrel_35ed8eab-1e0b-4ec8-92f2-1b8510cb3ad8"), lx, ly, lz, 0, 1, "")
    new_item_left = Osi.CreateAt(mapConfig.CRATE, lx, ly, lz, 0, 1, "")
    last_item_left = PlaceBoxes(new_item_left, mapConfig.placements_left, mapConfig)

    local rx, ry, rz = mapConfig.Crate2[1], mapConfig.Crate2[2], mapConfig.Crate2[3]
    new_item_right = Osi.CreateAt(mapConfig.CRATE, rx, ry, rz, 0, 1, "")
    last_item_right = PlaceBoxes(new_item_right, mapConfig.placements_right, mapConfig)

    local initialID = CreateAt(mapConfig.DEBUG_ENEMY, 218.16305, 16.377229, 319.40869, 0,0,"")
    Osi.SetFaction(initialID, mapConfig.f_enemy)
    local x, y, z = Osi.GetPosition(initialID)
    --add eneity name to guid
    initialID = 'debug_Goblins_Female_Caster_' .. initialID
    entityStates[initialID] = {x = x, y = y, z = z, type = 'enemy', currentTargetIndex = 0}
    Osi.UseSpell(Osi.GetHostCharacter(), 'Siege_Points_Setup', Osi.GetHostCharacter())
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



function DelayedCall(ms, func)
    if ms == 0 then func() return end
    local Time = 0
    local handler
    handler = Ext.Events.Tick:Subscribe(function(e)
        Time = Time + e.Time.DeltaTime * 1000
        if (Time >= ms) then
            func()
            Ext.Events.Tick:Unsubscribe(handler)
        end
    end)
end


-- equips a character with an armor
--@param character string
--@param mapkey string - mapkey
function equipmentHandling(character, mapkey)
    -- Ensure equiping is initialized
    if equiping == nil then
        equiping = {}
    end

    table.insert(equiping, {character = character, mapkey = mapkey})

    -- First we have to spawn an item in with the Mapkey 
    Osi.TemplateAddTo(mapkey, character, 1)

    -- Delay since the function might be too fast for the item to get added
    DelayedCall(100, function()
        for _, entry in pairs(equiping) do
            character = entry.character
            mapkey = entry.mapkey
            -- Then we have to get the actual id
            _P("local uuid = Osi.GetItemByTemplateInInventory(", mapkey, ", ", character, ")")
            local uuid = Osi.GetItemByTemplateInInventory(mapkey, Osi.GetHostCharacter())
            _P("Id of spawned item is ", uuid)

            -- Then we can equip
            Osi.Equip(character, uuid)
        end
    end)

    -- TODO: After that, we probably should destroy unused ones, or give the player a button or something
end