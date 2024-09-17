function [obj] = qapObjectiveFixDist(x,otherparams,flowgen,distfixed,target,model,features)
%Q Summary of this function goes here
%   Detailed explanation goes here

    %n = size(distfixed,1);

    % generate several instances

    nToGen = otherparams.nToGen;
    nToPick = otherparams.nToPick;

    values = Inf*ones(nToGen,1);

    for i = 1:nToGen
        flow = flowgen(x);

        point = qap2proj(distfixed,flow,model,features);

        values(i) = norm(point - target);
    end

    % pick the best ones and set objective value of this generator
    svalues = sort(values);
    best = svalues(1:nToPick);

    obj = mean(best);


end

