#!/usr/bin/python
"""
Usage:
    python setup.py install
"""
import os
import re

from freddist.command.install import install
from freddist.core import setup
from freddist.util import find_data_files


PROJECT_NAME = 'fred-doc2pdf'
PACKAGE_NAME = 'fred-doc2pdf'

CONFIG_FILENAME = 'fred-doc2pdf.conf'


class Install(install):
    description = "Install fred-doc2pdf"

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
          modify_files={'$scripts/%s' % PACKAGE_NAME: 'update_script'})


if __name__ == '__main__':
    main()
