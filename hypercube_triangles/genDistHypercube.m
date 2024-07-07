function dist = genDistHypercube(l, d, base)
%GENDISTHYPERCUBE Generates distance matrix for hypercube QAP instance
%   Detailed explanation goes here
    n = l^d;
    dist = zeros(n);
    coords = (dec2base(0:n-1,l) - '0');
    for i = 1:n
        for j = [1:i-1,i+1:n]
            if norm(coords(i,:) - coords(j,:),1) == 1
                dist(i,j) = randi(base);
            elseif norm(coords(i,:) - coords(j,:),1) == 2
                dist(i,j) = 2*base + randi(base/2);
            else
                dist(i,j) = 4*base + randi(base/2);
        end
    end
end

