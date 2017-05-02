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
    </blockTable>

  </xsl:template>

</xsl:stylesheet>
