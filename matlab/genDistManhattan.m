function [dist,xy,description] = genDistManhattan(n,A)

    xy = -ones(n,2);
    dist = -ones(n);
    
    nextx = 0;
    nexty = 0;
    
    for i = 1:n
        xy(i,1) = nextx;
        xy(i,2) = nexty;
         
        nextx = nextx + 1;
        if nextx >= A
            nextx = 0;
            nexty = nexty + 1;
        end
    end
    
    for i = 1:n
        for j = 1:n
            dist(i,j) = norm(xy(i,:)-xy(j,:),1);
        end
    end

    xstring = sprintf('%f,',xy(:,1));
    ystring = sprintf('%f,',xy(:,2));
    description = strcat("DistanceType,Manhattan\nRectangleDim,",num2str(A,10), ...
        "\nXCoords,", extractBefore(xstring, length(xstring)), ...
        "\nYCoords,", extractBefore(ystring, length(ystring)), ...
        "\n");

end

