#!/usr/bin/python
#
"""Usage:
   sudo python setup.py config
   sudo python setup.py install
"""
import sys
import os
import re

from distutils.core import setup
from distutils.command import config,  install
from distutils.sysconfig import get_python_lib
from distutils.util import change_root

import ConfigParser
from doc2pdf import CONFIG_FILENAME, CONFIG_SECTION, CONFIG_OPTIONS, get_default_conf


# ----------------------------------------
# Here you can configure config variables:
# ----------------------------------------

# Name of the reportlab module
MODULE_REPORTLAB = 'reportlab'

# Names of the TRML modules
MODULES_TINYRML = ('trml2pdf', 'rml2pdf')
TINYERP_PATH = 'tinyerp-server/report/render'

# Folder where setup looks for font
FONT_ROOT = '/usr/share/fonts'

# Folder names where process looking for fonts
PREFERRED_FONT_FOLDERS = ('freefont', 'truetype')

# Font names which process looking for
PREFERRED_FONT_NAMES = ('FreeSans', 'FreeSerif', 'FreeMono', 
        'DejaVuSans', 'DejaVuSerif',
        'Helvetica', 'Arial', 'Times', 'Times-Roman', 'Times-New-Roman')

# ----------------------------------------

MAIN_SCRIPT_NAME = 'fred-doc2pdf'
OK = 1 # define true

    
def try_import(modulename):
    'Check is exists module name'
    status = 1
    try:
        exec('import %s'%modulename)
    except ImportError,  msg:
        sys.stderr.write('ImportError: %s\n'%msg)
        status = 0
    else:
        sys.stdout.write('Module %s was found.\n'%modulename)
    return status


def check_reportlab():
    'Check is exists reportlab module'
    status = try_import(MODULE_REPORTLAB)
    if not status:
        sys.stderr.write('Try install: apt-get install python-reportlab\n')
        return status, MODULE_REPORTLAB
        
    exec('import %s'%MODULE_REPORTLAB)
    try:
        version = eval('%s.Version'%MODULE_REPORTLAB)
        fversion = float(version)
    except AttributeError, msg:
        sys.stderr.write('AttributeError: %s\n'%msg)
    except ValueError, msg:
        sys.stderr.write('ValueError: %s\n'%msg)
    else:
        if fversion < 2.0:
            sys.stderr.write('Error: Module %s version %s is lower than minimum 2.0.\n'%(MODULE_REPORTLAB, version))
            status = 0
        else:
            sys.stdout.write('Checked %s version: %s\n'%(MODULE_REPORTLAB, version))
    return status, MODULE_REPORTLAB


def check_trml2pdf():
    'Check Tiny RML templating module'
    
    # find in standrard module path
    for modulename in MODULES_TINYRML:
        status = try_import(modulename)
        if status:
            return status, modulename, ''
    
    path = os.path.join(get_python_lib(), TINYERP_PATH)
    sys.stdout.write('Insert path: %s\n'%path)
    sys.path.insert(0, path)

    # try again with explicit path
    for modulename in MODULES_TINYRML:
        status = try_import(modulename)
        if status:
            return status, modulename, path
    
    sys.stderr.write('Try install: apt-get install tinyerp-server\n')
    return 0, '', ''
    

def get_popen_result(command):
    'Returns result from shell command find'
    status = 1
    data = ''
    try:
        pipes = os.popen3(command)
    except IOError, msg:
        sys.stderr.write('IOError: %s\n'%msg)
        status = 0
    else:
        data = pipes[1].read()
        errors = pipes[2].read()
        map(lambda f: f.close(), pipes)
        if errors:
            sys.stderr.write('PipeError: %s\n'%errors)
            status = 0
    return status, data
    

def find_font_folders():
    'Returs list of folders'

    sys.stdout.write("Looking for folders '%s'...\n"%"', '".join(PREFERRED_FONT_FOLDERS))
    cmd = 'find %s -type d%s'%(FONT_ROOT, ' -or'.join(map(lambda s: ' -iname %s'%s, PREFERRED_FONT_FOLDERS)))
    # sys.stdout.write('$ %s\n'%cmd) info about shell command
    status, data = get_popen_result(cmd)
    data = data.strip()

    # list of path with font folders:
    font_folders = re.split('\s+', data)
    print 'Found %d folder(s).'%len(font_folders)
    return status, font_folders

def join_font_types(plain, fontnames):
    """Chceck if name has all types: plain, obligue, bold, bold-obligue.
    If is it true, returns string with this names.
    """
    font_familly = ''
    font_name, ext = plain.split('.')
    
    obligue, bold, bold_obligue = ['']*3
    
    for name in fontnames:
        if re.match('%s-?(Oblique|Italics?).ttf'%font_name, name, re.I):
            obligue = name
        if re.match('%s-?Bold.ttf'%font_name, name,  re.I):
            bold = name
        if re.match('%s-?Bold-?(Oblique|Italics?).ttf'%font_name, name, re.I):
            bold_obligue = name
    
    if obligue and bold and bold_obligue:
        font_familly = ' '.join((plain,  obligue,  bold,  bold_obligue))
        sys.stdout.write("Found font familly '%s'\n"%plain)
    
    return font_familly

def find_font_familly(font_folders):
    'Returns status,  path to the font,  font familly names (4 names)'
    status = 0
    font_folder_name, font_familly = '', ''
    font_filenames = map(lambda s: '%s.ttf'%s, PREFERRED_FONT_NAMES)
    
    for folder_name in font_folders:
        command = "find %s -name '*.ttf'"%folder_name
        stat, data = get_popen_result(command)
        if not stat:
            continue
        
        # keep paths and names of fonts separately:
        font_paths = []
        font_names = []
        for p in re.split('\s+', data.strip()):
            font_paths.append(os.path.dirname(p))
            font_names.append(os.path.basename(p))
        
        print "Found %d fonts in folder '%s'."%(len(font_names), folder_name)
        # find font familly
        # looking for fonty types (4 types = one familly)
        for font_type in font_filenames:
            if font_type in font_names:
                font_familly = join_font_types(font_type, font_names)
                if font_familly:
                    status = 1
                    font_folder_name = font_paths[font_names.index(font_type)]
                    break
    if not status:
        sys.stderr.write('Error: Suitable font was not found.\n')
        sys.stderr.write('Try install: sudo apt-get intall ttf-freefont\n')
    return status, font_folder_name, font_familly


def find_font_path_and_familly():
    'Find truetype fonts'
    status, font_path, font_names = 0, '', ''
    font_names = []
    status, font_folders = find_font_folders()
    if status and len(font_folders):
        status, font_path, font_names = find_font_familly(font_folders)
    else:
        status = 0
    return status, font_path, font_names
    

def save_config(conf):
    'Save data into config'
    
    config = ConfigParser.SafeConfigParser()
    config.add_section(CONFIG_SECTION)
    for option, value in conf.items():
        config.set(CONFIG_SECTION, option, value)
    
    try:
        fp = open(CONFIG_FILENAME, 'w')
        config.write(fp)
        fp.close()
        sys.stdout.write("Configuration file '%s' created OK.\n"%CONFIG_FILENAME)
    except IOError, msg:
        sys.stderr.write('IOError: %s\n'%msg)
        return None

    return OK
    

def is_exists():
    'Check if configuration file exists'
    return os.path.isfile(CONFIG_FILENAME)

def is_writable():
    'Chcek rights - if file is writable'
    status = 1
    try:
        # create folders
        parts = CONFIG_FILENAME.split('/')[:-1]
        for n in range(len(parts)):
            path = '/'.join(parts[:n+1])
            if not path: continue
            if not os.path.isdir(path):
                os.mkdir(path)
        
        # try write to file
        f = open(CONFIG_FILENAME, 'w')
        
    except IOError, msg:
        sys.stdout.write('IOError (is writable): %s\n'%msg)
        status = 0
    else:
        f.close()
        os.unlink(CONFIG_FILENAME)
    return status

    
def make_config():
    'Test checking configuration'
    
    if not is_writable():
        return 0
    
    status = 1
    
    conf = get_default_conf() # from doc2pdf

    stat, reportlab_name = check_reportlab()
    if not stat:
        status = 0
    
    stat, trml_name, path = check_trml2pdf()
    if stat:
        conf['trml_module_name'] = trml_name
        if path:
            conf['module_path'] = path # particular path
    else:
        status = 0
    
    stat, font_path, font_familly = find_font_path_and_familly()
    if stat:
        conf['true_type_path'] = font_path
        conf['default_font_ttf'] = font_familly
    else:
        status = 0

    if status:
        status = save_config(conf)
    else:
        sys.stdout.write('Configuration file was not created.\nClear out problems and try again.\n')
    return status

def main_config(inst):
    'Main function for make configuration'
    global CONFIG_FILENAME
    
    if 'bdist' in sys.argv[1:]:
        return 1 # not run script in bdist mode
    
    if inst.root:
        # change path to configuration file path
        CONFIG_FILENAME = change_root(inst.root, CONFIG_FILENAME)
        sys.stdout.write("Configuration filepath has been modified to '%s'.\n"%CONFIG_FILENAME)
# temporary disabled because it set path during bdist_rpm to /var/tmp/
# so rpm installed doc2pdf has invalid config file path
#        inst.fred2pdf_changed_path = 1
    
    if is_exists():
        sys.stdout.write('Configuration file already exists.\n')
        status = 1
    else:
        status = make_config()
    return status


class Config(config.config):
    """This is config class, which checks for fred2pdf 
    specific prerequisities.
    """
    description = "Check prerequisities of fred2pdf"

    def run(self):
        if main_config(self):
            config.config.run(self)

class FredInstall(install.install):
    """This is config class, which checks for fred2pdf 
    specific prerequisities.
    """
    description = "Install fred2pdf witch create config"

    def run(self):
        if main_config(self):
            install.install.run(self)
        if getattr(self, 'fred2pdf_changed_path', None):
            # write changed CONFIG_FILENAME of the path to main script
            path = os.path.join(self.install_scripts, MAIN_SCRIPT_NAME)
            body = open(path).read()
            body = re.sub("CONFIG_FILENAME\s*=\s*['\"][^'\"]+['\"]", "CONFIG_FILENAME = '%s'"%CONFIG_FILENAME, body, 1)
            open(path, 'w').write(body)
            sys.stdout.write("Variable CONFIG_FILENAME changed in source file '%s'.\n"%path)

templatesContent = os.listdir(
  os.path.join(os.path.dirname(sys.argv[0]),"templates")
)
FILES1 = " ".join(
  [filename for filename in templatesContent 
    if os.path.isfile(os.path.join("templates",filename))])

examplesContent = os.listdir(
  os.path.join(os.path.dirname(sys.argv[0]),"examples")
)
FILES2 = " ".join(
  [filename for filename in examplesContent 
    if os.path.isfile(os.path.join("examples",filename))])

setup(name = 'fred-doc2pdf',
    description = 'PDF creator module',
    author = 'Zdenek Bohm, CZ.NIC',
    author_email = 'zdenek.bohm@nic.cz',
    url = 'http://enum.nic.cz/',
    version = '1.2.1',
    license = 'GNU GPL',
    cmdclass = { 'config': Config, 'install': FredInstall }, 

    scripts = (MAIN_SCRIPT_NAME, "fred-doc2pdf" ),
    
    data_files=[
        ('/etc/fred/',[]),
        ('share/fred-doc2pdf/templates', map(lambda s:'templates/%s'%s, re.split('\s*', FILES1))
        ), 
        ('share/fred-doc2pdf/examples', map(lambda s:'examples/%s'%s, re.split('\s*', FILES2)), 
        )
        ]


    )
    
