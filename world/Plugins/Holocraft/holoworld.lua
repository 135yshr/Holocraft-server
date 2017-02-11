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
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACED_BLOCK, OnPlayerPlacedBlock)
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BROKEN_BLOCK, OnPlayerBrokenBlock)
    cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
    cPluginManager:AddHook(cPluginManager.HOOK_TICK, Tick)

    cRankManager:SetDefaultRank("Admin")

    cNetwork:Connect(SERVER_ADDR, SERVER_PORTS, TCP_CLIENT)

    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    return true
end

function HandleRequest_HoloWorld(Request)
    local action = Request.PostParams["action"]
    LOG("action: " .. action)

    if action == "setblock" then
        local blockType = E_BLOCK_WOOL
        local x = tonumber(Request.PostParams["pos_x"])
        local y = tonumber(Request.PostParams["pos_y"])
        local z = tonumber(Request.PostParams["pos_z"])
        setBlock(UpdateQueue, x, y, z, blockType, E_META_WOOL_WHITE)
        LOG(action .. "(" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ")")
    end
    if action == "delblock" then
        local blockType = E_BLOCK_AIR
        local x = tonumber(Request.PostParams["pos_x"])
        local y = tonumber(Request.PostParams["pos_y"])
        local z = tonumber(Request.PostParams["pos_z"])
        setBlock(UpdateQueue, x, y, z, blockType, E_META_WOOL_WHITE)
        LOG(action .. "(" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ")")
    end
end

function OnChunkGenerating(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
    a_ChunkDesc:SetUseDefaultBiomes(false)
    a_ChunkDesc:SetUseDefaultHeight(false)
    a_ChunkDesc:SetUseDefaultComposition(false)
    a_ChunkDesc:SetUseDefaultFinish(false)
    return true
end

function OnWorldStarted(World)
    -- SendTCPMessage({action="world_size"})

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
    Player:SetPosition(0, 66, 8)
    pos = Player:GetPosition()
    LOG(Player:GetName() .. " joined(" .. pos.x .. "," .. pos.y .. "," .. pos.z .. ")")
end

function OnPlayerPlacedBlock(Player, BlockX, BlockY, BlockZ, BlockType, BlockMeta)
    SendTCPMessage({action="setblock", pos={x=BlockX, y=BlockY-65, z=BlockZ}})
end

function OnPlayerBrokenBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
    SendTCPMessage({action="delblock", pos={x=BlockX, y=BlockY-65, z=BlockZ}})
end
