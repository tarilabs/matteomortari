<#assign _description = content.description!
    ((content.type == "post")?then(content.body?replace("<[\\w/][^>]*>", "", "r")?replace("\\s+", " ", "r")?truncate(200, "...")?trim,
                                   "I believe there is a whole new range of unexplored applications for Rule Engines (AI/Expert Systems) and Machine Learning; I also believe defining the Business Rules on the BRMS system not only enables knowledge inference from raw data, but most importantly when modeled using the DMN open standard, it helps to shorten the distance between experts and analysts, between developers and end-users, business stakeholders.")
    )/>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1" name="viewport" >
<#-- _description if coming from post.body may still contain unescaped HTML comments, so better escape it: -->
    <meta content="<#escape x as x?xml>${_description}</#escape>" name="description"> 
    <title><#if (content.title)??><#escape x as x?xml>${content.title}</#escape><#else>Matteo Mortari, Software Engineer</#if></title>
<#if content.canonical??>
    <link rel="canonical" href="${content.canonical}" />
</#if>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
.blog-header {
  font-family: "Playfair Display", Georgia, "Times New Roman", serif/*rtl:Amiri, Georgia, "Times New Roman", serif*/;
}
img {
    max-width: 100%;
    height: auto;
}
    </style>
</head>
<body>