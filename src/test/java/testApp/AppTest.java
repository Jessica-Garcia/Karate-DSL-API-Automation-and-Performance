package testApp;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import net.masterthought.cucumber.ReportBuilder;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.junit.jupiter.api.Test;

import java.io.File;
import net.masterthought.cucumber.Configuration;
import org.apache.commons.io.FileUtils;

class AppTest {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:testApp")
                .outputCucumberJson(true)
                .parallel(2);
        generateReport(results.getReportDir());
        assertTrue(results.getFailCount() == 0, results.getErrorMessages());

    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] { "json" }, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "testApp");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
