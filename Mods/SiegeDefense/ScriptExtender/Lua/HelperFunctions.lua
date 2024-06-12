-- Define a table to hold all helper functions
local helperFunctions = {}

-- Function to place boxes
local function PlaceBoxes(item, placements, mapConfig)
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

-- Function to handle map selection
function helperFunctions.selectMap(mapName, allWindows)
    Ext.Utils.Print("Map selected: " .. mapName)
    Ext.Net.PostMessageToServer("MapSelected", Ext.Json.Stringify({ mapName = mapName }))
    if allWindows.mapSelectionW then
        allWindows.mapSelectionW.Open = false -- Close the map selection window
    end
end

-- Function to handle starting the game map
function helperFunctions.HandleStartGameMap(guid, mapConfig)
    Osi.TeleportToPosition(guid, mapConfig.MAP_0[1], mapConfig.MAP_0[2], mapConfig.MAP_0[3], "", 1, 1, 1, 1, 1)
    local lx, ly, lz = mapConfig.Crate1[1], mapConfig.Crate1[2], mapConfig.Crate1[3]
    squirrelID = Osi.CreateAt(Osi.GetTemplate("S_DEN_Squirrel_35ed8eab-1e0b-4ec8-92f2-1b8510cb3ad8"), lx, ly, lz, 0, 1, "")
    new_item_left = Osi.CreateAt(mapConfig.CRATE, lx, ly, lz, 0, 1, "")
    last_item_left = PlaceBoxes(new_item_left, mapConfig.placements_left, mapConfig)

    local rx, ry, rz = mapConfig.Crate2[1], mapConfig.Crate2[2], mapConfig.Crate2[3]
    new_item_right = Osi.CreateAt(mapConfig.CRATE, rx, ry, rz, 0, 1, "")
    last_item_right = PlaceBoxes(new_item_right, mapConfig.placements_right, mapConfig)

    local initialID = Osi.CreateAt(mapConfig.DEBUG_ENEMY, 218.16305, 16.377229, 319.40869, 0,0,"")
    Osi.SetFaction(initialID, mapConfig.f_enemy)
    local x, y, z = Osi.GetPosition(initialID)
    --add entity name to guid
    initialID = 'debug_Goblins_Female_Caster_' .. initialID
    --entityStates[initialID] = {x = x, y = y, z = z, type = 'enemy', currentTargetIndex = 0}
    Osi.UseSpell(Osi.GetHostCharacter(), 'Siege_Points_Setup', Osi.GetHostCharacter())
end


-- Function to create a custom GUI
function helperFunctions.MYGUI(params)
    local title = params.title or 'Custom Window'
    local customWindow = Ext.IMGUI.NewWindow(title)
    customWindow.Closeable = params.closeable or true

    -- Helper function to add components based on type
    local function addComponent(parent, component)
        if component.type == "text" then
            parent:AddText(component.value or "")
        elseif component.type == "button" then
            local button = parent:AddButton(component.label or "Button")
            if component.onClick then
                button.OnClick = component.onClick
            end
        elseif component.type == "inputText" then
            local inputText = parent:AddInputText(component.label or "Input", component.value or "")
            if component.onChange then
                inputText.OnChange = component.onChange
            end
        elseif component.type == "checkbox" then
            local checkbox = parent:AddCheckbox(component.label or "Checkbox", component.checked or false)
            if component.onChange then
                checkbox.OnChange = component.onChange
            end
        elseif component.type == "tabBar" then
            local tabBar = parent:AddTabBar(component.label or "TabBar")
            for _, tab in ipairs(component.tabs) do
                local tabItem = tabBar:AddTabItem(tab.label or "Tab")
                for _, tabComponent in ipairs(tab.components) do
                    addComponent(tabItem, tabComponent)
                end
            end
        elseif component.type == "table" then
            local tableElement = parent:AddTable(component.label or "Table", component.columns or 1)
            tableElement.Borders = component.borders or true
            for _, row in ipairs(component.rows) do
                local rowElement = tableElement:AddRow()
                for _, cell in ipairs(row) do
                    local cellElement = rowElement:AddCell()
                    if cell.type == "text" then
                        cellElement:AddText(cell.value or "")
                    elseif cell.type == "image" then
                        cellElement:AddImage(cell.value or "")
                    elseif cell.type == "button" then
                        local button = cellElement:AddButton(cell.label or "Button")
                        if cell.onClick then
                            button.OnClick = cell.onClick
                        end
                    end
                end
            end
        end
    end

    -- Iterate through components in params and add them to the window
    for _, component in ipairs(params.components) do
        addComponent(customWindow, component)
    end

    return customWindow
end

return helperFunctions
