<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!-- 

This template serves as pattern for transfer of auth_info record into PDF. 
Tato šablona slouží pro převod auth_info.xml záznamu do PDF.
Create: Zdeněk Böhm <zdenek.bohm@nic.cz>; 1.2.2007, 12.2.2007

There is used a logo (file cz_nic_logo.jpg), which is saved in a folder templates/
together with this template. It is neccesity to set up path properly, if the template isn't called
from script folder (fred2pdf/trunk):

(There have to be two hyphens before stringparam.)
$xsltproc -stringparam srcpath enum/fred2pdf/trunk/templates/ -stringparam lang en enum/fred2pdf/trunk/templates/auth_info.xsl enum/fred2pdf/trunk/examples/auth_info.xml

<mojeid_valid>
        <request_date>
        <request_id>
        <name> </name>
        <organization> </organization>
        <ic>
        <birth_date> </birth_date>
        <address> </address>
        <ic_dic> </ic_dic>
</mojeid_valid>


*===============

<xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="$lang02"/>
          <xsl:with-param name="templateName" select="concat('main_', $lang02)"/>
        </xsl:call-template>
       


        <xsl:for-each select="holder">

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />

<xsl:param name="srcpath" select="'templates/'" />
<xsl:param name="lang" select="'cs'" />

<xsl:variable name="loc" select="document(concat('auth_info_', $lang, '.xml'))/strings"/>


<xsl:template match="/mojeid_valid">

<xsl:if test="not($lang='cs' or $lang='en')">
    <xsl:message terminate="yes">Parameter 'lang' is invalid. Available values are: cs, en</xsl:message>
</xsl:if>

<document>

    <!--title="{$loc/str[@name='Confirmation of Request for password']}" -->
<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="Žádost o validaci kontaktu mojeID"
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

        <!--<drawString x="2.5cm" y="23.4cm" color="#a8986d"><xsl:value-of select="$loc/str[@name='Confirmation of Request for password']"/></drawString> -->
        <drawString x="2.5cm" y="23.4cm" color="#a8986d">Žádost o validaci kontaktu mojeID</drawString>
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
        Validaci proveďte jedním z následujících způsobů:
    </para>
    <para>
        - Tuto žádost vytiskněte, opatřete ověřeným podpisem a zašlete poštou na adresu Zákaznická podpora CZ.NIC, z. s. p. o., Americká 23, 120 00 Praha 2
    </para>
    <para>
        - Přiložte tuto žádost do přílohy emailu, podepište jej svým elektronickým podpisem a zašlete jej na adresu podpora@nic.cz
    </para>
    <para>
        - Tuto žádost vytiskněte, podepiště a dostavte se osobně na adresu sdružení CZ.NIC - Americká 23, Praha 2. Nezapomeňte s sebou vzít také Váš občanský průkaz.
    </para>

    <spacer length="0.6cm"/>
<para>
    Věc: Žádost o validaci kontaktu mojeID.
</para>
<spacer length="0.6cm"/>
<para>
    Žádám tímto o validování účtu mojeID: 
</para>

<spacer length="0.6cm"/>

<para>
 Jméno : <xsl:value-of select="name"/>
 </para> 

<para>
 <xsl:choose> 
     <xsl:when test="string(organization)">  
         Organizace : <xsl:value-of select="organization"/>
     </xsl:when>
     <xsl:otherwise>
     </xsl:otherwise>
 </xsl:choose>
</para>
 
<para>
 <xsl:choose> 
     <xsl:when test="string(ic)">  
         IČ : <xsl:value-of select="ic"/>
     </xsl:when>
     <xsl:otherwise>
     </xsl:otherwise>
 </xsl:choose>
</para> 
 
 <para>
 Datum narození : <xsl:value-of select="birth_date"/>
 </para> <para>
 Adresa : <xsl:value-of select="address"/>
 </para> 

<spacer length="0.6cm"/>
<para>
Identifikační číslo žádosti <xsl:value-of select="request_id"/>
, zažádáno dne <xsl:value-of select="request_date"/>. 
</para>

<spacer length="0.6cm"/>
<para>
 Jméno a podpis odpovědné osoby:
</para>
<spacer length="1.0cm"/>
<para>
...........................................................................
</para>
<!--
<para>
(úředně ověřený podpis v případě zaslání poštou)
</para>
-->
</story>

</document>
</xsl:template>

</xsl:stylesheet>
