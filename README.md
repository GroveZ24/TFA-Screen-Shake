# TFA Screen Shake
Optional screen shake for use with TFA Base

### ConVars:
- `cl_tfa_screenshake_enabled` (1 by default) - Toggle screen shake
- `cl_tfa_screenshake_blur_enabled` (1 by default) - Toggle blur
- `cl_tfa_screenshake_strength_multiplier` (1 by default) - Screen shake strength multiplier
- `cl_tfa_screenshake_fov_strength_multiplier` (1 by default) - Screen shake FOV strength multiplier
- `cl_tfa_screenshake_speed_multiplier` (1 by default) - Screen shake speed multiplier

### For devs:
You can customize the screen shake on a per-weapon basis using:
- `SWEP.ScreenShakeStrengthMultiplier` - Screen shake strength multiplier
- `SWEP.ScreenShakeFOVMultiplier` - Screen shake FOV multiplier
- `SWEP.ScreenShakeSpeedMultiplier` - Screen shake speed multiplier

**NOTE:** I used CalcView and GetMotionBlurValues hooks, keep in mind that they're incompatible with similar hooks in other mods. Blame me, gmod, ur addons and my sh#tcode. Also, I haven't tested this sh#t in multiplayer and never will.
