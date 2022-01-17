function [insts,iters] = qapGaUnstructured(target, model, features, params)
%GENERATORUNSTRUCTURED
% Genetic representation: Direct representation of problem data
% Fitness function: Euclidean distance to target point
% Initial population: Based on closest instances to target point

    if nargin < 4
        params = struct;
    end

    % Population for genetic algorithm
    if ~isfield(params, 'gapop')
        gapop = 50;
    else
        gapop = params.gapop;
    end
        
    % Number of generations. In order to generate an interesting variety of
    % instances you might not want this to be too large. Experiment to find
    % good values for all these parameters.
    if ~isfield(params, 'gagen')
        gagen = 25;
    else
        gagen = params.gagen;
    end
    
    % Size of instances to be generated
    if ~isfield(params, 'instsize')
        n = 50;
    else
        n = params.instsize;
    end
    
    % Initial population random or based on reading existing instances.
    randomgen = false;
    
    % Maximum problem data value
    maxvalue = 1000;
    
    % Bounds on ga variables
    lb = zeros(1,2*n^2);
    ub = maxvalue*ones(1,2*n^2);
    intcon = 1:2*n^2;

    if randomgen
        x0 = randi(maxvalue,gapop,2*n^2);
    else
    % Find closest instances to target point and read their data files
        existingPoints = model.data.X*model.pilot.A';
        sqDistances = sum((existingPoints-target).^2,2);
        [D,II] = sort(sqDistances);
    
        x0 = -ones(gapop,2*n^2);
        for i = 1:gapop
            [mat1,mat2] = qap_readFile(strcat(params.instdir,'\ProblemData\',string(model.data.S(II(i))),'\',model.data.instlabels(II(i)),'.dat'));
            libn = size(mat1,1);

            % Bound problem data and increase or decrease matrix size so that
            % all instances have size n.

            % Note to Kelvin: Fixing the instance sizes in this way probably isn't
            % actually a good idea. Figure out what will work for your problem and
            % data set. Or just generate initial population randomly. This is
            % just to demonstrate how reading instances from your existing
            % library *could* work.
            mat1 = min(mat1,maxvalue);
            mat2 = min(mat2,maxvalue);

            if libn > n
                mat1 = mat1(1:n, 1:n);
                mat2 = mat2(1:n, 1:n);
            end

            if libn < n
                A = mat1;
                B = mat2;
                mat1 = zeros(n);
                mat2 = maxvalue*ones(n);
                mat1(1:libn,1:libn) = A;
                mat2(1:libn,1:libn) = B;
            end

            x0(i, :) = [mat1(:)',mat2(:)'];
        end
    end
    
    options = optimoptions('ga', 'PopulationSize', gapop, 'InitialPopulationMatrix', x0, 'PlotFcn', @gaplotscores, 'MaxGenerations', gagen);

    [~,~,~,output,population,scores] = ga(@(x) qapObjectiveUnstructured(x,target,model,features), 2*n^2, [], [], [], [], lb, ub, [], intcon, options);
    
    %mat1 = reshape(x(1:n^2), n, n);
    %mat2 = reshape(x((n^2+1):2*n^2), n, n);
    
    iters = output.generations;
    insts = population;
    [~,tmp] = sort(scores);
    insts = insts(tmp(1:params.instPerTarget),:);
    
end

