# Bachelor Thesis Overview

## Background

The condition monitoring of plain bearings is crucial for identifying critical operating states such as mixed and boundary friction in real time. Key factors in this process are the maximum temperature of the lubricant film (T_max) and the minimum lubrication film thickness (h_min). 

Traditionally, h_min is determined by directly measuring the distance between the shaft and the bearing. However, recent studies have shown that h_min can be determined based on the position of T_max, which eliminates the need for distance sensors and significantly reduces costs. This method is based on the Gümbel curve, documented in DIN 31652, and is currently limited to stationary or quasi-stationary operating conditions.

### Objective

My bachelor thesis is part of a series of research projects developing a self-sustaining plain bearing with an integrated, temperature-based monitoring system. The system is powered by thermoelectric generators, enabling its use in industrial applications without special adaptations. My focus is to investigate whether machine learning methods can reduce the number of sensors required without compromising prediction accuracy.

### Methodology

The training data for this project comes from experiments simulating various operating conditions. Both MATLAB and machine learning techniques are employed to:
- Collect and analyze data
- Develop models to predict T_max and h_min
- Evaluate the efficiency and accuracy of the models

**Remarks**: 
- Live Scripts marked with (**EN**) = complete English translation
- Live Scripts marked with (**CN**) = for the most part in Chinese
- **The data are copyright reserved and therefore not uploaded**

## Stage 1: Preprocess & Explore

Live Scripts: 
- batch_import_n_preprocess (EN)
- Spontanversagen_Analysis (CN)

functions: preprocess, testplan_visualization, timeCrossSection_animation, maxT_position_animation

### 1.1 Automatic Import & Preprocessing

The Excel tables are automatically imported into a MATLAB structure array, with systematically renamed variables to address any inconsistencies. A descriptive field is added to this structure array.

### 1.2 Visualization of Measurement Data

- Test plan
- Temperature curve profiles at each time cross-section (time cross-section animation)
- Changes in the position of the maximum temperature over time (maxT_position_animation)

*Example: Test Plan for the experiment data_10MPa_1.00h_Oil_60_deg_Stepped*
![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/1dcd5bdc-db94-47a5-9513-12f8d515d70a)

*Example: Animation of the changes in position of the maximum temperature over time*

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/8174a08c-f0d9-4f10-9140-2b8d4eec439e)

### 1.3 Analysis and Possible Explanations

The **measurements from the first five sensors** are primarily influenced by the inlet temperature of the lubricant oil. When the inlet oil temperature is higher than the initial temperature of the bearing (room temperature), the system requires time to reach thermal equilibrium. During this period, the highest temperature is consistently recorded by the sensor closest to the oil inlet.

In all experiments, **the position of the maximum temperature fluctuates between non-adjacent sensors**, indicating a double-peak shape in the temperature curve, contrary to theoretical expectations. This anomaly was traced back to a specific sensor that consistently recorded lower values, thereby affecting the position of the maximum temperature.

## Stage 2: Data Filtering
Live Script:
- data_filtration (EN)

functions: avgT_changeRate, positionFilter

### 2.1 Exclusion of Non-Stationary Points

Points where the rate of change of T_mean exceeds a threshold are excluded.

*Example: The rate of change of T_mean for the experiment data_10MPa_1.00h_Oil_60_deg_Stepped*
![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/e3a0f676-737f-494d-8783-ed029fc1c631)

### 2.2 Exclusion of Unusable Points

Points where the position of the maximum temperature lies outside the evaluable range are excluded.

*Example: Test Plan after complete filteration for the experiment data_10MPa_1.00h_Oil_60_deg_Stepped*
![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/39d6964e-4238-437e-910a-eca424a42819)

## Stage 3: Polynomial Fitting

Live Scripts:
1. choose_polyfit (EN)
2. fit_processed_data (CN)
3. fitted_visualization (EN)

functions: adj_R2_polyfit, selectRows

### 3.0 Motivation

Due to the wide spacing between sensors (7.5 degrees between adjacent sensors), determining h_min without interpolation is unrealistic. In addition, the values measured by each sensor may not be accurate, since they were all manually calibrated to improve the performance. Polynomial interpolation therefore is necessary to obtain precise values. 

*Determinable h_min based entirely on measurable T_max positions without applying any interpolation*
![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/e7253f84-f4b7-461d-88aa-9950f924e8b2)

### 3.1 Selection of Suitable Polynomials

Polynomials of degrees 3 to 8 are tested and selected based on the adjusted R^2. Even-degree polynomials are preferred due to their symmetry matching the shapes of the temperature curves.

The results indicate that 

- for Sommerfeld numbers So < 14, polynomials of degree 4 or higher can adequately represent the curve;
- for Sommerfeld numbers ≥ 14, however, polynomials of degree 6 or higher are more suitable.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/3fdb9d5c-2b63-49a6-9299-d0a0d4d764dc)

### 3.2 Fitting of Temperature Curves with 6th Degree Polynomials

To determine accurate T_max values and positions, curve fitting with 6th degree polynomials is performed.

## Stage 4: Data Preparation

Live Scripts:
1. data_preparation (CN)
2. derived_quantities (CN)

functions: beta_to_epsilon, epsilon_to_beta, epsilon_to_hmin, hmin_to_epsilon, beta_to_hmin, hmin_to_beta, Sommerfeld, viscosity 

### 4.0 Defining the Problem

The Problem can be devided into two parts:
1. Prediction of the T_max value and
2. Prediction of the T_max position,

with the accuracy of second task being more important.

**Objective**:
Investigating whether the use of machine learning algorithms can reduce the number of required sensors while maintaining prediction accuracy, and determining which sensor positions should be retained.

**Constraints**:
- Only the measured temperature data is available to the bearing. Thus, **for the first task**, the only input is sensor data, while **for the second task**, the result of the first task (T_max value) can also act as input. Note it has been confirmed at a later stage that T_max actually is *the most* important predictor for the second task, indicating an **strong interconnection between the two tasks**.
- Due to **energy constraints**, available models are reduced to the ones that only require minimal computational effort: linear models, decision trees, ensembles of trees.
- Only stationary or quasi-stationary (constant angular velocity for all moving parts) operating points can be used for modeling.

**Definition of acceptable prediction accuracy**: 

The h_min values determined by the model should not deviate too much from the actual values. (How far is too far? Not yet determined. Current criterion: most deviations within ±1 micrometer).

### 4.1 Encoding Relevant Relationships from DIN 31652 into MATLAB Functions

beta_to_epsilon, epsilon_to_beta, epsilon_to_hmin, hmin_to_epsilon, beta_to_hmin, hmin_to_beta, Sommerfeld, viscosity 

### 4.2 Constructing Datasets for Both Tasks

- Predictors/Features for Task 1: Sensor data.
- Predictors/Features for Task 2: Sensor data + (for the moment) the *precise value* of T_max (as a placeholder for initial analyses, to be replaced later by a predicted value for a given sensor combination).

## Stage 5: Perform Regression

Remark: Not yet fully completed.

Live Scripts:
1. characteristics (EN)
2. best_subset_selection (EN) to be updated

### 5.1 Preliminary Selection & Upper bound on Model Complexity

Use MATLAB's Regression Learner App to evaluate the three candidate model types by using various levels of preset flexiblilities.

**Results**:

- The best linear model has a validation mean squared error (MSE) an order of magnitude lower than the second-best model (ensemble tree model), indicating that **linear models are best suited for the task**.
- There is almost no improvement between a linear model with interaction and lower-order terms and a linear model with quadratic and lower-order terms. This indicates that **terms higher than second-order are unnecessary for the linear model**.

### 5.2 How relevant is T_max for the second Task?

By fitting a linear model with quadratic (and lower-order) terms, and rank all predictors by their mean absolute Shaplay value, it can be shown that the feature "T_max" is several times more important than any other feature.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/5ad28b62-3307-46f8-9045-a48d13adbe82)

### 5.3 Investigation of Sensitivity of Both Tasks to the Number and Placement of the Sensors

The order by which sensor elimination is performed is generated randomly for a bunch of times. Then the 10-fold cross-validated MSE is calculated and plotted for each case.

The results show that:

**For the First Task**:
- The prediction of the T_max value is relatively insensitive to sensor placement. There is a clear decreasing trend in validation RMSE with an increasing number of sensors, regardless which sensors are chosen.
- High accuracy (RMSE < 0.05 °C) is easily achievable.

**For the Second Task**:
- The prediction of the T_max position is sensitive to sensor placement. Adding certain sensors can significantly improve accuracy.
- High accuracy (RMSE < 1 °) is difficult to achieve.

**Therefore**, the optimization of sensor quantity and placement should be oriented on the accuracy of the second task.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/aa906c64-1e85-4a3e-89cd-45a503a50773)

### 5.4 Optimal Sensor Selection for Every Possible Number of Sensors

Due to the small number of sensors, the "Optimal Subset Selection Algorithm" can be employed to determine *the best* possible sensor combination. For each potential number of retained sensors, all possible combinations are evaluated. The combination that produces the minimum cross-validation MSE for the second task is selected. The model used for both tasks is a linear model with quadratic and lower-order terms.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/a9f27b76-efd1-4297-b4e5-2550c858a246)

### 5.5 Evaluate the effect of eliminating of Statistically Insignificant Terms

This can be easily implemented by replacing the fitlm(...,'quadratic') function in the Best Subset Selection program with the stepwiselm(...,'quadratic','Upper','quadratic') function. [Still Running]

### 5.6 Determining Optimal Sensor Quantity and Placement

This depends on the definition of acceptable prediction accuracy. See Section 4.0. [Not yet determined]

*Example: Graphic evaluation of the results for five retained sensors from 5.4*
![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/c9f93871-d37e-4a93-843d-fa7ffdc474de)

### 5.7 Interpretation of the chosen Model

This can be achieved by ranking the features (= sensors) according to their Mean Absolute Shapley Values. [To be done]
