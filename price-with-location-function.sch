<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494" queryBinding="xslt3">

  <xsl:function name="schxslt:location" as="xs:string">
    <xsl:param name="node" as="node()"/>
    <xsl:variable name="segments" as="xs:string*">
      <xsl:for-each select="($node/ancestor-or-self::node())">
        <xsl:variable name="position">
          <xsl:number level="single"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test=". instance of element()">
            <xsl:value-of select="concat(node-name(), '[', $position, ']')"/>
          </xsl:when>
          <xsl:when test=". instance of attribute()">
            <xsl:value-of select="concat('@', node-name())"/>
          </xsl:when>
          <xsl:when test=". instance of processing-instruction()">
            <xsl:value-of select="concat('processing-instruction(&quot;', name(.), '&quot;)[', $position, ']')"/>
          </xsl:when>
          <xsl:when test=". instance of comment()">
            <value-of select="concat('comment()[', $position, ']')"/>
          </xsl:when>
          <xsl:when test=". instance of text()">
            <xsl:value-of select="concat('text()[', $position, ']')"/>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <xsl:sequence select="concat('/', string-join($segments, '/'))"/>

  </xsl:function>
	<pattern>
		<rule context="book">
			<assert test="@price > 10">The book price is too small</assert>
			<report test="@price > 1000">The book price is too big</report>
		</rule>
	</pattern>
</schema>