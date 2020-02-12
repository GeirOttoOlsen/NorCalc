/******************************************************************************

  Program:      pdf_pre.i
  
  Written By:   Gordon Campbell
  Written On:   July 6, 2005
  
  Description:  Preprocessor defintions for PDFinclude
  
******************************************************************************/

&GLOBAL-DEFINE PDFDIR 


&IF OPSYS = "UNIX" &THEN
  &GLOBAL-DEFINE zlib            /usr/lib/libz.so.1
  /* there is no procryptlib.dll for unix; TODO: use libcrypto instead */
  &GLOBAL-DEFINE MD5LIB          md5sum
  &GLOBAL-DEFINE mathLib         /usr/lib/libm.so
&ELSEIF PROVERSION >= "11.3" AND "{&PROCESS-ARCHITECTURE}" = "64" &THEN /* 27-OCT-2016 jcc: 64 bits support; PROCESS-ARCHITECTURE appeared in 11.3 */
  /* C:/path/to/pdfinclude/dll and C:/path/to/pdfinclude/dll/openssl must be added to Windows' PATH environment variable */
  &GLOBAL-DEFINE zlib            zlibwapi.dll
  &GLOBAL-DEFINE MD5LIB          md5.exe
  /* &GLOBAL-DEFINE pdfencryptlib   procryptlib.dll */ /* I have no 64 bits version of this dll :( */
  &GLOBAL-DEFINE mathLib         msvcrt40.dll
&ELSE /* 27-OCT-2016 jcc: default to 32 bits - for 64 bits OE >= 10.2A and < 11.3 we cannot tell if we are 32 or 64 bits :( */
  /* C:/path/to/pdfinclude/dll and C:/path/to/pdfinclude/dll/openssl must be added to Windows' PATH environment variable */
  &GLOBAL-DEFINE zlib            zlib1.dll
  &GLOBAL-DEFINE MD5LIB          md5.exe
  &GLOBAL-DEFINE pdfencryptlib   procryptlib.dll
  &GLOBAL-DEFINE mathLib         msvcrt40.dll
&ENDIF

/* 25-JAN-2011 jcc */
&IF OPSYS = "UNIX" &THEN
  &GLOBAL-DEFINE pdfSKIP     CHR(13) CHR(10)
&ELSE
  &GLOBAL-DEFINE pdfSKIP     SKIP
&ENDIF

/* end of pdf_pre.i */
