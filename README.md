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
- for Sommerfeld numbers So ≥ 14, however, polynomials of degree 6 or higher are more suitable.

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

#### Objective

Investigating whether the use of machine learning algorithms can reduce the number of required sensors while maintaining prediction accuracy, and determining which sensor positions should be retained.

#### Constraints
- Only the measured temperature data is available to the bearing. Thus, **for the first task**, the only input is sensor data, while **for the second task**, the result of the first task (T_max value) can also act as input. Preliminary analysis at a later stage (stage 5.2) indicates that T_max could be an important predictor for the second task, suggesting a **potential strong interconnection** between the two tasks.
- Due to **energy constraints**, available models are reduced to the ones that only require minimal computational effort: linear models, decision trees, ensembles of trees.
- Only stationary or quasi-stationary (constant angular velocity for all moving parts) operating points can be used for modeling.

#### Definition of acceptable prediction accuracy

Reliable model predictions necessitate that the predicted values of h_min align closely with the actual values, with deviations (residuals) maintained within a defined acceptable range. Given the absence of established standards regarding this application, the subsequent section will explore the criteria that this range should satisfy.

First, a **baseline for prediction accuracy** is needed for orientation, which can be established by comparing actual measurements with theoretical values. Among all experiments, measurements from the plateau case can most suitably fullfill this role, as its experimental conditions strictly adheres to the definition of stationary operating conditions. This means that after the initial phase, the position of the maximum temperature and therefore h_min would theoretically remain constant. 

The measured residuals for h_min in this case follow a bell-shaped distribution with 86.076% of the residuals falling within ±2 μm and 48.945% within ±1 μm. **This level of accuracy is however insufficient**, since the deviations come close to the lowest critical threshold for h_min, which is 3 μm.

##### Ideal Accuracy:

Ideally, there should be an order of magnitude difference between the residuals and the critical threshold, meaning that the majority of residuals, defined here as ≥ 95% in alignment with the commonly used 95% confidence interval, should fall within ±10% of the lowest threshold, i.e., 0.3 μm. 

##### Minimum Acceptable Accuracy:

If the ideal condition cannot be met, then at least 95% of all residuals should remain within ±1 μm. This would then require adjusting all critical thresholds by 1 μm in the conservative direction to avoid false assurances.

*Histogram of the measured residuals (for orientation)*

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/253cc82e-158e-4d2c-bc36-a6b4f80f0c9e)

### 4.1 Encoding Relevant Relationships from DIN 31652 into MATLAB Functions

beta_to_epsilon, epsilon_to_beta, epsilon_to_hmin, hmin_to_epsilon, beta_to_hmin, hmin_to_beta, Sommerfeld, viscosity 

### 4.2 Constructing Datasets for Both Tasks

- Predictors/Features for Task 1: Sensor data.
- Predictors/Features for Task 2: Sensor data + (for the moment) the *precise value* of T_max (as a placeholder for initial analyses, to be replaced in stage 5.4 by a predicted value for a given sensor combination).

## Stage 5: Perform Regression

Remark: Not yet fully completed.

Live Scripts:
1. characteristics (EN)
2. best_subset_selection (EN) 
3. acceptable_accuracy (CN)
4. model_interpretation (EN)

### 5.1 Preliminary Selection & Upper bound on Model Complexity

Use MATLAB's Regression Learner App to evaluate the three candidate model types by using various levels of preset flexiblilities.

**Results**:

- The best linear model has a validation mean squared error (MSE) an order of magnitude lower than the second-best model (ensemble tree model), indicating that **linear models are best suited for the task**.
- There is almost no improvement between a linear model with interaction and lower-order terms and a linear model with quadratic and lower-order terms. This indicates that **terms higher than second-order are unnecessary for the linear model**.

### 5.2 Relevance of T_max for the Second Task: Preliminary Analysis

By fitting a linear model with quadratic (and lower-order) terms and ranking all predictors by their mean absolute Shapley value, it can be shown that the feature 'T_max' is several times more important than any other feature when its true values are used. Note that in practice, 'T_max' must be predicted as the result of the first task, leading to inevitable deviations from the true values used in this analysis. Consequently, its mean absolute Shapley value and thus its importance may vary.

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

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/7a1f98e5-4f7b-4fa4-bf35-f58013e2270b)

### 5.4 Optimal Sensor Selection for Every Possible Number of Sensors

Due to the small number of sensors, the "Optimal Subset Selection Algorithm" can be employed to determine *the best* possible sensor combination. For each potential number of retained sensors, all possible combinations are evaluated. The combination that produces the minimum cross-validation MSE for the second task is selected. The model used for both tasks is a linear model with quadratic and lower-order terms.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/08810d79-9670-477f-87f4-ab565e75e452)

### 5.5 Evaluate the effect of eliminating the Statistically Insignificant Terms

Removing the statistically insignificant terms has a slight but consistent negative effect on the prediction accuracy of h_min.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/8fab8c47-7b5e-4897-80d8-46722e260aea)

### 5.6 Determining Optimal Sensor Quantity and Placement

As an intuitive representation of prediction accuracy, the proportion of residuals that fall within specific ranges is plotted against different sensor counts. The chart below illustrates the proportion of residuals that fall within ±1 μm, ±0.6 μm, and ±0.3 μm respectively when varying numbers of sensors are retained.

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/2859010a-e4b0-46a8-afc4-29f512118f7b)

It is clear that the minimum accuracy requirement is readily satisfied with any number of sensors. However, even in the best-case scenario using inputs from all 13 sensors, the ideal accuracy is not attained, with only up to 85.6% of residuals falling within ±0.3 μm. Nonetheless, with some slight relaxation of the order-of-magnitude requirement, satisfactory results can be achieved:

- Ideal accuracy requirement: For a sensor arrangement (and the corresponding model) to be considered viable, at least 95% of all residuals should fall within ±10% of the lowest threshold for h_min, i.e. ±0.3 μm.
- Slightly relaxed requirement: For a sensor arrangement (and the corresponding model) to be considered viable, at least 95% of all its residuals should fall within ±20% of the lowest threshold for h_min, i.e. ±0.6 μm.

Adopting this more lenient criterion reveals that a minimum of six sensors suffices. Previous research has confirmed that power generated thermoelectrically can sustain the operation of six temperature sensors. Consequently, the optimal sensor count is six, positioned at φ = 195°, 202.5°, 210°, 232.5°, 240°, and 262.5° respectively.

*Graphic evaluation of the results in the case of 6 retained sensors*

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/a090d7c6-4e9d-4533-ad48-243a354a699d)

### 5.7 Interpretation of the chosen Model

This can be achieved by ranking the features (= sensors) according to their Mean Absolute Shapley Values. Note that values extremely close to zero indicates that the corresponding sensor is not evaluated by the model and has therefore no effect on the prediction.

*Shapley Summary Plot in the case of 6 retained sensors*

![image](https://github.com/YLS-23/fewer-sensors-same-results/assets/172030231/10cd767b-c1c8-4d32-a712-cb483aee8e23)


