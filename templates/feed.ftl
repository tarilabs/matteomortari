<?xml version="1.0"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>Matteo Mortari, Software Engineer</title>
    <link>${config.site_host}</link>
    <atom:link href="${config.site_host}/${config.feed_file}" rel="self" type="application/rss+xml" />
    <description>I believe there is a whole new range of unexplored applications for Rule Engines (AI/Expert Systems) and Machine Learning; I also believe defining the Business Rules on the BRMS system not only enables knowledge inference from raw data, but most importantly when modeled using the DMN open standard, it helps to shorten the distance between experts and analysts, between developers and end-users, business stakeholders.</description>
    <language>en-gb</language>
    <pubDate>${published_date?string("EEE, d MMM yyyy HH:mm:ss Z")}</pubDate>
    <lastBuildDate>${published_date?string("EEE, d MMM yyyy HH:mm:ss Z")}</lastBuildDate>

    <#list published_content?sort_by("date")?reverse[0..*100] as post>
    <item>
      <title><#escape x as x?xml>${post.title}</#escape></title>
      <link>${config.site_host}/${post.uri}</link>
      <pubDate>${post.date?string("EEE, d MMM yyyy HH:mm:ss Z")}</pubDate>
      <guid isPermaLink="false">${post.uri}</guid>
      	<description>
	<#escape x as x?xml>	
	${post.body}
	</#escape>
	</description>
    </item>
    </#list>

  </channel> 
</rss>
