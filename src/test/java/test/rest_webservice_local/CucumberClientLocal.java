package test.rest_webservice_local;

import us.monoid.json.JSONException;
import us.monoid.json.JSONObject;
import us.monoid.web.JSONResource;
import us.monoid.web.Resty;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.options;
import static us.monoid.web.Resty.content;

public class CucumberClientLocal implements CucumberClientInterface {

    public void startServer(){
    };

    public void stopServer(){
    };

    public String getPasswordRules(String password){
        String words = "";
        Resty resty  = new Resty();

        URL url = null;
        URI uri;

        try {
            url = new URL("http://localhost:8080/passwordAPI/passwordRules/"+password);
            uri = new URI(url.getProtocol(), url.getUserInfo(), url.getHost(), url.getPort(), url.getPath(), url.getQuery(), url.getRef());
            JSONResource response = resty.json(uri);
            words = (String) response.get("passwordRules");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return words;
    };
    public String getPasswordStrength(String password){
        String words = "";
        Resty resty  = new Resty();

        URL url = null;
        URI uri;

        try {
            url = new URL("http://localhost:8080/passwordAPI/passwordStrength/" + password);
            uri = new URI(url.getProtocol(), url.getUserInfo(), url.getHost(), url.getPort(), url.getPath(), url.getQuery(), url.getRef());
            JSONResource response = resty.json(uri);
            words = (String) response.get("passwordStrength");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return words;
    };
}