<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="lang" select="'cs'"/>
  <xsl:param name="title" select="'The Record statement from the Domain registry .cz'"/>
  <xsl:param name="testsignature" select="''"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"></xsl:variable>
  <xsl:variable name="lang01" select="'cs'"/>
  <xsl:variable name="lang02" select="'en'"/>

  <xsl:template match="record_statement">
    <document>
    <docinit>
        <registerTTFont faceName="FreeSans" fileName="FreeSans.ttf"/>
        <registerTTFont faceName="FreeSansBold" fileName="FreeSansBold.ttf"/>
        <registerTTFont faceName="FreeSansBoldItalic" fileName="FreeSansBoldOblique.ttf"/>
        <registerTTFont faceName="FreeSansItalic" fileName="FreeSansOblique.ttf"/>
        <registerFontFamily normal="FreeSans" bold="FreeSansBold" italic="FreeSansItalic" boldItalic="FreeSansBoldItalic" />
    </docinit>
      <template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" showBoundary="0">
        <xsl:attribute name="author">
              <xsl:value-of select="$loc/str[@name='NIC_author']"/>
        </xsl:attribute>
        <xsl:attribute name="title">
              <xsl:value-of select="$title"/>
        </xsl:attribute>

        <xsl:call-template name="recordStatementTemplate">
          <xsl:with-param name="lang" select="$lang01"/>
          <xsl:with-param name="templateName" select="concat('record_statement_', $lang01)"/>
        </xsl:call-template>

        <xsl:call-template name="recordStatementTemplate">
          <xsl:with-param name="lang" select="$lang02"/>
          <xsl:with-param name="templateName" select="concat('record_statement_', $lang02)"/>
        </xsl:call-template>

      </template>

      <stylesheet>
        <paraStyle name="basic" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="main" parent="basic" spaceAfter="0.2cm" fontName="FreeSans" fontSize="10"/>
        <paraStyle name="bold" parent="basic" fontName="FreeSansBold" fontSize="9"  />
        <paraStyle name="italic" parent="basic" fontName="FreeSansItalic" fontSize="9"  />
        <paraStyle name="small-header" fontSize="13" spaceBefore="0.4cm" spaceAfter="0.4cm" fontName="FreeSansBoldItalic" textColor="#003893"/>
        <paraStyle name="header" fontSize="15" spaceBefore="0.8cm" spaceAfter="0.45cm" fontName="FreeSansBold" textColor="#003893"/>
        <paraStyle name="page-header" parent="main" fontSize="18" spaceAfter="0.5cm" fontName="FreeSansBold" textColor="#003893" />
        <paraStyle name="largeStringMono" fontName="Courier" fontSize="8" leading="8" />

        <blockTableStyle id="registry_data">
          <lineStyle kind="GRID" start="0,0" stop="-1,-1" thickness="0.1" colorName="black"/>
          <blockFont name="FreeSans" start="0,0" stop="-1,-1" size="9"/>
          <blockLeftPadding length="0.1cm" start="0,0" stop="-1,-1" />
          <blockTopPadding length="0.1cm" start="0,0" stop="-1,-1" />
          <blockValign value="TOP" start="0,0" stop="0,-1" />
        </blockTableStyle>

      </stylesheet>

      <story>
          <setNextTemplate>
             <xsl:attribute name="name">
                 <xsl:value-of select="concat('record_statement_',$lang01)"/>
             </xsl:attribute>
          </setNextTemplate>

          <xsl:call-template name="pageRecordStatement">
            <xsl:with-param name="lang" select="$lang01"/>
          </xsl:call-template>

          <setNextTemplate>
             <xsl:attribute name="name">
                 <xsl:value-of select="concat('record_statement_',$lang02)"/>
             </xsl:attribute>
          </setNextTemplate>
          <nextFrame/>

          <xsl:call-template name="pageRecordStatement">
            <xsl:with-param name="lang" select="$lang02"/>
          </xsl:call-template>
      </story>
    </document>
  </xsl:template>

  <xsl:template name="recordStatementTemplate">
    <xsl:param name="templateName" select="main_cs"/>
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <pageTemplate>
      <xsl:attribute name="id">
        <xsl:value-of select="$templateName"/>
      </xsl:attribute>
      <pageGraphics>

        <setFont name="FreeSans" size="8"/>

        <xsl:if test="$testsignature = 'yes'">
          <fill color="#ce1126"/>
          <drawString x="2.32cm" y="4.8cm">This statement was electronically signed by the association CZ.NIC, z. s. p. o. in DD.MM.YYYY HH:MM:SS.</drawString>
          <fill color="black"/>
        </xsl:if>

        <setFont name="FreeSans" size="12"/>
        <translate dx="9.2"/>
        <xsl:call-template name="cznic_logo"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
        <translate dx="-9.2"/>
        <frame id="main" x1="2.1cm" y1="6cm" width="16.7cm" height="20.2cm" showBoundary="0"/>
        <translate dx="9"/>
        <xsl:call-template name="footer_text"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>
        <translate dx="-9"/>
        <xsl:call-template name="footer"/>
      </pageGraphics>
    </pageTemplate>
  </xsl:template>

  <xsl:template name="pageRecordStatement">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

    <para style="page-header"><xsl:value-of select="$loc/str[@name='The Record statement from the Domain registry .cz']"/></para>
    <para style="main"><xsl:value-of select="$loc/str[@name='These data are valid for']"/>
      &SPACE;
      <xsl:call-template name="localized_datetime"><xsl:with-param name="lang" select="$lang"/><xsl:with-param name="sdt" select="current_datetime" /></xsl:call-template>
    </para>

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

    <xsl:for-each select="domain">
      <xsl:call-template name="pageDetailDomain">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="contact">
      <xsl:call-template name="pageDetailContact">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="contactTableRowTemplate">
      <xsl:param name="lang" select="'cs'"/>
      <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
          <tr>
            <td><xsl:value-of select="$loc/str[@name='Handle, Name, Organization']"/>:</td>
            <td>
                <xsl:value-of select="handle"/>
                <xsl:if test="name/text()">, <xsl:value-of select="name"/></xsl:if>
                <xsl:if test="organization/text()">, <xsl:call-template name="trim_with_dots">
                        <xsl:with-param name="string" select="organization/text()"/>
                        <xsl:with-param name="max_length" select="32"/>
                    </xsl:call-template>
                </xsl:if>
            </td>
          </tr>
  </xsl:template>

  <xsl:template name="discloseValueOrNotSet">
  <xsl:param name="value" select="."/>
  <xsl:param name="disclose" select="false()"/>
  <xsl:param name="disclose_or_private" select="false()"/>
  <xsl:param name="lang" select="'cs'"/>
  <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <xsl:choose>
      <xsl:when test="$disclose_or_private">
        <xsl:choose>
          <xsl:when test="string-length($value) > 0">
            <para style="basic"><xsl:value-of select="$value"/></para>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$disclose">
              <para style="italic">(<xsl:value-of select="$loc/str[@name='Not set']"/>)</para>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$disclose">
          <para style="italic">(<xsl:value-of select="$loc/str[@name='Not disclosed']"/>)</para>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <para style="italic"><xsl:value-of select="$loc/str[@name='Not disclosed']"/></para>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
