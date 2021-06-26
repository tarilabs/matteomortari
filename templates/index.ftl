<#include "header.ftl">
    
<header>
  <div class="navbar fixed-top navbar-dark bg-dark shadow-lg">
    <div class="container">
      <a href="#" class="navbar-brand d-flex align-items-center">
        <strong>MM</strong>
      </a>
      <ul class="nav nav-pills justify-content-end">
        <li><a href="#talks" class="nav-link px-2 text-white">Talks</a></li>
        <li><a href="#projects" class="nav-link px-2 text-white">Projects</a></li>
        <li><a href="#blog" class="nav-link px-2 text-white">Blog</a></li>
        <li><a href="#about" class="nav-link px-2 text-white">About</a></li>
      </ul>
    </div>
  </div>
</header>

<main>
  <div class="container-fluid d-flex flex-column justify-content-end align-items-center" style="height: 90vh; background-image: url('img/conf.jpg'); background-repeat: no-repeat; background-position: center center; background-size: cover;">
        <h1 class="text-white display-1">Matteo Mortari</h1>
        <p class="lead px-1 text-muted" style="backdrop-filter: brightness(66%) blur(5px);">Software Engineer</p>
        <a href="#talks">
        <i class="bi-chevron-compact-down" style="font-size: 2rem; color: white;"></i>
      </a>
  </div>

  <div class="container px-4 py-5" id="talks">
    <div class="row row-cols-1 row-cols-lg-3 align-items-stretch g-4 py-5">
      <#list published_content?filter(x -> x.type == "talk")?sort_by("date")?reverse[0..*3] as content>
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
    <!-- more talks -->
    <div class="row">
      <div class="col">
        <p class="text-end">
          <a href="archive.html" class="text-decoration-none">
            More Talks
            <i class="bi-chevron-right"></i>
          </a>
        </p>
      </div>
    </div>
  </div>

  <section class="py-5 container" id="about">
    <div class="row py-lg-5">
      <div class="col-lg-4 col-md-4 mx-auto d-flex flex-column min-vh-50 justify-content-center align-items-center">
        <div class="px-5 py-5">
        <img src="img/redtie_squared_500.JPG" style="height: 100%;
        width: 100%;
        object-fit: cover;
        border-radius: 50%;"/>
        </div>
      </div>
      <div class="col-lg-8 col-md-8 mx-auto px-5">
        <p class="lead text-muted">
My name is Matteo Mortari and I'm a Software Engineer.
<br/><br/>
I believe there is a whole new range of unexplored applications for Rule Engines (AI/Expert Systems) and Machine Learning;
I also believe defining the Business Rules on the BRMS system not only enables knowledge inference from raw data, but most importantly when modeled using the DMN open standard, it helps to shorten the distance between experts and analysts, between developers and end-users, business stakeholders.
<br/><br/>
I enjoy traveling a lot, both for pleasure and business, which rewarded me already several chances to explore new places and meet new people worldwide.
<br/><br/>
Feel free to contact me:
<br/><br/>
<a href="https://www.linkedin.com/in/matteomortari" class="text-reset px-1" style="font-size: xx-large;"><i class="bi bi-linkedin"></i></a>
<a href="https://www.youtube.com/MatteoMortari" class="text-reset px-1" style="font-size: xx-large;"><i class="bi bi-youtube"></i></a>
<a href="https://github.com/tarilabs" class="text-reset px-1" style="font-size: xx-large;"><i class="bi bi-github"></i></a>
<!-- <a href="https://twitter.com/tari_manga" class="text-reset px-1" style="font-size: xx-large;"><i class="bi bi-twitter"></i></a> -->
        </p> 
      </div>
    </div>
    <div class="row py-5">
      <div class="col">
        <p class="text-end">
          <a href="about.html" class="text-decoration-none">
            About
            <i class="bi-chevron-right"></i>
          </a>
        </p>
      </div>
    </div>
  </section>

<div class="py-5 container" id="projects">
  <div class="row">
    <div class="col">
      <h1>Projects</h1>
      <p class="lead text-muted">a collection of the most recent projects I've been working on</p>
    </div>
  </div>
  <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
    <#assign projects = data.get('projects.yml').data>
    <#list projects as project>
    <div class="col">
      <div class="card shadow-sm">
        <div class="bd-placeholder-img card-img-top p-2" style="width: 100%; height: 225px; display: table-cell; text-align: center; vertical-align: middle; background-color: whitesmoke">
          <div style="width: 100%; height: 100%; background-image: url('${project.preview}'); background-repeat: no-repeat; background-position: center center; background-size: contain;"></div>
        </div>
        <div class="card-body">
          <p class="card-text">${project.description}</p>
          <div class="d-flex justify-content-between align-items-center">
            <div class="btn-group">
              <a href="${project.href}" role="button" class="btn btn-sm btn-outline-secondary">More details</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    </#list>
  </div>
  <!-- <div class="row py-5">
    <div class="col">
      <p class="text-end">
        <a href="#" class="text-decoration-none">
          More Projects
          <i class="bi-chevron-right"></i>
        </a>
      </p>
    </div>
  </div> -->
</div>

<section class="py-5 container" id="blog">
  <div class="row mb-2">
	<#assign post = posts?filter(x -> x.status == "published")[0]>
    <div class="col">
      <h1 class="blog-header pb-4 mb-4 fst-italic border-bottom">From the Blog</h1>
      <h3 class="blog-header"><a href="${post.uri}" class="text-reset text-decoration-none"><#escape x as x?xml>${post.title}</#escape></a></h3>
      <p class="text-muted"">${post.date?string("dd MMMM yyyy")}</p>
      <p>${post.body?replace("<[\\w/][^>]*>", "", "r")?replace("\\s+", " ", "r")?truncate(500, "...")}<br/><a href="${post.uri}" class="text-decoration-none">
        Continue reading
        <i class="bi-chevron-right"></i>
      </a></p> 
    </div>
  </div>
  <div class="row mb-2">
	<#list posts?filter(x -> x.status == "published")[1..2] as post>
    <div class="col-md-6">
		<h3 class="blog-header"><a href="${post.uri}" class="text-reset text-decoration-none"><#escape x as x?xml>${post.title}</#escape></a></h3>
		<p class="text-muted"">${post.date?string("dd MMMM yyyy")}</p>
		<p>${post.body?replace("<[\\w/][^>]*>", "", "r")?replace("\\s+", " ", "r")?truncate(500, "...")}<br/><a href="${post.uri}" class="text-decoration-none">
		  Continue reading
		  <i class="bi-chevron-right"></i>
		</a></p> 
    </div>
	</#list>
  </div>
  <div class="row py-5">
    <div class="col">
      <p>Older posts are available in the <a href="archive.html">archive</a>.</p>
    </div>
  </div>
</section>


<#include "footer.ftl">