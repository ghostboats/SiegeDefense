PersistentVars = {}

-------------- Coordinates for Teleport -----------
local TRANSPONDER_POS		=  {-84.692207336426, 19.01319694519, -387.45742797852}

--local MAP_0                 = {220.62478637695,15.830078125,322.23071289062}
local MAP_0 = {239.58920288086,20.7880859375,320.14974975586}

local BARRICADETEMPLATE		= "d590884d-55a2-4136-9777-531ee7d53f7e"

local CRATE		= "23578669-058f-4318-8e51-87523fc1307f"

local Crate1 = {220.62478637695,15.830078125,322.23071289062}

local Crate2 = {220.62478637695,15.830078125,317.23071289062}


-- Table to store the current target index for each character
local characterTargets = {}

-- Define an array of target positions
local targetPositions = {
    {x = 226.49760437012, y = 16.8076171875, z = 319.62942504883},
    {x = 226.82446289062, y = 16.294921875, z = 314.53106689453},
    {x = 236.56643676758, y = 17.2421875, z = 314.7282409668},
    {x = 237.89315795898, y = 17.375, z = 322.44702148438},
    {x = 250.27450561523, y = 16.79296875, z = 322.64022827148}
}


-- LevelUnloading Listener
Ext.Osiris.RegisterListener("LevelUnloading", 1, "after", function(level)
	if level == "TUT_Avernus_C" then -- tutorial level exit
		Ext.Utils.Print('leaving tut')
	end		
end)

-- LevelLoaded Listener
Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
	Ext.Utils.Print("Level Loaded: " .. level)
	local hostChar = Osi.GetHostCharacter()
	if level == "WLD_Main_A" then
        Ext.Utils.Print('about to remove spells from host')
		Osi.RemoveSpell(hostChar, "Start_Game_Leave_Tut", 0)
		--Osi.AddSpell(hostChar, "Start_Game_Maps", 1, 0)
		Osi.OpenMessageBox(hostChar, "level loaded wld main a")
	elseif level == "TUT_Avernus_C" then
		Osi.AddSpell(hostChar, "Start_Game_Leave_Tut", 1, 0) 
		--Osi.AddSpell(hostChar, "DEBUG_SHOUT", 1, 0)
	end
end)

-- StatusApplied Listener
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(guid, status, causee, storyactionid)
	--Ext.Utils.Print(status)
	if status == "StartGame" then
		HandleStartGameMap1(guid)
		--local hostChar = Osi.GetHostCharacter()
		--TeleportCharacter(hostChar, statue_test)
	elseif status == "LeaveTut" then
		local hostChar = Osi.GetHostCharacter()
		TeleportCharacter(hostChar, TRANSPONDER_POS)
	elseif status == "DEBUG" then
		HandleDebug(guid)
	end
end)

-- Listener for turn start
Ext.Osiris.RegisterListener("TurnStarted", 1, "before", function(characterGuid)
    Ext.Utils.Print("Turn has started for character: " .. characterGuid)
    local factionID = Osi.GetFaction(characterGuid)
    Ext.Utils.Print("Faction ID for character: " .. factionID)
    --if characterGuid == 'Goblins_Male_Ranger_3d95ab75-8dcb-d6ea-072a-120eaa16a885' then
    --    Osi.CharacterMoveToPosition(characterGuid, 228.6, 23.7880859375, 317.19277954102, '10', "", 1)
    --end
    if factionID == 'Evil NPC_64321d50-d516-b1b2-cfac-2eb773de1ff6' then
        -- Initialize target index for new characters
        if not characterTargets[characterGuid] then
            characterTargets[characterGuid] = 1
        end

        local currentTargetIndex = characterTargets[characterGuid]
        local entityMovement = Osi.GetActionResourceValuePersonal(characterGuid, 'Movement', 0)
        local currentX, currentY, currentZ = Osi.GetPosition(characterGuid)

        -- Get the current target position and distance to position
        local target = targetPositions[currentTargetIndex]
        local targetX = target.x
        local targetY = target.y
        local targetZ = target.z
        local distanceTo = Osi.GetDistanceToPosition(characterGuid, targetX, targetY, targetZ)

        -- Check if we're close enough to consider the target reached
        if distanceTo < entityMovement then
            -- Move to the next target
            currentTargetIndex = getNextTarget(characterGuid, currentTargetIndex)
            if currentTargetIndex == nil then
                return -- All targets reached
            end
            target = targetPositions[currentTargetIndex]
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
        local closestPlayer = Osi.GetClosestPlayer(characterGuid)
        Ext.Utils.Print("Closest Player To Current Turn Taker: " .. tostring(closestPlayer))
        Ext.Utils.Print(Osi.GetHostCharacter())
        Osi.Attack(characterGuid, closestPlayer, 1)

    elseif not string.find(characterGuid, 'Player') then
        Osi.ApplyStatus(characterGuid, 'Ally_Generic', 10, 1, characterGuid)
    end
end)



------------------ functions --------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-- Function to get the next target position
function getNextTarget(characterGuid, currentTargetIndex)
    if currentTargetIndex < #targetPositions then
        return currentTargetIndex + 1
    else
        -- Optionally handle the case when all targets are reached
        return nil
    end
end



-- Function to handle debug
function HandleDebug(guid)
    --Osi.OpenMessageBox(hostChar, combinedString)
	--newX, newY, newZ = Osi.FindValidPosition(x, y, z, 10, new_item, 1.4)
	--Osi.ItemMoveToPosition(new_item, newX, newY, newZ, 100, 100, "")
	local hostChar = Osi.GetHostCharacter()
    local x, y, z = Osi.GetPosition(hostChar)
    local crate = "{" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "}"
    Ext.Utils.Print("local Crate1 = " .. crate)
	new_item = Osi.CreateAt("23578669-058f-4318-8e51-87523fc1307f", x, y, z, 0, 1, "")
	local yy = y + 1.1
	local telly_me = {x, yy, z}
    Ext.Utils.Print('host location' .. tostring(Osi.GetPosition(hostChar)))
	TeleportCharacter(guid, telly_me)
end

-- Function to handle startgame status
function HandleStartGameMap1(guid)
    local hostChar = Osi.GetHostCharacter()
    TeleportCharacter(guid, MAP_0)

    local x, y, z = Crate1[1], Crate1[2], Crate1[3]
    new_item = Osi.CreateAt(CRATE, x, y, z, 0, 1, "")
    local combinedString = "initial: " .. tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z)
    Ext.Utils.Print(combinedString)

    -- Placing boxes with multiple directions and distances
    local placements = {
        {direction = 'east', distance = 8, height = 5},
        {direction = 'south', distance = 5, height = 5},
        {direction = 'east', distance = 6, height = 5},
        {direction = 'north', distance = 8, height = 5},
        {direction = 'east', distance = 9, height = 5},
    }
    last_item = PlaceBoxes(new_item, placements)

    local rx, ry, rz = Crate2[1], Crate2[2], Crate2[3]
    new_item = Osi.CreateAt(CRATE, rx, ry, rz, 0, 1, "")
    placements = {
        {direction = 'east', distance = 3, height = 5},
        {direction = 'south', distance = 5, height = 5},
        {direction = 'east', distance = 16, height = 5},
        {direction = 'north', distance = 8, height = 5},
        {direction = 'east', distance = 4, height = 5},
    }
    last_item = PlaceBoxes(new_item, placements)

    --local golemID = CreateAt(GetTemplate("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255"), 223.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
    local mephitemplateID = Osi.GetTemplate("S_HAG_MudMephit_04_2a99e33a-cb96-40a0-bb8e-4a118719e794")
    local goblinTemplateID = Osi.GetTemplate("S_CAMP_PartyGoblin_004_2fed2230-f4b2-4ac2-9400-e4866072ff99")
    local yennaTemplateID = Osi.GetTemplate("be212ed5-a622-4560-96be-0ee27ea1f913")
    local mephitID = CreateAt(mephitemplateID, 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
    local goblinID = CreateAt(goblinTemplateID, 228.58090209961, 23.7880859375, 317.19277954102, 0,0,"")
    local yennaID = CreateAt(yennaTemplateID, 223.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
    --local test = Osi.CanShowSpellForCharacter(goblinID, 'Target_Healer_Heal')
    --Ext.Utils.Print('test:' .. tostring(test))
    --local tx, ty, tz = Osi.GetPosition(goblinID)
    --Osi.UseSpell(goblinID, 'Target_Healer_Heal', goblinID)
    Osi.UseSpellAtPosition(goblinID, 'Debug_MistyStep', 228.58090209961, 22.7880859375, 317.19277954102)
    Osi.SetFaction(goblinID, '6545a015-1b3d-66a4-6a0e-6ec62065cdb7')
    Ext.Utils.Print('mephit location' .. tostring(Osi.GetPosition(mephitID)))
    set_creature_hostile(mephitemplateID,mephitID)
    
    local golemFaction = Osi.GetFaction("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255")
    local mephitFaction = Osi.GetFaction("S_HAG_MudMephit_04_2a99e33a-cb96-40a0-bb8e-4a118719e794")
    local hostFaction = Osi.GetFaction(hostChar)
    local factionString = "Golem Faction: " .. tostring(golemFaction) .. ", Mephit Faction: " .. tostring(mephitFaction) .. ", Host Faction: " .. tostring(hostFaction)
    Ext.Utils.Print(factionString)
    --Golem Faction: Act1_UND_KethericCity_Golem_40a90873-e3f0-478c-99f9-11e71f068f55, Mephit Faction: Act1_HAG_WoodWoad_5b02a4d5-fdca-428d-a19d-dbc73e0bd777, Host Faction: Hero Player1_6545a015-1b3d-66a4-6a0e-6ec62065cdb7
    local golemGroupID = Osi.GetCombatGroupID("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255")
    local mephitGroupID = Osi.GetCombatGroupID("S_HAG_MudMephit_04_2a99e33a-cb96-40a0-bb8e-4a118719e794")
    local hostGroupID = Osi.GetCombatGroupID("Player1_169d0520-1eb0-f576-d819-74850d49eaaa")
    local groupIDString = "Golem Group ID: " .. tostring(golemGroupID) .. ", Mephit Group ID: " .. tostring(mephitGroupID) .. ", Host Group ID: " .. tostring(hostGroupID)
    Ext.Utils.Print(groupIDString)
    --Golem Group ID: a78e643e-ecdb-3d86-7e62-8a2eaf7c8a6f, Mephit Group ID: 8a17e0b6-fc74-5603-5e4a-139a1bbd7ac8, Host Group ID:
end

function PlaceBoxes(item, placements)
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
                    new_item = Osi.CreateAt(CRATE, x, y + current_height, z + current_distance, 0, 1, "")
                elseif direction == 'east' then
                    new_item = Osi.CreateAt(CRATE, x + current_distance, y + current_height, z, 0, 1, "")
                elseif direction == 'south' then
                    new_item = Osi.CreateAt(CRATE, x, y + current_height, z - current_distance, 0, 1, "")
                elseif direction == 'west' then
                    new_item = Osi.CreateAt(CRATE, x - current_distance, y + current_height, z, 0, 1, "")
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


function CreateWallBetweenCrates(crate1, crate2, crateID, height)
    local x1, y1, z1 = table.unpack(crate1)
    local x2, y2, z2 = table.unpack(crate2)

    -- Calculate the z-axis distance and direction
    local distance = math.abs(z2 - z1)
    local direction = (z2 > z1) and 1 or -1

    for i = 0, distance do
        for h = 0, height - 1 do
            -- Adjust the z-coordinate for each crate based on the direction
            local z = z1 + (i * direction)
            Osi.CreateAt(crateID, x1, y1 + h, z, 0, 1, "")
        end
    end
end


-- Function to teleport a character to specified coordinates
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

function set_creature_hostile(creature_tpl_id,target_t)
    local host_guid = Osi.GetHostCharacter()
    local src_faction = Osi.GetFaction(host_guid)
    Osi.SetFaction(target_t, '64321d50-d516-b1b2-cfac-2eb773de1ff6')
    --Osi.SetHostileAndEnterCombat('Neutral NPC_cfb709b3-220f-9682-bcfb-6f0d8837462e', '64321d50-d516-b1b2-cfac-2eb773de1ff6', host_guid, creature_tpl_id)
    Osi.SetHostileAndEnterCombat('Hero Player1_6545a015-1b3d-66a4-6a0e-6ec62065cdb7', '64321d50-d516-b1b2-cfac-2eb773de1ff6', host_guid, creature_tpl_id)
end