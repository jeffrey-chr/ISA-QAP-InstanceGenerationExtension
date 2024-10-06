function [obj] = qapObjectiveGenBoth(x,otherparams,distgen,flowgen,target,model,features,record)
%Q Summary of this function goes here
%   Detailed explanation goes here

    %n = size(distfixed,1);

    % generate several instances

    nToGen = otherparams.nToGen;
    nToSkip = otherparams.nToSkip;
    nToPick = otherparams.nToPick;

    values = Inf*ones(nToGen,1);

    for i = 1:nToGen
        dist = distgen(x);
        flow = flowgen(x);

        point = qap2proj(dist,flow,model,features);

        values(i) = norm(point - target);

        % added = record.addIfBetter(values(i), dist, flow);
        % if added
        %     fprintf("check...\n");
        % end
    end

    % pick the best ones and set objective value of this generator
    svalues = sort(values);
    best = svalues(nToSkip:(nToPick+nToSkip));
    
    obj = mean(best);


end

