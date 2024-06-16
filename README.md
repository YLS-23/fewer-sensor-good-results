### Bachelor Thesis Overview

## Background

The condition monitoring of plain bearings is crucial for identifying critical operating states such as mixed and boundary friction in real time. Key factors in this process are the maximum temperature of the lubricant film (T_max) and the minimum lubrication film thickness (h_min). 

Traditionally, h_min is determined by directly measuring the distance between the shaft and the bearing. However, recent studies have shown that h_min can be determined based on the position of T_max, which eliminates the need for distance sensors and significantly reduces costs. This method is based on the Gümbel curve, documented in DIN 31652, and is currently limited to stationary or quasi-stationary operating conditions.

# Objective of the Bachelor Thesis

My bachelor thesis is part of a series of research projects developing a self-sustaining plain bearing with an integrated, temperature-based monitoring system. The system is powered by thermoelectric generators, enabling its use in industrial applications without special adaptations. My focus is to investigate whether machine learning methods can reduce the number of sensors required without compromising prediction accuracy.

# Methodology

The training data for this project comes from experiments simulating various operating conditions. Both MATLAB and machine learning techniques are employed to:
- Collect and analyze data
- Develop models to predict T_max and h_min
- Evaluate the efficiency and accuracy of the models

**Remarks**: 
Live Scripts marked with (EN) = complete English translation
Live Scripts marked with (CN) = for the most part in Chinese
All functions have Chinese comments 

## Stage 1: Preprocess & Explore
Live Scripts: 
- batch_import_n_preprocess (EN)
- Spontanversagen_Analysis (CN)
functions:
- preprocess
- testplan_visualization
- timeCrossSection_animation
- maxT_position_animation

## Stage 2: Data Filtering
Live Script:
- data_filtration (EN)
functions:
- avgT_changeRate
- positionFilter

## Stage 3: Polynomial Fitting
Live Scripts:
1. choose_polyfit (EN)
2. fit_processed_data (CN)
3. fitted_visualization (EN)
functions:
- adj_R2_polyfit
- selectRows

## Stage 4: Data Preparation
Live Scripts:
1. data_preparation (CN)
2. derived_quantities (CN)
functions:
- beta_to_epsilon
- epsilon_to_beta
- epsilon_to_hmin
- hmin_to_epsilon
- beta_to_hmin
- hmin_to_beta
- Sommerfeld
- viscosity 

## Stage 5: Perform Regression
Remark: still working on it, only a small part was uploaded
Live Scripts:
1. characteristics (EN)
2. best_subset_selection (EN) to be updated
