#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Usage: doc2pdf [OPTION...] filename.rml

Render the standard input (RML) and output a PDF file.

 Options:
  -? --help               this help
  -f --config=FILENAME    use configuration file
  -o --output=FILENAME    output into file (default is stdout)
                          special value 'no' for profiling

Examples: 
  doc2pdf input.rml > output.pdf
  doc2pdf -o output.pdf input.rml
  xsltproc template.xsl data.xml | doc2pdf > output.pdf
  xsltproc template.xsl data.xml | doc2pdf -o output.pdf
"""

#    This module is running on the Tiny RML2PDF system (http://openreport.org/) 
#    and  The ReportLab Open Source PDF library (the ReportLab Toolkit) 
#    http://www.reportlab.org/.
#    
#    It was written due to these system don't work with UTF8 encoding.
#    
#    For this purpose module works with TrueType fonts. It set path
#    and load default font. This names are must be saved into configuration.py
#    module.
#    
#    Templates must declare used font names and this names must be accessible
#    on the defined path.
#    
#    Here is example how to declare font familly in RML template:
#    
#    <docinit>
#      <registerDefaultFont 
#        fontName="Times-Roman" fontFile="Times_New_Roman.ttf" 
#        fontNameBold="Times-Bold" fontFileBold="Times_New_Roman_Bold.ttf" 
#        fontNameItalic="Times-Italic" fontFileItalic="Times_New_Roman_Italic.ttf" 
#        fontNameBoldItalic="Times-BoldItalic" fontFileBoldItalic="Times_New_Roman_Bold_Italic.ttf" 
#        />
#      <registerFont 
#        fontName="Arial" fontFile="Arial.ttf" 
#        fontNameBold="Arial-Bold" fontFileBold="Arial_Bold.ttf" 
#        fontNameItalic="Arial-Italic" fontFileItalic="Arial_Italic.ttf" 
#        fontNameBoldItalic="Arial-BoldItalic" fontFileBoldItalic="Arial_Bold_Italic.ttf" 
#        />
#    </docinit>
#
#    python -m profile fred-doc2pdf -o no test_invoice.rml > profile.log

import os, sys
import StringIO
import re
import ConfigParser
import getopt

from reportlab import platypus

# (Path and) Name of the configuration file
CONFIG_FILENAME = '/etc/fred/fred-doc2pdf.conf'
CONFIG_SECTION = 'main'
CONFIG_OPTIONS = ('trml_module_name', 'true_type_path', 'default_font_ttf', 'module_path')

# This font names are used in default (implicit) style.
# Names are separated from file-TTF-names for better names redefine.
# (This names can be overwrite by template definition.)
DEFAULT_FONT_FAMILLY = (
    'Times-Roman',
    'Times-Italic',
    'Times-Bold',
    'Times-BoldItalic',
)

def get_default_conf():
    conf = {}
    for name in CONFIG_OPTIONS:
        conf[name] = ''
    # default configuration pathfilename
    conf['config'] = CONFIG_FILENAME
    return conf

# variables form configuration file
CONFIG = get_default_conf()
HOOKS = {}

# []
# _calc_height( 639.968503937 481.228346457 None None )
cache_tables = {}
cache_cells = {}

def fnc(*argvs):
    'Function in case if required function mising.'
    sys.stderr.write("Error: Missing function.\n")
    sys.stderr.write("argvs: %s.\n"%str(argvs))



def get_config_from_option(argv):
    params = {}
    args = []
    try:
        opt, args = getopt.getopt(argv[1:], 'f:hto:', ['config=', 'help', 'test=', 'output='])
        status = 1
    except getopt.GetoptError, msg:
        sys.stderr.write('Option Error:%s\n'%msg)
        status = 0
    else:
        for k, v in opt:
            params[k] = v
        
    return status, params, args


def __load_configuration__():
    'Load configuration data'
    global CONFIG

    if not os.path.isfile(CONFIG['config']):
        sys.stderr.write("Error: Missing configuration file: '%s'.\n"%CONFIG['config'])
        return None
        
    config = ConfigParser.SafeConfigParser()
    
    # load config
    try:
        config.read(CONFIG['config'])
    except (ConfigParser.MissingSectionHeaderError, ConfigParser.ParsingError), msg:
        sys.stderr.write('ConfigError: %s\n'%msg)
        return None
        
    # load values
    for option in CONFIG_OPTIONS:
        try:
            CONFIG[option] = config.get(CONFIG_SECTION, option)
        except (ConfigParser.NoSectionError, ConfigParser.NoOptionError, ConfigParser.InterpolationMissingOptionError), msg:
            sys.stderr.write('ConfigError.get: %s\n'%msg)
            return None
    
    # build environments
    is_error = 0
    CONFIG['TrueTypePath'] = re.split('\s+', CONFIG.get('true_type_path'))
    if not len(CONFIG['TrueTypePath'][0]):
        sys.stderr.write('Error: Variable TrueTypePath is empty.\n')
        return None
        
    CONFIG['DEFAULT_FONT_TTF'] = re.split('\s+', CONFIG.get('default_font_ttf'))
    if len(CONFIG['DEFAULT_FONT_TTF']) == 4:
        CONFIG['DEFAULT_STYLE_FONT'] = zip(DEFAULT_FONT_FAMILLY, CONFIG['DEFAULT_FONT_TTF'])
    else:
        sys.stderr.write('Error: Variable DEFAULT_FONT_TTF must have four items.\n')
        return None
        
    return 1
    

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
    HOOKS.get('original_paragraph_setup', fnc)(self, text.replace('&','&amp;'), style, bulletText, frags, cleaner)

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
      register_TTF_font_familly(CONFIG['DEFAULT_STYLE_FONT'])
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
        register_TTF_font_familly(CONFIG['DEFAULT_STYLE_FONT'])
    HOOKS.get('original_rml_doc_render', fnc)(self, out)

def fred_docinit(self, els):
    'Disable original function for register fonts.'
    pass

"""
*** Use cache for very long tables ***
"""    
class FredTable(platypus.Table):
    'Optimized for very long tables'
    
    def __init__(self, data, colWidths=None, rowHeights=None, style=None,
                repeatRows=0, repeatCols=0, splitByRow=1, emptyTableAction=None, ident=None,
                hAlign=None,vAlign=None):
        
        global cache_cells
        
        self.ident = ident
        self.hAlign = hAlign or 'CENTER'
        self.vAlign = vAlign or 'MIDDLE'
        if type(data) not in platypus.tables._SeqTypes:
            raise ValueError, "%s invalid data type" % self.identity()
        self._nrows = nrows = len(data)
        self._cellvalues = []
        _seqCW = type(colWidths) in platypus.tables._SeqTypes
        _seqRH = type(rowHeights) in platypus.tables._SeqTypes
        if nrows:
            self._ncols = ncols = max(map(platypus.tables._rowLen,data))
        elif colWidths and _seqCW: 
            ncols = len(colWidths)
        else:
            ncols = 0
        if not emptyTableAction: emptyTableAction = platypus.tables.rl_config.emptyTableAction
        if not (nrows and ncols):
            if emptyTableAction=='error':
                raise ValueError, "%s must have at least a row and column" % self.identity()
            elif emptyTableAction=='indicate':
                self.__class__ = Preformatted
                global _emptyTableStyle
                if '_emptyTableStyle' not in globals().keys():
                    _emptyTableStyle = ParagraphStyle('_emptyTableStyle')
                    _emptyTableStyle.textColor = colors.red
                    _emptyTableStyle.backColor = colors.yellow
                Preformatted.__init__(self,'%s(%d,%d)' % (self.__class__.__name__,nrows,ncols), _emptyTableStyle)
            elif emptyTableAction=='ignore':
                self.__class__ = Spacer
                Spacer.__init__(self,0,0)
            else:
                raise ValueError, '%s bad emptyTableAction: "%s"' % (self.identity(),emptyTableAction)
            return
    
        # we need a cleanup pass to ensure data is strings - non-unicode and non-null
        self._cellvalues = self.normalizeData(data)
        if not _seqCW: colWidths = ncols*[colWidths]
        elif len(colWidths) != ncols:
            raise ValueError, "%s data error - %d columns in data but %d in grid" % (self.identity(),ncols, len(colWidths))
        if not _seqRH: rowHeights = nrows*[rowHeights]
        elif len(rowHeights) != nrows:
            raise ValueError, "%s data error - %d rows in data but %d in grid" % (self.identity(),nrows, len(rowHeights))
        for i in range(nrows):
            if len(data[i]) != ncols:
                raise ValueError, "%s not enough data points in row %d!" % (self.identity(),i)
        self._rowHeights = self._argH = rowHeights
        self._colWidths = self._argW = colWidths

        # speed optimalization:
        self._cellStyles = None
        if cache_cells.has_key(ncols):
            if nrows <= cache_cells[ncols][0]:
                # use cached objects
                self._cellStyles = cache_cells[ncols][1]
        
        if self._cellStyles is None:
            cellrows = []
            for i in range(nrows):
                cellcols = []
                for j in range(ncols):
                    cellcols.append(platypus.tables.CellStyle(`(i,j)`))
                cellrows.append(cellcols)
            self._cellStyles = cellrows
            # save into cache:
            cache_cells[ncols] = (nrows, cellrows)
    
        self._bkgrndcmds = []
        self._linecmds = []
        self._spanCmds = []
        self.repeatRows = repeatRows
        self.repeatCols = repeatCols
        self.splitByRow = splitByRow
    
        if style:
            self.setStyle(style)


    def _calc_height(self, availHeight, availWidth, H=None, W=None):
        'replace original at reportlab.platypus.tables._calc_height'

        global cache_tables
    
        # _calc_height( 639.968503937 481.228346457 None None )
        cache_key = '%f:%f:%d' % (availHeight, availWidth, len(self._argH))
        
        if cache_tables.has_key(cache_key):
            # get parsed values from cache
            self._rowHeights, self._height, self._rowpositions = cache_tables[cache_key]
            return
        
        HOOKS.get('original_table_calc_height', fnc)(self, availHeight, availWidth, H, W)

        # keep parsed values in cache
        cache_tables[cache_key] = (self._rowHeights, self._height, self._rowpositions)


def fred_table(self, node):
    length = 0
    colwidths = None
    rowheights = None
    data = []
    childs = trml2pdf._child_get(node,'tr')
    if not childs:
        return None
    for tr in childs:
        data2 = []
        for td in trml2pdf._child_get(tr, 'td'):
            flow = []
            for n in td.childNodes:
                if n.nodeType==node.ELEMENT_NODE:
                    flow.append( self._flowable(n) )
            if not len(flow):
                flow = self._textual(td)
            data2.append( flow )
        if len(data2)>length:
            length=len(data2)
            for ab in data:
                while len(ab)<length:
                    ab.append('')
        while len(data2)<length:
            data2.append('')
        data.append( data2 )
    if node.hasAttribute('colWidths'):
        assert length == len(node.getAttribute('colWidths').split(','))
        colwidths = [utils.unit_get(f.strip()) for f in node.getAttribute('colWidths').split(',')]
    if node.hasAttribute('rowHeights'):
        rowheights = [utils.unit_get(f.strip()) for f in node.getAttribute('rowHeights').split(',')]
    # HOOK: Here is reason why this function is overwritten:
    # original code: platypus.Table -> new code: FredTable
    table = FredTable(data = data, colWidths=colwidths, rowHeights=rowheights, **(utils.attr_get(node, ['splitByRow'] ,{'repeatRows':'int','repeatCols':'int'})))
    if node.hasAttribute('style'):
        table.setStyle(self.styles.table_styles[node.getAttribute('style')])
    return table

        
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
    HOOKS.get('original_BaseDocTemplate_endBuild', fnc)(self)


def load_num_total_pages(self, document):
    """Load number of the total pages.
    Befor output data repalce all occurences of the TotalPage mark by real number.
    """
    self.stream = self.stream.replace(mark_count_page_number_octal, str(num_total_page))
    HOOKS.get('original_PDFPage_check_format', fnc)(self, document)


def parse_options(argv):
    """Parse commandline options and load configuration.
    Returns filename of the RML file or None if any problem
    occurs.
    """
    global CONFIG
    
    if len(argv) < 2:
        return None
        
    status, opt, args = get_config_from_option(argv)
    if not status:
        return None
    
    if opt.has_key('-h') or opt.has_key('--help'):
        print __doc__
        return None

    if opt.has_key('-f') or opt.has_key('--config'):
        CONFIG['config'] = opt.has_key('--config') and opt['--config'] or opt['-f']
        
    if CONFIG is None:
        return None

    filename = None

    if opt.has_key('-o') or opt.has_key('--output'):
        CONFIG['output'] = opt.has_key('-o') and opt['-o'] or opt['--output']

    if sys.stdin.isatty():
        # required filename only in atty mode
        if len(args) == 1:
            filename = args[0]
        else:
            sys.stderr.write('RML file must be set. See help.\n')
    
    return filename


def import_modules():
    'Import reportlab modules according to config settings'
    global reportlab, TTFont, canvas, utils, trml2pdf
    
    result = 1
    
    # Need for register TrueType fonts
    import reportlab
    from reportlab.pdfbase.ttfonts import TTFont
    from reportlab.pdfgen import canvas

    # Init module path
    if CONFIG.has_key('module_path'):
        sys.path.insert(0, CONFIG['module_path'])
    
    # Import trml2pdf with posibility to definition of the module name.
    try:
        exec 'from %s import trml2pdf as trml, utils as utl'%(len(CONFIG.get('trml_module_name', '')) and CONFIG['trml_module_name'] or 'trml2pdf')
    except ImportError, msg:
        sys.stderr.write('ImportError: %s\n'%msg)
        sys.stderr.write('Chceck your configuration file.\n')
        result = 0
    else:
        # register imported modules into globals
        trml2pdf = trml
        utils = utl

    return result

# =============================================
#
#   HOOKS - overwrite previous code
#
# =============================================
def init_hooks():
    'Initialisate all hooks into reportalb module.'
    global HOOKS

    # register originals
    # ================================================
    #
    # First KEEP original code:
    # It must precedent functions, because they use it
    #
    # ================================================
    
    # resolve problems with &
    HOOKS['original_paragraph_setup'] = reportlab.platypus.paragraph.Paragraph._setup
    
    # table cache
    HOOKS['original_table_calc_height'] = reportlab.platypus.tables.Table._calc_height
    
    # Fonts
    HOOKS['original_rml_doc_render'] = trml2pdf._rml_doc.render
    
    # Page numbers
    HOOKS['original_BaseDocTemplate_endBuild'] = reportlab.platypus.BaseDocTemplate._endBuild
    HOOKS['original_PDFPage_check_format'] = reportlab.pdfbase.pdfdoc.PDFPage.check_format
    
    # ================================================
    # Second hooks originals:
        
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
    
    #Hook table cache for speed optimalisation
    trml2pdf._rml_flowable._table = fred_table
    
    # ---------------------------------------------
    # Set of functions for register TrueType fonts.
    # ---------------------------------------------
    # Init paths of the TrueType fonts
    reportlab.rl_config.TTFSearchPath = CONFIG.get('TrueTypePath', '')
    
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
    # Optimalisation for count long tables
    reportlab.rl_config.longTableOptimize = 1
    

def run(body):
    'Run PDF process'
    if __load_configuration__() and import_modules():
        init_hooks()
        if CONFIG.has_key('output'):
            if CONFIG['output'] == 'no':
                trml2pdf.parseString(body) # no any pdf output
                return
            try:
                fp = open(CONFIG['output'], 'w')
            except IOError, msg:
                sys.stderr.write('IOError: %s.\n'%msg)
            else:
                fp.write(trml2pdf.parseString(body))
                fp.close()
        else:
            print trml2pdf.parseString(body)

def main(argv):
    'Main module function'
    # argv=['./doc2pdf.py', 'invoice.rml']
    if sys.stdin.isatty():
        # run as single command
        filename = parse_options(argv)
        if filename is None:
            return
        try:
            body = file(filename).read()
        except IOError, msg:
            sys.stderr.write('IOError: %s.\n'%msg)
        else:
            run(body)
    else:
        # run in pipe
        parse_options(argv)
        run(sys.stdin.read())
    



    
if __name__=="__main__":
    main(sys.argv)

