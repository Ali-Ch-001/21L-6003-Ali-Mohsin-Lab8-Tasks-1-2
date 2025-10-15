# MLOps Lab 8 - GitHub & DVC

**Student:** Ali Mohsin (21L-6003)  
**Lab:** Tasks 1+2

## Project Overview

This project demonstrates:
1. **Collaborative Flask Development with Git** - Managing merge conflicts in a team environment
2. **DVC-Based ML Pipeline** - Reproducible machine learning workflow with data version control

---

## Problem Statement 1: Collaborative Flask Development

### Objective
Simulate collaborative development on a Flask application with multiple team members working on the same codebase, creating and resolving merge conflicts.

### Workflow
1. Create feature branches for different developers
2. Modify the same file (`housepk_app.py`) with conflicting changes
3. Merge branches and resolve conflicts
4. Synchronize all team members with the resolved codebase

### Feature Branches
- `feature-login` - Login functionality
- `feature-dashboard` - Dashboard implementation
- `feature-api` - API endpoints

---

## Problem Statement 2: DVC-Based ML Pipeline

### Objective
Build an end-to-end reproducible ML pipeline for house price prediction using DVC and deploy with Flask.

### Dataset
Pakistan House Price Dataset from Kaggle

### Pipeline Stages
1. **Prepare** - Load and prepare raw data
2. **Features** - Feature engineering and train-test split
3. **Train** - Train machine learning model
4. **Evaluate** - Evaluate model performance

### Technologies
- **DVC** - Data version control and pipeline orchestration
- **scikit-learn** - Machine learning
- **Flask** - Model deployment
- **Git/GitHub** - Code version control

---

## Project Structure

```
├── data/                   # Data directory (tracked by DVC)
├── src/                    # Source code for ML pipeline
│   ├── prepare.py         # Data preparation
│   ├── features.py        # Feature engineering
│   ├── train.py           # Model training
│   └── evaluate.py        # Model evaluation
├── metrics/               # Model metrics (JSON)
├── models/                # Trained models (tracked by DVC)
├── templates/             # Flask HTML templates
├── housepk_app.py        # Flask application
├── dvc.yaml              # DVC pipeline definition
├── params.yaml           # Pipeline parameters
├── requirements.txt      # Python dependencies
└── README.md             # This file
```

---

## Setup Instructions

### 1. Clone Repository
```bash
git clone <repository-url>
cd "21L-6003 Ali Mohsin Lab8 Tasks 1+2"
```

### 2. Create Virtual Environment
```bash
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Initialize DVC
```bash
dvc init
dvc remote add -d local /tmp/dvc-storage
```

### 5. Pull Data (if available)
```bash
dvc pull
```

---

## Running the Pipeline

### Execute Complete Pipeline
```bash
dvc repro
```

### Execute Specific Stage
```bash
dvc repro <stage-name>
```

### View Pipeline DAG
```bash
dvc dag
```

---

## Flask Deployment

### Run Flask App
```bash
python housepk_app.py
```

### Access Application
Open browser: `http://localhost:5000`

---

## Git Branching Workflow (Task 1)

### Create Feature Branch
```bash
git checkout -b feature-<name>
```

### Make Changes and Commit
```bash
git add .
git commit -m "Description of changes"
```

### Push to Remote
```bash
git push origin feature-<name>
```

### Merge to Main
```bash
git checkout main
git merge feature-<name>
# Resolve conflicts if any
git add .
git commit -m "Resolved merge conflicts"
git push origin main
```

---

## DVC Commands Reference

### Track Data Files
```bash
dvc add data/dataset.csv
```

### Run Pipeline
```bash
dvc repro
```

### View Metrics
```bash
dvc metrics show
```

### Compare Experiments
```bash
dvc metrics diff
```

### Push Data to Remote
```bash
dvc push
```

---

## Task 1: Collaborative Development Steps

1. **Terminal 1 (Developer 1 - Login Feature)**
   ```bash
   git checkout -b feature-login
   # Edit housepk_app.py to add login functionality
   git add housepk_app.py
   git commit -m "Add login route and authentication"
   git push origin feature-login
   ```

2. **Terminal 2 (Developer 2 - Dashboard Feature)**
   ```bash
   git checkout -b feature-dashboard
   # Edit housepk_app.py to add dashboard
   git add housepk_app.py
   git commit -m "Add dashboard with visualizations"
   git push origin feature-dashboard
   ```

3. **Terminal 3 (Developer 3 - API Feature)**
   ```bash
   git checkout -b feature-api
   # Edit housepk_app.py to add API endpoints
   git add housepk_app.py
   git commit -m "Add REST API endpoints"
   git push origin feature-api
   ```

4. **Team Lead - Merge and Resolve Conflicts**
   ```bash
   git checkout main
   git merge feature-login
   git merge feature-dashboard  # Conflicts!
   # Resolve conflicts in housepk_app.py
   git add housepk_app.py
   git commit -m "Resolved conflicts: merged login and dashboard"
   git merge feature-api  # More conflicts!
   # Resolve conflicts
   git add housepk_app.py
   git commit -m "Resolved conflicts: merged all features"
   git push origin main
   ```

5. **All Developers - Sync**
   ```bash
   git checkout main
   git pull origin main
   ```

---

## Task 2: DVC Pipeline Steps

1. **Setup DVC Remote**
   ```bash
   dvc remote add -d myremote /path/to/storage
   ```

2. **Add Dataset**
   ```bash
   dvc add data/house_prices.csv
   git add data/house_prices.csv.dvc data/.gitignore
   git commit -m "Add house price dataset"
   ```

3. **Define Pipeline**
   - Edit `params.yaml` with hyperparameters
   - Edit `dvc.yaml` with pipeline stages
   
4. **Run Pipeline**
   ```bash
   dvc repro
   ```

5. **Commit Results**
   ```bash
   git add dvc.yaml dvc.lock params.yaml src/ metrics/
   git commit -m "Complete ML pipeline with DVC"
   dvc push
   git push
   ```

---

## Troubleshooting

### DVC Issues
- **Error: DVC file not found**: Run `dvc pull` to fetch data
- **Pipeline fails**: Check `params.yaml` and ensure data files exist

### Git Issues
- **Merge conflicts**: Open conflicted files, resolve markers, then `git add` and `git commit`
- **Diverged branches**: Use `git pull --rebase` or `git merge`

### Flask Issues
- **Model not found**: Ensure `dvc pull` has been run to fetch model files
- **Port already in use**: Change port in `app.run(port=XXXX)`

---

## Metrics & Results

Pipeline metrics are stored in `metrics/eval.json`:
- Accuracy
- F1 Score
- Precision
- Recall
- RMSE (for regression)

---

## Contributing

1. Create feature branch
2. Make changes
3. Test locally
4. Submit pull request
5. Resolve conflicts
6. Merge to main

---

## License

Educational project for MLOps Lab 8

---

## Contact

**Ali Mohsin**  
Student ID: 21L-6003  
Course: MLOps - Semester 9
