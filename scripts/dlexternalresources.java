///usr/bin/env jbang "$0" "$@" ; exit $? 
//JAVA 21+
//DEPS info.picocli:picocli:4.7.5
//DEPS org.jsoup:jsoup:1.16.2

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.stream.Collectors;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Parameters;

// code `jbang edit -b scripts/dlexternalresources.java`
// in sandbox: jbang src/dlexternalresources.java ~/git/matteomortari/content/blog
@Command(name = "dlexternalresources", mixinStandardHelpOptions = true)
public class dlexternalresources implements Callable<Integer> {
    @Parameters(
        index = "0",
        description = "The base path of the content/blog directory",
        defaultValue = "content/blog"
    )
    private File basePath;

    public static void main(String[] args) throws Exception {
        int exitCode = new CommandLine(new dlexternalresources()).execute(args);
        System.exit(exitCode);
    }

    @Override
    public Integer call() {
        try {
            System.out.println("Start. "+basePath.getAbsolutePath());
            List<Path> files = Files.walk(basePath.toPath()).filter(p -> p.toAbsolutePath().toString().endsWith(".html")).collect(Collectors.toList());
            for(Path f : files) {
                siphonFromHTMLFile(f.toFile());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 1;
        }
        return 0;
    }

    private void siphonFromHTMLFile(File input) throws Exception {
        System.out.println(input+"... ");
        var allLines= Files.readAllLines(input.toPath());
        var indexOfMDH = allLines.indexOf("~~~~~~");
        if (indexOfMDH<0) {
            throw new IllegalStateException();
        }
        // String mdHeader = allLines.subList(0, indexOfMDH+1).stream().collect(Collectors.joining(System.lineSeparator()));
        String htmlPart =allLines.subList(indexOfMDH+1, allLines.size()).stream().collect(Collectors.joining(System.lineSeparator()));
        Document doc = Jsoup.parseBodyFragment(htmlPart);
        var imgs = doc.select("img");
        for (Element e : imgs) {
            var imgSrc = e.attr("src");
            if (imgSrc.startsWith("http")) {
                siphonRemote(input, imgSrc);
            }
        }
    }

    private void siphonRemote(File input, String imgSrc) throws Exception {
        String name = input.getName().substring(0,input.getName().lastIndexOf(".html"));
        File parent = input.getParentFile();
        File dlDir = new File(parent, name);
        File destFile = new File(dlDir, asFriendlyFilename(imgSrc));
        if (!destFile.exists()) {
            System.out.println(" downloading to: "+destFile);
            dlDir.mkdirs();
            download(imgSrc, destFile.getAbsolutePath());
        } else {
            System.out.println(" skip (already existing): "+destFile);
        }
    }

    static long download(String url, String fileName) throws IOException {
        try (InputStream in = URI.create(url).toURL().openStream()) {
            return Files.copy(in, Paths.get(fileName));
        }
    }


    private String asFriendlyFilename(String input) throws Exception {
        byte[] bytes = input.getBytes("UTF-8");
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            if (b >= 'a' && b <= 'z' || b >= 'A' && b <= 'Z' || b >= '0' && b <= '9' || b == '.')  {
                sb.append((char)b);
            } else {
                sb.append("%").append(String.format("%02X", b));
            }
        }
        return sb.toString();
    }
}