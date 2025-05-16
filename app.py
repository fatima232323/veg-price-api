# app.py
from flask import Flask, jsonify
import os
import json
from scrape_prices import scrape_price_table

app = Flask(__name__)
DATA_FILE = "latest_prices.json"
cached_data = {}

@app.before_first_request
def load_prices():
    global cached_data
    try:
        scrape_price_table(DATA_FILE)
    except Exception as e:
        print("❌ Could not fetch fresh data:", e)

    try:
        with open(DATA_FILE, "r", encoding="utf-8") as f:
            cached_data = json.load(f)
        print("✅ Loaded cached or updated price list")
    except Exception as e:
        print("❌ Failed to load any data:", e)
        cached_data = {"error": "No data available"}

@app.route("/api/prices", methods=["GET"])
def get_prices():
    return jsonify(cached_data)

@app.route("/api/update", methods=["POST"])
def manual_update():
    global cached_data
    try:
        scrape_price_table(DATA_FILE)
        with open(DATA_FILE, "r", encoding="utf-8") as f:
            cached_data = json.load(f)
        return jsonify({"message": "✅ Price list updated"}), 200
    except Exception as e:
        return jsonify({"error": f"❌ Failed to update: {e}"}), 500

if __name__ == "__main__":
    app.run(debug=True)
