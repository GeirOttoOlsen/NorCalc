/******************************************************************************

  Program:      pdfextract.p
  
  Written By:   Gordon Campbell
  Written On:   January 2004
  
  Description:  Allows you to extract a Page from an existing PDF document

  Notes:        - Encrypted PDF files are not supported at this time
                - Works with every pdf, even with version > 1.4 containing
                  XRef streams and Object streams.
                  Should you find a non-working pdf, please report it.

  History:
  
  05/14/13  JC Cardot   Refactor PDFExtract.p into PDFExtract.i in order to reuse
                        the code for PDF & FDF files.
                        Moved all the top comments (change log) to PDFExtract.i

  05/25/13  JC Cardot   Take into account new parameter FormFlatten
                        (which replaces retainAcroForm)

  10/22/14  JC Cardot   Bug fix: some fonts were missing on multiple document pages

  03/14/17  JC Cardot   Enhancement: allow many sessions to parse pdf files at the same time
                        (added cTmpCacheDir used, instead of cCacheDir for the generation)

******************************************************************************/
/* &GLOBAL-DEFINE debug YES */

/* include common code */
&IF DEFINED(unittest) = 0 &THEN
{lib/pdfextract.i h_PDFinc &debug = {&debug} &unittest = {&unittest} }
&ELSE
{lib/pdfextract.i &debug = {&debug} &unittest = {&unittest} }
&ENDIF

/* ----------------------- INTERNAL PROCEDURES ------------------------ */

/* 14-MAY-2013 jcc: PDF extra processing */
PROCEDURE extraProcessing:
    RUN CreateInfo("Pages", STRING(doc-pages)).
END PROCEDURE.

PROCEDURE ProcessObjects:
  FOR EACH TT_Object WHERE TT_Object.obj_stream = pStream
                       AND TT_Object.pdf_id     = pID
                       AND TT_Object.obj_id     = root-obj
                       AND TT_Object.gen_id     = root-gen:
      TT_Object.obj_type = "~/Root".
  END.

  FOR EACH TT_Object WHERE TT_Object.obj_stream = pStream
                       AND TT_Object.pdf_id     = pID
                       AND TT_Object.obj_id     = info-obj
                       AND TT_Object.gen_id     = info-gen:
      TT_Object.obj_type = "~/Info".
  END.

  /* Read the Info Dictionary and Determine Document Info */
  FOR EACH TT_Object WHERE TT_Object.obj_stream = pStream
                       AND TT_Object.pdf_id     = pID
                       AND TT_object.obj_type   = "~/Info"
      BREAK BY obj_id 
            BY gen_id 
            BY obj_seq.

    IF FIRST-OF( TT_Object.gen_id ) THEN DO:
      RUN ProcessInfoDictionary (TT_Object.obj_dict_id) NO-ERROR.
      {&adCheckErrorAndReturn}
    END. /* First-Of /Info */
    ELSE
        LEAVE.
  END. /* Info Dictionary */

  /* Read the Root Dictionary and process recursively the objects */
  FOR EACH TT_Object WHERE TT_Object.obj_stream = pStream
                       AND TT_Object.pdf_id     = pID
                       AND TT_object.obj_type   = "~/Root"
      BREAK BY obj_id 
            BY gen_id 
            BY obj_seq.

    IF FIRST-OF( TT_Object.gen_id ) THEN DO:
      RUN ProcessRootDictionary (TT_Object.obj_dict_id) NO-ERROR.
      {&adCheckErrorAndReturn}
    END. /* First-Of /Root */
    ELSE
        LEAVE.
  END. /* Root Dictionary */

END. /* ProcessObjects */

PROCEDURE ProcessInfoDictionary:
  DEFINE INPUT  PARAMETER ipiDictId AS INTEGER    NO-UNDO.

  DEFINE BUFFER TT_dict FOR TT_dict.

  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  {getDict TT_dict ipiDictId "SCALAR" "~/Author"}.
  IF AVAILABLE TT_dict THEN DO:
      doc-author = parseText(TT_dict.value_scalar).
      RUN CreateInfo ("Author", doc-author).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Producer"}.
  IF AVAILABLE TT_dict THEN DO:
      doc-producer = parseText(TT_dict.value_scalar).
      RUN CreateInfo ("Producer", doc-producer).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Creator"}.
  IF AVAILABLE TT_dict THEN DO:
      doc-creator = parseText(TT_dict.value_scalar).
      RUN CreateInfo ("Creator", doc-creator).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Title"}.
  IF AVAILABLE TT_dict THEN DO:
      doc-title = parseText(TT_dict.value_scalar).
      RUN CreateInfo ("Title", doc-title).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Subject"}.
  IF AVAILABLE TT_dict THEN DO:
      doc-subject = parseText(TT_dict.value_scalar).
      RUN CreateInfo ("Subject", doc-subject).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Keywords"}.
  IF AVAILABLE TT_dict THEN DO:
      doc-keywords = parseText(TT_dict.value_scalar).
      RUN CreateInfo ("Keywords", doc-keywords).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/ModDate"}.
  IF AVAILABLE TT_dict THEN DO: /* 04-MAR-2010 jcc: TODO: check the result as at least for time it seems wrong */
      doc-moddate = DATE(INT(SUBSTR(TT_dict.value_scalar,8,2)),
                         INT(SUBSTR(TT_dict.value_scalar,10,2)),
                         INT(SUBSTR(TT_dict.value_scalar,4,4))) NO-ERROR.
      RUN CreateInfo ("ModDate",STRING(doc-moddate)).

      doc-modtime = SUBSTR(TT_dict.value_scalar,12,2) + ":"
                  + SUBSTR(TT_dict.value_scalar,14,2) + ":"
                  + SUBSTR(TT_dict.value_scalar,16,2).
      RUN CreateInfo ("ModTime",doc-modtime).
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/CreationDate"}.
  IF AVAILABLE TT_dict THEN DO: /* 04-MAR-2010 jcc: TODO: check the result as at least for time it seems wrong */
      doc-createdon = DATE(INT(SUBSTR(TT_dict.value_scalar,8,2)),
                           INT(SUBSTR(TT_dict.value_scalar,10,2)),
                           INT(SUBSTR(TT_dict.value_scalar,4,4))) NO-ERROR.
      RUN CreateInfo ("CreationDate",STRING(doc-createdon)).

      doc-createdat = SUBSTR(TT_dict.value_scalar,12,2) + ":"
                    + SUBSTR(TT_dict.value_scalar,14,2) + ":"
                    + SUBSTR(TT_dict.value_scalar,16,2).
      RUN CreateInfo ("CreationTime",doc-createdat).
  END.

END. /* ProcessInfoDictionary */

PROCEDURE CreateInfo:
  DEFINE INPUT PARAMETER pInfo  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pValue AS CHARACTER NO-UNDO.

  DEFINE BUFFER TT_Info FOR TT_Info.

  IF pValue = "" OR pValue = ? THEN RETURN.

  CREATE TT_Info.
  ASSIGN TT_Info.obj_stream = pStream
         TT_info.pdf_id     = pID
         TT_info.info_name  = pInfo
         TT_info.info_value = pValue.

END. /* CreateInfo */

PROCEDURE ProcessRootDictionary:
    DEFINE INPUT  PARAMETER ipiDictId AS INTEGER    NO-UNDO.

    DEFINE BUFFER TT_dict      FOR TT_dict.
    DEFINE BUFFER TT_Object    FOR TT_Object.
    DEFINE BUFFER TT_Resource  FOR TT_Resource.
    DEFINE BUFFER bTT_Resource FOR TT_Resource.


    IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

    {getDict TT_dict ipiDictId "SCALAR" "~/Version"}.
    IF AVAILABLE TT_dict THEN
        doc-version = TT_dict.value_scalar.

    {getDict TT_dict ipiDictId "DICT" "~/Pages"}.
    IF AVAILABLE TT_dict THEN DO:
        RUN ProcessPagesDictionary (TT_dict.value_dict_id,0,0,0,0,0,0,0,0,0) NO-ERROR.
        {&adCheckErrorAndReturn}
    END.

    {getDict TT_dict ipiDictId "DICT" "~/AcroForm"}.
    IF AVAILABLE TT_dict THEN DO:
        RUN ProcessAcroFormDictionary (TT_dict.value_dict_id) NO-ERROR.
        {&adCheckErrorAndReturn}

        /* 23-AUG-2012 jcc: store info about the external pdf form in order to be able
                            to retain it in the generated pdf */
        /* IF pdf_get_parameter(pStream, "retainAcroForm") = "TRUE" THEN DO: */
        IF pdf_get_parameter2(pStream, "formFlatten", "*") <> "*" THEN DO:
            FIND FIRST TT_Object WHERE TT_Object.obj_dict_id = TT_dict.value_dict_id NO-ERROR.
            IF NOT AVAILABLE TT_Object THEN DO:
                RUN CreateVirtualObject ("DICT", TT_dict.value_dict_id, "", BUFFER TT_Object) NO-ERROR.
                {&adCheckErrorAndReturn}
            END.
            CREATE TT_Resource.
            ASSIGN TT_Resource.obj_stream = pStream
                   TT_Resource.pdf_id     = pID
                   TT_Resource.page_id    = 0
                   TT_Resource.res_type   = "AcroForm"
                   TT_Resource.res_obj    = TT_Object.obj_id
                   TT_Resource.res_gen    = TT_Object.gen_id
                   TT_Resource.res_text   = "".
        END.
    END.
END. /* ProcessRootDictionary */

PROCEDURE ProcessAcroFormDictionary:
    DEFINE INPUT  PARAMETER ipiDictId AS INTEGER    NO-UNDO.

    DEFINE VARIABLE obj-disp   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-justif AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-name   AS CHARACTER   NO-UNDO.

    DEFINE BUFFER TT_Object FOR TT_object.
    DEFINE BUFFER TT_dict   FOR TT_dict.
    DEFINE BUFFER TT_array  FOR TT_array.

    {getDict TT_dict ipiDictId "DICT" "~/DR"}.
    IF AVAILABLE TT_dict THEN
        RUN ProcessDR (TT_dict.value_dict_id).

    /* 14-AUG-2012 jcc: If there is a /DA at this level, then the fields must inherit it */
    {getDict TT_dict ipiDictId "SCALAR" "~/DA"}.
    IF AVAILABLE TT_dict THEN
        obj-disp = RIGHT-TRIM(LEFT-TRIM(TT_dict.value_scalar, "("), ")").

    {getDict TT_dict ipiDictId "SCALAR" "~/Q"}.
    IF AVAILABLE TT_dict THEN
        obj-justif = TT_dict.value_scalar. /* 0: left, 1: center, 2: right */

    {getDict TT_dict ipiDictId "ARRAY" "~/Fields"}.
    IF AVAILABLE TT_dict THEN DO:
        FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id
            BY TT_array.value_id:
            obj-name = "".
            RUN ProcessFieldDictionary(TT_array.value_dict_id, INPUT-OUTPUT obj-name, "", obj-disp, obj-justif, NO).

            /* 28-MAY-2013 jcc: create one "FormWidget" TT_Resource per top level field, not for kids (=> not done in ProcessFieldDictionary) so that at export time (pdf_inc.p|pdf_catalog), we only export the top level fields in the AcroForm */
            FIND TT_Object WHERE TT_Object.obj_dict_id = TT_array.value_dict_id NO-ERROR.
            /* 28-MAY-2013 jcc: useless: done in ProcessFieldDictionary */
            /* IF NOT AVAILABLE TT_Object THEN DO: */
                /* RUN CreateVirtualObject ("DICT", TT_array.value_dict_id, "", BUFFER TT_Object) NO-ERROR. */
                /* {&adCheckErrorAndReturn} */
            /* END. */
            IF AVAILABLE TT_Object THEN DO:
                CREATE TT_Resource.
                ASSIGN TT_Resource.obj_stream = pStream
                       TT_Resource.pdf_id     = pID
                       TT_Resource.page_id    = 0
                       TT_Resource.res_type   = "FormWidget"
                       TT_Resource.res_obj    = TT_Object.obj_id
                       TT_Resource.res_gen    = TT_Object.gen_id
                       TT_Resource.res_text   = obj-name. /* 28-MAY-2013 jcc: store the name here to be used in pdf_inc.p|pdf_definition */
            END.
        END.
    END.
END. /* ProcessAcroFormDictionary */

PROCEDURE ProcessFieldDictionary:
    DEFINE INPUT PARAMETER ipiDictId     AS INTEGER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER obj-name      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER obj-type      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER obj-disp      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER obj-justif    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER obj-multiline AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE cWord        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cX           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cY           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lHasKids     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lText        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE obj-off      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-on       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-on-value AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-rect     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-value    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE obj-values   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE par-page     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE rFilter      AS ROWID       NO-UNDO.
    DEFINE VARIABLE rDecodeParms AS ROWID       NO-UNDO.
    DEFINE VARIABLE par-obj-name AS CHARACTER   NO-UNDO.

    DEFINE BUFFER TT_Object     FOR TT_Object.
    DEFINE BUFFER par_TT_Object FOR TT_Object.
    DEFINE BUFFER TT_dict       FOR TT_dict.
    DEFINE BUFFER bTT_dict      FOR TT_dict.
    DEFINE BUFFER N_TT_dict     FOR TT_dict. /* Normal appearance dict */
    DEFINE BUFFER ap_TT_dict    FOR TT_dict. /* Off/On appearance dict */
    DEFINE BUFFER TT_array      FOR TT_array.
    DEFINE BUFFER TT_Widget     FOR TT_Widget.


    FIND TT_Object WHERE TT_Object.obj_dict_id = ipiDictId NO-ERROR.

    IF NOT AVAILABLE TT_Object THEN DO:
        RUN CreateVirtualObject ("DICT", ipiDictId, "", BUFFER TT_Object) NO-ERROR.
        {&adCheckErrorAndReturn}
    END.

    /* Field type */
    {getDict TT_dict ipiDictId "SCALAR" "~/FT"}.
    IF AVAILABLE TT_dict THEN
        ASSIGN
            obj-type           = IF obj-type = "~/Btn,radio" THEN obj-type ELSE TT_dict.value_scalar
            TT_Object.obj_type = "Widget".

    {getDict TT_dict ipiDictId "ARRAY" "~/Rect"}.
    IF AVAILABLE TT_dict THEN DO:
        FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id
            BY TT_array.value_id:
            obj-rect = obj-rect + " " + TT_array.value_scalar.
        END.
        obj-rect = SUBSTRING(obj-rect, 2).
    END.

    /* Field name */
    {getDict TT_dict ipiDictId "SCALAR" "~/T"}.
    IF AVAILABLE TT_dict THEN
        obj-name = parseText(TT_dict.value_scalar).

    /* Page to which the field belongs - optional */
    {getDict TT_dict ipiDictId "DICT" "~/P"}.
    IF AVAILABLE TT_dict THEN DO:
        FIND par_TT_Object WHERE par_TT_Object.obj_dict_id = TT_dict.value_dict_id NO-ERROR.
        IF AVAIL par_TT_Object THEN DO:
            /* Bit of a hack to ensure that the Field ID is set to the current
              document page - don't have time to figure out why the parent
              would be set as Page 0 (since it only happens sometimes) */
            IF par_TT_Object.page_id = 0 THEN
                par_TT_Object.page_id = doc-pages.
            par-page = par_TT_Object.page_id.
        END.
        ELSE
          par-page = 1.
    END.

    /* Default appearance string */
    {getDict TT_dict ipiDictId "SCALAR" "~/DA"}.
    IF AVAILABLE TT_dict THEN
        obj-disp = parseText(TT_dict.value_scalar).

    /* Field appearance ressources */
    {getDict TT_dict ipiDictId "DICT" "~/DR"}.
    IF AVAILABLE TT_dict THEN
        RUN ProcessDR (TT_dict.value_dict_id).

    /* Field flags: 32 bits integer bits field. Bit 13 is for multiline, 16 for Radio, 17 for push button, 18 for combos */
    {getDict TT_dict ipiDictId "SCALAR" "~/Ff"}.
    IF AVAILABLE TT_dict THEN DO:
        obj-multiline = obj-type = "~/Tx" AND LOGICAL(GET-BITS(INTEGER(TT_dict.value_scalar), 13, 1)).
        IF obj-type = "~/Btn"
           AND NOT LOGICAL(GET-BITS(INTEGER(TT_dict.value_scalar), 16, 1))
           AND NOT LOGICAL(GET-BITS(INTEGER(TT_dict.value_scalar), 17, 1)) THEN
            obj-type = obj-type + ",checkbox".
        ELSE IF obj-type = "~/Btn"
           AND LOGICAL(GET-BITS(INTEGER(TT_dict.value_scalar), 16, 1))
           AND NOT LOGICAL(GET-BITS(INTEGER(TT_dict.value_scalar), 17, 1)) THEN
            obj-type = obj-type + ",radio".
        ELSE IF obj-type = "~/Ch"
           AND LOGICAL(GET-BITS(INTEGER(TT_dict.value_scalar), 18, 1)) THEN
            obj-type = obj-type + ",combo".
        ELSE IF obj-type = "~/Ch" THEN
            obj-type = obj-type + ",list".
    END.
    ELSE IF obj-type = "~/Btn" THEN DO:
        {getDict TT_dict ipiDictId "DICT" "~/Parent"}.
        IF NOT AVAILABLE TT_dict THEN
            obj-type = obj-type + ",checkbox".
    END.
    ELSE IF obj-type = "~/Ch" THEN
        obj-type = obj-type + ",list".

    IF obj-type = "~/Ch,list" THEN DO:
        {getDict TT_dict ipiDictId "ARRAY" "~/V"}.
        IF AVAILABLE TT_dict THEN DO:
            FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id:
                obj-value = obj-value + CHR(10) + parseText(TT_array.value_scalar).
            END.
            obj-value = SUBSTRING(obj-value, 2).
        END.
    END.
    ELSE DO:
        {getDict TT_dict ipiDictId "SCALAR" "~/V"}.
        IF AVAILABLE TT_dict THEN DO:
            IF obj-type = "~/Tx" OR ENTRY(1,obj-type) = "~/Ch" THEN
                obj-value = parseText(TT_dict.value_scalar).
            ELSE IF obj-type = "~/Btn,checkbox" THEN
                obj-value = IF TT_dict.value_scalar = "~/Yes" THEN "YES" ELSE IF TT_dict.value_scalar = "~/Off" THEN "NO" ELSE "".
            ELSE IF obj-type = "~/Btn,radio" THEN /* 10-MAY-2014 jcc: the value for radio buttons was missing */
                obj-value = IF TT_dict.value_scalar = "~/Off" THEN "NO" ELSE TT_dict.value_scalar.
            ELSE /* 10-MAY-2014 jcc: should never happen */
                obj-value = TT_dict.value_scalar.
        END.
    END.

    /* find in the normal appearance stream (if any) the text position within the fill-in */
    IF obj-type = "~/Tx" THEN DO:
        {getDict TT_dict ipiDictId "DICT" "~/AP"}. /* Appearance dictionary */
        IF AVAILABLE TT_dict THEN blkAppearance: DO:
            {getDict N_TT_dict TT_dict.value_dict_id "DICT" "~/N"}. /* Normal appearance */
            IF AVAILABLE N_TT_dict THEN DO:
                rFilter = ?.
                {getDict bTT_dict N_TT_dict.value_dict_id "~/Filter"}. /* 03-JUN-2016 jcc: do not specify dict type as it might be SCALAR or ARRAY */
                IF AVAILABLE bTT_dict THEN
                    rFilter = ROWID(bTT_dict).
                rDecodeParms = ?.
                {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/DecodeParms"}.
                IF AVAILABLE bTT_dict THEN
                    rDecodeParms = ROWID(bTT_dict).
                ELSE DO: /* 04-NOV-2015 jcc: pdf 1.7 allows "DP" */
                    {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/DP"}.
                    IF AVAILABLE bTT_dict THEN
                        rDecodeParms = ROWID(bTT_dict).
                END.
                {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/Length"}.
                IF AVAILABLE bTT_dict THEN DO: /* available when there is a stream */
                    /* Search for a Td operator in the stream (position) */
                    /* The stream file is: pID + "-" + STRING(bTT_dict.dict_id) + ".stm" */
                    /* 25-SEP-2015 jcc: dict_id replaced by tt_object.obj_id: because of the new cache, dict_id might change */
                    FIND TT_Object WHERE TT_Object.obj_stream = pStream
                        AND TT_Object.obj_dict_id = N_TT_dict.value_dict_id NO-ERROR.
                    IF AVAILABLE TT_Object THEN DO:
                        IF rFilter <> ? THEN DO:
                            /* RUN decodeFile(pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".stm", */
                            RUN decodeFile(pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".stm",
                                           rFilter, rDecodeParms,
                                           /* pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".txt") NO-ERROR. */
                                           pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".txt") NO-ERROR.
                            IF ERROR-STATUS:ERROR THEN LEAVE blkAppearance.
                        END.
                        /* INPUT FROM VALUE(pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + (IF rFilter = ? THEN ".stm" ELSE ".txt")) BINARY NO-ECHO NO-CONVERT. */
                        INPUT FROM VALUE(pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + (IF rFilter = ? THEN ".stm" ELSE ".txt")) BINARY NO-ECHO NO-CONVERT NO-MAP.
                        DO WHILE TRUE:
                            cWord = readWord().
                            IF cWord = ? THEN DO: /* reached the EOF? */
                                ASSIGN cX = "" cY = "".
                                LEAVE.
                            END.
                            IF NOT lText THEN DO: /* skip everything until we find a BT (begin text) tag */
                                IF cWord = "BT" THEN
                                    lText = TRUE.
                                NEXT.
                            END.
                            IF cWord = "Td" THEN LEAVE.
                            ASSIGN
                                cX = cY
                                cY = cWord.
                            /* Bug: there might be a "Tm" operator */
                        END.
                        INPUT CLOSE.
                    END. /* AVAILABLE TT_Object */
                END. /* AVAILABLE /Length */
            END.
        END.

        /* Justification */
        {getDict TT_dict ipiDictId "SCALAR" "~/Q"}.
        IF AVAILABLE TT_dict THEN
            obj-justif = TT_dict.value_scalar. /* 0: left, 1: center, 2: right */
    END. /* IF obj-type = "~/Tx" */

    /* List of possible values for Combo and List box */
    ELSE IF ENTRY(1,obj-type) = "~/Ch" THEN DO:
        {getDict TT_dict ipiDictId "ARRAY" "~/Opt"}.
        IF AVAILABLE TT_dict THEN DO:
            FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id: 
                obj-values = obj-values + CHR(10) + parseText(TT_array.value_scalar).
            END.
            obj-values = SUBSTRING(obj-values, 2).
        END.

        /* Justification */
        {getDict TT_dict ipiDictId "SCALAR" "~/Q"}.
        IF AVAILABLE TT_dict THEN
            obj-justif = TT_dict.value_scalar. /* 0: left, 1: center, 2: right */
    END.

    /* Checkbox & radio buttons appearances */
    ELSE IF ENTRY(1,obj-type) = "~/Btn" THEN DO:
        {getDict TT_dict ipiDictId "DICT" "~/AP"}. /* Appearance dictionary */
        IF AVAILABLE TT_dict THEN DO:
            {getDict N_TT_dict TT_dict.value_dict_id "DICT" "~/N"}. /* Normal appearance dict */
            IF AVAILABLE N_TT_dict THEN blkAppearanceOn: DO:
                /* "On" appearance dict: this is the one which name is *not* /Off... */
                FIND ap_TT_dict WHERE ap_TT_dict.dict_id = N_TT_dict.value_dict_id
                                  AND ap_TT_dict.value_type = "DICT"
                                  AND ap_TT_dict.dict_key <> "~/Off" NO-ERROR.
                /* 25-SEP-2015 jcc: dict_id replaced by tt_object.obj_id: because of the new cache, dict_id might change */
                FIND TT_Object WHERE TT_Object.obj_stream = pStream
                    AND TT_Object.obj_dict_id = ap_TT_dict.value_dict_id NO-ERROR.
                IF AVAILABLE ap_TT_dict AND AVAILABLE TT_Object THEN DO:
                    obj-on-value = LEFT-TRIM(ap_TT_dict.dict_key, "~/").
                    rFilter = ?.
                    {getDict bTT_dict ap_TT_dict.value_dict_id "~/Filter"}. /* 03-JUN-2016 jcc: do not specify dict type as it might be SCALAR or ARRAY */
                    IF AVAILABLE bTT_dict THEN DO:
                        rFilter = ROWID(bTT_dict).
                        rDecodeParms = ?.
                        {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/DecodeParms"}.
                        IF AVAILABLE bTT_dict THEN
                            rDecodeParms = ROWID(bTT_dict).
                        ELSE DO: /* 04-NOV-2015 jcc: pdf 1.7 allows "DP" */
                            {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/DP"}.
                            IF AVAILABLE bTT_dict THEN
                                rDecodeParms = ROWID(bTT_dict).
                        END.
                        {getDict bTT_dict ap_TT_dict.value_dict_id "SCALAR" "~/Length"}.
                        IF AVAILABLE bTT_dict THEN DO: /* available when there is a stream */
                            IF rFilter <> ? THEN DO:
                                RUN decodeFile(pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".stm",
                                /* RUN decodeFile(pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".stm", */
                                               rFilter, rDecodeParms,
                                               pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".txt") NO-ERROR.
                                               /* pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".txt") NO-ERROR. */
                                IF ERROR-STATUS:ERROR THEN LEAVE blkAppearanceOn.
                                obj-on = pcCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".txt".
                                /* obj-on = pcCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".txt". */
                            END.
                        END.
                    END. /* If AVAILABLE filter */
                    ELSE
                        obj-on = pcCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".stm".
                        /* obj-on = pcCacheDir + pID + "-" + STRING(ap_TT_dict.value_dict_id) + ".stm". */
                END. /* If AVAILABLE /Yes */
                /* "Off" appearance dict */
                {getDict ap_TT_dict N_TT_dict.value_dict_id "DICT" "~/Off"}.
                /* 25-SEP-2015 jcc: dict_id replaced by tt_object.obj_id: because of the new cache, dict_id might change */
                FIND TT_Object WHERE TT_Object.obj_stream = pStream
                    AND TT_Object.obj_dict_id = ap_TT_dict.value_dict_id NO-ERROR.
                IF AVAILABLE ap_TT_dict AND AVAILABLE TT_Object THEN blkAppearanceOff: DO:
                    rFilter = ?.
                    {getDict bTT_dict ap_TT_dict.value_dict_id "~/Filter"}. /* 03-JUN-2016 jcc: do not specify dict type as it might be SCALAR or ARRAY */
                    IF AVAILABLE bTT_dict THEN DO:
                        rFilter = ROWID(bTT_dict).
                        rDecodeParms = ?.
                        {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/DecodeParms"}.
                        IF AVAILABLE bTT_dict THEN
                            rDecodeParms = ROWID(bTT_dict).
                        ELSE DO: /* 04-NOV-2015 jcc: pdf 1.7 allows "DP" */
                            {getDict bTT_dict N_TT_dict.value_dict_id "SCALAR" "~/DP"}.
                            IF AVAILABLE bTT_dict THEN
                                rDecodeParms = ROWID(bTT_dict).
                        END.
                        {getDict bTT_dict ap_TT_dict.value_dict_id "SCALAR" "~/Length"}.
                        IF AVAILABLE bTT_dict THEN DO: /* available when there is a stream */
                            IF rFilter <> ? THEN DO:
                                RUN decodeFile(pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".stm",
                                /* RUN decodeFile(pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".stm", */
                                               rFilter, rDecodeParms,
                                               pcTmpCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".txt") NO-ERROR.
                                               /* pcTmpCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".txt") NO-ERROR. */
                                IF ERROR-STATUS:ERROR THEN LEAVE blkAppearanceOff.
                                obj-off = pcCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".txt".
                                /* obj-off = pcCacheDir + pID + "-" + STRING(bTT_dict.dict_id) + ".txt". */
                            END.
                        END.
                    END.
                    ELSE
                        obj-off = pcCacheDir + pID + "-" + STRING(TT_Object.obj_id) + ".stm".
                        /* obj-off = pcCacheDir + pID + "-" + STRING(N_TT_dict.value_dict_id) + ".stm". */
                END. /* If AVAILABLE /Off */
                IF obj-on-value > "" THEN obj-values = obj-on-value + ",No".
            END.
        END.
    END.

    par-obj-name = obj-name.
    {getDict TT_dict ipiDictId "ARRAY" "~/Kids"}.
    IF AVAILABLE TT_dict THEN DO:
        FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id
            BY TT_array.value_id:
            RUN ProcessFieldDictionary (TT_array.value_dict_id, INPUT-OUTPUT obj-name, obj-type, obj-disp, obj-justif, obj-multiline).
            /* 28-MAY-2013 jcc: create a "FormWidget,Kid" TT_Resource for kids, so that we can exclude the corresponding Annots when the parent widget is flattened (pdf_inc.p|pdf_definition) */
            FIND TT_Object WHERE TT_Object.obj_dict_id = TT_array.value_dict_id NO-ERROR.
            IF AVAILABLE TT_Object THEN DO:
                CREATE TT_Resource.
                ASSIGN TT_Resource.obj_stream = pStream
                       TT_Resource.pdf_id     = pID
                       TT_Resource.page_id    = 0
                       TT_Resource.res_type   = "FormWidget,Kid"
                       TT_Resource.res_obj    = TT_Object.obj_id
                       TT_Resource.res_gen    = TT_Object.gen_id
                       TT_Resource.res_text   = par-obj-name. /* 28-MAY-2013 jcc: store the name here to be used in pdf_inc.p|pdf_definition */
            END.
            lHasKids = TRUE.
        END.
    END.
    obj-name = par-obj-name.

    /* A text form field or a checkbox or any other form widget was found */
    IF NOT lHasKids /*AND (obj-type = "~/Tx" OR ENTRY(1,obj-type) = "~/Btn" OR ENTRY(1,obj-type) = "~/Ch")*/ THEN DO:
      CREATE TT_Widget.
      ASSIGN TT_widget.obj_stream       = pStream
             TT_widget.pdf_id           = pID
             TT_Widget.widget_name      = obj-name
             TT_Widget.widget_type      = obj-type
             TT_Widget.widget_rect      = obj-rect
             TT_Widget.widget_tpos      = IF cX > "" AND cY > "" THEN cX + " " + cY + " Td" ELSE ""
             TT_Widget.widget_disp      = obj-disp
             TT_Widget.widget_justif    = IF obj-justif > "" THEN obj-justif ELSE "0"
             TT_Widget.widget_multiline = obj-multiline
             TT_Widget.widget_on        = obj-on
             TT_Widget.widget_off       = obj-off
             TT_Widget.widget_on_value  = IF ENTRY(1,obj-type) = "~/Btn" THEN IF obj-on-value = "" THEN "Yes" ELSE obj-on-value ELSE ""
             TT_Widget.widget_value     = obj-value
             TT_Widget.widget_values    = obj-values
             TT_Widget.widget_page      = par-page.
    END.

END. /* ProcessFieldDictionary */

PROCEDURE ProcessDR:
    DEFINE INPUT  PARAMETER ipiDictId AS INTEGER    NO-UNDO.

    DEFINE VARIABLE iFontNbr AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iGen     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iObj     AS INTEGER   NO-UNDO.

    DEFINE BUFFER TT_dict     FOR TT_dict.
    DEFINE BUFFER bTT_dict    FOR TT_dict.
    DEFINE BUFFER TT_Resource FOR TT_Resource.
    DEFINE BUFFER TT_Object   FOR TT_Object.
    DEFINE BUFFER TT_Font     FOR TT_Font.
    DEFINE BUFFER bTT_Font    FOR TT_Font.

    {getDict TT_dict ipiDictId "DICT" "~/Font"}.
    IF AVAILABLE TT_dict THEN
        FOR EACH bTT_dict WHERE bTT_dict.dict_id = TT_dict.value_dict_id,
            FIRST TT_Object WHERE TT_Object.obj_dict_id = bTT_dict.value_dict_id:
            /* 18-JAN-2011 jcc: do not create duplicate of the ressource */
            IF NOT CAN-FIND(FIRST TT_Resource                                
                            WHERE TT_Resource.obj_stream = pStream
                              AND TT_Resource.res_obj = TT_Object.obj_id
                              AND TT_Resource.res_gen = TT_Object.gen_id) THEN DO:
                CREATE TT_Resource.
                ASSIGN TT_Resource.obj_stream = pStream
                       TT_Resource.pdf_id     = pID
                       TT_Resource.page_id    = 0
                       TT_Resource.res_type   = "Font"
                       TT_Resource.res_obj    = TT_Object.obj_id
                       TT_Resource.res_gen    = TT_Object.gen_id
                       TT_Resource.res_text   = bTT_dict.dict_key.
                       /* TT_Resource.res_text   = "~/xTT" + STRING(iFontNbr). */
                iFontNbr = iFontNbr + 1.
            END.

            /* 14-JAN-2011 jcc: process the font dictionary only it has not already been done */
            IF CAN-FIND (FIRST bTT_Font WHERE bTT_Font.obj_stream = pStream
                         AND bTT_Font.pdf_id = pID
                         AND bTT_Font.obj_id = TT_Object.obj_id
                         AND bTT_Font.gen_id = TT_Object.gen_id) THEN ASSIGN
                iObj = TT_Object.obj_id
                iGen = TT_Object.gen_id.
            ELSE
                RUN ProcessFontDictionary (bTT_dict.value_dict_id, 0,
                    /*TT_Resource.res_Text*/ bTT_dict.dict_key, YES, OUTPUT iObj, OUTPUT iGen).

            /* 14-JAN-2011 jcc: in case the font name is an alias, create a TT_Font
               and/or set used_flag = YES so that the font appears in the ressources
               of the added text (i.e. the text used to fill the form).
               This happens e.g. with OpenOffice.org generated forms */
            FIND TT_Font
              WHERE TT_Font.obj_stream = pStream
                AND TT_Font.pdf_id     = pID
                AND TT_Font.obj_id     = iObj
                AND TT_Font.gen_id     = iGen
                AND TT_Font.font_name  = SUBSTRING(bTT_dict.dict_key, 2) NO-ERROR. /* SUBSTRING to remove the leading slash */
            IF NOT AVAILABLE TT_Font THEN
                FIND FIRST TT_Font
                  WHERE TT_Font.obj_stream = pStream
                    AND TT_Font.pdf_id     = pID
                    AND TT_Font.obj_id     = iObj
                    AND TT_Font.gen_id     = iGen
                    AND TT_Font.font_name  = ""
                    AND TT_Font.font_tag   = bTT_dict.dict_key NO-ERROR.

            IF AVAILABLE TT_Font THEN ASSIGN
              TT_Font.font_name = SUBSTRING(bTT_dict.dict_key, 2)
              TT_Font.used_flag = YES.
            ELSE DO:
              FIND FIRST TT_Font
                WHERE TT_Font.obj_stream = pStream AND TT_Font.pdf_id = pID
                  AND TT_Font.obj_id = iObj AND TT_Font.gen_id = iGen NO-ERROR.
              IF AVAILABLE TT_Font THEN DO:
                CREATE bTT_Font.
                BUFFER-COPY TT_Font EXCEPT font_name used_flag TO bTT_Font
                  ASSIGN
                    bTT_Font.font_name = SUBSTRING(bTT_dict.dict_key, 2)
                    bTT_Font.used_flag = YES.
              END.
            END.
        END. /* FOR EACH bTT_dict */
END. /* ProcessDR */

PROCEDURE ProcessPagesDictionary:
  DEFINE INPUT PARAMETER ipiDictId AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER dCrop1    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop2    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop3    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop4    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia1   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia2   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia3   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia4   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER iRotate   AS INTEGER   NO-UNDO.

  DEFINE BUFFER TT_dict  FOR TT_dict.
  DEFINE BUFFER TT_array FOR TT_array.
  
  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  {getDict TT_dict ipiDictId "ARRAY" "~/MediaBox"}.
  IF AVAILABLE TT_dict AND TT_dict.value_array_id > -1 THEN DO:
      RUN ProcessMediaBox (TT_dict.value_array_id,
                           OUTPUT dMedia1,
                           OUTPUT dMedia2,
                           OUTPUT dMedia3,
                           OUTPUT dMedia4) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "ARRAY" "~/CropBox"}.
  IF AVAILABLE TT_dict AND TT_dict.value_array_id > -1 THEN DO:
      RUN ProcessCropBox (TT_dict.value_array_id,
                          OUTPUT dCrop1,
                          OUTPUT dCrop2,
                          OUTPUT dCrop3,
                          OUTPUT dCrop4) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/Resources"}.
  IF AVAILABLE TT_dict AND TT_dict.value_dict_id > -1 THEN DO:
      RUN ProcessResourceDictionary (TT_dict.value_dict_id, 0) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Rotate"}.
  IF AVAILABLE TT_dict THEN
      iRotate = INTEGER(TT_dict.value_scalar).

  {getDict TT_dict ipiDictId "ARRAY" "~/Kids"}.
  IF AVAILABLE TT_dict AND TT_dict.value_array_id > -1 THEN DO:
      FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id:

          RUN ProcessPageDictionary (TT_array.value_dict_id,
            dCrop1, dCrop2, dCrop3, dCrop4,
            dMedia1, dMedia2, dMedia3, dMedia4,
            iRotate) NO-ERROR.
          {&adCheckErrorAndReturn}
      END.
  END.

END. /* ProcessPagesDictionary */

PROCEDURE ProcessMediaBox:
  DEFINE INPUT  PARAMETER ipiArrayId    AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeDefMedia1 AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeDefMedia2 AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeDefMedia3 AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeDefMedia4 AS DECIMAL   NO-UNDO.

  DEFINE VARIABLE i AS INTEGER    NO-UNDO.

  DEFINE BUFFER TT_array FOR TT_array.

  IF ipiArrayId < 0 THEN RETURN. /* empty array */

  DO i = 1 TO 4:
      FIND TT_array WHERE TT_array.array_id   = ipiArrayId
                      AND TT_array.value_id   = i
                      AND TT_array.value_type = "SCALAR" NO-ERROR.
      IF AVAILABLE TT_array THEN CASE i:
          WHEN 1 THEN opdeDefMedia1 = string2dec(TT_array.value_scalar).
          WHEN 2 THEN opdeDefMedia2 = string2dec(TT_array.value_scalar).
          WHEN 3 THEN opdeDefMedia3 = string2dec(TT_array.value_scalar).
          WHEN 4 THEN opdeDefMedia4 = string2dec(TT_array.value_scalar).
      END CASE.
      ELSE
          RETURN ERROR "Malformed MediaBox" + CHR(3) + ABLCallStack(0).
  END.
END.  /* ProcessMediaBox */

PROCEDURE ProcessCropBox:
  DEFINE INPUT  PARAMETER ipiArrayId    AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeCrop1 AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeCrop2 AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeCrop3 AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER opdeCrop4 AS DECIMAL   NO-UNDO.

  DEFINE VARIABLE i AS INTEGER    NO-UNDO.

  DEFINE BUFFER TT_array FOR TT_array.

  IF ipiArrayId < 0 THEN RETURN. /* empty array */

  DO i = 1 TO 4:
      FIND TT_array WHERE TT_array.array_id   = ipiArrayId
                      AND TT_array.value_id   = i
                      AND TT_array.value_type = "SCALAR" NO-ERROR.
      IF AVAILABLE TT_array THEN CASE i:
          WHEN 1 THEN opdeCrop1 = string2dec(TT_array.value_scalar).
          WHEN 2 THEN opdeCrop2 = string2dec(TT_array.value_scalar).
          WHEN 3 THEN opdeCrop3 = string2dec(TT_array.value_scalar).
          WHEN 4 THEN opdeCrop4 = string2dec(TT_array.value_scalar).
      END CASE.
      ELSE
          RETURN ERROR "Malformed CropBox" + CHR(3) + ABLCallStack(0).
  END.
END.  /* ProcessCropBox */

PROCEDURE ProcessPageDictionary:
  DEFINE INPUT PARAMETER ipiDictId AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER dCrop1    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop2    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop3    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop4    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia1   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia2   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia3   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia4   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER iRotate   AS INTEGER   NO-UNDO.

  DEFINE BUFFER TT_Object FOR TT_Object.

  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  {getDict TT_dict ipiDictId "SCALAR" "~/Type"}.
  IF NOT AVAILABLE TT_dict THEN /* 05-NOV-2014 jcc: protection against invalid pdf */
      RETURN ERROR "Invalid pdf template: page object dictionary is missing /Type key" + CHR(3) + ABLCallStack(0).

  FIND LAST TT_Object WHERE TT_Object.obj_dict_id = ipiDictId NO-ERROR.
  IF NOT AVAILABLE TT_Object THEN DO:
      RUN CreateVirtualObject ("DICT", ipiDictId, "", BUFFER TT_Object) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.
  IF AVAILABLE TT_Object THEN
      TT_Object.obj_type = SUBSTRING(TT_dict.value_scalar, 2). /* remove leading slash */

  CASE SUBSTRING(TT_dict.value_scalar, 2):
      WHEN "Pages" THEN DO:
        RUN ProcessPagesDictionary (ipiDictId,
            dCrop1, dCrop2, dCrop3, dCrop4,
            dMedia1, dMedia2, dMedia3, dMedia4,
            iRotate) NO-ERROR.
        {&adCheckErrorAndReturn}
      END.

      WHEN "Page" THEN DO:
        doc-pages = doc-pages + 1.
        TT_object.page_id = doc-pages.
        RUN ProcessPageObject (ipiDictId, doc-pages,
            dCrop1, dCrop2, dCrop3, dCrop4,
            dMedia1, dMedia2, dMedia3, dMedia4,
            iRotate) NO-ERROR.
        {&adCheckErrorAndReturn}
      END.
  END CASE.

END. /* ProcessPageDictionary */

PROCEDURE ProcessPageObject:
  DEFINE INPUT PARAMETER ipiDictId AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER pPage     AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER dCrop1    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop2    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop3    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dCrop4    AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia1   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia2   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia3   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER dMedia4   AS DECIMAL   DECIMALS 5 NO-UNDO.
  DEFINE INPUT PARAMETER iRotate   AS INTEGER   NO-UNDO.

  DEFINE VARIABLE L_Entries AS INTEGER     NO-UNDO.

  DEFINE BUFFER TT_Object FOR TT_Object.
  DEFINE BUFFER TT_dict   FOR TT_dict.
  DEFINE BUFFER bTT_dict  FOR TT_dict.
  DEFINE BUFFER TT_array  FOR TT_array.

  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  FIND LAST TT_Object WHERE TT_Object.obj_dict_id = ipiDictId NO-ERROR.
  IF NOT AVAILABLE TT_Object THEN DO:
      RETURN ERROR "Missing page object!" + CHR(3) + ABLCallStack(0).
      /* RUN CreateVirtualObject ("DICT", ipiDictId, "", BUFFER TT_Object) NO-ERROR. */
      /* {&adCheckErrorAndReturn} */
  END.

  {getDict TT_dict ipiDictId "ARRAY" "~/Mediabox"}.
  IF AVAILABLE TT_dict AND TT_dict.value_array_id > -1 THEN DO:
      RUN ProcessMediaBox (TT_dict.value_array_id,
                           OUTPUT dMedia1,
                           OUTPUT dMedia2,
                           OUTPUT dMedia3,
                           OUTPUT dMedia4) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  ASSIGN TT_Object.obj_media1 = dMedia1
         TT_Object.obj_media2 = dMedia2
         TT_Object.obj_media3 = dMedia3
         TT_Object.obj_media4 = dMedia4.

  {getDict TT_dict ipiDictId "ARRAY" "~/CropBox"}.
  IF AVAILABLE TT_dict AND TT_dict.value_array_id > -1 THEN DO:
      RUN ProcessCropBox (TT_dict.value_array_id,
                          OUTPUT dCrop1,
                          OUTPUT dCrop2,
                          OUTPUT dCrop3,
                          OUTPUT dCrop4) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  ASSIGN TT_Object.obj_crop1 = dCrop1
         TT_Object.obj_crop2 = dCrop2
         TT_Object.obj_crop3 = dCrop3
         TT_Object.obj_crop4 = dCrop4.

  {getDict TT_dict ipiDictId "SCALAR" "~/Rotate"}.
  IF AVAILABLE TT_dict THEN DO:
      TT_Object.Rotate = INTEGER(TT_dict.value_scalar).
  END.
  ELSE
      TT_Object.Rotate = iRotate.

  {getDict TT_dict ipiDictId "DICT" "~/Resources"}.
  IF AVAILABLE TT_dict AND TT_dict.value_dict_id > -1 THEN DO:
       RUN ProcessResourceDictionary (TT_dict.value_dict_id, pPage) NO-ERROR.
       {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "~/Contents"}.
  /* contents might be a dictionary or an array of dictionaries */
  IF TT_dict.value_type = "ARRAY" AND TT_dict.value_array_id > -1 THEN DO:
      FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id
          BY TT_array.value_id:
          RUN ProcessPageContent (TT_array.value_id, TT_array.value_dict_id, pPage) NO-ERROR.
          {&adCheckErrorAndReturn}
      END.
  END.
  ELSE IF TT_dict.value_type = "DICT" AND TT_dict.value_dict_id > -1 THEN DO:
      RUN ProcessPageContent (1, TT_dict.value_dict_id, pPage) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  /* 23-AUG-2012 jcc: remember annotations (widget annotations used by AcroForm and other annotations as defined in the retainAnnots parameter) */
  DEFINE VARIABLE cRetainAnnotsList AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lRetainAcroForm   AS LOGICAL     NO-UNDO.

  cRetainAnnotsList = pdf_get_parameter(pStream, "retainAnnots").
  /* lRetainAcroForm = pdf_get_parameter(pStream, "retainAcroForm") = "TRUE". */
  lRetainAcroForm = pdf_get_parameter2(pStream, "formFlatten", "*") <> "*".
  IF NOT lRetainAcroForm AND cRetainAnnotsList = "*" THEN
      cRetainAnnotsList = "!Widget,*".
  IF lRetainAcroForm THEN
      cRetainAnnotsList = cRetainAnnotsList + (IF cRetainAnnotsList > "" THEN "," ELSE "") + "Widget".
  IF lRetainAcroForm OR cRetainAnnotsList > "" THEN DO:
      {getDict TT_dict ipiDictId "ARRAY" "~/Annots"}.
      IF AVAILABLE TT_dict AND TT_dict.value_array_id > -1 THEN DO:
          FOR EACH TT_array WHERE TT_array.array_id = TT_dict.value_array_id:
              {getDict bTT_dict TT_array.value_dict_id "SCALAR" "~/Subtype"}.
              IF NOT AVAILABLE bTT_dict OR NOT CAN-DO(cRetainAnnotsList, SUBSTRING(bTT_dict.value_scalar, 2)) THEN NEXT.
              FIND FIRST TT_Object WHERE TT_Object.obj_dict_id = TT_array.value_dict_id NO-ERROR.
              IF NOT AVAILABLE TT_Object THEN DO:
                  RUN CreateVirtualObject ("DICT", TT_array.value_dict_id, "", BUFFER TT_Object) NO-ERROR.
                  {&adCheckErrorAndReturn}
              END.
              CREATE TT_Resource.
              ASSIGN TT_Resource.obj_stream = pStream
                     TT_Resource.pdf_id     = pID
                     TT_Resource.page_id    = pPage
                     TT_Resource.res_type   = "Annot"
                     TT_Resource.res_obj    = TT_Object.obj_id
                     TT_Resource.res_gen    = TT_Object.gen_id
                     TT_Resource.res_text   = "".
          END.
      END.
  END.

END. /* ProcessPageObject */

PROCEDURE ProcessResourceDictionary:
  DEFINE INPUT  PARAMETER ipiDictId AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pPage AS INTEGER    NO-UNDO.

  DEFINE VARIABLE L_Entries AS CHARACTER NO-UNDO.

  DEFINE BUFFER TT_Object FOR TT_object.
  DEFINE BUFFER TT_dict   FOR TT_dict.

  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  FIND LAST TT_Object WHERE TT_Object.obj_dict_id = ipiDictId NO-ERROR.
  IF NOT AVAILABLE TT_Object THEN DO:
      RUN CreateVirtualObject ("DICT", ipiDictId, "", BUFFER TT_Object) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  ASSIGN TT_Object.obj_type = "~/Resource"
         TT_Object.page_id  = pPage.

  {getDict TT_dict ipiDictId "DICT" "~/Font"}.
  IF AVAILABLE TT_dict AND TT_dict.value_dict_id > -1 THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "Font") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/Xobject"}.
  IF AVAILABLE TT_dict THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "Xobject") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/ExtGState"}.
  IF AVAILABLE TT_dict THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "ExtGState") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/ColorSpace"}.
  IF AVAILABLE TT_dict THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "ColorSpace") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/Shading"}.
  IF AVAILABLE TT_dict THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "Shading") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/Pattern"}.
  IF AVAILABLE TT_dict THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "Pattern") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  {getDict TT_dict ipiDictId "DICT" "~/Properties"}.
  IF AVAILABLE TT_dict THEN DO:
      RUN ProcessEntry (TT_dict.value_dict_id, pPage, "Properties") NO-ERROR.
      {&adCheckErrorAndReturn}
  END.

  /* 03-FEB-2011 jcc: TODO: /ProcSet is an array, cannot be treated like the others
  FIND TT_dict WHERE TT_dict.dict_id    = ipiDictId
                 AND TT_dict.dict_key   = "~/ProcSet"
                 AND TT_dict.value_type = "ARRAY" NO-ERROR.
  IF AVAILABLE TT_dict THEN DO:
      ...
      {&adCheckErrorAndReturn}
  END.
  */

END. /* ProcressResourceDictionary */

/* Process the mapping between names and objects defined in /Resource */
PROCEDURE ProcessEntry:
  DEFINE INPUT PARAMETER ipiDictId AS INTEGER     NO-UNDO.
  DEFINE INPUT PARAMETER pPage     AS INTEGER     NO-UNDO.
  DEFINE INPUT PARAMETER pType     AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE cDataType AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iGen      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iObj      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE l_Array   AS LOGICAL     NO-UNDO INIT FALSE.
  DEFINE VARIABLE l_Length  AS INTEGER     NO-UNDO.

  DEFINE BUFFER TT_dict     FOR TT_dict.
  DEFINE BUFFER bTT_dict    FOR TT_dict.
  DEFINE BUFFER bTT_array   FOR TT_array.
  DEFINE BUFFER bTT_Object  FOR TT_Object.
  DEFINE BUFFER TT_Resource FOR TT_Resource.

  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  /* we have a dictionary containing named objects: /Name <object> */
  FOR EACH TT_dict WHERE TT_dict.dict_id = ipiDictId:
      /* let's check the object associated to /Name */
      CASE TT_dict.value_type:
          WHEN "DICT" THEN IF TT_dict.value_dict_id > -1 THEN DO:
              FIND bTT_Object WHERE bTT_Object.obj_dict_id = TT_dict.value_dict_id NO-ERROR.
          END.
          WHEN "ARRAY" THEN IF TT_dict.value_array_id > -1 THEN DO: /* /Procset only */
              FIND bTT_Object WHERE bTT_Object.obj_array_id = TT_dict.value_array_id NO-ERROR.
          END.
          OTHERWISE
              NEXT. /* TODO: check the pdf spec - could be a /Colorspace */
      END CASE.
      IF AVAILABLE bTT_Object THEN DO:
          ASSIGN
              iObj = bTT_Object.obj_id
              iGen = bTT_Object.gen_id.
      END.

      /* Skip resources that have already been added */
      IF CAN-FIND(FIRST tt_Resource
                WHERE tt_Resource.obj_stream = pStream
                  AND tt_Resource.pdf_id     = pID
                  AND tt_Resource.page_id    = pPage /* igc - 10/21/05 */
                  /* AND (   tt_Resource.page_id    = pPage /* igc - 10/21/05 */ */
                       /* OR tt_Resource.page_id    = 0 ) /* 17-JAN-2011 jcc: skip if resources have been added globally, i.e. page = 0 */ */
                  /* 27-OCT-2014 jcc: XObjects tags are not changed anymore */
                  AND tt_Resource.res_text   = (/*IF pType = "Xobject" THEN
                                                  "~/" + pID + SUBSTRING(TT_dict.dict_key, 2)
                                                ELSE*/ TT_dict.dict_key )
                  AND tt_Resource.res_type   = pType
                  AND tt_Resource.res_obj    = iObj
                  AND tt_Resource.res_gen    = iGen)
      THEN NEXT.

      CREATE TT_Resource.
      ASSIGN TT_Resource.obj_stream = pStream
             TT_Resource.pdf_id     = pID
             TT_Resource.page_id    = pPage
             TT_Resource.res_type   = pType
             TT_Resource.res_obj    = iObj
             TT_Resource.res_gen    = iGen
             /* 27-OCT-2014 jcc: XObjects tags are not changed anymore */
             TT_Resource.res_text   = /*IF pType = "Xobject" THEN
                                        "~/" + pID + SUBSTRING(TT_dict.dict_key, 2)
                                      ELSE*/ TT_dict.dict_key
             TT_Resource.res_old    = IF pType = "Xobject" THEN
                                        TT_dict.dict_key
                                      ELSE "".

      CASE pType:
        WHEN "Font" THEN DO:
          RUN ProcessFontDictionary (TT_dict.value_dict_id, pPage, TT_Resource.res_text, NO, OUTPUT iObj, OUTPUT iGen) NO-ERROR.
          {&adCheckErrorAndReturn}          
        END.
        WHEN "ColorSpace" THEN CASE TT_dict.value_type:
          WHEN "ARRAY" THEN DO:
              RUN ProcessColorSpace ("ARRAY", TT_dict.value_array_id, pPage, OUTPUT iObj, OUTPUT iGen) NO-ERROR.
              {&adCheckErrorAndReturn}          
          END.
          /* 03-FEB-2011 jcc: TODO */
          /* WHEN "SCALAR" THEN DO: */
              /* RUN ProcessColorSpace ("SCALAR", TT_dict.value_scalar, pPage). */
              /* {&adCheckErrorAndReturn} */
          /* END. */
        END. /* CASE TT_dict.value_type */
        WHEN "Shading" OR
        WHEN "XObject" OR
        WHEN "ExtGState" OR 
        WHEN "Pattern" OR
        WHEN "Properties" THEN DO:
            FIND LAST bTT_Object WHERE bTT_Object.obj_dict_id = TT_dict.value_dict_id NO-ERROR.
            IF NOT AVAILABLE bTT_Object THEN DO:
                RUN CreateVirtualObject ("DICT", TT_dict.value_dict_id, "", BUFFER bTT_Object) NO-ERROR.
                {&adCheckErrorAndReturn}
            END.              
            ASSIGN
                iObj                = bTT_Object.obj_id
                iGen                = bTT_Object.gen_id
                bTT_Object.obj_type = "~/" + pType
                bTT_Object.page_id  = pPage.
        END.
      END CASE.
      ASSIGN
          TT_Resource.res_obj = iObj
          TT_Resource.res_gen = iGen.
  END. /* FOR EACH TT_dict */
END. /* ProcessEntry */

PROCEDURE ProcessFontDictionary:
  DEFINE INPUT  PARAMETER ipiDictId AS INTEGER     NO-UNDO.
  DEFINE INPUT  PARAMETER pPage     AS INTEGER     NO-UNDO.
  DEFINE INPUT  PARAMETER pTag      AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER plUsed    AS LOGICAL     NO-UNDO.
  DEFINE OUTPUT PARAMETER piObj     AS INTEGER     NO-UNDO.
  DEFINE OUTPUT PARAMETER piGen     AS INTEGER     NO-UNDO.

  DEFINE VARIABLE base-font   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cWidths     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE font_name   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lDescriptor AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE rTTFont     AS ROWID       NO-UNDO.

  DEFINE BUFFER TT_dict    FOR TT_dict.
  DEFINE BUFFER bTT_dict   FOR TT_dict.
  DEFINE BUFFER bTT_array  FOR TT_array.
  DEFINE BUFFER TT_Object  FOR TT_Object.
  DEFINE BUFFER bTT_Object FOR TT_Object.
  DEFINE BUFFER TT_Font    FOR TT_Font.

  IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

  FIND LAST TT_Object WHERE TT_Object.obj_dict_id = ipiDictId NO-ERROR.
  IF NOT AVAILABLE TT_Object THEN DO:
      RUN CreateVirtualObject ("DICT", ipiDictId, "", BUFFER TT_Object) NO-ERROR.
      {&adCheckErrorAndReturn}
  END.
  
  ASSIGN
      piObj = TT_Object.obj_id
      piGen = TT_Object.gen_id
      TT_Object.obj_type = "~/Font".

  {getDict TT_dict ipiDictId "DICT" "~/FontDescriptor"}.
  IF AVAILABLE TT_dict AND TT_dict.value_dict_id > -1 THEN DO:
      FIND FIRST bTT_dict WHERE bTT_dict.dict_id = TT_dict.value_dict_id.
      FIND LAST bTT_Object WHERE bTT_Object.obj_dict_id = bTT_dict.dict_id NO-ERROR.
      IF NOT AVAILABLE bTT_Object THEN DO:
          RUN CreateVirtualObject ("DICT", bTT_dict.dict_id, "", BUFFER bTT_Object) NO-ERROR.
          {&adCheckErrorAndReturn}
      END.              
    lDescriptor = TRUE.
    RUN ProcessFontDescriptorDictionary (TT_dict.value_dict_id, /* font desc dict */
                                         ipiDictId,             /* parent dict    */
                                         pPage,
                                         pTag,
                                         plUsed,
                                         OUTPUT base-font,
                                         OUTPUT rTTFont) NO-ERROR.
    {&adCheckErrorAndReturn}
  END.
  
  IF base-font = "" THEN DO:
      {getDict TT_dict ipiDictId "SCALAR" "~/BaseFont"}.
      IF AVAILABLE TT_dict THEN
          base-font = TT_dict.value_scalar.
  END.

  {getDict TT_dict ipiDictId "SCALAR" "~/Name"}.
  IF AVAILABLE TT_dict THEN
      font_name = TT_dict.value_scalar.

  {getDict TT_dict ipiDictId "ARRAY" "~/Widths"}.
  IF AVAILABLE TT_dict THEN DO:
      FOR EACH bTT_array WHERE bTT_array.array_id = TT_dict.value_array_id
        BY bTT_array.value_id:
        cWidths = cWidths + " " + bTT_array.value_scalar.
      END.
      cWidths = SUBSTRING(cWidths, 2).
      /* 15-OCT-2014 jcc: pad with zeroes up to /FirstChar, else _pdf_text_width won't find the correct widths - slso take /LastChar into account */
      {getDict TT_dict ipiDictId "SCALAR" "~/FirstChar"}.
      IF AVAILABLE TT_dict THEN
          cWidths = FILL("0 ", INTEGER(TT_dict.value_scalar)) + cWidths.
      {getDict TT_dict ipiDictId "SCALAR" "~/LastChar"}.
      IF AVAILABLE TT_dict AND INTEGER(TT_dict.value_scalar) < 255 THEN
          cWidths = cWidths + FILL("0 ", INTEGER(TT_dict.value_scalar) - 255).
  END.

  IF NOT lDescriptor THEN DO: 
    /* 18-JAN-2011 jcc: do not create duplicate of font */
    IF NOT CAN-FIND(TT_Font
                    WHERE TT_Font.obj_stream = pStream
                      AND TT_Font.pdf_id     = pID
                      AND TT_Font.obj_id     = piObj
                      AND TT_Font.gen_id     = piGen
                      AND TT_Font.font_tag   = pTag  /* 03-NOV-2014 jcc: many tags might share the same object! */   
                      AND TT_Font.page_id    = pPage /* 22-OCT-2014 jcc: one font must be created per page! */
                    ) THEN DO:
        CREATE TT_Font.
        ASSIGN TT_Font.obj_stream  = pStream
               TT_Font.pdf_id      = pID
               TT_Font.obj_id      = piObj
               TT_Font.gen_id      = piGen
               TT_Font.page_id     = pPage
               TT_Font.font_name   = font_name
               TT_Font.font_base   = base-font
               TT_Font.font_tag    = pTag
               TT_Font.font_width  = cWidths
               TT_Font.used_flag   = plUsed.
    END.
  END.
  ELSE DO:
      /* 21-JAN-2011 jcc: use the new output parameter of ProcessFontDescriptorDictionary to find the font */
      FIND TT_Font WHERE ROWID(TT_Font) = rTTFont NO-ERROR.
      IF AVAILABLE TT_Font THEN
          TT_Font.font_width = cWidths.
  END.
  
END. /* ProcessFontDictionary */

PROCEDURE ProcessFontDescriptorDictionary:
    DEFINE INPUT  PARAMETER ipiDictId       AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER ipiParentDictId AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pParPage        AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pTag            AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER plUsed          AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER pFontName       AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER prTTFont        AS ROWID       NO-UNDO.

    DEFINE BUFFER TT_dict      FOR TT_dict.
    DEFINE BUFFER parTT_Object FOR TT_Object.
    DEFINE BUFFER TT_Font      FOR TT_Font.
    DEFINE BUFFER bTT_Font     FOR TT_Font.

    IF ipiDictId < 0 THEN RETURN. /* empty dictionary */

    FIND LAST parTT_Object WHERE parTT_Object.obj_dict_id = ipiParentDictId NO-ERROR.
    IF NOT AVAILABLE parTT_Object THEN DO:
        RUN CreateVirtualObject ("DICT", ipiDictId, "", BUFFER parTT_Object) NO-ERROR.
        {&adCheckErrorAndReturn}
    END.

    /* 18-JAN-2011 jcc: do not create duplicate of font */
    FIND FIRST bTT_Font
      WHERE bTT_Font.obj_stream = pStream
        AND bTT_Font.pdf_id     = pID
        AND bTT_Font.obj_id     = parTT_Object.obj_id
        AND bTT_Font.gen_id     = parTT_Object.gen_id NO-ERROR.
    IF AVAILABLE bTT_Font THEN DO:
      IF bTT_Font.font_tag <> pTag OR bTT_Font.page_id <> pParPage THEN DO:
        CREATE TT_Font.
        BUFFER-COPY bTT_Font EXCEPT font_tag page_id /*alias_flag*/ TO TT_Font
            ASSIGN
               TT_Font.page_id    = pParPage
               TT_Font.font_tag   = pTag
               TT_Font.used_flag  = plUsed.
               /* TT_Font.alias_flag = YES. */
      END.
      ELSE DO:
          FIND TT_Font WHERE ROWID(TT_Font) = ROWID(bTT_Font).
          TT_Font.used_flag = plUsed.
      END.  
    END.
    ELSE DO:
        CREATE TT_Font.
        ASSIGN TT_Font.obj_stream = pStream
               TT_Font.pdf_id     = pID
               TT_Font.obj_id     = parTT_Object.obj_id
               TT_Font.gen_id     = parTT_Object.gen_id
               TT_Font.page_id    = pParPage
               TT_Font.font_tag   = pTag.
    END.
    prTTFont = ROWID(TT_Font).

    {getDict TT_dict ipiDictId "SCALAR" "~/FontName"}.
    IF AVAILABLE TT_dict THEN DO:
        TT_Font.Font_name = SUBSTRING(TT_dict.value_scalar, 2). /* remove initial / */
        pFontName = TT_Font.Font_name.
    END.

END. /* ProcessFontDescriptorDictionary */

PROCEDURE ProcessColorSpace:
    DEFINE INPUT PARAMETER ipcType          AS CHARACTER   NO-UNDO. /* ARRAY or SCALAR */
    DEFINE INPUT PARAMETER ipiDictOrArrayId AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER pPage            AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER piObj     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piGen     AS INTEGER   NO-UNDO.

    DEFINE BUFFER TT_object  FOR TT_object.

    IF ipiDictOrArrayId < 0 THEN RETURN. /* empty dictionary or array */

    CASE ipcType:
        /* WHEN "DICT" THEN DO: */
            /* FIND LAST TT_Object WHERE TT_Object.obj_dict_id = ipiDictOrArrayId NO-ERROR. */
            /* IF NOT AVAILABLE TT_Object THEN DO: */
                /* RUN CreateVirtualObject ("DICT", ipiDictOrArrayId, "", BUFFER TT_Object) NO-ERROR. */
                /* {&adCheckErrorAndReturn} */
            /* END. */
        /* END. */
        WHEN "ARRAY" THEN DO:
            FIND LAST TT_Object WHERE TT_Object.obj_array_id = ipiDictOrArrayId NO-ERROR.
            IF NOT AVAILABLE TT_Object THEN DO:
                RUN CreateVirtualObject ("ARRAY", ipiDictOrArrayId, "", BUFFER TT_Object) NO-ERROR.
                {&adCheckErrorAndReturn}
            END.
        END.
        OTHERWISE
            RETURN ERROR "Unknown data type for ProcessColorSpace: " + QUOTER(ipcType) + CHR(3) + ABLCallStack(0).
    END CASE.

    IF AVAILABLE TT_object THEN ASSIGN
        piObj = TT_Object.obj_id
        piGen = TT_Object.gen_id
        TT_Object.obj_type = "~/ColorSpace"
        TT_Object.page_id  = pPage.

END. /* ProcessColorSpace */

PROCEDURE ProcessPageContent:
    DEFINE INPUT PARAMETER pCounter  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER ipiDictId AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pPage     AS INTEGER   NO-UNDO.

    DEFINE BUFFER TT_Object FOR TT_Object.

    FIND LAST TT_Object WHERE TT_Object.obj_dict_id = ipiDictId NO-ERROR.
    IF NOT AVAILABLE TT_Object THEN
        RETURN ERROR "Content stream not found!" + CHR(3) + ABLCallStack(0).

    IF pCounter = 1 THEN DO:
        OS-DELETE VALUE(pcTmpCacheDir + pID + STRING(pPage) + ".txt") NO-ERROR.
        RUN CreateInfo("Page",pPage).
    END.

    /* 05-NOV-2014 jcc: if the object is already used, duplicate it */
    IF TT_Object.obj_type <> "" THEN
        RUN CreateVirtualObject (TT_Object.obj_value_type, ipiDictId, "", BUFFER TT_Object).

    ASSIGN TT_Object.obj_type = "~/Content"
           TT_Object.page_id  = pPage.

    RUN outputDictStream(ipiDictId, YES, pID + STRING(pPage) + ".txt", pCounter > 1) NO-ERROR.
    {&adCheckErrorAndReturn}

END. /* ProcessPageContent */

