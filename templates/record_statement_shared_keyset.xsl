<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

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

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Keyset object states']"/></para>
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
            <td>
              <xsl:value-of select="flags"/>
              <xsl:call-template name="dnsKeyFlagDescriptionTemplate">
                <xsl:with-param name="flags" select="flags" />
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Protocol']"/>:</td>
            <td>
              <xsl:value-of select="protocol"/>
              <xsl:call-template name="dnsKeyProtocolDescriptionTemplate">
                <xsl:with-param name="protocol" select="protocol" />
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Algorithm']"/>:</td>
            <td>
              <xsl:value-of select="algorithm"/>
              <xsl:call-template name="dnsKeyAlgDescriptionTemplate">
                <xsl:with-param name="alg" select="algorithm" />
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Key']"/>:</td>
            <td>
                <pre style="largeStringMono">
                    <xsl:call-template name="split_large_string">
                        <xsl:with-param name="largeString" select="key"/>
                        <xsl:with-param name="numOfLetters" select="59"/>
                    </xsl:call-template>
                </pre>
            </td>
          </tr>
      </blockTable>
  </xsl:template>

  <xsl:template name="dnsKeyProtocolDescriptionTemplate">
      <!--
        https://www.iana.org/assignments/dns-key-rr/dns-key-rr.xhtml
             1  Reserved
             2  Reserved
             3  DNSSEC
             4  Reserved
         5-254  Unassigned
           255  Reserved
      -->
      <xsl:param name="lang" select="'cs'"/>
      <xsl:param name="protocol"/>
      <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>, <xsl:if
        test="$protocol = 1 or $protocol = 2 or $protocol = 4 or $protocol = 255"><xsl:value-of select="$loc/str[@name='Reserved']"/></xsl:if><xsl:if
        test="$protocol = 3">DNSSEC</xsl:if><xsl:if
        test="$protocol &gt;= 5 and $protocol &lt;= 254"><xsl:value-of select="$loc/str[@name='Unassigned']"/></xsl:if>
  </xsl:template>

  <xsl:template name="dnsKeyAlgDescriptionTemplate">
      <!--
        https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml
      -->
      <xsl:param name="lang" select="'cs'"/>
      <xsl:param name="alg"/>
      <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>, <xsl:choose>
          <xsl:when test="$alg &gt;= 17 and $alg &lt;= 122">
              <xsl:value-of select="$loc/str[@name='Unassigned']"/>
          </xsl:when>
          <xsl:when test="$alg &gt;= 123 and $alg &lt;= 251">
              <xsl:value-of select="$loc/str[@name='Reserved']"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="$loc/str[@name=concat('dns_alg_', $alg)]"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="dnsKeyFlagDescriptionTemplate">
      <!--
        https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml
      -->
      <xsl:param name="lang" select="'cs'"/>
      <xsl:param name="flags"/>
      <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/><xsl:if
        test="($flags mod 512) - ($flags mod 256)">, ZONE</xsl:if><xsl:if
        test="($flags mod 256) - ($flags mod 128)">, REVOKE</xsl:if><xsl:if
        test="$flags mod 2">, Secure Entry Point (SEP)</xsl:if>
  </xsl:template>

</xsl:stylesheet>
