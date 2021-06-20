<#include "header.ftl">
	
	<#include "menu.ftl">
<section class="my-2 py-5 container">
	<#if (content.title)??>
	<div class="page-header">
		<h1><#escape x as x?xml>${content.title}</#escape></h1>
	</div>
	<#else></#if>

	<p><em>${content.date?string("dd MMMM yyyy")}</em></p>

<#if (content.youtubeid)??>
<div class="text-center">
	<iframe style="width: 50%; height: 33vh;" src="https://www.youtube.com/embed/${content.youtubeid}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
</#if>

	<p>${content.body}</p>

	<hr />
</section>
<#include "footer.ftl">