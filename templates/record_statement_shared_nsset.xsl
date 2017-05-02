<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template name="pageDetailNsset">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

    <para style="header"><xsl:value-of select="$loc/str[@name='Nameserver set']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Identifier']"/></td>
        <td><para style="bold"><xsl:value-of select="handle"/></para></td>
      </tr>
      <xsl:for-each select="nameserver_list/nameserver">
        <xsl:call-template name="nameserverListTemplate">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:for-each>
    </blockTable>

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

  <xsl:template name="nameserverListTemplate">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <tr>
      <td><xsl:value-of select="$loc/str[@name='Name server']"/></td>
      <td>
        <xsl:value-of select="fqdn"/> &SPACE; <xsl:for-each
          select="ip_list/ip"><xsl:value-of select="."/><xsl:if test="position() != last()">, </xsl:if></xsl:for-each>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
