<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- 
Usage: 
xsltproc templates/postal-summary-sheet.xsl examples/postal-summary-sheet.xml | doc2pdf.py > document.pdf
-->

<xsl:output method="xml" encoding="utf-8" />
<xsl:param name="lang" select="'cs'" />
<xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

<xsl:include href="shared_templates.xsl" />

<xsl:template match="/summary">
<document>
<template pageSize="(29.7cm, 21cm)" leftMargin="1.1cm" rightMargin="1.1cm" topMargin="1.8cm" bottomMargin="1.3cm" 
  title="Postal summary sheet"
  author="CZ.NIC"
  >
    <pageTemplate id="first">
      <pageGraphics>

        <setFont name="Times-Roman" size="12"/>
        <drawString x="1.1cm" y="18.8cm">ODESÍLATEL: <xsl:value-of select="$loc/str[@name='CZ.NIC, z.s.p.o.']"/>, <xsl:value-of select="$loc/str[@name='Americka 23, 120 00 Prague 2']"/></drawString>

        <setFont name="Times-Roman" size="8"/>
        <drawString x="24cm" y="19.6cm">Číslo přílohy</drawString>
        <drawString x="24cm" y="19.3cm">přijímací knihy</drawString>

        <rect x="26.5cm" y="19cm" width="2.1cm" height="1cm" fill="no" stroke="yes"/>
        <setFont name="Times-Roman" size="12"/>
        <drawString x="27.4cm" y="19.36cm"><pageNumber/></drawString>

      </pageGraphics>
        <frame id="delivery" x1="0.8cm" y1="0.8cm" width="28cm" height="17.6cm" showBoundary="0" />
    </pageTemplate>

</template>

<stylesheet>
    <blockTableStyle id="tbl_delivery">

      <blockAlignment value="CENTER" start="0,0" stop="5,2" />

      <blockValign value="BOTTOM" start="0,0" stop="4,2"/>
      <blockValign value="MIDDLE" start="5,0" stop="-1,2"/>
      <blockValign value="MIDDLE" start="0,3" stop="-1,-1"/>

      <blockFont name="Times-Roman" size="8" start="0,0" stop="-1,-1"/>

      <lineStyle kind="GRID" start="0,3" stop="-1,-1" colorName="black" />

      <lineStyle kind="BOX" start="0,0" stop="-1,2" colorName="black" />

      <lineStyle kind="LINEAFTER" start="6,0" stop="6,1" colorName="black" />

      <lineStyle kind="LINEAFTER" start="0,0" stop="4,2" colorName="black" />
      <lineStyle kind="LINEAFTER" start="8,0" stop="8,2" colorName="black" />
      <lineStyle kind="LINEAFTER" start="10,0" stop="10,2" colorName="black" />
      <lineStyle kind="LINEAFTER" start="12,0" stop="12,2" colorName="black" />

      <lineStyle kind="LINEAFTER" start="5,1" stop="5,1" colorName="black" />
      <lineStyle kind="LINEAFTER" start="7,1" stop="7,1" colorName="black" />
      <lineStyle kind="LINEAFTER" start="9,1" stop="9,2" colorName="black" />
      <lineStyle kind="LINEAFTER" start="11,1" stop="11,2" colorName="black" />

      <lineStyle kind="LINEBELOW" start="5,0" stop="12,0" colorName="black" />
      <lineStyle kind="LINEBELOW" start="5,1" stop="12,1" colorName="black" />

    </blockTableStyle>

    <paraStyle name="th" fontSize="8" />
</stylesheet>

<story>

<blockTable colWidths="1.2cm,1.7cm,4.6cm,6cm,4.3cm,1.4cm,0.7cm,0.7cm,1.1cm,1.3cm,0.7cm,1cm,0.7cm,2.1cm" repeatRows="3" style="tbl_delivery">
<tr>
    <td>Datum</td>
    <td><para style="th">Podací</para><para style="th">číslo</para></td>
    <td><para style="th">Jméno a příjmení adresáta</para><para style="th">(název organizace)</para></td>
    <td>Ulice, číslo domu</td>
    <td><para style="th">Dodací pošta</para><para style="th">(místo určení, PSČ)</para></td>
    <td>Dobírka</td>
    <td></td>
    <td>Hmotnost</td>
    <td></td>
    <td><para style="th">Udaná cena</para><para style="th">Vplacená částka</para></td>
    <td></td>
    <td>Výplatné</td>
    <td></td>
    <td>Poznámka</td>
</tr>
<tr>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>Kč</td>
    <td>h</td>
    <td>kg</td>
    <td>g</td>
    <td>Kč</td>
    <td>h</td>
    <td>Kč</td>
    <td>h</td>
</tr>

<tr>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>Převod:</td>
</tr>

<xsl:apply-templates/>


</blockTable>

</story>

</document>
</xsl:template>

<xsl:template match="mailing-list/item">
<tr>
    <td><xsl:call-template name="short_date"><xsl:with-param name="sdt" select="date" /></xsl:call-template></td>
    <td><xsl:value-of select="mailing_number"/></td>
    <td><xsl:value-of select="name"/></td>
    <td><xsl:value-of select="street"/></td>
    <td><xsl:value-of select="zip"/>&SPACE;<xsl:value-of select="city"/></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
</tr>
</xsl:template>

</xsl:stylesheet>
