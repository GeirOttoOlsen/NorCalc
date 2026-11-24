/*------------------------------------------------------------------------
File : bytearrayhelper
Purpose : 
Syntax : 
Description : 
Author(s) : rkelters
Created : Wed Jul 30 09:14:04 CEST 2014
Notes : 
----------------------------------------------------------------------*/
 
USING Progress.Lang.*.
 
ROUTINE-LEVEL ON ERROR UNDO, THROW.
 
CLASS oo.ByteArrayHelper: 
  METHOD PUBLIC STATIC "System.Byte[]" MemptrToByteArray( pmptr AS MEMPTR ):
    DEFINE VARIABLE oIntPointer AS System.IntPtr NO-UNDO .
    DEFINE VARIABLE iPtr64      AS INT64         NO-UNDO .
    DEFINE VARIABLE vInt        AS INT         NO-UNDO .
    DEFINE VARIABLE iPtr32      AS INTEGER       NO-UNDO .
    DEFINE VARIABLE nBytes AS "System.Byte[]".

    vInt = GET-SIZE(pmPtr).
    
    nBytes = NEW "System.Byte[]"(vInt).

    IF oo.SessionHelper:ProcessBitness() = 32 THEN DO:
        iPtr32 = GET-POINTER-VALUE (pmptr) .

        oIntPointer = NEW System.IntPtr (iPtr32).
    END .
    ELSE DO:
        iPtr64 = GET-POINTER-VALUE (pmptr) .

        oIntPointer = NEW System.IntPtr (iPtr64).
    END.

    System.Runtime.InteropServices.Marshal:Copy(oIntPointer, nBytes, 0, vInt).
    RETURN nBytes.
    FINALLY:
      /* nPtr = ?.*/
      DELETE OBJECT oIntPointer.
      SET-SIZE(pmPtr) = 0.
      nBytes = ?.
    END.
   
  END METHOD.
   
  METHOD PUBLIC STATIC MEMPTR ByteArrayToMemptr (poBytes AS "System.Byte[]":U):
      DEFINE VARIABLE mptr        AS MEMPTR        NO-UNDO .
      DEFINE VARIABLE oIntPointer AS System.IntPtr NO-UNDO .
      DEFINE VARIABLE iPtr64      AS INT64         NO-UNDO .
      DEFINE VARIABLE iPtr32      AS INTEGER       NO-UNDO .
  
      SET-SIZE (mptr) = poBytes:Length .
  
      IF oo.SessionHelper:ProcessBitness() = 32 THEN DO:
          iPtr32 = GET-POINTER-VALUE (mptr) .
  
          oIntPointer = NEW System.IntPtr (iPtr32).
      END .
      ELSE DO:
          iPtr64 = GET-POINTER-VALUE (mptr) .
  
          oIntPointer = NEW System.IntPtr (iPtr64).
      END.
  
      System.Runtime.InteropServices.Marshal:Copy (poBytes, 0, oIntPointer, poBytes:Length).
  
      RETURN mptr .
  
      FINALLY:
          IF VALID-OBJECT (oIntPointer) THEN
              DELETE OBJECT oIntPointer.
      END FINALLY.
  
  END METHOD .
   
  METHOD PUBLIC STATIC LONGCHAR ByteArrayToLongChar( INPUT data AS "System.Byte[]" ):
    DEFINE VARIABLE result AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE memStream AS "System.IO.MemoryStream" NO-UNDO.
    DEFINE VARIABLE streamReader AS "System.IO.StreamReader" NO-UNDO.
     
    IF VALID-OBJECT(data)
    THEN DO:
      memStream = NEW System.IO.MemoryStream(data).
      memStream:Position = 0.
      streamReader = NEW System.IO.StreamReader(memStream).
      result = streamReader:ReadToEnd () .
      DELETE OBJECT memStream.
      DELETE OBJECT streamReader.
    END.
     
    RETURN result.
  END METHOD.
  
END CLASS.