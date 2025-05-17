import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime

BASE_URL = "https://timesofkarachi.pk"

def get_latest_vegetable_url():
    url = BASE_URL + "/commissioner-rate-list/"
    r = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'})
    soup = BeautifulSoup(r.text, "html.parser")

    all_links = soup.find_all("a", href=True)

    # Filter for links that look like "karachi-vegetable-price-list"
    for link in all_links:
        text = link.text.lower()
        href = link["href"]

        if "karachi vegetable price list" in text or "vegetable price list" in text:
            return href if href.startswith("http") else BASE_URL + href

    return None


def scrape_price_table(save_path="vegetable_prices.json"):
    veg_url = get_latest_vegetable_url()
    if not veg_url:
        raise Exception("No vegetable price post found.")

    r = requests.get(veg_url)
    soup = BeautifulSoup(r.text, "html.parser")

    table = soup.find("table")
    if not table:
        raise Exception("❌ Could not find a table on the page")

    rows = table.find_all("tr")[1:]

    items = []
    for row in rows:
        cols = row.find_all("td")
        if len(cols) >= 4:
            item = {
                "name": cols[0].get_text(strip=True),
                "bazaar_rate": cols[1].get_text(strip=True),
                "mandi_rate": cols[2].get_text(strip=True),
                "auction_rate": cols[3].get_text(strip=True),
            }
            items.append(item)

    data = {
        "last_updated": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "source": veg_url,
        "items": items
    }

    with open(save_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    return data
