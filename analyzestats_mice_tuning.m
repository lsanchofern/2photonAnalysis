function analyzestats_mice_tuning()
%function to analyze KOvs KO, preMD vs MD
%compare tuning across conditions and genotypes 

%% some set up 

%set save directory 

global SaveDir
SaveDir = ['L:\AnalyzedData\calcium\groupstats-MD experiment\'];
if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

%% Cell Identity loading directory 

AnalDirWT= ['L:\Laura\MouseMeasures-MD experiment\WT']; 
AnalDirKO= ['L:\Laura\MouseMeasures-MD experiment\KO'];

if ~exist(AnalDirWT,'dir') 
         mkdir (AnalDirWT)
 end

if ~exist(AnalDirKO,'dir') 
         mkdir (AnalDirKO)
end

%readin structure with longitudinally tracked cell identity
%DSI
%WT mice 
WTfile_ID_DSI=dir(fullfile(AnalDirWT,'*_CellIdentity_DSI.mat')); 
for i=1:numel(WTfile_ID_DSI)
    WTfile_CellID_DSI(i)=load(fullfile(AnalDirWT, WTfile_ID_DSI(i).name)); 
end 

%KO mice 
KOfile_ID_DSI=dir(fullfile(AnalDirKO,'*_CellIdentity_DSI.mat')); 
for i=1:numel(KOfile_ID_DSI)
    KOfile_CellID_DSI(i)=load(fullfile(AnalDirKO, KOfile_ID_DSI(i).name)); 
end 

%OSI
%WT mice 
WTfile_ID_OSI=dir(fullfile(AnalDirWT,'*_CellIdentity_OSI.mat')); 
for i=1:numel(WTfile_ID_OSI)
    WTfile_CellID_OSI(i)=load(fullfile(AnalDirWT, WTfile_ID_OSI(i).name)); 
end 

%KO mice 
KOfile_ID_OSI=dir(fullfile(AnalDirKO,'*_CellIdentity_OSI.mat')); 
for i=1:numel(KOfile_ID_OSI)
    KOfile_CellID_OSI(i)=load(fullfile(AnalDirKO, KOfile_ID_OSI(i).name)); 
end 
%% Pre MD 

%set data origin directory for preMD 
AnalDirWTpre= ['L:\Laura\MouseMeasures-MD experiment\WT\preMD']; 
AnalDirKOpre= ['L:\Laura\MouseMeasures-MD experiment\KO\preMD']; 
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
WTfile_contra=dir(fullfile(AnalDirWTpre,'*_OSI_pre_contra.mat')); 
for i=1:numel(WTfile_contra)
    WTDrift_pre_contra(i)=load(fullfile(AnalDirWTpre, WTfile_contra(i).name)); 
end 
WTfile_ipsi=dir(fullfile(AnalDirWTpre,'*_OSI_pre_ipsi.mat')); 
for i=1:numel(WTfile_ipsi)
    WTDrift_pre_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile_ipsi(i).name)); 
end 

%KO mice 
KOfile_contra=dir(fullfile(AnalDirKOpre,'*_OSI_pre_contra.mat')); 
for i=1:numel(KOfile_contra)
    KODrift_pre_contra(i)=load(fullfile(AnalDirKOpre, KOfile_contra(i).name)); 
end 

KOfile_ipsi=dir(fullfile(AnalDirKOpre,'*_OSI_pre_ipsi.mat')); 
for i=1:numel(KOfile_ipsi)
    KODrift_pre_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile_ipsi(i).name)); 
end

%all cells, regardless of longitudinal tracked 
%WT mice 
WTfile_contra_all=dir(fullfile(AnalDirWTpre,'*_preMD_OSI_contra_AllCells.mat')); 
for i=1:numel(WTfile_contra_all)
    WTDrift_pre_contra_all(i)=load(fullfile(AnalDirWTpre, WTfile_contra_all(i).name)); 
end 
WTfile_ipsi_all=dir(fullfile(AnalDirWTpre,'*_preMD_OSI_ipsi_AllCells.mat')); 
for i=1:numel(WTfile_ipsi_all)
    WTDrift_pre_ipsi_all(i)=load(fullfile(AnalDirWTpre, WTfile_ipsi_all(i).name)); 
end 

%KO mice 
KOfile_contra_all=dir(fullfile(AnalDirKOpre,'*_preMD_OSI_contra_AllCells.mat')); 
for i=1:numel(KOfile_contra_all)
    KODrift_pre_contra_all(i)=load(fullfile(AnalDirKOpre, KOfile_contra_all(i).name)); 
end 

KOfile_ipsi_all=dir(fullfile(AnalDirKOpre,'*_preMD_OSI_ipsi_AllCells.mat')); 
for i=1:numel(KOfile_ipsi_all)
    KODrift_pre_ipsi_all(i)=load(fullfile(AnalDirKOpre, KOfile_ipsi_all(i).name)); 
end



%% post MD 

%set data origin directory for postMD 
AnalDirWTpost= ['L:\Laura\MouseMeasures-MD experiment\WT\postMD']; 
AnalDirKOpost= ['L:\Laura\MouseMeasures-MD experiment\KO\postMD']; 
 if ~exist(AnalDirWTpost,'dir') 
         mkdir (AnalDirWTpost)
 end

if ~exist(AnalDirKOpost,'dir') 
         mkdir (AnalDirKOpost)
end

%read in structures from each mouse 

%read-in SigCellsDrift (for OSI measurements- drifting grating stimulus)
%this is based off the dFoF- calcium signal 

%WT mice 
WTfile_contra=dir(fullfile(AnalDirWTpost,'*_OSI_post_contra.mat')); 
for i=1:numel(WTfile_contra)
    WTDrift_post_contra(i)=load(fullfile(AnalDirWTpost, WTfile_contra(i).name)); 
end 
WTfile_ipsi=dir(fullfile(AnalDirWTpost,'*_OSI_post_ipsi.mat')); 
for i=1:numel(WTfile_ipsi)
    WTDrift_post_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile_ipsi(i).name)); 
end


%KO mice 
KOfile_contra=dir(fullfile(AnalDirKOpost,'*_OSI_post_contra.mat')); 
for i=1:numel(KOfile_contra)
    KODrift_post_contra(i)=load(fullfile(AnalDirKOpost, KOfile_contra(i).name)); 
end 

KOfile_ipsi=dir(fullfile(AnalDirKOpost,'*_OSI_post_ipsi.mat')); 
for i=1:numel(KOfile_ipsi)
    KODrift_post_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile_ipsi(i).name)); 
end

%all cells, regardless of longitudinal tracked 
%WT mice 
WTfile_contra_all=dir(fullfile(AnalDirWTpost,'*_postMD_OSI_contra_AllCells.mat')); 
for i=1:numel(WTfile_contra_all)
    WTDrift_post_contra_all(i)=load(fullfile(AnalDirWTpost, WTfile_contra_all(i).name)); 
end 
WTfile_ipsi_all=dir(fullfile(AnalDirWTpost,'*_postMD_OSI_ipsi_AllCells.mat')); 
for i=1:numel(WTfile_ipsi_all)
    WTDrift_post_ipsi_all(i)=load(fullfile(AnalDirWTpost, WTfile_ipsi_all(i).name)); 
end 

%KO mice 
KOfile_contra_all=dir(fullfile(AnalDirKOpost,'*_postMD_OSI_contra_AllCells.mat')); 
for i=1:numel(KOfile_contra_all)
    KODrift_post_contra_all(i)=load(fullfile(AnalDirKOpost, KOfile_contra_all(i).name)); 
end 

KOfile_ipsi_all=dir(fullfile(AnalDirKOpost,'*_postMD_OSI_ipsi_AllCells.mat')); 
for i=1:numel(KOfile_ipsi_all)
    KODrift_post_ipsi_all(i)=load(fullfile(AnalDirKOpost, KOfile_ipsi_all(i).name)); 
end

%% plot drifting gratings- OSI 
%first organized the data into concatenated vectors 

% CONTRALATERAL EYE RESPONSES 
%WT, preMD
WT_preOSI_contra=[]; 
for i=1:length(WTDrift_pre_contra) %for all the mice 
    WT_preOSI_contra=[WT_preOSI_contra; WTDrift_pre_contra(i).OSI_pre_contra];
end 

%WT,postMD
WT_postOSI_contra=[]; 
for i=1:length(WTDrift_post_contra) %for all the mice 
    WT_postOSI_contra=[WT_postOSI_contra; WTDrift_post_contra(i).OSI_post_contra];
end 

%KO,preMD
KO_preOSI_contra=[]; 
for i=1:length(KODrift_pre_contra) %for all the mice 
    KO_preOSI_contra=[KO_preOSI_contra; KODrift_pre_contra(i).OSI_pre_contra];
end 

%KO,postMD
KO_postOSI_contra=[]; 
for i=1:length(KODrift_post_contra) %for all the mice 
    KO_postOSI_contra=[KO_postOSI_contra; KODrift_post_contra(i).OSI_post_contra];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_preOSI_ipsi=[]; 
for i=1:length(WTDrift_pre_ipsi) %for all the mice 
    WT_preOSI_ipsi=[WT_preOSI_ipsi; WTDrift_pre_ipsi(i).OSI_pre_ipsi];
end 

%WT,postMD
WT_postOSI_ipsi=[]; 
for i=1:length(WTDrift_post_ipsi) %for all the mice 
    WT_postOSI_ipsi=[WT_postOSI_ipsi; WTDrift_post_ipsi(i).OSI_post_ipsi];
end 

%KO,preMD
KO_preOSI_ipsi=[]; 
for i=1:length(KODrift_pre_ipsi) %for all the mice 
    KO_preOSI_ipsi=[KO_preOSI_ipsi; KODrift_pre_ipsi(i).OSI_pre_ipsi];
end 

%KO,postMD
KO_postOSI_ipsi=[]; 
for i=1:length(KODrift_post_ipsi) %for all the mice 
    KO_postOSI_ipsi=[KO_postOSI_ipsi; KODrift_post_ipsi(i).OSI_post_ipsi];
end 


%% put data in a table for two way anova 
char_WT=strings(length(WT_preOSI_contra),9); 

for i=1:length(WT_preOSI_contra)
    char_WT(i,1)='pre';
    char_WT(i,2)='post';
    char_WT(i,3)='WT'; 
    char_WT(i,4)='contra'; 
    char_WT (i,5)='ipsi'; 
    char_WT(i,6)='pre WT contra'; 
    char_WT(i,7)='pre WT ipsi'; 
    char_WT(i,8)='post WT contra'; 
    char_WT(i,9)='post WT ipsi'; 
end 
char_KO=strings(length(KO_preOSI_contra),9); 

for i=1:length(KO_preOSI_contra)
    char_KO(i,1)='pre';
    char_KO(i,2)='post';
    char_KO(i,3)='KO'; 
    char_KO(i,4)='contra'; 
    char_KO (i,5)='ipsi'; 
    char_KO(i,6)='pre KO contra'; 
    char_KO(i,7)='pre KO ipsi'; 
    char_KO(i,8)='post KO contra'; 
    char_KO(i,9)='post KO ipsi';  
end 

%make an empty table

cv_dsi=vertcat(WT_preOSI_contra, WT_postOSI_contra, KO_preOSI_contra, KO_postOSI_contra,...
    WT_preOSI_ipsi, WT_postOSI_ipsi, KO_preOSI_ipsi, KO_postOSI_ipsi); %pre, post, pre, post  
genotype=vertcat(char_WT(:,3), char_WT(:,3), char_KO(:,3), char_KO(:,3),...
    char_WT(:,3), char_WT(:,3), char_KO(:,3), char_KO(:,3)); %WT then KO

condition=vertcat(char_WT(:,1), char_WT(:,2), char_KO(:,1), char_KO(:,2),...
    char_WT(:,1), char_WT(:,2), char_KO(:,1), char_KO(:,2)); %pre, post, pre, post

eye=vertcat(char_WT(:,4), char_WT(:,4), char_KO(:,4), char_KO(:,4),...
    char_WT(:,5), char_WT(:,5), char_KO(:,5), char_KO(:,5)); %contra, then ipsi 

group= vertcat(char_WT(:,6), char_WT(:,8), char_KO(:,6), char_KO(:,8),...
    char_WT(:,7), char_WT(:,9), char_KO(:,7), char_KO(:,9)); 

OSItable=table(cv_dsi,genotype,condition,eye,group); 

%two way anova 
[p,tbl,stats]=anovan(OSItable.cv_dsi,{OSItable.condition,OSItable.genotype,OSItable.eye},...
    'model', 'interaction', 'varnames', {'condition', 'genotype', 'eye'},'display','off'); 
%save table 
save(fullfile(SaveDir,'ANOVAresults.mat'),'tbl'); 

%multicomparisons
[results,m,h,gnames]=multcompare(stats,"Dimension", [1 2 3],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi=array2table(results,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi.("Group A")=gnames(tbl_multi.("Group A")); 
tbl_multi.("Group B")=gnames(tbl_multi.("Group B")); 

%save
save(fullfile(SaveDir,'OSI_MultipleComparisons.mat'),'tbl_multi'); 

%make swarmchart plot 
swarmchartplot=figure(1);
groupnames={'pre WT contra', 'pre KO contra', 'post WT contra', 'post KO contra',...
    'pre WT ipsi', 'pre KO ipsi', 'post WT ipsi', 'post KO ipsi'}; 
vio_color=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1],...
    [0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
vs=violinplot(OSItable.cv_dsi, OSItable.group,'GroupOrder', groupnames,'ViolinColor', vio_color); 
ylim([0 1]); 
title('OSI Tuning')
ylabel('cv')
xlabel('Group')

% % 
% % %make histograms for each condition 
% % 
% % %scales 
% % 
% % f2=figure(2);
% % t=tiledlayout(2,2); 
% % %WT pre 
% % nexttile
% % h1=histogram(WT_preDSI_contra, 10, 'FaceColor', [0.3 0.3 0.3]);
% % xlim([-1 1]); 
% % ylim([0 10])
% % title ('WT- pre MD')
% % box off 
% % %WT post 
% % nexttile
% % h2=histogram(WT_postDSI_contra, 10, 'FaceColor', [0.7 0.7 0.7]);
% % xlim([-1 1]); 
% % ylim([0 10])
% % title('WT- post MD')
% % box off 
% % %KO pre 
% % nexttile
% % h3=histogram(KO_preDSI_contra, 10, 'FaceColor', [.8 0 1]);
% % xlim([-1 1]); 
% % ylim([0 20])
% % title('KO- pre MD')
% % box off 
% % %KO post 
% % nexttile
% % h4=histogram(KO_postDSI_contra, 10, 'FaceColor', [.8 0.7 1]);
% % xlim([-1 1]);
% % ylim([0 20])
% % title ('KO- post MD')
% % box off 
% % title(t,'Ocular Dominance')
% % xlabel(t,'ODI')
% % ylabel(t,'Number of Neurons')

%save figure 
saveas(swarmchartplot, fullfile(SaveDir, 'OriTuning'), 'pdf');
saveas(swarmchartplot, fullfile(SaveDir, 'OriTuning'), 'tif');
saveas(swarmchartplot, fullfile(SaveDir, 'OriTuning'), 'fig');


%% plot drifting gratings- OSI - ALL CELLS 
%first organized the data into concatenated vectors 

% CONTRALATERAL EYE RESPONSES 
%WT, preMD
WT_preOSI_contra_all=[]; 
for i=1:length(WTDrift_pre_contra_all) %for all the mice 
    WT_preOSI_contra_all=[WT_preOSI_contra_all; WTDrift_pre_contra_all(i).preMD_OSI_contra'];
end 

%WT,postMD
WT_postOSI_contra_all=[]; 
for i=1:length(WTDrift_post_contra_all) %for all the mice 
    WT_postOSI_contra_all=[WT_postOSI_contra_all; WTDrift_post_contra_all(i).postMD_OSI_contra'];
end 

%KO,preMD
KO_preOSI_contra_all=[]; 
for i=1:length(KODrift_pre_contra_all) %for all the mice 
    KO_preOSI_contra_all=[KO_preOSI_contra_all; KODrift_pre_contra_all(i).preMD_OSI_contra'];
end 

%KO,postMD
KO_postOSI_contra_all=[]; 
for i=1:length(KODrift_post_contra_all) %for all the mice 
    KO_postOSI_contra_all=[KO_postOSI_contra_all; KODrift_post_contra_all(i).postMD_OSI_contra'];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_preOSI_ipsi_all=[]; 
for i=1:length(WTDrift_pre_ipsi_all) %for all the mice 
    WT_preOSI_ipsi_all=[WT_preOSI_ipsi_all; WTDrift_pre_ipsi_all(i).preMD_OSI_ipsi'];
end 

%WT,postMD
WT_postOSI_ipsi_all=[]; 
for i=1:length(WTDrift_post_ipsi_all) %for all the mice 
    WT_postOSI_ipsi_all=[WT_postOSI_ipsi_all; WTDrift_post_ipsi_all(i).postMD_OSI_ipsi'];
end 

%KO,preMD
KO_preOSI_ipsi_all=[]; 
for i=1:length(KODrift_pre_ipsi_all) %for all the mice 
    KO_preOSI_ipsi_all=[KO_preOSI_ipsi_all; KODrift_pre_ipsi_all(i).preMD_OSI_ipsi'];
end 

%KO,postMD
KO_postOSI_ipsi_all=[]; 
for i=1:length(KODrift_post_ipsi_all) %for all the mice 
    KO_postOSI_ipsi_all=[KO_postOSI_ipsi_all; KODrift_post_ipsi_all(i).postMD_OSI_ipsi'];
end 

%% put data in a table for two way anova -ALLCELLs 
char_WT_pre_all=strings(length(WT_preOSI_contra_all),6); 

for i=1:length(WT_preOSI_contra_all)
    char_WT_pre_all(i,1)='pre';
    char_WT_pre_all(i,2)='WT'; 
    char_WT_pre_all(i,3)='contra'; 
    char_WT_pre_all(i,4)='ipsi'; 
    char_WT_pre_all(i,5)='pre WT contra'; 
    char_WT_pre_all(i,6)='pre WT ipsi'; 
end 

char_WT_post_all=strings(length(WT_postOSI_contra_all),6); 

for i=1:length(WT_postOSI_contra_all)
    char_WT_post_all(i,1)='post';
    char_WT_post_all(i,2)='WT'; 
    char_WT_post_all(i,3)='contra'; 
    char_WT_post_all(i,4)='ipsi'; 
    char_WT_post_all(i,5)='post WT contra'; 
    char_WT_post_all(i,6)='post WT ipsi'; 
end 

char_KO_pre_all=strings(length(KO_preOSI_contra_all),6); 

for i=1:length(KO_preOSI_contra_all)
    char_KO_pre_all(i,1)='pre';
    char_KO_pre_all(i,2)='KO'; 
    char_KO_pre_all(i,3)='contra'; 
    char_KO_pre_all(i,4)='ipsi'; 
    char_KO_pre_all(i,5)='pre KO contra'; 
    char_KO_pre_all(i,6)='pre KO ipsi';
end 

char_KO_post_all=strings(length(KO_postOSI_contra_all),6); 

for i=1:length(KO_postOSI_contra_all)
    char_KO_post_all(i,1)='post';
    char_KO_post_all(i,2)='KO'; 
    char_KO_post_all(i,3)='contra'; 
    char_KO_post_all(i,4)='ipsi'; 
    char_KO_post_all(i,5)='post KO contra'; 
    char_KO_post_all(i,6)='post KO ipsi';
end 

%make an empty table

cv_osi_all=vertcat(WT_preOSI_contra_all, WT_postOSI_contra_all, KO_preOSI_contra_all, KO_postOSI_contra_all,...
    WT_preOSI_ipsi_all, WT_postOSI_ipsi_all, KO_preOSI_ipsi_all, KO_postOSI_ipsi_all); %pre, post, pre, post  

genotype_all=vertcat(char_WT_pre_all(:,2), char_WT_post_all(:,2), char_KO_pre_all(:,2), char_KO_post_all(:,2),...
    char_WT_pre_all(:,2), char_WT_post_all(:,2), char_KO_pre_all(:,2), char_KO_post_all(:,2)); %WT then KO

condition_all=vertcat(char_WT_pre_all(:,1), char_WT_post_all(:,1), char_KO_pre_all(:,1), char_KO_post_all(:,1),...
    char_WT_pre_all(:,1), char_WT_post_all(:,1), char_KO_pre_all(:,1), char_KO_post_all(:,1)); %pre, post, pre, post

eye_all=vertcat(char_WT_pre_all(:,3), char_WT_post_all(:,3), char_KO_pre_all(:,3), char_KO_post_all(:,3),...
    char_WT_pre_all(:,4), char_WT_post_all(:,4), char_KO_pre_all(:,4), char_KO_post_all(:,4)); %contra, then ipsi 

group_all= vertcat(char_WT_pre_all(:,5), char_WT_post_all(:,5), char_KO_pre_all(:,5), char_KO_post_all(:,5),...
    char_WT_pre_all(:,6), char_WT_post_all(:,6), char_KO_pre_all(:,6), char_KO_post_all(:,6)); 

OSItable_all=table(cv_osi_all,genotype_all,condition_all,eye_all,group_all); 

%two way anova 
[p_all,tbl_all,stats_all]=anovan(OSItable_all.cv_osi_all,{OSItable_all.condition_all,OSItable_all.genotype_all,OSItable_all.eye_all},...
    'model', 'interaction', 'varnames', {'condition', 'genotype', 'eye'},'display','off'); 
%save table 
save(fullfile(SaveDir,'Allcells-OSI-ANOVAresults.mat'),'tbl_all'); 

%multicomparisons
[results_all,m_all,h_all,gnames_all]=multcompare(stats_all,"Dimension", [1 2 3],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi_all=array2table(results_all,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi_all.("Group A")=gnames_all(tbl_multi_all.("Group A")); 
tbl_multi_all.("Group B")=gnames_all(tbl_multi_all.("Group B")); 

%save
save(fullfile(SaveDir,'AllCells_OSI_MultipleComparisons.mat'),'tbl_multi_all'); 

%make swarmchart plot 
swarmchartplot_all=figure(2);
groupnames={'pre WT contra', 'pre KO contra', 'post WT contra', 'post KO contra',...
    'pre WT ipsi', 'pre KO ipsi', 'post WT ipsi', 'post KO ipsi'}; 
vio_color=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1],...
    [0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
vs=violinplot(OSItable_all.cv_osi_all, OSItable_all.group_all,'GroupOrder', groupnames,'ViolinColor', vio_color); 
ylim([0 1]); 
title('All Cells-OSI Tuning')
ylabel('cv')
xlabel('Group')

% % 
% % %make histograms for each condition 
% % 
% % %scales 
% % 
% % f2=figure(2);
% % t=tiledlayout(2,2); 
% % %WT pre 
% % nexttile
% % h1=histogram(WT_preDSI_contra, 10, 'FaceColor', [0.3 0.3 0.3]);
% % xlim([-1 1]); 
% % ylim([0 10])
% % title ('WT- pre MD')
% % box off 
% % %WT post 
% % nexttile
% % h2=histogram(WT_postDSI_contra, 10, 'FaceColor', [0.7 0.7 0.7]);
% % xlim([-1 1]); 
% % ylim([0 10])
% % title('WT- post MD')
% % box off 
% % %KO pre 
% % nexttile
% % h3=histogram(KO_preDSI_contra, 10, 'FaceColor', [.8 0 1]);
% % xlim([-1 1]); 
% % ylim([0 20])
% % title('KO- pre MD')
% % box off 
% % %KO post 
% % nexttile
% % h4=histogram(KO_postDSI_contra, 10, 'FaceColor', [.8 0.7 1]);
% % xlim([-1 1]);
% % ylim([0 20])
% % title ('KO- post MD')
% % box off 
% % title(t,'Ocular Dominance')
% % xlabel(t,'ODI')
% % ylabel(t,'Number of Neurons')

%save figure 
saveas(swarmchartplot_all, fullfile(SaveDir, 'OriTuning'), 'pdf');
saveas(swarmchartplot_all, fullfile(SaveDir, 'OriTuning'), 'tif');
saveas(swarmchartplot_all, fullfile(SaveDir, 'OriTuning'), 'fig'); 

%% Contralateral cell tuning 


end 


