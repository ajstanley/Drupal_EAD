<?xml version='1.0'?><!--Revision date 26 December 2003-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- This stylesheet formats the dsc where
    components have a single container element.-->
    <!--It assumes that c01 is a high-level description such as
    a series, subseries, subgroup or subcollection and does not have
    container elements associated with it.-->
    <!--Column headings for containers are inserted whenever
    the value of a container's type attribute differs from that of
    the container in the preceding component. -->
    <!-- The value of a column heading is taken from the type
    attribute of the container element.-->
    <!--The content of container elements is always displayed.-->

    <!-- .................Section 1.................. -->

    <!--This section of the stylesheet formats dsc, its head, and
    any introductory paragraphs.-->


    <xsl:template match="dsc[@type='in-depth']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="archdesc/dsc">
        <xsl:comment> 25</xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>




    <!--Formats dsc/head and makes it a link target.-->
    <xsl:template match="dsc/head">
        <h3><xsl:comment> 34 </xsl:comment>
            <a name="{generate-id()}"><!-- anchor -->
                <xsl:apply-templates/>
            </a>
        </h3>
    </xsl:template>

    <!--Formats dsc/head and makes it a link target.-->
    <xsl:template match="dsc[@type='in-depth']/head">
        <h3><xsl:comment> 43 </xsl:comment>
            <a name="{generate-id()}"><!-- anchor -->
                <xsl:apply-templates/>
            </a>
        </h3>
    </xsl:template>

    <xsl:template match="dsc/p | dsc/note/p">
        <p style="margin-left:25pt">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="archdesc/dsc">
        <xsl:comment> 56</xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>



    <!-- added code to display a line between the Series List and Container List jah 4/06 -->
    <xsl:template match="archdesc/dsc[@type='in-depth']">
        <!--		<hr></hr>  -->
        <xsl:comment> 65 </xsl:comment>
        <!--	<hr noshade="noshade"/> -->
        <xsl:apply-templates/>
    </xsl:template>

    <!--	<xsl:template match="archdesc/dsc[@type='in-depth']">
            <hr />
        </xsl:template>  -->

    <xsl:template match="archdesc/dsc[@type='in-depth']">
        <xsl:comment>75 </xsl:comment>
        <p>testing
            <xsl:if test="@level='file'" >
                <h3><xsl:value-of select="archdesc/dsc[@type='in-depth']/head"/><xsl:apply-templates/></h3>
            </xsl:if>
        </p>
    </xsl:template>


    <xsl:template match="archdesc/dsc[@type='in-depth']/head">
        <xsl:comment>85 </xsl:comment>
        <!--		<p>
                    <a href="#">Return to the Table of Contents<xsl:comment> 57 </xsl:comment></a>
                </p>
                <hr />  -->
        <h3>
            <a name="{generate-id()}"><xsl:comment> anchor </xsl:comment></a>
            <xsl:comment>92</xsl:comment>
            <xsl:apply-templates/>
            <xsl:comment>94 </xsl:comment>
        </h3>
        <xsl:comment>96 </xsl:comment>
    </xsl:template>

    <xsl:template match="archdesc/dsc">
        <xsl:apply-templates/>
    </xsl:template>




    <!-- ................Section 2 ...........................-->
    <!--This section of the stylesheet contains two templates
    that are used generically throughout the stylesheet.-->

    <!--This template formats the unitid, origination, unittitle,
    unitdate, and physdesc elements of components at all levels. They appear on
    a separate line from other did elements. It is generic to all
    component levels.-->

    <xsl:template name="component-did">
        <!--Inserts unitid and a space if it exists in the markup.-->
        <xsl:if test="unitid">
            <xsl:apply-templates select="unitid"/>
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>

        <!--Inserts origination and a space if it exists in the markup.-->
        <xsl:if test="origination">
            <xsl:apply-templates select="origination"/>
            <xsl:text>&#x20;</xsl:text>
        </xsl:if>

        <!--This choose statement selects between cases where unitdate is a child of
        unittitle and where it is a separate child of did.-->
        <xsl:choose>
            <!--This code processes the elements when unitdate is a child
            of unittitle.-->
            <xsl:when test="unittitle/unitdate">
                <xsl:apply-templates select="unittitle/text()| unittitle/*[not(self::unitdate)]"/>
                <xsl:text>&#x20;</xsl:text>
                <xsl:for-each select="unittitle/unitdate">
                    <xsl:apply-templates/>
                    <xsl:text>&#x20;</xsl:text>
                </xsl:for-each>
            </xsl:when>

            <!--This code process the elements when unitdate is not a
                    child of untititle-->
            <xsl:otherwise>
                <xsl:apply-templates select="unittitle"/>
                <xsl:text>&#x20;</xsl:text>
                <xsl:for-each select="unitdate">
                    <xsl:apply-templates/>
                    <xsl:text>&#x20;</xsl:text>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="physdesc"/>
    </xsl:template>


    <!-- ...............Section 3.............................. -->
    <!--This section of the stylesheet creates an HTML table for each c01.
    It then recursively processes each child component of the
    c01 by calling a named template specific to that component level.
    The named templates are in section 4.-->

    <!-- created two templates where there was one
     One is for the Series List and the Other for the Container List
         The purpose was to change the indentation of the scopecontent of
         the Series List. Previously, the Series List and Container List used
         the same table for formatting". jah 4/06 -->



    <xsl:template match="dsc[@type='in-depth']">
        <xsl:comment>172 </xsl:comment>
        <!--	<xsl:call-template name="file_head"/> -->
        <xsl:apply-templates select="head" />
        <xsl:comment>175 </xsl:comment>
        <table width="100%"  border-top="none">
            <xsl:for-each select="c01">
                <xsl:comment>177 </xsl:comment>
                <xsl:choose>
                    <xsl:when test="@level='series'">
                        <xsl:call-template name="c01-level-series"/>
                    </xsl:when>
                    <xsl:otherwise >
                        <xsl:call-template name="c01-level-file"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:for-each select="c02">
                    <xsl:choose>
                        <xsl:when test="@level='subseries' or @level='series'">
                            <xsl:call-template name="c02-level-subseries"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="c02-level-container"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:for-each select="c03">
                        <xsl:call-template name="c03-level"/>

                        <xsl:for-each select="c04">
                            <xsl:call-template name="c04-level"/>

                            <xsl:for-each select="c05">
                                <xsl:call-template name="c05-level"/>

                                <xsl:for-each select="c06">
                                    <xsl:call-template name="c06-level"/>

                                    <xsl:for-each select="c07">
                                        <xsl:call-template name="c07-level"/>

                                        <xsl:for-each select="c08">
                                            <xsl:call-template name="c08-level"/>

                                            <xsl:for-each select="c09">
                                                <xsl:call-template name="c09-level"/>

                                                <xsl:for-each select="c10">
                                                    <xsl:call-template name="c10-level"/>
                                                </xsl:for-each><!--Closes c10-->
                                            </xsl:for-each><!--Closes c09-->
                                        </xsl:for-each><!--Closes c08-->
                                    </xsl:for-each><!--Closes c07-->
                                </xsl:for-each><!--Closes c06-->
                            </xsl:for-each><!--Closes c05-->
                        </xsl:for-each><!--Closes c04-->
                    </xsl:for-each><!--Closes c03-->
                </xsl:for-each><!--Closes c02-->
            </xsl:for-each><!-- closes c01 -->
        </table>
        <p>
            <a href="#">
                Return to the Table of Contents
            </a>
        </p>
    </xsl:template>

    <xsl:template match="dsc[@type='analyticover']/c01[@level='series']">

        <!-- modified jah 4/2206 -->

        <table class="series">
            <xsl:call-template name="c01-level-II"/>

            <xsl:for-each select="c02">

                <xsl:choose>
                    <xsl:when test="@level='subseries' or @level='series'">
                        <xsl:call-template name="c02-level-subseries"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="c02-level-container"/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:for-each select="c03">
                    <xsl:call-template name="c03-level"/>

                    <xsl:for-each select="c04">
                        <xsl:call-template name="c04-level"/>

                        <xsl:for-each select="c05">
                            <xsl:call-template name="c05-level"/>

                            <xsl:for-each select="c06">
                                <xsl:call-template name="c06-level"/>

                                <xsl:for-each select="c07">
                                    <xsl:call-template name="c07-level"/>

                                    <xsl:for-each select="c08">
                                        <xsl:call-template name="c08-level"/>

                                        <xsl:for-each select="c09">
                                            <xsl:call-template name="c09-level"/>

                                            <xsl:for-each select="c10">
                                                <xsl:call-template name="c10-level"/>
                                            </xsl:for-each><!--Closes c10-->
                                        </xsl:for-each><!--Closes c09-->
                                    </xsl:for-each><!--Closes c08-->
                                </xsl:for-each><!--Closes c07-->
                            </xsl:for-each><!--Closes c06-->
                        </xsl:for-each><!--Closes c05-->
                    </xsl:for-each><!--Closes c04-->
                </xsl:for-each><!--Closes c03-->
            </xsl:for-each><!--Closes c02-->
        </table>

    </xsl:template>



    <!-- ...............Section 4.............................. -->
    <!--This section of the stylesheet contains a separate named template for
    each component level. The contents of each is identical except for the
    spacing that is inserted to create the proper column display in HTML
    for each level.-->


    <!--Processes c01 which is assumed to be a series
    description without associated components.-->
    <xsl:template name="c01-level-series">
        <xsl:for-each select="did">
            <tr>
                <th colspan="2"><xsl:comment> 308 </xsl:comment>
                    <h4><a>
                        <xsl:attribute name="name">
                            <xsl:text>series</xsl:text><xsl:number from="dsc" count="c01 "/>
                        </xsl:attribute>
                        <xsl:comment> anchor </xsl:comment>
                    </a>
                        <xsl:call-template name="component-did"/>
                    </h4>
                </th>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 281 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <!--This template creates a separate row for each child of
            the listed elements.-->
        <xsl:for-each select="scopecontent | bioghist | arrangement | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment>335 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 345 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>




    <xsl:template name="c01-level-II">
        <xsl:for-each select="did">

            <tr>
                <th colspan="2"><h4><xsl:call-template name="component-did"/></h4></th>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1" colspan="2"><xsl:comment> 365 </xsl:comment></td>
                    <td class="container_col2"><xsl:apply-templates/></td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <!--This template creates a separate row for each child of
            the listed elements.-->
        <xsl:for-each select="scopecontent | bioghist | arrangement | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th colspan="2"><h5><xsl:apply-templates/></h5></th>
                </tr>
            </xsl:for-each>
            <!-- modified jah 4/2006 -->
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1" colspan="2"><xsl:apply-templates/></td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!--	<xsl:template name="file_head" match="head">
            <h3>test</h3>
            <xsl:apply-templates/>
        </xsl:template>
        -->
    <xsl:template name="c01-level-file">
        <xsl:for-each select="did">
            <!-- uncomment if needed
                <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                <td class="container_col1"><xsl:comment> 337 </xsl:comment></td>
                <td class="container_col2"><xsl:value-of select="container/@type"/></td>
                </tr>
                </xsl:if>
            -->
            <tr>
                <td class="container_col1"><xsl:comment> 405 </xsl:comment>
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 414 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment>426 </xsl:comment></th>
                    <th class="container_col2">
                        <xsl:apply-templates/>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 434 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>

    </xsl:template>







    <!--This template processes c02 elements that have associated containers, for
    example when c02 is a file.-->
    <xsl:template name="c02-level-container">

        <xsl:for-each select="did">
            <!-- uncomment if needed
                <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                             <tr>
                                 <td class="container_col1"><xsl:comment> 337 </xsl:comment></td>
                                 <td class="container_col2"><xsl:value-of select="container/@type"/></td>
                            </tr>
                        </xsl:if>
            -->
            <tr>
                <td class="container_col1"><xsl:comment> 464 </xsl:comment>
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 473</xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 485</xsl:comment></th>
                    <th class="container_col2">
                        <xsl:apply-templates/>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 493 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!--This template processes c02 level components that do not have
    associated containers, for example if the c02 is a subseries. The
    various subelements are all indented one column to the right of c01.-->
    <xsl:template name="c02-level-subseries">
        <xsl:for-each select="did">
            <tr>
                <th colspan="2"><xsl:comment> 465 </xsl:comment>
                    <h5><xsl:comment> Line 401 </xsl:comment>
                        <xsl:call-template name="component-did"/>
                    </h5>
                </th>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 516 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closese the did.-->
        <xsl:for-each select="scopecontent | bioghist | arrangement | descgrp/* | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment>527 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 537 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="c03-level">
        <xsl:for-each select="did">

            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <!-- Note from Megg: is this intentionally blank? Or is there an instance when text appears? -->
                <!-- Removed row with comments in case needed -->
                <!--
                            <tr>
                                <th colspan="2">
                                    <h6>
                                        <xsl:comment> 419 </xsl:comment>
                                        <xsl:value-of select="container/@type"/>
                                    </h6>
                                </th>
                            </tr>
                -->
            </xsl:if>
            <tr>
                <td class="container_col1"><xsl:comment> 521 </xsl:comment><xsl:apply-templates select="container"/></td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 571 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 583 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 593 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!--This template processes c04 level components.-->
    <xsl:template name="c04-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td colspan="2">
                        <strong>
                            <xsl:value-of select="container/@type"/>
                        </strong>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 624 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | descgrp/* | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment>636 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 646</xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="c05-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td class="container_col1">
                        <strong>
                            <xsl:value-of select="container/@type"/>
                        </strong>
                    </td>
                    <td class="container_col2"><xsl:comment> 664 </xsl:comment>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 635 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | descgrp/* | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note">
            <!--The head element is rendered in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 690 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>
                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 700 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!--This template processes c06 components.-->
    <xsl:template name="c06-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td colspan="2">
                        <strong>
                            <xsl:value-of select="continer/@type"/>
                        </strong>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 731 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
            <!--The head element is displayed in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 744 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>

                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 754 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="c07-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td colspan="2">
                        <strong>
                            <xsl:value-of select="container/@type"/>
                        </strong>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 784 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each> <!--Closes the did.-->
        <xsl:for-each select="scopecontent | bioghist | arrangement | descgrp/* | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note">
            <!--The head element is displayed in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 795 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>

                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment>806 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="c08-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td colspan="2">
                        <strong>
                            <xsl:value-of select="container/@type"/>
                        </strong>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:value-of select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 836 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | descgrp/* | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note">
            <!--The head element is displayed in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 848 </xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>


                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 860 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="c09-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td colspan="2">
                        <strong>
                            <xsl:value-of select="container/@type"/>
                        </strong>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 890 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each><!--Closes the did.-->

        <xsl:for-each select="scopecontent | bioghist | arrangement | descgrp/* | userestrict | accessrestrict | processinfo | acqinfo | custodhist | controlaccess/controlaccess | odd | note">
            <!--The head element is displayed in bold.-->
            <xsl:for-each select="head">
                <tr>
                    <th class="container_col1"><xsl:comment> 902</xsl:comment></th>
                    <th class="container_col2">
                        <strong>
                            <xsl:apply-templates/>
                        </strong>
                    </th>

                </tr>
            </xsl:for-each>
            <xsl:for-each select="*[not(self::head)]">
                <tr>
                    <td class="container_col1"><xsl:comment> 913 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="c10-level">
        <xsl:for-each select="did">
            <xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
                <tr>
                    <td class="container_col1">
                        <strong>
                            <xsl:value-of select="container/@type"/>
                        </strong>
                    </td>
                    <td class="container_col2"><xsl:comment> 888</xsl:comment>
                    </td>
                </tr>
            </xsl:if>
            <tr>
                <td class="container_col1">
                    <xsl:apply-templates select="container"/>
                </td>
                <td class="container_col2">
                    <xsl:call-template name="component-did"/>
                </td>
            </tr>
            <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                <tr>
                    <td class="container_col1"><xsl:comment> 902 </xsl:comment></td>
                    <td class="container_col2">
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>	<!--Closes the did.-->
    </xsl:template>
    <!-- ****************************************************************** -->

    <!-- LINKS                                                              -->

    <!-- Converts REF, EXTREF, DAO and PTR elements into HTML links         -->

    <!-- ****************************************************************** -->



    <xsl:template match="ref">

        <a href="#{@target}">

            <xsl:apply-templates/>

        </a>

    </xsl:template>



    <xsl:template match="extref | archref">

        <xsl:choose>

            <xsl:when test="self::extref[@show='new']">

                <a href="{@href}" target="_blank"><xsl:apply-templates/></a>

            </xsl:when>

            <xsl:otherwise>

                <a href="{@href}"><xsl:apply-templates/></a>

            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>



    <xsl:template match="ptr">

        <a href="{@href}">

            <xsl:value-of select="@href"/><xsl:apply-templates/>

        </a>

    </xsl:template>



    <xsl:template match="extptr">

        <xsl:choose>

            <xsl:when test="self::extptr[@show='embed']">

                <img src="{@xpointer}" alt="{@title}" align="{@altrender}"/>

            </xsl:when>

            <xsl:otherwise>

                <a href="{@xpointer}">"{@title}"ha</a>

            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>



    <xsl:template match="dao">

        <xsl:choose>

            <xsl:when test="self::dao[@show='new']">

                <a href="{@href}" target="_blank">Digital object</a>

            </xsl:when>

            <xsl:otherwise>

                <a href="{@href}">Digital object</a>

            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>
