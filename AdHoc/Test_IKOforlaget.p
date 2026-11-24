
/*------------------------------------------------------------------------
    File        : Test_IKOforlaget.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Fri Feb 16 12:09:06 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var challangePwd as char no-undo.
def var secret as char no-undo.
def var pemFile as char no-undo.
def var oPrivKey as Chilkat.PrivateKey no-undo.
def var oPubKey as Chilkat.PublicKey no-undo.
def var oCmd as class jboxCmd no-undo.

oPrivKey = new Chilkat.PrivateKey().
oPubKey = new Chilkat.PublicKey().

assign 
  challangePwd = 'wOfIIil5El'
  secret       = 'fxf1K9LCaEwfzmQz9tVuD3YT0E2RS6Ei'
  .
GlobalLicense:instance:ReadLicense().

//run privatekey.
//run Cert.
//run convertPEMtoJKS.
//run keystore.
run PFX.
//run Cert.
  
CATCH eAny AS Progress.Lang.Error :
   MESSAGE eAny:GetMessage(1)
   VIEW-AS ALERT-BOX.     
END CATCH.  

procedure privateKey:
  def var oPK as class Chilkat.PrivateKey no-undo.
  oPK = new Chilkat.PrivateKey().
  oPK:DebugLogFilePath = 'e:\temp\openssl_debug_privatekey.txt'.
 
  oPK:LoadPvkFile('E:\OpenSSL-3.0.5_win32\keypair.pem', secret).
  if not oPK:LastMethodSuccess then 
   undo, throw new Progress.Lang.AppError(oPK:LastErrorText,0).
  oCmd = new JboxCMD('notepad.exe',oPK:DebugLogFilePath).
end.

procedure ConvertPEMtoJKS:
  def var oPEM as class Chilkat.Pem no-undo.
  def var oJKS as class Chilkat.JavaKeyStore no-undo.
  
  oJKS = new Chilkat.JavaKeyStore().
  
  pemFile = 'E:\OpenSSL-3.0.5_win32\IKOforlag\myProducedKeyPair.pem'.

  oPEM = new Chilkat.Pem().
  oPem:LoadPemFile(pemFile,secret).
  
  oJKS = oPem:ToJks('IKAforlaget',secret).
  if not oPEM:LastMethodSuccess then 
   undo, throw new Progress.Lang.AppError(oPEM:LastErrorText,0).
  oJKS:ToFile('secret','E:\OpenSSL-3.0.5_win32\IKOforlag\IKAkeystore.jks').

end procedure.

procedure Keystore:
  def var oJKS as class Chilkat.JavaKeyStore no-undo.
  def var keystore as char no-undo.
  
  keystore = 'E:\OpenSSL-3.0.5_win32\IKOforlag\iko\test\keypair.pem'.
  
  oJKS = new Chilkat.JavaKeyStore().
  oJKS:VerboseLogging = true.
  oJKS:DebugLogFilePath = 'e:\temp\test.log'.
  oJKS:LoadFile(secret,keystore).

  MESSAGE oJKS:NumPrivateKeys
  VIEW-AS ALERT-BOX.

/*MESSAGE oPFX:LastErrorText                                   */
/*VIEW-AS ALERT-BOX.                                           */
/*if not oJKS:LoadFile('test123',keystore) then                */
/*  undo, throw new Progress.Lang.AppError(oJKS:LastErrorText).*/
/*                                                             */
/*  MESSAGE oJKS:NumPrivateKeys                                */
/*  VIEW-AS ALERT-BOX.                                         */
  
end. 

procedure PFX:
  def var oPFX as class Chilkat.Pfx no-undo.
  def var pfxFile as char no-undo.

/*Prod*/
assign 
  challangePwd = 'mjxiOB1Eg0'
  secret       = '67awWJzEi6HfalhaNESPRya1Bz1gcQOp'
  .

  oPFX = new Chilkat.Pfx().
  pfxFile = 'E:\OpenSSL-3.0.5_win32\IKOforlag\prod\ikocertificate.pfx'.
  
  oPFX:VerboseLogging = true.
  oPFX:DebugLogFilePath = 'e:\temp\prodPFX.log'.
  oPFX:LoadPfxFile(pfxFile,secret).
  if not oPFX:LastMethodSuccess then do: 
    oPFX:LoadPfxFile(pfxFile, challangePwd).
    if not oPFX:LastMethodSuccess then 
      undo, throw new Progress.Lang.AppError(oPFX:LastErrorText).
  end.
CATCH eAny AS Progress.Lang.Error :
      oCmd = new jboxCMD('notepad.exe',oPFX:DebugLogFilePath).
    
END CATCH.

end.

procedure cert:
  def var oCert as Chilkat.Cert no-undo.
  def var pasw as char no-undo.
  
  assign 
    pemFile = 'E:\OpenSSL-3.0.5_win32\iko_test.p7b'
    .
  
  oCert = new Chilkat.Cert().
  if not oCert:LoadFromFile(pemFile) then 
    undo, throw new Progress.Lang.AppError(oCert:LastErrorText,0).
  MESSAGE 'extendedKeyUsage: 'oCert:ExtendedKeyUsage skip 'ClientAuth:' oCert:ForClientAuthentication skip 'privatekeyExportable:' oCert:PrivateKeyExportable skip 'has privatekey:' oCert:HasPrivateKey() skip 'hasKeyContainer:' oCert:HasKeyContainer 
  VIEW-AS ALERT-BOX.
/*  oPrivKey = oCert:ExportPrivateKey().*/
/*  oPubKey = oCert:ExportPublicKey().  */
/*  oCert:ExportToPfxFile('E:\OpenSSL-3.0.5_win32\IKOforlag\ikoCertificate.pfx',secret,false).*/
/*  if not oCert:LastMethodSuccess then                                                       */
/*    undo, throw new Progress.Lang.AppError(oCert:LastErrorText,0).                          */
end procedure.