function configure(this)
%CONFIGURE  Unpack the simulator options into a valid configuration.

this.configuration.patients = {};
this.configuration.primaryControllers = {};
this.configuration.secondaryControllers = {};
this.configuration.resultsManagers = {};

%% Configure virtual population.
for i = 1:numel(this.options.virtualPatients)
    patientClass = this.options.virtualPatients{i}{1};
    mealClass = this.options.virtualPatients{i}{2};
    exerciseClass = this.options.virtualPatients{i}{3};
    primaryControllerClass = this.options.virtualPatients{i}{4};
    secondaryControllerClass = [];
    if numel(this.options.virtualPatients{i}) >= 5
        secondaryControllerClass = this.options.virtualPatients{i}{5};
    end
    
    %% Configure meal plan.
    if iscell(mealClass)
        if numel(mealClass) >= 1
            options = mealClass{2};
            eval(['mealPlan = ', mealClass{1}, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ...
                ', options);']);
        else
            eval(['mealPlan = ', mealClass{1}, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ');']);
        end
    else
        eval(['mealPlan = ', mealClass, '(', ...
            num2str(this.options.simulationStartTime), ', ', ...
            num2str(this.options.simulationDuration), ', ', ...
            num2str(this.options.simulationStepSize), ');']);
    end
    
    %% Configure exercise plan.
    if iscell(exerciseClass)
        if numel(exerciseClass) >= 1
            options = exerciseClass{2};
            eval(['exercisePlan = ', exerciseClass{1}, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ...
                ', options);']);
        else
            eval(['exercisePlan = ', exerciseClass{1}, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ');']);
        end
    else
        eval(['exercisePlan = ', exerciseClass, '(', ...
            num2str(this.options.simulationStartTime), ', ', ...
            num2str(this.options.simulationDuration), ', ', ...
            num2str(this.options.simulationStepSize), ');']);
    end
    
    %% Configure virtual patient.
    if iscell(patientClass)
        if numel(patientClass) >= 1
            options = patientClass{2};
            eval(['this.configuration.patients{end+1} = ', patientClass{1}, ...
                '(mealPlan, exercisePlan, options);']);
        else
            eval(['this.configuration.patients{end+1} = ', patientClass{1}, ...
                '(mealPlan, exercisePlan);']);
        end
    else
        eval(['this.configuration.patients{end+1} = ', patientClass, ...
            '(mealPlan, exercisePlan);']);
    end
    
    %% Configure primary controller.
    if iscell(primaryControllerClass)
        if numel(primaryControllerClass) >= 1
            options = primaryControllerClass{2};
            eval(['this.configuration.primaryControllers{end+1} = ', ...
                primaryControllerClass{1}, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ...
                ', this.configuration.patients{end}, options);']);
        else
            eval(['this.configuration.primaryControllers{end+1} = ', ...
                primaryControllerClass{1}, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ...
                ', this.configuration.patients{end});']);
        end
    else
        eval(['this.configuration.primaryControllers{end+1} = ', ...
            primaryControllerClass, '(', ...
            num2str(this.options.simulationStartTime), ', ', ...
            num2str(this.options.simulationDuration), ', ', ...
            num2str(this.options.simulationStepSize), ...
            ', this.configuration.patients{end});']);
    end
    
    %% Configure secondary controller.
    this.configuration.secondaryControllers{end+1} = [];
    if ~isempty(secondaryControllerClass)
        if iscell(secondaryControllerClass)
            if numel(secondaryControllerClass) >= 1
                options = secondaryControllerClass{2};
                eval(['this.configuration.secondaryControllers{end} = ', ...
                    secondaryControllerClass{1}, '(', ...
                    num2str(this.options.simulationStartTime), ', ', ...
                    num2str(this.options.simulationDuration), ', ', ...
                    num2str(this.options.simulationStepSize), ...
                    ', this.configuration.patients{end}, options);']);
            else
                eval(['this.configuration.secondaryControllers{end} = ', ...
                    secondaryControllerClass{1}, '(', ...
                    num2str(this.options.simulationStartTime), ', ', ...
                    num2str(this.options.simulationDuration), ', ', ...
                    num2str(this.options.simulationStepSize), ...
                    ', this.configuration.patients{end});']);
            end
        else
            eval(['this.configuration.secondaryControllers{end} = ', ...
                secondaryControllerClass, '(', ...
                num2str(this.options.simulationStartTime), ', ', ...
                num2str(this.options.simulationDuration), ', ', ...
                num2str(this.options.simulationStepSize), ...
                ', this.configuration.patients{end});']);
        end
    end
    
    %% Configure results manager.
    if iscell(this.options.resultsManager)
        eval(['this.configuration.resultsManagers{end+1} = ', ...
            this.options.resultsManager{1}, '(', ...
            num2str(this.options.simulationStartTime), ', ', ...
            num2str(this.options.simulationDuration), ', ', ...
            num2str(this.options.simulationStepSize), ', ', ...
            'this.configuration.patients{end}, ', ...
            'this.configuration.primaryControllers{end}, ', ...
            'this.configuration.secondaryControllers{end});']);
    else
        eval(['this.configuration.resultsManagers{end+1} = ', ...
            this.options.resultsManager, '(', ...
            num2str(this.options.simulationStartTime), ', ', ...
            num2str(this.options.simulationDuration), ', ', ...
            num2str(this.options.simulationStepSize), ', ', ...
            'this.configuration.patients{end}, ', ...
            'this.configuration.primaryControllers{end}, ', ...
            'this.configuration.secondaryControllers{end});']);
    end
end

%% Configure results manager options.
this.resultsManagerOptions = [];
if iscell(this.options.resultsManager) && numel(this.options.resultsManager) >= 1
    this.resultsManagerOptions = this.options.resultsManager{2};
end

%% Configure parallel execution.
if this.options.parallelExecution ~= true
    this.options.parallelExecution = false;
end

%% Configure interactive simulation.
if this.options.interactiveSimulation ~= true
    this.options.interactiveSimulation = false;
end

if this.options.interactiveSimulation
    this.simulationTime = this.options.simulationStartTime;
end

end

