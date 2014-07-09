<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
<!ENTITY LF "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>&#xA;</xsl:text>">
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
    </account>
    <auth>
      <codes>
        <pin3>12333321</pin3>
      </codes>
    </auth>
  </user>
</contact_auth>
 
 Resulting RML can be processed by doc2pdf to generate PDF version of letter 
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" encoding="utf-8"/>

  <xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
      <xsl:value-of select='substring($sdt,9,2)'/>.<xsl:value-of select='substring($sdt,6,2)'/>.<xsl:value-of select='substring($sdt,1,4)'/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="contact_auth/user">
    <document>&LF;
      <docinit>&LF;
        <registerFont 
          fontName="Arial" fontFile="../msttcorefonts/Arial.ttf" 
          fontNameBold="ArialBold" fontFileBold="../msttcorefonts/Arial_Bold.ttf" 
          fontNameItalic="ArialItalic" fontFileItalic="../msttcorefonts/Arial_Italic.ttf" 
          fontNameBoldItalic="ArialBoldItalic" fontFileBoldItalic="../msttcorefonts/Arial_Bold_Italic.ttf" 
        />&LF;
      </docinit>&LF;
      <template pageSize="(210mm, 297mm)" leftMargin="20mm" rightMargin="20mm" topMargin="20mm" bottomMargin="20mm" title="mojeID account full activation" showBoundary="0" author="CZ.NIC">&LF;
        <pageTemplate id="main_cs">&LF;
          <pageGraphics>&LF;
            <frame id="address" x1="110mm" y1="227mm" width="85mm" height="35mm" showBoundary="0"/>&LF;
            <frame id="main" x1="28mm" y1="39mm" width="154mm" height="185mm" showBoundary="0"/>&LF;
            <frame id="account" x1="28mm" y1="24mm" width="57mm" height="45mm" showBoundary="0"/>&LF;
            <barCode x="152.5mm" y="58.5mm" barWidth="21mm" barHeight="21mm" code="QR">BEGIN:VCARD
VERSION:3.0
FN;CHARSET=utf-8:<xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/>
N;CHARSET=utf-8:<xsl:value-of select="account/last_name"/>;<xsl:value-of select="account/first_name"/>;;;
URL;TYPE=pref:http://<xsl:value-of select="account/username"/>.mojeid.cz
TEL;TYPE=CELL:<xsl:value-of select="account/mobile"/>
EMAIL;TYPE=PREF:<xsl:value-of select="account/email"/>
END:VCARD</barCode>&LF;
            <stroke color="black"/>&LF;
            <fill color="#000000"/>&LF;
            <setFont name="Arial" size="9.5"/>&LF;
            <drawString x="150mm" y="194mm">Praha&SPACE;<xsl:call-template name="local_date"><xsl:with-param name="sdt" select="actual_date"/></xsl:call-template></drawString>&LF;
            <setFont name="ArialBold" size="17"/>&LF;
            <drawString x="72mm" y="141.5mm">Váš kód PIN3: <xsl:value-of select="auth/codes/pin3"/></drawString>&LF;
            <xsl:choose>
              <xsl:when test="string-length(account/username)&lt;18">
                <setFont name="ArialBold" size="9.5"/></xsl:when>
              <xsl:otherwise>
                <setFont name="Arial" size="5.5"/>
              </xsl:otherwise>
            </xsl:choose>
            <drawString x="102mm" y="60.5mm"><xsl:value-of select="account/username"/></drawString>&LF;
            <drawString x="102mm" y="50.5mm"><xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/></drawString>&LF;
            <drawString x="102mm" y="41mm"><xsl:value-of select="account/email"/></drawString>&LF;
          </pageGraphics>&LF;
        </pageTemplate>&LF;

        <stylesheet>&LF;
          <paraStyle name="main" fontName="Arial" fontSize="9.5"/>&LF;
          <paraStyle name="main-bold" parent="main" fontName="ArialBold"/>&LF;
          <paraStyle name="main-title" parent="main-bold" fontSize="12"/>&LF;
          <paraStyle name="title" fontSize="23" fontName="ArialBold" spaceBefore="0" spaceAfter="5mm" textColor="#666666"/>&LF;
          <paraStyle name="address" fontSize="11" fontName="Arial"/>&LF;
          <paraStyle name="address-name" parent="address" fontName="ArialBold"/>&LF;
        </stylesheet>&LF;

        <story>&LF;
          <setNextTemplate name="main_cs"/>&LF;
          <para style="address-name"><xsl:value-of select="name"/></para>&LF;
          <xsl:if test="organization"><para style="address-name"><xsl:value-of select="organization"/></para></xsl:if>&LF;
          <para style="address"><xsl:value-of select="street"/></para>&LF;
          <para style="address"><xsl:value-of select="postal_code"/>&SPACE;<xsl:value-of select="city"/><xsl:if test="stateorprovince">, <xsl:value-of select="stateorprovince"/></xsl:if></para>&LF;
          <nextFrame/>&LF;
          <para style="title">Plná aktivace účtu mojeID</para>&LF;
          <spacer length="17mm"/>&LF;
          <para style="main-bold">
            <xsl:choose>
              <xsl:when test="account/sex='female'">Vážená uživatelko,</xsl:when>
              <xsl:otherwise>Vážený uživateli,</xsl:otherwise>
            </xsl:choose>
          </para>&LF;
          <spacer length="5mm"/>&LF;
          <para style="main">těší nás, že jste si založil<xsl:if test="account/sex='female'">a</xsl:if> účet mojeID.
K dokončení jeho identifikace Vám v tuto chvíli zbývá
poslední krok - ověření Vaší korespondenční adresy pomocí kódu PIN3.</para>&LF;
          <spacer length="3mm"/>&LF;
          <para style="main-title">Proč je dobré dokončit identifikaci účtu mojeID?</para>&LF;
          <spacer length="4mm"/>&LF;
          <para style="main">Ověření pomocí kódu PIN3 zaručuje, že je Vaše korespondenční
adresa autentická. To zvyšuje Vaši důvěryhodnost u služeb využívajících mojeID, jako jsou
například elektronické obchody, diskusní fóra nebo internetové seznamky.</para>&LF;
          <spacer length="21mm"/>&LF;
          <para style="main">Zadat kód PIN3 je možné po přihlášení do profilu mojeID na
<b>www.mojeid.cz</b>. Podrobný návod, jak dokončit identifikaci účtu mojeID pomocí kódu
PIN3, naleznete na zadní straně tohoto dopisu.</para>&LF;
          <spacer length="3mm"/>&LF;
          <para style="main">Váš tým mojeID</para>&LF;
          <spacer length="3mm"/>&LF;
          <para style="main-bold">Zákaznická podpora</para>&LF;
          <para style="main-bold">CZ.NIC, z. s. p. o.</para>&LF;
          <para style="main-bold">Americká 23, 120 00 Praha 2</para>&LF;
          <para style="main-bold">+420 222 745 111 | podpora@mojeid.cz | www.mojeid.cz</para>&LF;
          <spacer length="22mm"/>&LF;
          <para style="main-bold">Základní údaje o Vašem účtu:</para>&LF;
          <nextFrame/>&LF;
          <xsl:choose>
            <xsl:when test="string-length(account/username)&lt;18">
<para style="main-bold"><xsl:value-of select="account/username"/>.mojeid.cz</para>&LF;
<para style="main-bold"><xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/></para>&LF;
<para style="main-bold"><xsl:value-of select="account/email"/></para>&LF;
            </xsl:when>
            <xsl:otherwise>
<para style="main-bold" fontSize="5.5"><xsl:value-of select="account/username"/>.mojeid.cz</para>&LF;
<para style="main-bold" fontSize="5.5"><xsl:value-of select="account/first_name"/>&SPACE;<xsl:value-of select="account/last_name"/></para>&LF;
<para style="main-bold" fontSize="5.5"><xsl:value-of select="account/email"/></para>&LF;
            </xsl:otherwise>
          </xsl:choose>
        </story>&LF;
      </template>&LF;
    </document>&LF;
  </xsl:template>

</xsl:stylesheet>
