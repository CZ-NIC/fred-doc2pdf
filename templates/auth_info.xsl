<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
<!ENTITY EMSPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
<!ENTITY NON-BEAKING-SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!-- 

This template serves as pattern for transfer of auth_info record into PDF. 
Tato šablona slouží pro převod auth_info.xml záznamu do PDF.
Create: Zdeněk Böhm <zdenek.bohm@nic.cz>; 1.2.2007, 12.2.2007

There is used a logo (file cz_nic_logo.jpg), which is saved in a folder templates/
together with this template. It is neccesity to set up path properly, if the template isn't called
from script folder (fred2pdf/trunk):

(There have to be two hyphens before stringparam.)
$xsltproc enum/fred2pdf/trunk/templates/ -stringparam lang en enum/fred2pdf/trunk/templates/auth_info.xsl enum/fred2pdf/trunk/examples/auth_info.xml
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="cznic_design.xsl"/>

<xsl:output method="xml" encoding="utf-8" />

<xsl:template name="handle_type">
    <xsl:param name="type_id"/>
    <xsl:choose>
        <xsl:when test="$type_id = 1"><xsl:value-of select="$loc/str[@name='contact']"/></xsl:when>
        <xsl:when test="$type_id = 2"><xsl:value-of select="$loc/str[@name='nameserver set']"/></xsl:when>
        <xsl:when test="$type_id = 3"><xsl:value-of select="$loc/str[@name='domain name']"/></xsl:when>
        <xsl:when test="$type_id = 4"><xsl:value-of select="$loc/str[@name='keyset']"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$loc/str[@name='handle']"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:param name="lang" select="'cs'" />
<xsl:variable name="loc" select="document(concat('auth_info_', $lang, '.xml'))/strings"/>

<xsl:template match="/enum_whois/auth_info">

<xsl:if test="not($lang='cs' or $lang='en')">
    <xsl:message terminate="yes">Parameter 'lang' is invalid. Available values are: cs, en</xsl:message>
</xsl:if>

<document>
<docinit>
    <registerTTFont faceName="FreeSans" fileName="FreeSans.ttf"/>
    <registerTTFont faceName="FreeSansBold" fileName="FreeSansBold.ttf"/>
    <registerTTFont faceName="FreeSansBoldItalic" fileName="FreeSansBoldOblique.ttf"/>
    <registerTTFont faceName="FreeSansItalic" fileName="FreeSansOblique.ttf"/>
    <registerFontFamily normal="FreeSans" bold="FreeSansBold" italic="FreeSansItalic" boldItalic="FreeSansBoldItalic" />
</docinit>
<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="{$loc/str[@name='Confirmation of Request for password']}"
  author="CZ.NIC"
  >

    <pageTemplate id="main">
      <pageGraphics>
    <!-- Page header -->
        <translate dx="13.6"/><!-- Align CZ.NIC logo to the left side same as the main text -->
        <xsl:call-template name="cznic_logo"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
        <translate dx="-13.6"/>
        <lineMode width="1"/>
        <fill color="black"/>

       <frame id="body" x1="2.3cm" y1="10cm" width="16.6cm" height="14cm" showBoundary="0" />

    <!-- Page footer -->
        <stroke color="#003893"/>
        <setFont name="FreeSans" size="8"/>
        <drawString x="2.5cm" y="9.4cm"><xsl:value-of select="$loc/str[@name='Signatories whose name is not listed in the Central registry of domain names must attach']"/></drawString>
        <drawString x="2.5cm" y="9cm"><xsl:value-of select="$loc/str[@name='an original or a notarized copy of a document authorizing them to perform the relevant request.']"/></drawString>
        <lines>2.5cm 8.6cm 18.5cm 8.6cm</lines>
        <drawString x="2.5cm" y="8cm"><xsl:value-of select="$loc/str[@name='Please print this request sign it (a notarized signature required) and send the signed original to the following address:']"/></drawString>

        <setFont name="FreeSansBold" size="12"/>
        <drawString x="12.5cm" y="5.5cm">Zákaznická podpora</drawString>
        <drawString x="12.5cm" y="4.9cm">CZ.NIC, z. s. p. o.</drawString>
        <drawString x="12.5cm" y="4.3cm">Milešovská 1136/5</drawString>
        <drawString x="12.5cm" y="3.7cm">130 00&EMSPACE;Praha 3</drawString>

    <!-- Folder marks -->
        <stroke color="black"/>
        <lines>0.5cm 10.2cm 1cm 10.2cm</lines>
        <lines>20cm 10.2cm 20.5cm 10.2cm</lines>

        <lines>0.5cm 20.2cm 1cm 20.2cm</lines>
        <lines>20cm 20.2cm 20.5cm 20.2cm</lines>

        <xsl:call-template name="footer"/>
      </pageGraphics>
    </pageTemplate>

</template>

<stylesheet>
    <paraStyle name="main" fontName='FreeSans' fontSize='9' />
    <paraStyle name="address" fontName="FreeSansItalic" fontSize="8" leftIndent="1.4cm" />
    <paraStyle name="footer" parent="main" fontSize="8" />
    <paraStyle name="title" fontName='FreeSansBold' fontSize='12' textColor="#003893" leading="14" />
</stylesheet>

<story>
<para style="title">
<xsl:value-of select="$loc/str[@name='Confirmation of Request for password for']"/>&SPACE;<xsl:call-template name="handle_type"><xsl:with-param name="type_id" select="handle/@type" /></xsl:call-template>&SPACE;<xsl:value-of select="handle" />
</para>
<spacer length="0.6cm"/>
<para style="main">
<xsl:value-of select="$loc/str[@name='I hereby confirm my request to obtain password for']"/>&SPACE;<xsl:call-template name="handle_type"><xsl:with-param name="type_id" select="handle/@type" /></xsl:call-template>&SPACE;<b><xsl:value-of select="handle" /></b>,
<xsl:value-of select="$loc/str[@name='submitted through a web form at the association webpages']"/>
&SPACE;<xsl:value-of select="$loc/str[@name='on']"/>&SPACE; <b><xsl:value-of select="transaction_date" /></b>,
<xsl:value-of select="$loc/str[@name='assigned id number']"/>&NON-BEAKING-SPACE;<b><xsl:value-of select="transaction_id" /></b>&SPACE;
<xsl:value-of select="$loc/str[@name='Please send the password to']"/>&SPACE; <b><xsl:value-of select="replymail" /></b>.
</para>
<spacer length="0.6cm"/>
<para style="main">
<xsl:value-of select="$loc/str[@name='Name and signature of responsible person:']"/>
</para>
<spacer length="1.6cm"/>
<para style="main">
...........................................................................
</para>
</story>

</document>
</xsl:template>

</xsl:stylesheet>
