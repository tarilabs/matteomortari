<#include "header.ftl">

	<#include "menu.ftl">
<section class="my-2 py-5 container">
	<div class="page-header">
		<h1>${content.title}</h1>
	</div>
	
<#assign inlineTemplate = content.body?interpret>
<@inlineTemplate />

</section>
<#include "footer.ftl">