<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="lang" select="'cs'"/>
  <xsl:param name="title" select="'CZ.NIC message'"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>

  <!-- root template for rml document generation -->
  <xsl:template match="message">
    <document>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" showBoundary="0">
        <xsl:attribute name="author">
              <xsl:value-of select="$loc/str[@name='NIC_author']"/>
        </xsl:attribute>
        <xsl:attribute name="title">
              <xsl:value-of select="$title"/>
        </xsl:attribute>

        <xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="$lang01"/>
          <xsl:with-param name="templateName" select="concat('notice_correct_', $lang01)"/>
        </xsl:call-template>

        <xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="$lang02"/>
          <xsl:with-param name="templateName" select="concat('notice_correct_', $lang02)"/>
        </xsl:call-template>

      </template>

      <stylesheet>
        <paraStyle name="basic" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="main" parent="basic" spaceAfter="0.6cm" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="address" fontSize="12" fontName="FreeSans"/>
        <paraStyle name="address-name" parent="address" fontName="FreeSansBold"/>
      </stylesheet>

      <story>
        <xsl:for-each select="holder">
          <setNextTemplate>
             <xsl:attribute name="name">
                 <xsl:value-of select="concat('notice_correct_',$lang01)"/>
             </xsl:attribute>
          </setNextTemplate>

          <xsl:call-template name="pageContent">
            <xsl:with-param name="lang" select="$lang01"/>
          </xsl:call-template>

          <setNextTemplate>
             <xsl:attribute name="name">
                 <xsl:value-of select="concat('notice_correct_',$lang02)"/>
             </xsl:attribute>
          </setNextTemplate>
          <nextFrame/>

          <xsl:call-template name="pageContent">
            <xsl:with-param name="lang" select="$lang02"/>
          </xsl:call-template>

        </xsl:for-each>
      </story>
    </document>
  </xsl:template>

</xsl:stylesheet>