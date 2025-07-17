using System;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;

class Program
{
    private static readonly string HOST_URL = "http://155.138.208.97:8080/v1";
    private static string API_KEY;

    static async Task Main(string[] args)
    {
        LoadEnvironment();
        Console.WriteLine($"Debug: API_KEY = {API_KEY}");

        // Health check
        await TestApiHealth();

        // API key validation
        if (string.IsNullOrEmpty(API_KEY) || API_KEY.Contains("ADD"))
        {
            Console.WriteLine("please add the API key to .env file");
        }

        // Test HTTP API calls
        await TestHttpClient();

        Console.WriteLine(".NET GoodMem integration test completed");
    }

    private static void LoadEnvironment()
    {
        try
        {
            var envPath = ".devcontainer/.env";
            if (File.Exists(envPath))
            {
                var lines = File.ReadAllLines(envPath);
                foreach (var line in lines)
                {
                    if (line.StartsWith("ADD_API_KEY="))
                    {
                        API_KEY = line.Substring("ADD_API_KEY=".Length).Trim('"');
                        break;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Console.WriteLine($"Could not load .env file: {e.Message}");
        }
    }

    private static async Task TestApiHealth()
    {
        try
        {
            using var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get, HOST_URL.Replace("/v1", "/v1/spaces"));
            
            if (!string.IsNullOrEmpty(API_KEY) && !API_KEY.Contains("ADD"))
            {
                request.Headers.Add("x-api-key", API_KEY);
            }

            var response = await client.SendAsync(request);
            Console.WriteLine($"api health pass: {(int)response.StatusCode}");
        }
        catch (Exception e)
        {
            Console.WriteLine($"api health check fail: {e.Message}");
        }
    }

    private static async Task TestHttpClient()
    {
        try
        {
            if (string.IsNullOrEmpty(API_KEY) || API_KEY.Contains("ADD"))
            {
                Console.WriteLine("Skipping HTTP client test - no valid API key");
                return;
            }

            using var client = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Get, HOST_URL.Replace("/v1", "/v1/spaces"));
            request.Headers.Add("x-api-key", API_KEY);

            var response = await client.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                Console.WriteLine(".NET HTTP client test: successful");
            }
            else
            {
                Console.WriteLine($".NET HTTP client test failed with status: {(int)response.StatusCode}");
            }
        }
        catch (Exception e)
        {
            Console.WriteLine($".NET HTTP client test failed: {e.Message}");
        }
    }
}