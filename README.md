# ENGR 330 – Test 2: Adder Comparison Project
### Author: Jampal Penortsang
### Instructor: Dr. Hassan Salamy

---

## Project Overview
This project implements and compares three different adder architectures in **SystemVerilog**:
- **Ripple-Carry Adder (RCA)**  
- **Carry-Lookahead Adder (CLA)**  
- **Prefix Adder (Brent–Kung style)**  

Each adder is parameterized for multiple bit-widths (8, 16, 32, 64).  
The project also includes a **SystemVerilog testbench** for verification and a **results report** summarizing simulation and synthesis findings.

---

## Project Structure
adder-Test2/
│
├── adder_rtl/
│ ├── rca.v # Ripple-Carry Adder
│ ├── cla.v # Carry-Lookahead Adder
│ └── prefix.v # Prefix Adder
│
├── tb/
│ └── tb_adders.v # Testbench for all adders
│
├── results/
│ └── results.md # Simulation and synthesis report
│
└── README.md # Project documentation
---

## Vivado Simulation Instructions
1. Open **Vivado 2018.2**
2. Create a new project → **Add Simulation Sources**
3. Add the following files:
   - `adder_rtl/rca.v`
   - `adder_rtl/cla.v`
   - `adder_rtl/prefix.v`
   - `tb/tb_adders.v`
4. Set `tb_adders` as the **top module**
5. Run **Behavioral Simulation**
6. View the simulation console for `PASS/FAIL` outputs

---

## Design Summary

| Adder Type | Propagation Delay | Area (gates) | Structure Type |
|-------------|------------------|---------------|----------------|
| RCA | High | Low | Serial |
| CLA | Medium | Medium | Parallel Block |
| Prefix | Low | High | Logarithmic |

---

## Testing
The `tb_adders.v` testbench automatically verifies each adder across 10 randomized test vectors per bit-width (8, 16, 32, 64).  
Expected output prints to the simulation console in Vivado.

---

## Git Workflow & Version Control

This project follows the **Gitflow branching model**, as required by the assignment.

### Branches Used
- `main` → final, stable release branch  
- `develop` → integration/testing branch  
- `feat/rca` → ripple-carry adder development  
- `feat/cla` → carry-lookahead adder development  
- `feat/prefix` → prefix adder development  

---

### Workflow Steps (Recorded for Documentation)

```bash
# 1. Initialize local repo and connect to GitHub
git init
git remote add origin https://github.com/<your-username>/adder-Test2.git

# 2. Create main and develop branches
git branch -M main
git checkout -b develop

# 3. Implement RCA feature
git checkout -b feat/rca
git add adder_rtl/rca.v
git commit -m "feat(rca): implement parameterized ripple-carry adder"
git push -u origin feat/rca
# (PR or merge into develop)

# 4. Implement CLA feature
git checkout -b feat/cla
git add adder_rtl/cla.v
git commit -m "feat(cla): implement 4-bit block carry-lookahead adder"
git push -u origin feat/cla
# (PR or merge into develop)

# 5. Implement Prefix Adder
git checkout -b feat/prefix
git add adder_rtl/prefix.v
git commit -m "feat(prefix): add parameterized prefix adder"
git push -u origin feat/prefix
# (PR or merge into develop)

# 6. Merge features into develop and test
git checkout develop
git merge feat/rca
git merge feat/cla
git merge feat/prefix
git push

# 7. Merge develop into main and tag release
git checkout main
git merge develop
git tag -a v1.0 -m "Adder Test 2 submission v1.0"
git push origin main --tags
| Commit #       | Message                                                 | Description                      |
| -------------- | ------------------------------------------------------- | -------------------------------- |
| 1              | `chore(project): initialize repo and folder structure`  | Initial project setup            |
| 2              | `feat(rca): implement parameterized ripple-carry adder` | Added RCA design                 |
| 3              | `feat(cla): implement carry-lookahead adder`            | Added CLA design                 |
| 4              | `feat(prefix): add prefix adder (Brent–Kung)`           | Added Prefix design              |
| 5              | `test(tb): add verification testbench and results`      | Added testbench and results file |
| 6 *(optional)* | `docs(readme): add Git workflow and final notes`        | Documentation update             |
| Final          | `release(v1.0): final submission version tag`           | Tagged release for grading       |
