# TFA Screen Shake
Optional screen shake for use with TFA Base

### ConVars:
- `cl_tfa_screenshake_enabled` (1 by default) - Toggle screen shake
- `cl_tfa_screenshake_blur_enabled` (1 by default) - Toggle blur
- `cl_tfa_screenshake_force_multiplier` (1 by default) - Screen shake force multiplier
- `cl_tfa_screenshake_fov_force_multiplier` (1 by default) - Screen shake FOV force multiplier
- `cl_tfa_screenshake_speed_multiplier` (1 by default) - Screen shake speed multiplier

### For devs:
You can customize the screen shake on a per-weapon basis using:
- `SWEP.ScreenShakeForceMultiplierOverride` - Overrides screen shake force multiplier
- `SWEP.ScreenShakeFOVForceMultiplierOverride` - Overrides screen shake FOV force multiplier
- `SWEP.ScreenShakeSpeedMultiplierOverride` - Overrides screen shake speed multiplier

**NOTE:** I used `CalcView` and `GetMotionBlurValues` hooks, keep in mind that they're incompatible with similar hooks in other mods. Blame me and my shitcode.
