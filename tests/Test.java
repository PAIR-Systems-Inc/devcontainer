import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.FileInputStream;
import java.util.Properties;

public class Test {
    private static final String HOST_URL = "http://155.138.208.97:8080/v1";
    private static String API_KEY;
    
    public static void main(String[] args) {
        loadEnvironment();
        System.out.println("Debug: API_KEY = " + API_KEY);
        
        // Health check
        testApiHealth();
        
        // API key validation
        if (API_KEY == null || API_KEY.contains("ADD")) {
            System.out.println("please add the API key to .env file");
        }
        
        // Test HTTP API calls
        testHttpClient();
        
        System.out.println("Java GoodMem integration test completed");
    }
    
    private static void loadEnvironment() {
        Properties props = new Properties();
        try {
            props.load(new FileInputStream(".env"));
            API_KEY = props.getProperty("ADD_API_KEY");
        } catch (IOException e) {
            System.out.println("Could not load .env file: " + e.getMessage());
        }
    }
    
    private static void testApiHealth() {
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest.Builder requestBuilder = HttpRequest.newBuilder()
                .uri(URI.create(HOST_URL.replace("/v1", "/v1/spaces")))
                .GET();
            
            if (API_KEY != null && !API_KEY.contains("ADD")) {
                requestBuilder.header("x-api-key", API_KEY);
            }
            
            HttpRequest request = requestBuilder.build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            System.out.println("api health pass: " + response.statusCode());
        } catch (Exception e) {
            System.out.println("api health check fail: " + e.getMessage());
        }
    }
    
    private static void testHttpClient() {
        try {
            if (API_KEY == null || API_KEY.contains("ADD")) {
                System.out.println("Skipping HTTP client test - no valid API key");
                return;
            }
            
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(HOST_URL.replace("/v1", "/v1/spaces")))
                .header("x-api-key", API_KEY)
                .GET()
                .build();
            
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                System.out.println("Java HTTP client test: successful");
            } else {
                System.out.println("Java HTTP client test failed with status: " + response.statusCode());
            }
            
        } catch (Exception e) {
            System.out.println("Java HTTP client test failed: " + e.getMessage());
        }
    }
}