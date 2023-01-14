<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fhir="http://hl7.org/fhir" version="1.0">
    <xsl:output method="html" />
    <xsl:param name="pref" select="pref" />
	<xsl:template match="/">


		<div>
			<!-- <h3><a name="description" />Description</h3> -->
			<div>
				<table class="table-bordered" style="width:100%">
					<tr>
						<td style="width:25%">Publisher: <xsl:value-of select="/fhir:ExampleScenario/fhir:publisher/@value" /></td>
						<td style="width:25%"><a href="versions.html#maturity">Status</a>: <xsl:value-of select="/fhir:ExampleScenario/fhir:status/@value" /></td>
						<td style="width:25%"><a href="versions.html#maturity">Experimental</a>: <xsl:value-of select="/fhir:ExampleScenario/fhir:experimental/@value" /></td>
						<td style="width:25%"><a href="versions.html#maturity">Copyright</a>: <xsl:value-of select="/fhir:ExampleScenario/fhir:copyright/@value" /></td>
					</tr>
				</table>
				<table class="table-bordered"  style="width:100%">
					<tr>
						<td><a href="versions.html#maturity">Purpose</a>: <xsl:value-of select="/fhir:ExampleScenario/fhir:purpose/@value" /></td>
					</tr>
				</table>
				<p />
				<p />
			</div>
			<div>
				<h4><a name="Actors" />Actors</h4>
				<div style="min-width:400px">
				<table class="grid" style="width:100%">
					<tbody>
						<tr>
							<th>Name</th>
							<th>Type</th>
							<th>Description</th>
						</tr>
						<xsl:apply-templates select="/fhir:ExampleScenario/fhir:actor" />
					</tbody>
				</table> 
				</div>
				<p />
				<p />
			</div>
			<div>
				<h4><a name="flow" />Process Flow - <xsl:value-of select="/fhir:ExampleScenario/fhir:process/fhir:description/@value" /></h4>
				<xsl:apply-templates select="/fhir:ExampleScenario/fhir:process" /> 
			</div>
		</div>

	</xsl:template>

	<xsl:template match="fhir:actor">
		<tr>
			<td>
				<b>
<!--					<xsl:value-of select="fhir:name/@value" /> -->
					<xsl:call-template name="replace-linebreaks">
					  <xsl:with-param name="text" select="fhir:name/@value"/>
					  <xsl:with-param name="replace" select="'\n'"/>
					</xsl:call-template>
				</b>
			</td>
			<td><xsl:value-of select="fhir:type/@value" /></td>
			<td><xsl:value-of select="fhir:description/@value" /></td>
		</tr>
	</xsl:template>


	<xsl:template match="/fhir:ExampleScenario/fhir:process">
		<!--		<h4><xsl:value-of select="title/@value"/></h4> <br/>  -->
		<div class="container">
			<!-- Áreas -->
			<div>
				<div>Main Flow</div>
				<!-- /Área -->
				<table class="table-striped table-bordered" style="width:100%">
					<tbody>
					<tr>
						<th>Step</th>
						<th>Name</th>
						<th>Description</th>
						<th>Initiator</th>
						<th>Receiver</th>
						<th>Request</th>
						<th>Response</th>
					</tr>
					<xsl:apply-templates select="fhir:step" /> 
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>


	<xsl:template match="fhir:process">
		<xsl:value-of select="fhir:title/@value" />
			<xsl:apply-templates select="./fhir:step" />
	</xsl:template>


	<xsl:template match="fhir:step">
      <tr><a href="#{position()}" /><xsl:apply-templates select="./fhir:operation" /></tr>
	</xsl:template>

	<xsl:template match="fhir:operation">
        <xsl:variable name="init" select="./fhir:initiator/@value"/>
        <xsl:variable name="recv" select="./fhir:receiver/@value"/>


		<td><a name="p2"><xsl:value-of select="fhir:number/@value" /></a></td>
		<td><xsl:value-of select="fhir:name/@value" /></td>
		<td><xsl:value-of select="fhir:description/@value" /></td>
        <td><xsl:call-template name="break"><xsl:with-param name="text" select="/fhir:ExampleScenario/fhir:actor[fhir:actorId/@value=$init]/fhir:name/@value" /></xsl:call-template></td> 
        <td><xsl:call-template name="break"><xsl:with-param name="text" select="/fhir:ExampleScenario/fhir:actor[fhir:actorId/@value=$recv]/fhir:name/@value" /></xsl:call-template></td> 

					


<!--    
        <td>indexed:        <xsl:value-of select="/fhir:ExampleScenario/fhir:actor[fhir:actorId/@value=fhir:receiver/@value]/fhir:name/@value" /></td> 
-->
		<td><xsl:apply-templates select="./fhir:request" /></td>
		<td><xsl:apply-templates select="./fhir:response" /></td>
	</xsl:template>

	<xsl:template match="alternative">
		<a name="p2">Alternative: <xsl:value-of select="number/@value" /></a>
		<xsl:value-of select="name/@value" />
		<xsl:value-of select="description/@value" />
		<!-- IF STEP IS ALTERNATIVE -->
				<xsl:apply-templates select="./option" />
				<!--
				<div class="accordion-group">
						<div class="accordion-heading ponto">
							<a class="accordion-toggle" data-toggle="collapse" href="{position()}">Option1 #1-1-1</a>
						</div>
						<div class="accordion-body" id="{position()}">
						<xsl:apply-templates select="./option"/>
						</div>
					</div>
					-->
	</xsl:template>
	<xsl:template match="option">
		<xsl:variable name="id" select="position()" />
		<xsl:variable name="optionname" select="./description/@value" />
				<a class="accordion-toggle" data-parent="{$id}" data-toggle="collapse" href="#{$id}"><xsl:value-of select="$id" /> - <xsl:value-of select="./description/@value" /></a>
				<xsl:apply-templates select="./*" />
	</xsl:template>
	<xsl:template match="pause">(pause)</xsl:template>

	<xsl:template match="fhir:request">
		<xsl:apply-templates select="./fhir:resourceId" />

	</xsl:template>

	<xsl:template match="fhir:response">
		<xsl:apply-templates select="./fhir:resourceId" />
	</xsl:template>
	<xsl:template match="fhir:resourceId">
		<xsl:variable name="iid" select="./@value" />
		<a href="ExampleScenario-{/fhir:ExampleScenario/fhir:id/@value}-resources.html#{/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:resourceId/@value}">
			<xsl:call-template name="break"><xsl:with-param name="text" select="/fhir:ExampleScenario/fhir:instance[fhir:resourceId/@value=$iid]/fhir:name/@value"/></xsl:call-template>		
		</a>
	</xsl:template>


	<xsl:template name="linebreak">

	</xsl:template>

	<xsl:template name="replace-linebreaks">
    <xsl:param name="text"/>
    <xsl:param name="replace" select="'\n'"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:call-template name="linebreak" />
        <xsl:call-template name="replace-linebreaks">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template name="break">
  <xsl:param name="text" select="string(.)"/>
  <xsl:choose>
    <xsl:when test="contains($text, '\n')">
      <xsl:value-of select="substring-before($text, '\n')"/>
      <br/>
      <xsl:call-template name="break">
        <xsl:with-param 
          name="text" 
          select="substring-after($text, '\n')"
        />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



</xsl:stylesheet>
