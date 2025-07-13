local FACTION = ax.faction:Instance()
FACTION:SetName("Vortigaunt")
FACTION:SetDescription("Inter-dimensional aliens freed from the Nihilanth who now wield vortessence alongside humanity. They mend wounds, guide resistance strategy and share ancient knowledge.")
FACTION:SetColor(Color(60, 140, 60))

FACTION.Image = ax.util:GetMaterial("gamepadui/hl2/chapter6")

FACTION:SetModels({
    "models/vortigaunt.mdl",
    "models/vortigaunt_blue.mdl"
})

FACTION_VORTIGAUNT = FACTION:Register()