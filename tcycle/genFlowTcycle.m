function flow = genFlowTcycle(dims, base, modfunc,ntri)
%GENFLOWHYPERCUBE Generates distance matrix for hypercube QAP instance
%   Detailed explanation goes here
    d = length(dims);
    n = dims(1);
    for i = 2:d
        n = n * dims(i);
    end

    flow = zeros(n);
    coords = zeros(n,d);
    for i = 2:n
        coords(i,:) = coords(i-1,:);
        coords(i,d) = coords(i,d) + 1;
        for j = d:-1:2
            if coords(i,j) >= dims(j)
                coords(i,j) = 0;
                coords(i,j-1) = coords(i,j-1) + 1;
            end
        end
    end
    
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

