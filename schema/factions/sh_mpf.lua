local FACTION = ax.faction:Instance()
FACTION:SetName("Metropolice Force")
FACTION:SetDescription("Implanted human collaborators who police the urban zones for the Combine. They impose curfews, break up dissent and suppress resistance with lethal efficiency.")
FACTION:SetColor(Color(45, 90, 140))

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter3")

FACTION:SetModels({
    "models/police.mdl"
})

FACTION.AllowNonAscii = true

FACTION.Taglines = {
    "DEFENDER",
    "HERO",
    "JURY", -- test
    "KING",
    "LINE",
    "PATROL",
    "QUICK",
    "ROLLER",
    "STICK",
    "TAP",
    "UNION",
    "VICTOR",
    "XRAY",
    "YELLOW"
}

function FACTION:GetDefaultName(client)
    return "MPF:" .. ax.config:Get("city.abbreviation") .. "-" .. self.Taglines[math.random(#self.Taglines)] .. "-" .. ax.util:ZeroNumber(math.random(1, 9999), 4), true
end

FACTION_MPF = FACTION:Register()

ax.animations:SetModelClass("models/police.mdl", "metrocop")
ax.animations:SetModelClass("models/police/eliteghostcp.mdl", "metrocop")
ax.animations:SetModelClass("models/police/eliteshockcp.mdl", "metrocop")
ax.animations:SetModelClass("models/police/leet_police2.mdl", "metrocop")
ax.animations:SetModelClass("models/police/policetrench.mdl", "metrocop")
ax.animations:SetModelClass("models/police/sect_police2.mdl", "metrocop")
