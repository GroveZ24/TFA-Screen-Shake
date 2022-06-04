# TFA Screen Shake
Optional screen shake for use with TFA Base

### ConVars:
- `cl_tfa_screenshake_enabled` (1 by default) - Toggle screen shake  
- `cl_tfa_screenshake_blur_enabled` (1 by default) - Toggle blur  
- `cl_tfa_screenshake_multiplier` (1 by default) - Screen shake multiplier  

**NOTE:** Since I used `FrameTime()`, screen shake won't work while you have VSYNC on or when your frametime is unstable. Also I used `CalcView` and `GetMotionBlurValues` hooks, keep in mind that they're incompatible with similar hooks in other mods. Blame me and my shitcode. 
