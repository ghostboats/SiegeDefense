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

	last_item = PlaceBox(new_item, 'east', 8, 3)
	last_item = PlaceBox(last_item, 'south', 4, 4)
	last_item = PlaceBox(last_item, 'east', 2, 1)
	--Osi.CreateAt(CRATE, x + 1, y, z, 0, 1, "")
	--Osi.CreateAt(CRATE, x + 2, y, z, 0, 1, "")

	local rx, ry, rz = Crate2[1], Crate2[2], Crate2[3]
	new_item = Osi.CreateAt(CRATE, rx, ry, rz, 0, 1, "")
	last_item = PlaceBox(new_item, 'east', 3, 3)
	last_item = PlaceBox(last_item, 'south', 4, 4)
	last_item = PlaceBox(last_item, 'east', 2, 1)

	local entityID = CreateAt(GetTemplate("S_UND_KethericCity_AdamantineGolem_2a5997fc-5f2a-4a13-b309-bed16da3b255"), x, y, z, 0,0,"")
	--Osi.CharacterMoveToPosition(character, x, y, z, movementSpeed, event, moveID)
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

function PlaceBox(item, direction, distance, height)
    direction = direction or "east"  -- Setting default value
    distance = distance or 0
    height = height or 1
    local x, y, z = Osi.GetPosition(item)
    local new_item

    for current_height = 0, height - 1 do
        if direction == 'north' then
            for current_distance = 1, distance do
                new_item = Osi.CreateAt(CRATE, x, y + current_height, z + current_distance, 0, 1, "")
                Ext.Utils.Print("Created CRATE at x: " .. tostring(x) .. ", y: " .. tostring(y + current_height) .. ", z: " .. tostring(z + current_distance))
            end
        elseif direction == 'east' then
            for current_distance = 1, distance do
                new_item = Osi.CreateAt(CRATE, x + current_distance, y + current_height, z, 0, 1, "")
                Ext.Utils.Print("Created CRATE at x: " .. tostring(x + current_distance) .. ", y: " .. tostring(y + current_height) .. ", z: " .. tostring(z))
            end
        elseif direction == 'south' then
            for current_distance = 1, distance do
                new_item = Osi.CreateAt(CRATE, x, y + current_height, z - current_distance, 0, 1, "")
                Ext.Utils.Print("Created CRATE at x: " .. tostring(x) .. ", y: " .. tostring(y + current_height) .. ", z: " .. tostring(z - current_distance))
            end
        elseif direction == 'west' then
            for current_distance = 1, distance do
                new_item = Osi.CreateAt(CRATE, x - current_distance, y + current_height, z, 0, 1, "")
                Ext.Utils.Print("Created CRATE at x: " .. tostring(x - current_distance) .. ", y: " .. tostring(y + current_height) .. ", z: " .. tostring(z))
            end
        end
    end
    return new_item
end