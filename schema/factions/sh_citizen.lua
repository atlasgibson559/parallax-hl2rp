local FACTION = ax.faction:Instance()
FACTION:SetName("Citizen")
FACTION:SetDescription("Ordinary humans trying to survive under the Universal Union’s occupation. They queue for rations, heed curfews, and cling to rumours of freedom.")
FACTION:SetColor(Color(150, 150, 150))
FACTION:MakeDefault()

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter1")

FACTION:SetModels({
    "models/humans/group01/male_01.mdl",
    "models/humans/group01/male_02.mdl",
    "models/humans/group01/male_03.mdl",
    "models/humans/group01/male_04.mdl",
    "models/humans/group01/male_05.mdl",
    "models/humans/group01/male_06.mdl",
    "models/humans/group01/male_07.mdl",
    "models/humans/group01/male_08.mdl",
    "models/humans/group01/male_09.mdl",
    "models/humans/group01/female_01.mdl",
    "models/humans/group01/female_02.mdl",
    "models/humans/group01/female_03.mdl",
    "models/humans/group01/female_04.mdl",
    "models/humans/group01/female_06.mdl"
})

FACTION_CITIZEN = FACTION:Register()