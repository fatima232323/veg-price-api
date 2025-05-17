from flask import Flask, jsonify, send_file
from scrape_prices import scrape_price_table
import os

app = Flask(__name__)
cached_data = {}

# 👇 Automatically generate file when the app starts
try:
    cached_data = scrape_price_table()
    print("✅ latest_prices.json generated on startup.")
except Exception as e:
    print(f"❌ Failed to generate file: {e}")

@app.route("/api/prices")
def get_prices():
    return jsonify(cached_data)

@app.route("/latest_prices.json")
def serve_latest_prices_file():
    path = "latest_prices.json"
    if os.path.exists(path):
        return send_file(path, mimetype="application/json")
    return jsonify({"error": "File not found"}), 404

if __name__ == "__main__":
    app.run(debug=True)
