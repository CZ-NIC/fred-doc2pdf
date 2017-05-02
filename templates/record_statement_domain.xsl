<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:param name="title" select="'The Record statement of domain from the Domain registry .cz'"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:include href="record_statement_shared.xsl"/>
  <xsl:include href="record_statement_shared_nsset.xsl"/>
  <xsl:include href="record_statement_shared_keyset.xsl"/>

  <xsl:template name="pageDetailDomain">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <para style="header"><xsl:value-of select="$loc/str[@name='Domain']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Identifier']"/></td>
        <td><para style="bold"><xsl:value-of select="fqdn"/></para></td>
      </tr>
    </blockTable>

    <xsl:for-each select="nsset">
      <xsl:call-template name="pageDetailNsset">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="keyset">
      <xsl:call-template name="pageDetailKeyset">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
