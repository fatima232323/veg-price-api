import requests
from bs4 import BeautifulSoup
import json
from datetime import datetime

BASE_URL = "https://timesofkarachi.pk"

def get_latest_vegetable_url():
    return get_latest_url("vegetable price list")

def get_latest_fruit_url():
    return get_latest_url("fruit price list")

def get_latest_url(keyword):
    url = BASE_URL + "/commissioner-rate-list/"
    r = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'})
    soup = BeautifulSoup(r.text, "html.parser")

    all_links = soup.find_all("a", href=True)
    for link in all_links:
        text = link.text.lower()
        href = link["href"]

        if keyword in text:
            return href if href.startswith("http") else BASE_URL + href
    return None

def scrape_price_table(save_path="vegetable_prices.json"):
    veg_url = get_latest_vegetable_url()
    return scrape_table_from_url(veg_url, save_path)

def scrape_fruit_prices(save_path="fruit_prices.json"):
    fruit_url = get_latest_fruit_url()
    return scrape_table_from_url(fruit_url, save_path)

def scrape_table_from_url(url, save_path):
    if not url:
        raise Exception("No relevant post found.")

    r = requests.get(url)
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
        "source": url,
        "items": items
    }

    with open(save_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    return data
