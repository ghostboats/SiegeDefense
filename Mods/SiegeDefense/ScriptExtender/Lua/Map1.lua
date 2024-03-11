-- Map1.lua
local Map1 = {}

function Map1.GenerateMap1(guid)
    local hostChar = Osi.GetHostCharacter()
    TeleportCharacter(guid, MAP_1)
    Osi.OpenMessageBox(hostChar, 'moving to game location')
    local x, y, z = Osi.GetPosition(hostChar)
    local zz = z + 2
    local telly_me = {x, y, zz}
    TeleportCharacter(guid, telly_me)
    
    for i = 0, 6 do
        Osi.CreateAt(CRATE, x + i, y, z, 0, 1, "")
        Ext.Utils.Print("Created CRATE at x: " .. tostring(x + i) .. ", y: " .. tostring(y) .. ", z: " .. tostring(z))
    end

    for i = 0, 2 do
        Osi.CreateAt(CRATE, x + i, y, z+3, 0, 1, "")
        Ext.Utils.Print("Created CRATE at x: " .. tostring(x + i) .. ", y: " .. tostring(y - 6) .. ", z: " .. tostring(z))
    end
end

return Map1