local hf = Ext.Require('HelperFunctions.lua')
local wp = Ext.Require('windowParams.lua')
local allWindows = {}

-- Define the selectMap function
local function selectMap(mapName)
    Ext.Utils.Print("Map selected: " .. mapName)
    Ext.Net.PostMessageToServer("MapSelected", Ext.Json.Stringify({ mapName = mapName }))
    if allWindows.mapSelectionW then
        allWindows.mapSelectionW.Open = false -- Close the map selection window
    end
end

-- Register the EnableMod listener to show the initial window
Ext.RegisterNetListener("EnableMod", function(channel, payload, user)
    _D('in enable mod')
    local siegeDefenseW = hf.MYGUI(wp.siegeDefenseWParams)
    allWindows.siegeDefenseW = siegeDefenseW -- Assign directly to the key
end)

Ext.RegisterNetListener("SummonAllyWindow", function(channel, payload, user)
    _D('in Summon Ally Window')
    local summonAllyW = hf.MYGUI(wp.summonAllyWParams)
    allWindows.summonAllyW = summonAllyW
end)


-- Modify the onChange event in siegeDefenseWParams to show the map selection window when checked
wp.siegeDefenseWParams.components[2].onChange = function(self, state)
    Ext.Utils.Print("Checkbox state changed: " .. tostring(state))
    Ext.Net.PostMessageToServer("UpdateSiegeDefenseMode", Ext.Json.Stringify({ state = state }))
    if state then
        -- Debug print to see the contents of allWindows
        for k, v in pairs(allWindows) do
            Ext.Utils.Print("allWindows[" .. tostring(k) .. "] = " .. tostring(v))
        end
        
        if allWindows.siegeDefenseW then
            allWindows.siegeDefenseW.Open = false -- Close the specific siegeDefenseW window
        end

        -- Update the map selection button handlers dynamically
        wp.mapSelectionWParams.components[1].rows[1][3].onClick = function() selectMap("MapName0") end
        wp.mapSelectionWParams.components[1].rows[2][3].onClick = function() selectMap("MapName1") end

        local mapSelectionW = hf.MYGUI(wp.mapSelectionWParams)
        allWindows.mapSelectionW = mapSelectionW
    end
end
