function Initialize(Plugin)
    Plugin:SetName("HoloWorld")
    Plugin:SetVersion(1)

    -- Hooks
    cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);

    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    return true
end
    
function OnChunkGenerating(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
    a_ChunkDesc:SetUseDefaultBiomes(false)
    a_ChunkDesc:SetUseDefaultHeight(false)
    a_ChunkDesc:SetUseDefaultComposition(false)
    a_ChunkDesc:SetUseDefaultFinish(false)
end

function PlayerJoined(Player)
    -- enable flying
    Player:SetCanFly(true)
    LOG(Player:GetName() .. " joined")
end