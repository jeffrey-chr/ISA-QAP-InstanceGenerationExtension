%Generate new instances with distances based on vertices of hypercubes.

if ~exist('qap_writeFile','file')
    ufid = fopen('..\linkdir.txt','r');
    uline = fgetl(ufid);
    fclose(ufid);
    oldpath = path;
    path(oldpath,uline);
end

if ~exist('qap_writeFile','file')
    error('Failed to load utilities');
end

outputDir = ".\output\";
descDir = ".\description\";

g = @(x) x + randi(x/2);

% instTypes = { %[5,3,3], 20, infproxy1, randdens1, true;
%               %[2,6], 20;
%               %[3,4], 20;
%               %[2,7], 10;
%               %[5,3], 10;
%               [2,5], 20;
%             };
instTypes = {
              %[2,5], 8;
              %[2,6], 8;
              [3,3,3,3], @() genDistHypercube(3,4,20), @(t) genFlowWebs([3,3,3,3],20,g,t), 'hyper', 30;
              [8,10], @() genDistDrexx(10,8), @(t) genFlowWebs([8,10],20,g,t), 'drez', 30;
              
              %[8,10], @() genDistManhattan(80,8), @(t) genFlowTcycle([8,10],20,g,t), 'manhat', 20;
              %[2,7], 8;
              %[5,3], 8;
            };
        
for i = 1:size(instTypes,1)
    ninst = instTypes{i,5};
    for count = 1:ninst
        dims = instTypes{i,1};
        n = dims(1);
        for j = 2:length(dims)
            n = n * dims(j);
        end
        nseeds = 5+count;

        dist = instTypes{i,2}();
        flow = instTypes{i,3}(nseeds);
        name = strcat('treeflow',num2str(n),'_D',instTypes{i,4},'_',num2str(count));
        qap_writeFile(strcat(outputDir,name,".dat"),dist,flow);

        description = strcat("InstanceType,Webflow\nInstanceSize,",num2str(n), ...
            "\nBaseDistance,",num2str(20), ...
            "\nBaseFlow,",num2str(20), ...
            "\nNoSeeds,",num2str(nseeds), ...
            "\nDistanceType,",instTypes{i,4});
        fid = fopen(strcat(descDir,name,".csv"),'w');
        fprintf(fid, description);
        fclose(fid);
    end
end
