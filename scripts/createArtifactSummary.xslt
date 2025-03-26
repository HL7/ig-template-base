<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:f="http://hl7.org/fhir">
  <xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:param name="columns" select="3"/>
  <xsl:param name="version"/>
  <xsl:param name="globals"/>
  <xsl:template match="f:ImplementationGuide">
    <!-- Include a note in the output with breadcrumbs back to this script -->
    <xsl:comment>DO NOT EDIT THIS FILE - It is generated by https://github.com/HL7/ig-template-base/blob/master/scripts/createArtifactSummary.xslt and any changes made will be overwritten</xsl:comment>
    <div class="markdown-toc">
      <p>Contents:</p>
      <ul>
        <xsl:if test="$globals='Y'">
          <li>
            <a href="#globals">Globals</a>
          </li>
        </xsl:if>
        <xsl:for-each select="f:definition/f:grouping">
          <li>
            <a href="#{position()}">
              <xsl:value-of select="f:name/@value"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </div>
    <div>
      <p>This page provides a list of the FHIR artifacts defined as part of this implementation guide.</p>
      <xsl:if test="$globals='Y'">
        <a name="globals">
          <xsl:value-of select="' '"/>
        </a>
        <h3>Global profiles</h3>
        {% include globals-table.xhtml %}
      </xsl:if>
      <xsl:for-each select="f:definition/f:grouping">
        <xsl:variable name="relevantResources">
          <xsl:for-each select="f:resource[f:extension[@url='http://hl7.org/fhir/StructureDefinition/implementationguide-page']][not(f:extension[@url='http://hl7.org/fhir/StructureDefinition/tools-alternateVersion'] or $version) or (f:extension[@url='http://hl7.org/fhir/StructureDefinition/tools-alternateVersion']/f:valueCode/@value=$version)]|
          parent::f:definition/f:resource[f:extension[@url='http://hl7.org/fhir/StructureDefinition/implementationguide-page']][f:package/@value=current()/@id or f:groupingId/@value=current()/@id][not(f:extension[@url='http://hl7.org/fhir/StructureDefinition/tools-alternateVersion'] or $version) or (f:extension[@url='http://hl7.org/fhir/StructureDefinition/tools-alternateVersion']/f:valueCode/@value=$version)]">content</xsl:for-each>
        </xsl:variable>
        <xsl:if test="$relevantResources">
          <a name="{position()}">
            <xsl:value-of select="' '"/>
          </a>
          <h3>
            <xsl:value-of select="concat(f:name/@value, ' ')"/> 
          </h3>
          <xsl:apply-templates select="."/>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template match="f:grouping">
      <xsl:text>{% capture grouping_desc %}</xsl:text>
      <xsl:value-of select="f:description/@value" disable-output-escaping="no"/>
       <xsl:text>{% endcapture %}
    {{ grouping_desc | markdownify}}</xsl:text>
      <xsl:variable name="showDescriptions" select="count(parent::f:definition/f:resource[f:groupingId/@value=current()/@id]/f:description/@value)!=0"/>
      <table class="grid">
        <col style="width:20%"/>
		<thead>
		<tr>		
			<td>Title</td>
			<td>Artifact Id</td>
			<td>Description</td>		
		</tr>
		</thead>
        <tbody>
          <xsl:for-each select="parent::f:definition/f:resource[f:groupingId/@value=current()/@id]">
            <tr>
              <td style="column-width:30%">
                <a href="{f:extension[@url='http://hl7.org/fhir/StructureDefinition/implementationguide-page']/f:valueUri/@value}" title="{f:reference/f:reference/@value}">
<!--                  <xsl:text>&#160;&#160;&#x2022;&#160;&#160;</xsl:text>-->
                  <xsl:choose>
                    <xsl:when test="f:name">
                      <xsl:value-of select="f:name/@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="f:reference/f:reference/@value"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </td>
			  <td>
                <xsl:value-of select="f:reference/f:reference/@value"/>			
              </td>
              <xsl:if test="$showDescriptions">
                <td>
                  <xsl:text>{% capture desc %}</xsl:text>
                  <xsl:value-of select="f:description/@value" disable-output-escaping="no"/>
                  <xsl:text>{% endcapture %}
{{ desc | markdownify}}</xsl:text>
                </td>
              </xsl:if>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
  </xsl:template>
  <xsl:template match="f:grouping" mode="first">
    <tr>
      <xsl:apply-templates select=".|following-sibling::f:grouping[position() &lt; $columns]" mode="next"/>
      <xsl:if test="count(following-sibling::f:grouping) &lt; ($columns - 1)">
        <xsl:call-template name="emptycell">
          <xsl:with-param name="cells" select="$columns - 1 - count(following-sibling::f:grouping)"/>
        </xsl:call-template>
      </xsl:if>
    </tr>
    <tr colspan="3">
      <td>&#160;</td>
    </tr>
  </xsl:template>
  <xsl:template match="f:grouping" mode="next">
    <td style="column-width:30%">
      <a href="{translate(concat('#',name/@value), ' ', '_')}">
        <xsl:number/>. <xsl:value-of select="f:name/@value"/> &#160;&#160;&#160;&#9654;</a>
    </td>
  </xsl:template>
  <xsl:template name="emptycell">
    <xsl:param name="cells"/>
    <td/>
    <xsl:if test="$cells &gt; 1">
      <xsl:call-template name="emptycell">
        <xsl:with-param name="cells" select="$cells - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
