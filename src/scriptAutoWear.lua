-- this script is for rotation farming but still using harvester or harvester of sorrow with fuel pack
-- originally made by Akechi001 on github
-- using harvester in auto wear lucifer and set the id of the shoes 1966


--setable value
worldItemStorage = "STORAGEWORLDNAME" -- Change it based on your world Storage (MAKE SURE IT'S CAPITAL LETTERS)
doorID = "IDDOORWORLD" -- change it based on your id door in world storage (MAKE SURE IT'S CAPITAL LETTERS)
fuelID = 1746 -- this is fuel pack ID in growtopia
bot = getBot() -- set bot that u want to check, change to getBot() = check all bot | getBot("username") = checking 1 bot account
cooldownTime = 3600000

--sleep value
findPathSleep = 250
collectObjectSleep = 500
warpSleep = 1000
pickItemSleep = 4000
loopingSleep = 5000
reloginSleep = 10000
retrycheckItemSleep = 2000

--
-- don't change anything from below here for prevent eror
--


-- fix value
status = getBot().status
inventory = bot:getInventory()
rotation = bot.rotation
malady = bot.auto_malady
lastFuelPackAttempt = 0

-- checking if the user wearing fuelpack
function wearItem(worldItemStorage, doorID, fuelID, bot)
    local itemList = {}
    local foundFuel = false
    local currentTime = os.time() * 1000

    print("Current time:", os.date("%Y-%m-%d %H:%M:%S"))
    print("User ID =" .. bot.name)

    -- Get Item by ID
    inventory_fuelPack = inventory:getItem(fuelID)

    -- insert Item in the matrix itemList
    for i, item in pairs(inventory:getItems()) do
        table.insert(itemList, { id = item.id, name = getInfo(item.id).name, count = item.count or 0 })
    end

    -- checking item based by id in the matrix itemList
    for _, row in ipairs(itemList) do
        if row.id == fuelID then
            print("Found fuelpack = " .. inventory_fuelPack.count)
            foundFuel = true
        end
    end

    -- if item is not found
    if not foundFuel then
        print("There is no fuel pack")

        if currentTime - lastFuelPackAttempt >= cooldownTime then
            print("Going to World Storage")
            sleep(pickItemSleep)

            if status == BotStatus.online then
                goToWorldStorage(worldItemStorage, doorID, bot)
                sleep(pickItemSleep)
                print("Picking fuelpack")
                pickFuelPack(fuelID, bot)
                enableRotationFarmAfterPickItem(bot)
            else
                print("Bot went offline during goToWorldStorage. Restarting loop...")
                return
            end
        else
            print("Fuelpack search is on cooldown. Skipping...")
        end
    else
        print("Fuel pack found and equipped.")
    end
end



--go to world storage
function goToWorldStorage(worldItemStorage, doorID, bot)
    local malady = bot.auto_malady
    rotation.enabled = false
    malady.enabled = false
    bot.auto_collect = false
    --checking various setting is disabled
    if rotation.enabled == false and bot.auto_collect == false then
        print("set rotation and auto collect disabled")
        bot:warp(worldItemStorage,doorID)
    else
        print("rotation or auto collect still active")
    end
    print("Checking status: rotation=" .. tostring(rotation.enabled) .. ", malady=" .. tostring(malady.enabled) .. ", auto_collect=" .. tostring(bot.auto_collect))


end

--pick fuel pack and auto wear from the storage world and enable rotation farm
function pickFuelPack(fuelID, bot)
    local found = false
    --checking fuel pack based by ID in storage world
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == fuelID and bot:getWorld().name == worldItemStorage then
            found = true
            bot:findPath(obj.x // 32, obj.y // 32)
            sleep(findPathSleep)
            bot:collectObject(obj.oid, 10)
            bot:wear(fuelID)
            sleep(warpSleep)
            enableRotationFarmAfterPickItem(bot)
            sleep(collectObjectSleep)
            bot:leaveWorld()
            print("Successfully picked up fuel pack")
            print("World after leaving: " .. bot:getWorld().name)
            break

        elseif status ~= BotStatus.online then
            sleep(300)
            print("Bot is offline. Retrying...")
            sleep(reloginSleep)
            status = bot.status
            return
        elseif bot:getWorld().name == "EXIT" then
            sleep(300)
            print("Bot is in EXIT world. Retrying...")
            return

        else
            print("No conditions matched. Debug this!")
        end
    end
    -- continue rotation and cooldown the function if the fuel doesn't exist in the storage world
    if not found then
        if bot:getWorld().name == worldItemStorage then
            print("Didn't find fuel pack... setting cooldown")
            print("World: " .. bot:getWorld().name)
            sleep(warpSleep)
            enableRotationFarmAfterPickItem(bot)
            lastFuelPackAttempt = os.time() * 1000
        elseif status ~= BotStatus.online then
            print("Bot is offline. Trying again...")
            sleep(reloginSleep)
            status = bot.status
            return
        elseif bot:getWorld().name == "EXIT" then
            print("Bot in EXIT world. Trying again...")
            return
        else
            print("No conditions matched. Debug this!")
        end
    end

end

function enableRotationFarmAfterPickItem(bot)
    --enabled features
    local malady = bot.auto_malady
    rotation.enabled = false
    rotation.enabled = true
    malady.enabled = true
    bot.auto_collect = true


    -- checking if the features is enable
    if rotation.enabled and malady.enabled and bot.auto_collect then
        print("Features enabled successfully: rotation=" .. tostring(rotation.enabled) ..
                ", malady=" .. tostring(malady.enabled) ..
                ", auto_collect=" .. tostring(bot.auto_collect))
        return
    else
        print("Failed to enable features. Retrying...")
        return
    end
end

function enableFeaturesRotation(bot)
    -- Enable rotation setting
    rotation.enabled = true
    rotation.visit_random_worlds = true
    rotation.pnb_in_home = true              	-- Enable PNB In Home
    rotation.seed_drop_amount = 100
    rotation.auto_rest = true
    rotation.auto_exchange = true
    rotation.auto_jammer = true
    rotation.clear_objects = true
    rotation.one_by_one = true

    bot.auto_ban = true                 	-- Enable Auto Ban Players
    bot.auto_wear = true			-- Enable Auto Wear
    bot.dynamic_delay = true
    bot.wear_storage = worldItemStorage.."|"..doorID		-- Wear storage

    -- Check all features
    if rotation.enabled
            and rotation.visit_random_worlds
            and rotation.pnb_in_home
            and rotation.auto_rest
            and rotation.auto_exchange
            and rotation.auto_jammer
            and rotation.clear_objects
            and rotation.one_by_one
            and bot.auto_ban
            and bot.auto_wear
            and bot.dynamic_delay then
        print("Enabled rotation successfully! All features are active.")
    else
        print("Some features failed to activate.")
        return
    end
end


function enableFeaturesMalady(bot)
    -- Enable malady settings
    malady.enabled = true
    malady.auto_chicken_feet = true -- Auto Chicken Feet
    malady.auto_grumbleteeth = true -- Auto Grumbleteeth
    malady.auto_refresh = true -- Auto Refresh

    local spam = bot.auto_spam.messages
    spam:set(1, "sf")
    spam:set(2, "sd")
    spam:set(3, "sw")
    spam:set(4, "sf")

    -- Check all features
    if malady.enabled
            and malady.auto_chicken_feet
            and malady.auto_grumbleteeth
            and malady.auto_refresh then
        print("Malady features enabled successfully. All features are active.")
    else
        print("Some malady features failed to activate.")
        return
    end
end


--execution function
while true do
    if status == BotStatus.online then
        if enableFeaturesMalady then
            enableFeaturesMalady(bot)
        else
            print("Error: enableFeaturesMalady is nil")
        end

        if enableFeaturesRotation then
            enableFeaturesRotation(bot)
        else
            print("Error: enableFeaturesRotation is nil")
        end

        while status == BotStatus.online do
            wearItem(worldItemStorage, doorID, fuelID, bot)
            print("")
            print("")
            sleep(loopingSleep)
        end
        print("Bot went offline. Restarting feature initialization...")
        sleep(reloginSleep)
        status = bot.status
    else
        print("Bot is offline, retrying in 10 seconds...")
        sleep(reloginSleep)
        status = bot.status
    end
end
