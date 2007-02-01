<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />

<xsl:template match="/enum_whois/auth_info">
<document>
<!-- 
Tato šablona slouží pro převod auth_info záznamu do PDF.
Vyvořil: Zdeněk Böhm <zdenek.bohm@nic.cz>; 1.2.2007
-->
<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="Vyžádání změny v AuthInfo záznamu"
  author="CZ.NIC"
  >

    <pageTemplate id="main">
      <pageGraphics>
    <!-- BEGIN of the page header -->
        <setFont name="Times-BoldItalic" size="26"/>
        <drawString x="2.5cm" y="26cm">CZ.NIC, z.s.p.o</drawString>
        <stroke color="#bab198"/>
        <lineMode width="0.2cm"/>
        <lines>2.5cm 25cm 18.5cm 25cm</lines>
        <lineMode width="1"/>
    <!-- END of the page header -->
        <fill color="#a8986d"/>
        <setFont name="Times-Bold" size="12"/>
        <drawString x="2.5cm" y="24cm" color="#a8986d">Vyžádání změny v AuthInfo záznamu</drawString>

       <frame id="body" x1="2.3cm" y1="2cm" width="16.4cm" height="21cm" showBoundary="0" />

      </pageGraphics>
    </pageTemplate>

</template>

<stylesheet>
    <paraStyle name="address" fontName="Times-Italic" fontSize="8" leftIndent="1.4cm" />
    <paraStyle name="footer" fontSize="8" />
</stylesheet>

<story>
<para>
Věc: Potvrzení žádosti o poskytnutí hesla <xsl:value-of select="objtype" />&SPACE;<xsl:value-of select="handle" />.
</para>
<spacer length="0.6cm"/>
<para>
Potvrzuji tímto žádost o poskytnutí hesla <xsl:value-of select="objtype" />&SPACE;<b><xsl:value-of select="handle" /></b>,
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

<spacer length="8cm"/>


<illustration width="16.4cm" height="0.4cm">
        <stroke color="#c0c0c0"/>
        <lines>0cm 0cm 16cm 0cm</lines>
</illustration>
<spacer length="0.6cm"/>

<para style="footer">
Tuto žádost prosím vytiskněte, podepište (je nutný úředně ověřený podpis) a podepsaný originál zašlete na adresu:
</para>

<spacer length="0.6cm"/>

    <para style="address">Zákaznická podpora</para>
    <para style="address">CZ.NIC, z. s. p. o. Americká 23</para>
    <para style="address">120 00 Praha 2</para>

<spacer length="0.6cm"/>
<para style="footer">
V případě, že podepisující osoba není uvedena v Centrálním registru doménových jmen, je k této žádosti potřeba přiložit originál nebo úředně ověřenou kopii dokumentu, který zmocňuje tuto osobu k uvedenému požadavku.
</para>

</story>

</document>
</xsl:template>

</xsl:stylesheet>
