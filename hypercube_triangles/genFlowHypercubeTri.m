function flow = genFlowHypercubeTri(l, d, base, modfunc,ntri)
%GENFLOWHYPERCUBE Generates distance matrix for hypercube QAP instance
%   Detailed explanation goes here
    n = l^d;
    flow = zeros(n);
    coords = (dec2base(0:n-1,l) - '0');
    for t = 1:ntri
        chosen = randi(n);
        chosencoord = coords(chosen,:);
        neighbours = [];
        for i = 1:n
            if abs(norm(chosencoord - coords(i,:),1) - 1) < 0.01
                neighbours = [neighbours, i];
            end 
        end
        perm = randperm(length(neighbours));
        chosen1 = neighbours(perm(1));
        chosen2 = neighbours(perm(2));
        %flow(chosen, chosen1) = flow(chosen, chosen1)+ modfunc(base);
        %flow(chosen, chosen2) = flow(chosen, chosen2)+ modfunc(base);
        %flow(chosen1, chosen2) = flow(chosen1, chosen2)+ modfunc(base);
        flow(chosen, chosen1) = modfunc(base);
        flow(chosen1, chosen2) = modfunc(base);
        flow(chosen2, chosen) = modfunc(base);
    
    end

end

