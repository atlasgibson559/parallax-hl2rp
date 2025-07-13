local FACTION = ax.faction:Instance()
FACTION:SetName("Overwatch Transhuman Arm")
FACTION:SetDescription("Genetically-augmented shock troops deployed when civilian forces fail. Their purpose is the decisive annihilation of hostile elements and fortification of Combine interests.")
FACTION:SetColor(Color(150, 15, 15))

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter4")

FACTION:SetModels({
    "models/combine_soldier.mdl",
    "models/combine_super_soldier.mdl",
    "models/combine_soldier_prisonguard.mdl"
})

FACTION_OTA = FACTION:Register()