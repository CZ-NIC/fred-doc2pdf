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
  <message>
   <domain><![CDATA[example.cz]]></domain>
   <registrar><![CDATA[REG-REGISTRAR]]></registrar>
   <actual_date><![CDATA[2007-10-05]]></actual_date>
   <termination_date><![CDATA[2007-10-15]]></termination_date>
   <holder>
    <handle><![CDATA[HOLDER]]></handle>
    <name><![CDATA[Fred & sons]]></name>
    <street><![CDATA[Street 123]]></street>
    <city><![CDATA[Prague]]></city>
    <zip><![CDATA[11100]]></zip>
    <country><![CDATA[CZECH REPUBLIC]]></country>
   </holder>
  </message>
  <message>
   <domain><![CDATA[test.cz]]></domain>
   <registrar><![CDATA[REG-REGISTRAR]]></registrar>
   <actual_date><![CDATA[2007-10-05]]></actual_date>
   <termination_date><![CDATA[2007-10-15]]></termination_date>
   <holder>
    <handle><![CDATA[MY-ID]]></handle>
    <name><![CDATA[Company l.t.d.]]></name>
    <street><![CDATA[Street 123]]></street>
    <city><![CDATA[Berlin]]></city>
    <zip><![CDATA[11100]]></zip>
    <country><![CDATA[GERMANY]]></country>
   </holder>
  </message>    
 </messages>
 
 Resulting RML can be processed by doc2pdf to generate PDF version of letter 
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:param name="lang" select="'cs'"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>
  <!-- root template for rml document generation -->
  <xsl:template match="messages">
    <document>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" title="Extension of registration" author="CZ.NIC">
        <xsl:call-template name="pageTemplate">
          <xsl:with-param name="lang" select="'cs'"/>
          <xsl:with-param name="templateName" select="'main_cs'"/>
        </xsl:call-template>
        <xsl:call-template name="pageTemplate">
          <xsl:with-param name="lang" select="'en'"/>
          <xsl:with-param name="templateName" select="'main_en'"/>
        </xsl:call-template>
        <pageTemplate id="first" pageSize="(29.7cm, 21cm)" leftMargin="1.1cm" rightMargin="1.1cm" topMargin="1.8cm" bottomMargin="1.3cm">
          <pageGraphics>
            <setFont name="Times-Roman" size="12"/>
            <drawString x="1.1cm" y="18.8cm">ODESÍLATEL: <xsl:value-of select="$loc/str[@name='CZ.NIC, z.s.p.o.']"/>, <xsl:value-of select="$loc/str[@name='Americka 23, 120 00 Prague 2']"/></drawString>
            <setFont name="Times-Roman" size="8"/>
            <drawString x="24cm" y="19.6cm">Číslo přílohy</drawString>
            <drawString x="24cm" y="19.3cm">přijímací knihy</drawString>
            <rect x="26.5cm" y="19cm" width="2.1cm" height="1cm" fill="no" stroke="yes"/>
          </pageGraphics>
          <frame id="delivery" x1="0.8cm" y1="0.8cm" width="28cm" height="17.6cm" showBoundary="0"/>
        </pageTemplate>
      </template>
      <stylesheet>
        <paraStyle name="main" spaceAfter="0.6cm" fontName="Times-Roman"/>
        <paraStyle name="address" fontSize="12" fontName="Times-Roman"/>
        <paraStyle name="address-name" parent="address" fontName="Times-Bold"/>
        <blockTableStyle id="tbl_delivery">
          <blockAlignment value="CENTER" start="0,0" stop="5,2"/>
          <blockValign value="BOTTOM" start="0,0" stop="4,2"/>
          <blockValign value="MIDDLE" start="5,0" stop="-1,2"/>
          <blockValign value="MIDDLE" start="0,3" stop="-1,-1"/>
          <blockFont name="Times-Roman" size="8" start="0,0" stop="-1,-1"/>
          <lineStyle kind="GRID" start="0,3" stop="-1,-1" colorName="black"/>
          <lineStyle kind="BOX" start="0,0" stop="-1,2" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="6,0" stop="6,1" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="0,0" stop="4,2" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="8,0" stop="8,2" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="10,0" stop="10,2" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="12,0" stop="12,2" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="5,1" stop="5,1" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="7,1" stop="7,1" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="9,1" stop="9,2" colorName="black"/>
          <lineStyle kind="LINEAFTER" start="11,1" stop="11,2" colorName="black"/>
          <lineStyle kind="LINEBELOW" start="5,0" stop="12,0" colorName="black"/>
          <lineStyle kind="LINEBELOW" start="5,1" stop="12,1" colorName="black"/>
        </blockTableStyle>
        <paraStyle name="th" fontSize="8"/>
      </stylesheet>
      <story>
        <xsl:for-each select="message">
          <!--<story>-->
          <setNextTemplate name="main_cs"/>
          <xsl:call-template name="onePage">
            <xsl:with-param name="lang" select="'cs'"/>
          </xsl:call-template>
          <setNextTemplate name="main_en"/>
          <nextFrame/>
          <xsl:call-template name="onePage">
            <xsl:with-param name="lang" select="'en'"/>
          </xsl:call-template>
          <nextFrame/>
          <!--</story>-->
        </xsl:for-each>
        <!--<story>-->
        <setNextTemplate name="first"/>
        <blockTable colWidths="1.2cm,1.7cm,4.6cm,6cm,4.3cm,1.4cm,0.7cm,0.7cm,1.1cm,1.3cm,0.7cm,1cm,0.7cm,2.1cm" repeatRows="3" style="tbl_delivery">
          <tr>
            <td>Datum</td>
            <td>
              <para style="th">Podací</para>
              <para style="th">číslo</para>
            </td>
            <td>
              <para style="th">Jméno a příjmení adresáta</para>
              <para style="th">(název organizace)</para>
            </td>
            <td>Ulice, číslo domu</td>
            <td>
              <para style="th">Dodací pošta</para>
              <para style="th">(místo určení, PSČ)</para>
            </td>
            <td>Dobírka</td>
            <td/>
            <td>Hmotnost</td>
            <td/>
            <td>
              <para style="th">Udaná cena</para>
              <para style="th">Vplacená částka</para>
            </td>
            <td/>
            <td>Výplatné</td>
            <td/>
            <td>Poznámka</td>
          </tr>
          <tr>
            <td/>
            <td/>
            <td/>
            <td/>
            <td/>
            <td>Kč</td>
            <td>h</td>
            <td>kg</td>
            <td>g</td>
            <td>Kč</td>
            <td>h</td>
            <td>Kč</td>
            <td>h</td>
          </tr>
          <tr>
            <td/>
            <td/>
            <td/>
            <td/>
            <td/>
            <td/>
            <td/>
            <td>Převod:</td>
          </tr>
          <xsl:apply-templates select="/messages/message"/>
        </blockTable>
      </story>
    </document>
  </xsl:template>
  <!-- for automatic generation of two pageTemplate elements (en,cs) parmetrized by language -->
  <xsl:template name="pageTemplate">
    <xsl:param name="templateName" select="main_cs"/>
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <pageTemplate>
      <xsl:attribute name="id">
        <xsl:value-of select="$templateName"/>
      </xsl:attribute>
      <pageGraphics>
        <image file="templates/logo-balls.png" x="2.1cm" y="24cm" width="5.6cm"/>
        <frame id="address" x1="12.5cm" y1="22.6cm" width="7.6cm" height="3cm" showBoundary="0"/>
        <frame id="main" x1="2.1cm" y1="4.5cm" width="16.7cm" height="17.7cm" showBoundary="0"/>
        <image file="templates/cz_nic_logo_{$lang}.png" x="2.1cm" y="0.8cm" width="4.2cm"/>
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
  </xsl:template>
  <!--one page of letter parametrized by language-->
  <xsl:template name="onePage">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <para style="address-name">
      <xsl:value-of select="holder/name"/>
    </para>
    <para style="address">
      <xsl:value-of select="holder/street"/>
    </para>
    <para style="address"><xsl:value-of select="holder/zip"/>&SPACE;<xsl:value-of select="holder/city"/></para>
    <para style="address">
      <xsl:value-of select="holder/country"/>
    </para>
    <nextFrame/>
    <para style="main"><xsl:value-of select="$loc/str[@name='Prague']"/>, <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></para>
    <para style="main"><xsl:value-of select="$loc/str[@name='Subject: Extension of registration of']"/>&SPACE;<xsl:value-of select="domain"/>&SPACE;<xsl:value-of select="$loc/str[@name='domain(subject)']"/></para>
    <spacer length="1.2cm"/>
    <para style="main"><xsl:value-of select="$loc/str[@name='Dear holder of']"/>&SPACE;<xsl:value-of select="domain"/>&SPACE;<xsl:value-of select="$loc/str[@name='domain name']"/>,
</para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='The CZ.NIC z.s.p.o. company, an administrator...']"/>
    </para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='Should you be interested in keeping this domain name...']"/>
    </para>
    <para style="main"><xsl:value-of select="$loc/str[@name='hould the registration of the domain name...']"/>&SPACE;<xsl:call-template name="local_date"><xsl:with-param name="sdt" select="termination_date"/></xsl:call-template>&SPACE;<xsl:value-of select="$loc/str[@name='and the domain name shall be open...']"/></para>
    <para style="main"><xsl:value-of select="$loc/str[@name='The following information was recorded on the CZ.NIC Central database as of the date of issuance of this letter']"/>:
</para>
    <spacer length="0.6cm"/>
    <para><xsl:value-of select="$loc/str[@name='Domain name']"/>: <xsl:value-of select="domain"/></para>
    <para><xsl:value-of select="$loc/str[@name='Holder']"/>: <xsl:value-of select="holder/name"/> (ID: <xsl:value-of select="holder/handle"/>)</para>
    <para><xsl:value-of select="$loc/str[@name='Designated registrar']"/>: <xsl:value-of select="registrar"/></para>
    <para><xsl:value-of select="$loc/str[@name='Date of termination of the registration']"/>: <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="termination_date"/></xsl:call-template></para>
    <spacer length="0.8cm"/>
    <para>Ing. Martin Peterka</para>
    <para>
      <xsl:value-of select="$loc/str[@name='Operations manager, CZ.NIC, z.s.p.o.']"/>
    </para>
  </xsl:template>
  <!-- one row of summary table -->
  <xsl:template match="message">
    <tr>
      <td>
        <xsl:call-template name="short_date">
          <xsl:with-param name="sdt" select="actual_date"/>
        </xsl:call-template>
      </td>
      <td/>
      <td>
        <para>
          <xsl:value-of select="holder/name"/>
        </para>
      </td>
      <td>
        <para>
          <xsl:value-of select="holder/street"/>
        </para>
      </td>
      <td>
        <para><xsl:value-of select="holder/zip"/>&SPACE;<xsl:value-of select="holder/city"/></para>
      </td>
      <td/>
      <td/>
      <td/>
      <td/>
      <td/>
      <td/>
      <td/>
      <td/>
      <td/>
    </tr>
  </xsl:template>
</xsl:stylesheet>
