from flask import Flask, jsonify
import subprocess
import os
import json

app = Flask(__name__)

@app.route("/api/prices", methods=["GET"])
def get_prices():
    try:
        with open("latest_prices.json", "r", encoding='utf-8') as f:
            data = json.load(f)
        return jsonify(data)
    except Exception as e:
        print("❌ Error reading JSON:", e)
        return jsonify({"error": "Data not available"}), 500

@app.route("/api/update", methods=["POST"])
def update_prices():
    json_path = os.path.join(os.path.dirname(__file__), "latest_prices.json")
    
    # Check if the file exists and is not empty
    if os.path.exists(json_path) and os.path.getsize(json_path) > 10:
        return jsonify({"message": "Price list already up to date"})

    try:
        subprocess.run(["python3", "ocr_prices.py"], check=True)
        return jsonify({"message": "Price list updated"})
    except Exception as e:
        print("❌ OCR script failed:", e)
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
