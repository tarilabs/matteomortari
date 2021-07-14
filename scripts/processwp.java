///usr/bin/env jbang "$0" "$@" ; exit $? 
//JAVA 11+
//DEPS info.picocli:picocli:4.2.0
//DEPS org.jsoup:jsoup:1.14.1

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.stream.Collectors;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Comment;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.select.NodeFilter;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Parameters;

// code `jbang edit scripts/processwp.java`
@Command(name = "processwp", mixinStandardHelpOptions = true)
public class processwp implements Callable<Integer> {
    @Parameters(
        index = "0",
        description = "The message to send",
        defaultValue = "content/blog"
    )
    private File basePath;

    public static void main(String[] args) throws Exception {
        int exitCode = new CommandLine(new processwp()).execute(args);
        System.exit(exitCode);
    }

    @Override
    public Integer call() {
        try {
            System.out.println("Start. "+basePath.getAbsolutePath());
            List<Path> files = Files.walk(basePath.toPath()).filter(p -> p.toAbsolutePath().toString().endsWith(".html")).collect(Collectors.toList());
            for(Path f : files) {
                processHTMLFromWP(f.toFile());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 1;
        }
        return 0;
    }

    private static void processHTMLFromWP(File input) throws IOException {
        System.out.print(input+"... ");
        var allLines= Files.readAllLines(input.toPath());
        if (!allLines.stream().collect(Collectors.joining()).contains("<!-- wp:paragraph -->")) {
            // File do not contain any <!-- wp:paragraph --> lines.
            System.out.println(CommandLine.Help.Ansi.AUTO.string("@|bold,yellow skipped|@"));
            return;
        }
        var indexOfMDH = allLines.indexOf("~~~~~~");
        if (indexOfMDH<0) {
            throw new IllegalStateException();
        }
        String mdHeader = allLines.subList(0, indexOfMDH+1).stream().collect(Collectors.joining(System.lineSeparator()));
        String htmlPart =allLines.subList(indexOfMDH+1, allLines.size()).stream().collect(Collectors.joining(System.lineSeparator()));
        Document doc = Jsoup.parseBodyFragment(htmlPart);
        doc.body().filter(new NodeFilterImplementation());
        var imgs = doc.select("img");
        for (Element e : imgs) {
            e.attr("width", false);
            e.attr("height", false);
            e.classNames(Set.of("img-fluid"));
            if (!e.parent().tagName().equals("figure")) {
                if (e.parent().tagName().equals("p")) {
                    e.parent().addClass("text-center");
                }
            }
        }
        var imgInFigures = doc.select("figure > img");
        for (Element i : imgInFigures) {
            i.classNames(Set.of("figure-img", "img-fluid"));
        }
        var figures = doc.select("figure");
        for (Element f : figures) {
            if (f.hasClass("wp-block-embed-youtube")) {
                continue;
            }
            f.classNames(Set.of("figure"));
            Element div = new Element("div");
            div.classNames(Set.of("row","justify-content-center","text-center"));
            div.html(f.outerHtml());
            f.replaceWith(div);
        }
        var youtubes = doc.select("figure.wp-block-embed-youtube");
        for (Element y : youtubes) {
            String ytURL = y.text().trim();
            if (!ytURL.contains("/embed/")) {
                ytURL = "https://www.youtube.com/embed/"+ytURL.substring(ytURL.lastIndexOf("/")+1);
            }
            Element iframe = new Element("iframe");
            iframe.attr("src", ytURL);
            iframe.attr("title", "YouTube video player");
            iframe.attr("frameborder", "0");
            iframe.attr("allow", "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture");
            iframe.attr("allowfullscreen", true);
            Element ratio = new Element("div").classNames(Set.of("ratio","ratio-16x9")).appendChild(iframe);
            Element col = new Element("div").classNames(Set.of("col-lg-6")).appendChild(ratio);
            Element row = new Element("div").classNames(new LinkedHashSet<>(List.of("row","justify-content-center","text-center", "py-3"))).appendChild(col);
            y.replaceWith(row);
        }
        String content = mdHeader + System.lineSeparator() +  doc.body().html();
        System.out.println(CommandLine.Help.Ansi.AUTO.string("@|bold,green DONE|@"));
        Files.writeString(input.toPath(), content, StandardOpenOption.WRITE, StandardOpenOption.TRUNCATE_EXISTING);
    }
}

final class NodeFilterImplementation implements NodeFilter {
    @Override
    public FilterResult tail(Node node, int depth) {
        if (node instanceof Comment) {
            return FilterResult.REMOVE;
        }
        return FilterResult.CONTINUE;
    }

    @Override
    public FilterResult head(Node node, int depth) {
        if (node instanceof Comment) {
            return FilterResult.REMOVE;
        }
        return FilterResult.CONTINUE;
    }
}