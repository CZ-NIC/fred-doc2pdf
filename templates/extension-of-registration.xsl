<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />
<xsl:param name="lang" select="'cs'" />
<xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

<xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
    </xsl:if>
</xsl:template>

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

        <image file="templates/cz_nic_logo_en.png" x="2.1cm" y="0.8cm" width="4.2cm" />

        <stroke color="#C4C9CD"/>
        <lineMode width="0.01cm"/>
        <lines>7.1cm  1.3cm  7.1cm 0.5cm</lines>
        <lines>11.4cm 1.3cm 11.4cm 0.5cm</lines>
        <lines>14.6cm 1.3cm 14.6cm 0.5cm</lines>
        <lines>17.9cm 1.3cm 17.9cm 0.5cm</lines>
        <lineMode width="1"/>

        <fill color="#ACB2B9" /> 
        <setFont name="Times-Roman" size="7" />

        <drawString x="7.3cm" y="1.1cm">CZ.NIC, z.s.p.o.</drawString>
        <drawString x="7.3cm" y="0.8cm">Americka 23, 120 00 Prague 2</drawString>
        <drawString x="7.3cm" y="0.5cm">Czech Republic</drawString>

        <drawString x="11.6cm" y="1.1cm">T +420 222 745 111</drawString>
        <drawString x="11.6cm" y="0.8cm">F +420 222 745 112</drawString>

        <drawString x="14.8cm" y="1.1cm">IČ 67985726</drawString>
        <drawString x="14.8cm" y="0.8cm">DIČ CZ67986726</drawString>

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

<para style="address-name">Firma/Name s.r.o.</para>
<para style="address">Wall Street 123/156</para>
<para style="address">12300 New York City, DC</para>
<para style="address">USA</para>

<nextFrame/>

<para style="main">
Prague, DATUM
</para>

<para style="main">
Subject: Extension of registration of domain hradorlik.cz
</para>
<spacer length="1.2cm"/>

<para style="main">
Dear holder of domena domain name,
</para>

<para style="main">
The CZ.NIC z.s.p.o. company, an administrator of the national .cz domain, hereby informs you that so far he has not been instructed to renew the registration of your domain name specified above. This domain is currently out of service and excluded from .cz zone (see the Instructions for registration in .cz domain located at www.nic.cz). 
</para>

<para style="main">
Should you be interested in keeping this domain name for a further period, please promptly contact the appropriate registrar, confer with him over the complaints, if any, and make further arrangements. You are also free to turn to a different designated registrar and entrust him with the registration extension.
See also www.nic.cz for an update list of the companies having a contract with CZ NIC association that enables them to act as a registrar. 
</para>

<para style="main">
Should the registration of the domain name not be extended in time, the registration shall be terminated on the datum and the domain name shall be open to other interested persons!
</para>

<para style="main">
The following information was recorded on the CZ.NIC Central database as of the date of issuance of this letter:
</para>

<spacer length="0.6cm"/>

<para>Domain name: domena</para>
<para>Holder: org a jmeno drzitele (ID: ID drzitele)</para>
<para>Designated registrar: nazev registratora</para>
<para>Date of termination of the registration: DATUM</para>

<spacer length="0.8cm"/>

<para>Ing. Martin Peterka</para>
<para>Operations manager, CZ.NIC, z.s.p.o.</para>

</story>

</document>
</xsl:template>

</xsl:stylesheet>
