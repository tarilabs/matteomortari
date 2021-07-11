<#include "header.ftl">
	
	<#include "menu.ftl">
<section class="my-2 py-5 container">
	<#if (content.title)??>
	<div class="page-header">
		<h1><#escape x as x?xml>${content.title}</#escape></h1>
	</div>
	<#else></#if>

	<p><em>${content.date?string("dd MMMM yyyy")}</em></p>

<div class="row justify-content-center text-center">
<div class="col-lg-6">
<#if (content.youtubeid)??>
<div class="ratio ratio-16x9">
	<iframe src="https://www.youtube.com/embed/${content.youtubeid}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
<#elseif (content.preview)??>
	<img src="../../${content.preview}" class="img-fluid" />
</#if>
</div>
</div>

	<p>${content.body}</p>

</section>
<#include "footer.ftl">