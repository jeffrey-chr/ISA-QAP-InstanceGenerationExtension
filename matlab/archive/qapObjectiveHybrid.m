function [obj] = qapObjectiveHybrid(x,target,model,features,params)
%QAPOBJECTIVESTUTZLE

    ntrials = 20;

    n = params.n;
    dists = -ones(ntrials,1);

    for i = 1:ntrials
        dist = vector2hybridist(x(4:end));
        %flow = genFlowStructuredPlus(n,x(4),x(5),x(6),x(7));
        flow = genFlowStructuredPlus(n,x(4),x(5),x(6));
        
        point = qap2proj(dist,flow,model,features);
        dists(i) = norm(point - target);
    end
        
    [~,II] = sort(dists);
    obj = mean(dists(II(1:10)));
    
end