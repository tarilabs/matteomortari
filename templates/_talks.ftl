<#include "header.ftl">

	<#include "menu.ftl">
<section class="my-2 py-5 container">
	<div class="page-header">
		<h1>Talks</h1>
	</div>
	

  <div class="container px-4 py-5" id="talks">
    <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-5">
      <#list published_content?filter(x -> x.type == "talk")?sort_by("date")?reverse as content>
      <div class="col">
        <div class="card card-cover h-100 overflow-hidden text-white bg-dark rounded-5 shadow-lg" style="
        border: none;
        background: linear-gradient(
          rgba(0, 0, 0, 0.7), 
          rgba(0, 0, 0, 0.7)
        ), url('${content.preview}');
        background-repeat: no-repeat; background-position: center center; background-size: cover;">
          <div class="d-flex flex-column h-100 p-5 pb-3 text-white text-shadow-1">
            <h2 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold"><a href="${content.uri}" class="text-reset text-decoration-none">${content.title}</a></h2>
            <ul class="d-flex list-unstyled mt-auto">
              <li class="me-auto">
                <#if content.icon??><i class="${content.icon}"></i><#else><i class="bi-youtube"></i></#if>
              </li>
              <li class="d-flex align-items-center">
                <a class="btn btn-outline-light btn-sm" href="${content.uri}" role="button">Watch <i class="bi-chevron-right"></i></a>
              </li>
            </ul>
          </div>
        </div>
      </div>
      </#list>
    </div>
  </div>

</section>
<#include "footer.ftl">