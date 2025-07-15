local cameraSounds = {
    ["npc/turret_floor/ping.wav"] = true,
    ["npc/turret_floor/deploy.wav"] = true,
    ["npc/turret_floor/click1.wav"] = true,
    ["ambient/alarms/klaxon1.wav"] = true
}

function SCHEMA:EntityEmitSound(data)
    local ent = data.Entity
    if ( !IsValid(ent) ) then return end

    if ( ent:GetClass() == "npc_combine_camera" ) then
        if ( cameraSounds[data.SoundName] ) then
            data.SoundLevel = 60

            return true
        end
    elseif ( ent:IsNPC() ) then
        data.SoundLevel = data.SoundLevel - 15

        return true
    end
end

local reloaded = false
function SCHEMA:OnReloaded()
    if ( reloaded ) then return end
    reloaded = true

    if ( SERVER ) then
        if ( ax.dispatch:CanPlayAmbient() ) then
            ax.dispatch:CreateAmbientTimer()
        else
            timer.Remove("ax.dispatch.ambience")
        end
    end
end

function SCHEMA:IsPlayerDeveloper(client)
    return client:SteamID64() == "76561198373309941"
end