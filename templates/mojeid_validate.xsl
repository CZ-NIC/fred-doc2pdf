<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE " ">
<!ENTITY NBSP "&#160;">
<!ENTITY ENSP "&#8194;">
<!ENTITY EMSP "&#8195;">
<!ENTITY THINSP "&#8201;">
<!ENTITY BULL "&#8226;">
<!ENTITY CIRCLE "&#9679;">
<!ENTITY HELLIP "&#8230;">
]>
<!-- 

This template creates a RML document used to validate mojeID account.
Created: Michal Strnad <michal.strnad@nic.cz>; 2015-02-17
         based on cznic_design.xsl template

(There have to be two hyphens before stringparam.)
$xsltproc templates/mojeid_validate.xsl examples/mojeid_validate.xml | ./fred-doc2pdf > mojeid_validate.pdf

<mojeid_valid>
        <request_date>17.1.2010</request_date>
        <request_id>123123</request_id>
        <name>Ilya Muromec Křižík</name>
        <organization>Organization s.r.o</organization>
        <ic>IC-2342</ic>
        <birth_date>1.1.1901</birth_date>
        <address>U můstku 2342/344 Kroměříž</address>
</mojeid_valid>

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="cznic_design.xsl"/>

<xsl:output method="xml" encoding="utf-8" />

<xsl:param name="lang" select="'cs'" />

<xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>
<xsl:variable name="mojeid_loc" select="document(concat('mojeid_translation_', $lang, '.xml'))/strings"></xsl:variable>


<xsl:template match="/mojeid_valid">

<xsl:if test="not($lang='cs')">
    <xsl:message terminate="yes">Parameter 'lang' is invalid. Available value is: cs</xsl:message>
</xsl:if>

<document>

<template pageSize="(210mm, 297mm)" leftMargin="20mm" rightMargin="20mm" topMargin="20mm" bottomMargin="20mm" 
    title="Žádost o validaci účtu mojeID"
    author="CZ.NIC"
  >

    <pageTemplate id="main">
      <pageGraphics>
    <!-- Page header -->
        <translate dx="15.5"/>
        <xsl:call-template name="mojeid_logotype_color"/>
        <translate dx="-15.5"/>
        <lineMode width="1"/>
        <stroke color="black"/>
        <fill color="black"/>

        <setFont name="FreeSansBold" size="18"/>
        <drawString x="24mm" y="249mm">Žádost o validaci účtu mojeID</drawString>

        <setFont name="FreeSansBold" size="10"/>
        <drawString x="24mm" y="234mm">Číslo žádosti:</drawString>
        <setFont name="FreeSans" size="10"/>
        <drawString x="64mm" y="234mm"><xsl:value-of select="request_id"/></drawString>

        <setFont name="FreeSansBold" size="10"/>
        <drawString x="24mm" y="230mm">Identifikátor:</drawString>
        <setFont name="FreeSans" size="10"/>
        <drawString x="64mm" y="230mm"><xsl:value-of select="handle"/></drawString>

        <setFont name="FreeSansBold" size="10"/>
        <drawString x="24mm" y="222mm">Validované údaje z účtu mojeID</drawString>

        <setFont name="FreeSansBold" size="10"/>
        <drawString x="24mm" y="214mm">Jméno:</drawString>
        <setFont name="FreeSans" size="10"/>
        <drawString x="64mm" y="214mm"><xsl:value-of select="name"/></drawString>

        <xsl:choose>
            <xsl:when test="string(organization)">  
                <setFont name="FreeSansBold" size="10"/>
                <drawString x="24mm" y="210mm">Organizace:</drawString>
                <setFont name="FreeSans" size="10"/>
                <drawString x="64mm" y="210mm"><xsl:value-of select="organization"/></drawString>

                <drawString x="78mm" y="222mm">(podnikající fyzická osoba/právnická osoba):</drawString>

                <setFont name="FreeSansBold" size="10"/>
                <drawString x="24mm" y="206mm">IČ:</drawString>
                <setFont name="FreeSans" size="10"/>
                <drawString x="64mm" y="206mm"><xsl:value-of select="ic"/></drawString>

                <setFont name="FreeSansBold" size="10"/>
                <drawString x="24mm" y="202mm">Datum narození:</drawString>
                <setFont name="FreeSans" size="10"/>
                <drawString x="64mm" y="202mm"><xsl:value-of select="birth_date"/></drawString>

                <setFont name="FreeSansBold" size="10"/>
                <drawString x="24mm" y="198mm">Sídlo firmy:</drawString>
                <setFont name="FreeSans" size="10"/>
                <drawString x="64mm" y="198mm"><xsl:value-of select="address"/></drawString>

                <!-- TODO - this can gain more space, increase height of the frame -->
                <frame id="body" x1="23mm" y1="70mm" width="166mm" height="110mm" showBoundary="0" />
                <stroke color="gray"/>
                <fill color="gray"/>
                <lines>23mm 188mm 189mm 188mm</lines>
            </xsl:when>
            <xsl:otherwise>
                <setFont name="FreeSansBold" size="10"/>
                <drawString x="24mm" y="210mm">Datum narození:</drawString>
                <setFont name="FreeSans" size="10"/>
                <drawString x="64mm" y="210mm"><xsl:value-of select="birth_date"/></drawString>

                <drawString x="78mm" y="222mm">(fyzická osoba):</drawString>

                <setFont name="FreeSansBold" size="10"/>
                <drawString x="24mm" y="206mm">Trvalé bydliště:</drawString>
                <setFont name="FreeSans" size="10"/>
                <drawString x="64mm" y="206mm"><xsl:value-of select="address"/></drawString>

                <!-- TODO - this can gain more space, increase height of the frame -->
                <frame id="body" x1="23mm" y1="70mm" width="166mm" height="118mm" showBoundary="0" />
                <stroke color="gray"/>
                <fill color="gray"/>
                <lines>23mm 196mm 189mm 196mm</lines>
            </xsl:otherwise>
        </xsl:choose>

    <!-- Page footer -->

        <stroke color="black"/>
        <fill color="black"/>
        <setFont name="FreeSansBold" size="10"/>
        <drawString x="125mm" y="52mm">Zákaznická podpora</drawString>
        <setFont name="FreeSans" size="10"/>
        <drawString x="125mm" y="48mm">CZ.NIC, z.&THINSP;s.&THINSP;p.&THINSP;o.</drawString>
        <drawString x="125mm" y="44mm">Milešovská 1136/5</drawString>
        <drawString x="125mm" y="40mm">130&THINSP;00&EMSP;Praha&NBSP;3</drawString>

        <setFont name="FreeSans" size="8"/>
        <drawString x="18mm" y="19mm">The English version is available at mojeid.cz/application.</drawString>
        <drawString x="18mm" y="13mm">
          <xsl:value-of select="$loc/str[@name='MojeID service is operated by the CZ.NIC Association, an interest association of legal entities, registered in the Associations register']"/>
        </drawString>
        <drawString x="18mm" y="10mm">
          <xsl:value-of select="$loc/str[@name='maintained by the Municipal Court in Prague, File ref.: L 58624.']"/>
        </drawString>

    <!-- Folder marks -->
        <stroke color="gray"/>
        <fill color="gray"/>
        <lines>5mm 99mm 10mm 99mm</lines>
        <lines>200mm 99mm 205mm 99mm</lines>

        <lines>5mm 198mm 10mm 198mm</lines>
        <lines>200mm 198mm 205mm 198mm</lines>

        <stroke color="black"/>
        <fill color="black"/>
      </pageGraphics>
    </pageTemplate>

</template>

<stylesheet>
    <paraStyle name="main" fontName='FreeSans'/>
    <paraStyle name="list" fontName='FreeSans' firstLineIndent="-5mm" leftIndent="10mm" spaceBefore="5mm" alignment="LEFT"/>
    <paraStyle name="clist" fontName='FreeSans' leftIndent="10mm" spaceBefore="2.5mm" alignment="LEFT"/>
</stylesheet>

<story>

<para style="main">
    <b>Žádost o validaci podejte jedním z&NBSP;následujících způsobů:</b>
</para>

<para style="list">
    &CIRCLE;&NBSP;&NBSP;Žádost vytiskněte, opatřete ji <b>úředně ověřeným podpisem</b> a&NBSP;odešlete poštou na
    níže uvedenou adresu.
</para>
<para style="list">
    &CIRCLE;&NBSP;&NBSP;Žádost připojte jako přílohu k&NBSP;e-mailu, ten opatřete <b>uznávaným elektronickým podpisem</b>
    a&NBSP;odešlete na adresu <u><font color="blue">podpora@mojeid.cz</font></u>.
</para>
<para style="list">
    &CIRCLE;&NBSP;&NBSP;Žádost vytiskněte a&NBSP;<b>dostavte se s&NBSP;ní osobně</b> na některé z&NBSP;validačních míst.
    Seznam validačních míst, včetně pracovní doby, najdete na našich stránkách
    <u><font color="blue">mojeid.cz/validace</font></u>.
</para>
<para style="clist">
    Při návštěvě validačního místa si nezapomeňte vzít s&NBSP;sebou doklad totožnosti obsahující adresu
    trvalého pobytu (např. občanský průkaz). Při tomto způsobu ověření z&NBSP;něj pořizujeme částečnou kopii.
</para>
<xsl:choose>
    <xsl:when test="string(organization)">  
        <para style="clist">
            Při validaci účtu právnických osob vezměte s&NBSP;sebou kopii výpisu z&NBSP;obchodního rejstříku,
            žádost o&NBSP;validaci potvrzuje statutární orgán. Při validaci účtu podnikající fyzické osoby vezměte s&NBSP;sebou
            kopii výpisu z&NBSP;živnostenského rejstříku.
        </para>
        <spacer length="22mm"/>
        <para style="main">
            Jméno a&NBSP;podpis odpovědné osoby: &HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;
        </para>
    </xsl:when>
    <xsl:otherwise>
        <spacer length="22mm"/>
        <para style="main">
            Jméno a&NBSP;podpis: &HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;&HELLIP;
        </para>
    </xsl:otherwise>
</xsl:choose>

</story>

</document>
</xsl:template>

</xsl:stylesheet>
