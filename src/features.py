"""
Feature Engineering Stage
Handles feature encoding and train-test split
"""
import argparse
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import yaml
import os
import joblib

def load_params():
    with open("params.yaml") as f:
        return yaml.safe_load(f)

def engineer_features(in_csv, out_dir, test_size, random_state):
    """Engineer features and split data"""
    print(f"🔧 Engineering features from {in_csv}...")
    
    # Load data
    df = pd.read_csv(in_csv)
    params = load_params()['features']
    
    target_col = params['target_column']
    cat_features = params['categorical_features']
    num_features = params['numerical_features']
    
    # Separate features and target
    X = df[cat_features + num_features].copy()
    y = df[target_col].values
    
    print(f"   Features shape: {X.shape}")
    print(f"   Target shape: {y.shape}")
    
    # Encode categorical features
    label_encoders = {}
    for col in cat_features:
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col])
        label_encoders[col] = le
        print(f"   Encoded {col}: {len(le.classes_)} classes")
    
    # Convert to numpy
    X = X.values
    
    # Train-test split
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_size, random_state=random_state
    )
    
    print(f"   Train set: {X_train.shape}")
    print(f"   Test set: {X_test.shape}")
    
    # Save data
    os.makedirs(out_dir, exist_ok=True)
    np.save(os.path.join(out_dir, "X_train.npy"), X_train)
    np.save(os.path.join(out_dir, "X_test.npy"), X_test)
    np.save(os.path.join(out_dir, "y_train.npy"), y_train)
    np.save(os.path.join(out_dir, "y_test.npy"), y_test)
    
    # Save encoders and feature info for deployment
    os.makedirs("models", exist_ok=True)
    joblib.dump(label_encoders, "models/label_encoders.pkl")
    joblib.dump(cat_features + num_features, "models/model_features.pkl")
    
    # Create feature field map
    feature_field_map = {feat: feat for feat in cat_features + num_features}
    joblib.dump(feature_field_map, "models/feature_field_map.pkl")
    
    print(f"✅ Features saved to {out_dir}")
    print(f"✅ Encoders saved to models/")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--in_csv", type=str, required=True)
    parser.add_argument("--out_dir", type=str, default="data")
    parser.add_argument("--test_size", type=float, default=0.2)
    parser.add_argument("--random_state", type=int, default=42)
    args = parser.parse_args()
    
    engineer_features(
        in_csv=args.in_csv,
        out_dir=args.out_dir,
        test_size=args.test_size,
        random_state=args.random_state
    )
    
    print("✅ Feature engineering complete!")
