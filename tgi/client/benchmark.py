import json
from datetime import datetime, timezone

import requests
from prometheus_api_client import PrometheusConnect

HOST = "155.248.202.209"
TGI_ENDPOINT_URL = f"http://{HOST}:8080/generate"
PROM_ENDPOINT_URL = f"http://{HOST}:9090"


def send_request(
    endpoint_url: str,
    prompt: str,
    max_new_tokens: int
) -> dict:
    response = requests.post(
        url=endpoint_url,
        json={
            "inputs": prompt,
            "parameters": {
                "max_new_tokens": max_new_tokens,
                "details": True,
                "seed": 42,
            },
        },
        headers={"Content-Type": "application/json"}
    )
    response.raise_for_status()
    return response.json()


if __name__ == "__main__":

    started_at = datetime.now(timezone.utc)
    for _ in range(10):
        send_request(
            endpoint_url=TGI_ENDPOINT_URL,
            prompt="What is Deep Learning?",
            max_new_tokens=64
        )
    ended_at = datetime.now(timezone.utc)

    prom = PrometheusConnect(url=PROM_ENDPOINT_URL)
    metric = prom.get_metric_range_data(
        "nvidia_smi_power_draw_watts",
        start_time=started_at,
        end_time=ended_at
    )
    print(metric)
    power_values = metric[0]["values"]

    for pv in power_values:
        print(datetime.fromtimestamp(pv[0], timezone.utc), pv[1])

