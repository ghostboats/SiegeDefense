
-- Global table to store entity states
PersistentVars = PersistentVars or {}
local hf = Ext.Require('HelperFunctions.lua')
local mapConfig0 = Ext.Require('Maps/Map0.lua')
local currentMapInfo = {}
local entitiesTable = {}

-- Register a listener for the network message from the client
Ext.RegisterNetListener("UpdateSiegeDefenseMode", function(channel, payload, user)
    Ext.Utils.Print("Server received message: " .. payload)
    local data = Ext.Json.Parse(payload)
    PersistentVars.siegeDefenseEnabled = data.state
    Ext.Utils.Print("Server updated siegeDefenseModeEnabled: " .. tostring(PersistentVars.siegeDefenseEnabled))
end)

Ext.RegisterNetListener("MapSelected", function(channel, payload, user)
    Ext.Utils.Print("Server received map selection: " .. payload)
    local data = Ext.Json.Parse(payload)
    local selectedMap = data.mapName
    Ext.Utils.Print("Selected map: " .. selectedMap)
    if selectedMap == 'MapName0' then
        Osi.PROC_DEBUG_TeleportToAct('act1')
        currentMapInfo = mapConfig0
    end
end)

-- LevelLoaded Listener
Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
    Ext.Utils.Print("Level Loaded: " .. level)
    if level == "TUT_Avernus_C" and (PersistentVars.siegeDefenseEnabled == nil or PersistentVars.siegeDefenseEnabled == false) then
        Osi.UseSpell(Osi.GetHostCharacter(), 'Start_Game_Check', Osi.GetHostCharacter())
    end
    if PersistentVars.siegeDefenseEnabled == nil or PersistentVars.siegeDefenseEnabled == false then
        Ext.Utils.Print("Siege defense setting not enabled on this save, not loading anything related to it to keep save safe.")
        return
    end
    if level == 'WLD_Main_A' and currentMapInfo then
        hf.HandleStartGameMap(Osi.GetHostCharacter(), currentMapInfo)
    end
    Ext.Utils.Print("testiong")
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    if spell == "Start_Game_Check" then
        Ext.Net.BroadcastMessage("EnableMod", Ext.Json.Stringify(PersistentVars.siegeDefenseEnabled))
    end
end)

-- Restore PersistentVars on session load
function OnSessionLoaded()
    PersistentVars = PersistentVars or {}
    Ext.Utils.Print("Session Loaded, PersistentVars.siegeDefenseEnabled: " .. tostring(PersistentVars.siegeDefenseEnabled))
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)


Ext.Osiris.RegisterListener('EnteredCombat', 2, 'after', function(object, combatGuid)
    Ext.Utils.Print(object .. " entered combat: " .. combatGuid)
end)



















Ext.Osiris.RegisterListener("CombatRoundStarted", 2, "before", function(combatGuid, round)
    Ext.Utils.Print("ROUND " .. tostring(round) .. " STARTING FOR COMBATGUID: " .. combatGuid)
    Ext.Utils.Print("entitiesTable:")
    for cguid, state in pairs(entitiesTable) do
        local coords = "{" .. state.x .. ", " .. state.y .. ", " .. state.z .. "}"
        local allegiance = state.type or "Unknown"
        local targetIndex = state.currentTargetIndex or "N/A"
        Ext.Utils.Print("--------------------------------\n"..
                        "GUID: "..cguid.."\n".."currentTargetIndex: "..targetIndex.."\n".."Allegiance: "..allegiance.."\n".."Coords: "..coords.."\n"
                        .."--------------------------------")
    end
    Ext.Utils.Print("SPAWNING")
    -- Check if there are enemies to spawn this round
    local spawnInfo = currentMapInfo.enemySpawns["Round " .. tostring(round)] -- for descriptive keys
    -- local spawnInfo = currentMapInfo.enemySpawns[round] -- for numeric indices
    if spawnInfo then
        for _, enemy in ipairs(spawnInfo) do
            Ext.Utils.Print("Spawning " .. enemy.enemyName .. " at coordinates: {" .. enemy.coords.x .. ", " .. enemy.coords.y .. ", " .. enemy.coords.z .. "}")
            local enemyID = CreateAt(Osi.GetTemplate(enemy.enemyName), enemy.coords.x, enemy.coords.y, enemy.coords.z, 0,0,"")
            Osi.SetFaction(enemyID, currentMapInfo.f_enemy)
            local x, y, z = Osi.GetPosition(enemyID)
            entitiesTable[enemyID] = {x = x, y = y, z = z, type = 'enemy', currentTargetIndex = 0}
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
    if trimmedFactionID == currentMapInfo.f_enemy then
        Ext.Utils.Print('Adding into characterTargers')
        local currentTargetIndex = 0  -- Default value
        if entitiesTable[characterGuid] then
            currentTargetIndex = entitiesTable[characterGuid].currentTargetIndex  -- Keep existing value otherwise
        else
            Ext.Utils.Print('no entry maybe')
        end
        local movementLeft = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
        local currentX, currentY, currentZ = Osi.GetPosition(characterGuid)
        Ext.Utils.Print("Current Position: {" .. currentX .. ", " .. currentY .. ", " .. currentZ .. "}")
        
        while movementLeft > 0 do
            Ext.Utils.Print("starting loop again")
            local nextTarget = currentMapInfo.targetPositions[currentTargetIndex+1]
            if nextTarget == nil then
                Ext.Utils.Print("num 1")
                Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
                Osi.Die(characterGuid)
                break
            end
            local distanceToTarget = Osi.GetDistanceToPosition(characterGuid, nextTarget.x, nextTarget.y, nextTarget.z)
            if  movementLeft > distanceToTarget then--will overshoot position, need to move to next position and repeat
                if currentTargetIndex < #currentMapInfo.targetPositions then-- Move to the next target
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
        for guid, state in pairs(entitiesTable) do
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
            entitiesTable[characterGuid] = {x = qx, y = qy, z = qz, type = 'enemy', currentTargetIndex = currentTargetIndex}
        else
            local qx,qy,qz = Osi.GetPosition(characterGuid)
            entitiesTable[characterGuid] = {x = qx, y = qy, z = qz, type = 'enemy', currentTargetIndex = currentTargetIndex}
        end
    elseif not string.find(characterGuid, 'Player') then
        Osi.ApplyStatus(characterGuid, 'Ally_Generic', 10, 1, characterGuid)
    elseif string.find(characterGuid, 'Player') then
        Ext.Utils.Print("Player turn")
    end
end)



------------------ functions ------------------------
-- Function to handle startgame status



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