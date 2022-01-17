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

if ~exist('DefineFeatures','file')
    oldpath = path;
    path(oldpath,strcat(featdir,'\matlab'));
end
if ~exist('DefineFeatures','file')
    error('Failed to load feature analysis directory');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure

% Where to write generated instances
genfilesdir = "..\output\";

% load ISA model
model = load('..\..\ISA\QAPdata\model.mat');

% define target points:
% Get boundary of projected instance space
targets = model.cloist.Zedge(1:end,:);
% Put additional targets inside any large gaps
targets = fillpath(targets,1.2);
% Add more target points if desired
targets = [targets; 0, -3];
% Targets to be aimed at in this execution of the script
% Run a few at a time to avoid losing lots of time to crashes
%indices = 1:length(targets);
indices = [10];

% Get feature list
features = defineFeatures();

% Choose method for applying genetic algorithm
generatorFunction = @qapGaUnstructured;
instName = 'gaUnstr'
%OR
%generatorFunction = @qapGaStutzleGenerator;
%instName = 'gaStutzle';

% parameters for generation
params = struct;
params.instPerTarget = 10;
params.instdir = '..\..\Instances';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fsel = model.featsel.idx;
X = model.data.X;

existingPoints = X*model.pilot.A';

fig = figure('Position', [10 10 900 600]);
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
    
    [bestinsts{t},iters{t}] = generatorFunction(targets(t,:), model, features, params);

    for i = 1:params.instPerTarget
        bestprojs{t,i} = vector2proj(bestinsts{t}(i,:),model,features);
        figure(fig);
        targetplt{t} = scatter(targets(t,1), targets(t,2), 50,'x','MarkerEdgeColor',hsv2rgb([t/size(targets,1),0.75,0.7]),'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
        genplt{t} = scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),10,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
        
        [mat1, mat2] = vector2qap(bestinsts{t}(i,:));
        qap_writeFile(strcat(genfilesdir,'QAP',instName,'_',num2str(t),"_",num2str(i)),mat1,mat2);
    end
end
