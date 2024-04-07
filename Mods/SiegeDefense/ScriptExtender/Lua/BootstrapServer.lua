-- Table to store the current target index for each character
local characterTargets = {}
local turnCount = 0
local siegePoints = 5
local mapConfig0 = Ext.Require('Maps/Map0.lua')
-- LevelLoaded Listener
Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
	Ext.Utils.Print("Level Loaded: " .. level)
	if level == "WLD_Main_A" then
        Ext.Utils.Print('about to remove spells from host')
		Osi.RemoveSpell(Osi.GetHostCharacter(), "Start_Game_Leave_Tut", 0)
		Osi.OpenMessageBox(Osi.GetHostCharacter(), "level loaded wld main a")
	elseif level == "TUT_Avernus_C" then
		Osi.AddSpell(Osi.GetHostCharacter(), "Start_Game_Leave_Tut", 1, 0) 
	end
end)

-- StatusApplied Listener
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(guid, status, causee, storyactionid)
    Ext.Utils.Print('Status applied: '.. status)
    if string.find(status, 'Spawn_Ally') then
        local spawnX, spawnY, spawnZ = Osi.GetPosition(guid)
        local parts = {}
        for part in string.gmatch(status, "[^_]+") do
            table.insert(parts, part)
        end

        -- Check if we have enough parts to proceed
        if #parts >= 4 then
            -- Extracting first three characters of third and fourth parts and concatenating
            local part3 = parts[3]:sub(1, 3):upper()
            local part4 = parts[4]:sub(1, 3):upper()
            local variableName = part3 .. "_" .. part4

            -- Dynamically get the value from mapConfig0
            Ext.Utils.Print('variableName: ' .. tostring(variableName))
            local valueFromMapConfig0 = mapConfig0[variableName]

            -- Do something with the value
            if valueFromMapConfig0 then
                local ally_template = valueFromMapConfig0
                Osi.RemovePassive(guid, "DeathRewards")
                Ext.Utils.Print('#################Die 2')
                Osi.Die(guid)
                local goblinID = CreateAt(ally_template, spawnX, spawnY + 3, spawnZ, 0, 0, "")
                siegePoints = siegePoints - 1
                Osi.SetFaction(goblinID, '6545a015-1b3d-66a4-6a0e-6ec62065cdb7')
            else
                Ext.Utils.Print('No value found in mapConfig0 for key: ' .. tostring(variableName))
            end
        end
	elseif status == "Map0" then
        HandleStartGameMap(guid, mapConfig0)
	elseif status == "LeaveTut" then
		TeleportCharacter(guid, {-84.692207336426, 19.01319694519, -387.45742797852})
    elseif status == "Debug_Spawn_Enemy_Status" then
        local spawnX, spawnY, spawnZ = Osi.GetPosition(guid)
        Osi.RemovePassive(guid, "DeathRewards")
        Ext.Utils.Print('#################Die 2')
        Osi.Die(guid)
        local debugID = CreateAt('debug_Goblins_Female_Caster_451ba53a-9070-4d9e-b7f8-6322b64277ea', spawnX, spawnY + 3, spawnZ, 0, 0, "")
        Osi.SetFaction(debugID, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
    elseif status == "DYING" then
        if Osi.HasPassive(guid, 'DeathRewards') == 1 then
            siegePoints = siegePoints + 1
        end
	end
    Ext.Utils.Print('Siege Points: '.. tostring(siegePoints))
end)

-- Listener for turn start
Ext.Osiris.RegisterListener("TurnStarted", 1, "before", function(characterGuid)
    Ext.Utils.Print("Turn has started for character: " .. characterGuid)
    local factionID = Osi.GetFaction(characterGuid)
    Ext.Utils.Print("Faction ID for character: " .. factionID)
    if string.find(characterGuid, 'Squ') then
        Ext.Utils.Print("Current Turn: " .. tostring(turnCount))
        turnCount = 9
        if turnCount == 1 then
            local mephitID = CreateAt(Osi.GetTemplate("S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6"), 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
            Osi.SetFaction(mephitID, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
        elseif turnCount == 2 then
            local mephitID = CreateAt(Osi.GetTemplate("S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6"), 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
            Osi.SetFaction(mephitID, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
        elseif turnCount == 3 then
            local mephitID = CreateAt(Osi.GetTemplate("S_GOB_GoblinJolly_59557329-d49b-448b-bdd0-fd66ae0d67f6"), 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
            Osi.SetFaction(mephitID, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
        elseif turnCount == 4 then
            local golemID = CreateAt(GetTemplate("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255"), 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
            Osi.SetFaction(golemID, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
        end
    elseif factionID == 'Evil NPC_64321d50-d516-b1b2-cfac-2eb773de1ff6' then
        -- Initialize target index for new characters
        if not characterTargets[characterGuid] then
            characterTargets[characterGuid] = 1
        end

        local currentTargetIndex = characterTargets[characterGuid]
        local entityMovement = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
        local currentX, currentY, currentZ = Osi.GetPosition(characterGuid)

        -- Get the current target position and distance to position
        local target = mapConfig0.targetPositions[currentTargetIndex]
        local targetX = target.x
        local targetY = target.y
        local targetZ = target.z
        local distanceTo = Osi.GetDistanceToPosition(characterGuid, targetX, targetY, targetZ)

        -- Check if we're close enough to consider the target reached
        if distanceTo < entityMovement then
            -- Move to the next target
            currentTargetIndex = getNextTarget(characterGuid, currentTargetIndex)
            if currentTargetIndex == nil then
                Ext.Utils.Print('#################Die 3')
                Osi.Die(characterGuid)
                return -- All targets reached
            end
            target = mapConfig0.targetPositions[currentTargetIndex]
            targetX = target.x
            targetY = target.y
            targetZ = target.z
        end

        -- Calculate direction vector
        local directionX = targetX - currentX
        local directionZ = targetZ - currentZ

        -- Calculate the distance to the target
        local distanceToTarget = math.sqrt(directionX^2 + directionZ^2)

        -- Check if the distance is greater than the movement range
        if distanceToTarget > entityMovement then
            -- Scale the direction vector down to the entity's movement range
            local scale = entityMovement / distanceToTarget
            directionX = directionX * scale
            directionZ = directionZ * scale
        end

        -- Calculate new position
        local newX = currentX + directionX
        local newZ = currentZ + directionZ

        -- Update the target index in the table
        characterTargets[characterGuid] = currentTargetIndex

        -- Move the entity
        Osi.CharacterMoveToPosition(characterGuid, newX, currentY, newZ, '10', "", 1)
        Osi.Attack(characterGuid, Osi.GetHostCharacter(), 1)
    elseif not string.find(characterGuid, 'Player') then
        Osi.ApplyStatus(characterGuid, 'Ally_Generic', 10, 1, characterGuid)
    elseif string.find(characterGuid, 'Player') then
        turnCount = turnCount + 1
    end
end)

Ext.Osiris.RegisterListener("CastedSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)end)
------------------ functions ------------------------
-- Function to get the next target position
function getNextTarget(characterGuid, currentTargetIndex)
    if currentTargetIndex < #mapConfig0.targetPositions then
        return currentTargetIndex + 1
    else
        -- When final dest os reacjed
        --Osi.ApplyDamage(Osi.GetHostCharacter(), 1, 'Piercing')
        return nil
    end
end

-- Function to handle startgame status
function HandleStartGameMap(guid, mapConfig)
    TeleportCharacter(guid, mapConfig.MAP_0)
    local lx, ly, lz = mapConfig.Crate1[1], mapConfig.Crate1[2], mapConfig.Crate1[3]
    squirrelID = Osi.CreateAt(Osi.GetTemplate("S_DEN_Squirrel_35ed8eab-1e0b-4ec8-92f2-1b8510cb3ad8"), lx, ly, lz, 0, 1, "")
    new_item_left = Osi.CreateAt(mapConfig.CRATE, lx, ly, lz, 0, 1, "")
    last_item_left = PlaceBoxes(new_item_left, mapConfig.placements_left, mapConfig)

    local rx, ry, rz = mapConfig.Crate2[1], mapConfig.Crate2[2], mapConfig.Crate2[3]
    new_item_right = Osi.CreateAt(mapConfig.CRATE, rx, ry, rz, 0, 1, "")
    last_item_right = PlaceBoxes(new_item_right, mapConfig.placements_right, mapConfig)
--S_HAG_MudMephit_04_2a99e33a-cb96-40a0-bb8e-4a118719e794
    local initialID = CreateAt("debug_Goblins_Female_Caster_451ba53a-9070-4d9e-b7f8-6322b64277ea", 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
    Osi.SetFaction(initialID, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
end

function PlaceBoxes(item, placements, mapConfig)
    local new_item = item
    local last_first_row_item = nil  -- Variable to store the last item of the first row
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

                -- Storing the last item of the first row
                if current_height == 0 and current_distance == distance then
                    last_first_row_item = new_item
                end
            end
            Ext.Utils.Print('Row Created At Height: ' .. tostring(current_height) .. '    Direction: ' .. direction)
        end
        -- Update x, y, z for the next placement based on the last item of the first row
        x, y, z = Osi.GetPosition(last_first_row_item)
    end

    return last_first_row_item  -- Return the last item of the first row
end

function TeleportCharacter(character, pos)
	if character and pos and #pos == 3 then
		local x = pos[1]
		local y = pos[2]
		local z = pos[3]
		Osi.TeleportToPosition(character, x, y, z, "", 1, 1, 1, 1, 1)
	else
		Ext.Utils.Print("Error: Invalid parameters for teleportation.")
	end
end