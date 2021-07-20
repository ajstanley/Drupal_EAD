<?xml version='1.0' encoding='utf-8'?><!-- EAD Cookbook Style 5 eadcbs5.xsl Version 0.9 19 January 2004,
altered version for use by Vassar College Archives and Special Collections January 2007 -->
<!-- This stylesheet generates a Table of Contents inline-
at the top of document. It is an update to eadcbs1.xsl designed
to work with EAD 2002.-->
<!--This stylesheet does not format the <dsc> portion of a finding aid. Users
need to select another stylesheet for the dsc and reference that file
in the <xsl:inlcude> statement that appears at the end of this file.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:strip-space elements="*" />
    <xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
    <!-- Creates the body of the finding aid.-->

    <xsl:template match="/">

        <xsl:apply-templates/>

    </xsl:template>

    <xsl:template match="/ead">
        <xsl:comment> **************************** BEGIN SECTION TO OMIT **************************** </xsl:comment>
        <xsl:text>

</xsl:text>
        <html>
            <head>
                <!--	<link href="http://specialcollections.vassar.edu/sp_findingaids.css" rel="stylesheet" type="text/css" />   -->
                <link href="http://specialcollections.vassar.edu/sp_findingaids.css" rel="stylesheet" type="text/css" />
                <title>
                    <xsl:value-of select="normalize-space(eadheader/filedesc/titlestmt/titleproper)" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(eadheader/filedesc/titlestmt/subtitle)" />
                </title>
                <!--		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  -->
                <meta http-equiv="Content-Type" content="text/xml; charset=utf-8" />
                <xsl:call-template name="metadata" />
            </head><!--This part of the template creates a table for the finding aid with two columns. -->
            <body>
                <xsl:comment> **************************** END SECTION TO OMIT **************************** </xsl:comment>
                <xsl:text>

</xsl:text>
                <xsl:comment> ***********************  BEGIN SECTION TO COPY/PASTE  *********************** </xsl:comment>
                <xsl:text>

</xsl:text>

                <xsl:apply-templates select="eadheader" />
                <xsl:call-template name="toc" />


                <!--To change the order of display, adjust the sequence of
                    the following apply-template statements which invoke the various
                    templates that populate the finding aid. Multiple statements
                    are included to handle the possibility that descgrp has been used
                    as a wrapper to replace add and admininfo. In several cases where
                    multiple elemnents are displayed together in the output, a call-template
                    statement is used-->
                <xsl:apply-templates select="archdesc/did" />
                <xsl:apply-templates select="archdesc/bioghist" />
                <xsl:apply-templates select="archdesc/scopecontent" />
                <xsl:apply-templates select="archdesc/arrangement"/>
                <xsl:call-template name="archdesc-restrict"/>
                <xsl:call-template name="archdesc-relatedmaterial" />
                <xsl:apply-templates select="archdesc/controlaccess" />
                <xsl:apply-templates select="archdesc/odd" />
                <xsl:apply-templates select="archdesc/originalsloc" />
                <xsl:apply-templates select="archdesc/phystech" />
                <xsl:call-template name="archdesc-admininfo" />
                <xsl:apply-templates select="archdesc/otherfindaid | archdesc/*/otherfindaid"/>
                <xsl:apply-templates select="archdesc/fileplan | archdesc/*/fileplan"/>
                <xsl:apply-templates select="archdesc/bibliography | archdesc/*/bibliography"/>
                <xsl:apply-templates select="archdesc/index | archdesc/*/index"/>
                <xsl:apply-templates select="archdesc/dsc"/>
                <xsl:text>

</xsl:text>
                <xsl:comment> ***********************  END SECTION TO COPY/PASTE  *********************** </xsl:comment>

            </body>
        </html>
    </xsl:template>
    <!--This template creates HTML meta tags that are inserted into the HTML ouput
for use by web search engines indexing this file. The content of each
resulting META tag uses Dublin Core semantics and is drawn from the text of
the finding aid.-->
    <xsl:template name="metadata">
        <meta content="{eadheader/filedesc/titlestmt/titleproper }{eadheader/filedesc/titlestmt/subtitle}" name="dc.title" />
        <meta content="{archdesc/did/origination}" name="dc.author" />
        <xsl:for-each select="//controlaccess/persname | //controlaccess/corpname">
            <xsl:choose>
                <xsl:when test="@encodinganalog='600'">
                    <meta http-equiv="Content-Type" name="dc.subject" content="{.}" />
                </xsl:when>
                <xsl:when test="//@encodinganalog='610'">
                    <meta http-equiv="Content-Type" name="dc.subject" content="{.}" />
                </xsl:when>
                <xsl:when test="//@encodinganalog='611'">
                    <meta http-equiv="Content-Type" name="dc.subject" content="{.}" />
                </xsl:when>
                <xsl:when test="//@encodinganalog='700'">
                    <meta content="{.}" name="dc.contributor" />
                </xsl:when>
                <xsl:when test="//@encodinganalog='710'">
                    <meta http-equiv="Content-Type" name="dc.contributor" content="{.}" />
                </xsl:when>
                <xsl:otherwise>
                    <meta http-equiv="Content-Type" name="dc.contributor" content="{.}" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="//controlaccess/subject">
            <meta content="{.}" name="dc.subject" />
        </xsl:for-each>
        <xsl:for-each select="//controlaccess/geogname">
            <meta http-equiv="Content-Type" name="dc.subject" content="{.}" />
        </xsl:for-each>
        <meta content="{archdesc/did/unittitle}" name="dc.title" />
        <meta content="text" name="dc.type" />
        <meta content="manuscripts" name="dc.format" />
        <meta content="finding aids" name="dc.format" />
    </xsl:template>

    <!--This template creates the Table of Contents column for the finding aid.-->

    <xsl:template name="toc">
        <h3>Table of Contents</h3>
        <!-- The Table of Contents template performs a series of tests to
    determine which elements will be included in the table
    of contents. Each if statement tests to see if there is
    a matching element with content in the finding aid.-->
        <ul class="faq__index" id="i1">
            <xsl:if test="string(archdesc/did/head)">
                <li class="faq__indexItem"><a href="#{generate-id(archdesc/did/head)}"><xsl:value-of select="normalize-space(archdesc/did/head)" /></a></li>
            </xsl:if>
            <xsl:if test="string(archdesc/bioghist/head)">
                <li class="faq__indexItem"><a href="#{generate-id(archdesc/bioghist/head)}"><xsl:value-of select="normalize-space(archdesc/bioghist/head)" /></a></li>
            </xsl:if>
            <xsl:if test="string(archdesc/scopecontent/head)">
                <li class="faq__indexItem"><a href="#{generate-id(archdesc/scopecontent/head)}"><xsl:value-of select="normalize-space(archdesc/scopecontent/head)" /></a></li>
            </xsl:if>
            <xsl:if test="string(archdesc/controlaccess/head)">
                <li class="faq__indexItem"><a href="#{generate-id(archdesc/controlaccess/head)}"><xsl:value-of select="normalize-space(archdesc/controlaccess/head)" /></a></li>
            </xsl:if>
            <xsl:if test="string(archdesc/relatedmaterial) or string(archdesc/separatedmaterial) or string(archdesc/*/relatedmaterial) or string(archdesc/*/separatedmaterial)"><!--		<h4 style="text-indent:25pt"> -->
                <li class="faq__indexItem"><a href="#relatedmatlink"><xsl:text>Related Material</xsl:text></a></li>
            </xsl:if>
            <xsl:if test="string(archdesc/otherfindaid/head) or string(archdesc/*/otherfindaid/head)">
                <li class="faq__indexItem">
                    <xsl:choose>
                        <xsl:when test="archdesc/otherfindaid/head">
                            <a href="#{generate-id(archdesc/otherfindaid/head)}"><xsl:value-of select="normalize-space(archdesc/otherfindaid/head)" /></a>
                        </xsl:when>
                        <xsl:when test="archdesc/*/otherfindaid/head">
                            <a href="#{generate-id(archdesc/*/otherfindaid/head)}"><xsl:value-of select="normalize-space(archdesc/*/otherfindaid/head)" /></a>
                        </xsl:when>
                    </xsl:choose>
                </li>
            </xsl:if>
            <xsl:if test="string(archdesc/acqinfo/*) or string(archdesc/processinfo/*) or string(archdesc/prefercite/*) or string(archdesc/custodialhist/*) or string(archdesc/processinfo/*) or string(archdesc/appraisal/*) or string(archdesc/accruals/*) or string(archdesc/*/acqinfo/*) or string(archdesc/*/processinfo/*) or string(archdesc/*/prefercite/*) or string(archdesc/*/custodialhist/*) or string(archdesc/*/processinfo/*) or string(archdesc/*/appraisal/*) or string(archdesc/*/accruals/*)"><!--		<h4 style="text-indent:25pt"> -->
                <li class="faq__indexItem"><a href="#adminlink"><xsl:text>Administrative Information</xsl:text></a></li>
            </xsl:if>
            <xsl:if test="string(archdesc/userestrict/head) or string(archdesc/accessrestrict/head) or string(archdesc/*/userestrict/head) or string(archdesc/*/accessrestrict/head)">
                <li class="faq__indexItem"><a href="#restrictlink"><xsl:text>Access and Use</xsl:text></a></li>
            </xsl:if>
            <!--The next test covers the situation where there is more than one odd element
                in the document.-->
            <xsl:if test="string(archdesc/odd/head)">
                <xsl:for-each select="archdesc/odd">
                    <li class="faq__indexItem"><a href="#{generate-id(head)}"><xsl:value-of select="normalize-space(head)" /></a></li>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="string(archdesc/bibliography/head) or string(archdesc/*/bibliography/head)">
                <li class="faq__indexItem">
                    <xsl:choose>
                        <xsl:when test="archdesc/bibliography/head">
                            <a href="#{generate-id(archdesc/bibliography/head)}"><xsl:value-of select="normalize-space(archdesc/bibliography/head)" /></a>
                        </xsl:when>
                        <xsl:when test="archdesc/*/bibliography/head">
                            <a href="#{generate-id(archdesc/*/bibliography/head)}"><xsl:value-of select="normalize-space(archdesc/*/bibliography/head)" /></a>
                        </xsl:when>
                    </xsl:choose>
                </li>
            </xsl:if>
            <xsl:if test="string(archdesc/index/head) or string(archdesc/*/index/head)">
                <li class="faq__indexItem">
                    <xsl:choose>
                        <xsl:when test="archdesc/index/head">
                            <a href="#{generate-id(archdesc/index/head)}"><xsl:value-of select="normalize-space(archdesc/index/head)" /></a>
                        </xsl:when>
                        <xsl:when test="archdesc/*/index/head">
                            <a href="#{generate-id(archdesc/*/index/head)}"><xsl:value-of select="normalize-space(archdesc/*/index/head)" /></a>
                        </xsl:when>
                    </xsl:choose>
                </li>
            </xsl:if>
            <xsl:if test="string(archdesc/arrangement/head)">
                <li class="faq__indexItem">
                    <a href="#{generate-id(archdesc/arrangement/head)}"><xsl:value-of select="normalize-space(archdesc/arrangement/head)" /></a>
                </li>
            </xsl:if>

            <!-- Modified this TOC entry to list ALL <head> tags within "archdesc/dsc" not just he first one jah 4/06-->
            <xsl:for-each select="archdesc/dsc">
                <li class="faq__indexItem">
                    <a href="#{generate-id(head)}"><xsl:value-of select="normalize-space(head)" /></a>
                </li>
            </xsl:for-each>
            <!-- <xsl:if test="string(archdesc/dsc/head)">
                        <h4 style="text-indent:25pt">
                            <strong>
                                <a href="#{generate-id(archdesc/dsc/head)}">
                                    <xsl:value-of select="normalize-space(archdesc/dsc/head)" />
                                </a>
                            </strong>
                        </h4>
                     </xsl:if>

            --><!--End of the table of contents. -->
        </ul>
    </xsl:template>
    <!-- The following general templates format the display of various RENDER
     attributes.-->
    <xsl:template match="emph[@render='bold']">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="emph[@render='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="emph[@render='underline']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>
    <xsl:template match="emph[@render='sub']">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:template match="emph[@render='super']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="emph[@render='quoted']">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="emph[@render='doublequote']">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="emph[@render='singlequote']">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    <xsl:template match="emph[@render='bolddoublequote']">
        <strong>
            <xsl:text>"</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>"</xsl:text>
        </strong>
    </xsl:template>
    <xsl:template match="emph[@render='boldsinglequote']">
        <strong>
            <xsl:text>'</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>'</xsl:text>
        </strong>
    </xsl:template>
    <xsl:template match="emph[@render='boldunderline']">
        <strong>
            <u>
                <xsl:apply-templates/>
            </u>
        </strong>
    </xsl:template>
    <xsl:template match="emph[@render='bolditalic']">
        <strong>
            <em>
                <xsl:apply-templates/>
            </em>
        </strong>
    </xsl:template>
    <xsl:template match="emph[@render='boldsmcaps']">
        <span style="font-variant: small-caps">
            <strong>
                <xsl:apply-templates/>
            </strong>
        </span>
    </xsl:template>
    <xsl:template match="emph[@render='smcaps']">
        <span style="font-variant: small-caps">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="title[@render='bold']">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="title[@render='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="title[@render='underline']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>
    <xsl:template match="title[@render='sub']">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:template match="title[@render='super']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="title[@render='quoted']">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="title[@render='doublequote']">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="title[@render='singlequote']">
        <xsl:text>'</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    <xsl:template match="title[@render='bolddoublequote']">
        <strong>
            <xsl:text>"</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>"</xsl:text>
        </strong>
    </xsl:template>
    <xsl:template match="title[@render='boldsinglequote']">
        <strong>
            <xsl:text>'</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>'</xsl:text>
        </strong>
    </xsl:template>
    <xsl:template match="title[@render='boldunderline']">
        <strong>
            <u>
                <xsl:apply-templates/>
            </u>
        </strong>
    </xsl:template>
    <xsl:template match="title[@render='bolditalic']">
        <strong>
            <em>
                <xsl:apply-templates/>
            </em>
        </strong>
    </xsl:template>
    <xsl:template match="title[@render='boldsmcaps']">
        <span style="font-variant: small-caps">
            <strong>
                <xsl:apply-templates/>
            </strong>
        </span>
    </xsl:template>
    <xsl:template match="title[@render='smcaps']">
        <span style="font-variant: small-caps">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- This template converts a Ref element into an HTML anchor.-->
    <xsl:template match="ref">
        <a href="#{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <!--This template rule formats a list element anywhere
    except in arrangement.-->
    <xsl:template match="list[parent::*[not(self::arrangement)]]/head">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="list[parent::*[not(self::arrangement)]]/item">
        <ul class="line393ead"><li><xsl:apply-templates/></li></ul>
    </xsl:template>
    <!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
    <xsl:template match="table">
        <table>
            <tr>
                <th colspan="3">
                    <h4><xsl:apply-templates select="head" /></h4>
                </th>
            </tr>
            <xsl:for-each select="tgroup">
                <tr>
                    <xsl:for-each select="colspec">
                        <td width="{@colwidth}"></td>
                    </xsl:for-each>
                </tr>
                <xsl:for-each select="thead">
                    <xsl:for-each select="row">
                        <tr>
                            <xsl:for-each select="entry">
                                <th>
                                    <xsl:apply-templates/>
                                </th>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="tbody">
                    <xsl:for-each select="row">
                        <tr>
                            <xsl:for-each select="entry">
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </table>
    </xsl:template>
    <!--This template rule formats a chronlist element.-->
    <xsl:template match="chronlist">
        <table width="100%" class="chronlist">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="chronlist/head">
        <tr>
            <th colspan="2">
                <h4><xsl:apply-templates/></h4>
            </th>
        </tr>
    </xsl:template>
    <xsl:template match="chronlist/listhead">
        <tr>
            <th>
                <xsl:apply-templates select="head01" />
            </th>
            <th>
                <xsl:apply-templates select="head02" />
            </th>
        </tr>
    </xsl:template>
    <xsl:template match="chronitem">
        <!--Determine if there are event groups.-->
        <xsl:choose>
            <xsl:when test="eventgrp">
                <!--Put the date and first event on the first line.-->
                <tr>
                    <td>
                        <xsl:apply-templates select="date" />
                    </td>
                    <td>
                        <xsl:apply-templates select="eventgrp/event[position()=1]" />
                    </td>
                </tr>
                <!--Put each successive event on another line.-->
                <xsl:for-each select="eventgrp/event[not(position()=1)]">
                    <tr>
                        <td></td>
                        <td>
                            <xsl:apply-templates select="." />
                        </td>
                    </tr>
                </xsl:for-each>
            </xsl:when>
            <!--Put the date and event on a single line.-->
            <xsl:otherwise>
                <tr>
                    <td>
                        <xsl:apply-templates select="date" />
                    </td>
                    <td>
                        <xsl:apply-templates select="event" />
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--Suppreses all other elements of eadheader.-->
    <xsl:template match="eadheader">

    </xsl:template>
    <!--This template creates a table for the did, inserts the head and then
each of the other did elements. To change the order of appearance of these
elements, change the sequence of the apply-templates statements.-->
    <xsl:template match="archdesc/did">
        <div class="faq__item" id="{generate-id(head)}">
            <h3 class="faq__header"><xsl:apply-templates select="head" /></h3>
            <div class="faq__answer">
                <table width="100%">
                    <!--	<tr>
                        <th colspan="2"><a name="{generate-id(head)}"></a>
                            <xsl:apply-templates select="head" />
                        </th>
                        </tr> -->
                    <!--	<tr>
                            <td width="25%"> </td>
                            <td width="75%"> </td>
                        </tr> --><!--		<tr>
				<td colspan="2">

					<h3>
						<a name="{generate-id(head)}">
							<xsl:apply-templates select="head" />
						</a>
					</h3>

				</td>
			</tr> --><!--One can change the order of appearance for the children of did
				by changing the order of the following statements.-->
                    <xsl:apply-templates select="repository" />
                    <xsl:apply-templates select="origination" />
                    <xsl:apply-templates select="unittitle" />
                    <xsl:apply-templates select="unitdate" />
                    <xsl:apply-templates select="physdesc" />
                    <xsl:apply-templates select="abstract" />
                    <xsl:apply-templates select="unitid" />
                    <xsl:apply-templates select="physloc" />
                    <xsl:apply-templates select="langmaterial" />
                    <xsl:apply-templates select="materialspec" />
                    <xsl:apply-templates select="note" />
                </table>
            </div>
            <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a></div>
    </xsl:template>
    <!--This template formats the repostory, origination, physdesc, abstract,
    unitid, physloc and materialspec elements of archdesc/did which share a common presentaiton.
    The sequence of their appearance is governed by the previous template.-->
    <xsl:template match="archdesc/did/repository | archdesc/did/origination | archdesc/did/physdesc | archdesc/did/unitid | archdesc/did/physloc | archdesc/did/abstract | archdesc/did/langmaterial | archdesc/did/materialspec">
        <!--The template tests to see if there is a label attribute,
            inserting the contents if there is or adding display textif there isn't.
            The content of the supplied label depends on the element. To change the
            supplied label, simply alter the template below.-->
        <xsl:choose>
            <xsl:when test="@label">
                <tr>
                    <th>
                        <xsl:value-of select="normalize-space(@label)" />
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <tr>
                    <!--				<td valign="top"> -->
                    <!--	<td> -->
                    <th>
                        <!--	<strong> -->
                        <xsl:choose>
                            <xsl:when test="self::repository">
                                <xsl:text>Repository: </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::origination">
                                <xsl:text>Creator: </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::physdesc">
                                <xsl:text>Quantity: </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::physloc">
                                <xsl:text>Location: </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::unitid">
                                <xsl:text>Identification: </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::abstract">
                                <xsl:text>Abstract:</xsl:text>
                            </xsl:when>
                            <xsl:when test="self::langmaterial">
                                <xsl:text>Language: </xsl:text>
                            </xsl:when>
                            <xsl:when test="self::materialspec">
                                <xsl:text>Technical: </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <!--	</strong> -->
                        <!--	</td> -->
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- The following two templates test for and processes various permutations
of unittitle and unitdate.-->
    <xsl:template match="archdesc/did/unittitle"><!--The template tests to see if there is a label attribute for unittitle,
inserting the contents if there is or adding one if there isn't. -->
        <xsl:choose>
            <xsl:when test="@label">
                <tr>
                    <th>
                        <xsl:value-of select="normalize-space(@label)" />
                    </th>
                    <td><!--Inserts the text of unittitle and any children other that unitdate.-->
                        <xsl:apply-templates select="text() |* [not(self::unitdate)]" />
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <tr>
                    <th><xsl:text>Title </xsl:text></th>
                    <td>
                        <xsl:apply-templates select="text() |* [not(self::unitdate)]" />
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose><!--If unitdate is a child of unittitle, it inserts unitdate on a new line. -->
        <xsl:if test="child::unitdate">
            <!--The template tests to see if there is a label attribute for unittitle,
            inserting the contents if there is or adding one if there isn't. -->
            <xsl:choose>
                <xsl:when test="unitdate/@label">
                    <tr>
                        <td>
                            <strong>
                                <xsl:value-of select="normalize-space(unitdate/@label)" />
                            </strong>
                        </td>
                        <td>
                            <xsl:apply-templates select="unitdate" />
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <tr>
                        <td>
                            <strong>

                                <xsl:text>Dates </xsl:text>
                            </strong>
                        </td>
                        <td>
                            <xsl:apply-templates select="unitdate" />
                        </td>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!-- Processes the unit date if it is not a child of unit title but a child of did, the current context.-->
    <xsl:template match="archdesc/did/unitdate"><!--The template tests to see if there is a label attribute for a unittitle that is the
	child of did and not unittitle, inserting the contents if there is or adding one if there isn't.-->
        <xsl:choose>
            <xsl:when test="@label">
                <tr>
                    <th>
                        <xsl:value-of select="normalize-space(@label)" />
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:otherwise>
                <tr>
                    <th>
                        <xsl:text>Dates </xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--This template processes the note element.-->
    <xsl:template match="archdesc/did/note">
        <xsl:for-each select="p">
            <!--The template tests to see if there is a label attribute,
inserting the contents if there is or adding one if there isn't. -->
            <xsl:choose>
                <xsl:when test="parent::note[@label]">
                    <!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
                    <xsl:choose>
                        <xsl:when test="position()=1">
                            <tr>
                                <th>
                                    <xsl:value-of select="normalize-space(@label)" />
                                </th>
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td><xsl:comment> spacer </xsl:comment></td>
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!--Processes situations where there is no
                    label attribute by supplying default text.-->
                <xsl:otherwise>
                    <!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
                    <xsl:choose>
                        <xsl:when test="position()=1">
                            <tr>
                                <td>
                                    <strong>
                                        <xsl:text>Note </xsl:text>
                                    </strong>
                                </td>
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td><xsl:comment> spacer </xsl:comment></td>
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <!--Closes each paragraph-->
        </xsl:for-each>
    </xsl:template>
    <!--This template rule formats the top-level bioghist element and
        creates a link back to the top of the page after the display of the element.-->
    <xsl:template match="archdesc/bioghist |
		archdesc/scopecontent |
		archdesc/phystech |
		archdesc/odd |
		archdesc/arrangement">
        <xsl:if test="string(child::*)">
            <div class="faq__item">
                <xsl:apply-templates/>
                <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a>
            </div>

        </xsl:if>
    </xsl:template>

    <!--This template formats various head elements and makes them targets for
        links from the Table of Contents.-->
    <xsl:template match="archdesc/bioghist/head |
		archdesc/scopecontent/head |
		archdesc/phystech/head |
		archdesc/controlaccess/head |
		archdesc/odd/head |
		archdesc/arrangement/head">
        <h3 class="faq__header"  id="{generate-id()}">

            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="archdesc/bioghist/p |
		archdesc/scopecontent/p |
		archdesc/phystech/p |
		archdesc/controlaccess/p |
		archdesc/odd/p |
		archdesc/bioghist/note/p |
		archdesc/scopecontent/note/p |
		archdesc/phystech/note/p |
		archdesc/controlaccess/note/p |
		archdesc/odd/note/p">
        <p>
            <xsl:apply-templates/>

        </p>
    </xsl:template>

    <xsl:template match="archdesc/bioghist/bioghist/head |
		archdesc/scopecontent/scopecontent/head">
        <a href="#i1" class="iconDecorative-top topLink faq__topLink">Top</a>
        <h3>
            <xsl:apply-templates/>

        </h3>
    </xsl:template>

    <xsl:template match="archdesc/bioghist/bioghist/p |
		archdesc/scopecontent/scopecontent/p |
		archdesc/bioghist/bioghist/note/p |
		archdesc/scopecontent/scopecontent/note/p">
        <p>
            <xsl:apply-templates/>

        </p>
    </xsl:template>
    <!-- The next two templates format an arrangement
        statement embedded in <scopecontent>.-->

    <xsl:template match="archdesc/scopecontent/arrangement/head">
        <h4 id="{generate-id()}">
            <xsl:apply-templates/>

        </h4>
    </xsl:template>


    <xsl:template match="archdesc/scopecontent/arrangement/p
		| archdesc/scopecontent/arrangement/note/p">
        <p>
            <xsl:apply-templates/>

        </p>
    </xsl:template>

    <!-- The next three templates format a list within an arrangement
        statement whether it is directly within <archdesc> or embedded in
        <scopecontent>.-->

    <xsl:template match="archdesc/scopecontent/arrangement/list/head">
        <div>
            <a name="{generate-id()}"></a>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="archdesc/arrangement/list/head">
        <div>
            <a name="{generate-id()}"></a>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="archdesc/scopecontent/arrangement/list/item
		| archdesc/arrangement/list/item">
        <div>
            <a>
                <xsl:attribute name="href">#series<xsl:number/>
                </xsl:attribute>
                <xsl:apply-templates/></a>

        </div>
    </xsl:template>
    <!--This template rule formats the top-level related material
        elements by combining any related or separated materials
        elements. It begins by testing to see if there related or separated
        materials elements with content.-->
    <xsl:template name="archdesc-relatedmaterial">
        <xsl:if test="string(archdesc/relatedmaterial) or
			string(archdesc/*/relatedmaterial) or
			string(archdesc/separatedmaterial) or
			string(archdesc/*/separatedmaterial)">
            <div class="faq__item">
                <h3 class="faq__header" id="relatedmatlink">
                    <xsl:text>Related Material</xsl:text>
                </h3>
                <div class="faq__answer">
                    <xsl:apply-templates select="archdesc/relatedmaterial/p
				| archdesc/*/relatedmaterial/p
				| archdesc/relatedmaterial/note/p
				| archdesc/*/relatedmaterial/note/p"/>
                    <xsl:apply-templates select="archdesc/separatedmaterial/p
				| archdesc/*/separatedmaterial/p
				| archdesc/separatedmaterial/note/p
				| archdesc/*/separatedmaterial/note/p"/>
                </div>
                <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="archdesc/relatedmaterial/p
		| archdesc/*/relatedmaterial/p
		| archdesc/separatedmaterial/p
		| archdesc/*/separatedmaterial/p
		| archdesc/relatedmaterial/note/p
		| archdesc/*/relatedmaterial/note/p
		| archdesc/separatedmaterial/note/p
		| archdesc/*/separatedmaterial/note/p">

        <ul class="subject_headings">
            <li>
                <!-- if there are archrefs or extrefs, match the template - otherwise just print what is in the 'p' tag -->
                <xsl:choose>
                    <xsl:when test="archref  | extref">
                        <xsl:apply-templates select="archref | extref" />
                    </xsl:when>
                    <xsl:otherwise >
                        <xsl:value-of  select="." />
                    </xsl:otherwise>
                </xsl:choose>
                <!-- this is where the "related material" items are listed and linked.  -->
            </li>
        </ul>
    </xsl:template>

    <xsl:template match="archref | extref">
        <a><xsl:attribute name="href"><xsl:value-of select="normalize-space(@href)" /></xsl:attribute><xsl:value-of select="normalize-space(.)" /></a>
    </xsl:template>

    <!--This template formats the top-level controlaccess element.
        It begins by testing to see if there is any controlled
        access element with content. It then invokes one of two templates
        for the children of controlaccess. -->
    <xsl:template match="archdesc/controlaccess">
        <xsl:if test="string(child::*)">
            <a id="{generate-id(head)}"></a>
            <xsl:apply-templates select="head"/>
            <p>
                <xsl:apply-templates select="p | note/p"/>
            </p>
            <xsl:choose>
                <!--Apply this template when there are recursive controlaccess
                    elements.-->
                <xsl:when test="controlaccess">
                    <xsl:apply-templates mode="recursive" select="."/>
                </xsl:when>
                <!--Apply this template when the controlled terms are entered
                    directly under the controlaccess element.-->
                <xsl:otherwise>
                    <xsl:apply-templates mode="direct" select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--This template formats controlled terms that are entered
    directly under the controlaccess element. Elements are alphabetized.-->
    <xsl:template mode="direct" match="archdesc/controlaccess">
        <div class="faq__item line944">
            <xsl:for-each select="subject |corpname | famname | persname | genreform | title | geogname | occupation">
                <xsl:sort select="." data-type="text" order="ascending" />
                <xsl:apply-templates/>
            </xsl:for-each>
        </div>
        <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a>

    </xsl:template>
    <!--When controlled terms are nested within recursive
    controlaccess elements, the template for controlaccess/controlaccess
    is applied.-->
    <xsl:template mode="recursive" match="archdesc/controlaccess">
        <xsl:apply-templates select="controlaccess" />
        <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a>

    </xsl:template>
    <!--This template formats controlled terms that are nested within recursive
    controlaccess elements. Terms are alphabetized within each grouping.-->
    <xsl:template match="archdesc/controlaccess/controlaccess"><!--	<h4 style="margin-left:25pt"> -->
        <h4><xsl:apply-templates select="head" /></h4>
        <ul>
            <xsl:for-each select="subject |corpname | famname | persname | genreform | title | geogname | occupation">
                <xsl:sort select="." data-type="text" order="ascending" /><!--			<div style="margin-left:50pt"> -->
                <li>
                    <xsl:apply-templates/>
                </li><!--			</div> -->
            </xsl:for-each>
        </ul>
    </xsl:template>
    <!--This template rule formats a top-level access and use retriction elements.
    They are displayed under a common heading.
    It begins by testing to see if there are any restriction elements with content.-->
    <xsl:template name="archdesc-restrict">
        <xsl:if test="string(archdesc/userestrict/*) or string(archdesc/accessrestrict/*) or string(archdesc/*/userestrict/*) or string(archdesc/*/accessrestrict/*)">
            <div class="faq__item">
                <h3 id="restrictlink" class="faq__header">
                    <xsl:text>Access and Use<!-- "Restrictions" in original file --></xsl:text>
                </h3>
                <div class="faq__answer">
                    <xsl:apply-templates select="archdesc/accessrestrict | archdesc/*/accessrestrict" />
                    <xsl:apply-templates select="archdesc/userestrict | archdesc/*/userestrict" />
                </div>
                <a href="#i1" class="iconDecorative-top topLink faq__topLink">Top</a>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="archdesc/accessrestrict/head | archdesc/userestrict/head | archdesc/*/accessrestrict/head | archdesc/*/userestrict/head">
        <h4><xsl:apply-templates/></h4>
    </xsl:template>
    <xsl:template match="archdesc/accessrestrict/p | archdesc/userestrict/p | archdesc/*/accessrestrict/p | archdesc/*/userestrict/p | archdesc/accessrestrict/note/p | archdesc/userestrict/note/p | archdesc/*/accessrestrict/note/p | archdesc/*/userestrict/note/p"><!--	<p style="margin-left:50pt"> -->
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!--This templates consolidates all the other administrative information
     elements into one block under a common heading. It formats these elements
     regardless of which of three encodings has been utilized. They may be
     children of archdesc, admininfo, or descgrp.
     It begins by testing to see if there are any elements of this type
     with content.-->
    <xsl:template name="archdesc-admininfo">
        <xsl:if test="string(archdesc/processinfo/*) or string(archdesc/altformavail/*) or string(archdesc/prefercite/*) or string(archdesc/acqinfo/*) or string(archdesc/admininfo/custodhist/*) or string(archdesc/appraisal/*) or string(archdesc/accruals/*) or string(archdesc/*/processinfo/*) or string(archdesc/*/altformavail/*) or string(archdesc/*/prefercite/*) or string(archdesc/*/acqinfo/*) or string(archdesc/*/custodhist/*) or string(archdesc/*/appraisal/*) or string(archdesc/*/accruals/*)">
            <div class="faq__item">
                <h3 class="faq__header" id="adminlink">
                    <xsl:text>Administrative Information</xsl:text>
                </h3>
                <div class="faq__answer">
                    <xsl:apply-templates select="archdesc/prefercite | archdesc/*/prefercite" />
                    <xsl:apply-templates select="archdesc/processinfo | archdesc/*/processinfo" />
                    <xsl:apply-templates select="archdesc/acqinfo | archdesc/*/acqinfo" />
                    <xsl:apply-templates select="archdesc/custodhist | archdesc/*/custodhist" />
                    <xsl:apply-templates select="archdesc/appraisal | archdesc/*/appraisal" />
                    <xsl:apply-templates select="archdesc/accruals | archdesc/*/accruals" />
                    <xsl:apply-templates select="archdesc/altformavail | archdesc/*/altformavail" />
                </div><a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a></div>

        </xsl:if>
    </xsl:template>
    <!--This template rule formats the head element of top-level elements of
    administrative information.-->
    <xsl:template match="custodhist/head | archdesc/altformavail/head | archdesc/prefercite/head | archdesc/acqinfo/head | archdesc/processinfo/head | archdesc/appraisal/head | archdesc/accruals/head | archdesc/*/custodhist/head | archdesc/*/altformavail/head | archdesc/*/prefercite/head | archdesc/*/acqinfo/head | archdesc/*/processinfo/head | archdesc/*/appraisal/head | archdesc/*/accruals/head"><!--	<h4 style="margin-left:50pt"> -->
        <h4><a name="{generate-id()}"><xsl:comment>anchor 1051</xsl:comment></a><xsl:apply-templates/></h4>
    </xsl:template>
    <xsl:template match="custodhist/p | archdesc/altformavail/p | archdesc/prefercite/p | archdesc/acqinfo/p | archdesc/processinfo/p | archdesc/appraisal/p | archdesc/accruals/p | archdesc/*/custodhist/p | archdesc/*/altformavail/p | archdesc/*/prefercite/p | archdesc/*/acqinfo/p | archdesc/*/processinfo/p | archdesc/*/appraisal/p | archdesc/*/accruals/p | archdesc/custodhist/note/p | archdesc/altformavail/note/p | archdesc/prefercite/note/p | archdesc/acqinfo/note/p | archdesc/processinfo/note/p | archdesc/appraisal/note/p | archdesc/accruals/note/p | archdesc/*/custodhist/note/p | archdesc/*/altformavail/note/p | archdesc/*/prefercite/note/p | archdesc/*/acqinfo/note/p | archdesc/*/processinfo/note/p | archdesc/*/appraisal/note/p | archdesc/*/accruals/note/p">
        <!--	<p style="margin-left:25pt"> -->
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="archdesc/otherfindaid | archdesc/*/otherfindaid | archdesc/bibliography | archdesc/*/bibliography | archdesc/originalsloc | archdesc/phystech">
        <xsl:apply-templates/>
        <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a>

    </xsl:template>
    <xsl:template match="archdesc/otherfindaid/head | archdesc/*/otherfindaid/head | archdesc/bibliography/head | archdesc/*/bibliography/head | archdesc/fileplan/head | archdesc/originalsloc/head | archdesc/*/fileplan/head | archdesc/phystech/head">
        <h3 id="{generate-id()} line1040">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="archdesc/otherfindaid/p | archdesc/*/otherfindaid/p | archdesc/bibliography/p | archdesc/*/bibliography/p | archdesc/otherfindaid/note/p | archdesc/*/otherfindaid/note/p | archdesc/bibliography/note/p | archdesc/*/bibliography/note/p | archdesc/originalsloc/p | archdesc/originalsloc/note/p | archdesc/fileplan/p | archdesc/*/fileplan/p | archdesc/fileplan/note/p | archdesc/*/fileplan/note/p | archdesc/phystech/p | archdesc/phystech/note/p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!--This template rule tests for and formats the top-level index element. It begins
    by testing to see if there is an index element with content.-->
    <xsl:template match="archdesc/index | archdesc/*/index">
        <div class="faq__item">
            <h3 id="{generate-id(head)}" class="faq__header">
                <xsl:apply-templates select="head" />
            </h3>
            <div class="faq__answer">
                <xsl:for-each select="p | note/p">

                    <xsl:apply-templates/>
                </xsl:for-each>
                <!--Processes each index entry.-->
                <xsl:for-each select="indexentry">
                    <!--Sorts each entry term.-->
                    <xsl:sort select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject" />
                    <xsl:apply-templates select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject" />

                    <!--Supplies whitespace and punctuation if there is a pointer
                        group with multiple entries.-->
                    <xsl:choose>
                        <xsl:when test="ptrgrp">

                            <xsl:for-each select="ptrgrp">
                                <xsl:for-each select="ref | ptr">
                                    <xsl:apply-templates/>
                                    <xsl:if test="preceding-sibling::ref or preceding-sibling::ptr">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>

                        </xsl:when>
                        <!--If there is no pointer group, process each reference or pointer.-->
                        <xsl:otherwise>

                            <xsl:for-each select="ref | ptr">
                                <xsl:apply-templates/>
                            </xsl:for-each>

                        </xsl:otherwise>
                    </xsl:choose>
                    <!--Closes the indexentry.-->
                </xsl:for-each>
            </div>
            <a class="iconDecorative-top topLink faq__topLink" href="#i1">Top</a></div>
        <!--		<hr></hr> -->
        <hr />
    </xsl:template>
    <!--Insert the address for the dsc stylesheet of your choice here.-->
    <xsl:include href="dsc3.xsl" />

</xsl:stylesheet>
