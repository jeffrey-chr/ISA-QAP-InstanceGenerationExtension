function [insts, iters] = qapGaStutzleGenerator(target, model, features, params)
%QAPGASTUTZLEGENERATOR
% Genetic representation: Parameters for QAP generating algorithm proposed
% by Stutzle and Fernandes.
% Fitness function: Generate 50 instances using parameters specified by the
% genetic representation, take the average distance to the target point of
% the best 10 instances.
% Initial population: Uniform random distribution within reasonable
% settings for each parameter

    if nargin < 5
        params = struct;
    end

    % Population for genetic algorithm
    if ~isfield(params, 'gapop')
        gapop = 20;
    else
        gapop = params.gapop;
    end
        
    % Number of generations. In order to generate an interesting variety of
    % instances you might not want this to be too large. Experiment to find
    % good values for all these parameters.
    if ~isfield(params, 'gagen')
        gagen = 10;
    else
        gagen = params.gagen;
    end
    
    % Size of instances to be generated
    if ~isfield(params, 'instsize')
        n = 30;
    else
        n = params.instsize;
    end
    
    % Bounds on ga variables
    lb = [ceil(n/10), 20, 200, 10, 10, 0.5, 0.001 ] ;
    ub = [ceil(2*n/3), 100, 400, 200, 200, 2, 0.2 ] ;
    intcon = [1,2,3];
    
    objparams = struct;
    objparams.n = n;

    options = optimoptions('ga','PopulationSize', gapop, 'PlotFcn', @gaplotscores, 'MaxGenerations', gagen);

    [x,~,~,output,~,~] = ga(@(x) qapObjectiveStutzle(x,target,model,features,objparams), 2*n^2, [], [], [], [], lb, ub, [], intcon, options);
    
    iters = output.generations;
    insts = zeros(10,2*n^2);
    
    % Generate 10 instances with the winning parameters.
    for i = 1:10
        dist = genDistEuclidean(n,x(1),x(2),x(3));
        flow = genFlowStructuredPlus(n,x(4),x(5),x(6),x(7));
        insts(i,:) = [dist(:)',flow(:)'];
    end
    
end

