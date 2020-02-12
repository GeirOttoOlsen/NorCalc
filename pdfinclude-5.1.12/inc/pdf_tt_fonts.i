/******************************************************************************

  Program:      pdf_tt_fonts.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2014
  
  Description:  Defines the temp-tables related to fonts and font parsing
  
  10/16/14  JC Cardot   Created

******************************************************************************/

/* The following temp-table is used to track Fonts loaded into a PDF stream */
DEFINE {1} TEMP-TABLE TT_pdf_font NO-UNDO
    FIELD obj_stream             AS CHARACTER  
    FIELD pdf_id                 AS CHARACTER
    FIELD font_name              AS CHARACTER  
    FIELD font_file              AS CHARACTER  
    FIELD font_afm               AS CHARACTER  
    FIELD font_dif               AS CHARACTER  
    FIELD font_type              AS CHARACTER   /* 16-OCT-2014 jcc: changed to TrueType, OpenType, Type1 */
    FIELD font_pitch             AS CHARACTER   /* 16-OCT-2014 jcc: added. FIXED or VARIABLE. Replaces font_type */
    FIELD font_width             AS CHARACTER  
    FIELD font_obj               AS INTEGER    
    FIELD font_encoding          AS INTEGER    
    FIELD font_descr             AS INTEGER    
    FIELD font_stream            AS INTEGER    
    FIELD font_tag               AS CHARACTER  
    FIELD font_embed             AS LOGICAL     INIT TRUE
    FIELD font_subset            AS LOGICAL     /* 24-FEB-2014 jcc: added */
    FIELD font_options           AS CHARACTER   /* 04-JUL-2014 jcc: added */
    FIELD afm_ItalicAngle        AS CHARACTER  
    FIELD afm_Ascender           AS CHARACTER  
    FIELD afm_Descender          AS CHARACTER  
    FIELD afm_FontBBox           AS CHARACTER  
    FIELD afm_FirstChar          AS CHARACTER  
    FIELD afm_LastChar           AS CHARACTER  
    FIELD afm_Widths             AS CHARACTER  
    FIELD afm_IsFixedPitch       AS CHARACTER   INIT "0"
    FIELD afm_FamilyName         AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_FontName           AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_FullName           AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_Weight             AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_Characters         AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_UnderlineThickness AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_UnderlinePosition  AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_MissingWidth       AS CHARACTER   /* 30-JAN-2014 jcc: added */
    FIELD afm_MaxWidth           AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_AvgWidth           AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_StdHW              AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_StdVW              AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_Notice             AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_Version            AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_StartCharMetrics   AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_XHeight            AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_CapHeight          AS CHARACTER   /* 17-OCT-2014 jcc: added */
    FIELD afm_flags              AS CHARACTER  
    FIELD cid2gid_file           AS CHARACTER   /* 06-FEB-2014 jcc: added */
    FIELD is_unicode             AS LOGICAL     /* 30-JAN-2014 jcc: added */
    FIELD ext_page               AS INTEGER    
    FIELD used_flag              AS LOGICAL     /* 22-FEB-2010 jcc: added */
    FIELD used_by_xobject        AS CHARACTER   /* 04-MAY-2014 jcc: added */
INDEX obj_stream AS PRIMARY
      obj_stream
      font_name
INDEX obj_stream2 /* 23-FEB-2010 jcc: added */
      obj_stream 
      font_file   /* 23-FEB-2010 jcc: Mike Smith 10/7/2007 */
      used_flag
      font_obj.   /* 23-FEB-2010 jcc: Mike Smith 10/7/2007 */

/* 24-FEB-2014 jcc: the following 4 TTs are used for subsetting fonts */
DEFINE {1} TEMP-TABLE tt_pdf_font_table NO-UNDO LABEL "Font file tables (tt_pdf_font_table)"
 FIELD table_name AS CHARACTER
 FIELD offset     AS INTEGER
 FIELD checksum   AS INTEGER
 FIELD length     AS INTEGER
 INDEX ix table_name
    .

DEFINE {1} TEMP-TABLE tt_pdf_font_encoding_table NO-UNDO LABEL "Font file encoding tables (tt_pdf_font_encoding_table)"
 FIELD platformID AS INTEGER
 FIELD encodingID AS INTEGER
 FIELD offset     AS INTEGER
 INDEX ix platformID encodingID
    .

DEFINE {1} TEMP-TABLE tt_pdf_font_index_to_loc NO-UNDO LABEL "Font file index to loc table (tt_pdf_font_index_to_loc)"
 FIELD glyph      AS INTEGER
 FIELD loc        AS INTEGER
 INDEX ix glyph
    .

DEFINE {1} TEMP-TABLE tt_pdf_font_segment NO-UNDO LABEL "Font file segent table (tt_pdf_font_segment)"
 FIELD segment       AS INTEGER /* segment id */
 FIELD startCount    AS INTEGER /* start character code */
 FIELD endCount      AS INTEGER /* end character code */
 FIELD idDelta       AS INTEGER
 FIELD idRangeOffset AS INTEGER /* offset into glyphIdArray or 0 */
 INDEX ix segment.

/* 07-FEB-2014 jcc: new TT */
DEFINE {1} TEMP-TABLE TT_pdf_font_character NO-UNDO LABEL "Fonts characters information (width, used, glyph) table (TT_pdf_font_character)"
 FIELD obj_stream AS CHARACTER
 FIELD font_name  AS CHARACTER
 FIELD char_id    AS INTEGER
 FIELD char_width AS CHARACTER
 FIELD used       AS LOGICAL
 FIELD used_as_component AS LOGICAL /* 20-OCT-2014 jcc: added */
 FIELD glyph      AS INTEGER
 FIELD char_bbox  AS CHARACTER /* 17-OCT-2014 jcc: added */
 FIELD char_name  AS CHARACTER /* 17-OCT-2014 jcc: added */
 FIELD alldone    AS LOGICAL
 INDEX ix IS UNIQUE PRIMARY obj_stream font_name char_id
 INDEX ix1 obj_stream font_name char_id used
 INDEX ix2.1 obj_stream font_name alldone used
 INDEX ix2.2 obj_stream font_name alldone used_as_component
 INDEX ix3.1 obj_stream font_name glyph used
 INDEX ix3.2 obj_stream font_name glyph used_as_component.
