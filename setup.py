#!/usr/bin/python
"""
Usage:
    python setup.py install
"""
import os

from freddist.core import setup
from freddist.util import find_data_files


PROJECT_NAME = 'fred-doc2pdf'
PACKAGE_NAME = 'fred-doc2pdf'


def main():
    srcdir = os.path.dirname(os.path.abspath(__file__))

    data_files = [(os.path.join('share/%s/templates' % PACKAGE_NAME, dest), files)
                  for dest, files in find_data_files(srcdir, 'templates')]

    setup(name=PROJECT_NAME,
          description='PDF creator module',
          author='Zdenek Bohm, CZ.NIC',
          author_email='zdenek.bohm@nic.cz',
          url='http://fred.nic.cz',
          license='GNU GPL',
          long_description='The module of the FRED system',
          scripts=[PACKAGE_NAME],
          data_files=data_files)


if __name__ == '__main__':
    main()
