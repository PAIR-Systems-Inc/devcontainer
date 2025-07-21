const fs = require('fs');
const https = require('http');

const HOST_URL = "http://155.138.208.97:8080/v1";
let API_KEY;

function loadEnvironment() {
    try {
        const envContent = fs.readFileSync('.env', 'utf8');
        const lines = envContent.split('\n');
        
        for (const line of lines) {
            if (line.startsWith('ADD_API_KEY=')) {
                API_KEY = line.substring('ADD_API_KEY='.length).replace(/"/g, '');
                break;
            }
        }
    } catch (error) {
        console.log(`Could not load .env file: ${error.message}`);
    }
}

function testApiHealth() {
    return new Promise((resolve) => {
        const url = HOST_URL.replace('/v1', '/v1/spaces');
        const urlObj = new URL(url);
        
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port,
            path: urlObj.pathname,
            method: 'GET',
            headers: {}
        };

        if (API_KEY && !API_KEY.includes('ADD')) {
            options.headers['x-api-key'] = API_KEY;
        }

        const req = https.request(options, (res) => {
            console.log(`api health pass: ${res.statusCode}`);
            resolve();
        });

        req.on('error', (error) => {
            console.log(`api health check fail: ${error.message}`);
            resolve();
        });

        req.end();
    });
}

function testHttpClient() {
    return new Promise((resolve) => {
        if (!API_KEY || API_KEY.includes('ADD')) {
            console.log('Skipping HTTP client test - no valid API key');
            resolve();
            return;
        }

        const url = HOST_URL.replace('/v1', '/v1/spaces');
        const urlObj = new URL(url);
        
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port,
            path: urlObj.pathname,
            method: 'GET',
            headers: {
                'x-api-key': API_KEY
            }
        };

        const req = https.request(options, (res) => {
            if (res.statusCode === 200) {
                console.log('Node.js HTTP client test: successful');
            } else {
                console.log(`Node.js HTTP client test failed with status: ${res.statusCode}`);
            }
            resolve();
        });

        req.on('error', (error) => {
            console.log(`Node.js HTTP client test failed: ${error.message}`);
            resolve();
        });

        req.end();
    });
}

async function main() {
    loadEnvironment();
    console.log(`Debug: API_KEY = ${API_KEY}`);

    // Health check
    await testApiHealth();

    // API key validation
    if (!API_KEY || API_KEY.includes('ADD')) {
        console.log('please add the API key to .env file');
    }

    // Test HTTP API calls
    await testHttpClient();

    console.log('Node.js GoodMem integration test completed');
}

main().catch(console.error);