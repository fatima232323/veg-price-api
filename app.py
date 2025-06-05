from flask import Flask, jsonify, send_file
from scrape_prices import scrape_price_table, scrape_fruit_prices
import os

app = Flask(__name__)
cached_veg_data = {}
cached_fruit_data = {}

# 👇 Generate both vegetable and fruit data on startup
try:
    cached_veg_data = scrape_price_table()
    print("✅ vegetable_prices.json generated on startup.")
except Exception as e:
    print(f"❌ Failed to generate vegetable prices: {e}")

try:
    cached_fruit_data = scrape_fruit_prices()
    print("✅ fruit_prices.json generated on startup.")
except Exception as e:
    print(f"❌ Failed to generate fruit prices: {e}")

@app.route("/api/prices")
def get_vegetable_prices():
    return jsonify(cached_veg_data)

@app.route("/api/fruit-prices")
def get_fruit_prices():
    return jsonify(cached_fruit_data)

@app.route("/latest_prices.json")
def serve_vegetable_prices_file():
    path = "vegetable_prices.json"
    if os.path.exists(path):
        return send_file(path, mimetype="application/json")
    return jsonify({"error": "File not found"}), 404

@app.route("/fruit_prices.json")
def serve_fruit_prices_file():
    path = "fruit_prices.json"
    if os.path.exists(path):
        return send_file(path, mimetype="application/json")
    return jsonify({"error": "File not found"}), 404

if __name__ == "__main__":
    app.run(debug=True)
