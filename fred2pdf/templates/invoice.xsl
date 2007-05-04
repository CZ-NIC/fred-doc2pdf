<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" />

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
  title="Faktura č. {payment/invoice_number}"
  author="{supplier/name}"
  >
    <pageTemplate id="first">
      <pageGraphics>

        <setFont name="Times-BoldItalic" size="25"/>
        <drawString x="2cm" y="27.6cm"><xsl:value-of select="supplier/name"/></drawString>
        <lines>2cm 27.3cm 19cm 27.3cm</lines>
    <!-- end of header -->

        <setFont name="Times-Bold" size="10"/>
        <drawString x="2cm" y="26.5cm">Odběratel (Client):</drawString>
        <drawString x="2cm" y="25.7cm">IČO:</drawString>
        <drawString x="2cm" y="25.3cm">DIČ (VAT number):</drawString>

        <drawString x="11.6cm" y="24.2cm"><xsl:value-of select="client/name"/></drawString>
        <drawString x="11.6cm" y="23.4cm"><xsl:value-of select="client/address/street"/></drawString>
        <drawString x="11.6cm" y="22.6cm"><xsl:value-of select="client/address/zip"/>&SPACE;<xsl:value-of select="client/address/city"/></drawString>

        <setFont name="Times-Roman" size="10"/>
        <drawString x="6cm" y="25.7cm"><xsl:value-of select="client/ico"/></drawString>
        <drawString x="6cm" y="25.3cm"><xsl:value-of select="client/vat_number"/></drawString>

        <drawString x="2cm" y="21.5cm">Sídlo odběratele: <xsl:value-of select="client/address/street"/>, <xsl:value-of select="client/address/zip"/>&SPACE;<xsl:value-of select="client/address/city"/></drawString>
        <lines>2cm 20.8cm 19cm 20.8cm</lines>

        <drawString x="2cm" y="20.1cm">Dodavatel (Supplier):</drawString>
        <drawRightString x="19cm" y="20.1cm"><xsl:value-of select="supplier/fullname"/>, <xsl:value-of select="supplier/address/street"/>, <xsl:value-of select="supplier/address/zip"/>&SPACE;<xsl:value-of select="supplier/address/city"/></drawRightString>

        <drawRightString x="19cm" y="19.3cm"><xsl:value-of select="supplier/registration"/></drawRightString>


        <drawString x="2cm" y="19.3cm">IČO:</drawString>
        <drawString x="2cm" y="18.9cm">DIČ:</drawString>

        <drawString x="3cm" y="19.3cm"><xsl:value-of select="supplier/ico"/></drawString>
        <drawString x="3cm" y="18.9cm"><xsl:value-of select="supplier/vat_number"/></drawString>

        <setFont name="Times-Bold" size="10"/>
        <drawString x="2cm" y="18.1cm">Daňový doklad č. (Invoice No):</drawString>
        <drawString x="2cm" y="17.7cm">Variabilní symbol:</drawString>

        <drawString x="7.4cm" y="18.1cm"><xsl:value-of select="payment/invoice_number"/></drawString>
        <drawString x="7.4cm" y="17.7cm"><xsl:value-of select="payment/vs"/></drawString>


        <setFont name="Times-Roman" size="10"/>

        <drawString x="10.4cm" y="17.7cm">Datum vystavení faktury (invoice date):</drawString>
        <drawString x="10.4cm" y="17.3cm">Datum uskutečnění zdaň.plnění (tax point):</drawString>

        <drawRightString x="19cm" y="17.7cm"><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/invoice_date" /></xsl:call-template></drawRightString>
        <drawRightString x="19cm" y="17.3cm"><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/tax_point" /></xsl:call-template></drawRightString>



        <drawString x="12cm" y="16.5cm">List:</drawString>
        <drawString x="15.4cm" y="16.5cm">Počet listů:</drawString>

        <setFont name="Times-Bold" size="10"/>
        <drawRightString x="14cm" y="16.5cm"><pageNumber/></drawRightString>
        <drawRightString x="19cm" y="16.5cm"><pageNumberTotal/></drawRightString>

        <setFont name="Times-Roman" size="10"/>

        <rect x="2cm" y="15.3cm" width="17cm" height="0.8cm" stroke="yes" />

        <drawString x="2.2cm" y="15.6cm">Označení dodávky</drawString>

        <drawString x="2cm" y="3.4cm">Vystaveno fakturačním systémem CZ.NIC</drawString>

    <!-- footer -->
        <lines>2cm 3cm 19cm 3cm</lines>

        <setFont name="Times-Roman" size="8"/>
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
        <setFont name="Times-BoldItalic" size="25"/>
        <drawString x="2cm" y="27.6cm"><xsl:value-of select="supplier/name"/></drawString>
        <lines>2cm 27.3cm 19cm 27.3cm</lines>

        <setFont name="Times-Bold" size="10"/>
        <drawRightString x="19cm" y="27.6cm">Příloha faktury č.: <xsl:value-of select="payment/invoice_number"/></drawRightString>

        <setFont name="Times-Roman" size="10"/>
        <drawString x="12cm" y="26.8cm">List:</drawString>
        <drawString x="15.4cm" y="26.8cm">Počet listů:</drawString>

        <setFont name="Times-Bold" size="10"/>
        <drawRightString x="14cm" y="26.8cm"><pageNumber/></drawRightString>
        <drawRightString x="19cm" y="26.8cm"><pageNumberTotal/></drawRightString>
        <setFont name="Times-Roman" size="10"/>

    <!-- end of header -->

    <!-- footer -->
        <lines>2cm 3cm 19cm 3cm</lines>

        <setFont name="Times-Roman" size="8"/>
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
      <lineStyle kind="LINEABOVE" start="0,0" stop="1,0" colorName="black" />
      <lineStyle kind="LINEABOVE" start="0,-1" stop="1,-1" colorName="black" />
      <blockFont name="Times-Bold" start="1,0" stop="1,1"/>
      <blockFont name="Times-Bold" start="0,-1" stop="-1,-1"/>
      <blockAlignment value="RIGHT" start="1,0" stop="1,-1" />
    </blockTableStyle>

    <blockTableStyle id="appendix">
      <blockFont name="Times-Roman" start="0,0" stop="-1,-1" size="9"/>
      <blockAlignment value="RIGHT" start="4,0" stop="6,-1" />
      <lineStyle kind="BOX" start="0,0" stop="-1,0" colorName="black" />
      <lineStyle kind="LINEABOVE" start="0,-1" stop="-1,-1" colorName="black" />
      <blockFont name="Times-Bold" start="0,-1" stop="-1,-1"/>
    </blockTableStyle>

    <blockTableStyle id="tbl_advance_payment">
      <blockFont name="Times-Roman" start="0,0" stop="-1,-1" size="9"/>
      <blockAlignment value="RIGHT" start="1,0" stop="-1,-1" />
      <blockFont name="Times-Bold" start="0,0" stop="-1,0"/>
      <lineStyle kind="BOX" start="0,0" stop="2,0" colorName="black" />
      <lineStyle kind="LINEBELOW" start="0,-1" stop="2,-1" colorName="black" />
    </blockTableStyle>

</stylesheet>

<story>

<para>
Za období od <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/period_from" /></xsl:call-template> do <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/period_to" /></xsl:call-template>
Vám fakturujeme poskytnuté služby (Smlouva o spolupráci při registracích doménových jmen ENUM):
</para>
<spacer length="0.4cm"/>
<para>
Registrace doménových jmen (kód RREG), 
za udržování záznamu o doménovém jménu (kód RUDR),
v násobcích roků (Počet) pro doménová jména dle přílohy.
</para>

<spacer length="0.4cm"/>

<xsl:apply-templates select="delivery" />

<setNextTemplate name="appendix"/>

<xsl:apply-templates select="advance_payment" />
<xsl:apply-templates select="appendix" />

</story>

</document>
</xsl:template>

<xsl:template match="delivery">
<blockTable colWidths="4cm,5.4cm,7.4cm" style="tbl_delivery">
<tr>
    <td>Celkem (total):</td>
    <td><xsl:value-of select='format-number(sumarize/total, "### ##0.00", "CZK")' /></td>
    <td></td>
</tr>
<tr>
    <td>Uhrazeno (paid):</td>
    <td><xsl:value-of select='format-number(sumarize/paid, "### ##0.00", "CZK")' /></td>
    <td></td>
</tr>
<xsl:apply-templates />
<tr>
    <td>Celkem k úhradě (to be paid):</td>
    <td><xsl:value-of select='format-number(sumarize/to_be_paid, "### ##0.00", "CZK")' /></td>
    <td></td>
</tr>
</blockTable>
</xsl:template>

<xsl:template match="vat_rates">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="entry">
<tr>
    <td>Základ daně <xsl:value-of select='format-number(vatperc, "#0")' />%:</td>
    <td><xsl:value-of select='format-number(basetax, "### ##0.00", "CZK")' /></td>
    <td></td>
</tr>
<tr>
    <td>DPH <xsl:value-of select='format-number(vatperc, "#0")' />%:</td>
    <td><xsl:value-of select='format-number(vat, "### ##0.00", "CZK")' /></td>
    <td></td>
</tr>
</xsl:template>


<xsl:template match="appendix">
<pageBreak/>
<!-- 
    Table width: 16.8cm
-->
<blockTable colWidths="1.3cm,2cm,6.2cm,1.5cm,1.6cm,2cm,2.2cm" repeatRows="1" style="appendix">
<tr>
    <td>Změna</td>
    <td>Provedena</td>
    <td>Doména</td>
    <td>Služba do</td>
    <td>Počet</td>
    <td>Cena</td>
    <td>Celkem</td>
</tr>

<xsl:apply-templates select="items" />
<xsl:apply-templates select="sumarize_items" />

</blockTable>
</xsl:template>

<xsl:template match="items">
    <xsl:for-each select="item">
    <xsl:sort select="timestamp" />
    <xsl:sort select="subject" />
    <xsl:sort select="code" />
        <tr>
            <td><xsl:value-of select='code' /></td>
            <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="timestamp" /></xsl:call-template></td>
            <td><xsl:value-of select='subject' /></td>
            <td><xsl:call-template name="local_date"><xsl:with-param name="sdt" select="expiration" /></xsl:call-template></td>
            <td><xsl:value-of select='count' /></td>
            <td><xsl:value-of select='format-number(price, "### ##0.00", "CZK")' /></td>
            <td><xsl:value-of select='format-number(total, "### ##0.00", "CZK")' /></td>
        </tr>
    </xsl:for-each>
</xsl:template>

<xsl:template match="sumarize_items">
<tr>
    <td></td>
    <td>Celkem</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td><xsl:value-of select='format-number(total, "### ##0.00", "CZK")' /></td>
</tr>
</xsl:template>

<xsl:template match="advance_payment">

<spacer length="0.4cm"/>

<para>
DPH byla vypořádána na zálohových daňových dokladech:
</para>

<spacer length="0.4cm"/>

<blockTable colWidths="3cm,3cm,3.4cm,7.4cm" repeatRows="1" style="tbl_advance_payment">
<tr>
    <td>č.fa.</td>
    <td>čerpáno Kč</td>
    <td>zůstatek zálohy Kč</td>
    <td></td>
</tr>
<xsl:apply-templates select="applied_invoices" />
</blockTable>

</xsl:template>

<xsl:template match="applied_invoices">
    <xsl:for-each select="consumed">
    <xsl:sort select="number" order="descending" data-type="number" />
    <tr>
        <td><xsl:value-of select='number' /></td>
        <td><xsl:value-of select='format-number(price, "### ##0.00", "CZK")' /></td>
        <td><xsl:value-of select='format-number(balance, "### ##0.00", "CZK")' /></td>
        <td></td>
    </tr>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>