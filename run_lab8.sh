#!/bin/bash
# Master Script: Execute Both Tasks
# This script runs the complete Lab 8 implementation

set -e

PROJECT_DIR="/Users/alich/Fast Uni Things/Semester + labs/Semester 9/MLOps/Lab8/21L-6003 Ali Mohsin Lab8 Tasks 1+2"
cd "$PROJECT_DIR"

echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     MLOps Lab 8 - Complete Implementation             ║"
echo "║     Student: Ali Mohsin (21L-6003)                    ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Make scripts executable
chmod +x run_task1_branching.sh
chmod +x run_task2_pipeline.sh
chmod +x generate_dataset.py

echo "Choose which task to run:"
echo "1) Task 1: Collaborative Flask Development (Git Branching & Merge Conflicts)"
echo "2) Task 2: DVC-Based ML Pipeline (House Price Prediction)"
echo "3) Both Tasks (Sequential Execution)"
echo "4) Setup Only (Generate dataset and initialize)"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "▶️  Running Task 1: Collaborative Flask Development"
        echo ""
        ./run_task1_branching.sh
        ;;
    2)
        echo ""
        echo "▶️  Running Task 2: DVC-Based ML Pipeline"
        echo ""
        ./run_task2_pipeline.sh
        ;;
    3)
        echo ""
        echo "▶️  Running Both Tasks Sequentially"
        echo ""
        echo "============================================"
        echo "EXECUTING TASK 1"
        echo "============================================"
        ./run_task1_branching.sh
        echo ""
        echo ""
        echo "============================================"
        echo "EXECUTING TASK 2"
        echo "============================================"
        ./run_task2_pipeline.sh
        ;;
    4)
        echo ""
        echo "▶️  Setup Only"
        echo ""
        echo "Generating dataset..."
        python generate_dataset.py
        echo ""
        echo "✅ Setup complete!"
        echo ""
        echo "Next steps:"
        echo "  • Run Task 1: ./run_task1_branching.sh"
        echo "  • Run Task 2: ./run_task2_pipeline.sh"
        ;;
    *)
        echo "❌ Invalid choice. Please run again and select 1-4."
        exit 1
        ;;
esac

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     ✅ Lab 8 Execution Complete!                      ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📚 Documentation: See README.md for detailed information"
echo "🌐 Flask App: python housepk_app.py"
echo "📊 View Metrics: cat metrics/eval.json"
echo "🌳 Pipeline DAG: dvc dag"
echo ""
