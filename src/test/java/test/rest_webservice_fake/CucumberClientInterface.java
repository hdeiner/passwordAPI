package test.rest_webservice_fake;

interface CucumberClientInterface {
    void startServer();
    void stopServer();
    String getPasswordRules(String password);
    String getPasswordStrength(String password);
}