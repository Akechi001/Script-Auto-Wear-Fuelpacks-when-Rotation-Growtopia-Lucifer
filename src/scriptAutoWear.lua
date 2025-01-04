-- this script is for rotation farming but still using harvester or harvester of sorrow with fuel pack
-- originally made by Akechi001 on github
--

local worldItemStorage = WorldStorageItemName
local doorID = IDDoorWorld
local fuelID = 1746
local harvesterID = 1966
local pickaxeID = 98
local bot = getBot("enricoA8")
local inventory = bot:getInventory()

-- run function
while true do
    wearItem(worldItemStorage, doorID, fuelID, harvesterID, pickaxeID, bot)
    print("")
    print("")
    sleep(5000)
end

-- checking if the user wearing fuelpack, harvester or harvester of sorrow and pickaxe
local function wearItem(worldItemStorage, doorID, fuelID, harvesterID, pickaxeID, bot)
    local itemList = {}
    local foundFuel = false
    local foundHarvester = false
    local foundPickaxe = false

    print("User ID ="..bot.name)

    -- Get Item by ID
    inventory_fuelPack = inventory:getItem(fuelID)
    inventory_harvester = inventory:getItem(harvesterID)
    inventory_pickaxe = inventory:getItem(pickaxeID)

    -- insert Item in the matrix itemList
    for i, item in pairs(inventory:getItems()) do
        table.insert(itemList, {id = item.id, name = getInfo(item.id).name, count = item.count or 0})
    end

    -- showing itemList
    for i, row in ipairs(itemList) do
        print("Row "..i..": ID="..row.id..", Name="..row.name..", Count="..row.count)
    end

    -- checking item based by id in the matrix itemList
    for _, row in ipairs(itemList) do
        if row.id == fuelID then
            print("Found fuelpack = "..inventory_fuelPack.count)
            foundFuel = true
        end

        if row.id == harvesterID then
            print("Found harvester = "..inventory_harvester.count)
            foundHarvester = true
        end

        if row.id == pickaxeID then
            print("Found pickaxe = "..inventory_pickaxe.count)
            foundPickaxe = true
        end
    end

    -- if item is not found
    if not foundFuel then
        print("There is no fuel pack")
    end
    if not foundHarvester then
        print("There is no harvester")
    end
    if not foundPickaxe then
        print("There is no pickaxe")
    end
end

