<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fhir="http://hl7.org/fhir" version="1.0">
	<xsl:output method="html" />
	<xsl:param name="pref" select="pref" />
	<xsl:template match="/">

														<div id="sequence" class="tab-pane fade in active">
<!--															<h3><a name="description" />Description</h3> -->
															<p>
																<xsl:value-of select="/fhir:ExampleScenario/fhir:description/@value" />
															</p>
															<h4>
																<a name="preconditions" />
																Pre-Conditions
															</h4>
															<p>
																<xsl:value-of select="/fhir:ExampleScenario/fhir:process/fhir:preConditions/@value" />
															</p>
															<h4>
																<a name="postconditions" />
																Post Conditions
															</h4>
															<p>
																<xsl:value-of select="/fhir:ExampleScenario/fhir:process/fhir:postConditions/@value" />
															</p>
															<p />
														</div>



	</xsl:template>


</xsl:stylesheet>
