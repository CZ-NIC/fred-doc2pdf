<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!-- 

This template creates a RML document used to validate mojeID account.
Created: Juraj Vicenik <juraj.vicenik@nic.cz>; 15.10.2010
        based on auth_info.xsl template

A logo is used (file cz_nic_logo.jpg), which is saved in a folder templates/
together with this template. It is neccesity to set up the path properly, if the template isn't called
from script folder (fred2pdf/trunk):

(There have to be two hyphens before stringparam.)
$xsltproc -stringparam srcpath enum/fred2pdf/trunk/templates/ -stringparam lang en enum/fred2pdf/trunk/templates/mojeid_validate.xsl enum/fred2pdf/trunk/examples/mojeid_validate.xml

<mojeid_valid>
        <request_date>17.1.2010</request_date>
        <request_id>123123</request_id>
        <name>Ilya Muromec Křižík </name>
        <organization>Organization s.r.o </organization>
        <ic>IC-2342</ic>
        <birth_date>1.1.1901 </birth_date>
        <address>U můstku 2342/344 Kroměříž </address>
</mojeid_valid>

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />

<xsl:param name="srcpath" select="'templates/'" />
<xsl:param name="lang" select="'cs'" />

<xsl:variable name="loc" select="document(concat('mojeid_translation_', $lang, '.xml'))/strings"/>


<xsl:template match="/mojeid_valid">

<xsl:if test="not($lang='cs' or $lang='en')">
    <xsl:message terminate="yes">Parameter 'lang' is invalid. Available values are: cs, en</xsl:message>
</xsl:if>

<document>

<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
    title="{$loc/str[@name='ZadostOValidaciKontaktu']}"
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

        <drawString x="2.5cm" y="23.4cm" color="#a8986d"><xsl:value-of select="$loc/str[@name='ZadostOValidaciKontaktu']"/></drawString>
        <fill color="black"/>

        <frame id="body" x1="2.3cm" y1="6cm" width="16.6cm" height="17cm" showBoundary="0" />

    <!-- Page footer -->
        <stroke color="#c0c0c0"/>
        <lines>2.5cm 4.6cm 18.5cm 4.6cm</lines>

       
      
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
    <paraStyle name="bold" fontName="Times-Bold"/>
    <paraStyle name="address" fontName="Times-Italic" fontSize="8" leftIndent="1.4cm" />
    <paraStyle name="footer" fontSize="8" />
</stylesheet>

<story>

    <spacer length="0.4cm"/>
    <para>
        <xsl:value-of select="$loc/str[@name='ValidaciProvedte']"/>
    </para>
    <para>
        <xsl:value-of select="$loc/str[@name='ValidateVerifiedSignature']"/>
    </para>
    <para>
        <xsl:value-of select="$loc/str[@name='ValidateEmail']"/>
    </para>
    <para>
        <xsl:value-of select="$loc/str[@name='ValidateInPerson']"/>
    </para>

    <spacer length="0.6cm"/>
<para>
    <xsl:value-of select="$loc/str[@name='Vec:Zadost']"/>
</para>
<spacer length="0.6cm"/>
<para>
    <xsl:value-of select="$loc/str[@name='ZadamTimtoO']"/>
</para>

<spacer length="0.6cm"/>

<para>
    <xsl:value-of select="$loc/str[@name='01Jmeno']"/>
 &SPACE;<xsl:value-of select="name"/>
 </para> 

<para>
 <xsl:choose>
     <xsl:when test="string(organization)">  
         <xsl:value-of select="$loc/str[@name='02Org']"/>
         &SPACE;<xsl:value-of select="organization"/>
     </xsl:when>
     <xsl:otherwise>
     </xsl:otherwise>
 </xsl:choose>
</para>

<para>
 <xsl:choose> 
     <xsl:when test="string(ic)">  
        <xsl:value-of select="$loc/str[@name='03Ic']"/>
        &SPACE;<xsl:value-of select="ic"/>
     </xsl:when>
     <xsl:otherwise>
     </xsl:otherwise>
 </xsl:choose>
</para>
 
 <para>
     <xsl:value-of select="$loc/str[@name='04BirthDate']"/>
     &SPACE;<xsl:value-of select="birth_date"/>
 </para> 
 <para>
     <xsl:value-of select="$loc/str[@name='05Address']"/>
     &SPACE;<xsl:value-of select="address"/>
 </para>

<spacer length="0.6cm"/>
<para>
     <xsl:value-of select="$loc/str[@name='IdentifikacniCisloZadosti']"/> 
    <xsl:value-of select="request_id"/>

     <xsl:value-of select="$loc/str[@name='zazadanoDne']"/>
    <xsl:value-of select="request_date"/>. 
</para>

<spacer length="0.6cm"/>
<para>
    <xsl:value-of select="$loc/str[@name='JmenoApodpis']"/>
</para>
<spacer length="1.0cm"/>
<para>
...........................................................................
</para>

</story>

</document>
</xsl:template>

</xsl:stylesheet>
