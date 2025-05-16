from flask import Flask, jsonify
import os
import json
from scrape_prices import scrape_price_table

app = Flask(__name__)
DATA_FILE = "latest_prices.json"
cached_data = {}

# Load data only once on first access
def ensure_prices_loaded():
    global cached_data
    if not cached_data:
        try:
            scrape_price_table(DATA_FILE)
            print("✅ Fetched fresh data.")
        except Exception as e:
            print("⚠️ Failed to fetch fresh data:", e)

        try:
            with open(DATA_FILE, "r", encoding="utf-8") as f:
                cached_data.update(json.load(f))
                print("✅ Loaded price list from file.")
        except Exception as e:
            print("❌ Failed to load local file:", e)
            cached_data.update({"error": "No data available"})

@app.route("/api/prices", methods=["GET"])
def get_prices():
    ensure_prices_loaded()
    return jsonify(cached_data)

@app.route("/api/update", methods=["POST"])
def update_prices():
    global cached_data
    try:
        scrape_price_table(DATA_FILE)
        with open(DATA_FILE, "r", encoding="utf-8") as f:
            cached_data = json.load(f)
        return jsonify({"message": "✅ Price list updated"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
