package test.rest_webservice_local;

interface CucumberClientInterface {
    void startServer();
    void stopServer();
    String getPasswordRules(String password);
    String getPasswordStrength(String password);
}