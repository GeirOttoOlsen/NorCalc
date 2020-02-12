# readme.txt
# (c) 2012 JC Cardot
#
# this is the text which will end up within readme.pdf, when processed
# by readme.p
#
# the syntax being used is a wiki-like syntax
#
# a line starting with '#' is a comment and as such will be ignored
#
# preprocessors:
# &T toggles tags on and off
# &HR draw an horizontal rule
# &IMG inserts a picture (jpg or png)
# &FF (FormFeed ;) : new page
# &EOF (End Of File) : ignore all the remaining lines in the file
#
# =title  is a first level heading (text is 'title')
# ==heading is a second level heading (text is 'heading')
#
# *This is text with bullet (level 1)
# -This is indented text
# **This is text with bullet (level 2)
# --This text is indented to level 2
#
# @cMyVar = "This is some code".
#
# the table of contents is automatically generated from the headings.
#
# html-like tags (<b></b> <i></i> <u></u> <s></s>) can be used
# within the text. External hyperlinks can be created within the text using
# the <url=http://my.url.com></url> tag.
=Summary
*<url=#Introduction>Introduction</url>
*<url=#PDFInclude Overview>PDFInclude Overview</url>
*<url=#PDFInclude API>PDFInclude API</url>

This is <b>not</b> the real PDFInclude readme! This is only a test file.

=Introduction
==PDFInclude
PDFinclude is a Progress library which allows Progress developers to output documents in Adobe PDF file format without having to use third-party tools or utilities.

PDFinclude is a stand-alone component that defines a toolset of Progress functions and procedures that aid in the output of a PDF file directly from within the Progress 4GL/ABL. PDFInclude is developed itself 100% in Progress 4GL/ABL.

PDFinclude utilizes Progress code that is compliant with versions 9, 10 and 11 of the Progress 4GL/ABL on UNIX and/or Windows platforms.
==Benefits
Some of the benefits of using PDFinclude are:

*<b>Consistency</b> : By using the PDF file format, you can present a representation of the output file in a consistent manner.  Use the same PDF file across multiple devices, platforms and/or software packages.

*<b>Easy Implementation</b> : Since PDFinclude is written in Progress 4GL/ABL the ability to implement into your existing (or new) code is easy and seamless. No external calls are required to third-party products (such as a Perl script).

*<b>Secure Report Output</b> : PDF is a secure format that cannot be easily changed therefore sensitive reports can be distributed to users without the worry of them changing reported material.

*<b>Configurable</b> : By offering a multitude of different Progress-written PDF related functions, you can easily configure and determine the outputs content, object placement and look-and-feel.

*<b>Report Viewer Supplied</b> : Since PDF is becoming an industry-standard file format, many document viewers already exist (such as Adobe's Acrobat Reader, or Foxit Reader).
-This reduces your development effort by not having to create a separate Report Viewer. Furthermore you can embed and drive the viewer from within your application by using its OCX (with Acrobat Reader).

PDFInclude web site is <url=http://pdfinclude.com>pdfinclude.com</url>.

Starting with version 4, PDFInclude no longer is free software.

<u>Note</u>: this document was created using readme.p which came with this package, and can serve as a good introduction as how to use PDFInclude.

=PDFInclude Overview
==Usage
To use PDFInclude, you have to add one include at the top of your program:

@{pdf_inc.i "THIS-PROCEDURE"}
or
@{pdf_inc.i}
or
@{pdf_inc.i "NOT SUPER"}

This include may take one parameter which can take the following values:
*<b>THIS-PROCEDURE</b>
-The PDFInclude library is loaded as a super procedure of the THIS-PROCEDURE handle.
*<b>nothing</b>
-The PDFInclude library is loaded as a super procedure of the SESSION system handle.
*<b>other</b>
-The PDFInclude library is run persistent and accessible through the h_PDCInc handle.
-In this case, all RUN statements must include "IN h_PDFInc", e.g.
-RUN pdf_new_page <b>IN h_PDFInc</b> (pdfStream).

See the <url=#Hello World>example</url> below.

==Coordinate system & units
===Default user space units
According to the PDF specification, the coordinates on a page, be it for text or graphic elements, are working bottom-up from lower left hand corner. In other words, when looking at a page, the coordinates of the lower left hand corner are (0, 0), with X extending positively to the right and Y extending positively up.

PDF does not have a defined resolution, this is to say you can zoom a pdf page still retaining fidelity. The measurements in the pages are done in so called <b>default user space units</b>, which are 1/72 inch.
&IMG readme/coordinates.png

This example of a Letter page is 612 units wide and 792 units high. An A4 sized page is approximately 595.276 units wide and 841.89 units high.

===PDFInclude Column/Row units
PDFInclude also implements, for some of the text API procedures, a Column/Row coordinate systems which mimicks the Progress Row and Column coordinate system.  And these are really only useful if you use a Fixed width font (such as Courier).
In this system, the Text starts at the top/left corner and moves across and downward. The graphical space retains the standard placement of the PDF specification.
&IMG readme/coordinates-text.png

==Fonts
While PDFInclude allows you to load any font you would like to see in your pdf document, this often results in a bigger document (the whole font file being embedded within the pdf file).

That's why you can use the 14 pdf predefined fonts, which will not add a byte to the document:
*Courier (Courier, Courier-Oblique, Courier-Bold, Courier-BoldOblique)
*Helvetica (Helvetica, Helvetica-Oblique, Helvetica-Bold, Helvetica-BoldOblique)
*Times-Roman (Times-Roman, Times-Italic, Times-Bold, Times-BoldItalic)
*Symbol
*ZapfDingbats

You can still use any True Type Font. For this you will have to create the corresponding .afm file, using the provided ttfpt1.exe program (or using any utility allowing you to do that). See the <url=#Fonts>Fonts</url> chapter below.

==PDF viewers

Any pdf viewer is suitable, as PDFInclude generates documents conforming to the standard pdf format.
Almost any machine should have Adobe Reader installed.
However <url=http://en.wikipedia.org/wiki/Category:PDF_readers>a lot of pdf viewers are available</url>. For example Foxit Reader allows you to save pdf forms along with the contents of the widgets (like fillins, checkboxes...), whereas Sumatra PDF allows you to keep a PDF open while generating it with PDFInclude (very practical for debugging).

=PDFInclude API
==Hello World
First, let's see a small example to demonstrate the basics of PDFInclude:

@{pdf_inc.i}
@/* create a new "hello.pdf" file, name the stream "Spdf" */
@RUN pdf_new("Spdf", "hello.pdf").
@/* create a new page in our pdf */
@RUN pdf_new_page("Spdf").
@/* output some text */
@RUN pdf_text("Spdf", "Hello World!").
@/* close the file (this will create "hello.pdf") */
@RUN pdf_close("Spdf").

As you would expect, these few lines of code will create a new pdf file "hello.pdf", containing the very original sentence "Hello World!".

This example contains the minimum statements required for generating a pdf document.

You will find more examples at the end of this document, and more in the <b>samples</b> and <b>utilities</b> directories of the distribution.

See <url=#Usage>the usage chapter</url> for how to use the include file.

==The "PDF Stream"

As you can see in the hello world example, almost all procedures or functions take as a first argument a string, which use is to identify the pdf stream.
This is something similar to Progress streams, and allows you to generate more than one pdf simultaneously.
The "Spdf" name above is arbitrary, you can choose any string, keeping in mind that at generation time, one string identifies one pdf file.

The stream name is defined through the first call to pdf_new.

===Compression
Compression of the PDF stream can be used in order to minimize the size of the resulting PDF file. To enable compression, you need to :
*install <url=http://www.zlib.net>zlib</url> (free software available for Windows and Unix)
*eventually tweak the location of the zlib library (through a modification of pdf_pre.i). For MS Windows, the library is named zlib1.dll whereas for Unix, the name is libz.so.1.
*in the code, just set the "Compress" parameter to TRUE:
@    RUN pdf_set_parameter ("Spdf", "Compress", "TRUE").

===Encryption
Encryption of the PDF stream can be used to:
*ensure that it is impossible to modify the pdf file
*and/or it is impossible to open the pdf file without a password,

PDFInclude supports native RC4 (40 and 128 bits) and AES (128 bits) encryption, and encryption through PLOP from from PDFlib GmbH.
AES encryption is recommended, as it is stronger, and does not depend on any external dll.

&EOF
