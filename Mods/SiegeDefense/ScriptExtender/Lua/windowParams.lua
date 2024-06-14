local windowParams = {}

windowParams.siegeDefenseWParams = {
    title = "Siege Defense",
    components = {
        {
            type = "text",
            value = "Welcome to Siege Defense. If this is your first time playing, please read the following, it could be important for your saves!\n\n" ..
                    "If it is your first time playing, please ensure you start a new game if you intend to run Siege Defense. " ..
                    "It will alter many aspects of the base game so it is not intended to be run from any random save game as it is its own game mode.\n\n" ..
                    "The trigger to acknowledge you have read that and plan to play Siege Defense is below. " ..
                    "Checking it will allow the game to be run on a new game."
        },
        {
            type = "checkbox",
            label = "Acknowledge and start Siege Defense",
            checked = false
        }
    }
}

windowParams.mapSelectionWParams = {
    title = "Select Map",
    components = {
        {
            type = "table",
            label = "Map Selection Table",
            columns = 3,
            rows = {
                {
                    { type = "text", value = "Map Name 1" },
                    { type = "image", value = "path/to/map1/icon.png" },
                    { type = "button", label = "Load Map 1", onClick = function() selectMap("MapName1") end }
                },
                {
                    { type = "text", value = "Map Name 2" },
                    { type = "image", value = "path/to/map2/icon.png" },
                    { type = "button", label = "Load Map 2", onClick = function() selectMap("MapName2") end }
                },
                -- Add more maps as needed
            }
        }
    }
}

windowParams.summonAllyWParams = {
    title = "Summon Ally",
    components = {
        {
            type = "inputText",
            label = "Search Entity",
            value = ""
        },
        {
            type = "checkbox",
            label = "Filter Melee",
            checked = true,
            onChange = function(self, state)
                -- Add your filter logic here
            end
        },
        {
            type = "checkbox",
            label = "Filter Ranged",
            checked = false,
            onChange = function(self, state)
                -- Add your filter logic here
            end
        },
        {
            type = "table",
            label = "Entity Table",
            columns = 3,
            rows = {
                {
                    { type = "text", value = "Unit" },
                    { type = "text", value = "Type" },
                    { type = "text", value = "Level" }
                },
                {
                    { type = "image", value = "path/to/unit1/icon.png" },
                    { type = "text", value = "Unit Name 1" },
                    { type = "text", value = "Melee" },
                    { 
                        type = "inputText", 
                        label = "Level", 
                        value = "1", 
                        options = { "Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8", "Level 9", "Level 10", "Level 11", "Level 12" } 
                    },
                    { 
                        type = "button", 
                        label = "Spawn", 
                        onClick = function() 
                            -- Add logic to close the window and send message to server
                        end 
                    }
                },
                -- Add more rows as needed
            }
        }
    }
}

return windowParams
