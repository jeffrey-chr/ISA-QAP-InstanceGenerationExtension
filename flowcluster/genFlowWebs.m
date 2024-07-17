function flow = genFlowWebs(dims, base, modfunc,seeds)
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
    
    unassigned = ones(n,1);
    assignment = zeros(n,1);
    clusters = cell(seeds,1);
    weightedlist = [];
    tmp = randperm(n);
    unassigned(tmp(1:seeds)) = 0;
    for i = 1:seeds
        clusters{i} = [tmp(i)];
        clusterweight = randi(5);
        assignment(tmp(i)) = i;
        for j = 1:clusterweight
            weightedlist = [weightedlist, i];
        end
    end

    while any(unassigned)
        clusterid = randi(length(weightedlist)); 
        chooselist = clusters{weightedlist(clusterid)};
        chosen = chooselist(randi(length(chooselist)));

        chosencoord = coords(chosen,:);
        neighbours = [];
        for i = 1:n
            if abs(norm(chosencoord - coords(i,:),1) - 1) < 0.01
                neighbours = [neighbours, i];
            end 
        end
        if any(unassigned(neighbours))
            candidates = find(unassigned(neighbours));
            chosenneighbour = neighbours(candidates(randi(length(candidates))));
            flow(chosen, chosenneighbour) = modfunc(base);
            flow(chosenneighbour, chosen) = modfunc(base);
            unassigned(chosenneighbour) = 0;
            assignment(chosenneighbour) = assignment(chosen);
            clusters{assignment(chosen)} = [clusters{assignment(chosen)}, chosenneighbour];
        end
    end

    for i = 1:seeds
        c = clusters{i};
        for j = 1:length(c)
            for k = (j+1):length(c)
                if flow(c(j), c(k)) < 1e-3
                    flow(c(j), c(k)) = randi(base/2);
                    flow(c(k), c(j)) = randi(base/2);
                end
            end
        end
    end
    clusters
end

