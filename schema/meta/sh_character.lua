local characterMeta = ax.character.meta

function characterMeta:IsCombine()
    return self:GetFaction() == FACTION_METROCOP || self:GetFaction() == FACTION_SOLDIER
end

function characterMeta:IsMetrocop()
    return self:GetFaction() == FACTION_METROCOP
end

function characterMeta:IsSoldier()
    return self:GetFaction() == FACTION_SOLDIER
end

function characterMeta:IsCitizen()
    return self:GetFaction() == FACTION_CITIZEN
end

function characterMeta:IsAdministrator()
    return self:GetFaction() == FACTION_ADMINISTRATOR
end