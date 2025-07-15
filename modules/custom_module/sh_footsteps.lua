MODULE.Name = "Footsteps"
MODULE.Description = "Rewrites and improves on Source's handling of footsteps."
MODULE.Author = "bloodycop6385 (porter to ax) & TankNut"

ax.config:Register("footstep.volumeMultiplier", {
	Type = ax.types.number,
	Default = 1,
	Min = 0,
	Max = 2,
	Decimals = 1,
	Category = "Footsteps",

	Name = "config.footstep.volumeMultiplier",
	Description = "config.footstep.volumeMultiplier.help"
})

ax.config:Register("footstep.silentCrouching", {
	Type = ax.types.bool,
	Default = false,
	Category = "Footsteps",

	Name = "config.footstep.silentCrouching",
	Description = "config.footstep.silentCrouching.help"
})

ax.config:Register("footstep.silentWalking", {
	Type = ax.types.bool,
	Default = false,
	Category = "Footsteps",

	Name = "config.footstep.silentWalking",
	Description = "config.footstep.silentWalking.help"
})

ax.config:Register("footstep.allowPersonalFootstepVolume", {
	Type = ax.types.bool,
	Default = true,
	Category = "Footsteps",

	Name = "config.footstep.allowPersonalFootstepVolume",
	Description = "config.footstep.allowPersonalFootstepVolume.help"
})

ax.option:Register("footstep.volume", {
	Min = 0.1,
	Max = 2,
	Decimals = 1,
	Category = "Footsteps",
	NoNetworking = true,
	Default = 1,

	Name = "option.footstep.volume",
	Description = "option.footstep.volume.help"
})

function MODULE:PlayerFootstep(client)
	return true
end

function MODULE:EntityEmitSound(info)
	-- It's an ugly way of doing it but short of recompiling all of the HL2 models you're not gonna be able to prevent their baked-in sounds from playing.
	if IsValid(info.Entity) and info.Entity:IsPlayer() and !IsEmittingPlayerStep and string.find(info.OriginalSoundName, "step") then
		return false
	end
end

if CLIENT then
	function MODULE:Think()
		for _, client in player.Iterator() do
			local clientTable = client:GetTable()
			if !clientTable.NextStepTime then
				clientTable.NextStepTime = 0
				clientTable.NextStepSide = false
				clientTable.StepSkip = 0
			end

			if client:IsDormant() or clientTable.NextStepTime > CurTime() then
				continue
			end

			if client:InObserver() then
				continue
			end

			if client:GetMoveType() != MOVETYPE_LADDER and !client:IsFlagSet(FL_ONGROUND) then
				continue
			end

			if ax.config:Get("footstep.silentCrouching") and client:Crouching() then
				continue
			end

			if ax.config:Get("footstep.silentWalking") and client:KeyDown(IN_WALK) then
				continue
			end

			local vel = client:GetVelocity():Length()

			if vel < hook.Run("GetMinStepSpeed", client) then
				continue
			end

			local side = client.NextStepSide

			if hook.Run("HandlePlayerStep", client, side) == true then
				continue
			end

			clientTable.NextStepTime = CurTime() + hook.Run("GetNextStepTime", client, vel)
			clientTable.NextStepSide = !side
		end
	end

	function MODULE:HandlePlayerStep(client, side)
		local clientTable = client:GetTable()
		-- Submerged footsteps play less often through a kinda weird method
		if client:WaterLevel() >= 1 then
			if clientTable.StepSkip == 2 then
				clientTable.StepSkip = 0
			else
				clientTable.StepSkip = clientTable.StepSkip + 1

				return true
			end
		end
	end

	-- GAMEMODE functions, act as fallbacks for hook.Run
	function GAMEMODE:GetMinStepSpeed(client)
		return ax.config:Get("speed.walk") * client:GetCrouchedWalkSpeed()
	end

	function GAMEMODE:GetNextStepTime(client, vel)
		if client:GetMoveType() == MOVETYPE_LADDER then
			return 0.45
		end

		local val

		if client:WaterLevel() >= 1 then
			val = 0.6
		else
			if client:KeyDown(IN_WALK) and vel < 90 then
				val = 0.375 / (vel / 90)
			else
				val = math.max(math.Remap(vel, 90, 235, 0.4, 0.3), 0.1)
			end
		end

		if client:Crouching() then
			val = val + 0.1
		end

		return val
	end

	local ladderSurface = util.GetSurfaceData(util.GetSurfaceIndex("ladder"))
	local wadeSurface = util.GetSurfaceData(util.GetSurfaceIndex("wade"))

	function GAMEMODE:GetDefaultStepSound(client, side)
		if client:GetMoveType() == MOVETYPE_LADDER then
			return side and ladderSurface.stepRightSound or ladderSurface.stepLeftSound, 0.5
		elseif client:WaterLevel() >= 1 then
			return side and wadeSurface.stepRightSound or wadeSurface.stepLeftSound, client:IsRunning() and 0.65 or 0.25
		else
			local volume = client:IsRunning() and 0.5 or 0.2
			local snd

			local prop = client:GetSurfaceData()

			if prop then
				snd = side and prop.stepRightSound or prop.stepLeftSound
			else
				snd = side and "Default.StepRight" or "Default.StepLeft"
			end

			return snd, volume
		end
	end

	function GAMEMODE:ModifyPlayerStep(client, data)
		local character = client:GetCharacter()

		if character then
			local faction = character:GetFactionData()
			if istable(faction) and isfunction(faction.ModifyPlayerStep) and faction:ModifyPlayerStep(client, data) == true then
				return true
			end

			local class = character:GetClassData()
			if istable(class) and isfunction(class.ModifyPlayerStep) and class:ModifyPlayerStep(client, data) == true then
				return true
			end
		end

		if client:Crouching() then
			data.volume = data.volume * 0.65
		end
	end

	function GAMEMODE:HandlePlayerStep(client, side)
		local snd, volume = hook.Run("GetDefaultStepSound", client, side)

		local data = {
			snd = snd,
			side = side,
			volume = volume,
			ladder = client:GetMoveType() == MOVETYPE_LADDER,
			submerged = client:WaterLevel() >= 1,
			running = client:IsRunning()
		}

		if hook.Run("ModifyPlayerStep", client, data) == false then
			return
		end

		volume = data.volume * ax.config:Get("footstep.volumeMultiplier")

		if ax.config:Get("footstep.allowPersonalFootstepVolume") then
			volume = volume * ax.option:Get("footstep.volume")
		end

		IsEmittingPlayerStep = true
		EmitSound(data.snd, client:GetPos(), client:EntIndex(), CHAN_AUTO, volume)
		IsEmittingPlayerStep = nil
	end
end

local playerMeta = FindMetaTable("Player")
local offset = Vector(0, 0, 16)

function playerMeta:GetSurfaceData()
	local mins, maxs = self:GetHull()
	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos() - offset,
		filter = {self},
		mins = mins,
		maxs = maxs,
		collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
	})

	return util.GetSurfaceData(tr.SurfaceProps)
end

function playerMeta:IsRunning()
	local velocity = self:GetVelocity()
	local speed = velocity:Length()

	return speed > self:GetWalkSpeed() * 1.2
end