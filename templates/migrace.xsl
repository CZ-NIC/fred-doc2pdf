<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY nbsp "&#160;">
    <!ENTITY mdash "&#8212;">
    <!ENTITY gt "&#62;">
    <!ENTITY ndash "&#8211;">
    <!ENTITY rsaquo "&#8250;">
    
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:epp="urn:ietf:params:xml:ns:epp-1.1"
    xmlns:dsdDomain="urn:cznic:params:xml:ns:dsdDomain-1.1"
    xmlns:dsdSubject="urn:cznic:params:xml:ns:dsdSubject-1.1"
    xmlns:dsdContact="urn:cznic:params:xml:ns:dsdContact-1.1"
    >
<xsl:output method="html" encoding="utf-8"/>
<xsl:param name="path" select="'../templates/'" />
<!-- ===================================================

        SHARED

=================================================== -->

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>NIC.CZ - Data Migration</title>
    <link rel="stylesheet" media="screen" type="text/css" href="{$path}migrace.css" />
</head>
<body>

<h1>Data Migration</h1>

<xsl:apply-templates />

<div class="footnote">
<strong>Explanation:</strong>
<table class="tab1">
<tr>
    <td>value moves to new system</td>
</tr>
<tr>
    <td class="expire">value expires</td>
</tr>
</table>
</div>

</body>
</html>
</xsl:template>

<xsl:template match="epp:epp">
<!-- epp -->
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="epp:response">
<!-- response -->
<p class="notimportant">
<xsl:apply-templates select="epp:result|epp:trID" />
</p>
<xsl:apply-templates select="epp:resData" />
<hr/>
</xsl:template>

<xsl:template match="epp:result">
<strong>code</strong>: <xsl:value-of select="@code" />;
<strong>message</strong>: <xsl:value-of select="epp:msg" />;
</xsl:template>

<xsl:template match="epp:resData">
<!-- resData -->
<xsl:apply-templates />
</xsl:template>

<xsl:template match="epp:trID">
<strong>trID.svTRID</strong>: <xsl:value-of select="epp:svTRID" /><br/>
</xsl:template>

<xsl:template match="dsdDomain:upID|dsdSubject:upID">
<tr>
    <th><xsl:value-of select="name()" /></th>
    <td>
    <table class="tab2">
    <tr>
        <th>IDreg</th>
        <td><xsl:value-of select="dsdDomain:IDreg|dsdSubject:IDreg" /></td>
    </tr>
    <tr>
        <th>IDcont</th>
        <td class="expire"><xsl:value-of select="dsdDomain:IDcont|dsdSubject:IDcont" /></td>
    </tr>
    </table>
    </td>
    <th class="sep">&mdash;&gt;</th>
    <th>
    <xsl:if test="name() = 'dsdDomain:upID'">domain</xsl:if>
    <xsl:if test="name() = 'dsdSubject:upID'">contact</xsl:if>:upID</th>
    <td><xsl:value-of select="dsdDomain:IDreg|dsdSubject:IDreg" /></td>
</tr>
</xsl:template>

<xsl:template match="dsdDomain:PGPkey|dsdContact:PGPkey">
<pre class="pgpkey"><xsl:value-of select="." /></pre>
</xsl:template>

<xsl:template match="dsdDomain:status|dsdSubject:status|dsdContact:status">
<tr>
    <th><xsl:value-of select="name()" /></th>
    <td class="expire"><xsl:value-of select="." /><br/>
    <strong>s</strong>: <xsl:value-of select="./@s" />
    </td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>
</xsl:template>

<xsl:template match="dsdSubject:postalInfo|dsdContact:postalInfo">
    <table class="tab2">
    <tr><th>type</th><td class="expire"><xsl:value-of select="./@type" /></td></tr>
    <xsl:apply-templates />
    </table>
</xsl:template>

<xsl:template match="dsdSubject:addr|dsdContact:addr">
<tr>
    <th>street</th>
    <td><xsl:value-of select="dsdSubject:street|dsdContact:street" /></td>
</tr>
<tr>
    <th>city</th>
    <td><xsl:value-of select="dsdSubject:city|dsdContact:city" /></td>
</tr>
<tr>
    <th>zip</th>
    <td><xsl:value-of select="dsdSubject:zip|dsdContact:zip" /></td>
</tr>
<tr>
    <th>country</th>
    <td><xsl:value-of select="dsdSubject:country|dsdContact:country" /></td>
</tr>
</xsl:template>

<xsl:template match="contact_address">
<tr>
    <th>street</th>
    <td><xsl:value-of select="dsdSubject:street|dsdContact:street" /></td>
</tr>
<tr>
    <th>city</th>
    <td><xsl:value-of select="dsdSubject:city|dsdContact:city" /></td>
</tr>
<tr>
    <th>pc</th>
    <td><xsl:value-of select="dsdSubject:zip|dsdContact:zip" /></td>
</tr>
<tr>
    <th>cc</th>
    <td><xsl:value-of select="dsdSubject:country|dsdContact:country" /></td>
</tr>
</xsl:template>

<xsl:template match="dsdDomain:fnameAndLname|dsdSubject:fnameAndLname|dsdContact:fnameAndLname">
<table class="tab2">
    <tr><th>fname</th><td><xsl:value-of select="dsdDomain:fname|dsdSubject:fname|dsdContact:fname" /></td></tr>
    <tr><th>lname</th><td><xsl:value-of select="dsdDomain:lname|dsdSubject:lname|dsdContact:lname" /></td></tr>
</table>
</xsl:template>


<!-- ===================================================

        DOMAIN

=================================================== -->

<xsl:template match="dsdDomain:infData">
<!-- dsdDomain:infData -->
<table class="tab1">
<caption>Domain</caption>
<tr class="header">
    <th>Old name</th>
    <th>Old value</th>
    <th class="sep"></th>
    <th>New name</th>
    <th>New value</th>
</tr>
<tr>
    <th>dsdDomain:name</th>
    <td><xsl:value-of select="dsdDomain:name" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:name</th>
    <td><xsl:value-of select="dsdDomain:name" /></td>
</tr>

<tr>
    <th>dsdDomain:description</th>
    <td class="expire"><xsl:value-of select="dsdDomain:description" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<xsl:apply-templates select="dsdDomain:status" />

<tr>
    <th id="dsdDomain_idadm">dsdDomain:idadm</th>
    <td><xsl:value-of select="dsdDomain:idadm" /> &nbsp;<span class="direction"><a href="#subject_admin" title="Use  dsdSubject:admin-c as registrant">&ndash;&gt;</a></span></td>
    <th class="sep"></th>
    <th>domain:registrant</th>
    <td><a href="#subject_{dsdDomain:idadm}" title="Go to subject {dsdDomain:idadm}"><xsl:value-of select="dsdDomain:idadm" /></a>
    </td>
</tr>
<tr>
    <th id="dsdDomain_idtech">dsdDomain:idtech</th>
    <td><xsl:value-of select="dsdDomain:idtech" /> &nbsp;<span class="direction"><a href="#subject_tech" title="Use dsdSubject:admin-c as techcontact">&ndash;&gt;</a></span></td>
    <th class="sep"></th>
    <th id="domain_admin">domain:admin<br/><span class="direction"><a href="#subject_admin" title="Migration from dsdSubject:admin-c">&ndash;&rsaquo;|</a></span></th>
    <td>
        <xsl:for-each select="//epp:epp/epp:response/epp:resData/dsdSubject:infData">
            <xsl:if test="dsdSubject:id = //epp:epp/epp:response/epp:resData/dsdDomain:infData/dsdDomain:idadm">
                <xsl:for-each select="dsdSubject:admin-c">
                    <a href="#contact_{.}" title="Go to contact {.}"><xsl:value-of select="." /></a><br/>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </td>
</tr>

<tr>
    <th>dsdDomain:dns</th>
    <td>

    <table class="tab2">
    <tr>
        <th colspan="2" class="title">dsdDomain:nserver</th>
    </tr>
    <xsl:apply-templates select="dsdDomain:dns" />
    </table>

    </td>
    <th class="sep"></th>
    <th>NSSET</th>
    <td>
    <table class="tab2">
        <tr>
            <th>id</th>
            <td><xsl:value-of select="dsdDomain:name" /></td>
        </tr>
        <tr>
            <th>DNS</th>
            <td>
            <table class="tab2">
            <xsl:for-each select="dsdDomain:dns/dsdDomain:nserver">
            <tr>
                <th>name</th>
                <td><xsl:value-of select="dsdDomain:ns" /></td>
            </tr>
            <tr>
                <th>addr</th>
                <td><xsl:value-of select="dsdDomain:IPaddress" /></td>
            </tr>
            </xsl:for-each>
            </table>
            </td>
        </tr>
        <tr>
            <th id="nsset_tech">tech<br/><span class="direction"><a href="#subject_tech" title="Migration from dsdSubject:tech-c">&ndash;&rsaquo;|</a></span></th>
            <td>

        <xsl:for-each select="//epp:epp/epp:response/epp:resData/dsdSubject:infData">
            <xsl:if test="dsdSubject:id = //epp:epp/epp:response/epp:resData/dsdDomain:infData/dsdDomain:idtech">
                <xsl:for-each select="dsdSubject:admin-c">
                    <a href="#contact_{.}" title="Go to contact {.}"><xsl:value-of select="." /></a><br/>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>


            </td>
        </tr>
        <tr>
            <th>auth_info</th>
            <td></td>
        </tr>
        <tr>
            <th>reportlevel</th>
            <td></td>
        </tr>
    </table>
    </td>
</tr>
<tr>
    <th>dsdDomain:pubkey</th>
    <td class="expire"><xsl:value-of select="dsdDomain:pubkey" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>
<tr>
    <th>dsdDomain:notify</th>
    <td><xsl:value-of select="dsdDomain:notify" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:notify</th>
    <td><xsl:value-of select="dsdDomain:notify" /></td>
</tr>
<tr>
    <th>dsdDomain:notifyType</th>
    <td class="expire"><xsl:value-of select="dsdDomain:notifyType" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdDomain:ReqAuth</th>
    <td class="expire"><xsl:value-of select="dsdDomain:ReqAuth" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdDomain:regID</th>
    <td><xsl:value-of select="dsdDomain:regID" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:clID</th>
    <td><xsl:value-of select="dsdDomain:regID" /></td>
</tr>

<tr>
    <th>dsdDomain:crID</th>
    <td><xsl:value-of select="dsdDomain:crID" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:crID</th>
    <td><xsl:value-of select="dsdDomain:crID" /></td>
</tr>

<tr>
    <th>dsdDomain:crDate</th>
    <td><xsl:value-of select="dsdDomain:crDate" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:crDate</th>
    <td><xsl:value-of select="dsdDomain:crDate" /></td>
</tr>
<tr>
    <th>dsdDomain:upDate</th>
    <td><xsl:value-of select="dsdDomain:upDate" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:upDate</th>
    <td><xsl:value-of select="dsdDomain:upDate" /></td>
</tr>
<tr>
    <th>dsdDomain:exDate</th>
    <td><xsl:value-of select="dsdDomain:exDate" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:exDate</th>
    <td><xsl:value-of select="dsdDomain:exDate" /></td>
</tr>
<tr>
    <th>dsdDomain:trDate</th>
    <td><xsl:value-of select="dsdDomain:trDate" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>domain:trDate</th>
    <td><xsl:value-of select="dsdDomain:trDate" /></td>
</tr>

<xsl:apply-templates select="dsdDomain:upID" />

<tr>
    <th>dsdDomain:Agreement</th>
    <td class="expire">

    <table class="tab2">
    <tr>
        <th>fnameAndLname</th>
        <td><xsl:apply-templates select="dsdDomain:Agreement/dsdDomain:fnameAndLname" /></td>
    </tr>
    <tr>
        <th>version</th>
        <td><xsl:value-of select="dsdDomain:Agreement/dsdDomain:version" /></td>
    </tr>
    <tr>
        <th>Date</th>
        <td><xsl:value-of select="dsdDomain:Agreement/dsdDomain:Date" /></td>
    </tr>
    </table>

</td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>domain:authInfo</th>
    <td></td>
</tr>
<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>domain:roid</th>
    <td></td>
</tr>

</table>

</xsl:template>

<xsl:template match="dsdDomain:dns">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="dsdDomain:nserver">
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <th>ns</th>
        <td><xsl:value-of select="dsdDomain:ns" /></td>
    </tr>
    <tr>
        <th>IPaddress</th>
        <td><xsl:value-of select="dsdDomain:IPaddress" /><br/>
        <span class="expire"><strong>ip</strong>: <xsl:value-of select="dsdDomain:IPaddress/@ip" /></span>
        </td>
    </tr>
    <tr>
        <th>typ</th>
        <td class="expire"><xsl:value-of select="dsdDomain:typ" /></td>
    </tr>
</xsl:template>


<!-- ===================================================

        SUBJECT

=================================================== -->

<xsl:template match="dsdSubject:infData">
<table class="tab1">
<caption><span class="direction"><a href="javascript:window.scrollTo(0,0)" title="Go to TOP of thje page">^</a></span> Subject <span class="direction"><a href="javascript:window.scrollTo(0,0)" title="Go to TOP of thje page">^</a></span></caption>
<tr class="header">
    <th>Old name</th>
    <th>Old value</th>
    <th class="sep"></th>
    <th>New name</th>
    <th>New value</th>
</tr>

<tr>
    <th id="subject_{dsdSubject:id}">dsdSubject:id</th>
    <td>
    <xsl:if test="dsdSubject:id = //epp:epp/epp:response/epp:resData/dsdDomain:infData/dsdDomain:idadm">
       <span id="subject_admin" class="direction"><a href="#dsdDomain_idadm" title="Migration from dsdDomain:idadm">&ndash;&rsaquo;|</a></span>
    </xsl:if>
    <xsl:if test="dsdSubject:id = //epp:epp/epp:response/epp:resData/dsdDomain:infData/dsdDomain:idtech">
       <span id="subject_tech" class="direction"><a href="#dsdDomain_idtech" title="Migration from dsdDomain:idtech">&ndash;&rsaquo;|</a></span>
    </xsl:if>
    &nbsp; <xsl:value-of select="dsdSubject:id" />
    </td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:id</th>
    <td><xsl:value-of select="dsdSubject:id" /></td>
</tr>

<xsl:apply-templates select="dsdSubject:status" />

<tr>
    <th>dsdSubject:subjTyp</th>
    <td class="expire"><xsl:value-of select="dsdSubject:subjTyp" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdSubject:name</th>
    <td><xsl:value-of select="dsdSubject:name" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th><xsl:if test="dsdSubject:subjTyp = 'P' or dsdSubject:subjTyp = 'N'">contact:org</xsl:if>
        <xsl:if test="dsdSubject:subjTyp = 'F'">contact:name</xsl:if>
    </th>
    <td><xsl:value-of select="dsdSubject:name" /> &nbsp;<span class="direction"><a href="javascript:alert('CONDITION:\nIF dsdSubject:subjTyp == P,N:\n\tdsdSubject:name -> contact:org\nIF dsdSubject:subjTyp == F:\n\tdsdSubject:name -> contact:name')" title="The condition explanation">?</a></span></td>
</tr>

<tr>
    <th>dsdSubject:fnameAndLname</th>
    <td><xsl:apply-templates select="dsdSubject:fnameAndLname" /></td>
    <th class="sep"></th>
    <th><xsl:if test="dsdSubject:subjTyp = 'P' or dsdSubject:subjTyp = 'N' and dsdSubject:fnameAndLname/dsdSubject:lname">contact:name</xsl:if>
    </th>
    <td></td>
</tr>

<tr>
    <th>dsdSubject:DateOfBirth</th>
    <td class="expire"><xsl:value-of select="dsdSubject:DateOfBirth" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdSubject:ico</th>
    <td class="expire"><xsl:value-of select="dsdSubject:ico" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdSubject:dic</th>
    <td><xsl:value-of select="dsdSubject:dic" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:vat</th>
    <td><xsl:value-of select="dsdSubject:dic" /></td>
</tr>

<tr>
    <th>dsdSubject:bank</th>
    <td class="expire"><xsl:value-of select="dsdSubject:bank" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdSubject:postalInfo</th>
    <td><xsl:apply-templates select="dsdSubject:postalInfo" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact</th>
    <td><table class="tab2">
        <tr>
            <th>street</th>
            <td><xsl:value-of select="dsdSubject:postalInfo/dsdSubject:addr/dsdSubject:street" /></td>
        </tr>
        <tr>
            <th>city</th>
            <td><xsl:value-of select="dsdSubject:postalInfo/dsdSubject:addr/dsdSubject:city" /></td>
        </tr>
        <tr>
            <th>pc</th>
            <td><xsl:value-of select="dsdSubject:postalInfo/dsdSubject:addr/dsdSubject:zip" /></td>
        </tr>
        <tr>
            <th>cc</th>
            <td><xsl:value-of select="dsdSubject:postalInfo/dsdSubject:addr/dsdSubject:country" /></td>
        </tr>
        <tr>
            <th>sp</th>
            <td></td>
        </tr>
    </table>
    </td>
</tr>

<tr>
    <th>dsdSubject:notifyType</th>
    <td class="expire"><xsl:value-of select="dsdSubject:notifyType" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdSubject:notify</th>
    <xsl:choose>
        <xsl:when test="dsdSubject:notifyType = 'C' or dsdSubject:notifyType = 'N'">
            <td><xsl:value-of select="dsdSubject:notify" /></td>
            <th class="sep">&mdash;&gt;</th>
            <th>contact:notifyEmail</th>
            <td><xsl:value-of select="dsdSubject:notify" /></td>
        </xsl:when>
        <xsl:otherwise>
            <td class="expire"><xsl:value-of select="dsdSubject:notify" /></td>
            <th class="sep"></th>
            <th></th>
            <td></td>
        </xsl:otherwise>
    </xsl:choose>
</tr>

<tr>
    <th>dsdSubject:email</th>
    <td><xsl:value-of select="dsdSubject:email" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:email</th>
    <td><xsl:value-of select="dsdSubject:email" /></td>
</tr>

<tr>
    <th>dsdSubject:ReqAuth</th>
    <td class="expire"><xsl:value-of select="dsdSubject:ReqAuth" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<xsl:apply-templates select="dsdSubject:admin-c" />
<xsl:apply-templates select="dsdSubject:tech-c" />
<xsl:apply-templates select="dsdSubject:acc-c" />

<tr>
    <th>dsdSubject:crID</th>
    <td><xsl:value-of select="dsdSubject:crID" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:crID</th>
    <td><xsl:value-of select="dsdSubject:crID" /></td>
</tr>

<tr>
    <th>dsdSubject:crDate</th>
    <td><xsl:value-of select="dsdSubject:crDate" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:crDate</th>
    <td><xsl:value-of select="dsdSubject:crDate" /></td>
</tr>

<xsl:apply-templates select="dsdSubject:upID" />

<tr>
    <th>dsdSubject:upDate</th>
    <td><xsl:value-of select="dsdSubject:upDate" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:upDate</th>
    <td><xsl:value-of select="dsdSubject:upDate" /></td>
</tr>

<tr>
    <th>dsdSubject:upID</th>
    <td></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:clID</th>
    <td><xsl:value-of select="dsdSubject:upID/dsdSubject:IDreg" /></td>
</tr>

<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>contact:authInfo</th>
    <td></td>
</tr>
<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>contact:roid</th>
    <td></td>
</tr>

</table>
</xsl:template>


<xsl:template match="dsdSubject:admin-c">
<tr>
    <th id="admin-c">dsdSubject:admin-c</th>
    <td><xsl:value-of select="." /></td>
    <th class="sep">&mdash;&gt;</th>

    <th>
    <xsl:if test="../dsdSubject:id = //epp:epp/epp:response/epp:resData/dsdDomain:infData/dsdDomain:idadm">
        domain:admin <span class="direction"><a href="#domain_admin" title="Migration to domain:admin">|&ndash;&rsaquo;&rsaquo;</a></span>
    </xsl:if>
    <xsl:if test="../dsdSubject:id = //epp:epp/epp:response/epp:resData/dsdDomain:infData/dsdDomain:idtech">
        domain:tech <span class="direction"><a href="#nsset_tech" title="Migration to nsset:tech">|&ndash;&rsaquo;&rsaquo;</a></span>
    </xsl:if>
    </th>

    <td><xsl:value-of select="." /></td>
</tr>
</xsl:template>

<xsl:template match="dsdSubject:tech-c">
<tr>
    <th>dsdSubject:tech-c</th>
    <td class="expire"><xsl:value-of select="." /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>
</xsl:template>

<xsl:template match="dsdSubject:acc-c">
<tr>
    <th>dsdSubject:acc-c</th>
    <td class="expire"><xsl:value-of select="." /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>
</xsl:template>


<!-- ===================================================

        CONTACT

=================================================== -->
<xsl:template match="dsdContact:infData">
<table class="tab1">
<caption><span class="direction"><a href="javascript:window.scrollTo(0,0)" title="Go to TOP of thje page">^</a></span> Contact <span class="direction"><a href="javascript:window.scrollTo(0,0)" title="Go to TOP of thje page">^</a></span></caption>
<tr class="header">
    <th>Old name</th>
    <th>Old value</th>
    <th class="sep"></th>
    <th>New name</th>
    <th>New value</th>
</tr>
<tr>
    <th id="contact_{dsdContact:id}">dsdContact:id</th>
    <td><xsl:value-of select="dsdContact:id" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:id</th>
    <td><xsl:value-of select="dsdContact:id" /></td>
</tr>
<xsl:apply-templates select="dsdContact:status" />
<tr>
    <th>fnameAndLname</th>
    <td>
    <table class="tab2">
       <tr><th>fname</th><td><xsl:value-of select="dsdContact:fnameAndLname/dsdContact:fname" /></td></tr>
       <tr><th>lname</th><td><xsl:value-of select="dsdContact:fnameAndLname/dsdContact:lname" /></td></tr>
    </table>
    </td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:name</th>
    <td><xsl:value-of select="dsdContact:fnameAndLname/dsdContact:fname" />&nbsp;<xsl:value-of select="dsdContact:fnameAndLname/dsdContact:lname" /></td>
</tr>
<tr>
    <th>dsdContact:postalInfo</th>
    <td>
    <xsl:apply-templates select="dsdContact:postalInfo" />
    </td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact</th>
    <td><table class="tab2">
        <tr>
            <th>street</th>
            <td><xsl:value-of select="dsdContact:postalInfo/dsdContact:addr/dsdContact:street" /></td>
        </tr>
        <tr>
            <th>city</th>
            <td><xsl:value-of select="dsdContact:postalInfo/dsdContact:addr/dsdContact:city" /></td>
        </tr>
        <tr>
            <th>pc</th>
            <td><xsl:value-of select="dsdContact:postalInfo/dsdContact:addr/dsdContact:zip" /></td>
        </tr>
        <tr>
            <th>cc</th>
            <td><xsl:value-of select="dsdContact:postalInfo/dsdContact:addr/dsdContact:country" /></td>
        </tr>
        <tr>
            <th>sp</th>
            <td></td>
        </tr>
    </table>
    </td>
</tr>

<tr>
    <th>dsdContact:voice</th>
    <td><xsl:value-of select="dsdContact:voice" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:voice</th>
    <td><xsl:value-of select="dsdContact:voice" /></td>
</tr>

<tr>
    <th>dsdContact:fax</th>
    <td><xsl:value-of select="dsdContact:fax" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:fax</th>
    <td><xsl:value-of select="dsdContact:fax" /></td>
</tr>

<tr>
    <th>dsdContact:email</th>
    <td><xsl:value-of select="dsdContact:email" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:email</th>
    <td><xsl:value-of select="dsdContact:email" /></td>
</tr>

<tr>
    <th>dsdContact:notify</th>
    <td><xsl:value-of select="dsdContact:notify" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:notifyEmail</th>
    <td><xsl:value-of select="dsdContact:notify" /></td>
</tr>
<tr>
    <th>dsdContact:identityCardNum</th>
    <td><xsl:value-of select="dsdContact:identityCardNum" /><br/>
    <strong>identityCardSort</strong>: <xsl:value-of select="dsdContact:identityCardNum/@identityCardSort" /></td>
    <th class="sep">&mdash;&gt;</th>
    <th>contact:ident</th>
    <td>
    <table class="tab2">
        <tr><th>type</th><td>??? (op,rc,passport,mpsv,ico)</td></tr>
        <tr><th>number</th><td><xsl:value-of select="dsdContact:identityCardNum" /></td></tr>
    </table>
    </td>
</tr>

<tr>
    <th>dsdContact:notifyType</th>
    <td class="expire"><xsl:value-of select="dsdContact:notifyType" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th>dsdContact:passwordExists</th>
    <td class="expire"><xsl:value-of select="dsdContact:passwordExists" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>
<tr>
    <th>dsdContact:PGPKey</th>
    <td class="expire"><xsl:apply-templates select="dsdContact:PGPkey" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>
<tr>
    <th>dsdContact:DateOfBirth</th>
    <td class="expire"><xsl:apply-templates select="dsdContact:DateOfBirth" /></td>
    <th class="sep"></th>
    <th></th>
    <td></td>
</tr>

<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>contact:vat</th>
    <td></td>
</tr>
<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>contact:authInfo</th>
    <td></td>
</tr>
<tr>
    <th></th>
    <td></td>
    <th class="sep"></th>
    <th>contact:org</th>
    <td></td>
</tr>


</table>

</xsl:template>


</xsl:stylesheet>