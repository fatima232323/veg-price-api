from flask import Flask, jsonify
import subprocess
import json
import os

app = Flask(__name__)

@app.route("/api/prices", methods=["GET"])
def get_prices():
    try:
        json_path = os.path.join(os.path.dirname(__file__), "latest_prices.json")
        with open(json_path, "r", encoding='utf-8') as f:
            data = json.load(f)
        return jsonify(data)
    except Exception as e:
        print("❌ Error reading JSON:", e)
        return jsonify({"error": "Data not available"}), 500

@app.route("/api/update", methods=["POST"])
def update_prices():
    try:
        subprocess.run(["python3", "ocr_prices.py"], check=True)
        return jsonify({"message": "Price list updated"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
