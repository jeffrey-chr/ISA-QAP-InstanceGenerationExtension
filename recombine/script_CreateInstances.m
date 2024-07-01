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
    oldpath = path;
    path(oldpath,strcat(gendir,'\Generators\Hypercube'));
    path(oldpath,strcat(gendir,'\Generators\Palubeckis'));
    path(oldpath,strcat(gendir,'\Generators\StuFer'));
    path(oldpath,strcat(gendir,'\Generators\TaillardB'));
    path(oldpath,strcat(gendir,'\Generators\TaiTerminal'));
end
if ~exist('genDistHypercube','file')
    error('Failed to load instance generator directory');
end

n = 81;

infproxy1 = @(base, n) base * 2 * n + randi(floor(base)/2);
randdens1 = @(n) floor(randi(n) + n/2);

distanceGenerators81 = {
    @() randi(1000,81), 'random';
    @() genDistHypercube(3, 4, 20), 'hypercube';
    @() distPalubeckis(81), 'palubeckis';
    @() genDistTerminal([3,3,3,3], randdens1, true, 20, infproxy1);
    };

flowGenerators81 = {
    @() randi(1000,81), 'random';
    @() genFlowHypercube(3, 4, 20, @(x) x + randi(x/2)), 'hypercube';
    @() flowPalubeckis(81), 'palubeckis';
    @() genFlowStructuredPlus(81,rand*40+10, rand*6+1, 0.05), 'stustr';
    @() genFlowTerminal([3,3,3,3], randdens1, true, 20, infproxy1);
    };

distanceGenerator80 = {
    @() genDistManhattan(80,8), 'manhattan';
    };

flowGenerators80 = {
    @() flowPalubeckis(80), 'palubeckis';
    };

function dist = distPalubeckis(n)
    [dist,~] = generatePaluInstance(n,7,7,floor(n/2),10,50,3,19);
end
function flow = flowPalubeckis(n)
    [~,flow] = generatePaluInstance(n,7,7,floor(n/2),10,50,3,19);
end