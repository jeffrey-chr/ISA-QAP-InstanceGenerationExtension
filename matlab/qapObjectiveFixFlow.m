function [obj] = qapObjectiveFixFlow(x,target,model,features,flow)
%QAPOBJECTIVEUNSTRUCTURED

    n = length(x)/2;

    locs = reshape(x,2,n)';

    dist = zeros(n);

    for i = 1:n
        for j = i+1:n
            dist(i,j) = floor(norm(locs(i,:) - locs(j,:),2));
            dist(j,i) = dist(i,j);
        end
    end

    [points] = qap2proj(dist,flow,model,features);
    
    obj = norm(points - target);
    
end