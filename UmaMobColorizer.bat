@echo off
SetLocal EnableDelayedExpansion

:AreaPrompt
cls
echo Drag the AREA texture into this window, then press enter

set "areaPath="
set /p "areaPath="

if defined areaPath (
	set areaPath=%areaPath:"=%
)

if "%areaPath%" == "" (
	goto AreaPrompt
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

echo AREA Texture: "%areaPath%"
echo DIFFUSION Texture: "%diffPath%"

:R1Prompt
cls
echo Enter the hex code for r1

set "r1="
set /p "r1="

if defined r1 (
	set r1=%r1:"=%
)

if "%areaPath%" == "" (
	goto R1Prompt
)

:R2Prompt
cls
echo Enter the hex code for r2

set "r2="
set /p "r2="

if defined r2 (
	set r2=%r2:"=%
)

if "%areaPath%" == "" (
	goto R2Prompt
)

:G1Prompt
cls
echo Enter the hex code for g1

set "g1="
set /p "g1="

if defined g1 (
	set g1=%g1:"=%
)

if "%areaPath%" == "" (
	goto G1Prompt
)

:G2Prompt
cls
echo Enter the hex code for g2

set "g2="
set /p "g2="

if defined g2 (
	set g2=%g2:"=%
)

if "%areaPath%" == "" (
	goto G2Prompt
)

:B1Prompt
cls
echo Enter the hex code for b1

set "b1="
set /p "b1="

if defined b1 (
	set b1=%b1:"=%
)

if "%areaPath%" == "" (
	goto B1Prompt
)

:B2Prompt
cls
echo Enter the hex code for b2

set "b2="
set /p "b2="

if defined b2 (
	set b2=%b2:"=%
)

if "%areaPath%" == "" (
	goto B2Prompt
)

:ImgEdit
cls
echo Editing!

magick "%areaPath%" ^
	-set option:img_w %%[w] ^
	-set option:img_h %%[h] ^
	-channel RGB -separate ^
			( -clone 0 -level 0%%,49.8%% -negate -write mpr:r1_mask +delete ) ^
			( -clone 0 -level 50.2%%,100%% -write mpr:r2_mask +delete ) ^
			( -clone 1 -level 0%%,49.8%% -negate -write mpr:g1_mask +delete ) ^
			( -clone 1 -level 50.2%%,100%% -write mpr:g2_mask +delete ) ^
			( -clone 2 -level 0%%,49.8%% -negate -write mpr:b1_mask +delete ) ^
			( -clone 2 -level 50.2%%,100%% -write mpr:b2_mask +delete ) ^
			( -size %%[img_w]x%%[img_h] xc:%r1% -write mpr:r1 ) ^
			( -size %%[img_w]x%%[img_h] xc:%r2% -write mpr:r2 ) ^
			( -size %%[img_w]x%%[img_h] xc:%g1% -write mpr:g1 ) ^
			( -size %%[img_w]x%%[img_h] xc:%g2% -write mpr:g2 ) ^
			( -size %%[img_w]x%%[img_h] xc:%b1% -write mpr:b1 ) ^
			( -size %%[img_w]x%%[img_h] xc:%b2% -write mpr:b2 ) ^
			( mpr:r1 mpr:r1_mask -compose copy_opacity -composite -write mpr:r1 ) ^
			( mpr:r2 mpr:r2_mask -compose copy_opacity -composite -write mpr:r2 ) ^
			( mpr:g1 mpr:g1_mask -compose copy_opacity -composite -write mpr:g1 ) ^
			( mpr:g2 mpr:g2_mask -compose copy_opacity -composite -write mpr:g2 ) ^
			( mpr:b1 mpr:b1_mask -compose copy_opacity -composite -write mpr:b1 ) ^
			( mpr:b2 mpr:b2_mask -compose copy_opacity -composite -write mpr:b2 ) ^
			( "%diffPath%" -resize %%[img_w]x%%[img_h] -write mpr:diff ) ^
			( mpr:diff mpr:r1 mpr:r2 mpr:g1 mpr:g2 mpr:b1 mpr:b2 -compose multiply -layers flatten -write result.png ) ^
NULL:

echo Done!

pause