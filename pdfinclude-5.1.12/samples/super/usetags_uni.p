/*******************************************************************************

    Program:        usetags.p
    
    Description:    This sample illustrates the use of inline tagging.
                        

*******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE" }

DEFINE VARIABLE sPDF  AS CHARACTER NO-UNDO INIT "sPDF".
DEFINE VARIABLE cText AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFont AS CHARACTER NO-UNDO INIT "DejavuSerif". /* Courier */

DEFINE VARIABLE iMaxY AS INTEGER NO-UNDO.

ASSIGN cText = "This is some text that illustrates <b>bolded</b>, "
             + "<i>italicized</i>, <u>underlined</u> and <b><i>a <u>combination</u> of both</i></b>"
             + " formatting options." + CHR(10)
             + "This is some underlined <u>text that <color=red>will</color> wrap, along with its underline. The underlined text might wrap on many lines still being underlined</u>. Nice uh?" + CHR(10)
             + "This is in <color=red>red</color>. <s>This is striked</s>." + CHR(10)
             + "This <u>is <b>bold</b> underlined</u>." + CHR(10)
             + "<u><color=red>Starting in red, <s>change to <color=black>black</color>"
             + " then continue in red</color> but end in default color"
             + "<color=green><i>,whoops, try <b>italicized</b></s> green</i></color></u>." + CHR(10)
             + "It is also possible to do <url=http://en.wikipedia.org/wiki/Hyperlink>hyperlinks</url>! <b>cool</b> no? <url=http://www.oehive.org/pdfinclude>Click here to access the PDFInclude web site!</url>.".

/* ASSIGN cText = "This is some text that illustrates bolded, " */
             /* + "italicized, underlined and a combination of both" */
             /* + " formatting options." + CHR(10) */
             /* + "This is some underlined text that will wrap, along with its underline. The underlined text might wrap on many lines still being underlined. Nice uh?" + CHR(10) */
             /* + "This is in red. This is striked." + CHR(10) */
             /* + "This is bold underlined." + CHR(10) */
             /* + "Starting in red, change to black" */
             /* + " then continue in red but end in default color" */
             /* + ",whoops, try italicized green." + CHR(10) */
             /* + "It is also possible to do hyperlinks! cool no? Click here to access the PDFInclude web site!.". */

/* Create stream for new PDF file */
RUN pdf_new(sPDF,cPdfIncludePath + "samples/super/usetags_uni.pdf").

RUN pdf_load_font(Spdf,cFont        + "|SUBSET", "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + ".ttf",           "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + ".ufm","").
RUN pdf_load_font(Spdf,cFont + "b"  + "|SUBSET", "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + "-Bold.ttf",      "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + "-Bold.ufm","").
RUN pdf_load_font(Spdf,cFont + "bi" + "|SUBSET", "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + "-BoldItalic.ttf","fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + "-BoldItalic.ufm","").
RUN pdf_load_font(Spdf,cFont + "i"  + "|SUBSET", "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + "-Italic.ttf",    "fonts\dejavu-fonts-ttf-2.34\ttf\" + cFont + "-Italic.ufm","").

/* RUN pdf_set_parameter(sPDF,"COMPRESS","TRUE"). */
RUN pdf_set_parameter(sPDF,"unitTest","TRUE").

/* Setup Tagging */
RUN pdf_set_parameter(sPDF,"TagColor:Black","0,0,0").
RUN pdf_set_parameter(sPDF,"TagColor:Red","255,0,0").
RUN pdf_set_parameter(sPDF,"TagColor:Green","0,200,0").
RUN pdf_set_parameter(sPDF,"TagColor:Blue","0,0,255").

RUN pdf_set_parameter(sPDF,"UseTags","TRUE").
RUN pdf_set_parameter(sPDF,"BoldFont",cFont + "b").
RUN pdf_set_parameter(sPDF,"ItalicFont",cFont + "i").
RUN pdf_set_parameter(sPDF,"BoldItalicFont",cFont + "bi").
RUN pdf_set_parameter(sPDF,"DefaultFont",cFont).
RUN pdf_set_parameter(sPDF,"DefaultColor","Black").
RUN pdf_set_parameter(sPDF,"LinkColor","144,12,144"). /* "0,0,255" (blue) by default */
 
/* Instantiate a New Page */
RUN pdf_new_page(sPDF).

RUN pdf_set_font(sPDF,cFont, 10).

/* This outputs the tagged text and formats it accordingly */
RUN pdf_wrap_text(sPDF,
                  cText,
                  5,
                  60,
                  "LEFT",
                  OUTPUT iMaxY).

/* The same, but using pdf_wrap_text_xy */
/*RUN pdf_transaction_begin(Spdf).*/
RUN pdf_wrap_text_xy_dec (
    Spdf,
    cText,
    150, 400, 300, 300,
    11.5,
    'LEFT').
/*RUN pdf_transaction_rollback(Spdf).*/

RUN pdf_set_parameter(sPDF,"UseTags","FALSE").

cText = "This is some text that has tags like <b>bold</b> and <i>italic</i>"
      + " but tagging has been turned off so they won't be interpreted.".
RUN pdf_skipn(sPDF,2).
RUN pdf_wrap_text(sPDF,
                  cText,
                  5,
                  75,
                  "LEFT",
                  OUTPUT iMaxY).

RUN pdf_set_parameter(sPDF,"UseTags","TRUE").

cText = "Then I re-enable the tags like <b>bold</b> and <i>italic</i>"
      + " but I don't have to <color=red>reset</color> the tagging configuration.".

RUN pdf_skipn(sPDF,2).

RUN pdf_wrap_text(sPDF,
                  cText,
                  5,
                  75,
                  "LEFT",
                  OUTPUT iMaxY).

/* RUN pdf_skipn(sPDF,2). */
RUN pdf_text(sPDF, "<s>This</s> is some <u>underlined text</u>").
RUN pdf_skip(sPDF).
RUN pdf_text(sPDF, "This is some text").
RUN pdf_skip(sPDF).
RUN pdf_text(sPDF, "This is some text").
RUN pdf_skip(sPDF).
RUN pdf_text(sPDF, "This is some <u>underlined text</u>").
RUN pdf_skip(sPDF).
RUN pdf_text(sPDF, "This is some <u>underlined text</u>").
RUN pdf_skip(sPDF).

RUN pdf_close(sPDF).
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* usetags.p */
