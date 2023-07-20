if SERVER then
	util.AddNetworkString("TFA_ScreenShake")

	hook.Add("TFA_PostPrimaryAttack", "TFA_ScreenShakeDetect", function(wep)
		if wep:GetOwner():IsNPC() then return end
		if not wep.IsTFAWeapon then return end
		if not wep:GetOwner():Alive() then return end

		-- ТЫ ЧТО ТУТ БЛЯ ЗАБЫЛ? https://sun9-85.userapi.com/impg/fPEvcII-3N_I59My23iIsd_GnR1lybJ26Pj2dw/mOug2t0Id2c.jpg?size=600x600&quality=96&sign=5d5890625b0bae2702c626199bdd82c3&type=album

		net.Start("TFA_ScreenShake")
		net.Send(wep:GetOwner())
	end)
end

if CLIENT then
	local tfa_screenshake_enabled = CreateClientConVar("cl_tfa_screenshake_enabled", 1)
	local tfa_screenshake_blur_enabled = CreateClientConVar("cl_tfa_screenshake_blur_enabled", 1)
	local tfa_screenshake_strength_multiplier = CreateClientConVar("cl_tfa_screenshake_strength_multiplier", 1)
	local tfa_screenshake_fov_strength_multiplier = CreateClientConVar("cl_tfa_screenshake_fov_strength_multiplier", 1)
	local tfa_screenshake_speed_multiplier = CreateClientConVar("cl_tfa_screenshake_speed_multiplier", 1)

	RunConsoleCommand("mat_motion_blur_enabled", 1)

	local function LerpUnclamped(t, from, to)
		return t + (from - t) * to
	end

	local function InElasticEasedLerp(fraction, from, to)
		return LerpUnclamped(math.ease.InElastic(fraction), from, to)
	end

	local ScreenShakeFOVFraction = 0
	local ScreenShakeFOV = 0
	local ScreenShakeLeftFraction = 0
	local ScreenShakeLeftAngle = Angle(0, 0, 0)
	local ScreenShakeLeft = Angle(0, 0, 0)
	local ScreenShakeRightFraction = 0
	local ScreenShakeRightAngle = Angle(0, 0, 0)
	local ScreenShakeRight = Angle(0, 0, 0)
	local ScreenShakeBlurFraction = 0

	local hook_diving = false

	hook.Add("CalcView", "TFA_CustomScreenShake", function (ply, origin, angles, fov, znear, zfar)
		if hook_diving == true then return end
		local wep = ply:GetActiveWeapon()

		if not wep.IsTFAWeapon then return end
		if not ply:Alive() then return end
		if not tfa_screenshake_enabled:GetBool() then return end
		if ply:IsNPC() then return end

		local FOVMul = wep:GetStat("ScreenShakeFOVMultiplier") or 1
		local StrengthMul = wep:GetStat("ScreenShakeStrengthMultiplier") or 1
		local SpeedMul = wep:GetStat("ScreenShakeSpeedMultiplier") or 1

		local ScreenShakeSmoothing = 5
		local ScreenShakeFOVStrengthMultiplier = tfa_screenshake_fov_strength_multiplier:GetFloat() * (wep:GetStat("Primary.KickUp") + wep:GetStat("Primary.KickHorizontal")) * 7.5 * FOVMul
		local ScreenShakeStrengthMultiplier = tfa_screenshake_strength_multiplier:GetFloat() * (wep:GetStat("Primary.KickUp") + wep:GetStat("Primary.KickHorizontal")) * 30 * StrengthMul
		local ScreenShakeSpeedMultiplier = tfa_screenshake_speed_multiplier:GetFloat() * 1.5 * SpeedMul

		net.Receive("TFA_ScreenShake", function(len, ply)
			ScreenShakeFOVFraction = 1
			ScreenShakeBlurFraction = 1
			ScreenShakeLeftFraction = 1

			timer.Simple(0.025 * ScreenShakeSpeedMultiplier, function()
				ScreenShakeRightFraction = 1
			end)
		end)

		-- Shitcode alert https://sun9-85.userapi.com/impg/L7Oqe-ZpXe9Oh1h7bkdYli1VyQ_6osCRmMY9OA/XfTTKswiz6o.jpg?size=1080x752&quality=95&sign=e71bbdfb084836e106924fbc213407ca&type=album

		ScreenShakeFOVFraction = math.Approach(ScreenShakeFOVFraction, 0, FrameTime() * ScreenShakeSpeedMultiplier * 0.5)
		ScreenShakeFOV = InElasticEasedLerp(ScreenShakeFOVFraction, 0, ScreenShakeFOVStrengthMultiplier)

		ScreenShakeLeftFraction = math.Approach(ScreenShakeLeftFraction, 0, FrameTime() * ScreenShakeSpeedMultiplier)
		ScreenShakeLeftAngle = Angle(0, 0, InElasticEasedLerp(ScreenShakeLeftFraction, 0, ScreenShakeStrengthMultiplier))
		ScreenShakeLeft = LerpAngle(FrameTime() * ScreenShakeSmoothing, ScreenShakeLeft, ScreenShakeLeftAngle)

		ScreenShakeRightFraction = math.Approach(ScreenShakeRightFraction, 0, FrameTime() * ScreenShakeSpeedMultiplier)		
		ScreenShakeRightAngle = Angle(0, 0, InElasticEasedLerp(ScreenShakeRightFraction, 0, -ScreenShakeStrengthMultiplier))		
		ScreenShakeRight = LerpAngle(FrameTime() * ScreenShakeSmoothing, ScreenShakeRight, ScreenShakeRightAngle)

		angles:Add(ScreenShakeLeft)
		angles:Add(ScreenShakeRight)

		hook_diving = true

		local hook_dive_return = hook.Run("CalcView", ply, origin, angles, fov, znear, zfar) 
		hook_dive_return.fov = hook_dive_return.fov + ScreenShakeFOV

		hook_diving = false

		return hook_dive_return

		-- Fucked up FrameTime() shit cannot been fixed due to my skill issue
	end)

	hook.Add("GetMotionBlurValues", "TFA_CustomScreenShake_Blur", function(h, v, f, r)
		local ply = LocalPlayer()
		local wep = ply:GetActiveWeapon()

		if not wep.IsTFAWeapon then return end
		if not ply:Alive() then return end
		if not tfa_screenshake_blur_enabled:GetBool() then return end
		if ply:IsNPC() then return end

		local StrengthMul = wep:GetStat("ScreenShakeStrengthMultiplier") or 1
		local SpeedMul = wep:GetStat("ScreenShakeSpeedMultiplier") or 1

		local ScreenShakeBlurStrength = tfa_screenshake_strength_multiplier:GetFloat() * (wep:GetStat("Primary.KickUp") + wep:GetStat("Primary.KickHorizontal")) * 0.05 * StrengthMul
		local ScreenShakeBlurSpeed = tfa_screenshake_speed_multiplier:GetFloat() * 7.5 * SpeedMul

		ScreenShakeBlurFraction = math.Approach(ScreenShakeBlurFraction, 0, FrameTime() * ScreenShakeBlurSpeed)

		return h, v, f + (ScreenShakeBlurFraction * ScreenShakeBlurStrength), r
	end)
end