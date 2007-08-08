<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
    </xsl:if>
</xsl:template>

<xsl:template name="short_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.</xsl:if>
</xsl:template>

</xsl:stylesheet>
