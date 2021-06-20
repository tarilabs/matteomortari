<#include "header.ftl">
	
	<#include "menu.ftl">
<section class="my-2 py-5 container">
	<#if (content.title)??>
	<div class="page-header">
		<h1 class="blog-header"><#escape x as x?xml>${content.title}</#escape></h1>
	</div>
	<#else></#if>

	<p><em>${content.date?string("dd MMMM yyyy")}</em></p>

	${content.body}

</section>
<#include "footer.ftl">