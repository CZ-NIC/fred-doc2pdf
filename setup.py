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
from distutils.command import config
from distutils.sysconfig import PREFIX

import fred2pdf.configuration

# ----------------------------------------
# Here you can configure config variables:
# ----------------------------------------

# Name of the reportlab module
MODULE_REPORTLAB = 'reportlab'

# Names of the TRML modules
MODULES_TINYRML = ('trml2pdf', 'rml2pdf')

# Folder names where process looking for fonts
PREFERRED_FONT_FOLDERS = ('freefont', 'truetype')

# Font names which process looking for
PREFERRED_FONT_NAMES = ('FreeSans', 'FreeSerif', 'FreeMono', 
        'Helvetica', 'Arial', 'Times', 'Times-Roman', 'Times-New-Roman')

# ----------------------------------------



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
    for modulename in MODULES_TINYRML:
        status = try_import(modulename)
        if status:
            return status, modulename
    sys.stderr.write('Try install: apt-get install tinyerp-server\n')
    return 0, ''
    

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
    
    for folder_name in PREFERRED_FONT_FOLDERS:
        sys.stdout.write("Looking for folder '%s'...\n"%folder_name)
        status, data = get_popen_result('find %s -type d -iname %s'%(PREFIX, folder_name))
        data = data.strip()
        if status and len(data):
            break
        else:
            sys.stdout.write("Folder '%s' was not found.\n"%folder_name)
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
    

def make_config():
    'Test checking configuration'
    if not fred2pdf.configuration.is_writable():
        return 0
    
    status = 1
    conf = fred2pdf.configuration.settings

    stat, reportlab_name = check_reportlab()
    if not stat:
        status = 0
    
    stat, trml_name = check_trml2pdf()
    if stat:
        conf['trml_module_name'] = trml_name
    else:
        status = 0
    
    stat, font_path, font_familly = find_font_path_and_familly()
    if stat:
        conf['true_type_path'] = font_path
        conf['default_font_ttf'] = font_familly
    else:
        status = 0

    if status:
        status = fred2pdf.configuration.create_config(conf)
    return status


class Config(config.config):
    """This is config class, which checks for fred2pdf 
    specific prerequisities.
    """
    description = "Check prerequisities of fred2pdf"

    def run(self):
        if fred2pdf.configuration.is_exists():
            sys.stdout.write('Configuration file already exists.\n')
        else:
            if make_config():
                sys.stdout.write('OK, now you can do: sudo python setup.py install\n')


setup(name = 'Fred2PDF',
    description = 'PDF creator module',
    author = 'Zdenek Bohm, CZ.NIC',
    author_email = 'zdenek.bohm@nic.cz',
    url = 'http://enum.nic.cz/',
    license = 'GNU GPL',
    cmdclass = { 'config': Config }, 

    packages = ('fred2pdf', ),
    scripts = ('doc2pdf.py', ),
    
    package_data={
       'fred2pdf': ['templates/*.*'], 
    },
    
    )
    
