package test;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)

@CucumberOptions(
//      dryRun   = false,
//      strict = true,
//      tags     = "",
//      monochrome = false,
        features = { "src/test/features" },
        glue     = { "test" },
        plugin   = { "pretty", "html:target/cucumber/html-report", "json:target/cucumber/json-report.json" }
)

public class CucumberTest {

}