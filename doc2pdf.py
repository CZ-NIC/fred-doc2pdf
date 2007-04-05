#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
This module is running on the Tiny RML2PDF system (http://openreport.org/) 
and  The ReportLab Open Source PDF library (the ReportLab Toolkit) 
http://www.reportlab.org/.

It was written due to these system don't work with UTF8 encoding.

For this purpose module works with TrueType fonts. It set path
and load default font. This names are must be saved into configuration.py
module.

Templates must declare used font names and this names must be accessible
on the defined path.

Here is example how to declare font familly in RML template:

<docinit>
  <registerDefaultFont 
    fontName="Times-Roman" fontFile="Times_New_Roman.ttf" 
    fontNameBold="Times-Bold" fontFileBold="Times_New_Roman_Bold.ttf" 
    fontNameItalic="Times-Italic" fontFileItalic="Times_New_Roman_Italic.ttf" 
    fontNameBoldItalic="Times-BoldItalic" fontFileBoldItalic="Times_New_Roman_Bold_Italic.ttf" 
    />
  <registerFont 
    fontName="Arial" fontFile="Arial.ttf" 
    fontNameBold="Arial-Bold" fontFileBold="Arial_Bold.ttf" 
    fontNameItalic="Arial-Italic" fontFileItalic="Arial_Italic.ttf" 
    fontNameBoldItalic="Arial-BoldItalic" fontFileBoldItalic="Arial_Bold_Italic.ttf" 
    />
</docinit>
"""
import sys
import StringIO

try:
    import configuration
except ImportError, msg:
    sys.stderr.write("""ImportError: %s
First you need create configuration.py. For that purpose you can use configuration.py.default file.
$ cp configuration.py.default configuration.py
"""%msg)
    sys.exit(-1)

module_path  = getattr(configuration, 'module_path', None)
if module_path:
    sys.path.insert(0, module_path)

# Import trml2pdf with posibility to definition of the module name.
try:
    exec 'from %s import trml2pdf, utils'%getattr(configuration, 'trml_module_name', 'trml2pdf')
except ImportError, msg:
    sys.stderr.write('ImportError: %s\nYou need correct variables trml_module_name and module_path in your configuration.py file:\n'%msg)
    sys.exit(-1)

# Need for register TrueType fonts
import reportlab
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas

# ================================================
#
# First KEEP original code:
# It must precedent functions, because they use it
#
# ================================================

# resolve problems with &
original_paragraph_setup = reportlab.platypus.paragraph.Paragraph._setup

# Fonts
original_rml_doc_render = trml2pdf._rml_doc.render

# Page numbers
original_BaseDocTemplate_endBuild = reportlab.platypus.BaseDocTemplate._endBuild
original_PDFPage_check_format = reportlab.pdfbase.pdfdoc.PDFPage.check_format

# ================================================

def attr_get(node, attrs, dict={}):
    """Overwrite function attr_get() in module utils. We need encode unicodes.
    This HOOK fix problem with unicode.
    """
    res = {}
    for name in attrs:
        if node.hasAttribute(name):
            res[name] = utils.unit_get(node.getAttribute(name))
    for key in dict:
        if node.hasAttribute(key):
            if dict[key]=='str':
                    # res[key] = str(node.getAttribute(key))
                    # we need encode unicode to local encoding:
                    value = node.getAttribute(key)
                    if type(value) is unicode: value = value.encode(trml2pdf.encoding)
                    res[key] = str(value)
            elif dict[key]=='bool':
                res[key] = utils.bool_get(node.getAttribute(key))
            elif dict[key]=='int':
                res[key] = int(node.getAttribute(key))
    return res

def fred_paragraph_setup(self, text, style, bulletText, frags, cleaner):
    """Hook original function for resolve problem with occurence character & 
    during parsing XML code.
    """
    original_paragraph_setup(self, text.replace('&','&amp;'), style, bulletText, frags, cleaner)

"""
Set of functions for register TrueType fonts.
"""

def register_TTF_font_familly(names):
    """Register TrueType font. Names is list of tuples (PostSriptName, FileName.ttf)
    The list must be valid - normal (first) item must be set. Other types
    are obligatory.
    names = ((name, file), ...) four items in order: '','Bold','Italic','BoldItalic'
    """
    if len(names) != 4:
        raise 'Internal Error in register_TTF_font_familly(): The list MUST have 4 items: %s'%str(names)
    for n in range(4):
        name, file = names[n]
        if name: reportlab.pdfbase.pdfmetrics.registerFont(TTFont(name, file))
    types = ((0,0), (0,1), (1,0), (1,1))
    normal = names[0][0]
    for n in range(4):
        name, file = names[n]
        b,i = types[n]
        if name: reportlab.lib.fonts.addMapping(normal, b, i, name)

def docinit_TTF_elements(element_name, elements):
    "Register TTF font family. element_name = 'registerFont'"
    is_element_found = 0
    suffix = ('','Bold','Italic','BoldItalic')
    for node in elements:
        for font in node.getElementsByTagName(element_name):
            is_element_found = 1
            # normal, italic, bold, bold-italic
            names = [('',''),('',''),('',''),('','')]
            for n in range(4):
                names[n] = (font.getAttribute('fontName%s'%suffix[n]).encode('ascii'),
                            font.getAttribute('fontFile%s'%suffix[n]).encode('ascii'))
                name, file = names[n]
                if n==0:
                    if name == '': raise 'Element docinit.%s attribute main fontName missing.'%element_name
                    if file == '': raise 'Element docinit.%s attribute main fontFile missing.'%element_name
                if (name and not file) or (file and not name):
                    raise "Element docinit.registerFont missing one of attributes: fontName%s='%s' fontFile%s='%s'"%(suffix[n], name, suffix[n], file)
            register_TTF_font_familly(names)
    return is_element_found

def docinit_TTF(els):
    'Register TTF font family.'
    if not docinit_TTF_elements('registerDefaultFont', els):
      # if template has not defined default font name
      # we use default names from this module
      register_TTF_font_familly(configuration.DEFAULT_STYLE_FONT)
    docinit_TTF_elements('registerFont', els)

"""
*** HOOK OF THE REGISTER FONTS ***
If your documents works with unicode, you need use TrueType fonts.
Here is hook for register TTF indo document.
"""

def fred_render(self, out):
    el = self.dom.documentElement.getElementsByTagName('docinit')
    if el:
        docinit_TTF(el)
    else:
        register_TTF_font_familly(configuration.DEFAULT_STYLE_FONT)
    original_rml_doc_render(self, out)

def fred_docinit(self, els):
    'Disable original function for register fonts.'
    pass


"""
*** HOOK OF THE TOTAL PAGE NUMBER ***

This code HOOKS modules reportlab and trml2pdf.
These modules in actual versions have not implemented count value of the total page number.
So we need make some hooks until original modules will not updated.

reportlab$ svn info
Path: .
URL: http://www.reportlab.co.uk/svn/public/reportlab/trunk/reportlab
Repository Root: http://www.reportlab.co.uk/svn/public
Repository UUID: 636e621b-80dc-0310-9e7d-ef5f34d1b73f
Revision: 3004
Node Kind: directory
Schedule: normal
Last Changed Author: rgbecker
Last Changed Rev: 3004
Last Changed Date: 2006-12-19 15:50:51 +0100 (\u00dat, 19 pro 2006)

"""

# Global variable keep number of the total page:
num_total_page = 0
# Definition of the MARK what represent place where will be put total page number.
# Decimal   Octal   Hex    Value
# 028          034      01C    FS    (File Separator)
FS = 28
mark_count_page_number = chr(FS)
mark_count_page_number_octal = r'\0%o'%FS


def fred_textual(self, node):
    """Add tag of the Total page number.
    This hook implements new tag pageNumberTotal.
    """
    rc = ''
    for n in node.childNodes:
        if n.nodeType == n.ELEMENT_NODE:
            if n.localName=='pageNumber':
                rc += str(self.canvas.getPageNumber())
            # HOOK: this two lines add new tag for input total page number
            # Warning: If the text in printed as center ro right alignment, it has no effect
            # and number will be align on the same position as an internal mark.
            # TODO: Find better way of the implementation (or wait for next release?)
            elif n.localName=='pageNumberTotal':
                rc += mark_count_page_number
        elif (n.nodeType == node.CDATA_SECTION_NODE):
            rc += n.data
        elif (n.nodeType == node.TEXT_NODE):
            rc += n.data
    return rc.encode(trml2pdf.encoding)


def save_num_total_pages(self):
    """Save number of the total pages.
    This hook saves the number of pages for use later in the creating document process.
    """
    global num_total_page
    num_total_page = self.page
    original_BaseDocTemplate_endBuild(self)


def load_num_total_pages(self, document):
    """Load number of the total pages.
    Befor output data repalce all occurences of the TotalPage mark by real number.
    """
    self.stream = self.stream.replace(mark_count_page_number_octal, str(num_total_page))
    original_PDFPage_check_format(self, document)


def genpdf_help():
    print """Usage: doc2pdf input.rml >output.pdf
Render the standard input (RML) and output a PDF file.
For test use:
$ doc2pdf --test input.rml
"""
    sys.exit(0)

def test(data):
    'For test only. This is good for hide PDF binary source.'
    r = trml2pdf._rml_doc(data)
    fp = StringIO.StringIO()
    r.render(fp)
    return '*** END ***' # fp.getvalue()

# =============================================
#
#   HOOKS - overwrite previous code
#
# =============================================


# ---------------------------------------------
# fix unicode incompatibilities
# ---------------------------------------------

# Default encoding (used for TrueType). Don't touch.
trml2pdf.encoding = 'UTF-8'

# fix problem with unicode
utils.attr_get = attr_get

#Hook original function for resolve problem with occurence character & 
#during parsing XML code.
reportlab.platypus.paragraph.Paragraph._setup = fred_paragraph_setup

# ---------------------------------------------
# Set of functions for register TrueType fonts.
# ---------------------------------------------
# Init paths of the TrueType fonts
reportlab.rl_config.TTFSearchPath = configuration.TrueTypePath

trml2pdf._rml_doc.render = fred_render
trml2pdf._rml_doc.docinit = fred_docinit

# ---------------------------------------------
# Manage Page numbers
# ---------------------------------------------

#Add tag of the Total page number.
#This hook implements new tag pageNumberTotal.
trml2pdf._rml_canvas._textual = fred_textual

#Save number of the total pages.
#This hook saves the number of pages for use later in the creating document process.
reportlab.platypus.BaseDocTemplate._endBuild = save_num_total_pages

#Load number of the total pages.
#Befor output data repalce all occurences of the TotalPage mark by real number.
reportlab.pdfbase.pdfdoc.PDFPage.check_format = load_num_total_pages

# =============================================
    
if __name__=="__main__":
  if sys.stdin.isatty():
    if len(sys.argv)>1:
        if sys.argv[1]=='--help':
            genpdf_help()
        elif sys.argv[1]=='--test':
            if len(sys.argv)>2:
                print test(file(sys.argv[2], 'r').read())
            else:
                print 'Missing test file. Usage: doc2pdf --test input.rml' 
        else:
            print trml2pdf.parseString(file(sys.argv[1], 'r').read())
    else:
        print 'Usage: doc2pdf input.rml > output.pdf'
        print 'Try \'doc2pdf --help\' for more information.'
  else:
    # module in pipe:
    print trml2pdf.parseString(sys.stdin.read())

