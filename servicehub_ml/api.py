from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import json
import os
from collections import defaultdict
import traceback

app = Flask(__name__)
# Configure CORS to allow requests from any origin
CORS(app, resources={
    r"/*": {
        "origins": "*",
        "methods": ["GET", "POST", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization", "Access-Control-Allow-Origin"]
    }
})

# Load the model and attributes
try:
    model_data = joblib.load("sentiment_model.pkl")
    pipeline = model_data["model"]
    ATTRIBUTES = model_data["attributes"]
    print("Model and attributes loaded successfully!")
except Exception as e:
    print(f"Error loading model or attributes: {str(e)}")
    pipeline = None
    ATTRIBUTES = {}

# Store worker ratings
worker_ratings = defaultdict(lambda: {
    "total_reviews": 0,
    "positive_attributes": defaultdict(int),
    "negative_attributes": defaultdict(int),
    "score": 0.0
})

@app.route('/health', methods=['GET'])
def health_check():
    response = jsonify({
        'status': 'healthy',
        'model_loaded': pipeline is not None
    })
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response

@app.route('/analyze_sentiment', methods=['POST', 'OPTIONS'])
def analyze_sentiment():
    # Handle preflight request
    if request.method == 'OPTIONS':
        response = jsonify({'status': 'ok'})
        response.headers.add('Access-Control-Allow-Origin', '*')
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
        response.headers.add('Access-Control-Allow-Methods', 'POST')
        return response

    try:
        # Validate Content-Type header
        if not request.is_json:
            return jsonify({'error': 'Content-Type must be application/json'}), 415

        if pipeline is None:
            return jsonify({'error': 'Model not loaded'}), 500

        # Get the request data
        data = request.get_json(silent=True)
        if not data:
            return jsonify({'error': 'Invalid JSON or no data provided'}), 400
            
        text = data.get('text')
        if not text:
            return jsonify({'error': 'No text provided'}), 400
            
        # Make worker_id and category optional for testing
        worker_id = data.get('worker_id', 'test_worker')
        category = data.get('category', 'Home Assist')
            
        # Print received text for debugging
        print(f"Received text for analysis: {text}")
            
        # Predict sentiment
        sentiment = pipeline.predict([text])[0]
        print(f"Predicted sentiment: {sentiment}")
        
        # Update worker ratings only if worker_id is provided
        if worker_id != 'test_worker':
            worker = worker_ratings[worker_id]
            worker["total_reviews"] += 1

            # Check for attributes in the text
            text_lower = text.lower()
            category_attributes = ATTRIBUTES.get(category, {"positive": [], "negative": []})

            # Check positive attributes
            for attr in category_attributes["positive"]:
                if attr in text_lower:
                    worker["positive_attributes"][attr] += 1

            # Check negative attributes
            for attr in category_attributes["negative"]:
                if attr in text_lower:
                    worker["negative_attributes"][attr] += 1

            # Calculate score
            total_positive = sum(worker["positive_attributes"].values())
            total_negative = sum(worker["negative_attributes"].values())
            total_attributes = total_positive + total_negative

            if total_attributes > 0:
                worker["score"] = total_positive / total_attributes
            else:
                worker["score"] = 0.5  # Default score for no attributes

            # Create response with worker data
            response = jsonify({
                'sentiment': sentiment,
                'worker_id': worker_id,
                'score': worker["score"]
            })
        else:
            # Create response without worker data
            response = jsonify({
                'sentiment': sentiment
            })
        
        # Add CORS headers
        response.headers.add('Access-Control-Allow-Origin', '*')
        return response
        
    except Exception as e:
        print(f"Error in sentiment analysis: {str(e)}")
        print(traceback.format_exc())
        return jsonify({
            'error': f'Server error: {str(e)}',
            'status': 'error'
        }), 500

@app.route('/get_worker_rating/<worker_id>', methods=['GET'])
def get_worker_rating(worker_id):
    if worker_id not in worker_ratings:
        return jsonify({"error": "Worker not found"}), 404

    worker = worker_ratings[worker_id]
    return jsonify({
        "worker_id": worker_id,
        "total_reviews": worker["total_reviews"],
        "positive_attributes": dict(worker["positive_attributes"]),
        "negative_attributes": dict(worker["negative_attributes"]),
        "score": worker["score"]
    })

@app.route('/get_top_workers/<category>', methods=['GET'])
def get_top_workers(category):
    # Filter workers by category and sort by score
    category_workers = [
        {
            "worker_id": worker_id,
            "total_reviews": data["total_reviews"],
            "positive_attributes": dict(data["positive_attributes"]),
            "negative_attributes": dict(data["negative_attributes"]),
            "score": data["score"]
        }
        for worker_id, data in worker_ratings.items()
        if data["total_reviews"] > 0
    ]
    
    # Sort by score in descending order
    category_workers.sort(key=lambda x: x["score"], reverse=True)
    
    return jsonify({
        "category": category,
        "top_workers": category_workers
    })

if __name__ == '__main__':
    print("Starting Flask server...")
    # Enable debug mode for better error messages
    app.run(host='0.0.0.0', port=5000, debug=True) 