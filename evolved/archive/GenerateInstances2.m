ufid = fopen('..\linkdir.txt','r');
uline = strtrim(fgetl(ufid));
featdir = strtrim(fgetl(ufid));
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
    path(oldpath,strcat(featdir,'\matlab'));
    oldpath = path;
    path(oldpath,strcat(featdir,'\matlab\analyseqap'));
end
if ~exist('qap_DefineFeatures','file')
    error('Failed to load feature analysis directory');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure

% Where to write generated instances
genfilesdir = ".\output\";

% load ISA model
model = load('..\..\ISA\QAPdata_combined\model.mat');

% define target points:
% Get boundary of projected instance space
targets = model.cloist.Zedge(1:end,:);
% Put additional targets inside any large gaps
targets = fillpath(targets,1.2);
% Add more target points if desired
%targets = [targets; 0, -3];
% Targets to be aimed at in this execution of the script
% Run a few at a time to avoid losing lots of time to crashes
%indices = 1:length(targets);
indices = 14;
%indices = [10];
%targets = [1,-2.5;0,-2;-1,-0.75;-2,0.5;-2.5,2;-2,3.5];
%indices = [1:6];

% Get feature list
features = qap_DefineFeatures();

% Choose method for applying genetic algorithm
% generatorFunction = @qapGaUnstructured;
% instName = 'gaUnstr'
%OR
generatorFunction = @qapGaFixFlow;
instName = 'gaFixFlow';

% generatorFunction = @qapGaHybrid;
% instName = 'gaHybrid';

% parameters for generation
n = 75;
flows = genFlowRandom(n,rand*0.6+0.2,rand*6+1);
%flows = genFlowStructuredPlus(n,rand*40+10,rand*6+1,0.05);
params = struct;
params.instPerTarget = 5;
params.instdir = '..\..\Instances';
params.instsize = n;
params.flows = flows;
params.gagen = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fsel = model.featsel.idx;
X = model.data.X;

existingPoints = X*model.pilot.A';

fig = figure('Position', [0 100 800 800]);
clf
hold on
baseplt=scatter(existingPoints(:,1),existingPoints(:,2),12,'MarkerEdgeColor',[.7 .7 .7],'MarkerFaceColor',[.7 .7 .7]);

if exist('iters','var') == 0
    iters = cell(length(targets),1);
end
if exist('fitnesses','var') == 0
    fitnesses = zeros(length(targets),1);
end
if exist('bestinsts','var') == 0
    bestinsts = cell(length(targets),1);
end
if exist('bestprojs','var') == 0
    bestprojs = cell(length(targets),1);
end
if exist('targetplt','var') == 0
    targetplt = cell(length(targets),1);
end
if exist('genplt','var') == 0
    genplt = cell(length(targets),1);
end

for t = indices
    
    fprintf("Target point: %f, %f\n",targets(t,1),targets(t,2))

    [bestinsts{t},iters{t}] = generatorFunction(targets(t,:), model, features, params);

    for i = 1:params.instPerTarget

        x = bestinsts{t}(i,:);

        locs = reshape(x,2,n)';

        dist = zeros(n);
    
        for ii = 1:n
            for jj= ii+1:n
                dist(ii,jj) = floor(norm(locs(ii,:) - locs(jj,:),2));
                dist(jj,ii) = dist(ii,jj);
            end
        end

        bestprojs{t,i} = qap2proj(dist,flows,model,features);
        figure(fig);
        targetplt{t} = scatter(targets(t,1), targets(t,2), 120,'p','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
        genplt{t} = scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),25,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
        
        %[mat1, mat2] = vector2qap(bestinsts{t}(i,:));
        qap_writeFile(strcat(genfilesdir,'QAP',instName,'_',num2str(t),"_",num2str(i)),dist,flows);
    end
end
xlim = [-4 4];
ylim = [-4 4];
set(findall(gcf,'-property','FontSize'),'FontSize',20);
