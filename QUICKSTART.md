# 🚀 Quick Start Guide

## Lab 8: Git & DVC - Ali Mohsin (21L-6003)

### ⚡ Fast Execution

```bash
# Execute both tasks with branch separation
./run_lab8_with_branches.sh
# Then select option 3 (Both Tasks)
```

### 📋 Branch Strategy

- **`main`** - Base setup and configuration
- **`task1-collaborative-flask`** - Git branching and merge conflicts demo
- **`task2-dvc-pipeline`** - DVC ML pipeline implementation

---

## Task 1: Collaborative Flask Development

### Objective
Demonstrate Git collaboration with intentional merge conflicts

### Branch Workflow
```bash
# Automatic execution
./run_lab8_with_branches.sh
# Select option 1

# Manual execution
git checkout -b task1-collaborative-flask
./run_task1_branching.sh
```

### What it does:
1. Creates 3 feature branches: `feature-login`, `feature-dashboard`, `feature-api`
2. Each branch modifies `housepk_app.py` at the same location
3. Merges branches sequentially into main
4. Demonstrates and resolves merge conflicts
5. Shows collaborative Git workflow

---

## Task 2: DVC-Based ML Pipeline

### Objective
Build reproducible ML pipeline with DVC for house price prediction

### Branch Workflow
```bash
# Automatic execution
./run_lab8_with_branches.sh
# Select option 2

# Manual execution  
git checkout -b task2-dvc-pipeline
./run_task2_pipeline.sh
```

### What it does:
1. Tracks `data/zameen-updated.csv` with DVC (168k records)
2. Configures DVC remote storage
3. Runs complete ML pipeline:
   - **Prepare**: Data cleaning and preprocessing
   - **Features**: Encoding and train-test split
   - **Train**: RandomForest model training
   - **Evaluate**: Model evaluation (RMSE, MAE, R²)
4. Saves trained model for Flask deployment
5. Commits pipeline artifacts to Git

---

## 📊 Dataset Information

**File**: `data/zameen-updated.csv`
- **Records**: 168,448 properties
- **Features**: 
  - Categorical: city, property_type, purpose, Area Type
  - Numerical: bedrooms, baths, Area Size, latitude, longitude
- **Target**: price (PKR)

---

## 🎯 Pipeline Stages

### 1. Prepare (`src/prepare.py`)
- Loads raw Zameen dataset
- Handles missing values
- Removes outliers (1st-99th percentile)
- Output: `data/prepared_data.csv`

### 2. Features (`src/features.py`)
- Label encoding for categorical features
- Train-test split (80/20)
- Saves encoders for deployment
- Output: `X_train.npy`, `X_test.npy`, `y_train.npy`, `y_test.npy`

### 3. Train (`src/train.py`)
- Random Forest Regressor
- Hyperparameters from `params.yaml`
- Output: `model.pkl`, `models/house_price_model.pkl`

### 4. Evaluate (`src/evaluate.py`)
- Calculates RMSE, MAE, R², MAPE
- Output: `metrics/eval.json`

---

## 🔧 Configuration

### `params.yaml`
```yaml
prepare:
  dataset_path: 'data/zameen-updated.csv'

features:
  test_size: 0.2
  target_column: 'price'

train:
  model_type: 'RandomForest'
  n_estimators: 100
  max_depth: 10
```

---

## 📈 Expected Results

After running the pipeline:

```json
{
  "rmse": ~2500000,
  "mae": ~1500000,  
  "r2_score": ~0.75,
  "mape": ~15%
}
```

---

## 🌐 Flask Deployment

After Task 2 completes:

```bash
python housepk_app.py
```

Access at `http://localhost:5000`

### Endpoints:
- `/` - Prediction form
- `/login` - User authentication
- `/dashboard` - Model statistics
- `/api/predict` - JSON API
- `/api/health` - Health check

---

## 🔍 Verification Commands

```bash
# Check branches
git branch -a

# View pipeline
dvc dag

# Show metrics
cat metrics/eval.json

# List DVC tracked files
dvc list . data

# Check DVC status
dvc status

# View git log
git log --oneline --graph --all
```

---

## 🐛 Troubleshooting

### Issue: DVC not found
```bash
pip install dvc
```

### Issue: Models not found for Flask
```bash
# Make sure Task 2 has been run
git checkout task2-dvc-pipeline
dvc repro
```

### Issue: Merge conflicts
```bash
# Conflicts are intentional in Task 1
# The script resolves them automatically
```

---

## 📚 File Structure

```
.
├── data/
│   ├── zameen-updated.csv          # Original dataset
│   └── prepared_data.csv           # After prepare stage
├── src/
│   ├── prepare.py                  # Stage 1
│   ├── features.py                 # Stage 2
│   ├── train.py                    # Stage 3
│   └── evaluate.py                 # Stage 4
├── models/
│   ├── house_price_model.pkl       # Trained model
│   ├── label_encoders.pkl          # For deployment
│   └── model_features.pkl          # Feature list
├── metrics/
│   └── eval.json                   # Model metrics
├── templates/
│   ├── login.html                  # Task 1
│   ├── dashboard.html              # Task 1
│   └── statistics.html             # Task 1
├── dvc.yaml                        # Pipeline definition
├── params.yaml                     # Hyperparameters
├── housepk_app.py                  # Flask app
├── run_lab8_with_branches.sh       # Main script ⭐
├── run_task1_branching.sh          # Task 1 script
└── run_task2_pipeline.sh           # Task 2 script
```

---

## ⚡ One-Command Setup & Execution

```bash
# Make executable (first time only)
chmod +x run_lab8_with_branches.sh

# Run everything
./run_lab8_with_branches.sh
# Choose option 3

# Or run individually
./run_lab8_with_branches.sh  # option 1 for Task 1
./run_lab8_with_branches.sh  # option 2 for Task 2
```

---

## 🎓 Learning Outcomes

### Task 1: Git Collaboration
- ✅ Branch creation and management
- ✅ Merge conflict identification
- ✅ Conflict resolution strategies
- ✅ Team collaboration workflow

### Task 2: MLOps with DVC
- ✅ Data version control
- ✅ Reproducible ML pipelines
- ✅ Pipeline orchestration
- ✅ Model deployment
- ✅ Experiment tracking

---

## 📞 Support

**Student**: Ali Mohsin  
**ID**: 21L-6003  
**Course**: MLOps - Semester 9  

For issues, check:
1. README.md - Full documentation
2. QUICKSTART.md - This file
3. Git logs: `git log --oneline`
4. DVC status: `dvc status`
