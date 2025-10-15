#!/bin/bash
# Complete Lab 8 Implementation with Separate Branches
# Branch strategy: task1-collaborative-flask and task2-dvc-pipeline

set -e

PROJECT_DIR="/Users/alich/Fast Uni Things/Semester + labs/Semester 9/MLOps/Lab8/21L-6003 Ali Mohsin Lab8 Tasks 1+2"
cd "$PROJECT_DIR"

echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     MLOps Lab 8 - Complete Implementation             ║"
echo "║     Student: Ali Mohsin (21L-6003)                    ║"
echo "║     Branch Strategy: Separate branches for each task  ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Make scripts executable
chmod +x run_task1_branching.sh 2>/dev/null || true
chmod +x run_task2_pipeline.sh 2>/dev/null || true

echo "============================================"
echo "🌿 BRANCH STRATEGY"
echo "============================================"
echo ""
echo "This lab uses separate branches for each task:"
echo "  📌 main - Base branch with common setup"
echo "  📌 task1-collaborative-flask - Git branching & merge conflicts"
echo "  📌 task2-dvc-pipeline - DVC ML pipeline implementation"
echo ""
echo "============================================"
echo ""

# Ensure we're on main and it's clean
echo "📌 Ensuring main branch is ready..."
git checkout main 2>/dev/null || git checkout -b main
echo ""

# Commit current state to main
echo "📝 Committing setup to main branch..."
git add .
git commit -m "chore: Initial setup with dataset and configuration" 2>/dev/null || echo "ℹ️  Nothing new to commit"
echo ""

echo "Choose which task to run:"
echo "1) Task 1: Collaborative Flask Development (creates task1-collaborative-flask branch)"
echo "2) Task 2: DVC-Based ML Pipeline (creates task2-dvc-pipeline branch)"
echo "3) Both Tasks (Sequential - creates both branches)"
echo "4) Show branch status and structure"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "============================================"
        echo "TASK 1: COLLABORATIVE FLASK DEVELOPMENT"
        echo "============================================"
        echo ""
        
        # Create and switch to task1 branch
        echo "🌿 Creating/switching to task1-collaborative-flask branch..."
        git checkout task1-collaborative-flask 2>/dev/null || git checkout -b task1-collaborative-flask
        echo "✅ On branch: task1-collaborative-flask"
        echo ""
        
        # Run task 1
        ./run_task1_branching.sh
        
        echo ""
        echo "📌 Task 1 completed on branch: task1-collaborative-flask"
        echo "💡 To merge back to main: git checkout main && git merge task1-collaborative-flask"
        ;;
    
    2)
        echo ""
        echo "============================================"
        echo "TASK 2: DVC-BASED ML PIPELINE"
        echo "============================================"
        echo ""
        
        # Create and switch to task2 branch
        echo "🌿 Creating/switching to task2-dvc-pipeline branch..."
        git checkout task2-dvc-pipeline 2>/dev/null || git checkout -b task2-dvc-pipeline
        echo "✅ On branch: task2-dvc-pipeline"
        echo ""
        
        # Run task 2
        ./run_task2_pipeline.sh
        
        echo ""
        echo "📌 Task 2 completed on branch: task2-dvc-pipeline"
        echo "💡 To merge back to main: git checkout main && git merge task2-dvc-pipeline"
        ;;
    
    3)
        echo ""
        echo "============================================"
        echo "EXECUTING BOTH TASKS SEQUENTIALLY"
        echo "============================================"
        echo ""
        
        # Task 1
        echo "============================================"
        echo "TASK 1: COLLABORATIVE FLASK DEVELOPMENT"
        echo "============================================"
        echo ""
        
        echo "🌿 Creating/switching to task1-collaborative-flask branch..."
        git checkout task1-collaborative-flask 2>/dev/null || git checkout -b task1-collaborative-flask
        echo "✅ On branch: task1-collaborative-flask"
        echo ""
        
        ./run_task1_branching.sh
        
        echo ""
        echo "✅ Task 1 complete on task1-collaborative-flask branch"
        echo ""
        
        # Switch back to main
        git checkout main
        echo ""
        
        # Task 2
        echo "============================================"
        echo "TASK 2: DVC-BASED ML PIPELINE"
        echo "============================================"
        echo ""
        
        echo "🌿 Creating/switching to task2-dvc-pipeline branch..."
        git checkout task2-dvc-pipeline 2>/dev/null || git checkout -b task2-dvc-pipeline
        echo "✅ On branch: task2-dvc-pipeline"
        echo ""
        
        ./run_task2_pipeline.sh
        
        echo ""
        echo "✅ Task 2 complete on task2-dvc-pipeline branch"
        echo ""
        
        # Switch back to main
        git checkout main
        
        echo ""
        echo "============================================"
        echo "📊 BRANCH SUMMARY"
        echo "============================================"
        echo ""
        echo "✅ All tasks completed!"
        echo ""
        echo "Branches created:"
        git branch -a | grep -E "(task1|task2|main)"
        echo ""
        echo "💡 Next steps:"
        echo "  • To work on Task 1: git checkout task1-collaborative-flask"
        echo "  • To work on Task 2: git checkout task2-dvc-pipeline"
        echo "  • To merge Task 1: git checkout main && git merge task1-collaborative-flask"
        echo "  • To merge Task 2: git checkout main && git merge task2-dvc-pipeline"
        ;;
    
    4)
        echo ""
        echo "============================================"
        echo "📊 BRANCH STATUS AND STRUCTURE"
        echo "============================================"
        echo ""
        
        echo "🌿 Current Branch:"
        git branch --show-current
        echo ""
        
        echo "🌳 All Branches:"
        git branch -a
        echo ""
        
        echo "📝 Recent Commits per Branch:"
        for branch in main task1-collaborative-flask task2-dvc-pipeline; do
            if git show-ref --verify --quiet refs/heads/$branch; then
                echo ""
                echo "Branch: $branch"
                git log $branch --oneline -3 2>/dev/null || echo "  No commits yet"
            else
                echo ""
                echo "Branch: $branch (not created yet)"
            fi
        done
        echo ""
        
        echo "📂 Project Structure:"
        tree -L 2 -I '.git|.dvc|.venv|__pycache__' . 2>/dev/null || ls -R | head -50
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
echo "🌿 List Branches: git branch -a"
echo ""
