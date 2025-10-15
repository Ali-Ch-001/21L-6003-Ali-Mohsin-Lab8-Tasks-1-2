# Task 1: Collaborative Flask Development with Git and GitHub

## 📋 Problem Statement
Demonstrate collaborative software development using Git branching workflow, including:
- Multiple developers working on the same file
- Creating feature branches
- Merge conflicts
- Conflict resolution

## 🎯 Implementation Summary

### Step-by-Step Execution

#### 1. **Initial Setup**
- Started from `main` branch
- Repository status: Clean working tree
- Objective: Simulate 2 developers working on `housepk_app.py`

---

#### 2. **Developer 1: Login Feature** 👤
**Branch Created:** `feature-login`

**Changes Made:**
```python
# Added imports
from flask import Flask, render_template, request, redirect, url_for, session, flash

# Added configuration
app.secret_key = 'dev_secret_key_12345'

# Added routes
@app.route("/login", methods=["GET", "POST"])
def login():
    # Login logic with session management
    
@app.route("/logout")
def logout():
    # Logout with session clearing
```

**Commit Message:**
```
feat: Add login and logout functionality (Developer 1)

- Added Flask session support with secret key
- Implemented /login route with authentication
- Implemented /logout route with session clearing
- Added flash messages for user feedback
```

**Result:** ✅ Successfully committed to `feature-login` branch

---

#### 3. **Developer 2: API Feature** 👤
**Branch Created:** `feature-api`

**Changes Made:**
```python
# Added imports
from flask import Flask, render_template, request, redirect, url_for, jsonify

# Added API configuration
API_VERSION = "v1"
API_PREFIX = "/api/v1"

# Added routes
@app.route(f"{API_PREFIX}/health", methods=["GET"])
def api_health():
    # Health check endpoint
    
@app.route(f"{API_PREFIX}/features", methods=["GET"])
def api_features():
    # List model features
```

**Commit Message:**
```
feat: Add REST API endpoints (Developer 2)

- Added API version configuration
- Implemented /api/v1/health endpoint
- Implemented /api/v1/features endpoint
- Returns JSON responses for API consumers
```

**Result:** ✅ Successfully committed to `feature-api` branch

---

#### 4. **First Merge: feature-login → main** 🔀
**Team Lead Action:**
```bash
git checkout main
git merge feature-login
```

**Result:** ✅ **Fast-forward merge (No conflicts)**
- Developer 1's changes successfully integrated
- Main branch now has login/logout functionality

---

#### 5. **Second Merge: feature-api → main** 🔀
**Team Lead Action:**
```bash
git merge feature-api
```

**Result:** ❌ **MERGE CONFLICT DETECTED!**

**Conflict Details:**
```
CONFLICT (content): Merge conflict in housepk_app.py
Automatic merge failed; fix conflicts and then commit the result.
```

**Why the Conflict Occurred:**
Both developers modified the same section of `housepk_app.py`:
- **Location:** Import statements and app configuration
- **Developer 1:** Added `session, flash` imports and `secret_key`
- **Developer 2:** Added `jsonify` import and API configuration variables

**Conflict Markers in File:**
```python
<<<<<<< HEAD
from flask import Flask, render_template, request, redirect, url_for, session, flash
=======
from flask import Flask, render_template, request, redirect, url_for, jsonify
>>>>>>> feature-api

<<<<<<< HEAD
app.secret_key = 'dev_secret_key_12345'
=======
# Developer 2: Added API configuration
API_VERSION = "v1"
API_PREFIX = "/api/v1"
>>>>>>> feature-api
```

---

#### 6. **Conflict Resolution** 🔧
**Team Lead's Resolution Strategy:**

**Combined BOTH features** by:
1. **Merging imports:** Combined all unique imports
   ```python
   from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
   ```

2. **Keeping both configurations:**
   ```python
   app.secret_key = 'dev_secret_key_12345'  # Developer 1
   API_VERSION = "v1"                        # Developer 2
   API_PREFIX = "/api/v1"                   # Developer 2
   ```

3. **Organizing routes by feature:**
   ```python
   # ============================================
   # Authentication Routes (Developer 1)
   # ============================================
   @app.route("/login", methods=["GET", "POST"])
   # ... login logic ...
   
   @app.route("/logout")
   # ... logout logic ...
   
   # ============================================
   # API Routes (Developer 2)
   # ============================================
   @app.route(f"{API_PREFIX}/health", methods=["GET"])
   # ... health check ...
   
   @app.route(f"{API_PREFIX}/features", methods=["GET"])
   # ... features list ...
   ```

**Resolution Steps:**
```bash
# 1. Edit housepk_app.py to resolve conflicts
# 2. Remove conflict markers (<<<<<<, =======, >>>>>>>)
# 3. Combine both developers' changes
# 4. Stage the resolved file
git add housepk_app.py

# 5. Commit the merge
git commit -m "Merge feature-api into main (resolved conflicts)"
```

**Result:** ✅ **Conflict successfully resolved!**

---

## 📊 Git History Visualization

```
*   24ee90e (HEAD -> main) Merge feature-api into main (resolved conflicts)
|\  
| * 93ee694 (feature-api) feat: Add REST API endpoints (Developer 2)
* | 6bdd50e (feature-login) feat: Add login and logout functionality (Developer 1)
|/  
* 3aa89de docs: Add execution summary
* 36035a5 docs: Add comprehensive quickstart guide
* 464e992 feat: Complete Lab 8 setup with real dataset
```

**Branch Structure:**
```
main
├── feature-login (Developer 1)
└── feature-api (Developer 2)
```

---

## ✅ Learning Outcomes

### 1. **Branching Strategy**
- ✓ Each developer works on isolated feature branch
- ✓ Main branch remains stable during development
- ✓ Features can be developed in parallel

### 2. **Merge Conflicts**
- ✓ Conflicts occur when same file sections are modified
- ✓ Git cannot automatically resolve overlapping changes
- ✓ Manual intervention required to combine changes

### 3. **Conflict Resolution**
- ✓ Identify conflict markers in files
- ✓ Understand both developers' intentions
- ✓ Combine changes logically
- ✓ Test resolved code before committing

### 4. **Collaboration Best Practices**
- ✓ Use descriptive commit messages
- ✓ Keep branches focused on single features
- ✓ Communicate with team about changes
- ✓ Review code before merging

---

## 🎉 Final Status

| Item | Status |
|------|--------|
| Feature Branches Created | ✅ 2 branches |
| Merge Conflicts Encountered | ✅ 1 conflict |
| Conflicts Resolved | ✅ Successfully |
| Features Integrated | ✅ Both features working |
| Git History Clean | ✅ Proper commit messages |

---

## 🚀 How to Verify

### 1. Check Git Branches
```bash
git branch -a
```

### 2. View Git History
```bash
git log --oneline --graph --all
```

### 3. View Conflict Resolution
```bash
git show 24ee90e
```

### 4. Test the Application
```bash
source .venv/bin/activate
python housepk_app.py

# Test endpoints:
# - http://127.0.0.1:5000/login (Developer 1)
# - http://127.0.0.1:5000/api/v1/health (Developer 2)
# - http://127.0.0.1:5000/api/v1/features (Developer 2)
```

---

## 📝 Key Git Commands Used

```bash
# Create and switch to branch
git checkout -b <branch-name>

# Stage changes
git add <file>

# Commit changes
git commit -m "message"

# Switch branches
git checkout <branch-name>

# Merge branches
git merge <branch-name>

# View status
git status

# View history
git log --oneline --graph --all
```

---

## 💡 Conclusion

This demonstration successfully showcases:
1. ✅ **Parallel Development**: Two developers working simultaneously
2. ✅ **Feature Isolation**: Changes isolated in separate branches
3. ✅ **Merge Conflict**: Realistic conflict scenario
4. ✅ **Conflict Resolution**: Manual resolution combining both features
5. ✅ **Clean Integration**: Both features now work together in main branch

**The collaborative Git workflow is now fully demonstrated with visible commit history showing branches, merges, and conflict resolution!** 🎊
