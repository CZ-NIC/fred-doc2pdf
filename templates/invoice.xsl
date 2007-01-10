<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text> </xsl:text>">
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:decimal-format name="CZK" decimal-separator="." grouping-separator=" "/>

<xsl:template match="/invoice">
<document>
<template pageSize="(21cm, 29.7cm)" leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm" bottomMargin="2.0cm" 
  title="Faktura č. {payment/invoice_number}"
  author="{supplier/name}"
  >
    <pageTemplate id="first">
      <pageGraphics>

        <setFont name="Times-BoldItalic" size="26"/>
        <drawString x="2cm" y="27.6cm"><xsl:value-of select="supplier/name"/></drawString>
        <lines>2cm 27.3cm 19cm 27.3cm</lines>
    <!-- end of header -->

        <setFont name="Times-Bold" size="11"/>
        <drawString x="2cm" y="26.5cm">Odběratel (Client)</drawString>
        <drawString x="2cm" y="25.7cm">IČO:</drawString>
        <drawString x="2cm" y="25.3cm">DIČ (VAT number):</drawString>

        <drawString x="11.6cm" y="24.2cm"><xsl:value-of select="client/name"/></drawString>
        <drawString x="11.6cm" y="23.4cm"><xsl:value-of select="client/address/street"/></drawString>
        <drawString x="11.6cm" y="22.6cm"><xsl:value-of select="client/address/zip"/>&SPACE;<xsl:value-of select="client/address/city"/></drawString>

        <setFont name="Times-Roman" size="11"/>
        <drawString x="6cm" y="25.7cm"><xsl:value-of select="client/ico"/></drawString>
        <drawString x="6cm" y="25.3cm"><xsl:value-of select="client/vat_number"/></drawString>

        <drawString x="2cm" y="21.5cm">Sídlo odběratele: <xsl:value-of select="supplier/address/street"/>, <xsl:value-of select="supplier/address/zip"/>&SPACE;<xsl:value-of select="supplier/address/city"/></drawString>
        <lines>2cm 20.8cm 19cm 20.8cm</lines>

        <drawString x="2cm" y="20.1cm">Dodavatel (Supplier):</drawString>
        <drawRightString x="19cm" y="20.1cm"><xsl:value-of select="supplier/fullname"/>, <xsl:value-of select="supplier/address/street"/>, <xsl:value-of select="supplier/address/zip"/>&SPACE;<xsl:value-of select="supplier/address/city"/></drawRightString>

        <drawRightString x="19cm" y="19.3cm"><xsl:value-of select="supplier/registration"/></drawRightString>


        <drawString x="2cm" y="19.3cm">IČO:</drawString>
        <drawString x="2cm" y="18.9cm">DIČ:</drawString>

        <drawString x="3cm" y="19.3cm"><xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="3cm" y="18.9cm"><xsl:value-of select="supplier/vat_number"/></drawString>

        <setFont name="Times-Bold" size="11"/>
        <drawString x="2cm" y="18.1cm">Daňový doklad č. (Invoice No):</drawString>
        <drawString x="2cm" y="17.7cm">Variabliní symbol:</drawString>

        <drawString x="7.4cm" y="18.1cm"><xsl:value-of select="payment/invoice_number"/></drawString>
        <drawString x="7.4cm" y="17.7cm"><xsl:value-of select="payment/vs"/></drawString>


        <setFont name="Times-Roman" size="11"/>
        <xsl:if test="payment/payment_method">
        <drawString x="2cm" y="16.9cm">Způsob úhrady: <xsl:value-of select="payment/payment_method"/></drawString>
        </xsl:if>

        <drawString x="10.4cm" y="18.1cm">Datum splatnosti faktutry (payment date):</drawString>
        <drawString x="10.4cm" y="17.7cm">Datum vystavení faktury (invoice date):</drawString>
        <drawString x="10.4cm" y="17.3cm">Datum uskutečnění zdaň.plnění (tax point):</drawString>

        <drawRightString x="19cm" y="18.1cm"><xsl:value-of select="payment/payment_date"/></drawRightString>
        <drawRightString x="19cm" y="17.7cm"><xsl:value-of select="payment/invoice_date"/></drawRightString>
        <drawRightString x="19cm" y="17.3cm"><xsl:value-of select="payment/tax_point"/></drawRightString>

        <drawString x="12cm" y="16.5cm">List:</drawString>
        <drawString x="15cm" y="16.5cm">Počet listů:</drawString>

        <setFont name="Times-Bold" size="11"/>
        <drawString x="13cm" y="16.5cm"><pageNumber/></drawString>
        <drawString x="17cm" y="16.5cm"><pageNumberTotal/></drawString>
        <setFont name="Times-Roman" size="11"/>

        <rect x="2cm" y="15.3cm" width="17cm" height="0.8cm" stroke="yes" />

        <drawString x="2.2cm" y="15.6cm">Označení dodávky</drawString>

        <drawString x="2cm" y="3.4cm">Vystavil: <xsl:value-of select="payment/issue_person"/></drawString>

    <!-- footer -->
        <lines>2cm 3cm 19cm 3cm</lines>

        <setFont name="Times-Roman" size="9"/>
        <drawString x="2cm" y="2.4cm"><xsl:value-of select="supplier/name"/></drawString>
        <drawString x="2cm" y="2cm">Reklamace: <xsl:value-of select="supplier/reclamation"/></drawString>

        <drawString x="12cm" y="2.4cm"><xsl:value-of select="supplier/url"/></drawString>
        <drawString x="12cm" y="2cm"><xsl:value-of select="supplier/email"/></drawString>

        <drawString x="16.5cm" y="2.4cm">IČO: <xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="16.5cm" y="2cm">DIČ: <xsl:value-of select="supplier/vat_number"/></drawString>

      </pageGraphics>
        <frame id="delivery" x1="1.8cm" y1="4cm" width="17.4cm" height="11cm" showBoundary="0" />
    </pageTemplate>

    <pageTemplate id="appendix">
      <pageGraphics>
        <setFont name="Times-BoldItalic" size="26"/>
        <drawString x="2cm" y="27.6cm"><xsl:value-of select="supplier/name"/></drawString>
        <lines>2cm 27.3cm 19cm 27.3cm</lines>

        <setFont name="Times-Bold" size="11"/>
        <drawRightString x="19cm" y="27.6cm">Příloha faktury č.: <xsl:value-of select="payment/invoice_number"/></drawRightString>

        <setFont name="Times-Roman" size="11"/>
        <drawString x="12cm" y="26.8cm">List:</drawString>
        <drawString x="15.4cm" y="26.8cm">Počet listů:</drawString>

        <setFont name="Times-Bold" size="11"/>
        <drawRightString x="14cm" y="26.8cm"><pageNumber/></drawRightString>
        <drawRightString x="19cm" y="26.8cm"><pageNumberTotal/></drawRightString>
        <setFont name="Times-Roman" size="11"/>

    <!-- end of header -->

    <!-- footer -->
        <lines>2cm 3cm 19cm 3cm</lines>

        <setFont name="Times-Roman" size="9"/>
        <drawString x="2cm" y="2.4cm"><xsl:value-of select="supplier/name"/></drawString>
        <drawString x="2cm" y="2cm">Reklamace: <xsl:value-of select="supplier/reclamation"/></drawString>

        <drawString x="12cm" y="2.4cm"><xsl:value-of select="supplier/url"/></drawString>
        <drawString x="12cm" y="2cm"><xsl:value-of select="supplier/email"/></drawString>

        <drawString x="16.5cm" y="2.4cm">IČO: <xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="16.5cm" y="2cm">DIČ: <xsl:value-of select="supplier/vat_number"/></drawString>
      </pageGraphics>
        <frame id="delivery" x1="1.8cm" y1="3.5cm" width="17.4cm" height="23cm" showBoundary="0" />
    </pageTemplate>

</template>

<stylesheet>
    <blockTableStyle id="tbl_delivery">
      <blockValign value="TOP"/>
      <blockAlignment value="RIGHT"/>
      <blockAlignment value="LEFT" start="1,-1" stop="1,-1" />

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
<xsl:value-of select="payment/anotation"/>
</para>

<spacer length="0.4cm"/>

<blockTable colWidths="3.4cm,3.4cm,3.4cm,3.4cm,3.4cm" repeatRows="1" style="tbl_delivery">
<tr>
    <td>Úhrnem:</td>
    <td>%DPH</td>
    <td>Základ daně</td>
    <td>Kč DPH</td>
    <td>Kč celkem</td>
</tr>
<xsl:apply-templates select="delivery" />
<tr>
    <td>Celkem k úhradě</td>
    <td>(to be paid):</td>
    <td></td>
    <td></td>
    <td><xsl:value-of select='format-number(sumarize/to_be_paid, "### ##0.00", "CZK")' /></td>
</tr>
</blockTable>

<setNextTemplate name="appendix"/>
<pageBreak/>

<blockTable colWidths="1.5cm,7.2cm,1.5cm,1.8cm,1.8cm,3cm" repeatRows="1" style="appendix">
<tr>
    <td>Řádek</td>
    <td>Text</td>
    <td>Kód</td>
    <td>Počet</td>
    <td>%DPH</td>
    <td>Celkem</td>
</tr>
<xsl:apply-templates select="appendix" />
</blockTable>

</story>

</document>
</xsl:template>

<xsl:template match="delivery">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="entry">
<tr>
    <td></td>
    <td><xsl:value-of select='format-number(vatperc, "#0")' />%</td>
    <td><xsl:value-of select='format-number(basetax, "#0.00")' /></td>
    <td><xsl:value-of select='format-number(vat, "### ##0.00", "CZK")' /></td>
    <td><xsl:value-of select='format-number(total, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>

<xsl:template match="sumarize">
<tr>
    <td>Celkem k úhradě</td>
    <td>(to be paid):</td>
    <td></td>
    <td></td>
    <td><xsl:value-of select='format-number(to_be_paid, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>


<xsl:template match="appendix">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="items">
    
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="item">
<tr>
    <td><xsl:number/></td>
    <td><xsl:value-of select='subject' /></td>
    <td><xsl:value-of select='code' /></td>
    <td><xsl:value-of select='count' /></td>
    <td><xsl:value-of select='format-number(vatperc, "#0")' />%</td>
    <td><xsl:value-of select='format-number(total, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>

<xsl:template match="sumarize_items">
<tr>
    <td></td>
    <td>Celkem</td>
    <td></td>
    <td></td>
    <td></td>
    <td><xsl:value-of select='format-number(total, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>

</xsl:stylesheet>
