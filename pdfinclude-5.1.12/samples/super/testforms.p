{ samples/support/config.i }
    
{pdf_inc.i "THIS-PROCEDURE" }

RUN pdf_new("Spdf",cPdfIncludePath + "samples\super\testforms.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

RUN pdf_set_parameter("Spdf","UseExternalPageSize","TRUE").
/* RUN pdf_set_parameter("Spdf", "compress", "TRUE"). */
/* RUN pdf_set_parameter("Spdf","drawFormFieldRect","1,0,0"). */

/* 25-MAY-2013 jcc: formFlattenWithDefaultValues is a can-do list of widget names
                    for which to retain the default value when flattening the form */
/* RUN pdf_set_parameter("Spdf","formFlattenWithDefaultValues",""). /* Default value: won't use the default values' */ */
/* RUN pdf_set_parameter("Spdf","formFlattenWithDefaultValues","*"). /* Use default values for every widget */ */
RUN pdf_set_parameter("Spdf","formFlattenWithDefaultValues","!List*,*").
/* RUN pdf_set_parameter("Spdf","formFlattenWithDefaultValues","TextField*,Combo*,DropDown*"). */

RUN pdf_open_pdf("Spdf",cPdfIncludePath + "samples\support\testforms.pdf","Form").

/* DEFINE VARIABLE cWidgets AS CHARACTER   NO-UNDO. */
/* RUN pdf_get_widgets("Spdf", OUTPUT cWidgets).    */
/* MESSAGE cWidgets                                 */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.           */

RUN pdf_new_page("Spdf").

RUN pdf_use_pdf_page("Spdf","Form", 1).

/* 21-AUG-2012 jcc: No options are defined in pdf_fill_text, because pdfinclude
   is now able to use the field justification & multiline defined in the acroform */
RUN pdf_fill_text("Spdf","TextField_left","Left justification","").
RUN pdf_fill_text("Spdf","TextField_right","Right justification","").
RUN pdf_fill_text("Spdf","TextField_center","Center justification","").
RUN pdf_fill_text("Spdf","TextField_left_multi",FILL("Left justification multi ",8), "").
RUN pdf_fill_text("Spdf","TextField_right_multi",FILL("Right justification multi ",8), "").
RUN pdf_fill_text("Spdf","TextField_center_multi",FILL("Center justification multi ",8), "").

RUN pdf_fill_text("Spdf","TextField_left1","Left justification 1","").
RUN pdf_fill_text("Spdf","TextField_left2","Left justification 2","").
RUN pdf_fill_text("Spdf","TextField_left3","Left justification 3","").
RUN pdf_fill_text("Spdf","TextField_left4","Left justification 4","").

/* 22-AUG-2012 jcc: now we can fill checkboxes! */
RUN pdf_fill_text("Spdf","Checkbox1","YES","").
RUN pdf_fill_text("Spdf","Checkbox2","NO","").
RUN pdf_fill_text("Spdf","Checkbox3","YES","").

/* 22-AUG-2012 jcc: and radio buttons! */
RUN pdf_fill_text("Spdf","OptionButton1","1","").
RUN pdf_fill_text("Spdf","OptionButton2","NO","").
RUN pdf_fill_text("Spdf","OptionButton3","3","").

RUN pdf_fill_text("Spdf","RadioGroup1","3","").

/* 23-AUG-2012 jcc: and combo boxes! */
RUN pdf_fill_text("Spdf","ComboBox1","3","").
RUN pdf_fill_text("Spdf","ComboBox2","Free text","text").
RUN pdf_fill_text("Spdf","ComboBox3","1","").
RUN pdf_fill_text("Spdf","DropDown1","6","").

/* 23-AUG-2012 jcc: and list boxes! */
RUN pdf_fill_text("Spdf","ListBox1","3","").
RUN pdf_fill_text("Spdf","ListBox2","2,4,6,8,10,12","").
RUN pdf_fill_text("Spdf","ListBox3","11,10","").

/* 24-AUG-2012 jcc: The form might also span on more than one page... */
RUN pdf_new_page("Spdf").
RUN pdf_use_pdf_page("Spdf","Form", 2).
RUN pdf_fill_text("Spdf","TextField1_2nd_page","This appears on page 2","").
RUN pdf_fill_text("Spdf","Checkbox1_2nd_page","YES","").
/* RUN pdf_fill_text("Spdf","ListBox1_2nd_page","",""). */

RUN pdf_new_page("Spdf").
RUN pdf_use_pdf_page("Spdf","Form", 2).
RUN pdf_fill_text("Spdf","TextField1_2nd_page","This appears on page 3","").
/* RUN pdf_fill_text("Spdf","Checkbox_2nd_page","NO",""). */
RUN pdf_fill_text("Spdf","ListBox1_2nd_page","1,2,3","").

RUN pdf_new_page("Spdf").
RUN pdf_use_pdf_page("Spdf","Form", 2).
RUN pdf_fill_text("Spdf","TextField1_2nd_page","This appears on page 4","").
RUN pdf_fill_text("Spdf","Checkbox1_2nd_page","YES","").
RUN pdf_fill_text("Spdf","ListBox1_2nd_page","1,2,3,4,5,6,7,8,9,10,11,12","").

/* 24-AUG-2012 jcc: test while forcing justification */
RUN pdf_new_page("Spdf").
RUN pdf_use_pdf_page("Spdf","Form", 1).

RUN pdf_fill_text("Spdf","TextField_left","Left justification","align=right").
RUN pdf_fill_text("Spdf","TextField_right","Right justification","align=center").
RUN pdf_fill_text("Spdf","TextField_center","Center justification","align=left").
RUN pdf_fill_text("Spdf","TextField_left_multi",FILL("Left justification multi ",8), "align=right").
RUN pdf_fill_text("Spdf","TextField_right_multi",FILL("Right justification multi ",8), "align=center").
RUN pdf_fill_text("Spdf","TextField_center_multi",FILL("Center justification multi ",8), "align=left").
RUN pdf_fill_text("Spdf","TextField_left1","Left justification 1","align=right").
RUN pdf_fill_text("Spdf","TextField_left2","Left justification 2","align=center").
RUN pdf_fill_text("Spdf","TextField_left3","Left justification 3","align=left").
RUN pdf_fill_text("Spdf","TextField_left4","Left justification 4","align=right").
RUN pdf_fill_text("Spdf","Checkbox1","NO","").
RUN pdf_fill_text("Spdf","Checkbox2","YES","").
RUN pdf_fill_text("Spdf","Checkbox3","NO","").
RUN pdf_fill_text("Spdf","OptionButton2","Yes","").
RUN pdf_fill_text("Spdf","RadioGroup1","2","").
RUN pdf_fill_text("Spdf","ComboBox1","3","align=right").
RUN pdf_fill_text("Spdf","ComboBox2","Free text","text,align=left").
RUN pdf_fill_text("Spdf","ComboBox3","1","align=center").
RUN pdf_fill_text("Spdf","DropDown1","6","align=right").
RUN pdf_fill_text("Spdf","ListBox1","1,8","align=right").
RUN pdf_fill_text("Spdf","ListBox2","6,8","align=left").
RUN pdf_fill_text("Spdf","ListBox3","8,12","align=center").

RUN pdf_close ("Spdf").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
