package test.rest_webservice_local;

interface CucumberClientInterface {
    public void startServer();
    public void stopServer();
    public String getPasswordRules(String password);
    public String getPasswordStrength(String password);
}