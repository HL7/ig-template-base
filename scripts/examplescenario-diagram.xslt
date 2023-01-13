<?xml version="1.0" standalone="no"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir">
    <xsl:output method="text"/>
	<xsl:template match="/">
<xsl:text>@startuml</xsl:text>
<!--!include fhirskin.iuml-->
<!--
<xsl:apply-templates select="/fhir:ExampleScenario/fhir:process/fhir:title"/>
-->
Title <xsl:value-of select="/fhir:ExampleScenario/fhir:process/fhir:title/@value"/>

<xsl:text>&#13;&#10;</xsl:text>
<xsl:apply-templates select="/fhir:ExampleScenario/fhir:actor"/>
<xsl:text>&#13;&#10;</xsl:text><xsl:apply-templates select="/fhir:ExampleScenario/fhir:process"/><xsl:text>&#13;&#10;</xsl:text>
@enduml
</xsl:template>

<xsl:template match="/fhir:ExampleScenario/process">
<xsl:apply-templates select="./fhir:step"/>
</xsl:template>

<xsl:template match="fhir:step"><xsl:apply-templates select="fhir:operation"/><xsl:apply-templates select="fhir:process"/><xsl:apply-templates select="fhir:pause"/><xsl:apply-templates select="fhir:alternative"/></xsl:template>
<xsl:template match="fhir:operation">
<xsl:text>&#13;&#10;</xsl:text><xsl:value-of select="fhir:initiator/@value"/><xsl:text> </xsl:text><xsl:if test="fhir:dotted/@value='true'">-</xsl:if>-<xsl:text disable-output-escaping="yes">&gt; </xsl:text> <xsl:value-of select="fhir:receiver/@value"/> : <xsl:value-of select="fhir:name/@value"/>\n<xsl:apply-templates select="fhir:request"/><xsl:apply-templates select="fhir:response"/></xsl:template>

<xsl:template match="fhir:step/fhir:process">
group <xsl:value-of select="./fhir:title/@value"/><xsl:text>&#13;&#10;</xsl:text>
<xsl:apply-templates select="./fhir:step"/><xsl:text>&#13;&#10;end</xsl:text>
</xsl:template>


<xsl:template match="fhir:option/fhir:process">
group#A9CCEF #A9CCEF <xsl:value-of select="fhir:title/@value"/><xsl:text>&#13;&#10;</xsl:text>
<xsl:apply-templates select="./fhir:step"/><xsl:text>&#13;&#10;end</xsl:text>
</xsl:template>


<xsl:template match="fhir:step/fhir:alternative">
alt <xsl:value-of select="fhir:name/@value"/> 
<xsl:apply-templates select="fhir:option"/>
<xsl:text>&#13;&#10;</xsl:text>
<xsl:apply-templates select="./fhir:step"/><xsl:text>&#13;&#10;end</xsl:text>
</xsl:template>

<!--
<xsl:template match="alternative/option">
<xsl:value-of select="description/@value"/>
<xsl:apply-templates select="./step"/>
</xsl:template>
-->


<xsl:template match="fhir:alternative/fhir:option"> 
<xsl:choose>
<xsl:when test="position() &lt; 2"> 
alt#blue #A9DCDF </xsl:when>
<xsl:otherwise> 
else </xsl:otherwise>
</xsl:choose>

<xsl:value-of select="fhir:description/@value"/>
<xsl:text>&#13;&#10;</xsl:text>

<xsl:apply-templates select="./fhir:step"/>


</xsl:template>

<xsl:template match="fhir:actor">
<xsl:variable name="actorType" select="fhir:type/@value"/>
<xsl:if test="$actorType='person'">
actor</xsl:if> <xsl:if test="$actorType='entity'">
participant</xsl:if> 
<xsl:text> "</xsl:text><xsl:value-of select="fhir:name/@value"/>" as <xsl:apply-templates select="fhir:actorId/@value"/>
</xsl:template>


<xsl:template match="fhir:step/pause">
...
</xsl:template>


<xsl:template  match="fhir:versionId">
<xsl:variable name="iid" select="../fhir:resourceId/@value"/>
<xsl:variable name="vid" select="../fhir:versionId/@value"/> (<xsl:value-of select="/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:version[fhir:versionId/@value=$vid]/fhir:description/@value"/>)</xsl:template>

<xsl:template  match="fhir:request">
<xsl:if test="./fhir:resourceId">
<xsl:variable name="iid" select="./fhir:resourceId/@value"/>
<xsl:variable name="vid" select="./fhir:versionId/@value"/>
<xsl:text>[[ExampleScenario-</xsl:text><xsl:value-of select="/fhir:ExampleScenario/fhir:id/@value"/><xsl:text>-resources.html#</xsl:text><xsl:value-of select="./fhir:resourceId/@value"/><xsl:text> </xsl:text><xsl:value-of select="/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:name/@value"/> <xsl:apply-templates select="./fhir:versionId"/>]]<xsl:text></xsl:text></xsl:if></xsl:template>

<xsl:template  match="fhir:response">
<xsl:if test="./fhir:resourceId">
<xsl:variable name="iid" select="./fhir:resourceId/@value"/>
<xsl:variable name="vid" select="./fhir:versionId/@value"/>
<xsl:text>[[ExampleScenario-</xsl:text><xsl:value-of select="/fhir:ExampleScenario/fhir:id/@value"/><xsl:text>-resources.html#</xsl:text><xsl:value-of select="./fhir:resourceId/@value"/><xsl:text> </xsl:text><xsl:value-of select="/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:name/@value"/> <xsl:apply-templates select="./fhir:versionId"/>]]<xsl:text></xsl:text></xsl:if></xsl:template>


</xsl:stylesheet>

