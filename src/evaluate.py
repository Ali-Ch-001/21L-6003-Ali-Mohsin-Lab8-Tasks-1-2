"""
Model Evaluation Stage
Evaluates the trained model on test data
"""
import argparse
import os
import joblib
import numpy as np
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import json
import yaml

def load_params():
    with open("params.yaml") as f:
        return yaml.safe_load(f)

def evaluate_model(data_dir, model_path, out_path):
    """Evaluate the model and save metrics"""
    print(f"📊 Evaluating model...")
    
    # Load test data
    X_test = np.load(os.path.join(data_dir, "X_test.npy"))
    y_test = np.load(os.path.join(data_dir, "y_test.npy"))
    
    print(f"   Test data shape: {X_test.shape}")
    
    # Load model
    model = joblib.load(model_path)
    
    # Make predictions
    y_pred = model.predict(X_test)
    
    # Calculate metrics
    rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    # Calculate MAPE (Mean Absolute Percentage Error)
    mape = np.mean(np.abs((y_test - y_pred) / y_test)) * 100
    
    metrics = {
        "rmse": float(rmse),
        "mae": float(mae),
        "r2_score": float(r2),
        "mape": float(mape)
    }
    
    # Print metrics
    print(f"\n   📈 Model Performance:")
    print(f"      RMSE:     {rmse:,.2f} PKR")
    print(f"      MAE:      {mae:,.2f} PKR")
    print(f"      R² Score: {r2:.4f}")
    print(f"      MAPE:     {mape:.2f}%")
    
    # Save metrics
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w") as f:
        json.dump(metrics, f, indent=2)
    
    print(f"\n✅ Metrics saved to {out_path}")
    
    # Sample predictions
    print(f"\n   🔍 Sample Predictions:")
    for i in range(min(5, len(y_test))):
        print(f"      Actual: {y_test[i]:,.0f} PKR | Predicted: {y_pred[i]:,.0f} PKR | Error: {abs(y_test[i]-y_pred[i]):,.0f} PKR")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data_dir", type=str, default="data")
    parser.add_argument("--model", type=str, required=True)
    parser.add_argument("--out", type=str, default="metrics/eval.json")
    args = parser.parse_args()
    
    evaluate_model(args.data_dir, args.model, args.out)
    
    print("✅ Model evaluation complete!")
