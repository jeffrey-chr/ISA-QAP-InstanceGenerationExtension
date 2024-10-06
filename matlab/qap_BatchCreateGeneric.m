function qap_BatchCreateGeneric(myid,gagenerations, gapopsize, instPerPop, skippedPerPop, pickedPerPop, finalPerTarget, pickedPerTarget)
%QAP_BATCHCREATE Summary of this function goes here
%   Detailed explanation goes here

    ggen = gagenerations;
    gpop = gapopsize;

    n2G = instPerPop;
    n2P = pickedPerPop;
    n2S = skippedPerPop;

    instPerTarget = finalPerTarget;
    bestPerTarget = pickedPerTarget;


    ufid = fopen('../linkdir.txt','r');
    uline = strtrim(fgetl(ufid));
    featdir = strtrim(fgetl(ufid));
    instgendir = strtrim(fgetl(ufid));
    instdir = strtrim(fgetl(ufid));
    fclose(ufid);
    
    if ~exist('qap_readFile','file')
        oldpath = path;
        path(oldpath,uline);
    end
    if ~exist('qap_writeFile','file')
        error('Failed to load utilities');
    end
    
    if ~exist('qap_DefineFeatures','file')
        oldpath = path;
        path(oldpath,strcat(featdir,'/matlab'));
        oldpath = path;
        path(oldpath,strcat(featdir,'/matlab/analyseqap'));
    end
    if ~exist('qap_DefineFeatures','file')
        error('Failed to load feature analysis directory');
    end

    sources = ...
    ["/ProblemData/StuFerGen/stf60es2.dat";
     "/ProblemData/QAPLIB/sko72.dat";
     "/ProblemData/UniRndGen/xran70A1.dat";
     "/ProblemData/TermGen/term75_4.dat";
     "/ProblemData/StuFerGen/stf60er1.dat";
     "/ProblemData/Drezner/dre72.dat";
     "/ProblemData/Hypercube/hyp64_3.dat";
     "/ProblemData/tinytest/tiny9.dat"];
    
    nRealSources = 7;

    level = wildcardPattern + "/";
    pat = asManyOfPattern(level);
    filenames = extractAfter(sources,pat);
    filenames = extractBefore(filenames,".");

    ds = cell(length(sources),1);
    for i = 1:length(sources)
        [A,~] = qap_readFile(strcat(instdir,sources(i)));
        ds{i} = A;
    end
    
    targets = [-2, 1.5;
    2, 2.5;
    2.75,0.75;
    2.75, -0.75;
    1.75, -2;
    0.25,-2.5;
    -1.5, -2;
    -2.75,-0.5];


      % targets = [-1.5,2; 
      %       1,3;
      %       2.5,1.5;
      %       3, 0.5;
      %       3, -1;
      %       1.5,-2;
      %       0,-2.5;
      %       -1.5,-2;
      %       -2.75,-1;
      %       -2.75,0.5];

    targetid = rem(myid-1, length(targets))+1;

    sourceid = floor((myid-1)/length(targets))+1;

    sourcename = filenames(sourceid)

    distances = ds{sourceid};

    matildaborder = [   -2.6071    1.3126
   -3.6051    0.3402
   -3.6940   -0.5398
   -3.1427   -1.4077
   -1.3216   -2.4882
   -0.5808   -2.3092
    0.9063   -1.7832
    2.0801   -1.1468
    3.0781   -0.1743
    3.1670    0.7056
    2.6157    1.5735
    0.7946    2.6540
    0.0538    2.4750
   -1.4333    1.9490
   -2.6071    1.3126];


   



    

    %blah = [4,6,8,10,15];
    %indices = blah(myid);

    script_GenerateFixedDistGeneric;
end

