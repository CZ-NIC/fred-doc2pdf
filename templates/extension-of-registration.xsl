<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- 
Usage: 

Czech version:
xsltproc templates/extension-of-registration.xsl examples/extension-of-registration.xml | doc2pdf.py > document.pdf

English version:
xsltproc -stringparam lang en templates/extension-of-registration.xsl examples/extension-of-registration.xml | doc2pdf.py > document.pdf
-->

<xsl:output method="xml" encoding="utf-8" />
<xsl:param name="lang" select="'cs'" />
<xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

<xsl:include href="shared_templates.xsl" />

<xsl:template match="/message">
<document>
<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="Extension of registration"
  author="CZ.NIC"
  >
    <pageTemplate id="main">
      <pageGraphics>

        <image file="templates/logo-balls.png" x="2.1cm" y="24cm" width="5.6cm" />

        <frame id="address" x1="12.5cm" y1="22.6cm" width="7.6cm" height="3cm" showBoundary="0" />
        <frame id="main" x1="2.1cm" y1="4.5cm" width="16.7cm" height="17.7cm" showBoundary="0" />

        <image file="templates/cz_nic_logo_{$lang}.png" x="2.1cm" y="0.8cm" width="4.2cm" />

        <stroke color="#C4C9CD"/>
        <lineMode width="0.01cm"/>
        <lines>7.1cm  1.3cm  7.1cm 0.5cm</lines>
        <lines>11.4cm 1.3cm 11.4cm 0.5cm</lines>
        <lines>14.6cm 1.3cm 14.6cm 0.5cm</lines>
        <lines>17.9cm 1.3cm 17.9cm 0.5cm</lines>
        <lineMode width="1"/>

        <fill color="#ACB2B9" /> 
        <setFont name="Times-Roman" size="7" />

        <drawString x="7.3cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='CZ.NIC, z.s.p.o.']"/></drawString>
        <drawString x="7.3cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='Americka 23, 120 00 Prague 2']"/></drawString>
        <drawString x="7.3cm" y="0.5cm"><xsl:value-of select="$loc/str[@name='Czech Republic']"/></drawString>

        <drawString x="11.6cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='T']"/> +420 222 745 111</drawString>
        <drawString x="11.6cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='F']"/> +420 222 745 112</drawString>

        <drawString x="14.8cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='IC']"/> 67985726</drawString>
        <drawString x="14.8cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='DIC']"/> CZ67986726</drawString>

        <drawString x="18.1cm" y="1.1cm">kontakt@nic.cz</drawString>
        <drawString x="18.1cm" y="0.8cm">www.nic.cz</drawString>

      </pageGraphics>
    </pageTemplate>

</template>

<stylesheet>
    <paraStyle name="main" spaceAfter="0.6cm" fontName="Times-Roman" />
    <paraStyle name="address" fontSize="12" fontName="Times-Roman"  />
    <paraStyle name="address-name" parent="address" fontName="Times-Bold"  />
</stylesheet>

<story>

<para style="address-name"><xsl:value-of select='holder/name' /></para>
<para style="address"><xsl:value-of select='holder/street' /></para>
<para style="address"><xsl:value-of select='holder/zip' />&SPACE;<xsl:value-of select='holder/city' /></para>
<para style="address"><xsl:value-of select='holder/country' /></para>

<nextFrame/>

<para style="main">
<xsl:value-of select="$loc/str[@name='Prague']"/>, <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date" /></xsl:call-template>
</para>

<para style="main">
<xsl:value-of select="$loc/str[@name='Subject: Extension of registration of']"/>&SPACE;<xsl:value-of select='domain' />&SPACE;<xsl:value-of select="$loc/str[@name='domain(subject)']"/>
</para>
<spacer length="1.2cm"/>

<para style="main">
<xsl:value-of select="$loc/str[@name='Dear holder of']"/>&SPACE;<xsl:value-of select='domain' />&SPACE;<xsl:value-of select="$loc/str[@name='domain name']"/>,
</para>

<para style="main"><xsl:value-of select="$loc/str[@name='The CZ.NIC z.s.p.o. company, an administrator...']"/></para>

<para style="main"><xsl:value-of select="$loc/str[@name='Should you be interested in keeping this domain name...']"/></para>

<para style="main"><xsl:value-of select="$loc/str[@name='hould the registration of the domain name...']"/>&SPACE;
 <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="termination_date" /></xsl:call-template>&SPACE; <xsl:value-of select="$loc/str[@name='and the domain name shall be open...']"/>
</para>

<para style="main">
<xsl:value-of select="$loc/str[@name='The following information was recorded on the CZ.NIC Central database as of the date of issuance of this letter']"/>:
</para>

<spacer length="0.6cm"/>

<para><xsl:value-of select="$loc/str[@name='Domain name']"/>: <xsl:value-of select='domain' /></para>
<para><xsl:value-of select="$loc/str[@name='Holder']"/>: <xsl:value-of select='concat(holder/org, ", ", holder/name)' /> (ID: <xsl:value-of select='holder/handle' />)</para>
<para><xsl:value-of select="$loc/str[@name='Designated registrar']"/>: <xsl:value-of select='registrar' /></para>
<para><xsl:value-of select="$loc/str[@name='Date of termination of the registration']"/>: <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="termination_date" /></xsl:call-template></para>

<spacer length="0.8cm"/>

<para>Ing. Martin Peterka</para>
<para><xsl:value-of select="$loc/str[@name='Operations manager, CZ.NIC, z.s.p.o.']"/></para>

</story>

</document>
</xsl:template>

</xsl:stylesheet>
