<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:param name="title" select="'The Record statement of contact from the Domain registry .cz'"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:include href="record_statement_shared.xsl"/>

  <xsl:template name="pageDetailContact">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <para style="header"><xsl:value-of select="$loc/str[@name='Contact from the Domain registry']"/></para>
    <xsl:choose>
      <xsl:when test="external_states_list/state/text()='linked' or @is_private_printout='true'">
        <!-- Linked contact -->
        <blockTable colWidths="6cm,10.2cm" style="registry_data">
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Identifier']"/></td>
            <td><para style="bold"><xsl:value-of select="handle"/></para></td>
          </tr>
          <tr>
              <td><xsl:value-of select="$loc/str[@name='Organization']"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="disclose/@organization='true' or @is_private_printout='true'">
                    <para style="basic"><xsl:value-of select="organization"/></para>
                    <xsl:if test="disclose/@organization!='true'">
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
                  <xsl:when test="disclose/@name='true' or @is_private_printout='true'">
                    <para style="basic"><xsl:value-of select="name"/></para>
                    <xsl:if test="disclose/@name!='true'">
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
              <td><xsl:value-of select="$loc/str[@name='TID']"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="disclose/@vat='true' or @is_private_printout='true'">
                    <para style="basic"><xsl:value-of select="taxpayer_id_number"/></para>
                    <xsl:if test="disclose/@vat!='true'">
                      <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
          </tr>
          <xsl:if test="id_type/text()">
            <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="disclose/@ident='true' or @is_private_printout='true'">
                      <para style="basic">
                        <xsl:variable name="idTypeText" select="id_type/text()"/>
                        <xsl:value-of select="$loc/str[@name=$idTypeText]"/>
                      </para>
                      <xsl:if test="disclose/@ident!='true'">
                        <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <para style="italic"><xsl:value-of select="$loc/str[@name='Identification detail']"/></para>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="disclose/@ident='true' or @is_private_printout='true'">
                      <para style="basic">
                        <xsl:choose>
                            <xsl:when test="id_type = 'BIRTHDAY'">
                                <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="id_value" /></xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="id_value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                      </para>
                      <xsl:if test="disclose/@ident!='true'">
                        <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
            </tr>
          </xsl:if>
        </blockTable>

        <para style="small-header"><xsl:value-of select="$loc/str[@name='Contact information']"/></para>
        <blockTable colWidths="6cm,10.2cm" style="registry_data">
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Email']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="disclose/@email='true' or @is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="email"/></para>
                  <xsl:if test="disclose/@email!='true'">
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
            <td><xsl:value-of select="$loc/str[@name='Notify email']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="disclose/@notifyemail='true' or @is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="notification_email"/></para>
                  <xsl:if test="disclose/@notifyemail!='true'">
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
            <td><xsl:value-of select="$loc/str[@name='Phone']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="disclose/@telephone='true' or @is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="phone"/></para>
                  <xsl:if test="disclose/@telephone!='true'">
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
            <td><xsl:value-of select="$loc/str[@name='Fax']"/></td>
            <td>
              <xsl:choose>
                <xsl:when test="disclose/@fax='true' or @is_private_printout='true'">
                  <para style="basic"><xsl:value-of select="fax"/></para>
                  <xsl:if test="disclose/@fax!='true'">
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
                  <xsl:when test="disclose/@address='true' or @is_private_printout='true'">
                    <para style="basic">
                      <xsl:value-of select="address/street1"/>, <xsl:if
                          test="address/street2/text()"><xsl:value-of select="address/street2"/>, </xsl:if><xsl:if
                          test="address/street3/text()"><xsl:value-of select="address/street3"/>, </xsl:if><xsl:value-of
                          select="address/postal_code"/> &SPACE; <xsl:value-of select="address/city"/>, <xsl:if
                          test="address/stateorprovince"><xsl:value-of select="address/stateorprovince"/>, </xsl:if><xsl:value-of
                          select="address/country"/>
                    </para>
                    <xsl:if test="disclose/@address!='true'">
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

        <para style="small-header"><xsl:value-of select="$loc/str[@name='Data in the registry']"/></para>
        <blockTable colWidths="6cm,10.2cm" style="registry_data">
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Registered since']"/></td>
            <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="creation_date" /></xsl:call-template></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Last update date']"/></td>
            <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="last_update_date" /></xsl:call-template></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Last transfer date']"/></td>
            <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="last_transfer_date" /></xsl:call-template></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Sponsoring registrar']"/></td>
            <td>
                <xsl:value-of select="sponsoring_registrar/handle"/>
                <xsl:if test="sponsoring_registrar/name">, <xsl:value-of select="sponsoring_registrar/name"/></xsl:if>
                <xsl:if test="sponsoring_registrar/organization">, <xsl:value-of select="sponsoring_registrar/organization"/></xsl:if>
            </td>
          </tr>
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
          <xsl:when test="external_states_list/state/text()='linked'"/>
          <xsl:otherwise>
            <para style="small-header"><xsl:value-of select="$loc/str[@name='The contact has not currently a relation to other records in the registry, so only the Contact Identifier and the Designated Registrar are disclosed.']"/></para>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>

        <!-- Not linked contact -->
        <blockTable colWidths="6cm,10.2cm" style="registry_data">
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Identifier']"/></td>
            <td><para style="bold"><xsl:value-of select="handle"/></para></td>
          </tr>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Sponsoring registrar']"/></td>
            <td>
                <xsl:value-of select="sponsoring_registrar/handle"/>
                <xsl:if test="sponsoring_registrar/name">, <xsl:value-of select="sponsoring_registrar/name"/></xsl:if>
                <xsl:if test="sponsoring_registrar/organization">, <xsl:value-of select="sponsoring_registrar/organization"/></xsl:if>
            </td>
          </tr>
        </blockTable>
        <para style="small-header"><xsl:value-of select="$loc/str[@name='The contact has not currently a relation to other records in the registry, so its other data are not public.']"/></para>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
