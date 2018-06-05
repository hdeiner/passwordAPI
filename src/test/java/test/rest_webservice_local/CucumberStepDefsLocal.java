package test.rest_webservice_local;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class CucumberStepDefsLocal {
    private static CucumberClientInterface cucumberClientInterface;

    private String password;

    @Given("^I am using a fake server$")
    public void i_am_using_a_fake_server() throws Throwable {
        cucumberClientInterface.startServer();
    }

    @Then("^I stop the server$")
    public void i_stop_the_server() throws Throwable {
        cucumberClientInterface.stopServer();
    }

    @Given("^I want to change my password with the UM Portal on a fake server$")
    public void i_want_to_change_my_password_with_the_UM_Portal_fake_server() throws Exception {
        cucumberClientInterface = new CucumberClientLocal();
        cucumberClientInterface.startServer();
    }

    @When("^I try to set my new password to \"([^\"]*)\"$")
    public void i_try_to_set_my_new_password_to(String password) throws Exception {
        this.password = password;
    }

    @Then("^I then I should be told \"([^\"]*)\"$")
    public void i_then_I_should_be_told(String passwordAdvice) throws Exception {
        assertThat(cucumberClientInterface.getPasswordRules(password), is(passwordAdvice));
    }

    @Then("^I then I should be told that it has a strength of \"([^\"]*)\"$")
    public void i_then_I_should_be_told_that_it_has_a_strength_of(String passwordStrength) throws Exception {
        assertThat(cucumberClientInterface.getPasswordStrength(password), is(passwordStrength));
    }

}