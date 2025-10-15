#!/bin/bash
# Task 1: Collaborative Flask Development - Complete Workflow
# This script simulates multiple developers working on the same Flask app

set -e  # Exit on error

PROJECT_DIR="/Users/alich/Fast Uni Things/Semester + labs/Semester 9/MLOps/Lab8/21L-6003 Ali Mohsin Lab8 Tasks 1+2"
cd "$PROJECT_DIR"

echo "============================================"
echo "TASK 1: COLLABORATIVE FLASK DEVELOPMENT"
echo "============================================"
echo ""

# Ensure we're on main branch and it's clean
echo "📌 Step 1: Preparing main branch..."
git checkout main 2>/dev/null || git checkout -b main
git add .
git commit -m "Initial setup before branching" 2>/dev/null || echo "Nothing to commit"
echo "✓ Main branch ready"
echo ""

# ===================================================================
# DEVELOPER 1: Feature Login
# ===================================================================
echo "============================================"
echo "👤 DEVELOPER 1: Working on feature-login"
echo "============================================"
echo ""

echo "📌 Creating feature-login branch..."
git checkout -b feature-login 2>/dev/null || git checkout feature-login

echo "✏️  Adding login functionality to housepk_app.py..."

# Add login route at line 37 (after app initialization)
cat > /tmp/login_addition.txt << 'EOF'

# ===========================================
# LOGIN FEATURE - Added by Developer 1
# ===========================================
@app.route("/login", methods=["GET", "POST"])
def login():
    """Login route for user authentication"""
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        # Simple authentication logic
        if username == "admin" and password == "admin123":
            return redirect(url_for("index"))
        else:
            return render_template("login.html", error="Invalid credentials")
    return render_template("login.html")

@app.route("/logout")
def logout():
    """Logout route"""
    return redirect(url_for("login"))

EOF

# Backup original file
cp housepk_app.py housepk_app.py.backup

# Insert login feature after line 36 (after app.config line)
head -n 36 housepk_app.py > housepk_app_temp.py
cat /tmp/login_addition.txt >> housepk_app_temp.py
tail -n +37 housepk_app.py >> housepk_app_temp.py
mv housepk_app_temp.py housepk_app.py

echo "✓ Login feature added"

echo "📝 Committing changes..."
git add housepk_app.py
git commit -m "feat: Add login and logout routes with authentication"
echo "✓ Committed to feature-login"
echo ""

# ===================================================================
# DEVELOPER 2: Feature Dashboard
# ===================================================================
echo "============================================"
echo "👤 DEVELOPER 2: Working on feature-dashboard"
echo "============================================"
echo ""

echo "📌 Switching to main and creating feature-dashboard branch..."
git checkout main
git checkout -b feature-dashboard 2>/dev/null || git checkout feature-dashboard

echo "✏️  Adding dashboard functionality to housepk_app.py..."

# Add dashboard route at same location (will conflict!)
cat > /tmp/dashboard_addition.txt << 'EOF'

# ===========================================
# DASHBOARD FEATURE - Added by Developer 2
# ===========================================
@app.route("/dashboard")
def dashboard():
    """Dashboard with statistics and visualizations"""
    # Get model statistics
    model_info = {
        "model_type": "House Price Predictor",
        "features": len(feature_list),
        "status": "Active"
    }
    return render_template("dashboard.html", model_info=model_info)

@app.route("/statistics")
def statistics():
    """Show detailed statistics"""
    stats = {
        "total_predictions": 1250,
        "accuracy": 0.89,
        "last_updated": "2025-10-15"
    }
    return render_template("statistics.html", stats=stats)

EOF

# Restore backup and add dashboard feature
cp housepk_app.py.backup housepk_app.py

# Insert dashboard feature at same location
head -n 36 housepk_app.py > housepk_app_temp.py
cat /tmp/dashboard_addition.txt >> housepk_app_temp.py
tail -n +37 housepk_app.py >> housepk_app_temp.py
mv housepk_app_temp.py housepk_app.py

echo "✓ Dashboard feature added"

echo "📝 Committing changes..."
git add housepk_app.py
git commit -m "feat: Add dashboard and statistics routes"
echo "✓ Committed to feature-dashboard"
echo ""

# ===================================================================
# DEVELOPER 3: Feature API
# ===================================================================
echo "============================================"
echo "👤 DEVELOPER 3: Working on feature-api"
echo "============================================"
echo ""

echo "📌 Switching to main and creating feature-api branch..."
git checkout main
git checkout -b feature-api 2>/dev/null || git checkout feature-api

echo "✏️  Adding API endpoints to housepk_app.py..."

# Add API routes at same location (more conflicts!)
cat > /tmp/api_addition.txt << 'EOF'

# ===========================================
# API ENDPOINTS - Added by Developer 3
# ===========================================
@app.route("/api/health")
def api_health():
    """API health check endpoint"""
    return {"status": "healthy", "version": "1.0.0"}

@app.route("/api/model/info")
def api_model_info():
    """Get model information via API"""
    return {
        "model_type": "Random Forest",
        "features": feature_list,
        "feature_count": len(feature_list)
    }

EOF

# Restore backup and add API feature
cp housepk_app.py.backup housepk_app.py

# Insert API feature at same location
head -n 36 housepk_app.py > housepk_app_temp.py
cat /tmp/api_addition.txt >> housepk_app_temp.py
tail -n +37 housepk_app.py >> housepk_app_temp.py
mv housepk_app_temp.py housepk_app.py

echo "✓ API endpoints added"

echo "📝 Committing changes..."
git add housepk_app.py
git commit -m "feat: Add REST API endpoints for health and model info"
echo "✓ Committed to feature-api"
echo ""

# ===================================================================
# TEAM LEAD: Merge all features
# ===================================================================
echo "============================================"
echo "👨‍💼 TEAM LEAD: Merging all features to main"
echo "============================================"
echo ""

echo "📌 Switching to main branch..."
git checkout main
echo ""

# ===================================================================
# Merge Feature 1: Login (should be clean)
# ===================================================================
echo "🔄 Merging feature-login into main..."
git merge feature-login --no-edit
if [ $? -eq 0 ]; then
    echo "✅ feature-login merged successfully (no conflicts)"
else
    echo "⚠️  Conflicts detected in feature-login merge"
fi
echo ""

# ===================================================================
# Merge Feature 2: Dashboard (will have conflicts)
# ===================================================================
echo "🔄 Merging feature-dashboard into main..."
git merge feature-dashboard --no-edit 2>&1 | tee /tmp/merge_output.txt || true

if grep -q "CONFLICT" /tmp/merge_output.txt; then
    echo "⚠️  ❌ MERGE CONFLICT DETECTED!"
    echo ""
    echo "📋 Conflicting files:"
    git status --short | grep "^UU"
    echo ""
    echo "🔧 Resolving conflicts in housepk_app.py..."
    
    # Manual conflict resolution: Keep both login and dashboard features
    cat > housepk_app_resolved.py << 'RESOLVED'
# app.py
import os
import joblib
import numpy as np
from flask import Flask, render_template, request, redirect, url_for

APP_ROOT = os.path.dirname(__file__)
MODEL_DIR = os.path.join(APP_ROOT, "models")

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

# ===========================================
# LOGIN FEATURE - Added by Developer 1
# ===========================================
@app.route("/login", methods=["GET", "POST"])
def login():
    """Login route for user authentication"""
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        # Simple authentication logic
        if username == "admin" and password == "admin123":
            return redirect(url_for("index"))
        else:
            return render_template("login.html", error="Invalid credentials")
    return render_template("login.html")

@app.route("/logout")
def logout():
    """Logout route"""
    return redirect(url_for("login"))

# ===========================================
# DASHBOARD FEATURE - Added by Developer 2
# ===========================================
@app.route("/dashboard")
def dashboard():
    """Dashboard with statistics and visualizations"""
    # Get model statistics
    model_info = {
        "model_type": "House Price Predictor",
        "features": len(feature_list),
        "status": "Active"
    }
    return render_template("dashboard.html", model_info=model_info)

@app.route("/statistics")
def statistics():
    """Show detailed statistics"""
    stats = {
        "total_predictions": 1250,
        "accuracy": 0.89,
        "last_updated": "2025-10-15"
    }
    return render_template("statistics.html", stats=stats)

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

if __name__ == "__main__":
    app.run(debug=True, port=5000)
RESOLVED

    mv housepk_app_resolved.py housepk_app.py
    git add housepk_app.py
    git commit -m "fix: Resolved merge conflict - integrated login and dashboard features"
    echo "✅ Conflicts resolved and committed"
else
    echo "✅ feature-dashboard merged successfully (no conflicts)"
fi
echo ""

# ===================================================================
# Merge Feature 3: API (will also have conflicts)
# ===================================================================
echo "🔄 Merging feature-api into main..."
git merge feature-api --no-edit 2>&1 | tee /tmp/merge_output2.txt || true

if grep -q "CONFLICT" /tmp/merge_output2.txt; then
    echo "⚠️  ❌ MERGE CONFLICT DETECTED!"
    echo ""
    echo "📋 Conflicting files:"
    git status --short | grep "^UU"
    echo ""
    echo "🔧 Resolving conflicts - integrating API with existing features..."
    
    # Final resolution: Keep all features (login + dashboard + API)
    cat > housepk_app_final.py << 'FINAL'
# app.py
import os
import joblib
import numpy as np
from flask import Flask, render_template, request, redirect, url_for

APP_ROOT = os.path.dirname(__file__)
MODEL_DIR = os.path.join(APP_ROOT, "models")

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

# ===========================================
# LOGIN FEATURE - Added by Developer 1
# ===========================================
@app.route("/login", methods=["GET", "POST"])
def login():
    """Login route for user authentication"""
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        # Simple authentication logic
        if username == "admin" and password == "admin123":
            return redirect(url_for("index"))
        else:
            return render_template("login.html", error="Invalid credentials")
    return render_template("login.html")

@app.route("/logout")
def logout():
    """Logout route"""
    return redirect(url_for("login"))

# ===========================================
# DASHBOARD FEATURE - Added by Developer 2
# ===========================================
@app.route("/dashboard")
def dashboard():
    """Dashboard with statistics and visualizations"""
    # Get model statistics
    model_info = {
        "model_type": "House Price Predictor",
        "features": len(feature_list),
        "status": "Active"
    }
    return render_template("dashboard.html", model_info=model_info)

@app.route("/statistics")
def statistics():
    """Show detailed statistics"""
    stats = {
        "total_predictions": 1250,
        "accuracy": 0.89,
        "last_updated": "2025-10-15"
    }
    return render_template("statistics.html", stats=stats)

# ===========================================
# API ENDPOINTS - Added by Developer 3
# ===========================================
@app.route("/api/health")
def api_health():
    """API health check endpoint"""
    return {"status": "healthy", "version": "1.0.0"}

@app.route("/api/model/info")
def api_model_info():
    """Get model information via API"""
    return {
        "model_type": "Random Forest",
        "features": feature_list,
        "feature_count": len(feature_list)
    }

# ===========================================
# ORIGINAL ROUTES
# ===========================================
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

if __name__ == "__main__":
    app.run(debug=True, port=5000)
FINAL

    mv housepk_app_final.py housepk_app.py
    git add housepk_app.py
    git commit -m "fix: Resolved final merge conflict - integrated all features (login + dashboard + API)"
    echo "✅ All conflicts resolved and committed"
else
    echo "✅ feature-api merged successfully (no conflicts)"
fi
echo ""

# ===================================================================
# Summary
# ===================================================================
echo "============================================"
echo "✅ TASK 1 COMPLETED SUCCESSFULLY!"
echo "============================================"
echo ""
echo "📊 Summary:"
echo "  • Created 3 feature branches"
echo "  • Made conflicting changes to housepk_app.py"
echo "  • Merged all branches to main"
echo "  • Resolved merge conflicts"
echo ""
echo "📝 Git Log:"
git log --oneline --graph --all -10
echo ""
echo "🌿 Branches:"
git branch -a
echo ""
echo "✅ All developers can now pull the latest main branch!"
echo ""

# Clean up backup
rm -f housepk_app.py.backup

echo "🎉 Collaborative development workflow complete!"
