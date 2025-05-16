# scrape_prices.py
import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime

def scrape_price_table(save_path="latest_prices.json"):
    url = "https://timesofkarachi.pk/commissioner-rate-list/"
    response = requests.get(url, timeout=10)
    response.raise_for_status()  # Will throw if website is down

    soup = BeautifulSoup(response.text, "html.parser")
    table = soup.find("table")
    if not table:
        raise Exception("❌ Table not found on page")

    rows = table.find_all("tr")[1:]  # Skip header
    items = []
    for row in rows:
        cols = row.find_all("td")
        if len(cols) >= 5:
            items.append({
                "name_en": cols[0].text.strip(),
                "bazaar_rate": cols[1].text.strip(),
                "mandi_rate": cols[2].text.strip(),
                "auction_rate": cols[3].text.strip(),
                "name_ur": cols[4].text.strip()
            })

    data = {
        "last_updated": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "items": items
    }

    with open(save_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print("✅ Scraped and saved latest prices")
