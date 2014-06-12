<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!-- 
 Generate RML document containing letters with warning about domain expiration
 in czech and english version for each domain and final summary table for
 czech post office.
 
 Input of this XSL stylesheet is XML document with a list of domains and 
 domains details. Sample of input document:
 <messages>
  <holder>
    <name><![CDATA[Pepa Zdepa]]></name>
    <street><![CDATA[Ulice]]></street>
    <city><![CDATA[Praha]]></city>
    <zip><![CDATA[12300]]></zip>
    <country><![CDATA[CZECH REPUBLIC]]></country>
    <expiring_domain>
      <domain><![CDATA[5.7.2.2.0.2.4.e164.arpa]]></domain>
      <registrar><![CDATA[Company l.t.d. (www.nic.cz)]]></registrar>
      <actual_date><![CDATA[2010-05-11]]></actual_date>
      <termination_date><![CDATA[2011-06-11 00:00:00]]></termination_date>
    </expiring_domain>
  </holder>
  <holder>
    <name><![CDATA[Pepa Zdepa]]></name>
    <street><![CDATA[Ulice]]></street>
    <city><![CDATA[Praha]]></city>
    <zip><![CDATA[12300]]></zip>
    <country><![CDATA[CZECH REPUBLIC]]></country>
    <expiring_domain>
      <domain><![CDATA[tmp535521.cz]]></domain>
      <registrar><![CDATA[Company l.t.d. (www.nic.cz)]]></registrar>
      <actual_date><![CDATA[2010-05-11]]></actual_date>
      <termination_date><![CDATA[2011-06-11 00:00:00]]></termination_date>
    </expiring_domain>
    <expiring_domain>
      <domain><![CDATA[tmp691334.cz]]></domain>
      <registrar><![CDATA[Company l.t.d. (www.nic.cz)]]></registrar>
      <actual_date><![CDATA[2010-05-11]]></actual_date>
      <termination_date><![CDATA[2011-06-11 00:00:00]]></termination_date>
    </expiring_domain>
  </holder>
 </messages>
 
 Resulting RML can be processed by doc2pdf to generate PDF version of letter 
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:variable name="lang01" select="'cs'"/>
  <xsl:variable name="lang02" select="'en'"/>
  <xsl:param name="lang" select="$lang01"/>

  <!-- this is very fragile and depends on whole formatting of the document - we must be sure that the table fits within the actual page, otherwise it has to be placed on the extra pages -->
  <xsl:param name="listlimit" select="2"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>
  <!-- root template for rml document generation -->

  <xsl:template match="messages">
    <document>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" title="Extension of registration" showBoundary="0">
        <xsl:attribute name="author">
              <xsl:value-of select="$loc/str[@name='NIC_author']"/>
        </xsl:attribute>

        <xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="$lang01"/>
          <xsl:with-param name="templateName" select="concat('main_', $lang01)"/>
        </xsl:call-template>

        <xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="$lang02"/>
          <xsl:with-param name="templateName" select="concat('main_', $lang02)"/>
        </xsl:call-template>
       
        <pageTemplate id="domainList">
           <pageGraphics>

            <translate dx="9.2"/>
            <xsl:call-template name="cznic_logo"><xsl:with-param name="lang" select="'cs'"/></xsl:call-template>
            <translate dx="-9.2"/>

            <frame id="main" x1="2.1cm" y1="4.5cm" width="16.7cm" height="21.1cm" showBoundary="0"/>

            <translate dx="10"/>
            <xsl:call-template name="footer_text"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
            <translate dx="-10"/>
            <xsl:call-template name="footer"/>
          </pageGraphics>
        </pageTemplate>
      </template>

      <stylesheet>
        <paraStyle name="basic" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="main" parent="basic" spaceAfter="0.6cm" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="address" fontSize="12" fontName="FreeSans"/>
        <paraStyle name="address-name" parent="address" fontName="FreeSansBold"/>
        <paraStyle name="tableItem" leading="10" fontName="Courier" fontSize="7"/>
        <paraStyle name="tableHead" leading="10" fontName="FreeSansBold" fontSize="9"/>

        <blockTableStyle id="domainListTable">
            <blockAlignment value="CENTER" start="0,0" stop="-1,-1"/>
            <lineStyle kind="GRID" start="0,0" stop="-1,-1" colorName="black"/>
            <blockTopPadding length="2mm" start="0,0" stop="-1,-1" />
            <blockBottomPadding length="1mm" start="0,0" stop="-1,-1" />
        </blockTableStyle>

      </stylesheet>
      <story>
        <xsl:for-each select="holder">

          <xsl:choose>
              <xsl:when test="count(expiring_domain)&lt;=$listlimit">
                  <setNextTemplate>
                     <xsl:attribute name="name">
                         <xsl:value-of select="concat('main_',$lang01)"/>
                     </xsl:attribute>
                  </setNextTemplate>

                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="$lang01"/>
                  </xsl:call-template>
                    <xsl:call-template name="domainsTable">
                    </xsl:call-template>

                  <setNextTemplate>
                     <xsl:attribute name="name">
                         <xsl:value-of select="concat('main_',$lang02)"/>
                     </xsl:attribute>
                  </setNextTemplate>

                  <nextFrame/>
                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="$lang02"/>
                  </xsl:call-template>
                  <xsl:call-template name="domainsTable">
                  </xsl:call-template>
              </xsl:when>
              <xsl:otherwise> 

                  <setNextTemplate>
                     <xsl:attribute name="name">
                         <xsl:value-of select="concat('main_',$lang01)"/>
                     </xsl:attribute>
                  </setNextTemplate>

                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="$lang01"/>
                  </xsl:call-template>

                  <setNextTemplate>
                     <xsl:attribute name="name">
                         <xsl:value-of select="concat('main_',$lang02)"/>
                     </xsl:attribute>
                  </setNextTemplate>

                  <nextFrame/>
                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="$lang02"/>
                  </xsl:call-template>

                  <setNextTemplate name="domainList"/> 

                  <nextFrame/>
                    <xsl:call-template name="domainsTable">
                    </xsl:call-template>
                  <nextFrame/>
              </xsl:otherwise> 
          </xsl:choose>

            <!-- <setNextTemplate name="domainList"/> -->

        </xsl:for-each>
      </story>
    </document>
  </xsl:template>

  <!--one page of letter parametrized by language-->
  <xsl:template name="onePage">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <xsl:call-template name="fillAddress"> 
    </xsl:call-template>

    <para style="main"><xsl:value-of select="$loc/str[@name='Prague']"/>, <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></para>
    <para style="main"><b><xsl:value-of select="$loc/str[@name='Extension of registration of']"/></b></para>
    <spacer length="0.2cm"/>
    <para style="main"><xsl:value-of select="$loc/str[@name='Dear Sir or Madam']"/>
</para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='warning01']"/>
    </para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='warning02']"/>
      <b> <xsl:value-of select="$loc/str[@name='warning03']"/> </b>
      <xsl:value-of select="$loc/str[@name='warning04']"/>

    </para>
    <!-- Please notice ... -->
    <para style="basic" spaceAfter="0.3cm">

        <xsl:value-of select="$loc/str[@name='warning05']"/>
        <b>
        <xsl:value-of select="$loc/str[@name='warning06']"/>
        &SPACE;
        <xsl:call-template name="local_date">
            <xsl:with-param name="sdt" select="termination_date"/>
        </xsl:call-template>
        </b>
        &SPACE;
        <b><xsl:value-of select="$loc/str[@name='warning07']"/></b>
        <xsl:value-of select="$loc/str[@name='warning08']"/>
    </para>

    <para style="main"><xsl:value-of select="$loc/str[@name='The date of...']"/>
    </para>

    <para style="basic" spaceAfter="0.3cm"><xsl:value-of select="$loc/str[@name='Yours sincerely']"/>
    </para>
    <para style="basic">
        <xsl:value-of select="$loc/str[@name='Operations manager name']"/>
    </para>
    <para style="basic" spaceAfter="0.6cm">
      <xsl:value-of select="$loc/str[@name='Operations manager, CZ.NIC, z. s. p. o.']"/>
    </para>

    <para style="main"><b><xsl:value-of select="$loc/str[@name='Attachment']"/></b></para>

  </xsl:template>

  <!-- a table with list of expired domains -->
    <xsl:template name="domainsTable">

        <blockTable repeatRows="1" colWidths="6cm,4.5cm,5.8cm" style="domainListTable">
           <tr>
               <td><para style="tableHead">Domain / Doména</para></td>
               <td><para style="tableHead">Registrar / Registrátor</para></td>
               <td><para style="tableHead">Registrar web / Web registrátora</para></td>
           </tr>

           <xsl:for-each select="expiring_domain"> 
                <tr>
                    <td> 
                      <para style="tableItem">
                        <xsl:choose>
                            <xsl:when test="string-length(domain)&gt;41">
                                <xsl:value-of select="substring(domain,1,41)"/>&SPACE;<xsl:value-of select="substring(domain,42)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="domain"/>
                            </xsl:otherwise>
                        </xsl:choose>
                      </para>
                    </td>
                    <td> 
                        <para style="tableItem">
                        <xsl:value-of select="registrar"/>
                        </para>
                    </td>
                    <td> 
                      <para style="tableItem">
                        <xsl:choose>
                            <xsl:when test="string-length(registrar_web)&gt;30">
                                <xsl:value-of select="substring(registrar_web,1,30)"/>&SPACE;<xsl:value-of select="substring(registrar_web,31)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="registrar_web"/>
                            </xsl:otherwise>
                        </xsl:choose>
                      </para>
                    </td>
                </tr>
           </xsl:for-each>

        </blockTable>
    </xsl:template>

</xsl:stylesheet>
