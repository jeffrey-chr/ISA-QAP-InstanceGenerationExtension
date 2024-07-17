function [dist] = genDistDrexx(k,l)
%GENFLOWDREXX Summary of this function goes here
%   Detailed explanation goes here
n = k*l;
dist = -ones(n);

xy = -ones(n,2);

nextx = 0;
nexty = 0;

for i = 1:n
    xy(i,1) = nextx;
    xy(i,2) = nexty;
     
    nextx = nextx + 1;
    if nextx >= l
        nextx = 0;
        nexty = nexty + 1;
    end
end

for i = 1:n
    for j = 1:n
        d = norm(xy(i,:)-xy(j,:),1);
        if d == 0
            dist(i,j) = 0;
        elseif d == 1
            dist(i,j) = 1;
        else
            dist(i,j) = randi(9)+1;
        end
    end
end

end

