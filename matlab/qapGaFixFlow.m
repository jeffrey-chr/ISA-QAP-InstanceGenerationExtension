function [insts,iters] = qapGaFixFlow(target, model, features, params)
%GENERATORUNSTRUCTURED
% Genetic representation: Position of locations
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

    if ~isfield(params, 'flows')
        throw(-1);
    else
        flows = params.flows;
    end
    
    % Maximum problem data value
    maxvalue = 1000;
    
    % Bounds on ga variables
    lb = zeros(1,2*n);
    ub = maxvalue*ones(1,2*n);
    %intcon = 1:2*n^2;
    intcon = [];

    x0 = randi(maxvalue,gapop,2*n);
    
    options = optimoptions('ga', 'PopulationSize', gapop, 'InitialPopulationMatrix', x0, 'PlotFcn', @gaplotscores, 'MaxGenerations', gagen);

    [~,~,~,output,population,scores] = ga(@(x) qapObjectiveFixFlow(x,target,model,features,flows), 2*n, [], [], [], [], lb, ub, [], intcon, options);
    
    %mat1 = reshape(x(1:n^2), n, n);
    %mat2 = reshape(x((n^2+1):2*n^2), n, n);
    
    iters = output.generations;
    insts = population;
    [~,tmp] = sort(scores);
    insts = insts(tmp(1:params.instPerTarget),:);
    
end

