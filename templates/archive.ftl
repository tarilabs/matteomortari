<#include "header.ftl">

	<#include "menu.ftl">
	
	<div class="page-header">
		<h1>Archive</h1>
	</div>
	
	<!--<ul>-->
		<#list published_content?sort_by("date")?reverse as content>
		<#if (last_month)??>
			<#if content.date?string("MMMM yyyy") != last_month>
				</ul>
				<h4>${content.date?string("MMMM yyyy")}</h4>
				<ul>
			</#if>
		<#else>
			<h4>${content.date?string("MMMM yyyy")}</h4>
			<ul>
		</#if>
		
		<li>${content.date?string("dd")} - [${content.type}] - <a href="${content.uri}"><#escape x as x?xml>${content.title}</#escape></a></li>
		<#assign last_month = content.date?string("MMMM yyyy")>
		</#list>
	</ul>
	
<#include "footer.ftl">