function SCHEMA:LoadFonts()
	for i = 4, 20 do
		surface.CreateFont("ax.CHud." .. ax.util:ZeroNumber(i, 2), {
			font = "OCR A Extended",
			size = ScreenScaleH(i),
			weight = 600,
			outline = true,
			shadow = true,
			antialias = false,
		})
	end
end

function SCHEMA:PostHUDPaint()
	local character = ax.client:GetCharacter()
	if ( !character ) then return end

	if ( IsValid(ax.gui.mainmenu) ) then return end

	local prevent = hook.Run("PreCHUDPaint")
	if ( prevent == true ) then
		hook.Run("CHUDPaint")
		hook.Run("PostCHUDPaint")
		return
	end
end

function SCHEMA:PreCHUDPaint()
	local character = ax.client:GetCharacter()
	if ( !character ) then return false end

	return character:IsCombine()
end

local padding = ScreenScale(32)
local strFormat = {
	vitals  = "VITALS :: %i%%",
	grid    = "GRID :: %02d :: %02d :: %02d",
	socio 	= "%s :: SOCIO-STATUS",
	bearing = "%i° %s :: BEARING",
}

local compassDir = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
	[360] = "N"
}

function SCHEMA:CHUDPaint()
	local character = ax.client:GetCharacter()
	if ( !character ) then return end

	local scrW, scrH = ScrW(), ScrH()

	local leftOffset = padding
	local rightOffset = padding
	local mainColour = ax.config:Get("chud.mainColour", color_white)
	if ( ax.config:Get("chud.colourTeamBased", false) ) then
		local teamColour = team.GetColor(ax.client:Team())
		mainColour = teamColour
	end

	_, textOffset = draw.SimpleText(string.format(strFormat.vitals, ax.client:Health()), "ax.CHud.07", padding, leftOffset, mainColour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	leftOffset = leftOffset + textOffset

	local grid = ax.client:GetPos()
	local gridX, gridY, gridZ = math.floor(grid.x / 64), math.floor(grid.y / 64), math.floor(grid.z / 64)

	_, textOffset = draw.SimpleText(string.format(strFormat.grid, gridX, gridY, gridZ), "ax.CHud.07", padding, leftOffset, mainColour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	leftOffset = leftOffset + textOffset

	local socioStatus = ax.sociostatus:Get()
	if ( istable(socioStatus) ) then
		_, textOffset = draw.SimpleText(string.format(strFormat.socio, socioStatus:GetName():upper()), "ax.CHud.07", ScrW() - padding, rightOffset, socioStatus:GetColour(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		rightOffset = rightOffset + textOffset
	end

	local angles = ax.client:EyeAngles()
	local compassWidth = scrW * 0.3 -- 30% of screen width
	local compassHeight = ScreenScaleH(7)
	local compassX = (scrW - compassWidth) / 2
	local compassY = padding

	-- Background for compass
	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawRect(compassX, compassY, compassWidth, compassHeight)

	-- Border for compass
	surface.SetDrawColor(mainColour.r, mainColour.g, mainColour.b, 100)
	surface.DrawOutlinedRect(compassX, compassY, compassWidth, compassHeight, 1)

	-- Get player's yaw (horizontal rotation)
	local yaw = angles.y
	local normalizedYaw = yaw % 360
	if normalizedYaw < 0 then normalizedYaw = normalizedYaw + 360 end

	-- Draw direction markers
	for i = 0, 360, 15 do
		-- Calculate position on compass bar relative to player's yaw
		local angleDiff = (i - normalizedYaw + 180) % 360 - 180
		local markerPos = (angleDiff + 180) / 360

		-- Only draw if marker is within visible range
		if markerPos >= 0 && markerPos <= 1 then
			local markerX = compassX + (markerPos * compassWidth)
			local markerHeight = (i % 90 == 0) && compassHeight || compassHeight * 0.6
			local markerColor = mainColour
			local markerWidth = (i % 90 == 0) && 2 || 1

			-- Draw the marker line
			surface.SetDrawColor(markerColor.r, markerColor.g, markerColor.b, 200)
			surface.DrawRect(markerX - (markerWidth / 2), compassY, markerWidth, markerHeight)

			-- Draw cardinal direction labels (N, E, S, W)
			if ( i % 90 == 0 ) then
				local dirChar = compassDir[i]
				draw.SimpleText(dirChar, "ax.CHud.07", markerX, compassY + compassHeight + 6,
					mainColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	-- Center indicator
	local centerWidth = ScreenScaleH(3)
	surface.SetDrawColor(255, 255, 255, 200)
	surface.DrawRect(scrW / 2 - centerWidth / 2, compassY - 2, centerWidth, compassHeight + 2)

	-- Draw bearing text below compass
	local bearing = math.floor(normalizedYaw)
	local directionKey = 0
	local minDiff = 360
	for deg, dir in pairs(compassDir) do
		local diff = math.abs((bearing - deg + 180) % 360 - 180)
		if diff < minDiff then
			minDiff = diff
			directionKey = deg
		end
	end

	_, textOffset = draw.SimpleText(string.format(strFormat.bearing, ax.util:ZeroNumber(bearing, 2), compassDir[directionKey] || "N"),
		"ax.CHud.06", scrW / 2, compassY + compassHeight + 20, mainColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	rightOffset = rightOffset + textOffset
	hook.Run("PostCHUDPaint")
end