from goodmem_client.api import APIKeysApi, SpacesApi, MemoriesApi
from goodmem_client.configuration import Configuration
from goodmem_client.api_client import ApiClient

import requests
import psycopg2
import openai
import sys
import os 
from dotenv import load_dotenv

load_dotenv(dotenv_path='../.devcontainer/.env')

# Configuration - update with your GoodMem server details
HOST_URL = "http://155.138.208.97:8080/v1"  # Replace with your server URL
API_KEY = os.getenv("ADD_API_KEY")
print(f"Debug: API_KEY = {API_KEY}")

#health checks: 

#API endpoints

try:
    # Test the main API endpoint since /health doesn't exist
    headers = {"x-api-key": API_KEY} if API_KEY and "ADD" not in API_KEY else {}
    response = requests.get(HOST_URL.replace("/v1", "/v1/spaces"), headers=headers)
    print(f"api health pass: {response.status_code}")
except Exception as e:
    print(f"api health check fail: {e}")


#The python SDK

if not API_KEY or "ADD" in API_KEY: 
    print("please add the API key to .env file")


try:
    
    configuration = Configuration()
    configuration.host = HOST_URL.replace("/v1", "")
    api_client = ApiClient(configuration=configuration)
    
    if API_KEY and "ADD" not in API_KEY:
        api_client.default_headers["x-api-key"] = API_KEY
    
    spaces_api_instance = SpacesApi(api_client)
    response = spaces_api_instance.list_spaces()

    print("works")
    if API_KEY and "ADD" not in API_KEY:
        print(f"found: {len(response.spaces)} spaces.")
except Exception as e: 
    print(f"SDK test failed: {e}")
    print(f"Error type: {type(e)}")


#open ai integration. 

try:
    from openai import OpenAI
    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    response = client.embeddings.create(
        input="test text",
        model="text-embedding-3-small"
    )
    print("open ai embedding = success. ")
    
    # Test GoodMem with OpenAI embeddings
    # First get the first available space
    spaces_response = spaces_api_instance.list_spaces()
    if spaces_response.spaces and len(spaces_response.spaces) > 0:
        space = spaces_response.spaces[0]
        space_id = space.space_id
        
        memories_api = MemoriesApi(api_client)
        response = memories_api.create_memory({
            "original_content": "test memory w open ai. ",
            "contentType": "text/plain",
            "spaceId": space_id
        })
    else:
        print("No spaces available for memory test")
    print("goodmem, open ai = successful")
except Exception as e:
    print(f"OpenAI test failed: {e}")


