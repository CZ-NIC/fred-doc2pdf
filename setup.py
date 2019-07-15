#!/usr/bin/python
#
# Copyright (C) 2007-2019  CZ.NIC, z. s. p. o.
#
# This file is part of FRED.
#
# FRED is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# FRED is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FRED.  If not, see <https://www.gnu.org/licenses/>.

"""
Usage:
    python setup.py install
"""
from setuptools import setup, findall


PROJECT_NAME = 'fred-doc2pdf'
PACKAGE_NAME = 'fred-doc2pdf'


setup(name=PROJECT_NAME,
      description='PDF creator module',
      author='Zdenek Bohm, CZ.NIC',
      author_email='zdenek.bohm@nic.cz',
      url='http://fred.nic.cz',
      version='2.20.0',
      license='GPLv3+',
      long_description='The module of the FRED system',
      scripts=[PACKAGE_NAME],
      data_files=[('share/fred-doc2pdf/templates', findall('templates'))],
      zip_safe=False)
