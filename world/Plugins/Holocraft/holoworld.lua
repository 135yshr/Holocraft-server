UpdateQueue = nil
DummyFloor = {
    x = -4,
    y = -1,
    z = 6,
    width_x = 14,
    width_z = 14
}

function Tick(TimeDelta)
    UpdateQueue:update(50)
end

function Initialize(Plugin)
    Plugin:SetName("HoloWorld")
    Plugin:SetVersion(1)

    UpdateQueue = NewUpdateQueue()

    -- Hooks
    cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, OnWorldStarted)
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined);
    cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
    cPluginManager:AddHook(cPluginManager.HOOK_TICK, Tick);

    cRankManager:SetDefaultRank("Admin")

    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    return true
end
    
function OnChunkGenerating(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
    a_ChunkDesc:SetUseDefaultBiomes(false)
    a_ChunkDesc:SetUseDefaultHeight(false)
    a_ChunkDesc:SetUseDefaultComposition(false)
    a_ChunkDesc:SetUseDefaultFinish(false)
    return true
end

function OnWorldStarted(World)
    local y = DummyFloor.y + 65
    for x = DummyFloor.x, DummyFloor.width_x
    do
        for z = DummyFloor.z, DummyFloor.width_z
        do
            setBlock(UpdateQueue, x, y, z, E_BLOCK_WOOL, E_META_WOOL_WHITE)
        end
    end
end

function OnPlayerJoined(Player)
    -- enable flying
    Player:AddPosition(0, 66, 8)
    pos = Player:GetPosition()
    LOG(Player:GetName() .. " joined(" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ")")
end