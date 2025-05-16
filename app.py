from flask import Flask, jsonify
from scrape_prices import scrape_price_table
import json

app = Flask(__name__)
cached_data = {}

@app.route("/api/prices", methods=["GET"])
def get_prices():
    global cached_data
    if not cached_data:
        try:
            cached_data = scrape_price_table()
        except Exception as e:
            return jsonify({"error": str(e)})
    return jsonify(cached_data)

@app.route("/api/update", methods=["POST"])
def update_prices():
    global cached_data
    try:
        cached_data = scrape_price_table()
        return jsonify({"message": "✅ Price list updated"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
