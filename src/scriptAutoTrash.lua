-- Constants
FISH = {
    HERMIT = 3460,
    CRAWDAD = 3458,
    PURPLE_SHORE = 3452,
    LOBSTER = 3450,
    DUNGEON_CRAB = 3456,
    ALASKAN = 3454
}

SLEEP_TIMES = {
    FIND_PATH = 250,
    COLLECT_OBJECT = 500,
    WARP = 1000,
    PICK_ITEM = 4000,
    LOOPING = 5000,
    RELOGIN = 10000,
    RETRY_CHECK_ITEM = 2000
}


-- Bot setup
bot = getBot() -- set bot that u want to check, change to getBot() = check all bot | getBot("username") = checking 1 bot account
status = bot.status
inventory = bot:getInventory()
lastTrashAttempt = 0

-- Function to trash fish
function trashFish(fishID, bot)
    print("Attempting to trash fish with ID: " .. fishID)
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == fishID then
            print("Found fish with ID: " .. fishID .. " at position (" .. obj.x//32 .. ", " .. obj.y//32 .. ")")
            bot:findPath(obj.x // 32, obj.y // 32)
            sleep(SLEEP_TIMES.FIND_PATH)
            bot:collectObject(obj.oid, 10)
            sleep(SLEEP_TIMES.WARP)
            bot:trash(fishID, 199)
            sleep(2000)
            print("Successfully trashed fish with ID: " .. fishID)
            return true
        end
    end
    print("No fish found with ID: " .. fishID)
    return false
end

-- Main loop
while true do
    if status == BotStatus.online then
        print("Bot is online. Starting fish trashing process...")
        while status == BotStatus.online do
            -- Iterate over all fish types
            for fishName, fishID in pairs(FISH) do
                print("Checking for fish: " .. fishName .. " (ID: " .. fishID .. ")")
                if trashFish(fishID, bot) then
                    print("Fish trashed successfully. Moving to next cycle...")
                    break -- Stop checking other fish if one is found and trashed
                end
            end
            sleep(SLEEP_TIMES.LOOPING)
        end
        print("Bot went offline. Restarting feature initialization...")
        sleep(SLEEP_TIMES.RELOGIN)
        status = bot.status
    else
        print("Bot is offline, retrying in 10 seconds...")
        sleep(SLEEP_TIMES.RELOGIN)
        status = bot.status
    end
end