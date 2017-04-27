<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:param name="title" select="'The Record statement of keyset from the Domain registry .cz'"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:include href="record_statement_shared.xsl"/>
  <xsl:variable name="lang01" select="'cs'"/>
  <xsl:variable name="lang02" select="'en'"/>
  <xsl:param name="lang" select="$lang01"/>

  <xsl:template name="pageDetailKeyset">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

    <para style="main"><xsl:value-of select="$loc/str[@name='Key set']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Identifier']"/></td>
        <td><xsl:value-of select="handle"/></td>
      </tr>
      <xsl:apply-templates select="dns_key_list" />
      <xsl:for-each select="dns_key_list">
        <xsl:call-template name="dnsKeyListTemplate">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:for-each>

    </blockTable>

  </xsl:template>

  <xsl:template name="dnsKeyListTemplate">
      <xsl:param name="lang" select="'cs'"/>
      <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
      <tr>
        <td vAlign="top"><xsl:value-of select="$loc/str[@name='DNS Key']"/></td>
        <td>
          <blockTable colWidths="2.2cm,8cm" style="registry_data_insider">
            <tr>
              <td><xsl:value-of select="$loc/str[@name='Flags']"/>:</td>
              <td><xsl:value-of select="dns_key/flags"/></td>
            </tr>
            <tr>
              <td><xsl:value-of select="$loc/str[@name='Protocol']"/>:</td>
              <td><xsl:value-of select="dns_key/protocol"/></td>
            </tr>
            <tr>
              <td><xsl:value-of select="$loc/str[@name='Algorithm']"/>:</td>
              <td><xsl:value-of select="dns_key/algorithm"/></td>
            </tr>
            <tr>
              <td><xsl:value-of select="$loc/str[@name='Key']"/>:</td>
            </tr>
            <tr>
              <td>
                  <xsl:call-template name="split_large_string_into_pre">
                      <xsl:with-param name="largeString" select="dns_key/key"/>
                  </xsl:call-template>
              </td>
            </tr>
          </blockTable>

        </td>
      </tr>
  </xsl:template>

</xsl:stylesheet>
