### Bachelor Thesis Overview

## Background

The condition monitoring of plain bearings is crucial for identifying critical operating states such as mixed and boundary friction in real time. Key factors in this process are the maximum temperature of the lubricant film (T_max) and the minimum lubrication film thickness (h_min). 

Traditionally, h_min is determined by directly measuring the distance between the shaft and the bearing. However, recent studies have shown that h_min can be determined based on the position of T_max, which eliminates the need for distance sensors and significantly reduces costs. This method is based on the Gümbel curve, documented in DIN 31652, and is currently limited to stationary or quasi-stationary operating conditions.

## Objective of the Bachelor Thesis

My bachelor thesis is part of a series of research projects developing a self-sustaining plain bearing with an integrated, temperature-based monitoring system. The system is powered by thermoelectric generators, enabling its use in industrial applications without special adaptations. My focus is to investigate whether machine learning methods can reduce the number of sensors required without compromising prediction accuracy.

## Methodology

The training data for this project comes from experiments simulating various operating conditions. Both MATLAB and machine learning techniques are employed to:
- Collect and analyze data
- Develop models to predict T_max and h_min
- Evaluate the efficiency and accuracy of the models

**Remarks**: 
- Live Scripts marked with (EN) = complete English translation
- Live Scripts marked with (CN) = for the most part in Chinese
- All functions have Chinese comments 

## Stage 1: Preprocess & Explore
Live Scripts: 
- batch_import_n_preprocess (EN)
- Spontanversagen_Analysis (CN)
functions:
- preprocess
- testplan_visualization
- timeCrossSection_animation
- maxT_position_animation

**1.1 Automatic Import & Preprocessing**
The Excel tables are automatically imported into a MATLAB structure array, with systematically renamed variables to address any inconsistencies. A descriptive field is added to this structure array.

**1.2 Visualization of Measurement Data**
- Test plan
- Temperature curve profiles at each time cross-section (time cross-section animation)
- Changes in the position of the maximum temperature over time (maxT_position_animation)

**1.3 Analysis and Possible Explanations**
The measurements from the first five sensors are primarily influenced by the inlet temperature of the lubricant oil. When the inlet oil temperature is higher than the initial temperature of the bearing (room temperature), the system requires time to reach thermal equilibrium. During this period, the highest temperature is consistently recorded by the sensor closest to the oil inlet.

In all experiments, the position of the maximum temperature fluctuates between non-adjacent sensors, indicating a double-peak shape in the temperature curve, contrary to theoretical expectations. This anomaly was traced back to a specific sensor that consistently recorded lower values, thereby affecting the position of the maximum temperature.

## Stage 2: Data Filtering
Live Script:
- data_filtration (EN)
functions:
- avgT_changeRate
- positionFilter

**2.1 Exclusion of Non-Stationary Points**
Points where the rate of change of T_mean exceeds a threshold are excluded.

**2.2 Exclusion of Unusable Points**
Points where the position of the maximum temperature lies outside the evaluable range are excluded.

## Stage 3: Polynomial Fitting
Live Scripts:
1. choose_polyfit (EN)
2. fit_processed_data (CN)
3. fitted_visualization (EN)
functions:
- adj_R2_polyfit
- selectRows

**3.0 Motivation**
Due to the wide spacing between sensors (7.5 degrees between adjacent sensors), determining h_min without interpolation is unrealistic. In addition, the values measured by each sensor may not be accurate, since they were all manually calibrated to improve the performance. Polynomial interpolation therefore is necessary to obtain precise values. 

**3.1 Selection of Suitable Polynomials**
Polynomials of degrees 3 to 8 are tested and selected based on the adjusted R^2. Even-degree polynomials are preferred due to their symmetry matching the shapes of the temperature curves.

The results indicate that for Sommerfeld numbers So < 14, polynomials of degree 4 or higher can adequately represent the curve.
For Sommerfeld numbers ≥ 14, however, polynomials of degree 6 or higher are more suitable.

**3.2 Fitting of Temperature Curves with 6th Degree Polynomials**

To determine accurate T_max values and positions, curve fitting with 6th degree polynomials is performed.

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

**4.0 Defining the Problem**
The Problem can be devided into two parts:
1. Prediction of the T_max value and
2. Prediction of the T_max position,
with the accuracy of second task being more important.

Objective:
Investigating whether the use of machine learning algorithms can reduce the number of required sensors while maintaining prediction accuracy, and determining which sensor positions should be retained.

Constraints:
- Only the measured temperature data is available to the bearing. Thus, **for the first task**, the only input is sensor data, while **for the second task**, the result of the first task (T_max value) can also act as input. Note it has been confirmed at a later stage that T_max actually is *the most* important predictor for the second task, indicating an strong interconnection between the two tasks.
- Due to energy constraints, available models are reduced to the ones that only require minimal computational effort: linear models, decision trees, ensembles of trees.
- Only stationary or quasi-stationary (constant angular velocity for all moving parts) operating points can be used for modeling.

Definition of acceptable prediction accuracy: The h_min values determined by the model should not deviate too much from the actual values. (current criterion: most deviations within ±1 micrometer).

**4.1 Encoding Relevant Relationships from DIN 31652 into MATLAB Functions**
beta_to_epsilon, epsilon_to_beta, epsilon_to_hmin, hmin_to_epsilon, beta_to_hmin, hmin_to_beta, Sommerfeld, viscosity 

**4.2 Constructing Datasets for Both Tasks**
- Predictors/Features for Task 1: Sensor data.
- Predictors/Features for Task 2: Sensor data + (for the moment) the *precise* value of T_max (as a placeholder for initial analyses, to be replaced later by a predicted value for a given sensor combination).

## Stage 5: Perform Regression
Remark: still working on it, only a small part was uploaded
Live Scripts:
1. characteristics (EN)
2. best_subset_selection (EN) to be updated
