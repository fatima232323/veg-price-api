import requests
from PIL import Image
from io import BytesIO
import pytesseract
import json
import re
import os
import urllib3
from pdf2image import convert_from_bytes  # ✅ Correct import

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Comment this out when running on Render (Render has no Tesseract by default)
# pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

def run_ocr():
    url = "https://commissionerkarachi.gos.pk/uploads/pricelist/1747117937_7ca8a6f3f517988fb862.jpg"
    print("🔗 Fetching file:", url)

    headers = {
        "User-Agent": "Mozilla/5.0"
    }

    response = requests.get(url, headers=headers, verify=False)
    content_type = response.headers.get("Content-Type", "")
    print("📦 File type:", content_type)

    text = ""

    try:
        if "pdf" in content_type:
            images = convert_from_bytes(response.content)
            for img in images:
                text += pytesseract.image_to_string(img, lang='urd+eng')
        elif "image" in content_type:
            image = Image.open(BytesIO(response.content))
            text = pytesseract.image_to_string(image, lang='urd+eng')
        else:
            print("❌ Unsupported file type.")
            return
    except Exception as e:
        print("❌ Failed to process file:", e)
        return

    print("📝 Extracted text preview:")
    print(text[:500])

    prices = {}
    for line in text.splitlines():
        line = line.strip()
        if re.search(r"\d", line):
            parts = line.split()
            digits = [p for p in parts if re.match(r"\d+", p)]
            if digits:
                try:
                    price = int(digits[-1])
                    name = " ".join(p for p in parts if not re.match(r"\d+", p))
                    if name:
                        prices[name.strip()] = price
                except:
                    continue

    # ✅ Save with correct absolute path
    json_path = os.path.join(os.path.dirname(__file__), "latest_prices.json")
    print("💾 Saving to:", json_path)  # ✅ Add this
    with open(json_path, "w", encoding='utf-8') as f:
        json.dump(prices, f, ensure_ascii=False, indent=2)

    print("✅ Prices saved to latest_prices.json")

if __name__ == "__main__":
    run_ocr()
