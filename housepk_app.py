# app.py
import os
import joblib
import numpy as np
from flask import Flask, render_template, request, redirect, url_for, jsonify

APP_ROOT = os.path.dirname(__file__)
MODEL_DIR = os.path.join(APP_ROOT, "models")

# Developer 2: Added API configuration
API_VERSION = "v1"
API_PREFIX = "/api/v1"

# Load artifacts
model = joblib.load(os.path.join(MODEL_DIR, "house_price_model.pkl"))
feature_list = joblib.load(os.path.join(MODEL_DIR, "model_features.pkl"))  # ordered
label_encoders = joblib.load(os.path.join(MODEL_DIR, "label_encoders.pkl"))
feature_field_map = joblib.load(os.path.join(MODEL_DIR, "feature_field_map.pkl"))

# build metadata for template
feature_meta = []
for feat in feature_list:
    field_name = feature_field_map[feat]
    if feat in label_encoders:
        # categorical -> dropdown
        classes = [str(x) for x in label_encoders[feat].classes_.tolist()]
        feature_meta.append({
            "name": feat,
            "field": field_name,
            "type": "categorical",
            "options": classes
        })
    else:
        # numeric -> number input
        feature_meta.append({
            "name": feat,
            "field": field_name,
            "type": "numeric",
            "options": None
        })

app = Flask(__name__)
app.config['TEMPLATES_AUTO_RELOAD'] = True

# Developer 2: Added API health check
@app.route(f"{API_PREFIX}/health", methods=["GET"])
def api_health():
    """API health check endpoint added by Developer 2"""
    return jsonify({
        "status": "healthy",
        "version": API_VERSION,
        "model_loaded": model is not None,
        "features": len(feature_list)
    })

@app.route(f"{API_PREFIX}/features", methods=["GET"])
def api_features():
    """Get list of model features - Developer 2"""
    return jsonify({
        "features": feature_list,
        "count": len(feature_list)
    })

app = Flask(__name__)
app.config['TEMPLATES_AUTO_RELOAD'] = True

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html", feature_meta=feature_meta)

@app.route("/predict", methods=["POST"])
def predict():
    # build input vector in same order as feature_list
    row = []
    for feat in feature_list:
        field = feature_field_map[feat]
        val = request.form.get(field)
        if val is None:
            return f"Missing value for {feat}", 400
        if feat in label_encoders:
            # safe: value should be one of label_encoders[feat].classes_
            le = label_encoders[feat]
            try:
                encoded = int(le.transform([val])[0])
            except Exception as e:
                return f"Unexpected categorical value for {feat}: {val}", 400
            row.append(encoded)
        else:
            # numeric
            try:
                row.append(float(val))
            except:
                return f"Invalid numeric value for {feat}: {val}", 400

    X = np.array(row).reshape(1, -1)
    pred = model.predict(X)[0]
    # format prediction
    try:
        pred_fmt = round(float(pred), 2)
    except:
        pred_fmt = str(pred)
    return render_template("result.html", prediction=pred_fmt)

# Optional JSON API
@app.route("/api/predict", methods=["POST"])
def api_predict():
    data = request.json
    if not data:
        return {"error": "JSON payload required"}, 400
    row = []
    for feat in feature_list:
        if feat not in data:
            return {"error": f"Missing field: {feat}"}, 400
        val = data[feat]
        if feat in label_encoders:
            le = label_encoders[feat]
            try:
                encoded = int(le.transform([str(val)])[0])
            except Exception as e:
                return {"error": f"Invalid categorical value for {feat}: {val}"}, 400
            row.append(encoded)
        else:
            try:
                row.append(float(val))
            except:
                return {"error": f"Invalid numeric value for {feat}: {val}"}, 400
    X = np.array(row).reshape(1, -1)
    pred = model.predict(X)[0]
    return {"prediction": float(pred)}

@app.route("/dashboard")
def dashboard():
    model_info = {
        "model_type": "RandomForest Regressor",
        "features": len(feature_list),
        "status": "Active and Ready"
    }
    return render_template("dashboard.html", model_info=model_info)

@app.route("/statistics")
def statistics():
    # Load evaluation metrics
    import json
    metrics_path = os.path.join(APP_ROOT, "metrics", "eval.json")
    if os.path.exists(metrics_path):
        with open(metrics_path, "r") as f:
            metrics = json.load(f)
    else:
        metrics = {
            "rmse": "N/A",
            "mae": "N/A",
            "r2": "N/A",
            "mape": "N/A"
        }
    
    stats = {
        "training_samples": 132355,
        "test_samples": 33089,
        "total_features": len(feature_list),
        "categorical_features": len([f for f in feature_list if f in label_encoders]),
        "numeric_features": len([f for f in feature_list if f not in label_encoders]),
        "metrics": metrics
    }
    return render_template("statistics.html", stats=stats)

if __name__ == "__main__":
    app.run(debug=True, port=5000)
