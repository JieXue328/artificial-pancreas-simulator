%MULTIPATIENTSIM  Example of the artificial pancreas simulator for multiple
% random simulations.
run('../configurePaths');

% Make sure all paths are set correctly
options = SimulatorOptions;
options.simulationDuration = 24 * 60; % minutes
options.simulationStartTime = 8 * 60; % minutes
options.simulationStepSize = 10; % minutes
options.parallelExecution = true;
options.resultsManager = {'PublishResultsManager', struct('summary', true)};

% Define a structure holding options for HovorkaPatient
optPatient.patient = {'patient0'};
optPatient.intraVariability = 0.1;
optPatient.mealVariability = 0.5;
optPatient.sensorNoiseType = 'AR(1)';
optPatient.sensorNoiseValue = 0.07;
optPatient.useTreatments = true;
optPatient.randomInitialConditions = true;

% Define a structure holding options for RandomMealPlan
optMeal.name = 'myRandomMeals';
optMeal.dailyCarbsMax = 240;
optMeal.dailyCarbsMin = 180;
optMeal.plan.breakfast = struct('enabled', true, ...
    'time', [8, 9]*60, ...
    'value', [40, 60], ...
    'glycemicLoad', 15, ...
    'announcedFraction', 1);
optMeal.plan.snackMorning = struct('enabled', false, ...
    'time', [], ...
    'value', [], ...
    'glycemicLoad', 1, ...
    'announcedFraction', 0);
optMeal.plan.lunch = struct('enabled', true, ...
    'time', [12, 13]*60, ...
    'value', [60, 100], ...
    'glycemicLoad', 15, ...
    'announcedFraction', 1);
optMeal.plan.snackAfternoon = struct('enabled', true, ...
    'time', [14, 15]*60, ...
    'value', [15, 25], ...
    'glycemicLoad', 5, ...
    'announcedFraction', 0);
optMeal.plan.dinner = struct('enabled', true, ...
    'time', [17, 19]*60, ...
    'value', [40, 70], ...
    'glycemicLoad', 15, ...
    'announcedFraction', 1);
optMeal.plan.snackNight = struct('enabled', true, ...
    'time', [20.5, 21.5]*60, ...
    'value', [20, 30], ...
    'glycemicLoad', 5, ...
    'announcedFraction', 0);

% Set rng for reproducibility
rng(777);

% Define a virtual patients
options.virtualPatients = {};
for pID = 1:16
    % Set specific name
    optPatient.name = ['P', num2str(pID, '%03d')];
    
    % For reproducibility
    optPatient.RNGSeed = pID;

    % Set virtual patient options
    options.virtualPatients{pID} = { ...
        {'HovorkaPatient', optPatient}, ...
        {'RandomMealPlan', optMeal}, ...
        'EmptyExercisePlan', ...
        'PumpTherapy'};
end

% Simulate
simulator = ArtificialPancreasSimulator(options);
simulator.simulate();
