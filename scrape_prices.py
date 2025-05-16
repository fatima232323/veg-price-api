import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime

BASE_URL = "https://timesofkarachi.pk"

def get_latest_vegetable_url():
    url = BASE_URL + "/commissioner-rate-list/"
    r = requests.get(url)
    soup = BeautifulSoup(r.text, "html.parser")

    for link in soup.find_all("a", href=True):
        if "vegetable" in link.text.lower():
            href = link["href"]
            return href if href.startswith("http") else BASE_URL + href
    return None


def scrape_price_table(save_path="latest_prices.json"):
    veg_url = get_latest_vegetable_url()
    if not veg_url:
        raise Exception("No vegetable price post found.")

    r = requests.get(veg_url)
    soup = BeautifulSoup(r.text, "html.parser")

    # This may vary slightly depending on their page layout
    text_block = soup.get_text(separator="\n")

    lines = text_block.splitlines()
    items = []
    for line in lines:
        parts = line.strip().rsplit(" ", 1)
        if len(parts) == 2 and parts[1].isdigit():
            items.append({
                "name": parts[0].strip(),
                "price": parts[1].strip()
            })

    data = {
        "last_updated": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "source": veg_url,
        "items": items
    }

    with open(save_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    return data
