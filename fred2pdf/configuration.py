#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Here define path where your system holds TrueType fonts.
Define also default font name for implicit template style.
"""
import sys
import os
import re
import desktop_config

# (Path and) Name of the configuration file
CONFIG_FILENAME = '/etc/fred2pdf.conf'

# Default values. They are overwritten by values from config file.
settings = {
    # Name of the module from where import of the trml2pdf will be done.
    # apt-get install tinyerp-server
    'trml_module_name': '',  #'rml2pdf', 
    
    # Path for import module.
    # apt-get install python-reportlab
    # Warning: It must be a least version 2.0
    'module_path':      '',  # '/usr/lib/python2.4/site-packages/tinyerp-server/report/render', 
    
    # Define path where TrueType font are saved:
    # apt-get install ttf-freefont
    'true_type_path':   '',  # '/usr/share/fonts/truetype/freefont', 
    
    # Font names MUST be in this order:
    # basic style, obligue, bold, bold-obligue
    'default_font_ttf':  'FreeSans.ttf FreeSansOblique.ttf FreeSansBold.ttf FreeSansBoldOblique.ttf',
    }

DEFAULT_CONFIG_ORDER = """#
# Fred2PDF
# Created by setup.py
#
trml_module_name
module_path
true_type_path

# Font names MUST be in this order:
# basic style, obligue, bold, bold-obligue
default_font_ttf
""".split('\n')

    
# This font names are used in default (implicit) style.
# Names are separated from file-TTF-names for better names redefine.
# (This names can be overwrite by template definition.)
DEFAULT_FONT_FAMILLY = (
    'Times-Roman',
    'Times-Italic',
    'Times-Bold',
    'Times-BoldItalic',
)

def load():
    'Load configuration'
    settings['status'] = desktop_config.load(CONFIG_FILENAME,  settings)
    if settings['status']:
        
        settings['TrueTypePath'] = re.split('\s+', settings['true_type_path'])
        if not len(settings['TrueTypePath'][0]):
            sys.stderr.write('Error: Variable TrueTypePath is empty.\n')
            settings['status'] = 0
            
        settings['DEFAULT_FONT_TTF'] = re.split('\s+', settings['default_font_ttf'])
        if len(settings['DEFAULT_FONT_TTF']) == 4:
            settings['DEFAULT_STYLE_FONT'] = zip(DEFAULT_FONT_FAMILLY, settings['DEFAULT_FONT_TTF'])
        else:
            sys.stderr.write('Error: Variable DEFAULT_FONT_TTF must have four items.\n')
            settings['status'] = 0
        
    return settings

def create_config(data):
    if desktop_config.save(CONFIG_FILENAME, data,  DEFAULT_CONFIG_ORDER):
        sys.stdout.write("Configuratione file '%s' has been created.\n"%CONFIG_FILENAME)
        return 1
    return 0

def is_exists():
    'Check if configuration file exists'
    return os.path.isfile(CONFIG_FILENAME)

def is_writable():
    'Chcek rights - if file is writable'
    status = 1
    try:
        f = open(CONFIG_FILENAME, 'w')
    except IOError, msg:
        sys.stdout.write('IOError: %s\n'%msg)
        status = 0
    else:
        f.close()
        os.unlink(CONFIG_FILENAME)
    return status
