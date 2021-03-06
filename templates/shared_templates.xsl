<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
<!ENTITY EMSPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
<!ENTITY ENTER "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
</xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:func="http://exslt.org/functions" extension-element-prefixes="func"
  xmlns:cznic="http://nic.cz/xslt/functions">

<xsl:import href="cznic_design.xsl"/>
<xsl:include href="utilities.xsl"/>

<xsl:template name="local_date">
    <!--
        Localize only 'sdt' value in format: "2017-04-18T16:12:00,123123135+02:00". Other formats leave unchanged.
    -->
    <xsl:param name="sdt"/>
    <xsl:choose>
        <!-- Function matches() is availabe only from version XSLT 2.0. -->
        <xsl:when test='substring(translate($sdt, "0123456789", "NNNNNNNNNN"), 0, 11) = "NNNN-NN-NN"'>
            <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$sdt"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="localized_datetime">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:param name="sdt"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <xsl:if test="string-length($sdt)>0">
        <xsl:if test="$lang='en'">
            <xsl:value-of select='substring($sdt, 9, 2)' />/<xsl:value-of select='substring($sdt, 6, 2)' />/<xsl:value-of select='substring($sdt, 1, 4)' />
        </xsl:if>
        <xsl:if test="$lang='cs'">
            <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
        </xsl:if>
        &SPACE; <xsl:value-of select='substring($sdt, 12, 8)' /> &SPACE;
        <xsl:if test="substring($sdt, string-length($sdt)-5, 6)='+01:00'">
            <xsl:value-of select="$loc/str[@name='CET']"/>
        </xsl:if>
        <xsl:if test="substring($sdt, string-length($sdt)-5, 6)='+02:00'">
            <xsl:value-of select="$loc/str[@name='CEST']"/>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="text()" name="split_large_string">
  <xsl:param name="largeString"/>
  <xsl:param name="numOfLetters" select="56"/>
    <xsl:if test="string-length($largeString) > 0">
      <xsl:value-of select="substring($largeString, 0, $numOfLetters)"/>&ENTER;
      <xsl:call-template name="split_large_string">
        <xsl:with-param name="largeString" select="substring($largeString, $numOfLetters)"/>
        <xsl:with-param name="numOfLetters" select="$numOfLetters"/>
      </xsl:call-template>
   </xsl:if>
 </xsl:template>

<xsl:template name="trim_with_dots">
    <xsl:param name="string"/>
    <xsl:param name="max_length" select="25"/>
    <xsl:choose>
        <xsl:when test="string-length($string)>$max_length">
            <xsl:value-of select="substring($string, 1, $max_length)"/>…</xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$string"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- for automatic generation of two pageTemplate elements (en,cs) parmetrized by language -->
  <xsl:template name="mojeIDTemplate">
    <xsl:param name="templateName" select="main_cs"/>
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <pageTemplate>
      <xsl:attribute name="id">
        <xsl:value-of select="$templateName"/>
      </xsl:attribute>
      <pageGraphics>
        <xsl:call-template name="mojeid_logotype_gray"/>
        <frame id="address" x1="11.2cm" y1="22cm" width="8.6cm" height="5.0cm" showBoundary="0"/>
        <frame id="main" x1="1.6cm" y1="3.9cm" width="18cm" height="20cm" showBoundary="0"/>

        <stroke color="black"/>
        <fill color="#000000"/>
        <setFont name="FreeSans" size="8"/>
        <drawString x="1.8cm" y="3.3cm">
          <xsl:value-of select="$loc/str[@name='MojeID service is operated by the CZ.NIC Association, an interest association of legal entities, registered in the Associations register']"/>
        </drawString>
        <drawString x="1.8cm" y="2.9cm">
          <xsl:value-of select="$loc/str[@name='maintained by the Municipal Court in Prague, File ref.: L 58624.']"/>
        </drawString>

      </pageGraphics>
    </pageTemplate>
  </xsl:template>

<!-- for automatic generation of two pageTemplate elements (en,cs) parmetrized by language -->
  <xsl:template name="contactTemplate">
    <xsl:param name="templateName" select="main_cs"/>
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <pageTemplate>
      <xsl:attribute name="id">
        <xsl:value-of select="$templateName"/>
      </xsl:attribute>
      <pageGraphics>
        <frame id="address" x1="11.2cm" y1="22cm" width="8.6cm" height="5.0cm" showBoundary="0"/>
        <frame id="main" x1="1.6cm" y1="3.7cm" width="18cm" height="17.2cm" showBoundary="0"/>
        <stroke color="black"/>
        <fill color="#000000"/>
        <setFont name="FreeSans" size="8"/>
        <drawString x="1.8cm" y="3.3cm">
          <xsl:value-of select="$loc/str[@name='contact verification service is operated by the CZ.NIC Association, an interest association of legal entities, registered in Registry of legal entities']"/>
        </drawString>
        <drawString x="1.8cm" y="2.9cm">
          <xsl:value-of select="$loc/str[@name='at the Department of Civil Administration of the Municipal Council of Prague, nr. ZS 30/3/98.']"/>
        </drawString>
      </pageGraphics>
    </pageTemplate>
  </xsl:template>

  <xsl:template name="letterTemplate">
    <xsl:param name="templateName" select="main_cs"/>
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <pageTemplate>
      <xsl:attribute name="id">
        <xsl:value-of select="$templateName"/>
      </xsl:attribute>
      <pageGraphics>
        <setFont name="FreeSans" size="12"/>

        <translate dx="9.2"/>
        <xsl:call-template name="cznic_logo"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
        <translate dx="-9.2"/>
        <frame id="address" x1="11.2cm" y1="22cm" width="8.6cm" height="5.0cm" showBoundary="0"/>
        <frame id="main" x1="2.1cm" y1="4.5cm" width="16.7cm" height="17.7cm" showBoundary="0"/>
        <translate dx="9"/>
        <xsl:call-template name="footer_text"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
        <translate dx="-9"/>
        <xsl:call-template name="footer"/>
      </pageGraphics>
    </pageTemplate>
  </xsl:template>

  <!-- default code to fill the address frame, depends on some paraStyle elements defined in document -->
  <xsl:template name="fillAddress">
    <xsl:param name="recomandee" select="'no'"/>

    <para style="address-name">
        <xsl:call-template name="trim_with_dots">
            <xsl:with-param name="string" select="name"/>
            <xsl:with-param name="max_length" select="45"/>
        </xsl:call-template>
    </para>
    <xsl:if test="name!=organization">
        <para style="address-name">
            <xsl:call-template name="trim_with_dots">
                <xsl:with-param name="string" select="organization"/>
                <xsl:with-param name="max_length" select="45"/>
            </xsl:call-template>
        </para>
    </xsl:if>
    <para style="address">
      <xsl:value-of select="street"/>
    </para>
    <para style="address"><xsl:value-of select="postal_code"/>&EMSPACE;<xsl:value-of select="city"/><xsl:if test="string-length(normalize-space(stateorprovince))&gt;0">,&SPACE;<xsl:value-of select="stateorprovince"/></xsl:if> </para>

    <xsl:choose>
        <xsl:when test="cznic:country_is_czech_republic(country)">
        </xsl:when>
        <xsl:otherwise>
            <para style="address">
              <xsl:value-of select="country"/>
            </para>
        </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$recomandee='yes' and cznic:country_is_czech_republic(country)"><para style="address" spaceBefore="0.3cm"><b>DOPORUČENĚ S DODEJKOU DO VLASTNÍCH RUKOU ADRESÁTA</b></para></xsl:if>

    <nextFrame/>
  </xsl:template>


</xsl:stylesheet>

