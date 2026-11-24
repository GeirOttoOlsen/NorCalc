 
 /*------------------------------------------------------------------------
    File        : HTTPclient
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Mon Sep 13 20:33:58 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.IO.MemoryStream FROM ASSEMBLY.
using System.Net.Http.*.
USING System.Net.Http.Headers.MediaTypeHeaderValue FROM ASSEMBLY.
USING System.Net.Http.Headers.ContentDispositionHeaderValue FROM ASSEMBLY.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.HTTPclient INHERITS System.Net.Http.HttpClient: 
  def public property oX509Certificate as System.Security.Cryptography.X509Certificates.X509Certificate2 no-undo get. private set.
  def public property oClientHandler as System.Net.Http.HttpClientHandler no-undo get. private set.
  def public property oClient as System.Net.Http.HttpClient no-undo get. private set.
  def public property oURI    as class System.Uri no-undo get. set.
  
  def public property oResponse as System.Net.Http.HttpResponseMessage no-undo get. set.
  def public property oRequest as System.Net.Http.HttpRequestMessage no-undo get. set.
  
  def var oCert as class Chilkat.Cert no-undo.
  
  def private property oTask as "System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage>" no-undo get. private set.
  def var oFS as System.IO.FileStream no-undo.
  def var Body as longchar no-undo.
  def var oHttpStringContent as class System.Net.Http.StringContent no-undo.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC HTTPclient ():
    oClientHandler = new System.Net.Http.HttpClientHandler().
    oClient = new System.Net.Http.HttpClient().
    
    System.Net.ServicePointManager:SecurityProtocol = System.Net.SecurityProtocolType:Tls12.
    Initialize().
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC HTTPclient (ipCertificateName as char, input ipSecretKey as char ):
    def var oData as "System.Byte[]" no-undo.
    def var oData2 as "System.Byte[]" no-undo.
    GlobalLicense:Instance:ReadLicense().
    oCert = new Chilkat.Cert().
    oData = System.IO.File:ReadAllBytes(ipCertificateName).
    oCert:LoadPfxData(oData,ipSecretKey).
    
    if not oCert:LastMethodSuccess then 
      undo, throw new Progress.Lang.AppError(oCert:LastErrorText,0).
    oData2 = oCert:exporttopfxdata(ipSecretKey,true).
    oClientHandler   = new System.Net.Http.HttpClientHandler().
/*    oX509Certificate = new System.Security.Cryptography.X509Certificates.X509Certificate2(ipCertificateName,ipSecretKey).*/
    oX509Certificate = new System.Security.Cryptography.X509Certificates.X509Certificate2(oData2,ipSecretKey).
    oClientHandler:ClientCertificates:Add(oX509Certificate).
    oClient = new System.Net.Http.HttpClient(oClientHandler).
    
    System.Net.ServicePointManager:SecurityProtocol = System.Net.SecurityProtocolType:Tls12.
    Initialize().
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID AddHeader(input ipHeaderName as char, input ipHeaderValue as char,input ipType as char):
    def var oContentType as class System.Net.Http.Headers.MediaTypeHeaderValue no-undo.    
    case ipType:
      when 'Content' then do:
        oContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(ipHeaderValue).
        oHttpStringContent = new System.Net.Http.StringContent(ipHeaderValue).
        oHttpStringContent:Headers:ContentType = oContentType.
      end.
      otherwise do:
        oRequest:Headers:Add(ipHeaderName,input ipHeaderValue).
      end.
    end case.
    CATCH eAny AS System.Net.Http.HttpRequestException:
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC log getToken(input ipoMethod as class System.Net.Http.HttpMethod,input ipoUri as class System.uri,input ipoAuthorization as class System.Net.Http.Headers.AuthenticationHeaderValue,input ipoContent as class System.Net.Http.HttpContent):
   
  end method.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC log executeRequest(input ipMethod as char):
    oRequest:RequestUri = oUri.
    if oRequest:RequestUri:AbsoluteUri = '' then undo, throw new Progress.Lang.AppError('Kan ikke sende med tom URL',0).
    case ipMethod:
      when 'GET'    then do:
        oRequest:Method = System.Net.Http.HttpMethod:Get.
        oTask = oClient:SendAsync(oRequest).
      end.
      when 'POST'   then do:
        oRequest:Method = System.Net.Http.HttpMethod:Post.
        oTask = oClient:SendAsync(oRequest).
        
      end.
      when 'DELETE' then do:
        oRequest:Method = System.Net.Http.HttpMethod:Delete.
        if valid-object(oRequest:Content) then 
          oRequest:Content:Headers:Clear().
        oTask = oClient:SendAsync(oRequest).
      end.
    end case. 
    System.Threading.Thread:Sleep(3000).

    do while not oTask:IsCompleted:
      MESSAGE 'her..not complete'
      VIEW-AS ALERT-BOX.
      System.Threading.Thread:Sleep(1000).
    end.
    
    if not valid-object(oTask) then 
      undo, throw new Progress.Lang.AppError('oTask ikke valid object',0).
    if not valid-object(oTask:Result) then 
      undo, throw new Progress.Lang.AppError('Noe skjedde, Resultat ikke valid-object',0).
     
    oResponse = oTask:Result.
    
    if oTask:IsFaulted then     
      MESSAGE 'oTask:FEILET: ' oTask:Exception:GetMessage(1) skip oTask:Exception:GetMessage(2)  
        VIEW-AS ALERT-BOX.
    return not oTask:IsFaulted.

    CATCH eNet AS System.Net.Http.HttpRequestException :
      def var i as int no-undo.
        do i = 1 to eNet:NumMessages: 
          MESSAGE 'feil: ' eNet:GetMessage(i)
          VIEW-AS ALERT-BOX.
        end.
    END CATCH.

    CATCH eAny AS Progress.Lang.Error :
      def var ii as int no-undo.
    MESSAGE 'Status:' oTask:Status:value__ 'Canceled:' oTask:IsCanceled skip 'Complete:' oTask:IsCompleted skip 'Feil:' oTask:IsFaulted
    skip 
    VIEW-AS ALERT-BOX.
      do ii = 1 to eAny:NumMessages: 
        MESSAGE eAny:GetMessage(ii)
        VIEW-AS ALERT-BOX.
      end.
      return false.  
    END CATCH.
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID Initialize(  ):
    oClient:DefaultRequestHeaders:Clear().
    oRequest  = new System.Net.Http.HttpRequestMessage().    
    oResponse = new System.Net.Http.HttpResponseMessage().
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setBody(input ipBody as longchar,input ipEncoding as System.Text.Encoding):
/*    def var mp as MEMPTR no-undo.                                */
/*    def var oBytes as class "System.Byte[]" no-undo.             */
/*    set-size(mp) = length(ipBody).                               */
/*    copy-lob from object ipBody to object mp no-convert.         */
/*    oBytes = oo.DataHelper.ByteArrayHelper:MemptrToByteArray(mp).*/
  def var oHttpStringContent as System.Net.Http.StringContent no-undo.
    if ipBody <> '' then do:
      oHttpStringContent = new System.Net.Http.StringContent(ipBody,ipEncoding).
      oRequest:Content = oHttpStringContent.
    end.
     
/*    set-size(mp) = 0.*/
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'setBody:ERROR:' eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setMultipartBody(input ipBody as longchar,input ipEncoding as System.Text.Encoding, input ipFileList as char extent):
    def var ii as int no-undo.
    def var filnavn as char no-undo.
    def var oFileInfo as System.IO.FileInfo no-undo.

    def var oMultipartBody as class System.Net.Http.MultipartFormDataContent no-undo.
    def var oByteArrayContent as class System.Net.Http.ByteArrayContent no-undo.
    def var oStreamContent as class System.Net.Http.StreamContent no-undo.
    def var oImage as class System.Drawing.Image no-undo.
    def var oMemstream as class System.IO.MemoryStream no-undo.
    def var lcImg as longchar no-undo.
    def var oBytes as "System.Byte[]" no-undo.
    
    do ii = 1 to extent(ipFileList):
      filnavn = ipFileList[ii].
      if not System.IO.File:Exists(filnavn) then 
        undo, throw new Progress.Lang.AppError('Filen finnes ikke: ' + filnavn,0).
    end.
    
    if ipBody <> '' then do:
      oHttpStringContent = new System.Net.Http.StringContent(ipBody,ipEncoding).
      oMultipartBody     = new System.Net.Http.MultipartFormDataContent().
      oMultipartBody:Add(oHttpStringContent).
      
      do ii = 1 to extent(ipFileList):
        filnavn = ipFileList[ii].
        oFileInfo = new System.IO.FileInfo(filnavn).        
        oImage = System.Drawing.Image:FromFile(oFileInfo:FullName).
        oMemstream = new System.IO.MemoryStream().
        oImage:Save(oMemstream,oImage:RawFormat).       
        //lcImg = System.Convert:ToBase64String(oMemstream:ToArray()).
         
/*        oBytes = System.Text.ASCIIEncoding:ASCII:GetBytes(lcImg).*/
        oByteArrayContent = new System.Net.Http.ByteArrayContent(new System.Net.Http.StreamContent(oMemstream):ReadAsByteArrayAsync():Result).
        oByteArrayContent:Headers:ContentType = new MediaTypeHeaderValue('image/jpg').
        oByteArrayContent:Headers:ContentDisposition = new ContentDispositionHeaderValue('attachment'). 
        oMultipartBody:Add(oByteArrayContent,replace(oFileInfo:Name,oFileInfo:Extension,''),oFileInfo:Name).
      end.
      
      oRequest:Content = oMultipartBody.
    end.
     
/*    set-size(mp) = 0.*/
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'setBody:ERROR:' eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setURI(input ipURL as char):
    /*I tilfelle vi benytter ?x=a:.... så må jeg fjerne / rett før ?*/
    assign 
      ipURL = replace(ipURL,'/?','?')
      .
    oURI = new System.Uri(ipURL).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC longchar CopyToLongchar(ipContent as System.Net.Http.HttpContent):
    Def var oByteArray as "System.Byte[]" no-undo.
    def var data as longchar no-undo.
    
    oByteArray = ipContent:ReadAsByteArrayAsync():Result.
    Data = oo.ByteArrayHelper:ByteArrayToLongChar(oByteArray).
/*    copy-lob from object data to file 'e:\temp\slettes033.html' no-convert.*/
    return Data.
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID WriteToFile(input ipFilename as char ):
    if System.IO.File:Exists(ipFilename) then
      undo,throw new Progress.Lang.AppError('Filen finnes fra før, kan ikke opprettes',0).
    oFS = new System.IO.FileStream(ipFilename,System.IO.FileMode:Create,System.IO.FileAccess:Write,System.IO.FileShare:none).
    oResponse:Content:CopyToAsync(oFS).
    oFS:Close().
    
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID WriteRequestContentToFile(input ipFilename as char ):
    if System.IO.File:Exists(ipFilename) then
      undo,throw new Progress.Lang.AppError('Filen finnes fra før, kan ikke opprettes',0).
    oFS = new System.IO.FileStream(ipFilename,System.IO.FileMode:Create,System.IO.FileAccess:Write,System.IO.FileShare:none).
    oRequest:Content:CopyToAsync(oFS).
    oFS:Close().
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.


END CLASS.