package test;

import com.github.tomakehurst.wiremock.WireMockServer;
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

public class CucumberClientFake implements CucumberClientInterface {
    private static WireMockServer wireMockServer = null;

    public void startServer(){
        if (wireMockServer == null) {
            wireMockServer  = new WireMockServer(options().port(9010));
        }
        wireMockServer.start();
    };

    public void stopServer(){
        wireMockServer.stop();
    };

    public String getPasswordAdvice(String password){
        String words = "";
        Resty resty  = new Resty();

        URL url = null;
        URI uri;

        try {
            url = new URL("http://localhost:9010/getPasswordAdvice");
            uri = new URI(url.getProtocol(), url.getUserInfo(), url.getHost(), url.getPort(), url.getPath(), url.getQuery(), url.getRef());
            String requestToPost = "{\"password\": \"" + password + "\"}";

            JSONResource response = resty.json(uri,content(new JSONObject(requestToPost)));
            words = (String) response.get("passwordAdvice");
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
            url = new URL("http://localhost:9010/getPasswordStrength");
            uri = new URI(url.getProtocol(), url.getUserInfo(), url.getHost(), url.getPort(), url.getPath(), url.getQuery(), url.getRef());
            String requestToPost = "{\"password\": \"" + password + "\"}";

            JSONResource response = resty.json(uri,content(new JSONObject(requestToPost)));
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