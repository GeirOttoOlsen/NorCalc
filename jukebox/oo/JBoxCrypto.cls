 
/*------------------------------------------------------------------------
   File        : JboxCrypto
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : geiolsenadm
   Created     : Thu Mar 16 13:45:48 CET 2023
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

/*using System.*.                      */
/*using System.IO.*.                   */
/*using System.Security.Cryptography.*.*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JboxCrypto: 
  DEFINE VARIABLE StoreKey           AS CHARACTER INIT 'BMODcaZi8h72hEt9pzG/MQ==' NO-UNDO.

  DEFINE VARIABLE oPwdByte           AS CLASS     System.Security.Cryptography.Rfc2898DeriveBytes NO-UNDO.
  DEFINE VARIABLE oAesAlg            AS CLASS     System.Security.Cryptography.Aes                NO-UNDO.
  
  DEFINE VARIABLE EncryptedStreng    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE b64EncryptedStreng AS CHARACTER NO-UNDO.
  DEFINE VARIABLE decryptedString    AS CHARACTER NO-UNDO.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC JboxCrypto (  ):
      
  END CONSTRUCTOR.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC CHARACTER encryptString(INPUT ipString AS CHARACTER):
    DEFINE VARIABLE oInBytes   AS "System.Byte[]" NO-UNDO.
    DEFINE VARIABLE oOutBytes  AS "System.Byte[]" NO-UNDO.
    
    DEFINE VARIABLE oMemStream AS CLASS           System.IO.MemoryStream                        NO-UNDO.
    DEFINE VARIABLE oCS        AS CLASS           System.Security.Cryptography.CryptoStream     NO-UNDO.
    DEFINE VARIABLE oEncryptor AS CLASS           System.Security.Cryptography.ICryptoTransform NO-UNDO.

    oInBytes       = System.Text.Encoding:UTF8:GetBytes(ipString).
    
    prepareStorekey().

    oEncryptor = oAesAlg:CreateEncryptor(oAesAlg:Key,oAesAlg:IV).
    oMemStream     = NEW System.IO.MemoryStream().

    oCS            = NEW System.Security.Cryptography.CryptoStream(oMemStream,oEncryptor,System.Security.Cryptography.CryptoStreamMode:Write).
    oCS:Write(oInBytes,0,oInBytes:Length).
    oCS:FlushFinalBlock().
    oCS:Close().
    
    oOutBytes  = oMemStream:ToArray().
    b64EncryptedStreng = System.Convert:ToBase64String(oOutBytes).
    RETURN b64EncryptedStreng.
    
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'EncryptingError:' eANy:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

  METHOD PRIVATE VOID prepareStorekey ():
    DEFINE VARIABLE oStoreKeyChars AS "System.Char[]" NO-UNDO.
    DEFINE VARIABLE oStoreKey      AS "System.Byte[]" NO-UNDO.
    DEFINE VARIABLE oDerBytes      AS "System.Byte[]" NO-UNDO.

    oStoreKey      = System.Text.Encoding:UTF8:getBytes(StoreKey).
    oStoreKeyChars = System.Text.Encoding:UTF8:getChars(oStoreKey).
    oDerBytes      = System.Text.Encoding:UTF8:getBytes(oStoreKeyChars).
    
    oPwdByte       = NEW System.Security.Cryptography.Rfc2898DeriveBytes(StoreKey,oDerBytes).
    oAesAlg        = NEW System.Security.Cryptography.AesManaged().
    oAesAlg:Key    = oPwdByte:GetBytes(32).
    oAesAlg:IV     = oPwdByte:GetBytes(16).
    oAesAlg:Mode   = System.Security.Cryptography.CipherMode:CBC.
        
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC CHARACTER decryptString (INPUT ipEncryptedString AS CHARACTER):
    DEFINE VARIABLE oEncryptedBytes AS "System.Byte[]" NO-UNDO.
    DEFINE VARIABLE oDecryptedBytes AS "System.Byte[]" NO-UNDO.
    
    DEFINE VARIABLE oDecryptor      AS CLASS           System.Security.Cryptography.ICryptoTransform NO-UNDO.
    DEFINE VARIABLE oMemStream      AS CLASS           System.IO.MemoryStream                        NO-UNDO.
    DEFINE VARIABLE oCS             AS CLASS           System.Security.Cryptography.CryptoStream     NO-UNDO.

    oEncryptedBytes = system.convert:FromBase64String(ipEncryptedString).

    prepareStorekey().
    
    oDecryptor      = oAesAlg:CreateDecryptor(oAesAlg:Key,oAesAlg:IV).
    oMemStream      = NEW System.IO.MemoryStream().
    
    oCS = NEW System.Security.Cryptography.CryptoStream(oMemStream,oDecryptor,System.Security.Cryptography.CryptoStreamMode:Write).
    oCS:Write(oEncryptedBytes,0,oEncryptedBytes:Length).
    oCS:FlushFinalBlock().
    oCS:Close().
    
    RETURN System.Text.Encoding:utf8:GetString(oMemStream:ToArray()).

    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'DecryptionError:' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.

  END.
  
END CLASS.