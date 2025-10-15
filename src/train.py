"""
Model Training Stage
Trains the house price prediction model
"""
import argparse
import os
import joblib
import numpy as np
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.linear_model import LinearRegression
import yaml

def load_params():
    with open("params.yaml") as f:
        return yaml.safe_load(f)

def get_model(params):
    """Create model based on configuration"""
    model_type = params.get("model_type", "RandomForest")
    random_state = params["random_state"]
    
    if model_type == "RandomForest":
        return RandomForestRegressor(
            n_estimators=params["n_estimators"],
            max_depth=params["max_depth"],
            min_samples_split=params["min_samples_split"],
            random_state=random_state,
            n_jobs=-1
        )
    elif model_type == "GradientBoosting":
        return GradientBoostingRegressor(
            n_estimators=params["n_estimators"],
            max_depth=params["max_depth"],
            random_state=random_state
        )
    elif model_type == "LinearRegression":
        return LinearRegression()
    else:
        raise ValueError(f"Unknown model type: {model_type}")

def train_model(data_dir, model_out):
    """Train the model"""
    print(f"🤖 Training model...")
    
    params = load_params()["train"]
    
    # Load data
    X_train = np.load(os.path.join(data_dir, "X_train.npy"))
    y_train = np.load(os.path.join(data_dir, "y_train.npy"))
    
    print(f"   Training data shape: {X_train.shape}")
    print(f"   Model type: {params.get('model_type', 'RandomForest')}")
    
    # Create and train model
    model = get_model(params)
    model.fit(X_train, y_train)
    
    # Save model
    os.makedirs(os.path.dirname(model_out) if os.path.dirname(model_out) else ".", exist_ok=True)
    joblib.dump(model, model_out)
    
    # Also save to models directory for Flask app
    os.makedirs("models", exist_ok=True)
    joblib.dump(model, "models/house_price_model.pkl")
    
    print(f"✅ Model saved to {model_out}")
    print(f"✅ Model also saved to models/house_price_model.pkl")
    
    # Print feature importances if available
    if hasattr(model, 'feature_importances_'):
        print(f"\n   Top 5 Feature Importances:")
        importances = model.feature_importances_
        indices = np.argsort(importances)[::-1][:5]
        for i, idx in enumerate(indices, 1):
            print(f"      {i}. Feature {idx}: {importances[idx]:.4f}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data_dir", type=str, default="data")
    parser.add_argument("--model_out", type=str, default="model.pkl")
    args = parser.parse_args()
    
    train_model(args.data_dir, args.model_out)
    
    print("✅ Model training complete!")
