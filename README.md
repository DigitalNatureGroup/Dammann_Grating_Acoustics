
# Multi-Focus Acoustic Field Generation using Dammann Gratings for Phased Array Transducers

This repository contains the MATLAB scripts and resources used for the experiments and analysis presented in the paper:

**Fushimi, Tatsuki, and Yusuke Koroyasu. "Multi-focus acoustic field generation using Dammann gratings for phased array transducers." Results in Physics (2024): 108040.**

The study explores the generation of multi-focus acoustic fields using Dammann gratings applied to phased array transducers. It demonstrates the feasibility of controlled multi-focus field manipulation and validates the configurations with a conventional 16×16 transducer array.

---

## Repository Structure

```
├── codes/                   # Utility scripts and functions
├── visual_damman/           # Output data and visualizations for generated fields
├── selected_traps/          # Visualizations and data for selected configurations
├── transfer2pat.mat         # Data of selected configurations for further analysis
├── trans_x.csv              # Transducer x-coordinates
├── trans_y.csv              # Transducer y-coordinates
├── trans_z.csv              # Transducer z-coordinates
├── step_1_all_sweep_analyze_2d.m    # Step 1 script
├── step_2_analysis_sweep_2d.m       # Step 2 script
├── step_3_analysis_sweep_2d_pat.m   # Step 3 script (16x16 array validation)
├── step_4_translate_rotate.m        # Step 4 script
├── common_parameters.m      # Script for shared simulation parameters
└── README.md                # This file
```

---

## Usage Instructions

### Prerequisites

- MATLAB installed with the necessary toolboxes:
  - Signal Processing Toolbox
  - Image Processing Toolbox
- Add the `codes/` directory to your MATLAB path:
  ```matlab
  addpath('codes/')
  ```

---

### Step-by-Step Workflow

#### **Step 1: Sweep Analysis**
File: `step_1_all_sweep_analyze_2d.m`

- **Objective:** Generate Dammann gratings for various configurations (`x1`, `x2`) and calculate the resulting acoustic pressure and phase fields.
- **Key Outputs:**
  - Pressure (`abs(p1)`) and phase (`angle(p1)`) visualizations saved in `visual_damman/` as `.png` files.
  - Raw field data saved as `.mat` files for further analysis.
- **How to Run:**
  ```matlab
  step_1_all_sweep_analyze_2d
  ```

#### **Step 2: Sweep Data Analysis**
File: `step_2_analysis_sweep_2d.m`

- **Objective:** Analyze the fields generated in Step 1, filter out invalid configurations, and identify promising setups based on:
  - Local pressure maxima.
  - -3dB ranges.
  - Threshold limits relative to `pmax`.
- **Key Outputs:**
  - Scatter plots for trap counts and peak intensities (`fig_allsweep_trap_n.pdf`, `fig_allsweep_trap_p.pdf`).
  - Invalid configurations stored in `nan_coordinates`.
- **How to Run:**
  ```matlab
  step_2_analysis_sweep_2d
  ```

#### **Step 3: Validate Selected Configurations with a Conventional 16×16 Array**
File: `step_3_analysis_sweep_2d_pat.m`

- **Objective:** Validate the selected configurations (`best_comb_trap`) derived in Step 2 using a **standard 16×16 transducer array**.
- **Key Outputs:**
  - Pressure (`hot` colormap) and phase (`jet` colormap) visualizations saved in `selected_traps/` as `.png` files.
  - Peak pressure data for each configuration saved in `selected_trap_n_*.csv`.
- **How to Run:**
  ```matlab
  step_3_analysis_sweep_2d_pat
  ```

#### **Step 4: Apply Spatial Transformations**
File: `step_4_translate_rotate.m`

- **Objective:** Evaluate the robustness of selected configurations under spatial transformations (translation and rotation).
- **Key Outputs:**
  - Transformed pressure and phase field visualizations saved in `selected_traps/` as `.png` files.
- **How to Run:**
  ```matlab
  step_4_translate_rotate
  ```

---

### Key Functions and Utilities

- **`findpeaks2D.m`**: Identifies local maxima in 2D matrices.
- **`generate_damman.m`**: Generates Dammann gratings based on input parameters.
- **`pressure_calc_2d.m`**: Calculates the acoustic pressure field from the phase mask.
- **`pre_pressure_calc_2d_pat.m`**: Pre-computes parameters for efficient field simulations.

---

### Reproducibility

1. Generate the initial dataset:
   ```matlab
   step_1_all_sweep_analyze_2d
   ```
2. Analyze and filter the results:
   ```matlab
   step_2_analysis_sweep_2d
   ```
3. Validate with the 16×16 array:
   ```matlab
   step_3_analysis_sweep_2d_pat
   ```
4. Apply spatial transformations:
   ```matlab
   step_4_translate_rotate
   ```

---

### Citation

If you use this repository, please cite the original paper:

```
@article{fushimi2024multifocus,
  title={Multi-focus acoustic field generation using Dammann gratings for phased array transducers},
  author={Fushimi, Tatsuki and Koroyasu, Yusuke},
  journal={Results in Physics},
  year={2024},
  volume={26},
  pages={108040},
  doi={10.1016/j.rinp.2024.108040}
}
```

---

### Contact

For questions or feedback, please contact:  
**Dr. Tatsuki Fushimi**  
**R&D Center for Digital Nature, University of Tsukuba**  
Email: tatsuki@levitation.engineer
