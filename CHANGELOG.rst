ChangeLog
=========

2022-01-06 (2.24.0)
-------------------

* Add new contact states (to inform that some of the contact attributes are locked and cannot be changed) description
* Update text of mojeid validation pdf


2021-03-31 (2.23.1)
-------------------

* Fix date position in mojeid pin3 template


2021-03-23 (2.23.0)
-------------------

* Reworked mojeid pin3 templates


2020-04-17 (2.22.2)
-------------------

* Update helios template for new invoice prefixes


2020-01-31 (2.22.1)
-------------------

* Fix rpm for RHEL8 and F31


2020-01-08 (2.22.0)
-------------------

* Add administrative fee item code to invoice template


2019-11-20 (2.21.1)
-------------------

* Update spec file for F31 and Centos/RHEL 8


2019-09-11 (2.21.0)
-------------------

* Add monthly fee item code to invoice template
* Add note about VAT calculation


2019-07-15 (2.20.0)
-------------------

* Record statement fixes and enhancements

  * date formatting
  * trim organization field
  * footer text removed


2019-03-18 (2.19.0)
-------------------

* License GNU GPLv3+


2019-01-16 (2.18.1)
-------------------

* Fix - remove 'X X X' line from mojeid letter


2018-09-05 (2.18.0)
-------------------

* Font definitions moved to templates
* Use setuptools for distribution


2018-08-14 (2.17.1)
-------------------

* Helios template fixes


2018-04-23 (2.17.0)
-------------------

* Add new template for personal info public request


2018-03-27 (2.16.1)
-------------------

* Fix registry record statement template - timezone


2018-02-14 (2.16.0)
-------------------

* Enhancements of contact verification pdf (letter)

  * Add QR code with url
  * Font size changes
  * Text and grammar fixes
  * Removed duplicate footer


2017-09-12 (2.15.0)
-------------------

* Add registry record statement templates


2017-10-11 (2.14.1)
-------------------

* Update text of mojeid validation pdf

  * Remove second paragraph about validation by certificate
  * Show paragraph with "Datova schranka" only to organisations
  * Fix link to the site mojeid/validation


2017-03-02 (2.14.0)
-------------------

* Remove Arial font dependency


2017-05-03 (2.13.3)
-------------------

* Fix invoice template (appendix padding)


2017-03-09 (2.13.2)
-------------------

* Fedora packaging


2016-12-20 (2.13.1)
-------------------

* Fix text of mojeid validation pdf


2016-11-29 Ales Friedl, Jiri Sadek (2.13.0)
-------------------------------------------

* Remove fax in cz.nic design template, use mobile phone instead
* Fix examples
* Remove generated files


2016-09-07 Zdenek Bohm, Zuzana Ansorgova (2.12.0)
-------------------------------------------------

* configuration file documentation
* compatibility with reportlab 3.3.0


2016-06-13 Jiri Sadek (2.11.3)
------------------------------

* mojeid validation pdf (datova schranka)


2016-06-07 Jaromir Talir (2.11.2)
---------------------------------

* new helios version template fixes


2016-03-22 Michal Strnad, Jaromir Talir (2.11.1)
------------------------------------------------

* Fix rpm build
* Fix example data


2015-05-19 Michal Strnad (2.11.0)
---------------------------------

* new mojeid card letter template


2015-01-27 Michal Strnad, Jan Korous (2.10.0)
---------------------------------------------

* new (improved) content of admin. verification letter
* new design of mojeid validation pdf
* fix invoice typo
* removed company_name field from shared address template
* fix condition for domestic letters (country=czech republic)


2014-12-31 Jan Zima (2.9.1)
---------------------------

* company address change


2014-10-17 Michal Strnad (2.9.0)
--------------------------------

* new mojeid re-identification letter
* mojeid validation pdf - address type defined in text
* mojeid pin3 letters fixes (QR code)


2014-09-17 Jaromir Talir (2.8.2)
--------------------------------

* helios template update


2014-08-29 Michal Strnad (2.8.1)
--------------------------------

* fix template for mojeid pin3 letter (address country)


2014-08-01 Michal Strnad, Zdenek Bohm (2.8.0)
---------------------------------------------

* new template for new mojeid pin3 letter
* fix admin. contact verification letter long address bug


2014-06-12 Zdenek Bohm (2.7.0)
------------------------------

* new templates for admin. contact verification letters
* several grammar fixes accross all templates
* change of association registration note in all templates


2014-02-18 Jaromir Talir (2.6.3)
--------------------------------

* Fix trml2pdf path checking in setup


2014-02-13 Michal Strnad (2.6.2)
--------------------------------

* Fix mojeid validation template (id-card copy statement, add new validation places)


2014-02-05 Zdenek Bohm (2.6.1)
------------------------------

* Address position fix (verification, domain expiration)


2014-01-07 Zdenek Bohm (2.6.0)
------------------------------

* New design


2013-08-22 Zdenek Bohm, Jiri Sadek (2.5.3)
------------------------------------------

* Fix pdf fonts rendering (accented characters), should work with reportlab 2.4, 2.5, 2.6


2013-06-07 Zdenek Bohm, Vlastimil Zima (2.5.2)
----------------------------------------------

* Fix error message when font file was not found
* Updating setup.cfg and setup.py according recent fred-distutils changes
* New CZ.NIC logos


2012-11-19 Jaromir Talir (2.5.1)
--------------------------------

* mojeid pin3 letter template changes


2012-09-05 Juraj Vicenik, Jan Zima (2.5.0)
------------------------------------------

* contact verification letter templates
* mojeid_auth tag changed to contact_auth in mojeid letter template
* fix mojeid validation template


2012-05-15 Zdenek Bohm (2.4.0)
------------------------------

* invoice template fix (advance payments - bold text)
* new invoice examples


2012-04-12 Zdenek Bohm (2.3.5)
------------------------------

* invoice template fix (summarize item line)


2012-03-26 Zdenek Bohm (2.3.4)
------------------------------

* mojeid templates fixes


2012-03-14 Zdenek Bohm, Juraj Vicenik (2.3.3)
---------------------------------------------

* mojeid templates changes
* letter address format fix (stateorprovince)


2011-11-04 Zdenek Bohm (2.3.2)
------------------------------

* account invoice fixes (translations)


2011-11-02 Zdenek Bohm, Jaromir Talir (2.3.1)
---------------------------------------------

* fix rpm build
* account invoice fixes (service codes)


2011-10-18 Zdenek Bohm, Jaromir Talir, Jan Zima (2.3.0)
-------------------------------------------------------

* updated FredTable constructor default parameters (to be compatible with tinyerp-server-4.2.3.4-7)
* helios template update
* account invoice template update

  * new template parameters
  * formatting changes
  * translations updates


2011-06-02 Vit Vomacko (2.2.0)
------------------------------

* removed local freddist


2010-12-13 Juraj Vicenik (2.1.7)
--------------------------------

* If country is Czech republic, don't write it to the address
* Changed office hours in mojeID validation document


2010-11-04 Juraj Vicenik (2.1.6)
--------------------------------

* Modified documents for MojeID - validation
* Changed XML format for validation - handle is allowed


2010-10-25 Juraj Vicenik (2.1.5)
--------------------------------

* Fixes in mojeid letters


2010-10-23 Jaromir Talir , Juraj Vicenik (2.1.4)
------------------------------------------------

* Fixes in mojeid letters


2010-10-18 Zdenek Bohm, Juraj Vicenik (2.1.3)
---------------------------------------------

* New documents for Mojeid (identification and validation letters)


2010-07-30 Jiri Sadek, Juraj Vicenik (2.1.2)
--------------------------------------------

* Warning letter table fix (heading, padding)
* Compatibility with reportlab 2.4


2010-07-23 Jiri Sadek (version 2.1.1)
-------------------------------------

* New cznic logo added
* Warning letter table format fix (padding)


2010-06-28 Juraj Vicenik (version 2.1.0)
----------------------------------------

* Trimming of long names in some templates
* Added template for notification about defunct contacts
* More templates moved to file with shared templates
* Moved registry-specific data from some files to ``translataion_`` files


2010-02-17 Zdenek Bohm,  Jaromir Talir (version 2.0.4)
------------------------------------------------------

* Template for accounting software helios updated to support new year prefix for invoice numbers and new vat rate
* Added support for years fee
* Fixed incompability with reportlab version > 2.1


2009-07-02 Jaromir Talir (version 2.0.3)
----------------------------------------

* Fixed czech translation for invoice template text
* Added support for negative invoices to invoice template
* Changed dependance on freefont to dejavu fonts


2008-05-25 Jaromir Talir (version 2.0.2)
----------------------------------------

* bugfix doubled '-' sign in case of negative numbers in helios template


2008-12-17 Jaromir Talir (version 2.0.1)
----------------------------------------

* bugfix negative numbers in invoice template


2008-11-10 Jaromir Talir (version 2.0.0)
----------------------------------------

* updating czech translation for warning letter (grammar corrections)
* adding support for Keysets in public requests


2008-08-19 Ales Dolezal
-----------------------

* new setup options, which provides way to manually set up some parameters (trml name and path and
  font names and path) if used with ``--no-check-deps`` option.


2008-07-15 Jaromir Talir (version 1.4.2)
----------------------------------------

* update helios template

  * enhanced VAT string prependation

* added path to ubuntu font package path
* updated installation process
* rpm build fixes


2008-06-05 Jaromir Talir, Ales Dolezal (version 1.4.1)
------------------------------------------------------

* small build process changes


2008-05-30 Jaromir Talir, Ales Dolezal (version 1.4.0)
------------------------------------------------------

* new build system fred-dist
* impementation of new public request template
* helios template update

  * changing date because of request from VGD


2008-03-06 Jaromir Talir (version 1.3.2)
----------------------------------------

* examples are out of distribution package
* helios template update

  * fixing another removing of 0 from old invoice numbering schema


2008-02-19 Jaromir Talir (version 1.3.1)
----------------------------------------

* helios template update

  * fixing removing of 0 from old invoice numbering schema
  * fixing generation of element DatPorizeni

* fred2pdf fixes made in r4415 was accidentaly revert, now are back


2008-01-09 Jaromir Talir (version 1.3.0)
----------------------------------------

* helios integration
* new invoice design


2007-11-15 Jaromir Talir (version 1.2)
----------------------------------------

* speed fixes of pdf generation in rml2pdf
* update template for invoices with new design
* new template for warning letter about expiration passing
