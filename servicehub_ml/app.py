from flask import Flask, request, jsonify
import joblib
import json
from sklearn.feature_extraction.text import TfidfVectorizer

# Load the model and vectorizer
model = joblib.load("review_sentiment_model.pkl")
vectorizer = joblib.load("tfidf_vectorizer.pkl")  # If you saved it separately

app = Flask(__name__)

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    review = data.get("review", "")
    
    if not review:
        return jsonify({"error": "No review provided"}), 400

    # Transform and predict
    review_vector = vectorizer.transform([review])
    prediction = model.predict(review_vector)[0]
    
    return jsonify({"sentiment": prediction})

if __name__ == "__main__":
    app.run(debug=True)
