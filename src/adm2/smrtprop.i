&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : smrtprop.i
    Purpose     : Starts smart.p super procedure and defines general
                  SmartObject properties and other values.
    Syntax      : {src/adm2/smrtprop.i}

    Description :

    Modified    : July 7, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

 {src/adm2/custom/smartdefscustom.i}

 /* define the ADM Version and broker handle for all SmartObjects */
 &GLOB ADM-VERSION ADM2.1

 DEFINE VARIABLE ghProp         AS HANDLE NO-UNDO.  /* For {get/set} */
 DEFINE VARIABLE ghADMProps     AS HANDLE NO-UNDO.  /* Handle of prop t-t */
 DEFINE VARIABLE ghADMPropsBuf  AS HANDLE NO-UNDO.  /*  and its buffer    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectType Include 
FUNCTION getObjectType RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/smrtprto.i}
&ENDIF

 /* These preprocessors let the get and set methods know at compile time
    which property values are located in the temp-table and which must
    be accessed through the property functions.
 */

 &GLOB xpObjectVersion
 &GLOB xpObjectType 
 &GLOB xpContainerType  
 &GLOB xpPropertyDialog  
 &GLOB xpQueryObject    
 &GLOB xpContainerHandle             
 &GLOB xpInstanceProperties          
 &GLOB xpSupportedLinks              
 &GLOB xpContainerHidden             
 &GLOB xpObjectInitialized          
 &GLOB xpObjectHidden              
 &GLOB xpContainerSource           
 &GLOB xpContainerSourceEvents    
 &GLOB xpDataSourceEvents          
 &GLOB xpTranslatableProperties   
 &GLOB xpObjectPage                
 &GLOB xpDBAware                   
 &GLOB xpDesignDataObject
 /* This temp-table defines all the propertt fields for an object.
    This include file contributes the DEFINE statement header and
    all basic smart object properties. Each other property class include file
    adds its own fields and then the parent object ends the statement.
    Define the fields for smart objects only, not for their super procedures.
 */
   
 /* Note that ObjectHidden is here because "hidden" is a logical concept. */

&IF "{&ADMSuper}":U = "":U &THEN
  CREATE TEMP-TABLE ghADMProps.
  ghADMProps:UNDO = FALSE.
  ghADMProps:ADD-NEW-FIELD('ObjectVersion':U, 'CHAR':U, 0, ?,
    '{&ADM-VERSION}':U).
  ghADMProps:ADD-NEW-FIELD('ObjectType':U, 'CHAR':U, 0, ?,
    '{&PROCEDURE-TYPE}':U).
  ghADMProps:ADD-NEW-FIELD('ContainerType':U, 'CHAR':U, 0, ?,
    '{&ADM-CONTAINER}':U).
  ghADMProps:ADD-NEW-FIELD('PropertyDialog':U, 'CHAR':U, 0, ?,
    '{&ADM-PROPERTY-DLG}':U).
  ghADMProps:ADD-NEW-FIELD('QueryObject':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ContainerHandle':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('InstanceProperties':U, 'CHAR':U, 0, ?,
    '{&xcInstanceProperties}':U ).
  /* NOTE: Any need to support &User-Supported-Links?? */
  ghADMProps:ADD-NEW-FIELD('SupportedLinks':U, 'CHAR':U, 0, ?,
    '{&ADM-SUPPORTED-LINKS}':U).
  ghADMProps:ADD-NEW-FIELD('ContainerHidden':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('ObjectInitialized':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ObjectHidden':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('UIBMode':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerSource':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('ContainerSourceEvents':U, 'CHAR':U, 0, ?,
    'initializeObject,hideObject,viewObject,destroyObject,enableObject,confirmExit':U).
  ghADMProps:ADD-NEW-FIELD('DataSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('DataSourceEvents':U, 'CHAR':U, 0, ?,
    'dataAvailable,queryPosition,deleteComplete,fetchDataSet,confirmContinue':U).
  ghADMProps:ADD-NEW-FIELD('TranslatableProperties':U, 'CHAR':U, 0, ?,
    '{&xcTranslatableProperties}':U).
  ghADMProps:ADD-NEW-FIELD('ObjectPage':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('DBAware':U, 'LOGICAL':U, 0, ?,
  &IF DEFINED (DB-AWARE) NE 0 &THEN
    {&DB-AWARE}).
  &ELSE
    no).
  &ENDIF
  ghADMProps:ADD-NEW-FIELD('DesignDataObject':U, 'CHAR':U, 0, ?,'':U).

&ENDIF

  {src/adm2/custom/smrtpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectType Include 
FUNCTION getObjectType RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Type of the SmartObject, such as "SmartDataObject", etc.
            For an ADM Super procedure, this function returns "SUPER".
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  &IF "{&ADMSuper}":U NE "":U &THEN
    cType = "SUPER":U.
  &ELSE
    {get ObjectType cType} NO-ERROR.
  &ENDIF
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

