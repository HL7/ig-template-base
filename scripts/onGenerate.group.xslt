<?xml version="1.0" encoding="UTF-8"?>
<!--
  - This script ensures that all artifacts are assigned to a 'grouping' and, when necessary, defines additional groupings to hold un-grouped artifacts
  - when dealing with a multi-version IG, it will be run against both IG versions.
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:f="http://hl7.org/fhir" exclude-result-prefixes="html f">
  <xsl:output method="xml" version="1.0" encoding="UTF-8"/>
  <xsl:variable name="mode">
    <xsl:choose>
      <xsl:when test="not(f:definition/f:grouping[not(contains(@id, 'spreadsheet.xml'))])">allgroups</xsl:when>
      <xsl:when test="f:resource[not(f:groupingId)]">defaultgroup</xsl:when>
      <xsl:otherwise>noaction</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/f:ImplementationGuide">
    <xsl:choose>
      <xsl:when test="$mode='noaction'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="f:definition">
    <xsl:copy>
      <xsl:apply-templates select="@*|f:id|f:extension|f:modifierExtension|f:grouping|comment()[not(preceding-sibling::f:resource|preceding-sibling::f:page)]"/>
      <!-- This is a placeholder that will be replaced with the list of groups from this template.  (We use a separate file so they're easier to override/translate.) -->
      <groups xmlns="http://hl7.org/fhir">
        <xsl:comment>TEMPLATE_GROUPS_HERE</xsl:comment>
      </groups>
      <xsl:apply-templates select="f:resource|f:page|f:parameter|f:template|comment()[preceding-sibling::f:resource|preceding-sibling::f:page]"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="f:resource">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(f:extension[@url='http://hl7.org/fhir/tools/StructureDefinition/resource-sort'])">
        <extension xmlns="http://hl7.org/fhir" url="http://hl7.org/fhir/tools/StructureDefinition/resource-sort">
          <valueInteger value="999999999"/>
        </extension>
      </xsl:if>
      <xsl:apply-templates select="node()[not(self::f:groupingId)]"/>
      <xsl:choose>
        <xsl:when test="f:extension[@url='http://hl7.org/fhir/StructureDefinition/implementationguide-page'] and (not(f:groupingId) or contains(f:groupingId/@value, 'spreadsheet.xml'))">
          <xsl:variable name="infoExt" select="f:extension[@url='http://hl7.org/fhir/tools/StructureDefinition/resource-information']/f:valueString/@value"/>
          <xsl:variable name="groupingId">
            <xsl:choose>
              <xsl:when test="$mode='defaultgroup'">-other</xsl:when>
              <xsl:when test="f:exampleBoolean/@value='true' or f:exampleCanonical">-ex-example</xsl:when>
              <xsl:when test="$infoExt='ActorDefinition'">-req-actordefinition</xsl:when>
              <xsl:when test="$infoExt='Requirements'">-req-requirements</xsl:when>
              <xsl:when test="$infoExt='CapabilityStatement'">-dyn-capabilitystatement</xsl:when>
              <xsl:when test="$infoExt='OperationDefinition'">-dyn-operationdefinition</xsl:when>
              <xsl:when test="$infoExt='MessageDefinition'">-dyn-messagedefinition</xsl:when>
              <xsl:when test="$infoExt='SearchParameter'">-dyn-searchparameter</xsl:when>
              <xsl:when test="$infoExt='ActivityDefinition'">-ka-activitydefinition</xsl:when>
              <xsl:when test="$infoExt='Measure'">-ka-measure</xsl:when>
              <xsl:when test="$infoExt='PlanDefinition'">-ka-plandefinition</xsl:when>
              <xsl:when test="$infoExt='Library'">-ka-library</xsl:when>
              <xsl:when test="$infoExt='GraphDefinition'">-str-graphdefinition</xsl:when>
              <xsl:when test="starts-with($infoExt,'StructureDefinition:logical')">-str-logicalmodel</xsl:when>
              <xsl:when test="$infoExt='Questionnaire'">-str-questionnaire</xsl:when>
              <xsl:when test="$infoExt='StructureDefinition:resource:abstract' or $infoExt='StructureDefinition:primitive-type:abstract' or $infoExt='StructureDefinition:complex-type:abstract'">-str-abstractprofile</xsl:when>
              <xsl:when test="$infoExt='StructureDefinition:resource'">-str-profile</xsl:when>
              <xsl:when test="$infoExt='StructureDefinition:primitive-type' or $infoExt='StructureDefinition:complex-type'">-str-datatype</xsl:when>
              <xsl:when test="$infoExt='StructureDefinition:extension'">-str-extension</xsl:when>
              <xsl:when test="$infoExt='ValueSet'">-term-valueset</xsl:when>
              <xsl:when test="$infoExt='CodeSystem'">-term-codesystem</xsl:when>
              <xsl:when test="$infoExt='NamingSystem'">-term-namingsystem</xsl:when>
              <xsl:when test="$infoExt='StructureMap'">-map-structuremap</xsl:when>
              <xsl:when test="$infoExt='ConceptMap'">-map-conceptmap</xsl:when>
              <xsl:when test="$infoExt='ExampleScenario'">-ex-examplescenario</xsl:when>
              <xsl:when test="$infoExt='TestPlan'">-test-testplan</xsl:when>
              <xsl:when test="$infoExt='TestScript'">-test-testscript</xsl:when>
              <xsl:otherwise>-other</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <groupingId xmlns="http://hl7.org/fhir" value="{$groupingId}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="f:groupingId"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
