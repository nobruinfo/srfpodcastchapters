@ECHO OFF
REM ------------------ Begin of section to fill in -----------------------------
SET x="D:\Eigene Programme\Tools\Batch\FFMPEG\youtube-dl.exe"
SET xx="D:\Eigene Programme\Internet\MediathekView_6\bin\ffmpeg.exe"
SET mi="D:\Eigene Programme\Grafik\MediaInfo_CLI_0.7.72_Windows_x64\MediaInfo.exe"
SET optsnodate=--download-archive archiv.ini --max-downloads 10 --cookies cookies.txt
SET opts=%optsnodate% --dateafter 20200505 --restrict-filenames
SET optsnodate=%optsnodate% --exec "COPY /b {} +,,"
REM ------------------- End of section to fill in ------------------------------

REM So this batch can be started giving an UNC source file:
REM CD /D "%~dp0"
chcp 1252

REM This to have those !vars! at hand which aren't preset outside loops:
setlocal enabledelayedexpansion

REM If you want to directly save downloades podcast files to somewhere else:
REM CD /D W:\aaaaa

TITLE SRF Digital:
SET url=http://podcasts.srf.ch/digital_plus_mpx.xml
SET url=https://www.srf.ch/feed/podcast/sd/400741a5-0289-474b-807c-01679a6986c0.xml
%x% %opts% --write-description %url%

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
        SET chk=!aa:~0,1!
        
        IF "!chk!" == "(" (
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
