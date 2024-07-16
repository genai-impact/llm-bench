import json

import requests


HOST = "pikachu:8080"


if __name__ == "__main__":
    response = requests.post(
        url=f"http://{HOST}/generate",
        json={
            "inputs": "What is Deep Learning?",
            "parameters": {
                "max_new_tokens": 40,
                "details": True,
                "seed": 42,
            },
        },
        headers={"Content-Type": "application/json"}
    )
    print("Response status:", response.status_code)
    print("Content:")
    data = response.json()
    print(json.dumps(data, indent=4))
