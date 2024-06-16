function [trainedModel,validationRMSE,validationMSE] = train_Tp_model(trainingTbl,idx_selected_predictors)
% fitlm(...,"quadratic","RobustOpts","off"), 10 fold cross validation

% Extract predictors and response
% This code processes the data into the right shape for training the model.
inputTable = trainingTbl;
predictorNames = {'180', '187.5', '195', '202.5', '210', '217.5', '225', '232.5', '240', '247.5', '255', '262.5', '270' , 'T_value'};
predictorNames = predictorNames(idx_selected_predictors); % 选用其中部分
predictors = inputTable(:, predictorNames);
response = inputTable.T_position;

% Train a regression model
% This code specifies all the model options and trains the model.
concatenatedPredictorsAndResponse = predictors;
concatenatedPredictorsAndResponse.T_position = response;
linearModel = fitlm(...
    concatenatedPredictorsAndResponse, ...
    'quadratic', ...
    'RobustOpts', 'off');

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
linearModelPredictFcn = @(x) predict(linearModel, x);
trainedModel.predictFcn = @(x) linearModelPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedModel.RequiredVariables = predictorNames; % 更改
trainedModel.LinearModel = linearModel;
trainedModel.About = 'This struct is a trained model exported from Regression Learner R2024a.';
trainedModel.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Perform cross-validation
KFolds = 10;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% Initialize the predictions to the proper sizes
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    

    % Train a regression model
    % This code specifies all the model options and trains the model.
    concatenatedPredictorsAndResponse = trainingPredictors;
    concatenatedPredictorsAndResponse.T_position = trainingResponse;
    linearModel = fitlm(...
        concatenatedPredictorsAndResponse, ...
        'quadratic', ...
        'RobustOpts', 'off');

    % Create the result struct with predict function
    linearModelPredictFcn = @(x) predict(linearModel, x);
    validationPredictFcn = @(x) linearModelPredictFcn(x);

    % Add additional fields to the result struct

    % Compute validation predictions
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);

    % Store predictions in the original order
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% Compute validation RMSE
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));

% Compute validaton MSE
validationMSE = validationRMSE^2;
