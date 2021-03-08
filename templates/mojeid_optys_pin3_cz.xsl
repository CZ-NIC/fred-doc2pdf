<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>

  <xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
      <xsl:value-of select='substring($sdt,9,2)'/>.<xsl:value-of select='substring($sdt,6,2)'/>.<xsl:value-of select='substring($sdt,1,4)'/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="contact_auth">
    <document>
      <docinit>
        <registerTTFont faceName="AvenirMedium" fileName="Avenir-Medium-09.ttf"/>
        <registerTTFont faceName="AvenirBlack" fileName="Avenir-Black-03.ttf"/>
        <registerFontFamily normal="AvenirMedium" bold="AvenirBlack"/>
      </docinit>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" title="Oveření adresy pomocí PIN3" author="CZ.NIC">
        <pageTemplate id="main">
          <pageGraphics>
            <setFont name="AvenirMedium" size="10"/>
            <drawRightString x="62mm" y="180mm">Uživatelské jméno:</drawRightString>
            <setFont name="AvenirBlack" size="16"/>
            <drawRightString x="62mm" y="171mm">PIN3:</drawRightString>
            <frame id="date" x1="135mm" y1="254mm" width="55mm" height="10mm"/>
            <frame id="pin" x1="80mm" y1="166mm" width="126mm" height="20mm"/>
          </pageGraphics>
        </pageTemplate>
      </template>
      <stylesheet>
        <paraStyle name="username" fontSize="10" fontName="AvenirMedium" leading="20"/>
        <paraStyle name="date" fontSize="10" fontName="AvenirMedium" alignment="right"/>
        <paraStyle name="pin3" fontSize="16" fontName="AvenirBlack"/>
      </stylesheet>
      <story>
        <xsl:for-each select="user">
          <para style="date">Praha <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></para>
          <para style="username"><xsl:value-of select="account/username"/></para>
          <para style="pin3"><xsl:value-of select="auth/codes/pin3"/></para>
          <pageBreak/>
        </xsl:for-each>
      </story>
    </document>
  </xsl:template>

</xsl:stylesheet>
