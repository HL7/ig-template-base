<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Integrate the 'default' groupings with any custom groupings, sorting ones that start with '-' to intermix with other 'standard' groupings
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:f="http://hl7.org/fhir" exclude-result-prefixes="f">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="f:definition">
    <xsl:copy>
      <xsl:apply-templates select="@*|f:extension|f:modifierExtension"/>
      <xsl:call-template name="doGroupings"/>
      <xsl:apply-templates select="node()[not(self::f:extension or self::f:modifierExtension or self::f:grouping or self::f:groups)]"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="doGroupings">
    <xsl:apply-templates select="f:grouping[not(starts-with(@id, '-'))]"/>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-req'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-dyn'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-ka'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-str'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-term'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-map'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-test'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-ex'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-other'"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="doGrouping">
    <xsl:param name="prefix"/>
    <xsl:for-each select="f:groups/f:grouping[starts-with(@id, $prefix)]">
      <xsl:copy>
        <xsl:choose>
          <xsl:when test="parent::f:groups/parent::*/f:grouping[@id=current()/@id]">
            <xsl:for-each select="parent::f:groups/parent::*/f:grouping[@id=current()/@id]">
              <xsl:apply-templates select="@*|node()"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:for-each>
    <xsl:for-each select="f:grouping[starts-with(@id, $prefix)]">
      <xsl:if test="not(parent::*/f:groups/f:grouping[@id=current()/@id])">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>