function [dist] = vector2hybridist(vec)
%VECTOR2PROJ 
    n = length(vec)/2;
    x = vec(1:n);
    y = vec(n+1:end);

    dist = zeros(n);
    for i = 1:n
        for j = 1:n
            dist(i,j) = ceil(norm([x(i)-x(j),y(i)-y(j)]));
        end
    end

end