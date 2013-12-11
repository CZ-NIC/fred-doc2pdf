<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:variable name="title" select="'Notice to correct data'"/>
  <xsl:include href="shared_templates.xsl"/>
  <xsl:include href="shared_message.xsl"/>
  <xsl:variable name="lang01" select="'cs'"/>
  <xsl:variable name="lang02" select="'en'"/>
  <xsl:param name="lang" select="$lang01"/>

  <!-- content page of letter parametrized by language -->
  <xsl:template name="pageContent">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>
    <xsl:call-template name="fillAddress">
      <xsl:with-param name="recomandee" select="'yes'"/>
    </xsl:call-template>

    <para style="main"><b>Cc:</b>&SPACE; <xsl:value-of select="email"/></para>
    <para style="main"><xsl:value-of select="$loc/str[@name='Prague']"/>, <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></para>
    <para style="main"><b><xsl:value-of select="$loc/str[@name='Contact id']"/></b> &SPACE; <xsl:value-of select="handle"/> &SPACE; <b> – <xsl:value-of select="$loc/str[@name='notice to correct data']"/></b></para>
    <spacer length="0.5cm"/>
    <para style="main"><xsl:value-of select="$loc/str[@name='Dear Sir or Madam']"/>
</para>
    <para style="main">
      <xsl:value-of select="$loc/str[@name='notice_correct01']"/> &SPACE; <xsl:value-of select="handle"/> &SPACE;
      (<xsl:call-template name="invalidItems"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>)<xsl:value-of select="$loc/str[@name='notice_correct02']"/>
    </para>

    <para style="main">
      <xsl:value-of select="$loc/str[@name='notice_correct03']"/>
      <b> &SPACE;<xsl:value-of select="$loc/str[@name='notice_correct04']"/>&SPACE; </b>
      (<xsl:call-template name="invalidItems"><xsl:with-param name="lang" select="$lang"/></xsl:call-template>), &SPACE;
      <b> <xsl:value-of select="$loc/str[@name='notice_correct05']"/>
        &SPACE;
        <xsl:call-template name="local_date">
            <xsl:with-param name="sdt" select="termination_date"/>
        </xsl:call-template>
        <xsl:value-of select="$loc/str[@name='notice_correct06']"/>
      </b>
    </para>

    <para style="main">
      <xsl:value-of select="$loc/str[@name='notice_correct07']"/> &SPACE;
      <b> <xsl:value-of select="$loc/str[@name='notice_correct08']"/> </b>
    </para>

    <para style="basic" spaceAfter="0.3cm"><xsl:value-of select="$loc/str[@name='Yours sincerely']"/>
    </para>
    <para style="basic">
        <xsl:value-of select="$loc/str[@name='Operations manager name']"/>
    </para>
    <para style="basic" spaceAfter="0.6cm">
      <xsl:value-of select="$loc/str[@name='Operations manager, CZ.NIC, z. s. p. o.']"/>
    </para>

  </xsl:template>

  <xsl:template name="invalidItems">
    <xsl:param name="lang" select="'cs'"/>
    <xsl:for-each select="invalid/item">
      <xsl:value-of select="lang[@code=$lang]"/><xsl:if test="position() != last()">, </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>