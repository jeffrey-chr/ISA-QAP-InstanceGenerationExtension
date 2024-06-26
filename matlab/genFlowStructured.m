function [flow, xy,description] = genFlowStructured(n,d,b)
%GENFLOWSTRUCTURED Summary of this function goes here
%   Detailed explanation goes here
flow = -ones(n);
a = 100^(1/b);

xy = rand(n,2)*100;

for i = 1:n
    for j = 1:n
        if i == j 
            flow(i,j) = 0;
        else
            if norm(xy(i,:)-xy(j,:)) < d
                x = rand;
                flow(i,j) = floor(max(1,(a * x) ^ b));
            else
                flow(i,j) = 0;
            end
        end
    end
end

description = strcat("FlowType,Structured\nZeroThreshold,",num2str(d,10),"\nExponent,",num2str(b,10),"\n");

end

