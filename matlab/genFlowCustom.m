function [flow,description] = genFlowCustom(n,clu,clud,cluv,noisef, noises)
%GENFLOWCUSTOM Summary of this function goes here
%   Detailed explanation goes here

    % Number of clusters parameter
    nclu = round((n/2)^clu);

    % Minimum density within cluster parameter
    % [0,1]
    cludensity = clud;

    % Minimum link within cluster
    % Always 100

    % Degree of variation within cluster
    % [0,1] -> [10,1000]
    cluvar = 10^(1+2*cluv);

    % Frequency of links between clusters parameter
    % [0,1] -> [0,0.1]
    noisefreq = 0.1*noisef;

    % Relative strength of links between clusters
    % [0,1] -> [0,100] maximum
    noisestrength = floor(1+99*noises);

    assign = ceil(0.5*(1:nclu*2));
    if length(assign) > n
        assign = assign(1:n);
    end
    if length(assign) < n
        firstrandom = length(assign) + 1;
        assign = [assign, zeros(1,n-length(assign))];
        for i = firstrandom:n
            assign(i) = randi(nclu);
        end
    end
    
    flow = zeros(n);

    for c = 1:nclu
        idx = find(assign==c);
        ninclu = length(idx);
        npossible = ninclu * (ninclu-1) * 0.5;
        nlinks = round(npossible*cludensity);
        localF = zeros(ninclu);
        % add initial links
        for i = 1:nlinks
            foo = false;
            while ~foo
                p = randperm(ninclu,2);
                if localF(p(1),p(2)) == 0
                    foo = true;
                    localF(p(1),p(2)) = floor(100 + rand*cluvar);
                    localF(p(2),p(1)) = floor(100 + rand*cluvar);
                end
            end
        end
        % make the cluster connected if necessary
        checkF = (localF > 0);
        for j = 2:ninclu
            checkF = checkF + (localF > 0)^j;
        end
        [x,y] = find((checkF + eye(ninclu)) == 0);
        while ~isempty(x)
            qqq = randi(length(x));
            p(1) = x(qqq);
            p(2) = y(qqq);
            localF(p(1),p(2)) = floor(100 + rand*cluvar);
            localF(p(2),p(1)) = floor(100 + rand*cluvar);
            checkF = (localF > 0);
            for j = 2:ninclu
                checkF = checkF + (localF > 0)^j;
            end
            [x,y] = find((checkF + eye(ninclu)) == 0);
        end

        flow(idx,idx) = localF;
    end

    noiseloc = randperm(n*n,floor(n*n*noisefreq));

    for i = 1:length(noiseloc)
        flow(i) = flow(i) + randi(noisestrength);
    end

end

