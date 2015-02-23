<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:func="http://exslt.org/functions" extension-element-prefixes="func"
    xmlns:cznic="http://nic.cz/xslt/functions">

    <func:function name="cznic:country_is_czech_republic">
        <xsl:param name="country"/>
        <func:result select="contains('|cz|czech republic|česká republika|',
        concat('|', translate($country,
                    'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÝÓÚŮŽŠČŘĎŤŇĚ',
                    'abcdefghijklmnopqrstuvwxyzáéíýóúůžščřďťňě'),
               '|'))" />
        <!--
        Use translate() instead of lower-case() because it is available from XPath 2.0.
        -->
    </func:function>

</xsl:stylesheet>