<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fct="localFunctions" queryBinding="xslt3">
<sch:ns prefix="fct" uri="localFunctions"/>
<xsl:function name="fct:sortedList" as="xs:boolean">
		<xsl:param name="accoundMainIdList" as="xs:string*"/>
		<xsl:variable name="sortedAccountMainIdList" as="xs:string*">
			<xsl:for-each select="$accoundMainIdList">
				<xsl:sort/>
				<xsl:value-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="s1">
			<xsl:value-of select="string-join($accoundMainIdList,'|')"/>
		</xsl:variable>
		<xsl:variable name="s2">
			<xsl:value-of select="string-join($sortedAccountMainIdList,'|')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$s1 = $s2">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
</xsl:function>
   <sch:pattern>
       <sch:rule context="item">
            <sch:assert test="fct:sortedList(value)">value elements are not sorted.</sch:assert>
        </sch:rule>
   </sch:pattern>
</sch:schema>