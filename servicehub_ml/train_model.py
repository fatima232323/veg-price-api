import json
import random
import pandas as pd
import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib

# Define comprehensive attributes for each category
ATTRIBUTES = {
    "Home Assist": {
        "positive": [
            "professional", "punctual", "skilled", "clean", "efficient",
            "reliable", "polite", "experienced", "thorough", "organized"
        ],
        "negative": [
            "unprofessional", "late", "unskilled", "messy", "inefficient",
            "unreliable", "rude", "inexperienced", "careless", "disorganized"
        ]
    },
    "Personal Care": {
        "positive": [
            "professional", "gentle", "skilled", "hygienic", "caring",
            "attentive", "patient", "experienced", "thorough", "polite"
        ],
        "negative": [
            "unprofessional", "rough", "unskilled", "unhygienic", "uncaring",
            "inattentive", "impatient", "inexperienced", "careless", "rude"
        ]
    },
    "Lifestyle": {
        "positive": [
            "professional", "friendly", "skilled", "reliable", "creative",
            "attentive", "experienced", "organized", "polite", "efficient"
        ],
        "negative": [
            "unprofessional", "unfriendly", "unskilled", "unreliable", "uncreative",
            "inattentive", "inexperienced", "disorganized", "rude", "inefficient"
        ]
    },
    "Fresh Cart": {
        "positive": [
            "professional", "fresh", "quality", "punctual", "reliable",
            "attentive", "experienced", "organized", "polite", "efficient"
        ],
        "negative": [
            "unprofessional", "stale", "poor_quality", "late", "unreliable",
            "inattentive", "inexperienced", "disorganized", "rude", "inefficient"
        ]
    },
    "Event Decor": {
        "positive": [
            "professional", "creative", "skilled", "organized", "attentive",
            "experienced", "reliable", "efficient", "polite", "thorough"
        ],
        "negative": [
            "unprofessional", "uncreative", "unskilled", "disorganized", "inattentive",
            "inexperienced", "unreliable", "inefficient", "rude", "careless"
        ]
    }
}

def generate_training_samples():
    samples = []
    
    # Generate positive samples
    for category, attrs in ATTRIBUTES.items():
        # Single attribute samples
        for attr in attrs["positive"]:
            samples.extend([
                f"The {category.lower()} service was {attr}",
                f"The worker was very {attr}",
                f"I found the service to be {attr}",
                f"The {category.lower()} provider was {attr}",
                f"Extremely {attr} service"
            ])
        
        # Multiple attribute samples
        for i in range(len(attrs["positive"]) - 1):
            attr1 = attrs["positive"][i]
            attr2 = attrs["positive"][i + 1]
            samples.extend([
                f"The service was both {attr1} and {attr2}",
                f"Very {attr1} and {attr2} work",
                f"Found them to be {attr1} and {attr2}"
            ])
    
    # Generate negative samples
    for category, attrs in ATTRIBUTES.items():
        # Single attribute samples
        for attr in attrs["negative"]:
            samples.extend([
                f"The {category.lower()} service was {attr}",
                f"The worker was very {attr}",
                f"I found the service to be {attr}",
                f"The {category.lower()} provider was {attr}",
                f"Extremely {attr} service"
            ])
        
        # Multiple attribute samples
        for i in range(len(attrs["negative"]) - 1):
            attr1 = attrs["negative"][i]
            attr2 = attrs["negative"][i + 1]
            samples.extend([
                f"The service was both {attr1} and {attr2}",
                f"Very {attr1} and {attr2} work",
                f"Found them to be {attr1} and {attr2}"
            ])
    
    return samples

# Generate training data
training_samples = generate_training_samples()
data = {
    "text": training_samples,
    "sentiment": ["positive"] * (len(training_samples) // 2) + ["negative"] * (len(training_samples) // 2)
}

df = pd.DataFrame(data)

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    df["text"], df["sentiment"], test_size=0.2, random_state=42
)

# Create and train pipeline with enhanced parameters
pipeline = Pipeline([
    ("tfidf", TfidfVectorizer(
        max_features=10000,
        ngram_range=(1, 3),
        stop_words='english',
        min_df=2,
        max_df=0.95
    )),
    ("clf", LogisticRegression(
        max_iter=2000,
        class_weight='balanced',
        C=0.1,
        solver='liblinear',
        penalty='l2'
    ))
])

# Train
pipeline.fit(X_train, y_train)

# Evaluate
train_score = pipeline.score(X_train, y_train)
test_score = pipeline.score(X_test, y_test)
print(f"Training accuracy: {train_score:.4f}")
print(f"Testing accuracy: {test_score:.4f}")

# Save model and attributes in a single dictionary
model_data = {
    "model": pipeline,
    "attributes": ATTRIBUTES
}

# Save the combined model data
joblib.dump(model_data, "sentiment_model.pkl")

print("✅ Model trained and saved successfully")
