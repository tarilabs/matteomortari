<#include "header.ftl">
	
	<#include "menu.ftl">
<section class="my-2 py-5 container">
	<#if (content.title)??>
	<div class="page-header">
		<h1><#escape x as x?xml>${content.title}</#escape></h1>
	</div>
	<#else></#if>

	<p><em>${content.date?string("dd MMMM yyyy")}</em></p>

<div class="text-center">
<#if (content.youtubeid)??>
	<iframe style="width: 50%; height: 33vh;" src="https://www.youtube.com/embed/${content.youtubeid}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
<#elseif (content.preview)??>
	<img src="../../${content.preview}" style="width: 50%"/>
</#if>
</div>

	<p>${content.body}</p>

</section>
<#include "footer.ftl">