function SCHEMA:PlayerFootstep(client, position, foot, soundName, volume)
    if ( client:IsSprinting() ) then
        if ( client:Team() == FACTION_MPF ) then
            client:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav", 80, 100, 1, CHAN_AUTO)

            return true
        elseif ( client:Team() == FACTION_OTA ) then
            client:EmitSound("npc/combine_soldier/gear" .. math.random(1, 6) .. ".wav", 80, 100, 1, CHAN_AUTO)

            return true
        end
    end
end

function SCHEMA:PostPlayerLoadout(client)
    if ( client:IsCombine() ) then
        if ( client:Team() == FACTION_MPF ) then
            client:SetArmor(50)
        else
            client:SetArmor(100)
        end
    end
end

function SCHEMA:PlayerUse(client, entity)
    local isAdminFaction = client:Team() == FACTION_ADMIN
    if ( client:IsCombine() or isAdminFaction ) then
        if ( !entity:HasSpawnFlags(256) and !entity:HasSpawnFlags(1024) and !entity:OnCooldown("Use") and entity:GetClass() == "func_door" ) then
            entity:Fire("Open", "", 0)
            entity:SetCooldown("Use", 1)
            entity:EmitSound("buttons/combine_button1.wav", 70, 100, 0.5, CHAN_AUTO)
        end
    end
end

function SCHEMA:PlayerSwitchFlashlight(client, enabled)
    return client:IsCombine()
end

function SCHEMA:PlayerStartVoice(speaker)
    local character = speaker:GetCharacter()
    if ( !character ) then return end

    local faction = character:GetFactionData()
    if ( istable(faction) ) then
        local sound = faction.VoiceChatBleeps && faction.VoiceChatBleeps.On -- done using sound.Add
        if ( isstring(sound) && #sound > 0 ) then
            local speakerTable = speaker:GetTable()
            local nextBleep = speakerTable.axNextVoiceBleep || 0
            if ( isnumber(nextBleep) && nextBleep > CurTime() ) then return end

            speaker:EmitSound(sound, 90, 100, 1, CHAN_VOICE)
            speakerTable.axNextVoiceBleep = CurTime() + (faction.VoiceChatBleeps.Delay || 1)
            speakerTable.axBVoiceBleep = true
        end
    end
end

function SCHEMA:PlayerEndVoice(speaker)
    local character = speaker:GetCharacter()
    if ( !character ) then return end

    local faction = character:GetFactionData()
    if ( istable(faction) ) then
        local sound = faction.VoiceChatBleeps && faction.VoiceChatBleeps.Off -- done using sound.Add
        if ( isstring(sound) && #sound > 0 ) then
            local speakerTable = speaker:GetTable()
            if ( speakerTable.axBVoiceBleep == false ) then return end

            speaker:EmitSound(sound, 90, 100, 1, CHAN_VOICE)
            speakerTable.axBVoiceBleep = false
        end
    end
end