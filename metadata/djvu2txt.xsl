<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<!-- don't copy text nodes -->
<!-- <xsl:template match="text()" /> -->

<xsl:template match="PARAGRAPH">
  <xsl:apply-templates/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="LINE">
  <xsl:apply-templates/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="WORD">
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
</xsl:template>
</xsl:stylesheet>
