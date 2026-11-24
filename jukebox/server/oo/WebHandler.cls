 
 /*------------------------------------------------------------------------
    File        : WebHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Sun Aug 21 09:21:20 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.WebHandler: 
  DEF TEMP-TABLE ttError NO-UNDO SERIALIZE-NAME "Error"
      FIELD errorMessage AS CHAR
      FIELD errorNumber  AS INT SERIALIZE-HIDDEN
      .
  DEF PUBLIC PROPERTY httError AS HANDLE NO-UNDO GET. PROTECTED SET.
  
  def property oRequest as class OpenEdge.Web.IWebRequest no-undo get. set.
  
  def property oRequestBody       as class Progress.Lang.Object no-undo get. protected set.
  def property oRequestBodyString as class OpenEdge.Core.String no-undo get. protected set.
  def property oRequestBodyJson   as class Progress.Json.ObjectModel.JsonObject no-undo get. protected set.
  
  def public property StatusMessage as char no-undo get. protected set.                         
  
  def public property HasError as log no-undo 
    get():
      return CAN-FIND(FIRST ttError).
    end get. protected set.
   
//  DEF VAR oResponse      AS OpenEdge.Net.HTTP.IHttpResponse NO-UNDO.
//  def var oResponseBody as Openedge.Core.String no-undo.
//  def var oWriter as OpenEdge.Web.WebResponseWriter no-undo.

  def var ResponseBody as longchar no-undo.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

   CONSTRUCTOR PUBLIC WebHandler (  ):
   END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addError(input ipErrorText as char):
      log-manager:WRITE-MESSAGE (ipErrorText). /*for å få fram feilen i loggen....*/
/*                                                              */
      CREATE ttError.
      ASSIGN ttError.errorMessage = ipErrorText.
      
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID InitializeObject(  ):
    
      def var mpRequest as memptr no-undo.
      DEF VAR oParser AS Progress.Json.ObjectModel.ObjectModelParser NO-UNDO.

      oRequest  = new OpenEdge.Web.WebRequest().
//      oResponse = new OpenEdge.Web.WebResponse().
      httError  = TEMP-TABLE ttError:HANDLE.
      
      /*Må legge dette inn i en errorhåndterer, da Progress ikke gjør det...*/
      do on error undo, throw:
        mpRequest           = web-context:form-long-input.

        IF mpRequest = ? THEN UNDO, THROW NEW Progress.Lang.AppError("request body is unknown (?) - has to be a json object",0).
        oRequestBody        = new OpenEdge.Core.Memptr(mpRequest).
        oRequestBodyString  = new OpenEdge.Core.String().
        copy-lob from mpRequest to oRequestBodyString:Value no-convert.
                
        oRequestBody        = oRequest:Entity.

        CATCH eBody AS Progress.Lang.Error :
          assign
            StatusMessage = eBody:GetMessage(1) + ' content received (first 200 characters): ' + substring(oRequestBodyString:Value,1,200).
            .
          addError('Error fetching body: ' + StatusMessage).
          UNDO, THROW eBody.
        END CATCH.
      end.
      
      if type-of(oRequestBody,Progress.Json.ObjectModel.JsonObject) then
        oRequestBodyJson = cast(oRequestBody,Progress.Json.ObjectModel.JsonObject).
      ELSE DO ON ERROR UNDO, THROW:
        oParser = NEW Progress.Json.ObjectModel.ObjectModelParser(). 
        oRequestBodyJson = cast(oParser:Parse(mpRequest),Progress.Json.ObjectModel.JsonObject).
        CATCH eJson AS Progress.Lang.Error :
          assign
            StatusMessage = eJson:GetMessage(1) + ' content received (first 200 characters): ' + substring(oRequestBodyString:Value,1,200).
            .
          addError('Error fetching body: ' + StatusMessage).
          UNDO, THROW eJson.
        END CATCH.
      END.
        
        
 //     ELSE UNDO, THROW NEW Progress.Lang.AppError ("Body is not a Json object (Content-type should be 'application/json;charset=utf-8')",400).
      
      CATCH eApp AS Progress.Lang.AppError :
        assign
          StatusMessage = eApp:GetMessage(1).
          .
          addError(StatusMessage).
      END CATCH.
         
      CATCH eAny AS Progress.Lang.Error :
        def var ii as int no-undo.

        assign
          StatusMessage = eAny:GetMessage(1) + ' content received (first 200 characters): ' + substring(oRequestBodyString:Value,1,200).
          .
          
        do ii = 1 to eAny:NumMessages:
          addError(eAny:GetMessage(ii)).
        end.  
      END CATCH.   
      
      FINALLY:
        set-size(mpRequest) = 0.
      END FINALLY.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

/*  METHOD PUBLIC VOID writeResponse(input ipResponseBody as longchar,input ipContentType as char, input ipStatusCode as int, input ipStatusReason as char):*/
/*    ASSIGN                                                                                                                                                */
/*      oResponse        = NEW OpenEdge.Web.WebResponse()                                                                                                   */
/*      oResponseBody    = NEW OpenEdge.Core.String(ipResponseBody)                                                                                         */
/*      oResponse:Entity = oResponseBody                                                                                                                    */
/*      oResponse:ContentType   = ipContentType                                                                                                             */
/*      oResponse:ContentLength = oResponseBody:Size                                                                                                        */
/*      oResponse:StatusCode    = ipStatusCode                                                                                                              */
/*      oResponse:StatusReason  = ipStatusReason                                                                                                            */
/*    .                                                                                                                                                     */
/*                                                                                                                                                          */
/*    /* The WebResponseWriter ensures that the status line and                                                                                             */
/*       all headers are writted out before the message body/entity. */                                                                                     */
/*                                                                                                                                                          */
/*    oWriter = NEW OpenEdge.Web.WebResponseWriter(oResponse).                                                                                              */
/*    oWriter:Open().                                                                                                                                       */
/*    oWriter:Close().                                                                                                                                      */
/*                                                                                                                                                          */
/*  END METHOD.                                                                                                                                             */

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC WebHandler ( ):

	END DESTRUCTOR.
  
END CLASS.