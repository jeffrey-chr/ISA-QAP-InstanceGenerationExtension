fig = figure('Position', [0 100 800 800]);
clf
hold on
%baseplt=scatter(existingPoints(:,1),existingPoints(:,2),12,'MarkerEdgeColor',[.7 .7 .7],'MarkerFaceColor',[.7 .7 .7]);

%manreg = "^nug.*$|^sko.*$|^wil.*$|^had.*$|^scr.*$|^tho.*$|^stf.*m[prs].*$";
realreg = "^ste.*$|^els.*$|^bur.*$|^kra.*$|^esc.*$";
likereg = "^tai.*b.*$|^stf.*e[prs].*|^xtab.*$";
typesource = [];
for in = 1:length(model.data.instlabels)
    aonly = char(model.data.instlabels(in));
    if ~isempty(regexp(aonly,realreg,'ONCE'))
        typesource = [typesource;"REAL"];
    elseif ~isempty(regexp(aonly,likereg,'ONCE'))
        typesource = [typesource;"REALLIKE"];
    else
        typesource = [typesource;"ZZZ"];
    end
end
typesource = categorical(typesource);

i1 = (typesource=="ZZZ");
baseplt=scatter(existingPoints(i1,1),existingPoints(i1,2),12,'MarkerEdgeColor',[.5 .5 .5],'MarkerFaceColor',[.5 .5 .5]);
i2 = (typesource=="REAL");
realplt=scatter(existingPoints(i2,1),existingPoints(i2,2),12,'MarkerEdgeColor',[.45 .7 .45],'MarkerFaceColor',[.45 .7 .45]);
i3 = (typesource=="REALLIKE");
likeplt=scatter(existingPoints(i3,1),existingPoints(i3,2),12,'MarkerEdgeColor',[.45 .45 .6],'MarkerFaceColor',[.45 .45 .7]);

for t = 1:6

    for i = 1:params.instPerTarget
        %bestprojs{t,i} = vector2proj(bestinsts{t}(i,:),model,features);
        figure(fig);
        targetplt{t} = scatter(targets(t,1), targets(t,2), 160,'p','LineWidth',0.5,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
        genplt{t} = scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),45,'LineWidth',1.5,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',hsv2rgb([t/size(targets,1),0.75,0.7]));
        
        [mat1, mat2] = vector2qap(bestinsts{t}(i,:));
        instnames{t,i} = char(strcat('QAP',instName,'_',num2str(t),"_",num2str(i)));
        %qap_writeFile(strcat(genfilesdir,'QAP',instName,'_',num2str(t),"_",num2str(i),'.dat'),mat1,mat2);
    end
end
xlabel('z_1')
ylabel('z_2');
axis square;
axis([-4 4 -4 4]);
set(findall(gcf,'-property','FontSize'),'FontSize',20);

fig = figure('Position', [0 100 800 800]);
algorithms = ["BLS","BMA","MMAS"];
shortinstname = sortrows(string(instnames(:)));
algtable = cell(3,1);
algarray = -ones(60,3);
algarrayabs = -ones(60,3);
algtrials = -ones(60,3,30);
ntrials=30;
for ai = 1:length(algorithms)
    algtable{ai} = readtable(strcat('.\',algorithms(ai),"data.csv"));
    algtable{ai} = sortrows(algtable{ai});
    
    loci = 1;
    tabi = 1;
    while loci <= 60 && tabi <= size(algtable{ai},1)
        nextlocal = strtrim(shortinstname(loci,:));
        nexttable = strtrim(algtable{ai}(tabi,1).Name{1});
        if strcmp(nextlocal,nexttable)
            algarrayabs(loci,ai) = algtable{ai}.('AverageSoln')(tabi);
            for i = 1:ntrials
                colstr = strcat('AllTrials_',num2str(i));
                algtrials(loci,ai,i) = algtable{ai}.(colstr)(tabi);
            end
            loci = loci + 1;
            tabi = tabi + 1;
        else
            if nextlocal < nexttable
                loci = loci + 1;
            else
                tabi = tabi + 1;
            end
        end
    end
end

for insti = 1:60
    %solvar = cppfeatarray(insti,1);
    %solavg = cppfeatarray(insti,3);
    %algarray(insti,:) = (algarrayabs(insti,:) - solavg) / (solvar)^0.5;
    %algarray(insti,:) = algarray(insti,:) - min(algarray(insti,:));
    alltrials = algtrials(insti,:,:);
    tristd = std(alltrials(:));
    if tristd < 0.1
        tristd = 0.1;
    end
    algarray(insti,:) = (algarrayabs(insti,:) - min(algarrayabs(insti,:)))/tristd;
end

baddies = algarray >= 0.5;

if true
    % Color definitions
    hold on
    Z = model.pilot.Z
    best = model.trace.best;
    P = model.pythia.selection0;
    algolabels = model.data.algolabels
    ubound = ceil(max(Z));
    lbound = floor(min(Z));
    nalgos = length(algolabels);
    algolbls = cell(1,nalgos+1);
    isworty = sum(bsxfun(@eq, P, 0:nalgos))~=0;
    clr = 1-(1-flipud(lines(nalgos+1)))*0.7;
    h = zeros(1,nalgos+1);
    for i=0:nalgos
        if ~isworty(i+1)
            continue;
        end
        h(i+1) = line(Z(P==i,1), Z(P==i,2), 'LineStyle', 'none', ...
                                            'Marker', '.', ...
                                            'Color', clr(i+1,:), ...
                                            'MarkerFaceColor', clr(i+1,:), ...
                                            'MarkerSize', 5);
        if i~=0
            handle = plot(best{i}.polygon,'FaceColor', clr(i+1,:), 'EdgeColor','none', 'FaceAlpha', 0.5);
            %drawFootprint(best{i}, clr(i+1,:), 0.5);
        end
        if i==0
            algolbls{i+1} = 'None';
        else
            algolbls{i+1} = strrep(algolabels{i},'_',' ');
        end
    end
    xlabel('z_{1}'); ylabel('z_{2}'); %title('Portfolio footprints');
    %legend(h(isworty), algolbls(isworty), 'Location', 'NorthEastOutside');
    set(findall(gcf,'-property','FontSize'),'FontSize',20);
    set(findall(gcf,'-property','LineWidth'),'LineWidth',1);
    axis square; %axis([lbound(1)-1 ubound(1)+1 lbound(2)-1 ubound(2)+1]);
    axis([-4 4 -4 4])
end

for t = 1:6
    for i = 1:params.instPerTarget
        scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),20,'MarkerEdgeColor',[0.2 0.2 0.2],'MarkerFaceColor',[0.2 0.2 0.2]);
        shorti = find(instnames{t,i} == shortinstname(:));
        if baddies(shorti,2)
            scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),250,'Marker','x','LineWidth',2,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
        end
        if baddies(shorti,3)
            scatter(bestprojs{t,i}(1), bestprojs{t,i}(2),170,'Marker','+','LineWidth',2,'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1]);
        end
    end
end

        

