function [flow,xy,description] = genFlowRandom(n,sp,b)
%GENFLOWRANDOM Summary of this function goes here
%   Detailed explanation goes here
flow = -ones(n);
a = 100^(1/b);
xy = [];

for i = 1:n
    for j = 1:n
        if i == j 
            flow(i,j) = 0;
        else
            x = rand;
            if x < sp
                flow(i,j) = 0;
            else
                x = rand;
                flow(i,j) = floor(max(1,(a * x) ^ b));
            end
        end
    end

    description = strcat("FlowType,Random\nZeroProbability,",num2str(sp,10),"\nExponent,",num2str(b,10),"\n");
end


end

