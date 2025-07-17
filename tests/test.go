package main

import (
	"bufio"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

const HOST_URL = "http://155.138.208.97:8080/v1"

var API_KEY string

func main() {
	loadEnvironment()
	fmt.Printf("Debug: API_KEY = %s\n", API_KEY)

	// Health check
	testApiHealth()

	// API key validation
	if API_KEY == "" || strings.Contains(API_KEY, "ADD") {
		fmt.Println("please add the API key to .env file")
	}

	// Test HTTP API calls
	testHttpClient()

	fmt.Println("Go GoodMem integration test completed")
}

func loadEnvironment() {
	file, err := os.Open(".devcontainer/.env")
	if err != nil {
		fmt.Printf("Could not load .env file: %v\n", err)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "ADD_API_KEY=") {
			API_KEY = strings.Trim(strings.TrimPrefix(line, "ADD_API_KEY="), "\"")
			break
		}
	}
}

func testApiHealth() {
	url := strings.Replace(HOST_URL, "/v1", "/v1/spaces", 1)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Printf("api health check fail: %v\n", err)
		return
	}

	if API_KEY != "" && !strings.Contains(API_KEY, "ADD") {
		req.Header.Set("x-api-key", API_KEY)
	}

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Printf("api health check fail: %v\n", err)
		return
	}
	defer resp.Body.Close()

	fmt.Printf("api health pass: %d\n", resp.StatusCode)
}

func testHttpClient() {
	if API_KEY == "" || strings.Contains(API_KEY, "ADD") {
		fmt.Println("Skipping HTTP client test - no valid API key")
		return
	}

	url := strings.Replace(HOST_URL, "/v1", "/v1/spaces", 1)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Printf("Go HTTP client test failed: %v\n", err)
		return
	}

	req.Header.Set("x-api-key", API_KEY)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Printf("Go HTTP client test failed: %v\n", err)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode == 200 {
		fmt.Println("Go HTTP client test: successful")
	} else {
		fmt.Printf("Go HTTP client test failed with status: %d\n", resp.StatusCode)
	}
}