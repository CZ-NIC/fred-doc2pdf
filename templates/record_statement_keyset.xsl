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

    <para style="header"><xsl:value-of select="$loc/str[@name='Key set']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Identifier']"/></td>
        <td><para style="bold"><xsl:value-of select="handle"/></para></td>
      </tr>
    </blockTable>

    <xsl:for-each select="dns_key_list/dns_key">
      <xsl:call-template name="dnsKeyListTemplate">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:for-each>

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Technical contacts']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <xsl:for-each select="tech_contact_list/tech_contact">
        <xsl:call-template name="contactTableRowTemplate">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:for-each>
    </blockTable>

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Sponsoring registrar']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <xsl:for-each select="sponsoring_registrar">
        <xsl:call-template name="contactTableRowTemplate">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:for-each>
    </blockTable>

    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Status']"/></td>
        <td>
          <xsl:for-each select="external_states_list/state">
            <xsl:variable name="stateCode" select="text()"/>
            <para style="basic"><xsl:value-of select="$loc/str[@name=$stateCode]"/></para>
          </xsl:for-each>
        </td>
      </tr>
    </blockTable>

  </xsl:template>

  <xsl:template name="dnsKeyListTemplate">
      <xsl:param name="lang" select="'cs'"/>
      <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
      <para style="small-header"><xsl:value-of select="$loc/str[@name='DNS Key']"/></para>
      <blockTable colWidths="6cm,10.2cm" style="registry_data">
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Flags']"/>:</td>
            <td><xsl:value-of select="flags"/></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Protocol']"/>:</td>
            <td><xsl:value-of select="protocol"/></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Algorithm']"/>:</td>
            <td><xsl:value-of select="algorithm"/></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Key']"/>:</td>
            <td>
                <xsl:call-template name="split_large_string_into_pre">
                    <xsl:with-param name="largeString" select="key"/>
                </xsl:call-template>
            </td>
          </tr>
      </blockTable>
  </xsl:template>

</xsl:stylesheet>
