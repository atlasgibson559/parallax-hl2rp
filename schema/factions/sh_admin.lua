local FACTION = ax.faction:Instance()
FACTION:SetName("City Administration")
FACTION:SetDescription("The public face of Combine rule, spearheaded by the City Administrator and loyal aides. They disseminate propaganda, manage quotas and coordinate with Civil Protection.")
FACTION:SetColor(Color(125, 60, 160))

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter7")

FACTION:SetModels({
    "models/humans/group17/male_01.mdl",
    "models/humans/group17/male_02.mdl",
    "models/humans/group17/male_03.mdl",
    "models/humans/group17/male_04.mdl",
    "models/humans/group17/male_05.mdl",
    "models/humans/group17/male_06.mdl",
    "models/humans/group17/male_07.mdl",
    "models/humans/group17/male_08.mdl",
    "models/humans/group17/male_09.mdl",
    "models/humans/group17/female_01.mdl",
    "models/humans/group17/female_02.mdl",
    "models/humans/group17/female_03.mdl",
    "models/humans/group17/female_04.mdl",
    "models/humans/group17/female_06.mdl"
})

FACTION_ADMIN = FACTION:Register()