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
    <handle><![CDATA[CID:T1546080]]></handle>
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
    <handle><![CDATA[CID:D1428724]]></handle>
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
  <xsl:param name="lang" select="'cs'"/>
  <xsl:param name="srcpath" select="'templates/'" />
  <!-- TODO use it: -->
  <xsl:param name="listlimit" select="7"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>
  <!-- root template for rml document generation -->

  <xsl:template match="messages">
    <document>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" title="Extension of registration" author="CZ.NIC" showBoundary="0">

        <xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="'cs'"/>
          <xsl:with-param name="templateName" select="'main_cs'"/>
        </xsl:call-template>

        <xsl:call-template name="letterTemplate">
          <xsl:with-param name="lang" select="'en'"/>
          <xsl:with-param name="templateName" select="'main_en'"/>
        </xsl:call-template>
       
        <pageTemplate id="domainList">
           <pageGraphics>
            <!-- TODO eliminate showBoundary -->
            <frame id="main" x1="2.1cm" y1="4.5cm" width="18.0cm" height="21.1cm" showBoundary="0"/>
            <image file="{$srcpath}cz_nic_logo_{$lang}.png" x="2.1cm" y="0.8cm" width="4.2cm"/>
            <stroke color="#C4C9CD"/>
            <lineMode width="0.01cm"/>
            <lines>7.1cm  1.3cm  7.1cm 0.5cm</lines>
            <lines>11.4cm 1.3cm 11.4cm 0.5cm</lines>
            <lines>14.6cm 1.3cm 14.6cm 0.5cm</lines>
            <lines>17.9cm 1.3cm 17.9cm 0.5cm</lines>
            <lineMode width="1"/>
            <fill color="#ACB2B9"/>
            <setFont name="Times-Roman" size="7"/>
            <drawString x="7.3cm" y="1.1cm">
              <xsl:value-of select="$loc/str[@name='CZ.NIC, z.s.p.o.']"/>
            </drawString>
            <drawString x="7.3cm" y="0.8cm">
              <xsl:value-of select="$loc/str[@name='Americka 23, 120 00 Prague 2']"/>
            </drawString>
            <drawString x="7.3cm" y="0.5cm">
              <xsl:value-of select="$loc/str[@name='Czech Republic']"/>
            </drawString>
            <drawString x="11.6cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='T']"/> +420 222 745 111</drawString>
            <drawString x="11.6cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='F']"/> +420 222 745 112</drawString>
            <drawString x="14.8cm" y="1.1cm"><xsl:value-of select="$loc/str[@name='IC']"/> 67985726</drawString>
            <drawString x="14.8cm" y="0.8cm"><xsl:value-of select="$loc/str[@name='DIC']"/> CZ67986726</drawString>
            <drawString x="18.1cm" y="1.1cm">kontakt@nic.cz</drawString>
            <drawString x="18.1cm" y="0.8cm">www.nic.cz</drawString>
          </pageGraphics>
        </pageTemplate>
      </template>

      <stylesheet>
        <paraStyle name="basic" fontName="Times-Roman"/>
        <paraStyle name="main" parent="basic" spaceAfter="0.6cm"/>
        <paraStyle name="address" fontSize="12" fontName="Times-Roman"/>
        <paraStyle name="address-name" parent="address" fontName="Times-Bold"/>

        <blockTableStyle id="domainListTable">
            <blockFont name="Times-Roman" start="0,1" stop="-1,-1" size="9"/> 
            <blockFont name="Times-Bold" start="0,0" stop="-1,0" size="10"/>
            <blockAlignment value="CENTER" start="0,0" stop="-1,-1"/>
            <lineStyle kind="GRID" start="0,0" stop="-1,-1" colorName="black"/>
            <blockTopPadding length="0" start="0,0" stop="-1,-1" />
            <blockBottomPadding length="0" start="0,0" stop="-1,-1" />
            <blockBottomPadding length="0cm" start="0,0" stop="-1,-1" />
        </blockTableStyle>

      </stylesheet>
      <story>
        <xsl:for-each select="holder">

          <xsl:choose>
              <xsl:when test="count(expiring_domain)&lt;=$listlimit">
                  <setNextTemplate name="main_cs"/>
                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="'cs'"/>
                  </xsl:call-template>
                    <xsl:call-template name="domainsTable">
                    </xsl:call-template>

                  <setNextTemplate name="main_en"/>
                  <nextFrame/>
                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="'en'"/>
                  </xsl:call-template>
                  <xsl:call-template name="domainsTable">
                  </xsl:call-template>
              </xsl:when>
              <xsl:otherwise> 

                  <setNextTemplate name="main_cs"/>
                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="'cs'"/>
                  </xsl:call-template>

                  <setNextTemplate name="main_en"/>
                  <nextFrame/>
                  <xsl:call-template name="onePage">
                    <xsl:with-param name="lang" select="'en'"/>
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
    <para style="main"><b><xsl:value-of select="$loc/str[@name='Subject: Extension of registration of']"/></b></para>
    <spacer length="0.5cm"/>
    <para style="main"><xsl:value-of select="$loc/str[@name='Dear Sir or Madam']"/>
</para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='The CZ.NIC z.s.p.o. company, an administrator...']"/>
    </para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='Should you be interested in keeping this domain name...']"/>
    </para>
    <para style="basic" spaceAfter="0.3cm"><xsl:value-of select="$loc/str[@name='Please notice that unless...']"/>&SPACE;<xsl:call-template name="local_date"><xsl:with-param name="sdt" select="termination_date"/></xsl:call-template>&SPACE;<xsl:value-of select="$loc/str[@name='..and made avail...']"/></para>
    <para style="main"><xsl:value-of select="$loc/str[@name='The date of...']"/>
    </para>

    <para style="basic" spaceAfter="0.3cm"><xsl:value-of select="$loc/str[@name='Yours sincerely']"/>
    </para>
    <para style="basic">Ing. Martin Peterka</para>
    <para style="basic" spaceAfter="0.6cm">
      <xsl:value-of select="$loc/str[@name='Operations manager, CZ.NIC, z.s.p.o.']"/>
    </para>

    <para style="main"><b><xsl:value-of select="$loc/str[@name='Attachment']"/></b></para>

  </xsl:template>

  <!-- a table with list of expired domains -->
    <xsl:template name="domainsTable">

        <blockTable style="domainListTable">
           <tr>
                   <td> FQDN </td> 
                   <td> Reg. </td> 
                   <td> Reg. WWW </td>
           </tr>

           <xsl:for-each select="expiring_domain"> 
                <tr>
                   <td> <xsl:value-of select="domain"/> </td>
                   <td> <xsl:value-of select="registrar"/> </td>
                   <td> <xsl:value-of select="registrar_web"/> </td>
                </tr>
           </xsl:for-each>

        </blockTable>
    </xsl:template>

</xsl:stylesheet>
