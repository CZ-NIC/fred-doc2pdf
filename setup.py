#!/usr/bin/python
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
      version='2.18.0',
      license='GNU GPL',
      long_description='The module of the FRED system',
      scripts=[PACKAGE_NAME],
      data_files=[('usr/share/fred-doc2pdf/templates', findall('templates'))],
      zip_safe=False)
