<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
<!ENTITY EMSPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!-- 
 Generate RML document containing letters with warning about domain expiration
 in czech and english version for each domain and final summary table for
 czech post office.
 
 Input of this XSL stylesheet is XML document with a list of domains and 
 domains details. Sample of input document:

<?xml version="1.0" encoding="utf-8"?>
<contact_auth>
    <user>
        <actual_date>2010-10-06</actual_date>

        <name>Adam Adminovič</name>
        <organization>International Trade Ltd.</organization>
        <street>Nábřežní 14/456</street>
        <city>Praha</city>
        <stateorprovince>Praha - hl. město</stateorprovince>
        <postal_code>120 00</postal_code>
        <country>Česká republika</country>
        
        <account>
            <username>admin</username>
            <first_name>Adam</first_name>
            <last_name>Adminovič</last_name>
            <email>admin@nic.cz</email>
        </account>
        <auth>
            <codes>
                <pin2>2222222</pin2>
                <pin3>3333333</pin3>
            </codes>
            <link>http://demo.mojeid.cz/identity/</link>
        </auth>
    </user>
</contact_auth>
 
 Resulting RML can be processed by doc2pdf to generate PDF version of letter 
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:variable name="lang01" select="'cs'"/>
  <xsl:variable name="lang02" select="'en'"/>
  <xsl:param name="lang" select="$lang01"/>

  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>
  <xsl:variable name="mojeid_loc" select="document(concat('mojeid_translation_', $lang, '.xml'))/strings"></xsl:variable>

  <xsl:template match="contact_auth">
    <document>
    <docinit>
        <registerTTFont faceName="FreeSans" fileName="FreeSans.ttf"/>
        <registerTTFont faceName="FreeSansBold" fileName="FreeSansBold.ttf"/>
        <registerTTFont faceName="FreeSansBoldItalic" fileName="FreeSansBoldOblique.ttf"/>
        <registerTTFont faceName="FreeSansItalic" fileName="FreeSansOblique.ttf"/>
        <registerFontFamily normal="FreeSans" bold="FreeSansBold" italic="FreeSansItalic" boldItalic="FreeSansBoldItalic" />
    </docinit>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" title="mojeID new user authentication" showBoundary="0" author="CZ.NIC">
        <xsl:attribute name="author">
              <xsl:value-of select="$loc/str[@name='NIC_author']"/>
        </xsl:attribute>

        <xsl:call-template name="mojeIDTemplate">
          <xsl:with-param name="lang" select="$lang01"/>
          <xsl:with-param name="templateName" select="concat('main_', $lang01)"/>
        </xsl:call-template>

        <xsl:call-template name="mojeIDTemplate">
          <xsl:with-param name="lang" select="$lang02"/>
          <xsl:with-param name="templateName" select="concat('main_', $lang02)"/>
        </xsl:call-template>

        <stylesheet>
          <paraStyle name="main" fontName="FreeSans" fontSize="11" />
          <paraStyle name="title" fontSize="14" fontName="FreeSansBold" spaceBefore="0" spaceAfter="1.2cm" />
          <paraStyle name="address" fontSize="11" fontName="FreeSans"/>
          <paraStyle name="address-name" parent="address" fontName="FreeSansBold"/>
          <paraStyle name="tableHead" fontName="FreeSansBold"/>
      
          <blockTableStyle id="authDataTable">
            <blockFont name="FreeSans" size="11" start="0,0" stop="-1,-1"/>
            <blockLeftPadding length="0" start="0,0" stop="0,-1" />
            <blockTopPadding length="0" start="0,0" stop="-1,-1" />
            <blockBottomPadding length="0" start="0,0" stop="-1,-1"/>
          </blockTableStyle>
        </stylesheet>

      <story>
        <xsl:for-each select="user">
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
        </xsl:for-each>
      </story>

      </template>
    </document>
  </xsl:template>

  <!--one page of letter parametrized by language-->
  <xsl:template name="onePage">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <xsl:variable name="mojeid_loc" select="document(concat('mojeid_translation_', $lang, '.xml'))/strings"></xsl:variable>

    <xsl:call-template name="fillAddress"/>

    <para style="title"><xsl:value-of select="$mojeid_loc/str[@name='Authentication new user mojeID']"/></para>

    <para style="main"><xsl:value-of select="$loc/str[@name='Prague']"/>, <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></para>
    <spacer length="1.5cm"/>

    <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='Dear user,']"/></para>
    <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='this letter approves the succefful creation of mojeID account with these dates:']"/></para>
    <spacer length="0.5cm"/>
    
  <blockTable colWidths="2.4cm,15.2cm" style="authDataTable">
    <tr>
      <td>mojeID:</td>
      <td><xsl:value-of select="account/username"/></td>
    </tr>
    <tr>
      <td><xsl:value-of select="$mojeid_loc/str[@name='first name:']"/></td>
      <td><xsl:value-of select="account/first_name"/></td>
    </tr>
    <tr>
      <td><xsl:value-of select="$mojeid_loc/str[@name='last name:']"/></td>
      <td><xsl:value-of select="account/last_name"/></td>
    </tr>
    <tr>
      <td><xsl:value-of select="$mojeid_loc/str[@name='e-mail:']"/></td>
      <td><xsl:value-of select="account/email"/></td>
    </tr>
    </blockTable>
  <spacer length="0.6cm"/>

  <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='To access into your mojeID account is necessary to verify your identity with a pair of pins PIN1 and PIN2:']"/>
  </para>
  <spacer length="0.2cm"/>

  <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='PIN1 was sent to your email address']"/></para>
  <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='PIN2 is:']"/>&SPACE;<b><xsl:value-of select="auth/codes/pin2"/></b></para>
  <spacer length="0.2cm"/>

    <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='For activate your account click on a link you received by email.']"/></para>
  <spacer length="0.8cm"/>
    
    <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='Your team mojeID']"/></para>
  <spacer length="0.6cm"/>
    
    <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='Customer Support']"/></para>
    <para style="main">CZ.NIC, z. s. p. o.</para>
    <para style="main"><xsl:value-of select="$mojeid_loc/str[@name='Milesovska 1136/5']"/></para>
    <para style="main">130 00&EMSPACE;<xsl:value-of select="$mojeid_loc/str[@name='Prague 3']"/></para>
  <spacer length="1cm"/>

    <para style="main">www.mojeid.cz</para>
    <para style="main">+420 222 745 111</para>
    <para style="main">podpora@mojeid.cz</para>

  </xsl:template>

</xsl:stylesheet>
