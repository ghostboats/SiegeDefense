-- TutorialExit (c) 2023-2024 By SwissFred
--unused listeners
-- LevelGameplayStarted Listener
--Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, isEditorMode)
--	--Ext.Utils.Print("levelGameplaystarted")	
--	if level ~= "SYS_CC_I" and level == "WLD_Main_A" then -- not in creation and is tutorial level
--		--Ext.Utils.Print(level)
--		if not PersistentVars.ExitShip then 
--			local hostChar = Osi.GetHostCharacter()
--			if not PersistentVars.SpellsGiven then
--				Osi.AddSpell(hostChar, "Start_Game_Maps", 1, 0)
--				PersistentVars.SpellsGiven = true								
--			end	
--		end
--	end
--end)

-- CharacterJoinedParty Listener
--Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
	--Ext.Utils.Print(character)
--	local level = Osi.GetRegion(character)
--	if level == "TUT_Avernus_C" then
--		if character == SHADOWHEART then
--			Osi.PROC_TUT_TransformChamber_ShadowheartParty()
--			Osi.PROC_TUT_TransformChamber_ShadowheartWasFreed()			
--			PersistentVars.ShadowheartFreed = true
--		end
--	end
--end)

-- Closed Listener
--Ext.Osiris.RegisterListener("Closed", 1, "after", function(itemguid)
--	--Ext.Utils.Print("Closed", itemguid)
--	if itemguid == ELABORATECHESTTEMPLATE then 
--		if Osi.GetVarInteger(ELABORATECHESTTEMPLATE,"CLOSED") ~= 1 then
--			Osi.AddExplorationExperience(Osi.GetHostCharacter(), 300)
--			Osi.SetVarInteger(ELABORATECHESTTEMPLATE,"CLOSED", 1)
--		else
--			Osi.CreateProjectileStrikeAt(ELABORATECHESTTEMPLATE, "Projectile_Greedy")
--			Osi.RequestDelete(ELABORATECHESTTEMPLATE)
--		end
--	end		
--end)

-- UseStarted Listener
--Ext.Osiris.RegisterListener("UseStarted", 2, "after", function(character, item )
	--Ext.Utils.Print("UseStarted",character,item)			
--end)

-- DroppedBy Listener
--Ext.Osiris.RegisterListener("DroppedBy", 2, "after", function(itemguid, player) -- dropped
	--Ext.Utils.Print("dropped")
	--local template_UUID = GetTemplate(itemguid)
	--Ext.Utils.Print(itemguid)
	--Ext.Utils.Print(template_UUID)
	--Ext.Utils.Print(Osi.GetPosition(itemguid))
--end)

-- Moved Listener
--Ext.Osiris.RegisterListener("Moved", 1, "after", function(itemguid) -- Moved
	--Ext.Utils.Print("Moved")
	--local template_UUID = GetTemplate(itemguid)
	--Ext.Utils.Print(itemguid)
	--Ext.Utils.Print(template_UUID)
	--Ext.Utils.Print(Osi.GetPosition(itemguid))
--end)

-- AddedTo Listener
--Ext.Osiris.RegisterListener("AddedTo", 3, "after", function(object, inventoryHolder, addType)
--	--Ext.Utils.Print(object)
--	if PersistentVars.StarFishItem and string.sub(object, -36) == PersistentVars.StarFishItem then
--		Osi.PlaySound(GetHostCharacter(), "Spell_Impact_Paladin_TurnTheFaithless_L1to3")
--		Osi.TemplateRemoveFrom(STARFISHTEMPLATE, inventoryHolder, 4)
--		local players = Osi.DB_Players:Get(nil)
--		for _, player in pairs(players) do
--			Osi.AddExplorationExperience(player[1], 300)
--		end	
--	end	
--end)

-- Opened Listener
--Ext.Osiris.RegisterListener("Opened", 1, "after", function(itemguid)
--	--Ext.Utils.Print("Opened", itemguid)
--	if itemguid == ELABORATECHESTTEMPLATE then 
--		if fxHandle then 
--			Osi.StopLoopEffect(fxHandle)
--		end	
--		if Osi.GetVarInteger(ELABORATECHESTTEMPLATE,"OPENED") ~= 1 then
--			Osi.AddExplorationExperience(Osi.GetHostCharacter(), 300)
--			Osi.SetVarInteger(ELABORATECHESTTEMPLATE,"OPENED", 1)
--		else
--			local message4 = Osi.ResolveTranslatedString(message4Key)
--			Osi.OpenMessageBox(Osi.GetHostCharacter(), message4)							
--		end
--	end		
--end)

--unusues variables
--PersistentVars.ExitShip			= false
--PersistentVars.TutorialEnd		= false
--PersistentVars.ShadowheartFreed	= false
--PersistentVars.SpellsGiven		= false
--PersistentVars.StarFishItem		= nil

--local SHADOWHEART_POS		= {-2.0206580162048, 17.6171875, -346.88528442383 }

--local LEZEL_POS				= {-32.839233398438, 14.87109375, -433.92694091797}

--local CONSOLE_POS			= {0.56861913204193, 17.6455078125, -347.91262817383}

--local US_POS					= {3.75, 21.451171875, -438.25}

-- New Position near Shadowheart
--local ELABORATECHEST_POS		= {-2.3046224117279, 17.610919952393, -346.47982788086}

-- New Position near Console ---
--local TUTORIALCHEST_POS		= {-2.8222630023956,  17.607496261597, -347.76953125} 

-- Beach where Shadowheart is on the floor
--local BEACH_POS				= {272.21716308594, 1.0546875, 220.50318908691} 

-- at the waypoint ruins
--local RUINS_POS				= {281.9306640625, 0.6953125,294.48330688477} 

-- Mysterious item near beach Portal
--local STARFISH_POS			= {287.3056640625, 0.92956209182739,  294.06579589844} 

-- Waypoint Trigger
--local WAYPOINTBEACH			= "S_CHA_WaypointTrigger_5e857e93-203a-4d4a-bd29-8e97eb34dec6"
--local PORTALRUINS			= "WAYP_CHA_Chapel"

--------- Items ---------
--local TRANSPONDER			= "S_TUT_Helm_ControlPanel_bcbba417-6403-40a6-aef6-6785d585df2a"
--local CONSOLERUNE			= "19df3203-a4fb-4513-be14-fe036acffc0e" 
--local GOLDKEY				= "7d5eab5e-4ec0-4b40-8714-f85b2f8c8a0c" 

--local DARK_MIND				= "2c5bca7e-8649-4217-9ebb-52b20a506e99"
--local SLAVE_MIND				= "f938e0a4-fb50-4d69-8b40-18e9bba30a22"
--local MANUSCRIPT				= "2e55e20f-2fb4-4a7a-9a0d-78bc61a19ee0"

--local TUTORIALCHEST			= "e57e3af6-ae79-4d5c-9d11-f695b359c740" 
--local ELABORATECHEST			= "95dde668-cee0-47c0-92ed-1072db84f687" 
--local ELABORATECHESTTEMPLATE	= "S_TUT_TransformChamber_SharChest_95dde668-cee0-47c0-92ed-1072db84f687"
--local STARFISHTEMPLATE		= "DEC_Harbour_Shell_Starfish_A_3cc28d1f-4279-45df-946c-0b09d934a7c1"

-- root templates --
--local FIREGREATSWORD			= "660483f6-8eb3-45be-88a4-327f9d417026" 
--local GOLD_COIN				= "1c3c9c74-34a1-4685-989e-410dc080be6f"
--local SCROLL_FALSELIFE		= "7d76665a-3b9e-4495-a3c6-a05340704194"
--local SCROLL_SPEAKWITHDEAD	= "36d01b98-1702-4d00-81a9-1b8469dd67a5"
--local POTION_HEALING			= "d47006e9-8a51-453d-b200-9e0d42e9bbab"
--local KIT_THIEVESTOOL		= "e32a200c-5b63-414d-ae57-00e7b38f125b"
--local TRAP_DISARM			= "22c74b5e-bef2-41b1-b9ed-f4acc766d4ee"

-- characters
--local SHADOWHEART			= "S_Player_ShadowHeart_3ed74f06-3c60-42dc-83f6-f034cb47c679"
--local USDEVOURER				= "S_TUT_Lab_TrappedDevourer_6ca92237-eb1e-4ed8-a1ee-18b3bef21558"

-- VFX for playloopEffect
--local VFX_Light_Yellow_Green_01	= "aa29ff85-8912-d0f0-9e6a-186354d7adec"
--local VFX_Light_Mine_Green_01	= "96c29903-0613-cabd-8110-491f4534774d"

-- translated strings keys
--local message1Key = "h58240e6cg84ffg4c5bga240g405d65bfbaa1"
--local message2Key = "he200a766geea0g4d4bgaf5egb2262caa204c"
--local message3Key = "h35be50c2g63a1g4a86g840ag34c67b0698ea"
--local message4Key = "h52782fedga1d6g4cf3g91b8g4e3447830689"

PersistentVars = {}



-------------- Coordinates for Teleport -----------
local TRANSPONDER_POS		=  {-84.692207336426, 19.01319694519, -387.45742797852}

local MAP_1                 = {220.62478637695,15.830078125,322.23071289062}

local BARRICADETEMPLATE		= "d590884d-55a2-4136-9777-531ee7d53f7e"

local CRATE		= "23578669-058f-4318-8e51-87523fc1307f"

local Crate1 = {220.62478637695,15.830078125,322.23071289062}

local Crate2 = {220.62478637695,15.830078125,317.23071289062}

local statue_test = {-300.3968,15.04724,-250.2776}


-- LevelUnloading Listener
Ext.Osiris.RegisterListener("LevelUnloading", 1, "after", function(level)
	if level == "TUT_Avernus_C" then -- tutorial level exit
		Osi.OpenMessageBox(hostChar, 'leaving tut')
	end		
end)

-- LevelLoaded Listener
Ext.Osiris.RegisterListener("LevelLoaded", 1, "after", function(level)
	--Ext.Utils.Print("Level Loaded: " .. level)
	local hostChar = Osi.GetHostCharacter()
	if level == "WLD_Main_A" then
		Osi.RemoveSpell(hostChar, "Start_Game_Leave_Tut", 0)
		Osi.AddSpell(hostChar, "Start_Game_Maps", 1, 0)
		Osi.OpenMessageBox(hostChar, "level loaded wld main a")
	elseif level == "TUT_Avernus_C" then
		Osi.AddSpell(hostChar, "Start_Game_Leave_Tut", 1, 0)
		Osi.AddSpell(hostChar, "DEBUG_SHOUT", 1, 0)
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

------------------ functions --------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
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
	TeleportCharacter(guid, telly_me)
end

-- Function to handle startgame status
function HandleStartGameMap1(guid)
    local hostChar = Osi.GetHostCharacter()
    TeleportCharacter(guid, MAP_1)
    Osi.OpenMessageBox(hostChar, 'moving to game location')

    local x, y, z = Osi.GetPosition(hostChar)
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
    local mephitID = CreateAt(mephitemplateID, 218.16305541992, 16.377229690552, 319.40869140625, 0,0,"")
    --Osi.CharacterMoveToPosition(golemID, 245.22763061523, 17.1201171875, 322.94619750977, '10', "", 1)
    Osi.CharacterMoveToPosition(mephitID, 245.22763061523, 17.1201171875, 322.94619750977, '10', "", 1)
    set_creature_hostile(mephitemplateID,mephitID)
    
    local golemFaction = Osi.GetFaction("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255")
    local mephitFaction = Osi.GetFaction("S_HAG_MudMephit_04_2a99e33a-cb96-40a0-bb8e-4a118719e794")
    local hostFaction = Osi.GetFaction(hostChar)
    local factionString = "Golem Faction: " .. tostring(golemFaction) .. ", Mephit Faction: " .. tostring(mephitFaction) .. ", Host Faction: " .. tostring(hostFaction)
    Ext.Utils.Print(factionString)
    --Golem Faction: Act1_UND_KethericCity_Golem_40a90873-e3f0-478c-99f9-11e71f068f55, Mephit Faction: Act1_HAG_WoodWoad_5b02a4d5-fdca-428d-a19d-dbc73e0bd777, Host Faction: Hero Player1_6545a015-1b3d-66a4-6a0e-6ec62065cdb7
    --Osi.SetHostileAndEnterCombat()("Hero Player1_6545a015-1b3d-66a4-6a0e-6ec62065cdb7","Act1_HAG_WoodWoad_5b02a4d5-fdca-428d-a19d-dbc73e0bd777")
    --Osi.ForceTurnBasedMode(hostChar, 1) i think nope
    --Osi.EnterCombat(hostChar,mephitID) nope
    --Osi.SetHostileAndEnterCombat("Act1_HAG_WoodWoad_5b02a4d5-fdca-428d-a19d-dbc73e0bd777","Hero Player1_6545a015-1b3d-66a4-6a0e-6ec62065cdb7", mephitID, hostChar) nope
    local golemGroupID = Osi.GetCombatGroupID("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255")
    local mephitGroupID = Osi.GetCombatGroupID("S_HAG_MudMephit_04_2a99e33a-cb96-40a0-bb8e-4a118719e794")
    local hostGroupID = Osi.GetCombatGroupID("Player1_169d0520-1eb0-f576-d819-74850d49eaaa")
    local groupIDString = "Golem Group ID: " .. tostring(golemGroupID) .. ", Mephit Group ID: " .. tostring(mephitGroupID) .. ", Host Group ID: " .. tostring(hostGroupID)
    Ext.Utils.Print(groupIDString)
    --Golem Group ID: a78e643e-ecdb-3d86-7e62-8a2eaf7c8a6f, Mephit Group ID: 8a17e0b6-fc74-5603-5e4a-139a1bbd7ac8, Host Group ID:
    local hostName = Osi.GetClosestAlivePlayer(mephitID)
    Ext.Utils.Print(tostring(hostName))
    Ext.Utils.Print(Osi.GetCurrentCharacter(0))
    --Osi.SetCombatGroupID()
    --Osi.SetCombatGroupAndEnterCombat(hostChar)

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
    Osi.SetHostileAndEnterCombat('Hero Player1_6545a015-1b3d-66a4-6a0e-6ec62065cdb7', '64321d50-d516-b1b2-cfac-2eb773de1ff6', host_guid, creature_tpl_id)
end

---param target GUIDSTRING
---param groupID string
---param enemy GUIDSTRING
--function Osi.SetCombatGroupAndEnterCombat(target, groupID, enemy) end

---param target GUIDSTRING
---param groupID string
--function Osi.SetCombatGroupID(target, groupID) end