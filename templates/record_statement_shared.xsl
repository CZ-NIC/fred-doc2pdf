<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="lang" select="'cs'"/>
  <xsl:param name="title" select="'The Record statement from the Domain registry .cz'"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>

  <xsl:template match="record_statement">
    <document>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" showBoundary="0">
        <xsl:attribute name="author">
              <xsl:value-of select="$loc/str[@name='NIC_author']"/>
        </xsl:attribute>
        <xsl:attribute name="title">
              <xsl:value-of select="$title"/>
        </xsl:attribute>

        <xsl:call-template name="recordStatementTemplate">
          <xsl:with-param name="lang" select="$lang01"/>
          <xsl:with-param name="templateName" select="concat('record_statement_', $lang01)"/>
        </xsl:call-template>

        <xsl:call-template name="recordStatementTemplate">
          <xsl:with-param name="lang" select="$lang02"/>
          <xsl:with-param name="templateName" select="concat('record_statement_', $lang02)"/>
        </xsl:call-template>

      </template>

      <stylesheet>
        <paraStyle name="basic" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="main" parent="basic" spaceAfter="0.6cm" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="page-header" parent="main" fontSize="16" spaceAfter="0.6cm" fontName="FreeSansBold"/>
      </stylesheet>

      <story>
          <setNextTemplate>
             <xsl:attribute name="name">
                 <xsl:value-of select="concat('record_statement_',$lang01)"/>
             </xsl:attribute>
          </setNextTemplate>

          <xsl:call-template name="pageRecordStatement">
            <xsl:with-param name="lang" select="$lang01"/>
          </xsl:call-template>

          <setNextTemplate>
             <xsl:attribute name="name">
                 <xsl:value-of select="concat('record_statement_',$lang02)"/>
             </xsl:attribute>
          </setNextTemplate>
          <nextFrame/>

          <xsl:call-template name="pageRecordStatement">
            <xsl:with-param name="lang" select="$lang02"/>
          </xsl:call-template>
      </story>
    </document>
  </xsl:template>

  <xsl:template name="recordStatementTemplate">
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
        <frame id="main" x1="2.1cm" y1="5.2cm" width="16.7cm" height="22cm" showBoundary="0"/>
        <translate dx="9"/>
        <xsl:call-template name="footer_text"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
        <translate dx="-9"/>
        <xsl:call-template name="footer"/>
      </pageGraphics>
    </pageTemplate>
  </xsl:template>

  <xsl:template name="pageRecordStatement">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

    <para style="page-header"><xsl:value-of select="$loc/str[@name='The Record statement from the Domain registry .cz']"/></para>
    <para style="main"><xsl:value-of select="$loc/str[@name='These data are valid for']"/>
      &SPACE;
      <xsl:call-template name="localized_datetime"><xsl:with-param name="lang" select="$lang"/><xsl:with-param name="sdt" select="current_datetime" /></xsl:call-template>
    </para>

    <xsl:for-each select="keyset">
      <xsl:call-template name="pageDetailKeyset">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>