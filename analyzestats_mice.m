function analyzestats_mice()
%function to analyze KOvs KO, preMD vs MD
%compare OD across conditions and genotypes 

%% some set up 

%set save directory 

global SaveDir
SaveDir = ['L:\AnalyzedData\calcium\groupstats\'];
if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

%% Cell Identity loading directory 

AnalDirWT= ['L:\Laura\MouseMeasures\WT']; 
AnalDirKO= ['L:\Laura\MouseMeasures\KO'];

if ~exist(AnalDirWT,'dir') 
         mkdir (AnalDirWT)
 end

if ~exist(AnalDirKO,'dir') 
         mkdir (AnalDirKO)
end

%readin structure with longitudinally tracked cell identity

%WT mice 
WTfile_ID=dir(fullfile(AnalDirWT,'*_CellIdentity.mat')); 
for i=1:numel(WTfile_ID)
    WTfile_CellID(i)=load(fullfile(AnalDirWT, WTfile_ID(i).name)); 
end 

%KO mice 
KOfile_ID=dir(fullfile(AnalDirKO,'*_CellIdentity.mat')); 
for i=1:numel(KOfile_ID)
    KOfile_CellID(i)=load(fullfile(AnalDirKO, KOfile_ID(i).name)); 
end 
%% Pre MD 

%set data origin directory for preMD 
AnalDirWTpre= ['L:\Laura\MouseMeasures\WT\preMD']; 
AnalDirKOpre= ['L:\Laura\MouseMeasures\KO\preMD']; 
 if ~exist(AnalDirWTpre,'dir') 
         mkdir (AnalDirWTpre)
 end

if ~exist(AnalDirKOpre,'dir') 
         mkdir (AnalDirKOpre)
end

%read in structures from each mouse 

%read-in SigCellsDrift (for DSI measurements- drifting grating stimulus)
%this is based off the dFoF- calcium signal 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpre,'*_OD_pre.mat')); 
for i=1:numel(WTfile)
    WTDrift_pre(i)=load(fullfile(AnalDirWTpre, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpre,'*_OD_pre.mat')); 
for i=1:numel(KOfile)
    KODrift_pre(i)=load(fullfile(AnalDirKOpre, KOfile(i).name)); 
end 

%% post MD 

%set data origin directory for postMD 
AnalDirWTpost= ['L:\Laura\MouseMeasures\WT\postMD']; 
AnalDirKOpost= ['L:\Laura\MouseMeasures\KO\postMD']; 
 if ~exist(AnalDirWTpost,'dir') 
         mkdir (AnalDirWTpost)
 end

if ~exist(AnalDirKOpost,'dir') 
         mkdir (AnalDirKOpost)
end

%read in structures from each mouse 

%read-in SigCellsDrift (for DSI measurements- drifting grating stimulus)
%this is based off the dFoF- calcium signal 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpost,'*_OD_post.mat')); 
for i=1:numel(WTfile)
    WTDrift_post(i)=load(fullfile(AnalDirWTpost, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpost,'*_OD_post.mat')); 
for i=1:numel(KOfile)
    KODrift_post(i)=load(fullfile(AnalDirKOpost, KOfile(i).name)); 
end 

%% plot drifting gratings- OD score 
%first organized the data into concatenated vectors 
%WT, preMD
WT_preOD=[]; 
for i=1:length(WTDrift_pre) %for all the mice 
    WT_preOD=[WT_preOD; WTDrift_pre(i).OD_pre];
end 

%WT,postMD
WT_postOD=[]; 
for i=1:length(WTDrift_post) %for all the mice 
    WT_postOD=[WT_postOD; WTDrift_post(i).OD_post];
end 

%KO,preMD
KO_preOD=[]; 
for i=1:length(KODrift_pre) %for all the mice 
    KO_preOD=[KO_preOD; KODrift_pre(i).OD_pre];
end 

%KO,postMD
KO_postOD=[]; 
for i=1:length(KODrift_post) %for all the mice 
    KO_postOD=[KO_postOD; KODrift_post(i).OD_post];
end 

%now plot the OD score 
% plotODscore(WT_preOD, SaveDir, 'WT PreMD'); 
% plotODscore(WT_postOD, SaveDir, 'WT PostMD');
% plotODscore(KO_preOD, SaveDir, 'KO PreMD');
% plotODscore(KO_postOD, SaveDir, 'KO PostMD');


%% put data in a table for two way anova 
char_WT=strings(length(WT_preOD),3); 

for i=1:length(WT_preOD)
    char_WT(i,1)='pre';
    char_WT(i,2)='post';
    char_WT(i,3)='WT'; 
    char_WT(i,4)='pre WT'; 
    char_WT(i,5)='post WT'; 
end 
char_KO=strings(length(KO_preOD),3); 

for i=1:length(KO_preOD)
    char_KO(i,1)='pre';
    char_KO(i,2)='post';
    char_KO(i,3)='KO'; 
    char_KO(i,4)='pre KO'; 
    char_KO(i,5)='post KO'; 
end 

%make an empty table

ODscore=vertcat(WT_preOD, WT_postOD, KO_preOD, KO_postOD); %pre, post, pre, post  
genotype=vertcat(char_WT(:,3), char_WT(:,3), char_KO(:,3), char_KO(:,3)); %WT then KO
condition=vertcat(char_WT(:,1), char_WT(:,2), char_KO(:,1), char_KO(:,2)); %pre, post, pre, post
group= vertcat(char_WT(:,4), char_WT(:,5), char_KO(:,4), char_KO(:,5)); 
ODscoretable=table(ODscore,genotype,condition,group); 

%two way anova 
[p,tbl,stats]=anovan(ODscoretable.ODscore,{ODscoretable.condition,ODscoretable.genotype},...
    'model', 'interaction', 'varnames', {'condition', 'genotype'},'display','off'); 
%save table 
save(fullfile(SaveDir,'ANOVAresults.mat'),'tbl'); 

%multicomparisons
[results,m,h,gnames]=multcompare(stats,"Dimension", [1 2],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi=array2table(results,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi.("Group A")=gnames(tbl_multi.("Group A")); 
tbl_multi.("Group B")=gnames(tbl_multi.("Group B")); 

%save
save(fullfile(SaveDir,'MultipleComparisons.mat'),'tbl_multi'); 

%make swarmchart plot 
swarmchartplot=figure(1);
groupnames={'pre WT', 'post WT', 'pre KO', 'post KO'}; 
vio_color=vertcat([0 0 0], [0.4 0.4 0.4], [.8 0 1], [.8 0.7 1]); 
vs=violinplot(ODscoretable.ODscore, ODscoretable.group,'GroupOrder', groupnames,'ViolinColor', vio_color); 
ylim([-1 1]); 
title('Ocular Dominance')
ylabel('ODI')
xlabel('Group')

%make histograms for each condition 

%scales 

f2=figure(2);
t=tiledlayout(2,2); 
%WT pre 
nexttile
h1=histogram(WT_preOD, 10, 'FaceColor', [0.3 0.3 0.3]);
xlim([-1 1]); 
ylim([0 10])
title ('WT- pre MD')
box off 
%WT post 
nexttile
h2=histogram(WT_postOD, 10, 'FaceColor', [0.7 0.7 0.7]);
xlim([-1 1]); 
ylim([0 10])
title('WT- post MD')
box off 
%KO pre 
nexttile
h3=histogram(KO_preOD, 10, 'FaceColor', [.8 0 1]);
xlim([-1 1]); 
ylim([0 20])
title('KO- pre MD')
box off 
%KO post 
nexttile
h4=histogram(KO_postOD, 10, 'FaceColor', [.8 0.7 1]);
xlim([-1 1]);
ylim([0 20])
title ('KO- post MD')
box off 
title(t,'Ocular Dominance')
xlabel(t,'ODI')
ylabel(t,'Number of Neurons')

%save figure 
saveas(f2, fullfile(SaveDir, 'ODI-histograms'), 'pdf');
saveas(f2, fullfile(SaveDir, 'ODI-histograms'), 'tif');
saveas(f2, fullfile(SaveDir, 'ODI-histograms'), 'fig');


%% plot distribution of OD score 

%run a ks test 
[h_WT,p_WT]=kstest2(WT_postOD,WT_preOD); 
[h_KO,p_KO]=kstest2(KO_postOD, KO_preOD); 

%bin size
step=.1; 

%WT 
bins_OD_WTpre=-1:step:1; 
dist_OD_WTpre=hist(WT_preOD,bins_OD_WTpre); %get the distribution
ndist_OD_WTpre= dist_OD_WTpre/ sum(dist_OD_WTpre); %normalize to 0 -1 
cdist_OD_WTpre=cumsum(ndist_OD_WTpre); %cumulative distribution 

bins_OD_WTpost=-1:step:1; 
dist_OD_WTpost=hist(WT_postOD,bins_OD_WTpost); %get the distribution
ndist_OD_WTpost= dist_OD_WTpost/ sum(dist_OD_WTpost); %normalize to 0 -1 
cdist_OD_WTpost=cumsum(ndist_OD_WTpost); %cumulative distribution 


%plot distribution  

fOD_WT=figure(3); 
plot(bins_OD_WTpre, cdist_OD_WTpre, 'LineWidth',1.5, 'Color', [0.2 0.2 0.2]);
hold on 
ylim ([0 1])
xlim ([-1 1])
title ('ODI')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('OD score', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
plot(bins_OD_WTpost,cdist_OD_WTpost, 'LineWidth', 1.5, 'Color', [0.7 0.7 0.7]); 
box off 
title(['WT, pvalue is ',num2str(p_WT)]); 

%KO 
bins_OD_KOpre=-1:step:1; 
dist_OD_KOpre=hist(KO_preOD,bins_OD_KOpre); %get the distribution
ndist_OD_KOpre= dist_OD_KOpre/ sum(dist_OD_KOpre); %normalize to 0 -1 
cdist_OD_KOpre=cumsum(ndist_OD_KOpre); %cumulative distribution 

bins_OD_KOpost=-1:step:1; 
dist_OD_KOpost=hist(KO_postOD,bins_OD_KOpost); %get the distribution
ndist_OD_KOpost= dist_OD_KOpost/ sum(dist_OD_KOpost); %normalize to 0 -1 
cdist_OD_KOpost=cumsum(ndist_OD_KOpost); %cumulative distribution 

%plot distribution  

fOD_KO=figure(4); 
plot(bins_OD_KOpre, cdist_OD_KOpre, 'LineWidth',1.5, 'Color', [.8 0 1]);
hold on 
ylim ([0 1])
xlim ([-1 1])
title ('ODI')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('OD score', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
plot(bins_OD_KOpost,cdist_OD_KOpost, 'LineWidth', 1.5, 'Color', [.8 .7 1]); 
box off 
title(['KO, pvalue is ',num2str(p_KO)]);

%save distributions 
saveas(fOD_WT, fullfile(SaveDir, 'WT_ODI-distribution'), 'pdf');
saveas(fOD_WT, fullfile(SaveDir, 'WT_ODI-distribution'), 'tif');
saveas(fOD_WT, fullfile(SaveDir, 'WT_ODI-distribution'), 'fig');

saveas(fOD_KO, fullfile(SaveDir, 'KO_ODI-distribution'), 'pdf');
saveas(fOD_KO, fullfile(SaveDir, 'KO_ODI-distribution'), 'tif');
saveas(fOD_KO, fullfile(SaveDir, 'KO_ODI-distribution'), 'fig');

%% look at proportion of binocular/ contralateral/ ipsilateral cells 

%PRE MD
%WT mice 
WTfile_prop_pre=dir(fullfile(AnalDirWTpre,'*_cell_prop_pre.mat')); 
for i=1:numel(WTfile_prop_pre)
    WTDrift_prop_pre(i)=load(fullfile(AnalDirWTpre, WTfile_prop_pre(i).name)); 
end 

%KO mice 
KOfile_prop_pre=dir(fullfile(AnalDirKOpre,'*_cell_prop_pre.mat')); 
for i=1:numel(KOfile_prop_pre)
    KODrift_prop_pre(i)=load(fullfile(AnalDirKOpre, KOfile_prop_pre(i).name)); 
end 

%POST MD
%WT mice 
WTfile_prop_post=dir(fullfile(AnalDirWTpost,'*_cell_prop_post.mat')); 
for i=1:numel(WTfile_prop_post)
    WTDrift_prop_post(i)=load(fullfile(AnalDirWTpost, WTfile_prop_post(i).name)); 
end 

%KO mice 
KOfile_prop_post=dir(fullfile(AnalDirKOpost,'*_cell_prop_post.mat')); 
for i=1:numel(KOfile_prop_post)
    KODrift_prop_post(i)=load(fullfile(AnalDirKOpost, KOfile_prop_post(i).name)); 
end 

%WT mice
for i=1:length(WTDrift_prop_pre)
    WT_binoc_pre_prop(i)= WTDrift_prop_pre(i).cell_count_prop_pre.binoc;
   WT_con_pre_prop(i)= WTDrift_prop_pre(i).cell_count_prop_pre.con;
    WT_ipsi_pre_prop(i)= WTDrift_prop_pre(i).cell_count_prop_pre.ipsi;
   WT_binoc_post_prop(i)= WTDrift_prop_post(i).cell_count_prop_post.binoc;
   WT_con_post_prop(i)= WTDrift_prop_post(i).cell_count_prop_post.con;
    WT_ipsi_post_prop(i)= WTDrift_prop_post(i).cell_count_prop_post.ipsi;
end 

%KO mice 
for i=1:length(KODrift_prop_pre)
    KO_binoc_pre_prop(i)= KODrift_prop_pre(i).cell_count_prop_pre.binoc;
   KO_con_pre_prop(i)= KODrift_prop_pre(i).cell_count_prop_pre.con;
    KO_ipsi_pre_prop(i)= KODrift_prop_pre(i).cell_count_prop_pre.ipsi;
   KO_binoc_post_prop(i)= KODrift_prop_post(i).cell_count_prop_post.binoc;
   KO_con_post_prop(i)= KODrift_prop_post(i).cell_count_prop_post.con;
    KO_ipsi_post_prop(i)= KODrift_prop_post(i).cell_count_prop_post.ipsi;
end 

%WT, pre 
WT_binoc_pre=sum(WT_binoc_pre_prop); 
WT_con_pre=sum(WT_con_pre_prop); 
WT_ipsi_pre=sum(WT_ipsi_pre_prop); 

%WT, post 
WT_binoc_post=sum(WT_binoc_post_prop); 
WT_con_post=sum(WT_con_post_prop); 
WT_ipsi_post=sum(WT_ipsi_post_prop); 

%KO, pre 
KO_binoc_pre=sum(KO_binoc_pre_prop); 
KO_con_pre=sum(KO_con_pre_prop); 
KO_ipsi_pre=sum(KO_ipsi_pre_prop); 

%KO, post 
KO_binoc_post=sum(KO_binoc_post_prop); 
KO_con_post=sum(KO_con_post_prop); 
KO_ipsi_post=sum(KO_ipsi_post_prop); 

%% make pie chart for cell identities 
WT_pre=[WT_binoc_pre WT_con_pre WT_ipsi_pre];
WT_post=[WT_binoc_post WT_con_post WT_ipsi_post]; 
KO_pre=[KO_binoc_pre KO_con_pre KO_ipsi_pre];
KO_post=[KO_binoc_post KO_con_post KO_ipsi_post]; 

labels={'Binoc','Con', 'Ipsi'};
newColors=[...
    0.47, .93, .48;
    .04, .75, .66;
    .25, .2, .58]; %binoc, con, ipsi custom colors for pie slices 
%figure(5)
tiledlayout(2,2); 
fpie=figure('Name', 'Cell Identity', 'NumberTitle','off'); 


nexttile %WT pre
h=pie (WT_pre, '%.1f%%');
patchHand=findobj(h,'Type', 'Patch');
set(patchHand, {'FaceColor'}, mat2cell(newColors, ones(size(newColors,1),1), 3)); 
title('WT pre'); %label depending on experiment type 

nexttile %WT post 
h1=pie(WT_post,'%.1f%%'); 
patchHand1=findobj(h1,'Type', 'Patch');
set(patchHand1, {'FaceColor'}, mat2cell(newColors, ones(size(newColors,1),1), 3)); 
title('WT post'); %label depending on experiment type 

nexttile %KO pre
h2=pie (KO_pre, '%.1f%%');
patchHand2=findobj(h2,'Type', 'Patch');
set(patchHand2, {'FaceColor'}, mat2cell(newColors, ones(size(newColors,1),1), 3)); 
title('KO pre'); %label depending on experiment type 

nexttile %KO post
h3=pie (KO_post, '%.1f%%');
patchHand3=findobj(h3,'Type', 'Patch');
set(patchHand3, {'FaceColor'}, mat2cell(newColors, ones(size(newColors,1),1), 3)); 
title('KO post'); %label depending on experiment type 
legend(labels,'Location', 'southoutside'); 

%save figure 
saveas(fpie,fullfile(SaveDir, 'PieChart_cellproportions'),'pdf'); 
saveas(fpie,fullfile(SaveDir, 'PieChart_cellproportions'),'tif'); 
saveas(fpie,fullfile(SaveDir, 'PieChart_cellproportions'),'fig');
%% how does cell identity change? 
%eg binoc to contra, unresponsive to responsive, etc. 

% wt
WT_C2C=0; 
WT_C2I=0; 
WT_C2B=0; 
WT_C2U=0; 
WT_I2C=0; 
WT_I2I=0; 
WT_I2B=0; 
WT_I2U=0; 
WT_B2C=0; 
WT_B2I=0; 
WT_B2B=0; 
WT_B2U=0; 
WT_U2C=0; 
WT_U2I=0; 
WT_U2B=0; 
WT_U2U=0; 

%proportions of cell identity changes
for i=1:length(WTfile_CellID) 
    WT_C2C=WT_C2C+length(WTfile_CellID(i).Cell_type.CON.C2C); 
    WT_C2I=WT_C2I+length(WTfile_CellID(i).Cell_type.CON.C2I); 
    WT_C2B=WT_C2B+length(WTfile_CellID(i).Cell_type.CON.C2B); 
    WT_C2U=WT_C2U+length(WTfile_CellID(i).Cell_type.CON.C2U); 

    WT_I2C=WT_I2C+length(WTfile_CellID(i).Cell_type.IPSI.I2C); 
    WT_I2I=WT_I2I+length(WTfile_CellID(i).Cell_type.IPSI.I2I); 
    WT_I2B=WT_I2B+length(WTfile_CellID(i).Cell_type.IPSI.I2B); 
    WT_I2U=WT_I2U+length(WTfile_CellID(i).Cell_type.IPSI.I2U); 

    WT_B2C=WT_B2C+length(WTfile_CellID(i).Cell_type.BINOC.B2C); 
    WT_B2I=WT_B2I+length(WTfile_CellID(i).Cell_type.BINOC.B2I); 
    WT_B2B=WT_B2B+length(WTfile_CellID(i).Cell_type.BINOC.B2B); 
    WT_B2U=WT_B2U+length(WTfile_CellID(i).Cell_type.BINOC.B2U); 

    WT_U2C=WT_U2C+length(WTfile_CellID(i).Cell_type.UNRESP.U2C); 
    WT_U2I=WT_U2I+length(WTfile_CellID(i).Cell_type.UNRESP.U2I); 
    WT_U2B=WT_U2B+length(WTfile_CellID(i).Cell_type.UNRESP.U2B); 
    WT_U2U=WT_U2U+length(WTfile_CellID(i).Cell_type.UNRESP.U2U); 
end

%KO
KO_C2C=0; 
KO_C2I=0; 
KO_C2B=0; 
KO_C2U=0; 
KO_I2C=0; 
KO_I2I=0; 
KO_I2B=0; 
KO_I2U=0; 
KO_B2C=0; 
KO_B2I=0; 
KO_B2B=0; 
KO_B2U=0; 
KO_U2C=0; 
KO_U2I=0; 
KO_U2B=0; 
KO_U2U=0; 

%proportions of cell identity changes
for i=1:length(KOfile_CellID) 
    KO_C2C=KO_C2C+length(KOfile_CellID(i).Cell_type.CON.C2C); 
    KO_C2I=KO_C2I+length(KOfile_CellID(i).Cell_type.CON.C2I); 
    KO_C2B=KO_C2B+length(KOfile_CellID(i).Cell_type.CON.C2B); 
    KO_C2U=KO_C2U+length(KOfile_CellID(i).Cell_type.CON.C2U); 

    KO_I2C=KO_I2C+length(KOfile_CellID(i).Cell_type.IPSI.I2C); 
    KO_I2I=KO_I2I+length(KOfile_CellID(i).Cell_type.IPSI.I2I); 
    KO_I2B=KO_I2B+length(KOfile_CellID(i).Cell_type.IPSI.I2B); 
    KO_I2U=KO_I2U+length(KOfile_CellID(i).Cell_type.IPSI.I2U); 

    KO_B2C=KO_B2C+length(KOfile_CellID(i).Cell_type.BINOC.B2C); 
    KO_B2I=KO_B2I+length(KOfile_CellID(i).Cell_type.BINOC.B2I); 
    KO_B2B=KO_B2B+length(KOfile_CellID(i).Cell_type.BINOC.B2B); 
    KO_B2U=KO_B2U+length(KOfile_CellID(i).Cell_type.BINOC.B2U); 

    KO_U2C=KO_U2C+length(KOfile_CellID(i).Cell_type.UNRESP.U2C); 
    KO_U2I=KO_U2I+length(KOfile_CellID(i).Cell_type.UNRESP.U2I); 
    KO_U2B=KO_U2B+length(KOfile_CellID(i).Cell_type.UNRESP.U2B); 
    KO_U2U=KO_U2U+length(KOfile_CellID(i).Cell_type.UNRESP.U2U); 
end

% proportion of ipsilateral cells after MD
WT_Iconversion=WT_U2I+WT_C2I+ WT_B2I+WT_I2I; 
KO_Iconversion=KO_U2I+KO_C2I+ KO_B2I+KO_I2I; 

%proportion of binocular cells 
WT_Bconversion=WT_U2B+WT_C2B+ WT_B2B+WT_I2B; 
KO_Bconversion=KO_U2B+KO_C2B+ KO_B2B+KO_I2B;

%proportion of unresponsive cells 
WT_Uconversion=WT_U2U+WT_C2U+ WT_B2U+WT_I2U; 
KO_Uconversion=KO_U2U+KO_C2U+ KO_B2U+KO_I2U;

%% plot cell id changes 

fig_cellID=figure(6); 
%plot for ipsilateral cells 
%3 categories, B to I/ C to I, U to I 

tiledlayout(1,3)
nexttile
categoriesIPSI=categorical({'U2I', 'B2I', 'C2I'}); 
categoriesIPSI=reordercats(categoriesIPSI, {'U2I', 'B2I', 'C2I'}); 

WT_ipsi=[(WT_U2I/WT_Iconversion) WT_B2I/WT_Iconversion WT_C2I/WT_Iconversion]; 
KO_ipsi=[(KO_U2I/KO_Iconversion) KO_B2I/KO_Iconversion KO_C2I/KO_Iconversion]; 

y_ipsi=[WT_ipsi; KO_ipsi]; 
b1=bar(categoriesIPSI,y_ipsi, 0.9); 
hold on 
b1(1).FaceColor=[0.3 0.3 0.3]; 
b1(2).FaceColor=[.8 0 1]; 
ylim([0 1]); 
title('Ipsilateral Neurons')
legend('WT', 'KO'); 
box off; 

%plot for binocular cells 
nexttile
categoriesBINOC=categorical({'U2B', 'I2B', 'C2B'}); 
categoriesBINOC=reordercats(categoriesBINOC, {'U2B', 'I2B', 'C2B'}); 

WT_binoc=[(WT_U2B/WT_Bconversion) WT_I2B/WT_Bconversion WT_C2B/WT_Bconversion]; 
KO_binoc=[(KO_U2B/KO_Bconversion) KO_B2I/KO_Bconversion KO_C2I/KO_Bconversion]; 

y_binoc=[WT_binoc; KO_binoc]; 
b2=bar(categoriesBINOC,y_binoc, 0.9); 
hold on 
b2(1).FaceColor=[0.3 0.3 0.3]; 
b2(2).FaceColor=[.8 0 1]; 
ylim([0 1]); 
title('Binocular Neurons')
legend('WT', 'KO'); 
box off; 
hold off 

%plot for unresponsive cells 
nexttile
categoriesUNRESP=categorical({'B2U', 'I2U', 'C2U'}); 
categoriesUNRESP=reordercats(categoriesUNRESP, {'B2U', 'I2U', 'C2U'}); 

WT_unresp=[(WT_B2U/WT_Uconversion) WT_I2U/WT_Uconversion WT_C2U/WT_Uconversion]; 
KO_unresp=[(KO_B2U/KO_Uconversion) KO_B2U/KO_Uconversion KO_C2U/KO_Uconversion]; 

y_unresp=[WT_unresp; KO_unresp]; 
b3=bar(categoriesUNRESP,y_unresp, 0.9); 
hold on 
b3(1).FaceColor=[0.3 0.3 0.3]; 
b3(2).FaceColor=[.8 0 1]; 
ylim([0 1]); 
title('Unresponsive Neurons')
legend('WT', 'KO'); 
box off; 
hold off 

saveas(fig_cellID, fullfile(SaveDir,'CellConversionWTvsKO'),'pdf'); 
saveas(fig_cellID, fullfile(SaveDir,'CellConversionWTvsKO'),'tif');
saveas(fig_cellID, fullfile(SaveDir,'CellConversionWTvsKO'),'fig');

%% 
end 


