<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:include href="shared_templates.xsl"/>

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
            <drawRightString x="62.6mm" y="166.4mm">Uživatelské jméno:</drawRightString>
            <setFont name="AvenirBlack" size="16"/>
            <drawRightString x="62.6mm" y="157mm">PIN3:</drawRightString>
            <frame id="date" x1="20mm" y1="247mm" width="55mm" height="10mm"/>
            <frame id="address" x1="110mm" y1="212mm" width="70mm" height="35mm"/>
            <frame id="pin" x1="80mm" y1="152mm" width="102mm" height="20mm"/>
          </pageGraphics>
        </pageTemplate>
      </template>
      <stylesheet>
        <paraStyle name="username" fontSize="10" fontName="AvenirMedium" leading="20"/>
        <paraStyle name="date" fontSize="10" fontName="AvenirMedium"/>
        <paraStyle name="address-name" fontSize="10" fontName="AvenirBlack"/>
        <paraStyle name="address" fontSize="10" fontName="AvenirMedium"/>
        <paraStyle name="pin3" fontSize="16" fontName="AvenirBlack"/>
      </stylesheet>
      <story>
        <xsl:for-each select="user">
          <para style="date">Praha <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></para>
          <nextFrame/>
          <xsl:call-template name="fillAddress"/>
          <para style="username"><xsl:value-of select="account/username"/></para>
          <para style="pin3"><xsl:value-of select="auth/codes/pin3"/></para>
          <pageBreak/>
        </xsl:for-each>
      </story>
    </document>
  </xsl:template>

</xsl:stylesheet>
