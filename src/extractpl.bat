@echo off
REM ***************************************************************
REM * Name:     extractpl.bat                                     *
REM * Descr:    Script to extract ADE procedure libraries         *
REM * Author:   Gerry Seidl                                       *
REM * Date:     11/06/98                                          *
REM * Modified: 01/05/2000                                        *
REM * Usage:    Run script from %DLC%\src directory and make sure *
REM *           that %DLC%\bin is in your PATH. Then run          *
REM *           "extractpl <ADE pl name>"                         *
REM ***************************************************************

set PARMS=%1
if "%1"==""            goto USAGE
if "%1"=="adedict.pl"  goto ADEDICT
if "%1"=="ADEDICT.pl"  goto ADEDICT
if "%1"=="as4dict.pl"  goto AS4DICT
if "%1"=="AS4DICT.PL"  goto AS4DICT
if "%1"=="prodict.pl"  goto PRODICT
if "%1"=="PRODICT.PL"  goto PRODICT
if "%1"=="protools.pl" goto PROTOOLS
if "%1"=="PROTOOLS.PL" goto PROTOOLS
if "%1"=="adecomm.pl"  goto ADECOMM
if "%1"=="ADECOMM.PL"  goto ADECOMM
if "%1"=="adeedit.pl"  goto ADEEDIT
if "%1"=="ADEEDIT.PL"  goto ADEEDIT
if "%1"=="prodoc.pl"   goto PRODOC
if "%1"=="PRODOC.PL"   goto PRODOC
if "%1"=="prohelp.pl"  goto PROHELP
if "%1"=="PROHELP.PL"  goto PROHELP
echo Error: Unrecognized procedure library
goto END

:ADEDICT
if not exist adedict.pl goto NOT_EXIST
mkdir adedict
mkdir adedict\DB
mkdir adedict\FLD
mkdir adedict\IDX
mkdir adedict\SEQ
mkdir adedict\TBL
mkdir adedict\TRIG
prolib adedict.pl -extract *.*
goto END

:AS4DICT
if not exist as4dict.pl goto NOT_EXIST
mkdir as4dict
mkdir as4dict\DB
mkdir as4dict\dump
mkdir as4dict\FLD
mkdir as4dict\IDX
mkdir as4dict\load
mkdir as4dict\parm
mkdir as4dict\prc
mkdir as4dict\SEQ
mkdir as4dict\TBL
mkdir as4dict\TRIG
prolib as4dict.pl -extract *.*
goto END

:PRODICT
if not exist prodict.pl goto NOT_EXIST
mkdir prodict
mkdir prodict\as4
mkdir prodict\dump
mkdir prodict\gate
mkdir prodict\gui
mkdir prodict\misc
mkdir prodict\odb
mkdir prodict\ora
mkdir prodict\pro
mkdir prodict\user
mkdir prodict\rplctn
mkdir prodict\rplctn\admin
mkdir prodict\rplctn\stdobj
mkdir prodict\rplctn\template
prolib prodict.pl -extract *.*
goto END

:PROTOOLS
if not exist protools.pl goto NOT_EXIST
mkdir protools
prolib protools.pl -extract *.*
goto END

:ADECOMM
if not exist adecomm.pl goto NOT_EXIST
mkdir adecomm
prolib adecomm.pl -extract *.*
goto END

:ADEEDIT
if not exist adeedit.pl goto NOT_EXIST
mkdir adeedit
prolib adeedit.pl -extract *.*
goto END

:PRODOC
if not exist prodoc.pl goto NOT_EXIST
mkdir prodoc
mkdir prodoc\langref
mkdir prodoc\proghand
mkdir prodoc\langtut
prolib prodoc.pl -extract *.*
goto END

:PROHELP
if not exist prohelp.pl goto NOT_EXIST
mkdir prohelp
prolib prohelp.pl -extract *.*
goto END

:NOT_EXIST
echo Error: The specified procedure library does not exist
goto END

:USAGE
echo Usage: extractpl <ADE library name>
goto END

:END
