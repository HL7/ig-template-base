<?xml version="1.0" standalone="no"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" xmlns:f="http://hl7.org/fhir">    <xsl:output method="text"/>

    <xsl:key name="from-id-of-version-to-name-of-version" match="version" use="id"/>
    <xsl:template match="f:fhirVersion">
      <xsl:choose>
        <xsl:when test="./@value = '4.0.1'">
          <xsl:text>R4</xsl:text>
        </xsl:when>
        <xsl:when test="./@value = '3.0.2'">
          <xsl:text>STU3</xsl:text>
        </xsl:when>
        <xsl:when test="./@value = '1.0.2'">
          <xsl:text>DSTU2</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>R4</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>


  <xsl:template match="f:ImplementationGuide">

spring:
  datasource:
    url: 'jdbc:h2:file:./target/database/h2'

    username: sa
    password: null
    driverClassName: org.h2.Driver
    max-active: 15
    hikari:
      maximum-pool-size: 10
  jpa:
    properties:
      hibernate.format_sql: false
      hibernate.show_sql: false
  batch:
    job:
      enabled: false
hapi:
  fhir:
    ### This is the FHIR version. Choose between, DSTU2, DSTU3, R4 or R5
    fhir_version: <xsl:apply-templates select="f:fhirVersion"/> # (<xsl:value-of select="f:fhirVersion/@value"/> )

    install_transitive_ig_dependencies: true
    implementationguides:
      <xsl:value-of select="translate(f:id/@value, '.', '')" disable-output-escaping="no"/>:
        name: <xsl:value-of select="f:packageId/@value" disable-output-escaping="no"/>
        version: <xsl:value-of select="f:version/@value" disable-output-escaping="no"/> 
        url: <xsl:value-of select="substring-before(f:url/@value, '/ImplementationGuide/')"/>/package.tgz
    cors:
      allow_Credentials: true
      # These are allowed_origin patterns, see: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/cors/CorsConfiguration.html#setAllowedOriginPatterns-java.util.List-
      allowed_origin:
        - '*'

    tester:
        home:
          name: Local Tester
          server_address: 'http://localhost:8080/fhir'
          refuse_to_fetch_third_party_urls: false
          fhir_version: <xsl:apply-templates select="f:fhirVersion"/> # (<xsl:value-of select="f:fhirVersion/@value"/> )
        global:
          name: Global Tester
          server_address: "http://hapi.fhir.org/baseR4"
          refuse_to_fetch_third_party_urls: false
          fhir_version: <xsl:apply-templates select="f:fhirVersion"/> # (<xsl:value-of select="f:fhirVersion/@value"/> )

  </xsl:template>
</xsl:stylesheet>

