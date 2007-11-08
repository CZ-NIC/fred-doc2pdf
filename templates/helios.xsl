<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY SPACE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<!--
    $ xsltproc templates/helios.xsl examples/invoice.xml | xmllint -.-format -.-encode UTF-8 -
-->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    extension-element-prefixes="date"
>
<xsl:output method="xml" encoding="windows-1250" />

<xsl:template name="local_date">
    <xsl:param name="sdt"/>
    <xsl:if test="$sdt">
    <xsl:value-of select='substring($sdt, 9, 2)' />.<xsl:value-of select='substring($sdt, 6, 2)' />.<xsl:value-of select='substring($sdt, 1, 4)' />
    </xsl:if>
</xsl:template>

<xsl:template name='invoice_number'>
    <xsl:param name='number'/>
    <xsl:choose>
         <xsl:when test='substring($number,0,1)="2"'>
              <xsl:value-of select='concat(substring($number,0,5),substring($number,6))'/>
         </xsl:when>
         <xsl:otherwise>
              <xsl:value-of select='concat(substring($number,0,5),substring($number,6))'/>
         </xsl:otherwise>
    </xsl:choose>
</xsl:template>  

<xsl:template match="/invoice">
<xsl:variable name="now" select="date:date-time()"/>
<HeliosIQ_1>
<header>
    <delivery>
        <message>
            <messageID>FaV<xsl:value-of select="payment/invoice_number"/>.XML</messageID>
            <sent><xsl:value-of select="$now"/></sent>
        </message>
        <to>
            <address>C:\</address>
        </to>
        <from>
            <address>CZ.NIC, z.s.p.o.</address>
        </from>
    </delivery>
    <manifest>
        <document>
            <name>PohyboveDoklady</name>
            <description>internal-format-HELIOS:lcs_cz:PohyboveDoklady</description>
            <version>010020070125</version>
        </document>
    </manifest>
</header>
<body>
<PohyboveDoklady>
    <cisloDokladu>
        <xsl:call-template name='invoice_number'>
             <xsl:with-param name='number' select="payment/invoice_number"/>
        </xsl:call-template>    
    </cisloDokladu>
    <DruhPohybuZbo>13</DruhPohybuZbo>
    <TabDokladyZbozi>
        <DodFak><xsl:value-of select="payment/vs"/></DodFak>
        <PopisDodavky>Faktura za <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/period_from" /></xsl:call-template> - <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/period_to" /></xsl:call-template></PopisDodavky>
        <ZaokrouhleniFak>0</ZaokrouhleniFak>
        <ZaokrouhleniFakVal>0</ZaokrouhleniFakVal>
        <SazbaDPH>FK_1</SazbaDPH>
        <SazbaDPH1>FK_2</SazbaDPH1>

        <SumaKc><xsl:value-of select="delivery/sumarize/total_with_vat"/></SumaKc>
        <CbezDPH1><xsl:value-of select="delivery/sumarize/total"/></CbezDPH1>
        <CsDPH1><xsl:value-of select="delivery/sumarize/total_with_vat"/></CsDPH1>
        <CbezDPH1Val><xsl:value-of select="delivery/sumarize/total"/></CbezDPH1Val>
        <CsDPH1Val><xsl:value-of select="delivery/sumarize/total_with_vat"/></CsDPH1Val>

        <DatPorizeni><xsl:value-of select="payment/invoice_date"/></DatPorizeni>
        <DatRealizace/>
        <Splatnost><xsl:value-of select="payment/invoice_date"/></Splatnost>
        <DUZP><xsl:value-of select="payment/tax_point"/></DUZP>
        <DatPovinnostiFa/>
        <DatUctovani/>
        <UKod><xsl:value-of select='concat("FK_UKOD_",substring(payment/invoice_number,0,4))  '/></UKod>
        <FormaUhrady>FK_4</FormaUhrady>
        <IDBankSpoj>FK_5</IDBankSpoj>
        <CisloOrg>FK_10</CisloOrg>
        <RadaDokladu>FK_13</RadaDokladu>
        <PoziceZaokrDPHH>1</PoziceZaokrDPHH>
        <DIC>FK_12</DIC>
        <Mena>FK_7</Mena>
        <IDReal>FK_ZALFAK</IDReal>
        <PoziceZaokrDPHHla>1</PoziceZaokrDPHHla>
        <HraniceZaokrDPHHla>2</HraniceZaokrDPHHla>
        <ZaokrNaPadesat>0</ZaokrNaPadesat>
    </TabDokladyZbozi>
<xsl:for-each select='advance_payment/applied_invoices/consumed'>    
    <TabDoplnkovePol>
        <Auto>4</Auto>
        <Cislo><xsl:value-of select="position()"/></Cislo>
        <SazbaDPH>FK_1</SazbaDPH>
        <KorekceZakladuDane><xsl:value-of select="price"/></KorekceZakladuDane>
        <KorekceDane>0</KorekceDane>
        <ParovaciZnak>
            <xsl:call-template name='invoice_number'>
                 <xsl:with-param name='number' select="number"/>
            </xsl:call-template>
        </ParovaciZnak>
    </TabDoplnkovePol>
</xsl:for-each>    
<xsl:for-each select='delivery/vat_rates/entry/years/entry'>
    <TabPohybyZbozi>
        <RegCis>0<xsl:value-of select='year'/></RegCis>
        <Nazev1>Výnosy roku <xsl:value-of select='year'/></Nazev1>
        <!-- <MJEvidence>FK_17</MJEvidence> -->
        <!-- <MJ>FK_17</MJ> -->
        <SazbaDPH>FK_1</SazbaDPH>
        <MnOdebrane>0</MnOdebrane>
        <JCbezDaniKC><xsl:value-of select='price'/></JCbezDaniKC>
        <JCsDPHKc><xsl:value-of select='price'/></JCsDPHKc>
        <JCbezDaniVal><xsl:value-of select='price'/></JCbezDaniVal>
        <JCsDPHVal><xsl:value-of select='price'/></JCsDPHVal>
        <CCbezDaniKc><xsl:value-of select='price'/></CCbezDaniKc>
        <CCsDPHKc><xsl:value-of select='price'/></CCsDPHKc>
        <CCbezDaniVal><xsl:value-of select='price'/></CCbezDaniVal>
        <CCsDPHVal><xsl:value-of select='price'/></CCsDPHVal>
        <JCsSDKc><xsl:value-of select='price'/></JCsSDKc>
        <JCsSDVal><xsl:value-of select='price'/></JCsSDVal>
        <JCbezDaniKcPoS><xsl:value-of select='price'/></JCbezDaniKcPoS>
        <JCsSDKcPoS><xsl:value-of select='price'/></JCsSDKcPoS>
        <JCsDPHKcPoS><xsl:value-of select='price'/></JCsDPHKcPoS>
        <JCbezDaniValPoS><xsl:value-of select='price'/></JCbezDaniValPoS>
        <JCsSDValPoS><xsl:value-of select='price'/></JCsSDValPoS>
        <JCsDPHValPoS><xsl:value-of select='price'/></JCsDPHValPoS>
        <CCsSDKc><xsl:value-of select='price'/></CCsSDKc>
        <CCsSDVal><xsl:value-of select='price'/></CCsSDVal>
        <CCbezDaniKcPoS><xsl:value-of select='price'/></CCbezDaniKcPoS>
        <CCsSDKcPoS><xsl:value-of select='price'/></CCsSDKcPoS>
        <CCsDPHKcPoS><xsl:value-of select='price'/></CCsDPHKcPoS>
        <CCbezDaniValPoS><xsl:value-of select='price'/></CCbezDaniValPoS>
        <CCsSDValPoS><xsl:value-of select='price'/></CCsSDValPoS>
        <CCsDPHValPoS><xsl:value-of select='price'/></CCsDPHValPoS>
        <PrepMnozstvi>1</PrepMnozstvi>
        <MnozstviStorno>0</MnozstviStorno>
        <Mnozstvi>1</Mnozstvi>
        <Hmotnost>0</Hmotnost>
        <CCevidPozadovana>0</CCevidPozadovana>
        <MnOdebraneReal>0</MnOdebraneReal>
        <MnozstviStornoReal>0</MnozstviStornoReal>
        <CCevid>0</CCevid>
        <EvMnozstvi>0</EvMnozstvi>
        <EvStav>0</EvStav>
        <MnozstviReal>0</MnozstviReal>
<!--        <DatPorizeni>2007-10-22 14:25:50.983</DatPorizeni> -->
        <NastaveniSlev>4681</NastaveniSlev>
        <DruhPohybuZbo>13</DruhPohybuZbo>
        <SkupZbo>FK_SZ_SLUZBY</SkupZbo>
        <IDZboSklad>FK_SS_<xsl:value-of select='year'/></IDZboSklad>
        <KJKontrolovat>1</KJKontrolovat>
        <KJSkontrolovano>1</KJSkontrolovano>
        <Mena>FK_7</Mena>
        <PrepocetMJSD>1</PrepocetMJSD>
    </TabPohybyZbozi>
</xsl:for-each>

</PohyboveDoklady>

<Reference>
<TabDPH>
    <Polozka>
        <Klic>FK_1</Klic>
        <Sazba>0</Sazba>
        <Nazev>Nulová sazba</Nazev>
    </Polozka>
    <Polozka>
        <Klic>FK_2</Klic>
        <Sazba>19</Sazba>
        <Nazev>Zákl. sazba EU</Nazev>
    </Polozka>
</TabDPH>
<TabUKod>
    <Polozka>
        <Klic>FK_UKOD_230</Klic>
        <CisloKontace>19</CisloKontace>
    </Polozka>
    <Polozka>
        <Klic>FK_UKOD_240</Klic>
        <CisloKontace>20</CisloKontace>
    </Polozka>
    <Polozka>
        <Klic>FK_UKOD_120</Klic>
        <CisloKontace>26</CisloKontace>
    </Polozka>
    <Polozka>
        <Klic>FK_UKOD_110</Klic>
        <CisloKontace>27</CisloKontace>
    </Polozka>
</TabUKod>
<TabFormaUhrady>
    <Polozka>
        <Klic>FK_4</Klic>
        <FormaUhrady>Zálohou</FormaUhrady>
    </Polozka>
</TabFormaUhrady>
<TabBankSpojeni>
    <Polozka>
        <Klic>FK_5</Klic>
        <NazevBankSpoj/>
        <CisloUctu/>
        <Prednastaveno/>
        <IDOrg/>
        <Mena/>
        <UcetniUcet/>
        <Popis/>
        <IDUstavu/>
        <CilovaZeme/>
    </Polozka>
</TabBankSpojeni>
<TabCisOrg>
    <Polozka>
        <Klic>FK_10</Klic>
        <CisloOrg><xsl:value-of select="client/id + 10000"/></CisloOrg>
        <Nazev><xsl:value-of select="client/name"/></Nazev>

        <JeOdberatel>1</JeOdberatel>
        <JeDodavatel>1</JeDodavatel>
        <Fakturacni>1</Fakturacni>

        <PSC>FK_11</PSC>

        <Ulice><xsl:value-of select="client/address/street"/></Ulice>
        <Misto><xsl:value-of select="client/address/city"/></Misto>
        <ICO><xsl:value-of select="client/ico"/></ICO>
        <DIC>FK_12</DIC>
        <IdZeme>FK_9</IdZeme>
        <SlevaSozNa>2</SlevaSozNa>
        <SlevaSkupZbo>2</SlevaSkupZbo>
        <SlevaKmenZbo>2</SlevaKmenZbo>
        <SlevaStavSkladu>2</SlevaStavSkladu>
        <SlevaZbozi>2</SlevaZbozi>
        <SlevaOrg>2</SlevaOrg>
    </Polozka>
</TabCisOrg>
<TabKodMen>
    <Polozka>
        <Klic>FK_7</Klic>
        <Kod>CZK</Kod>
        <Nazev>Česká koruna</Nazev>
        <MinNasobek>0</MinNasobek>
        <ZaokrouhleniFaktury>0</ZaokrouhleniFaktury>
    </Polozka>
</TabKodMen>
<TabZeme>
    <Polozka>
        <Klic>FK_9</Klic>
        <ISOKod>CZ</ISOKod>
        <Nazev>Česká republika</Nazev>
        <CelniKod>CZ</CelniKod>
        <EU>1</EU>
    </Polozka>
</TabZeme>
<TabPSC>
    <Polozka>
        <Klic>FK_11</Klic>
        <Cislo><xsl:value-of select="client/address/zip"/></Cislo>
        <Mesto><xsl:value-of select="client/address/city"/></Mesto>
        <Posta><xsl:value-of select="client/address/city"/></Posta>
    </Polozka>
</TabPSC>
<TabDICOrg>
    <Polozka>
        <Klic>FK_12</Klic>
        <DIC><xsl:value-of select="client/vat_number"/></DIC>
        <CisloOrg>FK_10</CisloOrg>
        <ISOZeme>FK_9</ISOZeme>
    </Polozka>
</TabDICOrg>
<TabDruhDokZbo>
    <Polozka>
        <Klic>FK_13</Klic>
        <DruhPohybuZbo>13</DruhPohybuZbo>
        <RadaDokladu><xsl:value-of select="substring(payment/invoice_number, 0, 4)"/></RadaDokladu>
        <Nazev>FV registrátoři ENUM - zúčtování</Nazev>
        <PohybSkladu>1</PohybSkladu>
        <DefOKReal>1</DefOKReal>
        <DefOKUcto>1</DefOKUcto>
        <UKod>FK_3</UKod>
        <FormaUhrady>FK_4</FormaUhrady>
        <UctoCislovani>1</UctoCislovani>
        <VyrZaplZaloh>1</VyrZaplZaloh>
    </Polozka>
</TabDruhDokZbo>
<TabZalFak>
    <Polozka>
        <Klic>FK_ZALFAK</Klic>
<xsl:for-each select='advance_payment/applied_invoices/consumed'>    
        <ZalohovaFaktura>
            <IDZal>FK_DZ_<xsl:value-of select="number"/></IDZal>
            <CsDPH1><xsl:value-of select="price"/></CsDPH1>
            <CbezDPH1><xsl:value-of select="price"/></CbezDPH1>
            <CastkaDPH1>0</CastkaDPH1>
            <SazbaDPH1>FK_1</SazbaDPH1>
            <Popis><xsl:value-of select="number"/></Popis>
<!--            <Datum>1970-01-01 00:00:00.000</Datum> --> <!--TODO-->
        </ZalohovaFaktura>
</xsl:for-each>
    </Polozka>
</TabZalFak>
<TabDokladyZbozi>
<xsl:for-each select='advance_payment/applied_invoices/consumed'>
    <xsl:variable name='num'>
        <xsl:call-template name='invoice_number'>
            <xsl:with-param name='number' select="number"/>
        </xsl:call-template>
    </xsl:variable>    
    <Polozka>
        <Klic>FK_DZ_<xsl:value-of select="number"/></Klic>
        <DruhPohybuZbo>13</DruhPohybuZbo>
        <PoradoveCislo><xsl:value-of select="substring($num, 4)"/></PoradoveCislo>
        <RadaDokladu><xsl:value-of select="substring($num, 0, 4)"/></RadaDokladu>
 <!--       <DatPorizeni>1970-01-01 00:00:00.000</DatPorizeni> --> <!--TODO-->
    </Polozka>
</xsl:for-each>
</TabDokladyZbozi>
<TabSkupinyZbozi>
    <Polozka>
        <Klic>FK_SZ_SLUZBY</Klic>
        <SkupZbo>900</SkupZbo>
        <Nazev>Služby</Nazev>
    </Polozka>
</TabSkupinyZbozi>
<TabMJ>
    <Polozka>
        <Klic>FK_MJ_KUSY</Klic>
        <Kod>ks</Kod>
        <Nazev>kusy</Nazev>
    </Polozka>
</TabMJ>
<TabStavSkladu>
<xsl:for-each select='delivery/vat_rates/entry/years/entry'>
    <Polozka>
        <Klic>FK_SS_<xsl:value-of select='year'/></Klic>
        <JizNaSklade>1</JizNaSklade>
        <IDKmenZbozi>FK_KZ_<xsl:value-of select='year'/></IDKmenZbozi>
        <IDSklad>FK_STRED</IDSklad>
    </Polozka>
</xsl:for-each>    
</TabStavSkladu>
<TabKmenZbozi>
<xsl:for-each select='delivery/vat_rates/entry/years/entry'>
    <Polozka>
        <Klic>FK_KZ_<xsl:value-of select='year'/></Klic>
        <PrepMnozstvi>1</PrepMnozstvi>
        <SazbaDPHVstup>FK_1</SazbaDPHVstup>
        <SazbaDPHVystup>FK_1</SazbaDPHVystup>
        <RegCis>0<xsl:value-of select='year'/></RegCis>
        <Nazev1>Výnosy roku <xsl:value-of select='year'/></Nazev1>
        <DruhSkladu>0</DruhSkladu>
        <SkupZbo>FK_SZ_SLUZBY</SkupZbo>
        <MJEvidence>FK_MJ_KUSY</MJEvidence>
        <MJVstup>FK_MJ_KUSY</MJVstup>
        <MJVystup>FK_MJ_KUSY</MJVystup>
        <ZakladSDvSJ>0</ZakladSDvSJ>
    </Polozka>
</xsl:for-each>    
</TabKmenZbozi>
<TabStrom>
    <Polozka>
        <Klic>FK_Stred</Klic>
        <Cislo>001</Cislo>
        <Nazev>Středisko 001</Nazev>
        <DruhSkladu>1</DruhSkladu>
    </Polozka>
</TabStrom>
</Reference>
</body>
</HeliosIQ_1>
</xsl:template>


</xsl:stylesheet>
