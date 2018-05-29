package test;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class CucumberStepDefs {
    private static CucumberClientInterface cucumberClientInterface;

    private String password;

    @Given("^I am using a fake server$")
    public void i_am_using_a_fake_server() throws Throwable {
        cucumberClientInterface = new CucumberClientFake();
        cucumberClientInterface.startServer();
    }

//    @Given("^I am using a local server$")
//    public void i_am_using_a_local_server() throws Throwable {
//        checkWordsterCucumberClientInterface = new CucumberClientLocal();
//        checkWordsterCucumberClientInterface.startServer();
//    }

    @Then("^I stop the server$")
    public void i_stop_the_server() throws Throwable {
        cucumberClientInterface.stopServer();
    }

//    @When("^I convert \"([^\"]*)\" into words$")
//    public void i_convert_into_words(String stringToConvert) throws Throwable {
//        this.stringToConvert = stringToConvert;
//    }

//    @Then("^it should be \"([^\"]*)\"$")
//    public void it_should_be(String numberInWords) throws Throwable {
//        assertThat(checkWordsterCucumberClientInterface.getWords(stringToConvert), is(numberInWords));
//    }

//    @Then("^an exception \"([^\"]*)\" should be thrown$")
//    public void an_exception_should_be_thrown(String exceptedExceptionMessage) {
//        try {
//            CheckWordster checkWordster = new CheckWordster(this.stringToConvert);
//            assertThat("Supposed to throw a \"" + exceptedExceptionMessage + "\" exception", true, is(false));
//        } catch (CheckWordsterException e) {
//            assertThat(e.getMessage(), is(exceptedExceptionMessage));
//        }
//    }

    @Given("^I want to change my password with the UM Portal on a fake server$")
    public void i_want_to_change_my_password_with_the_UM_Portal_fake_server() throws Exception {
        cucumberClientInterface = new CucumberClientFake();
        cucumberClientInterface.startServer();
    }

    @When("^I try to set my new password to \"([^\"]*)\"$")
    public void i_try_to_set_my_new_password_to(String password) throws Exception {
        this.password = password;
    }

    @Then("^I then I should be told \"([^\"]*)\"$")
    public void i_then_I_should_be_told(String passwordAdvice) throws Exception {
        assertThat(cucumberClientInterface.getPasswordAdvice(password), is(passwordAdvice));
    }

    @Then("^I then I should be told that it has a strength of \"([^\"]*)\"$")
    public void i_then_I_should_be_told_that_it_has_a_strength_of(String arg1) throws Exception {
        // Write code here that turns the phrase above into concrete actions
    }

}