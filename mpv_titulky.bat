@echo off

set file="film.mp4"
set tit="prelozene_titulky.srt"

REM set font="10"
set font="40"

REM Bílá	--sub-color="#FFFFFF"
REM Žlutá	--sub-color="#FFFF00"
REM Zelená	--sub-color="#00FF00"
REM Modrá	--sub-color="#00A0FF"
REM Červená	--sub-color="#FF0000"
REM Cyan        --sub-color="#00FFFF"

set barva="#00FFFF"

REM Černá	#000000
REM Bílá	#FFFFFF
REM Šedá	#808080
REM Cyan	#00FFFF
REM Žlutá	#FFFF00
REM --sub-back-color="#000000"

set pozadi="#000000"

set border="3"
REM --sub-border-size=3

REM --sub-shadow-offset=2
REM --sub-shadow-color="#000000"
REM --sub-back-opacity=80 ( průhlednost pozadí 0–100 )

REM --sub-codepage=utf-8 ( Vynucení kódování, např. u špatně zobrazené diakritiky )

REM mpv.exe film.mp4 --sid=1 ( Zapnutí titulků, pokud jsou vypnuté )

REM -------------------------------------------------------------------------------------------------------------
REM mpv.exe -fs --sub-file=%tit% --sub-font-size=%font% --sub-color=%barva% --sub-back-color=%pozadi% %file% 

mpv.exe -fs --sub-file=%tit% --sub-font-size=%font% --sub-color=%barva% --sub-back-color=%pozadi% --sub-border-size=%border% %file%

pause
