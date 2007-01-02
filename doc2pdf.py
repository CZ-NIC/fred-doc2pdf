#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
This module is frontend of the Tiny RML2PDF system (http://openreport.org/) 
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

import reportlab
import trml2pdf

# Need for register TrueType fonts
from reportlab.pdfbase.ttfonts import TTFont

import configuration


# Init paths
reportlab.rl_config.TTFSearchPath = configuration.TrueTypePath

# Default encoding (used for TrueType). Don't touch.
trml2pdf.trml2pdf.encoding = 'UTF-8'


def attr_get(node, attrs, dict={}):
  """Overwrite function attr_get() in module utils. We need encode unicodes.
  """
  res = {}
  for name in attrs:
    if node.hasAttribute(name):
      res[name] = trml2pdf.utils.unit_get(node.getAttribute(name))
  for key in dict:
    if node.hasAttribute(key):
      if dict[key]=='str':
        value = node.getAttribute(key)
        if type(value) is unicode: value = value.encode('utf8')
        res[key] = str(value)
      elif dict[key]=='bool':
        res[key] = trml2pdf.utils.bool_get(node.getAttribute(key))
      elif dict[key]=='int':
        res[key] = int(node.getAttribute(key))
  return res

# Overwritting default function. We need encode unicode texts.
trml2pdf.utils.__dict__['attr_get'] = attr_get

def registerTTFFontFamilly(names):
    """Register TrueType font. Names is list of tuples (PostSriptName, FileName.ttf)
    The list must be valid - normal (first) item must be set. Other types
    are obligatory.
    names = ((name, file), ...) four items in order: '','Bold','Italic','BoldItalic'
    """
    if len(names) != 4:
        raise 'Internal Error in registerTTFFontFamilly: The list MUST have 4 items: %s'%str(names)
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
            registerTTFFontFamilly(names)
    return is_element_found


class ttf_rml_doc(trml2pdf.trml2pdf._rml_doc):
    'Modify clas for using TrueType'
    def __init__(self, data):
        trml2pdf.trml2pdf._rml_doc.__init__(self, data)

    def docinit_TTF(self, els):
        'Register TTF font family.'
        if not docinit_TTF_elements('registerDefaultFont', els):
          # if template has not defined default font name
          # we use default names from this module
          registerTTFFontFamilly(configuration.DEFAULT_STYLE_FONT)
        docinit_TTF_elements('registerFont', els)

    def docinit(self, el):
      'Disable parent docinit()'

    def render(self, out):
      'Overwrite parent render()'
      # register TTF fonts...
      el = self.dom.documentElement.getElementsByTagName('docinit')
      if el:
        self.docinit_TTF(el)
      else:
        registerTTFFontFamilly(configuration.DEFAULT_STYLE_FONT)
      # ...and continue in previous way
      trml2pdf.trml2pdf._rml_doc.render(self, out)


def parseString(data, fout=None):
  'Create class ttf_rml_doc() and render data.'
  r = ttf_rml_doc(data) # here is reason why we need this function.
  if fout:
    fp = file(fout,'wb')
    r.render(fp)
    fp.close()
    return fout
  else:
    fp = StringIO.StringIO()
    r.render(fp)
    return fp.getvalue()


def genpdf_help():
	print 'Usage: doc2pdf input.rml >output.pdf'
	print 'Render the standard input (RML) and output a PDF file'
	sys.exit(0)

if __name__=="__main__":
  if sys.stdin.isatty():
    if len(sys.argv)>1:
        if sys.argv[1]=='--help':
            genpdf_help()
        print parseString(file(sys.argv[1], 'r').read())
    else:
        print 'Usage: doc2pdf input.rml > output.pdf'
        print 'Try \'doc2pdf --help\' for more information.'
  else:
    # module in pipe:
    print parseString(sys.stdin.read())

