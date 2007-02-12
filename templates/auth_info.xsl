<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!-- 
Tato šablona slouží pro převod auth_info.xml záznamu do PDF.
Vyvořil: Zdeněk Böhm <zdenek.bohm@nic.cz>; 1.2.2007, 12.2.2007

V layoutu je použito logo cz_nic_logo.jpg, které je uloženo v adresáři templates/
společně s touto šablonou. Je nutné nastavit správně cestu, pokud se šablona nevolá z adresáře
skriptu (fred2pdf/trunk):

$ xsltproc stringparam srcpath adresar/kde-je-logo/templates/ templates/auth_info.xsl examples/auth_info.xml
(pred stringparam dva spojovniky)
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />

<xsl:template name="handle_type">
    <xsl:param name="type_id"/>
    <xsl:choose>
        <xsl:when test="$type_id = 1">ke kontaktu</xsl:when>
        <xsl:when test="$type_id = 2">k sadě nameserverů</xsl:when>
        <xsl:when test="$type_id = 3">k doménovému jménu</xsl:when>
        <xsl:otherwise>k identifikátoru</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:param name="srcpath" select="'templates/'" />

<xsl:template match="/enum_whois/auth_info">
<document>
<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="Vyžádání změny v AuthInfo záznamu"
  author="CZ.NIC"
  >

    <pageTemplate id="main">
      <pageGraphics>
    <!-- Page header -->
        <image file="{$srcpath}cz_nic_logo.jpg" x="2.3cm" y="25cm" width="4.5cm" />
        <stroke color="#bab198"/>
        <lineMode width="0.2cm"/>
        <lines>2.5cm 24.4cm 18.5cm 24.4cm</lines>
        <lineMode width="1"/>
        <fill color="#a8986d"/>
        <setFont name="Times-Bold" size="12"/>
        <drawString x="2.5cm" y="23.4cm" color="#a8986d">Vyžádání změny v AuthInfo záznamu</drawString>
        <fill color="black"/>

       <frame id="body" x1="2.3cm" y1="10cm" width="16.6cm" height="13cm" showBoundary="0" />

    <!-- Page footer -->
        <stroke color="#c0c0c0"/>
        <lines>2.5cm 8.6cm 18.5cm 8.6cm</lines>

        <setFont name="Times-Roman" size="8"/>
        <drawString x="2.5cm" y="8cm">Tuto žádost prosím vytiskněte, podepište (je nutný úředně ověřený podpis) a podepsaný originál zašlete na adresu:</drawString>
        <drawString x="2.5cm" y="2.2cm">V případě, že podepisující osoba není uvedena v Centrálním registru doménových jmen, je k této žádosti potřeba přiložit</drawString>
        <drawString x="2.5cm" y="1.8cm">originál nebo úředně ověřenou kopii dokumentu, který zmocňuje tuto osobu k uvedenému požadavku.</drawString>

        <setFont name="Times-Bold" size="12"/>
        <drawString x="11.5cm" y="5.5cm">Zákaznická podpora</drawString>
        <drawString x="11.5cm" y="4.7cm">CZ.NIC, z. s. p. o. Americká 23</drawString>
        <drawString x="11.5cm" y="3.9cm">120 00 Praha 2</drawString>

    <!-- Folder marks -->
        <stroke color="black"/>
        <lines>0.5cm 10.2cm 1cm 10.2cm</lines>
        <lines>20cm 10.2cm 20.5cm 10.2cm</lines>

        <lines>0.5cm 20.2cm 1cm 20.2cm</lines>
        <lines>20cm 20.2cm 20.5cm 20.2cm</lines>

      </pageGraphics>
    </pageTemplate>

</template>

<stylesheet>
    <paraStyle name="address" fontName="Times-Italic" fontSize="8" leftIndent="1.4cm" />
    <paraStyle name="footer" fontSize="8" />
</stylesheet>

<story>
<para>
Věc: Potvrzení žádosti o poskytnutí hesla <xsl:call-template name="handle_type"><xsl:with-param name="type_id" select="handle/@type" /></xsl:call-template>&SPACE;<xsl:value-of select="handle" />.
</para>
<spacer length="0.6cm"/>
<para>
Potvrzuji tímto žádost o poskytnutí hesla <xsl:call-template name="handle_type"><xsl:with-param name="type_id" select="handle/@type" /></xsl:call-template>&SPACE;<b><xsl:value-of select="handle" /></b>,
podanou prostřednictvím webového formuláře na stránce
<xsl:value-of select="webform_url" /> dne <b><xsl:value-of select="transaction_date" /></b>,
které bylo přiděleno identifikační číslo <b><xsl:value-of select="transaction_id" /></b> a žádám o poskytnutí 
příslušného hesla na adresu <b><xsl:value-of select="replymail" /></b>.
</para>
<spacer length="0.6cm"/>
<para>
Jméno a úředně ověřený podpis zodpovědné osoby:
</para>
<spacer length="1.6cm"/>
<para>
...........................................................................
</para>
</story>

</document>
</xsl:template>

</xsl:stylesheet>
