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