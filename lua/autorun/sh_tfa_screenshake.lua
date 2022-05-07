local meta = FindMetaTable("Player")

function meta:GetDolbanul()
	return self:GetDTBool(13)
end

function meta:SetDolbanul(value)
	return self:SetDTBool(13, value)
end

hook.Add("TFA_PostPrimaryAttack", "TFA_ScreenShake", function(weapon)
	weapon:GetOwner():SetDolbanul(true)

	timer.Simple(0.0001, function()
		weapon:GetOwner():SetDolbanul(false)
	end)
end)

if CLIENT then
	local function LerpUnclamped(t, from, to)
		return t + (from - t) * to;
	end

	local function InElasticEasedLerp(fraction, from, to)
		return LerpUnclamped(math.ease.InElastic(fraction), from, to)
	end

	local TFAScreenShakeLeft = Angle(0, 0, 0)
	local TFAScreenShakeRight = Angle(0, 0, 0)
	local TFAScreenShakeFOV = 0
	local DolbanulAngleFractionLeft = 0
	local DolbanulAngleFractionRight = 0
	local DolbanulFOVFraction = 0

	local function TFACustomScreenShake(ply, origin, angles, fov, znear, zfar)
		if not ply:GetActiveWeapon().IsTFAWeapon then return end

		local weapon = ply:GetActiveWeapon()
		local IsDolbanul = ply:GetDolbanul()
		local ScreenShakeForce = (weapon.Primary.KickUp + weapon.Primary.KickHorizontal) * 1.25
		local view = {}

		view.origin = origin
		view.angles = angles
		view.fov = fov
		view.znear = znear
		view.zfar = zfar
		view.drawviewer = false

		if (IsValid(weapon)) then
			local func = weapon.CalcView

			if (func) then
				view.origin, view.angles, view.fov = func(weapon, ply, origin * 1, angles * 1, fov)
			end
		end

		if IsDolbanul then
			DolbanulAngleFractionLeft = 1
			DolbanulFOVFraction = 1

			timer.Simple(0.04, function()
				DolbanulAngleFractionRight = 1
			end)
		end

		DolbanulAngleFractionLeft = math.Approach(DolbanulAngleFractionLeft, 0, FrameTime() * 2.5)
		DolbanulAngleFractionRight = math.Approach(DolbanulAngleFractionRight, 0, FrameTime() * 2.5)
		DolbanulFOVFraction = math.Approach(DolbanulFOVFraction, 0, FrameTime() * 3)

		--local TFAScreenShakeAngleLeft = Angle(0, InElasticEasedLerp(DolbanulAngleFractionLeft, 0, ScreenShakeForce * -0.05), InElasticEasedLerp(DolbanulAngleFractionLeft, 0, ScreenShakeForce * 3.5))
		--local TFAScreenShakeAngleRight = Angle(0, InElasticEasedLerp(DolbanulAngleFractionRight, 0, ScreenShakeForce * 0.05), InElasticEasedLerp(DolbanulAngleFractionRight, 0, ScreenShakeForce * -3.5))
		local TFAScreenShakeAngleLeft = Angle(0, 0, InElasticEasedLerp(DolbanulAngleFractionLeft, 0, ScreenShakeForce * 4))
		local TFAScreenShakeAngleRight = Angle(0, 0, InElasticEasedLerp(DolbanulAngleFractionRight, 0, ScreenShakeForce * -4))

		TFAScreenShakeLeft = LerpAngle(DolbanulAngleFractionLeft * .25, TFAScreenShakeLeft, TFAScreenShakeAngleLeft)
		TFAScreenShakeRight = LerpAngle(DolbanulAngleFractionRight * .25, TFAScreenShakeRight, TFAScreenShakeAngleRight)
		TFAScreenShakeFOV = InElasticEasedLerp(DolbanulFOVFraction, 0, ScreenShakeForce * 5)

		view.angles = view.angles + TFAScreenShakeLeft + TFAScreenShakeRight
		view.fov = view.fov + TFAScreenShakeFOV

		return view
	end

	hook.Add("CalcView", "TFACustomScreenShake", TFACustomScreenShake)
end