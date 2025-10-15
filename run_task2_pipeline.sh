#!/bin/bash
# Task 2: DVC-Based ML Pipeline - Complete Workflow
# This script sets up and runs the complete ML pipeline with DVC

set -e  # Exit on error

PROJECT_DIR="/Users/alich/Fast Uni Things/Semester + labs/Semester 9/MLOps/Lab8/21L-6003 Ali Mohsin Lab8 Tasks 1+2"
cd "$PROJECT_DIR"

echo "============================================"
echo "TASK 2: DVC-BASED ML PIPELINE"
echo "============================================"
echo ""

# Step 1: Track data with DVC
echo "📌 Step 1: Tracking data with DVC..."
if [ ! -f "data/zameen-updated.csv.dvc" ]; then
    dvc add data/zameen-updated.csv
    echo "✅ Data tracked with DVC"
else
    echo "ℹ️  Data already tracked with DVC"
fi
echo ""

# Step 2: Setup DVC remote storage (local)
echo "📌 Step 2: Configuring DVC remote storage..."
DVC_REMOTE_DIR="/tmp/dvc-storage-lab8"
mkdir -p "$DVC_REMOTE_DIR"

# Check if remote exists
if ! dvc remote list | grep -q "myremote"; then
    dvc remote add -d myremote "$DVC_REMOTE_DIR"
    echo "✅ DVC remote configured: $DVC_REMOTE_DIR"
else
    echo "ℹ️  DVC remote already configured"
fi
echo ""

# Step 3: Run DVC pipeline
echo "============================================"
echo "🚀 Step 3: Running DVC Pipeline"
echo "============================================"
echo ""

echo "📋 Pipeline stages:"
dvc stage list 2>/dev/null || echo "No stages defined yet"
echo ""

echo "🔄 Executing pipeline..."
dvc repro --verbose
echo ""

# Step 4: Show results
echo "============================================"
echo "📊 Step 4: Pipeline Results"
echo "============================================"
echo ""

echo "📈 Model Metrics:"
if [ -f "metrics/eval.json" ]; then
    cat metrics/eval.json
else
    echo "⚠️  Metrics file not found"
fi
echo ""

echo "🗂️  Generated Files:"
echo "   Data files:"
ls -lh data/*.npy 2>/dev/null || echo "   No .npy files"
echo ""
echo "   Model files:"
ls -lh model.pkl models/*.pkl 2>/dev/null || echo "   No model files"
echo ""
echo "   Metrics:"
ls -lh metrics/*.json 2>/dev/null || echo "   No metrics files"
echo ""

# Step 6: Show DVC DAG
echo "🌳 Pipeline DAG:"
dvc dag
echo ""

# Step 5: Push to DVC remote
echo "📤 Step 5: Pushing data and models to DVC remote..."
dvc push
echo "✅ Data and models pushed to remote storage"
echo ""

# Step 6: Git commit
echo "📝 Step 6: Committing to Git..."
git add dvc.yaml dvc.lock params.yaml data/.gitignore data/zameen-updated.csv.dvc
git add src/*.py README.md requirements.txt metrics/.gitignore
git commit -m "feat: Complete DVC pipeline for house price prediction" 2>/dev/null || echo "ℹ️  Nothing new to commit"
echo ""

# Step 7: Show status
echo "============================================"
echo "✅ TASK 2 COMPLETED SUCCESSFULLY!"
echo "============================================"
echo ""
echo "📊 Summary:"
echo "  • Dataset generated and tracked with DVC"
echo "  • Pipeline executed successfully"
echo "  • Model trained and evaluated"
echo "  • Artifacts pushed to DVC remote"
echo "  • Changes committed to Git"
echo ""
echo "📋 Next Steps:"
echo "  • Run Flask app: python housepk_app.py"
echo "  • View metrics: cat metrics/eval.json"
echo "  • Visualize pipeline: dvc dag"
echo "  • Push to GitHub: git push origin main"
echo ""

echo "🎉 DVC ML Pipeline workflow complete!"
