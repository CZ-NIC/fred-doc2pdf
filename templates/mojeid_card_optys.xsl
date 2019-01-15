<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!--
 Generate RML document containing letters with mojeID PIN3.
 
 Input of this XSL stylesheet is XML document with a list of domains and
 domains details. Sample of input document:

<?xml version="1.0" encoding="utf-8"?>
<contact_auth>
  <user>
    <actual_date>2014-06-30</actual_date>

    <name>Jmenič Příjmenovič</name>
    <organization>První českobudějovická &amp; synové, s. r. o.</organization>
    <street>Nějaká děsně hrozně moc dlouze pojmenovaná ulice 12/3456</street>
    <city>Strašná Díra</city>
    <stateorprovince>okres Česká Lípa</stateorprovince>
    <postal_code>720 00</postal_code>
    <country>Česká republika</country>

    <account>
      <username>jmenic-prijmenovic</username>
      <first_name>Jmenič</first_name>
      <last_name>Příjmenovič</last_name>
      <sex>male</sex>
      <email>jmenic-prijmenovic@mailovi.cz</email>
      <mobile>+420 602 11 22 33</mobile>
      <state>validated</state>
    </account>
  </user>
</contact_auth>
 
 Resulting RML can be processed by doc2pdf to generate PDF version of letter
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:func="http://exslt.org/functions" extension-element-prefixes="func"
  xmlns:cznic="http://nic.cz/xslt/functions">

  <xsl:output method="xml" encoding="utf-8"/>
  <xsl:include href="utilities.xsl"/>

  <xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
      <xsl:value-of select='substring($sdt,9,2)'/>.<xsl:value-of select='substring($sdt,6,2)'/>.<xsl:value-of select='substring($sdt,1,4)'/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="contact_auth/user">
    <document>
    <docinit>
        <registerTTFont faceName="FreeSans" fileName="FreeSans.ttf"/>
        <registerTTFont faceName="FreeSansBold" fileName="FreeSansBold.ttf"/>
        <registerTTFont faceName="FreeSansBoldItalic" fileName="FreeSansBoldOblique.ttf"/>
        <registerTTFont faceName="FreeSansItalic" fileName="FreeSansOblique.ttf"/>
        <registerFontFamily normal="FreeSans" bold="FreeSansBold" italic="FreeSansItalic" boldItalic="FreeSansBoldItalic" />
    </docinit>
      <template pageSize="(210mm, 297mm)" leftMargin="20mm" rightMargin="20mm" topMargin="20mm" bottomMargin="20mm" title="mojeID account full activation" showBoundary="0" author="CZ.NIC">
        <pageTemplate id="main_cs">
          <pageGraphics>
            <frame id="address" x1="110mm" y1="227mm" width="85mm" height="35mm" showBoundary="0"/>
            <frame id="main" x1="28mm" y1="39mm" width="154mm" height="185mm" showBoundary="0"/>
            <frame id="account" x1="28mm" y1="24mm" width="57mm" height="45mm" showBoundary="0"/>
            <barCode x="153.5mm" y="59mm" barWidth="18mm" barHeight="18mm" code="QR">BEGIN:VCARD
VERSION:3.0
FN;CHARSET=utf-8:<xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/>
N;CHARSET=utf-8:<xsl:value-of select="account/last_name"/>;<xsl:value-of select="account/first_name"/>;;;
URL;TYPE=pref:http://<xsl:value-of select="account/username"/>.mojeid.cz
TEL;TYPE=CELL:<xsl:value-of select="account/mobile"/>
EMAIL;TYPE=PREF:<xsl:value-of select="account/email"/>
END:VCARD</barCode>
            <stroke color="black"/>
            <fill color="#000000"/>
            <setFont name="FreeSans" size="9.5"/>
            <drawString x="150mm" y="194mm">Praha&SPACE;<xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></drawString>
            <xsl:choose>
              <xsl:when test="string-length(account/username)&lt;18">
                <setFont name="FreeSansBold" size="9.5"/></xsl:when>
              <xsl:otherwise>
                <setFont name="FreeSans" size="5.5"/>
              </xsl:otherwise>
            </xsl:choose>
            <drawString x="102mm" y="60.5mm"><xsl:value-of select="account/username"/></drawString>
            <drawString x="102mm" y="50.5mm"><xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/></drawString>
            <drawString x="102mm" y="41mm"><xsl:value-of select="account/email"/></drawString>
          </pageGraphics>
        </pageTemplate>

        <stylesheet>
          <paraStyle name="main" fontName="FreeSans" fontSize="9.5"/>
          <paraStyle name="main-bold" fontName="FreeSansBold" fontSize="9.5"/>
          <paraStyle name="main-italic" fontName="FreeSansItalic" fontSize="9.5"/>
          <paraStyle name="main-title" fontName="FreeSansBold" fontSize="12"/>
          <paraStyle name="title" fontSize="23" fontName="FreeSansBold" spaceBefore="0" spaceAfter="5mm" textColor="#666666"/>
          <paraStyle name="address" fontSize="11" fontName="FreeSans"/>
          <paraStyle name="address-name" fontSize="11" fontName="FreeSansBold"/>
        </stylesheet>

        <story>
          <setNextTemplate name="main_cs"/>
          <para style="address-name"><xsl:value-of select="name"/></para>
          <xsl:if test="normalize-space(organization)!=''"><para style="address-name"><xsl:value-of select="organization"/></para></xsl:if>
          <para style="address"><xsl:value-of select="street"/></para>
          <para style="address"><xsl:value-of select="postal_code"/>&SPACE;<xsl:value-of select="city"/><xsl:if test="normalize-space(stateorprovince)!=''">, <xsl:value-of select="stateorprovince"/></xsl:if></para>
          <xsl:if test="not(cznic:country_is_czech_republic(country))"><para style="address"><xsl:value-of select="country"/></para></xsl:if>
          <nextFrame/>
          <para style="title">Zaslání mojeID/emergency card</para>
          <spacer length="14mm"/>
          <para style="main-bold">
            <xsl:choose>
              <xsl:when test="account/sex='female'">Vážená uživatelko,</xsl:when>
              <xsl:otherwise>Vážený uživateli,</xsl:otherwise>
            </xsl:choose>
          </para>
          <spacer length="3mm"/>
          <para style="main">jsme rádi, že máte zájem o službu mojeID. Na základě obdržené žádosti
                             Vám zasíláme mojeID/emergency card.</para>
          <spacer length="3mm"/>
          <para style="main">Váš tým mojeID</para>
          <spacer length="3mm"/>
          <para style="main-bold">Zákaznická podpora</para>
          <para style="main-bold">CZ.NIC, z. s. p. o.</para>
          <para style="main-bold">Milešovská 1136/5, 130 00 Praha 3</para>
          <xsl:if test="not(cznic:country_is_czech_republic(country))"><para style="main-bold">Czech Republic</para></xsl:if>
          <para style="main-bold">+420 222 745 111 | podpora@mojeid.cz | www.mojeid.cz</para>
          <xsl:if test="cznic:country_is_czech_republic(country)"><spacer length="4mm"/></xsl:if>
          <xsl:choose>
            <xsl:when test="account/state='validated'">
              <spacer length="71mm"/>
            </xsl:when>
            <xsl:otherwise>
              <spacer length="16mm"/>
              <para style="main-italic">
                Víte o tom, že svůj účet můžete i <i>validovat</i>? Tím se myslí ověřit údaje z účtu
                mojeID oproti dokladu totožnosti, případně elektronickým podpisem. K ověřovaným
                údajům patří nejen jméno, ale i datum narození a adresa trvalého bydliště. Více
                o procesu validace a přehled validačních míst najdete na
                <i>www.mojeid.cz/validace</i>.
              </para>
              <spacer length="3mm"/>
              <para style="main-italic">
                Validovaný účet mojeID můžete využít například u služeb, které vyžadují ověření věku
                či trvalého bydliště. Mohou to být některé elektronické obchody prodávající zboží
                podléhající kontrole plnoletosti, komunitní weby nebo portály veřejné správy.
                Neváhejte tedy a navštivte nejbližší validační místo.
              </para>
              <spacer length="18mm"/>
            </xsl:otherwise>
          </xsl:choose>
          <para style="main-bold">Základní údaje o Vašem účtu:</para>
          <nextFrame/>
          <xsl:choose>
            <xsl:when test="string-length(account/username)&lt;18">
<para style="main-bold"><xsl:value-of select="account/username"/>.mojeid.cz</para>
<para style="main-bold"><xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/></para>
<para style="main-bold"><xsl:value-of select="account/email"/></para>
            </xsl:when>
            <xsl:otherwise>
<para style="main-bold" fontSize="5.5"><xsl:value-of select="account/username"/>.mojeid.cz</para>
<para style="main-bold" fontSize="5.5"><xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/></para>
<para style="main-bold" fontSize="5.5"><xsl:value-of select="account/email"/></para>
            </xsl:otherwise>
          </xsl:choose>
        </story>
      </template>
    </document>
  </xsl:template>

</xsl:stylesheet>
