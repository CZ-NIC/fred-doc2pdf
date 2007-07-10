<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />
<xsl:param name="lang" select="'cs'" />
<xsl:variable name="loc" select="document(concat('translation_', $lang, '.xml'))/strings"/>

<xsl:decimal-format name="CZK" decimal-separator="." grouping-separator=" "/>

<xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
    </xsl:if>
</xsl:template>

<xsl:template match="/invoice">
<document>

<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="{$loc/str[@name='Invoice No']} {payment/invoice_number}"
  author="{supplier/name}"
  >
    <pageTemplate id="first">
      <pageGraphics>

        <setFont name="Times-BoldItalic" size="25"/>
        <drawString x="2cm" y="27.6cm"><xsl:value-of select="supplier/name"/></drawString>
        <lines>2cm 27.3cm 19cm 27.3cm</lines>
    <!-- end of header -->

        <setFont name="Times-Bold" size="10"/>
        <drawString x="2cm" y="26.5cm"><xsl:value-of select="$loc/str[@name='Client']"/>:</drawString>
        <drawString x="2cm" y="25.7cm"><xsl:value-of select="$loc/str[@name='ICO']"/>:</drawString>
        <drawString x="2cm" y="25.3cm"><xsl:value-of select="$loc/str[@name='VAT number']"/>:</drawString>

        <drawString x="11.6cm" y="24.2cm"><xsl:value-of select="client/name"/></drawString>
        <drawString x="11.6cm" y="23.4cm"><xsl:value-of select="client/address/street"/></drawString>
        <drawString x="11.6cm" y="22.6cm"><xsl:value-of select="client/address/zip"/>&SPACE;<xsl:value-of select="client/address/city"/></drawString>

        <setFont name="Times-Roman" size="10"/>
        <drawString x="6cm" y="25.7cm"><xsl:value-of select="client/ico"/></drawString>
        <drawString x="6cm" y="25.3cm"><xsl:value-of select="client/vat_number"/></drawString>

        <drawString x="2cm" y="21.5cm"><xsl:value-of select="$loc/str[@name='Customer residence']"/>: <xsl:value-of select="client/address/street"/>, <xsl:value-of select="client/address/zip"/>&SPACE;<xsl:value-of select="client/address/city"/></drawString>
        <lines>2cm 20.8cm 19cm 20.8cm</lines>

        <drawString x="2cm" y="20.1cm"><xsl:value-of select="$loc/str[@name='Supplier']"/>:</drawString>
        <drawRightString x="19cm" y="20.1cm"><xsl:value-of select="supplier/fullname"/>, <xsl:value-of select="supplier/address/street"/>, <xsl:value-of select="supplier/address/zip"/>&SPACE;<xsl:value-of select="supplier/address/city"/></drawRightString>

        <drawRightString x="19cm" y="19.3cm"><xsl:value-of select="supplier/registration"/></drawRightString>


        <drawString x="2cm" y="19.3cm"><xsl:value-of select="$loc/str[@name='ICO']"/>:</drawString>
        <drawString x="2cm" y="18.9cm"><xsl:value-of select="$loc/str[@name='VAT number']"/>:</drawString>

        <drawString x="3cm" y="19.3cm"><xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="3cm" y="18.9cm"><xsl:value-of select="supplier/vat_number"/></drawString>

        <setFont name="Times-Bold" size="10"/>

        <drawString x="2cm" y="18.1cm"><xsl:value-of select="$loc/str[@name='Tax document for deposit']"/></drawString>
        <drawString x="2cm" y="17.7cm"><xsl:value-of select="$loc/str[@name='Invoice No']"/>:</drawString>
        <drawString x="2cm" y="17.3cm"><xsl:value-of select="$loc/str[@name='Variable symbol']"/>:</drawString>

        <drawString x="5.4cm" y="17.7cm"><xsl:value-of select="payment/invoice_number"/></drawString>
        <drawString x="5.4cm" y="17.3cm"><xsl:value-of select="payment/vs"/></drawString>

        <setFont name="Times-Roman" size="10"/>

        <drawString x="10.2cm" y="17.7cm"><xsl:value-of select="$loc/str[@name='Invoice date']"/>:</drawString>
        <drawString x="10.2cm" y="17.3cm"><xsl:value-of select="$loc/str[@name='Payment date']"/>:</drawString>

        <drawRightString x="19cm" y="17.7cm"><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/invoice_date" /></xsl:call-template></drawRightString>
        <drawRightString x="19cm" y="17.3cm"><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/advance_payment_date" /></xsl:call-template></drawRightString>

        <drawString x="12cm" y="16.5cm"><xsl:value-of select="$loc/str[@name='Sheet']"/>:</drawString>
        <drawString x="15.4cm" y="16.5cm"><xsl:value-of select="$loc/str[@name='Number of sheets']"/>:</drawString>

        <setFont name="Times-Bold" size="10"/>
        <drawRightString x="14cm" y="16.5cm"><pageNumber/></drawRightString>
        <drawRightString x="19cm" y="16.5cm"><pageNumberTotal/></drawRightString>

        <setFont name="Times-Roman" size="10"/>

        <rect x="2cm" y="15.3cm" width="17cm" height="0.8cm" stroke="yes" />

        <drawString x="2.2cm" y="15.6cm"><xsl:value-of select="$loc/str[@name='Supply sign']"/></drawString>

        <drawString x="2cm" y="3.4cm"><xsl:value-of select="$loc/str[@name='Draw by CZ.NIC invoice system']"/></drawString>

    <!-- footer -->
        <lines>2cm 3cm 19cm 3cm</lines>

        <setFont name="Times-Roman" size="8"/>
        <drawString x="2cm" y="2.4cm"><xsl:value-of select="supplier/name"/></drawString>
        <drawString x="2cm" y="2cm"><xsl:value-of select="$loc/str[@name='Reclamation']"/>: <xsl:value-of select="supplier/reclamation"/></drawString>

        <drawString x="12cm" y="2.4cm"><xsl:value-of select="supplier/url"/></drawString>
        <drawString x="12cm" y="2cm"><xsl:value-of select="supplier/email"/></drawString>

        <drawString x="16.5cm" y="2.4cm"><xsl:value-of select="$loc/str[@name='ICO']"/>: <xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="16.5cm" y="2cm"><xsl:value-of select="$loc/str[@name='VAT number']"/>: <xsl:value-of select="supplier/vat_number"/></drawString>

      </pageGraphics>
        <frame id="delivery" x1="1.8cm" y1="4cm" width="17.4cm" height="11cm" showBoundary="0" />
    </pageTemplate>

    <pageTemplate id="appendix">
      <pageGraphics>
        <setFont name="Times-BoldItalic" size="25"/>
        <drawString x="2cm" y="27.6cm"><xsl:value-of select="supplier/name"/></drawString>
        <lines>2cm 27.3cm 19cm 27.3cm</lines>

        <setFont name="Times-Bold" size="10"/>
        <drawRightString x="19cm" y="27.6cm"><xsl:value-of select="$loc/str[@name='Invoice attachment no.']"/>: <xsl:value-of select="payment/invoice_number"/></drawRightString>

        <setFont name="Times-Roman" size="10"/>
        <drawString x="12cm" y="26.8cm"><xsl:value-of select="$loc/str[@name='Sheet']"/>:</drawString>
        <drawString x="15.4cm" y="26.8cm"><xsl:value-of select="$loc/str[@name='Number of sheets']"/>:</drawString>

        <setFont name="Times-Bold" size="10"/>
        <drawRightString x="14cm" y="26.8cm"><pageNumber/></drawRightString>
        <drawRightString x="19cm" y="26.8cm"><pageNumberTotal/></drawRightString>
        <setFont name="Times-Roman" size="10"/>

    <!-- end of header -->

    <!-- footer -->
        <lines>2cm 3cm 19cm 3cm</lines>

        <setFont name="Times-Roman" size="8"/>
        <drawString x="2cm" y="2.4cm"><xsl:value-of select="supplier/name"/></drawString>
        <drawString x="2cm" y="2cm"><xsl:value-of select="$loc/str[@name='Reclamation']"/>: <xsl:value-of select="supplier/reclamation"/></drawString>

        <drawString x="12cm" y="2.4cm"><xsl:value-of select="supplier/url"/></drawString>
        <drawString x="12cm" y="2cm"><xsl:value-of select="supplier/email"/></drawString>

        <drawString x="16.5cm" y="2.4cm"><xsl:value-of select="$loc/str[@name='ICO']"/>: <xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="16.5cm" y="2cm"><xsl:value-of select="$loc/str[@name='VAT number']"/>: <xsl:value-of select="supplier/vat_number"/></drawString>
      </pageGraphics>
        <frame id="delivery" x1="1.8cm" y1="3.5cm" width="17.4cm" height="23cm" showBoundary="0" />
    </pageTemplate>

</template>

<stylesheet>

    <blockTableStyle id="tbl_delivery">

      <blockValign value="TOP"/>
      <blockAlignment value="RIGHT"/>
      <blockAlignment value="LEFT" start="0,0" stop="0,-1" />

      <blockFont name="Times-Bold" size="11" start="0,0" stop="-1,0"/>
      <blockFont name="Times-Bold" size="11" start="4,0" stop="4,-1"/>

      <lineStyle kind="LINEABOVE" start="0,0" stop="-1,0" colorName="black" />
      <lineStyle kind="LINEABOVE" start="0,1" stop="-1,1" colorName="black" />
      <lineStyle kind="LINEABOVE" start="0,-1" stop="-1,-1" colorName="black" />
      <blockFont name="Times-Bold" start="0,-1" stop="-1,-1" size="11"/>

    </blockTableStyle>

    <blockTableStyle id="appendix">
      <blockAlignment value="RIGHT"/>
      <blockAlignment value="LEFT" start="1,0" stop="1,-1" />
      <lineStyle kind="BOX" start="0,0" stop="-1,0" colorName="black" />
      <lineStyle kind="LINEABOVE" start="0,-1" stop="-1,-1" colorName="black" />
      <blockFont name="Times-Bold" size="11" start="0,-1" stop="-1,-1"/>
    </blockTableStyle>

</stylesheet>

<story>

<para>
<xsl:value-of select="$loc/str[@name='Voucher-for-call-VAT']"/>&SPACE;
<xsl:if test="client/vat_not_apply = 1">
<xsl:value-of select="$loc/str[@name='Insurance-by-law-and-VAT-liability']"/>
</xsl:if>
</para>

<spacer length="0.4cm"/>

<xsl:apply-templates select="delivery" />

</story>

</document>
</xsl:template>

<xsl:template match="delivery">
<blockTable colWidths="3.4cm,3.4cm,3.4cm,3.4cm,3.4cm" repeatRows="1" style="tbl_delivery">
<tr>
    <td><xsl:value-of select="$loc/str[@name='Sum']"/>:</td>
    <td><xsl:value-of select="$loc/str[@name='VAT %']"/></td>
    <td><xsl:value-of select="$loc/str[@name='Tax base']"/></td>
    <td><xsl:value-of select="$loc/str[@name='VAT CZK']"/></td>
    <td><xsl:value-of select="$loc/str[@name='Total CZK']"/></td>
</tr>
<xsl:apply-templates />
</blockTable>
</xsl:template>

<xsl:template match="vat_rates">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="entry">
<tr>
    <td></td>
    <td><xsl:value-of select='format-number(vatperc, "#0")' />%</td>
    <td><xsl:value-of select='format-number(basetax, "### ##0.00", "CZK")' /></td>
    <td><xsl:value-of select='format-number(vat, "### ##0.00", "CZK")' /></td>
    <td><xsl:value-of select='format-number(total, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>

<xsl:template match="sumarize">
<tr>
    <td><xsl:value-of select="$loc/str[@name='To be paid']"/>:</td>
    <td></td>
    <td></td>
    <td></td>
    <td><xsl:value-of select='format-number(to_be_paid, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>


</xsl:stylesheet>
