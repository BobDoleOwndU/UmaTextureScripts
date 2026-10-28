@echo off
SetLocal EnableDelayedExpansion

:Start
cls
echo Select an option:
echo 0: Body/Hair/Tail
echo 1: Face
echo 2: Eyes

set "optionSelect="
set /p "optionSelect="

if "%optionSelect%" == "0" goto BasePrompt
if "%optionSelect%" == "1" goto BasePrompt
if "%optionSelect%" == "2" goto DiffusionPrompt

goto Start

:BasePrompt
cls
echo Drag the BASE texture into this window, then press enter

set "basePath="
set /p "basePath="

if defined basePath (
	set basePath=%basePath:"=%
)

if "%basePath%" == "" (
	goto BasePrompt
)

:DiffusionPrompt
cls
echo Drag the DIFFUSION texture into this window, then press enter

set "diffPath="
set /p "diffPath="

if defined diffPath (
	set diffPath=%diffPath:"=%
)

if "%diffPath%" == "" (
	goto DiffusionPrompt
)

if "%optionSelect%" == "2" goto Eyehi0Prompt 

goto ShadowPrompt

:ShadowPrompt
cls
echo Drag the SHADOW texture into this window, then press enter

set "shadPath="
set /p "shadPath="

if defined shadPath (
	set shadPath=%shadPath:"=%
)

if "%shadPath%" == "" (
	goto ShadowPrompt
)

if "%optionSelect%" == "1" goto ImgEditFace

goto ImgEdit

:Eyehi0Prompt
cls
echo Drag the EYE HIGHLIGHT 0 texture into this window, then press enter

set "eyehi0Path= "
set /p "eyehi0Path= "

if defined eyehi0Path (
	set eyehi0Path=%eyehi0Path:"=%
)

if "%eyehi0Path%" == "" (
	goto EyeHi0Prompt
)

:Eyehi1Prompt
cls
echo Drag the EYE HIGHLIGHT 1 texture into this window, then press enter

set "eyehi1Path= "
set /p "eyehi1Path= "

if defined eyehi1Path (
	set eyehi1Path=%eyehi1Path:"=%
)

if "%eyehi1Path%" == "" (
	goto Eyehi1Prompt
)

goto ImgEditEye

:ImgEdit
cls
echo Editing!

magick "%basePath%" ^
	-set option:img_w %%[w] ^
	-set option:img_h %%[h] ^
	( ^
		-clone 0 ^
		-channel alpha -fx "max(1-u.r, max(u.g, 1-u.b))" ^
		-channel R     -fx "u.a > 0 ? 1 - (1 - u.r) / u.a : 0" ^
		-channel G     -fx "u.a > 0 ? u.g / u.a : 0" ^
		-channel B     -fx "u.a > 0 ? 1 - (1 - u.b) / u.a : 0" ^
		+channel -write mpr:magenta_to_alpha ^
		+delete ^
	) ^
	( mpr:magenta_to_alpha -fill #ffffff -colorize 100 -write mpr:shad_mask ) ^
	( "%shadPath%" -resize %%[img_w]x%%[img_h] -write mpr:shad ) ^
	( mpr:shad_mask mpr:shad -compose multiply -composite mpr:shad_mask -compose copy_opacity -composite -write mpr:final ) ^
	( "%diffPath%" -resize %%[img_w]x%%[img_h] -write mpr:diff ) ^
	( mpr:diff mpr:final -compose over -composite -write mpr:final ) ^
	( ^
		mpr:magenta_to_alpha ^
		-channel alpha -fx "u.a > 0 ? (max(u.r, max(u.g, 1-u.b)) * u.a) : 0" ^
		-channel R     -fx "u.a > 0 ? u.r / u.a : 0" ^
		-channel G     -fx "u.a > 0 ? u.g / u.a : 0" ^
		-channel B     -fx "u.a > 0 ? 1 - (1 - u.b) / u.a : 0" ^
		+channel -write mpr:blue_to_alpha ^
	) ^
	( mpr:blue_to_alpha -fill #ffffff -colorize 100 -write mpr:highlight ) ^
	( mpr:final mpr:highlight -compose overlay -composite -write result.png ) ^
NULL:

goto Done

:ImgEditFace
cls
echo Editing!

magick "%basePath%" ^
	-set option:img_w %%[w] ^
	-set option:img_h %%[h] ^
	( ^
		-clone 0 ^
		-channel alpha -fx "max(1-u.r, max(u.g, 1-u.b))" ^
		-channel R     -fx "u.a > 0 ? 1 - (1 - u.r) / u.a : 0" ^
		-channel G     -fx "u.a > 0 ? u.g / u.a : 0" ^
		-channel B     -fx "u.a > 0 ? 1 - (1 - u.b) / u.a : 0" ^
		+channel -write mpr:magenta_to_alpha ^
		+delete ^
	) ^
	( ^
		mpr:magenta_to_alpha ^
		-channel alpha -fx "u.a > 0 ? (max(1-u.r, max(1-u.g, 1-u.b)) * u.a) : 0" ^
		-channel R     -fx "u.a > 0 ? 1 - (1 - u.r) / u.a : 0" ^
		-channel G     -fx "u.a > 0 ? 1 - (1 - u.g) / u.a : 0" ^
		-channel B     -fx "u.a > 0 ? 1 - (1 - u.b) / u.a : 0" ^
		+channel -write mpr:white_to_alpha ^
	) ^
	( mpr:white_to_alpha -fill #ffffff -colorize 100 -write mpr:shad_mask ) ^
	( "%shadPath%" -resize %%[img_w]x%%[img_h] -write mpr:shad ) ^
	( mpr:shad_mask mpr:shad -compose multiply -composite mpr:shad_mask -compose copy_opacity -composite -write mpr:final ) ^
	( mpr:final -fuzz 6.7%% -transparent #dec7c6 -write mpr:final ) ^
	( "%diffPath%" -resize %%[img_w]x%%[img_h] -write mpr:diff ) ^
	( mpr:diff mpr:final -compose over -composite -write result.png ) ^
NULL:

goto Done

:ImgEditEye
cls
echo Editing!

magick "%diffPath%" ^
	-set option:img_w %%[w] ^
	-set option:img_h %%[h] ^
	( -size %%[img_w]x%%[img_h] tile:"%eyehi0Path%" -write mpr:hi1 ) ^
	( ^
		mpr:hi1 ^
		-channel alpha -fx "max(u.r, max(u.g, u.b))" ^
		-channel R     -fx "u.a > 0 ? u.r / u.a : 0" ^
		-channel G     -fx "u.a > 0 ? u.g / u.a : 0" ^
		-channel B     -fx "u.a > 0 ? u.b / u.a : 0" ^
		+channel -write mpr:hi1 ^
	) ^
	( -size %%[img_w]x%%[img_h] tile:"%eyehi1Path%" -write mpr:hi2 ) ^
	( ^
		mpr:hi2 ^
		-channel alpha -fx "max(u.r, max(u.g, u.b))" ^
		-channel R     -fx "u.a > 0 ? u.r / u.a : 0" ^
		-channel G     -fx "u.a > 0 ? u.g / u.a : 0" ^
		-channel B     -fx "u.a > 0 ? u.b / u.a : 0" ^
		+channel -write mpr:hi2 ^
	) ^
	( -clone 0 mpr:hi1 mpr:hi2 -compose over -layers flatten -write result.png ) ^
NULL:

:Done
echo Done!

pause