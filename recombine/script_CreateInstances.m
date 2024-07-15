ufid = fopen('..\linkdir.txt','r');
uline = strtrim(fgetl(ufid));
featdir = strtrim(fgetl(ufid));
gendir = strtrim(fgetl(ufid));
fclose(ufid);

if ~exist('qap_readFile','file')
    oldpath = path;
    path(oldpath,uline);
end
if ~exist('qap_writeFile','file')
    error('Failed to load utilities');
end

if ~exist('genDistHypercube','file')
    addpath(strcat(gendir,'\Generators\Hypercube'));
    addpath(strcat(gendir,'\Generators\Palubeckis'));
    addpath(strcat(gendir,'\Generators\StuFer'));
    addpath(strcat(gendir,'\Generators\TaillardB'));
    addpath(strcat(gendir,'\Generators\TaiTerminal'));
    addpath(strcat(gendir,'\Generators\Drexx'));
end
if ~exist('genDistHypercube','file')
    error('Failed to load instance generator directory');
end

n = 81;

infproxy1 = @(base, n) base * 2 * n + randi(floor(base)/2);
randdens1 = @(n) floor(randi(n) + n/2);

distanceGenerators81 = {
    @() randi(1000,81), 'rand';
    @() genDistHypercube(3, 4, 20), 'hypr';
    @() distPalubeckis(81), 'palu';
    @() genDistTerminal([3,3,3,3], randdens1, true, 20, infproxy1), 'term';
    };

flowGenerators81 = {
    @() randi(1000,81), 'rand';
    @() genFlowHypercube(3, 4, 20, @(x) x + randi(x/2)), 'hypr';
    @() flowPalubeckis(81), 'palu';
    @() genFlowStructuredPlus(81,rand*40+10, rand*6+1, 0.05), 'strp';
    @() genFlowTerminal([3,3,3,3], randdens1, true, 20), 'term';
    };

distanceGenerators80 = {
    @() genDistManhattan(80,8), 'manh';
    };

flowGenerators80 = {
    @() flowPalubeckis(80), 'palu';
    };

distanceGeneratorDre = {
    @() genDistDrexx(8,10), 'drez';
    };

flowGeneratorDre = {
    @() flowPalubeckis(80), 'palu';
    @() genFlowStructuredPlus(80,rand*40+10, rand*6+1, 0.05), 'strp';
    @() randi(1000,80), 'rand';
    };

distanceGeneratorEuc = {
    @() genDistEuclidean(81,ceil(81/(rand*13+2)),rand*30+20,300), 'eucl';
};

flowGeneratorEuc = {
    @() genFlowHypercube(3, 4, 20, @(x) x + randi(x/2)), 'hypr';
    @() flowPalubeckis(81), 'palu';
    @() genFlowTerminal([3,3,3,3], randdens1, true, 20), 'term';
};

genpairs = {distanceGenerators81, flowGenerators81;
    distanceGenerators80, flowGenerators80;
    distanceGeneratorDre, flowGeneratorDre;
    distanceGeneratorEuc, flowGeneratorEuc};

neach = 5;

for i = 1:size(genpairs,1)
    dgenlist = genpairs{i,1};
    fgenlist = genpairs{i,2};
    for j = 1:size(dgenlist,1)
        for k = 1:size(fgenlist,1)
            if strcmp(dgenlist{j,2},fgenlist{k,2}) == 0
                dgen = dgenlist{j,1};
                fgen = fgenlist{k,1};
                for L = 1:neach
                    dist = dgen();
                    flow = fgen();
                    n = size(dist,1);
                    fname = ['.\output\recomb', num2str(n),'_D',dgenlist{j,2},'_F',fgenlist{k,2},'_',num2str(L),'.dat'];
                    qap_writeFile(fname,dist,flow)
                end
            end
        end
    end
end