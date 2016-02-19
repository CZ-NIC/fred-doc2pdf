#!/usr/bin/python
"""
Usage:
    python setup.py install
"""
import importlib
import os
import re
import sys
from subprocess import Popen, PIPE

from distutils.sysconfig import get_python_lib

from freddist.command.install import install
from freddist.core import setup
from freddist.util import find_data_files


PROJECT_NAME = 'fred-doc2pdf'
PACKAGE_NAME = 'fred-doc2pdf'

CONFIG_FILENAME = 'fred-doc2pdf.conf'

# ----------------------------------------
# Here you can configure config variables:
# ----------------------------------------

# Names of the TRML modules
MODULES_TINYRML = ('trml2pdf', 'rml2pdf')
# Default for Fedora 20, every other system has trml2pdf in path
TINYERP_PATH = 'TRML2PDF-1.0-py2.7.egg'

# Folder where setup looks for font
FONT_ROOT = '/usr/share/fonts'

# Folder names where process looking for fonts
PREFERRED_FONT_FOLDERS = ('freefont', 'truetype', 'freefont-ttf', "dejavu")

# Font names which process looking for
PREFERRED_FONT_NAMES = ('FreeSans', 'FreeSerif', 'FreeMono', 
        'DejaVuSans', 'DejaVuSerif',
        'Helvetica', 'Arial', 'Times', 'Times-Roman', 'Times-New-Roman')

# ----------------------------------------
def get_popen_result(command):
    """
    Returns result from shell command
    """
    popen = Popen(command, stdout=PIPE, stderr=PIPE)
    output, error = popen.communicate()
    if popen.returncode:
        sys.stderr.write("Command '%s' returned exit code '%d'\n" % command, popen.returncode)
        exit(1)
    if error:
        sys.stderr.write("Command '%s' returned error '%s'\n" % command, error)
        exit(1)
    return output


def find_font_folders():
    """Returns list of folders"""
    sys.stdout.write("Looking for folders '%s'...\n" % "', '".join(PREFERRED_FONT_FOLDERS))
    cmd = ['find', FONT_ROOT, '-type', 'd', '-iname', PREFERRED_FONT_FOLDERS[0]]
    for name in PREFERRED_FONT_FOLDERS[1:]:
        cmd.extend(['-or', '-iname', name])

    # sys.stdout.write('$ %s\n'%cmd) info about shell command
    data = get_popen_result(cmd)
    data = data.strip()

    # list of path with font folders:
    font_folders = re.split('\s+', data)
    print 'Found %d folder(s).' % len(font_folders)
    return font_folders


def join_font_types(plain, fontnames):
    """
    Chceck if name has all types: plain, obligue, bold, bold-obligue.
    If is it true, returns string with this names.
    """
    font_family = ''
    font_name, dummy_ext = plain.split('.')

    obligue, bold, bold_obligue = ['']*3

    for name in fontnames:
        if re.match('%s-?(Oblique|Italics?).ttf'%font_name, name, re.I):
            obligue = name
        if re.match('%s-?Bold.ttf'%font_name, name,  re.I):
            bold = name
        if re.match('%s-?Bold-?(Oblique|Italics?).ttf'%font_name, name, re.I):
            bold_obligue = name

    if obligue and bold and bold_obligue:
        font_family = ' '.join((plain,  obligue,  bold,  bold_obligue))
        sys.stdout.write("Found font family '%s'\n"%plain)

    return font_family


def find_font_family(font_folders):
    """
    Returns path to the font and font family names (4 names)
    """
    font_folder_name, font_family = None, None
    font_filenames = ['%s.ttf' % name for name in PREFERRED_FONT_NAMES]

    for folder_name in font_folders:
        data = get_popen_result(['find', folder_name, '-name', '*.ttf'])

        # keep paths and names of fonts separately:
        font_paths = []
        font_names = []
        for path in re.split('\s+', data.strip()):
            font_paths.append(os.path.dirname(path))
            font_names.append(os.path.basename(path))

        print "Found %d fonts in folder '%s'." % (len(font_names), folder_name)
        # find font family
        # looking for fonty types (4 types = one family)
        for font_type in font_filenames:
            if font_type in font_names:
                font_family = join_font_types(font_type, font_names)
                if font_family:
                    font_folder_name = font_paths[font_names.index(font_type)]
                    break
    return font_folder_name, font_family


def find_font_path_and_family():
    """Find truetype fonts"""
    font_folders = find_font_folders()
    return find_font_family(font_folders)


class Install(install):
    description = "Install fred-doc2pdf"

    user_options = install.user_options
    user_options.append(('trml-name=', None,
        'name of trml module'))
    user_options.append(('trml-path=', None,
        'path to trml module'))
    user_options.append(('font-names=', None,
        'default names for true-type fonts'))
    user_options.append(('font-path=', None,
        'path to true-type fonts'))

    def initialize_options(self):
        install.initialize_options(self)
        self.trml_name = None
        self.trml_path = None
        self.font_names = None
        self.font_path  = None

    def finalize_options(self):
        install.finalize_options(self)
        # Set up trml
        if self.no_check_deps:
            if not self.trml_name:
                self.trml_name = 'trml2pdf'
        else:
            # Look for trml modules
            if self.trml_name:
                trml_modules = (self.trml_name, )
            else:
                trml_modules = MODULES_TINYRML
            if self.trml_path:
                trml_paths = (self.trml_path, )
            else:
                trml_paths = (None, os.path.join(get_python_lib(), TINYERP_PATH),
                              os.path.join('/usr/lib', TINYERP_PATH))

            # Find or verify existence
            found = False
            for trml_name in trml_modules:
                for trml_path in trml_paths:
                    try:
                        sys.path.append(trml_path)
                        importlib.import_module(trml_name)
                    except ImportError:
                        continue
                    finally:
                        sys.path.remove(trml_path)
                    found = True
                    break
                if found:
                    break
            if not found:
                sys.stderr.write("Module 'trml2pdf' not found, you need to install it.\n")
                exit(1)
            self.trml_name = trml_name
            self.trml_path = trml_path

        # Set up fonts
        if not self.font_path and not self.font_names:
            self.font_path, self.font_names = find_font_path_and_family()
        else:
            font_names = None
            if not self.font_path:
                self.font_path, font_names = find_font_path_and_family()

            if not self.font_names:
                if font_names:
                    self.font_names = font_names
                else:
                    dummy, self.font_names = find_font_path_and_family()

            if self.no_check_deps is None:
                # Check font path
                if os.path.isdir(self.font_path):
                    sys.stderr.write("Directory '%s' not found.\n" % self.font_path)
                    exit(1)
                # check explicit font names
                for font_file in re.split("\s+", self.font_names):
                    path = os.path.join(self.font_path, font_file)
                    if not os.path.isfile(path):
                        sys.stderr.write("File '%s' not found.\n" % path)
                        exit(1)

    def update_config(self, filename):
        content = open(filename).read()
        content = content.replace('TRML_MODULE_NAME', self.trml_name)
        if self.trml_path:
            content = content.replace('MODULE_PATH', self.trml_path)
        else:
            #TODO: We should remove useless configuration options from configuration file, not use dummy value
            content = content.replace('MODULE_PATH', '')
        content = content.replace('TRUE_TYPE_PATH', self.font_path)
        content = content.replace('DEFAULT_FONT_TTF', self.font_names)
        open(filename, 'w').write(content)
        self.announce("File '%s' was updated" % filename)

    def update_script(self, filename):
        content = open(filename).read()
        pattern = re.compile(r'^CONFIG_FILENAME .*$', re.MULTILINE)
        content = pattern.sub("CONFIG_FILENAME = '%s'" % self.expand_filename('$sysconf/fred/%s' % CONFIG_FILENAME),
                              content)
        open(filename, 'w').write(content)
        self.announce("File '%s' was updated" % filename)


def main():
    srcdir = os.path.dirname(os.path.abspath(__file__))

    data_files = [
        ('$sysconf/fred/', [os.path.join('conf', CONFIG_FILENAME)]),
    ] + [(os.path.join('share/%s/templates' % PACKAGE_NAME, dest), files)
         for dest, files in find_data_files(srcdir, 'templates')]

    setup(name=PROJECT_NAME,
          description='PDF creator module',
          author='Zdenek Bohm, CZ.NIC',
          author_email='zdenek.bohm@nic.cz',
          url='http://fred.nic.cz',
          license='GNU GPL',
          long_description='The module of the FRED system',
          scripts=[PACKAGE_NAME],
          data_files=data_files,
          cmdclass={'install':Install},
          modify_files={'$scripts/%s' % PACKAGE_NAME: 'update_script',
                        '$sysconf/fred/%s' % CONFIG_FILENAME: 'update_config'})


if __name__ == '__main__':
    main()
