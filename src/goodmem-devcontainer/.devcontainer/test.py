import os

import requests
from dotenv import load_dotenv
from goodmem_client.api import APIKeysApi, MemoriesApi, SpacesApi
from goodmem_client.api_client import ApiClient
from goodmem_client.configuration import Configuration

# --- Load environment variables ---
print("\nLoading environment variables...")
load_dotenv(dotenv_path=".env")

HOST_URL = "http://155.138.208.97:8080/v1"
API_KEY = os.getenv("ADD_API_KEY")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

print(
    f"API_KEY loaded: {'FOUND' if API_KEY and 'ADD' not in API_KEY else '❌ MISSING or PLACEHOLDER'}"
)
print(
    f"OPENAI_API_KEY loaded: {'FOUND' if OPENAI_API_KEY and 'your-openai-key' not in OPENAI_API_KEY else '❌ MISSING or PLACEHOLDER'}"
)

# --- Test direct HTTP access ---
print("\nTesting raw HTTP API...")

try:
    headers = {"x-api-key": API_KEY} if API_KEY and "ADD" not in API_KEY else {}
    response = requests.get(HOST_URL.replace("/v1", "/v1/spaces"), headers=headers)
    print(f"Response status: {response.status_code}")
    if response.ok:
        print("API endpoint is reachable.")
    else:
        print(f"API responded but with error: {response.text}")
except Exception as e:
    print(f"API request failed: {e}")

# --- Setup API Client ---
api_client = None
spaces_api_instance = None

if API_KEY and "ADD" not in API_KEY:
    configuration = Configuration()
    configuration.host = HOST_URL.replace("/v1", "")
    api_client = ApiClient(configuration=configuration)
    api_client.default_headers["x-api-key"] = API_KEY
    spaces_api_instance = SpacesApi(api_client)
else:
    print("Cannot initialize SDK — API key missing.")

# --- Test Python SDK: List Spaces ---
print("\nTesting GoodMem Python SDK...")

if not spaces_api_instance:
    print("Skipping SDK space listing due to missing client.")
else:
    try:
        print("Fetching spaces via SDK...")
        response = spaces_api_instance.list_spaces()
        print(f"SDK list_spaces succeeded with {len(response.spaces)} space(s).")
        for space in response.spaces:
            name = getattr(space, "name", "(no name)")
            labels = getattr(space, "labels", {})
            print(f"   - ID: {space.space_id}, Name: {name}, Labels: {labels}")
    except Exception as e:
        print(f"SDK test failed: {e}")

# --- Test OpenAI Embeddings + GoodMem Integration ---
print("\nTesting OpenAI Embeddings and GoodMem integration...")

if not OPENAI_API_KEY or "your-openai-key" in OPENAI_API_KEY:
    print("Skipping OpenAI test due to missing key.")
elif not api_client:
    print("Cannot run memory test — SDK client not initialized.")
else:
    try:
        from openai import OpenAI

        client = OpenAI(api_key=OPENAI_API_KEY)
        print("Creating embedding with OpenAI...")
        embedding_response = client.embeddings.create(
            input="test text", model="text-embedding-3-small"
        )
        print("OpenAI embedding succeeded.")

        print("Creating memory in GoodMem using embedding...")
        spaces_response = spaces_api_instance.list_spaces()
        if spaces_response.spaces:
            space_id = spaces_response.spaces[0].space_id
            memories_api = MemoriesApi(api_client)
            memory = {
                "original_content": "test memory w open ai.",
                "contentType": "text/plain",
                "spaceId": space_id,
            }
            memory_response = memories_api.create_memory(memory)
            print(f"Memory created. ID: {memory_response.memory_id}")
        else:
            print("No spaces available for memory creation.")

    except Exception as e:
        print(f"OpenAI + GoodMem integration test failed: {e}")
