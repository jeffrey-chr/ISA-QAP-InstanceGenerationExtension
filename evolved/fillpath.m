function [path] = fillpath(vertices,mingap)
%FILLPATH Summary of this function goes here
%   Detailed explanation goes here

path = vertices(1,:);
for i = 2:size(vertices,1)
    dist = norm(vertices(i,:) - vertices(i-1,:));
    dfloor = floor(dist / mingap);
    if dfloor > 1
        for j = 1:dfloor-1
            path = [path;j/dfloor*vertices(i-1,:) + (1 - j/dfloor)*vertices(i,:)];
        end
    end
    path = [path;vertices(i,:)];
end

end

