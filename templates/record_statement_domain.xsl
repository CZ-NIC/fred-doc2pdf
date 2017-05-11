<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
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
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Registered since']"/></td>
        <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="creation_date" /></xsl:call-template></td>
      </tr>
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Last update date']"/></td>
        <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="last_update_date" /></xsl:call-template></td>
      </tr>
      <tr>
        <td><xsl:value-of select="$loc/str[@name='Expiration date']"/></td>
        <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="expiration_date" /></xsl:call-template></td>
      </tr>
    </blockTable>

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Holder']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
        <tr>
            <td><xsl:value-of select="$loc/str[@name='Handle']"/></td>
            <td><xsl:value-of select="holder/handle"/></td>
        </tr>
        <tr>
            <td><xsl:value-of select="$loc/str[@name='Organization']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="holder/disclose/@organization='true' or holder/@is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="holder/organization"/></para>
                  <xsl:if test="holder/disclose/@organization!='true'">
                    <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
                </xsl:otherwise>
              </xsl:choose>
            </td>
        </tr>
        <tr>
            <td><xsl:value-of select="$loc/str[@name='Name']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="holder/disclose/@name='true' or holder/@is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="holder/name"/></para>
                  <xsl:if test="holder/disclose/@name!='true'">
                    <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
                </xsl:otherwise>
              </xsl:choose>
            </td>
        </tr>
        <tr>
            <td><xsl:value-of select="$loc/str[@name='ICO']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="holder/disclose/@ident='true' or holder/@is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="holder/id_number"/></para>
                  <xsl:if test="holder/disclose/@ident!='true'">
                    <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
                </xsl:otherwise>
              </xsl:choose>
            </td>
        </tr>
        <tr>
            <td><xsl:value-of select="$loc/str[@name='Address']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="holder/disclose/@address='true' or holder/@is_private_printout='true'">
                  <para style="basic">
                    <xsl:value-of select="holder/street1"/>, <xsl:if
                        test="holder/street2/text()"><xsl:value-of select="holder/street2"/>, </xsl:if><xsl:if
                        test="holder/street3/text()"><xsl:value-of select="holder/street3"/>, </xsl:if><xsl:value-of
                        select="holder/postal_code"/> &SPACE; <xsl:value-of select="holder/city"/>, <xsl:if
                        test="holder/stateorprovince"><xsl:value-of select="holder/stateorprovince"/>, </xsl:if><xsl:value-of
                        select="holder/country"/>
                  </para>
                  <xsl:if test="holder/disclose/@address!='true'">
                    <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
                </xsl:otherwise>
              </xsl:choose>
            </td>
        </tr>
    </blockTable>

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Administrative contacts']"/></para>
    <xsl:choose>
      <xsl:when test="admin_contact_list/admin_contact">
        <blockTable colWidths="6cm,10.2cm" style="registry_data">
          <xsl:for-each select="admin_contact_list/admin_contact">
            <xsl:call-template name="contactTableRowTemplate">
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
          </xsl:for-each>
        </blockTable>
      </xsl:when>
      <xsl:otherwise>
        <para style="italic"><xsl:value-of select="$loc/str[@name='Unassigned']"/></para>
      </xsl:otherwise>
    </xsl:choose>

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Sponsoring registrar']"/></para>
    <blockTable colWidths="6cm,10.2cm" style="registry_data">
      <xsl:for-each select="sponsoring_registrar">
        <xsl:call-template name="contactTableRowTemplate">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:for-each>
    </blockTable>

    <para style="small-header"><xsl:value-of select="$loc/str[@name='Domain object states']"/></para>
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

    <xsl:choose>
        <xsl:when test="nsset/handle">
          <xsl:for-each select="nsset">
            <xsl:call-template name="pageDetailNsset">
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <para style="header"><xsl:value-of select="$loc/str[@name='Nameserver set']"/></para>
          <para style="italic"><xsl:value-of select="$loc/str[@name='Unassigned']"/></para>
        </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
        <xsl:when test="keyset/handle">
          <xsl:for-each select="keyset">
            <xsl:call-template name="pageDetailKeyset">
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <para style="header"><xsl:value-of select="$loc/str[@name='Key set']"/></para>
          <para style="italic"><xsl:value-of select="$loc/str[@name='Unassigned']"/></para>
        </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
