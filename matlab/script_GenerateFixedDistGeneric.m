

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure

% Where to write generated instances
genfilesdir = "./output/";

% load ISA model
model = load('../../ISA/QAPdata_combined/model.mat');

% define target points:
% Get boundary of projected instance space
%targets = model.cloist.Zedge(1:end,:);
% Put additional targets inside any large gaps
%targets = fillpath(targets,1.2);
% Add more target points if desired
%targets = [targets; 0, -3];
% Targets to be aimed at in this execution of the script
% Run a few at a time to avoid losing lots of time to crashes
%indices = [4,6,8,10,15];
%indices = 1:4:length(targets);
%indices = 14;
%indices = [10];
%targets = [1,-2.5;0,-2;-1,-0.75;-2,0.5;-2.5,2;-2,3.5];
%indices = [1:6];

% Get feature list
features = qap_DefineFeatures();

% Choose method for applying genetic algorithm
% generatorFunction = @qapGaUnstructured;
% instName = 'gaUnstr'
%OR
generatorFunction = @qapGaGenBoth;
instName = 'gaFhypD';

% set by calling function
%[A,B] = qap_readFile(strcat(instdir,'/ProblemData/Hypercube/hyp32_1.dat'));
%distances = A;

% K = 10;
% m = 40;
% cc = 300;
% distances = genDistEuclidean(10,K,m,cc);


n = size(distances,1);

params = struct;
params.instdir = '../../Instances';
params.instsize = n;
params.gagen = ggen;
params.gapop = gpop;

%params.flowgen = @(x) genFlowStructuredPlus(n, x(1), x(2), x(3));
%params.lb = [10, 1, 0];
%params.ub = [50, 7, 0.25];
%params.intcon = [1,2];

params.flowgen = @(x) genFlowCustom(n, x(1), x(2), x(3), x(4),x(5));
params.lb = [0,0,0,0,0];
params.ub = [1,1,1,1,1];
params.intcon = [];

params.nToGen = n2G;
params.nToPick = n2P;

params.distgen = @(x) distances;

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
    genplt2 = cell(length(targets),1);
end

tic

params.distgen();

t = targetid;
    
fprintf("Target point: %f, %f\n",targets(t,1),targets(t,2))

record = QapRecord(5);

[xout] = generatorFunction(targets(t,:), model, features, params, record);

xout

quality = Inf*ones(instPerTarget,1);
flows = cell(instPerTarget,1);
projs = cell(instPerTarget,1);

for i = 1:instPerTarget
    % generate instance using identified parameters
    flows{i} = params.flowgen(xout);
    
    projs{i} = qap2proj(params.distgen(),flows{i},model,features,5000);

    quality(i) = norm(projs{i}-targets(t));
end

[~,sqidx] = sort(quality);

for i = 1:bestPerTarget
    %bestprojs{t,i} = qap2proj(distances,flows{sqidx(i)},model,features);
    bestprojs{t,i} = projs{sqidx(i)};

    figure(fig);
    targetplt{t} = scatter(targets(t,1), targets(t,2), 120,'p','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
    genplt{t} = scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),25,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));

    outsourcename = strrep(sourcename,"_","!");

    qap_writeFile(strcat(genfilesdir,'evoflow_',outsourcename,'_',num2str(t),"_",num2str(i)),params.distgen(),flows{i});
end

print(gcf,'-dpng',strcat('targethyp',num2str(t),'.png'));

toc
%xlim = [-4 4];
%ylim = [-4 4];
%set(findall(gcf,'-property','FontSize'),'FontSize',20);
