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
    <cisloDokladu><xsl:value-of select="payment/invoice_number"/></cisloDokladu>
    <DruhPohybuZbo>13</DruhPohybuZbo>
    <TabDokladyZbozi>
        <DodFak><xsl:value-of select="payment/vs"/></DodFak>
        <PopisDodavky>Přístup k zónovým soub. <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/period_from" /></xsl:call-template> - <xsl:call-template name="local_date"><xsl:with-param name="sdt" select="payment/period_to" /></xsl:call-template></PopisDodavky>
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

        <UKod>FK_3</UKod>
        <FormaUhrady>FK_4</FormaUhrady>
        <IDBankSpoj>FK_5</IDBankSpoj>
        <CisloOrg>FK_10</CisloOrg>
        <RadaDokladu>FK_13</RadaDokladu>
        <PoziceZaokrDPHH>1</PoziceZaokrDPHH>
        <DIC>FK_12</DIC>
        <Mena>FK_7</Mena>
        <IDReal>FK_14</IDReal>
        <PoziceZaokrDPHHla>1</PoziceZaokrDPHHla>
        <HraniceZaokrDPHHla>2</HraniceZaokrDPHHla>
        <ZaokrNaPadesat>0</ZaokrNaPadesat>
    </TabDokladyZbozi>

    <TabDoplnkovePol>
        <Auto>4</Auto>
        <Cislo>1</Cislo>
        <SazbaDPH>FK_2</SazbaDPH>
        <KorekceZakladuDane><xsl:value-of select="delivery/sumarize/paid"/></KorekceZakladuDane>
        <KorekceDane><xsl:value-of select="delivery/sumarize/paid_vat"/></KorekceDane>
        <KorekceZakladuDaneVal><xsl:value-of select="delivery/sumarize/paid"/></KorekceZakladuDaneVal>
        <KorekceDaneVal><xsl:value-of select="delivery/sumarize/paid"/></KorekceDaneVal>
        <ParovaciZnak><xsl:value-of select="advance_payment/applied_invoices/consumed/number"/></ParovaciZnak>
        <xsl:comment>
        DOTAZ: Zálohových faktur může být více. Do jakého seznamu se mají sestavit?
        </xsl:comment>
    </TabDoplnkovePol>
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
        <Klic>FK_3</Klic>
        <CisloKontace/>
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
        <CisloOrg><xsl:value-of select="client/ico"/></CisloOrg>
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
        <xsl:comment>
        DOTAZ: Údaje v elementech &lt;PoPCislo&gt;, &lt;OrCislo&gt; nerozlišujeme. 
        Číslo je součástí elementu &lt;Ulice&gt;.
        </xsl:comment>
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
        <xsl:comment>
        DOTAZ: Jak moc důležité je předchozí číslo faktury? Je možné jej vynechat?
        </xsl:comment>
        <RadaDokladu><xsl:value-of select="substring(payment/previous_invoice_number, 0, 4)"/></RadaDokladu>
        <PosledniPC><xsl:value-of select="substring(payment/previous_invoice_number, 4)"/></PosledniPC>
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
        <Klic>FK_14</Klic>
        <ZalohovaFaktura>
            <IDZal>FK_15</IDZal>
            <CsDPH1><xsl:value-of select="advance_payment/applied_invoices/consumed/price_with_vat"/></CsDPH1>
            <CbezDPH1><xsl:value-of select="advance_payment/applied_invoices/consumed/price"/></CbezDPH1>
            <CastkaDPH1><xsl:value-of select="advance_payment/applied_invoices/consumed/vat"/></CastkaDPH1>
            <CsDPH1Val><xsl:value-of select="advance_payment/applied_invoices/consumed/price_with_vat"/></CsDPH1Val>
            <CbezDPH1Val><xsl:value-of select="advance_payment/applied_invoices/consumed/price_with_vat"/></CbezDPH1Val>
            <CastkaDPH1Val><xsl:value-of select="advance_payment/applied_invoices/consumed/vat"/></CastkaDPH1Val>
            <SazbaDPH1>FK_2</SazbaDPH1>
            <Popis><xsl:value-of select="advance_payment/applied_invoices/consumed/number"/></Popis>
            <Datum><xsl:value-of select="advance_payment/applied_invoices/consumed/invoice_date"/></Datum>
        </ZalohovaFaktura>
    </Polozka>
</TabZalFak>
<TabDokladyZbozi>
    <Polozka>
        <Klic>FK_15</Klic>
        <DruhPohybuZbo>13</DruhPohybuZbo>
        <PoradoveCislo><xsl:value-of select="substring(advance_payment/applied_invoices/consumed/number, 4)"/></PoradoveCislo>
        <RadaDokladu><xsl:value-of select="substring(advance_payment/applied_invoices/consumed/number, 0, 4)"/></RadaDokladu>
        <DatPorizeni><xsl:value-of select="advance_payment/applied_invoices/consumed/invoice_date"/></DatPorizeni>
    </Polozka>
</TabDokladyZbozi>
</Reference>

</body>
</HeliosIQ_1>
</xsl:template>


</xsl:stylesheet>
