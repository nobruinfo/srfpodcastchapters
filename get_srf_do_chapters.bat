@ECHO OFF
REM ------------------ Begin of section to fill in -----------------------------
SET nir="D:\Eigene Programme\Nircmd\nircmd.exe"
SET zenitypath=D:\Eigene Programme\Tools\Batch\zenity-2.28.0_win32-3\bin
SET zenity="%zenitypath%\zenity.exe"
SET ZENITY_DATADIR=D:\Eigene Programme\Tools\Batch\zenity-2.28.0_win32-3\share\
SET x="D:\Eigene Programme\Internet\MediathekView_6\bin\ffmpeg.exe"
SET x="D:\Eigene Programme\Grafik\FFMPEG\ffmpeg-3.2.4-win64-static\bin\ffmpeg.exe"
SET x="D:\Eigene Programme\Tools\Batch\FFMPEG\youtube-dl.exe"
SET optsnodate=--download-archive archiv.ini --max-downloads 100 --cookies cookies.txt
SET opts=%optsnodate% --dateafter 20200505
SET optsnodate=%optsnodate% --exec "COPY /b {} +,,"
REM ------------------- End of section to fill in ------------------------------

REM --------------------- Begin of documentation -------------------------------
REM Zwischendurch mit  youtube-dl.exe -U
REM überprüfen, ob es Updates gibt.
REM
REM Quelle: https://github.com/ytdl-org/youtube-dl
REM RSS: https://github.com/ytdl-org/youtube-dl/issues/667
REM
REM Frühere RSS von Youtube waren so verwendet worden:
REM https://www.youtube.com/feeds/videos.xml?channel_id=UCMQ3E2ZfpvnUkpUen7iMwHQ
REM Jetzt nur noch als Playlist oder die Liste aller Videos.
REM 
REM Beschränkung gegen ganz alte Videos oben bei den Optionen zu setzen.
REM 
REM CC2tv hätte noch diese eigene RSS-Liste: http://cc2.tv/feedv.xml
REM Wird nicht verwendet, da er ja eine Playlist für die Gesamt-Episoden unter-
REM hält.
REM 
REM 
REM
REM 
REM 
REM 
REM 
REM ---------------------- End of documentation --------------------------------

%nir% win setsize foreground 5 5 500 500
mode 140,80
REM mode con: lines=2500
REM mode con: cols=%1 lines=%2
powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=140;$B.height=20000;$W.buffersize=$B;}"

REM IF "%~1"=="" ECHO missing input file name!
REM IF "%~1"=="" GOTO END

DEL map.txt > NUL 2> NUL

REM So this batch can be started giving an UNC source file:
CD /D "%~dp0"
chcp 1252

REM This to have those !vars! at hand which aren't preset outside loops:
setlocal enabledelayedexpansion

IF EXIST "D:\Eigene Programme\Tools\Batch\FFMPEG\*.*" (
  SET DRIVE=D:
) ELSE (
  SET DRIVE=C:
)
SET PATH=%PATH%;%DRIVE%\Eigene Programme\Grafik\Latex\Python27
SET PATH=%PATH%;%DRIVE%\Eigene Programme\Grafik\Latex\Python27\Lib\site-packages
SET PATH=%PATH%;%DRIVE%\Eigene Programme\Grafik\FFMPEG\ffmpeg-3.2.4-win64-static\bin


REM Now remove all paths that could interfere:
CALL SET PATH=%%PATH:C:\Users\Superuser\AppData\Local\Microsoft\WindowsApps=%%
CALL SET PATH=%%PATH:C:\Program Files (x86)\GnuPG\bin=%%
CALL SET PATH=%%PATH:C:\Program Files ^(x86^)\Common Files\Oracle\Java\javapath=%%
CALL SET PATH=%%PATH:C:\ProgramData\Oracle\Java\javapath=%%
CALL SET PATH=%%PATH:C:\Windows\System32\OpenSSH\=%%
CALL SET PATH=%%PATH:C:\tools\Cmder=%%
CALL SET PATH=%%PATH:C:\ProgramData\chocolatey\bin=%%
CALL SET PATH=%%PATH:;;=;%%

REM ------ TO BE REMOVED ------
CD /D W:\aaaaa

TITLE SRF Digital:
%x% %opts% --write-description http://podcasts.srf.ch/digital_plus_mpx.xml

SET xx="D:\Eigene Programme\Internet\MediathekView_6\bin\ffmpeg.exe"
SET mi="D:\Eigene Programme\Grafik\MediaInfo_CLI_0.7.72_Windows_x64\MediaInfo.exe"

REM Loop all description files:
FOR /R . %%F in (*.description) do (
  echo Treating %%F
  
  SET NAME=%%~nF
  ECHO name=!NAME!
  
  REM Only if file is not .m4a it needs to be converted:
  IF EXIST "!NAME!.mp3" (
    ECHO ;FFMETADATA>!NAME!.meta
    ECHO title=!NAME!>>!NAME!.meta
    ECHO artist=SRF>>!NAME!.meta
    ECHO genre=Podcast>>!NAME!.meta
  
    SET /a sum=0
    SET /a beg=0
    SET lasttitle=Start
    ECHO [CHAPTER]>>!NAME!.meta
    ECHO TIMEBASE=1/1000>>!NAME!.meta
    ECHO START=!beg!>>!NAME!.meta
  
    REM Loop any unempty line within file:
    for /F "usebackq tokens=*" %%A in ("!NAME!.description") do (
      SET /a sum=!sum!+1
    
      REM Skip first unempty lines:
      IF !sum! GEQ 3 (
        echo line!sum! = %%A
        SET aa=%%A
        
        SET "ft=!aa:(=!"
        SET "ddd=!ft:)=!"
        REM SET beg=!ddd:~0,8!.!ddd:~9,2!.!ddd:~4,4!
        REM SET beg=!ddd:~0,8!!
        SET hh=!ddd:~0,2!!
        SET min=!ddd:~3,2!!
        SET sec=!ddd:~6,2!!
        REM Remove leading zeroes:
        set /a hh=10000!hh! %% 10000
        set /a min=10000!min! %% 10000
        set /a sec=10000!sec! %% 10000
        ECHO hh=!hh! min=!min! sec=!sec!
        SET /a end=!hh!*3600+!min!*60+sec-1
        ECHO Formula done
        SET end=!end!000
        SET txt=!ddd:~9,99!!
        ECHO END=!end!>>!NAME!.meta
        ECHO title=!lasttitle!>>!NAME!.meta
        SET lasttitle=!txt!
  
        SET /a beg=!end!+1
        ECHO [CHAPTER]>>!NAME!.meta
        ECHO TIMEBASE=1/1000>>!NAME!.meta
        ECHO START=!beg!>>!NAME!.meta
      )
    )
    !mi! --Inform="General;%%Duration%%" "!NAME!.mp3">arghh.tmp
    SET /P end=<arghh.tmp
  
    ECHO END=!end!>>!NAME!.meta
    ECHO title=!lasttitle!>>!NAME!.meta
  
    %xx% -i "!NAME!.mp3" ^
    -i "!NAME!.meta" ^
    -map 0:a -map_metadata 1 "!NAME!.m4a"
    
    DEL "!NAME!.mp3" > NUL 2> NUL
  )
)

:END
PAUSE

DEL *.meta > NUL 2> NUL
DEL *.description > NUL 2> NUL
DEL arghh.tmp > NUL 2> NUL
