<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
    </xsl:if>
</xsl:template>

<xsl:template name="short_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.</xsl:if>
</xsl:template>

<xsl:template name="trim_with_dots">
    <xsl:param name="string"/>
    <xsl:param name="max_length" select="25"/>
    <xsl:choose>
        <xsl:when test="string-length($string)>$max_length">
            <xsl:value-of select="substring($string, 1, $max_length)"/>..</xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$string"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- for automatic generation of two pageTemplate elements (en,cs) parmetrized by language -->
  <xsl:template name="letterTemplate">
    <xsl:param name="templateName" select="main_cs"/>
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <pageTemplate>
      <xsl:attribute name="id">
        <xsl:value-of select="$templateName"/>
      </xsl:attribute>
      <pageGraphics>
        <setFont name="Times-Roman" size="12"/>
        <image file="{$srcpath}logo-balls.png" x="2.1cm" y="24cm" width="5.6cm"/>
        <!--
        <frame id="address" x1="12.5cm" y1="22.6cm" width="7.6cm" height="3cm" showBoundary="0"/>
        -->
        <frame id="address" x1="11.5cm" y1="22.2cm" width="8.6cm" height="4.2cm" showBoundary="0"/>
        <frame id="main" x1="2.1cm" y1="4.5cm" width="16.7cm" height="17.7cm" showBoundary="0"/>
        <image file="{$srcpath}cz_nic_logo_{$lang}.png" x="2.1cm" y="0.8cm" width="4.2cm"/>
        <stroke color="#C4C9CD"/>
        <lineMode width="0.01cm"/>
        <lines>7.1cm  1.3cm  7.1cm 0.5cm</lines>
        <lines>11.4cm 1.3cm 11.4cm 0.5cm</lines>
        <lines>14.6cm 1.3cm 14.6cm 0.5cm</lines>
        <lines>17.9cm 1.3cm 17.9cm 0.5cm</lines>
        <lineMode width="1"/>
        <fill color="#ACB2B9"/>
        <setFont name="Times-Roman" size="7"/>
        <drawString x="7.3cm" y="1.1cm">
          <xsl:value-of select="$loc/str[@name='CZ.NIC, z.s.p.o.']"/>
        </drawString>
        <drawString x="7.3cm" y="0.8cm">
          <xsl:value-of select="$loc/str[@name='Americka 23, 120 00 Prague 2']"/>
        </drawString>
        <drawString x="7.3cm" y="0.5cm">
          <xsl:value-of select="$loc/str[@name='Czech Republic']"/>
        </drawString>
        <drawString x="11.6cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='T']"/> +420 222 745 111</drawString>
        <drawString x="11.6cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='F']"/> +420 222 745 112</drawString>
        <drawString x="14.8cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='IC']"/> 67985726</drawString>
        <drawString x="14.8cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='DIC']"/> CZ67986726</drawString>
        <drawString x="18.1cm" y="1.1cm">kontakt@nic.cz</drawString>
        <drawString x="18.1cm" y="0.8cm">www.nic.cz</drawString>
      </pageGraphics>
    </pageTemplate>
  </xsl:template>

  <!-- default code to fill the address frame, depends on some paraStyle elements defined in document -->
  <xsl:template name="fillAddress">
    <para style="address-name">
        <xsl:call-template name="trim_with_dots">
            <xsl:with-param name="string" select="name"/>
            <xsl:with-param name="max_length" select="50"/>
        </xsl:call-template>
    </para>
    <para style="address-name">
        <xsl:call-template name="trim_with_dots">
            <xsl:with-param name="string" select="organization"/>
            <xsl:with-param name="max_length" select="50"/>
        </xsl:call-template>
    </para>
    <para style="address">
      <xsl:value-of select="street"/>
    </para>
    <para style="address"><xsl:value-of select="postal_code"/>&SPACE;<xsl:value-of select="city"/></para>
    <para style="address">
      <xsl:value-of select="country"/>
    </para>
    <nextFrame/>
  </xsl:template>


</xsl:stylesheet>

