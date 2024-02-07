function analyzestats_mice_OD()
%function to analyze KOvs KO, preMD vs MD
%compare OD across conditions and genotypes 
%look at binocular matching (pref_ori) as well 



%% some set up 

%set save directory 

global SaveDir
SaveDir = ['L:\Laura\AnalyzedData\calcium\groupstats-MD experiment\'];
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
WTfile=dir(fullfile(AnalDirWTpre,'*OD_pre.mat')); 
for i=1:numel(WTfile)
    WTDrift_pre(i)=load(fullfile(AnalDirWTpre, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpre,'*OD_pre.mat')); 
for i=1:numel(KOfile)
    KODrift_pre(i)=load(fullfile(AnalDirKOpre, KOfile(i).name)); 
end 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpre,'*dFoF_contra_pre.mat')); 
for i=1:numel(WTfile)
    WTDrift_dFoF_pre_contra(i)=load(fullfile(AnalDirWTpre, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpre,'*dFoF_contra_pre.mat')); 
for i=1:numel(KOfile)
    KODrift_dFoF_pre_contra(i)=load(fullfile(AnalDirKOpre, KOfile(i).name)); 
end 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpre,'*dFoF_ipsi_pre.mat')); 
for i=1:numel(WTfile)
    WTDrift_dFoF_pre_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpre,'*dFoF_ipsi_pre.mat')); 
for i=1:numel(KOfile)
    KODrift_dFoF_pre_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile(i).name)); 
end 


%ODI for all cells (regardless of longitudinal) 

%WT mice 
WTfile_all=dir(fullfile(AnalDirWTpre,'*_OD_pre_AllCells.mat')); 
for i=1:numel(WTfile_all)
    WTDrift_pre_all(i)=load(fullfile(AnalDirWTpre, WTfile_all(i).name)); 
end 

%KO mice 
KOfile_all=dir(fullfile(AnalDirKOpre,'*_OD_pre_AllCells.mat')); 
for i=1:numel(KOfile_all)
    KODrift_pre_all(i)=load(fullfile(AnalDirKOpre, KOfile_all(i).name)); 
end 

%binoc for all binoc cells (regardless of longitudinal) 

%WT mice 
WTfile_all_binoc_contra=dir(fullfile(AnalDirWTpre,'*_Oripref_pre_contra_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_contra)
    WTDrift_all_binoc_contra_pre(i)=load(fullfile(AnalDirWTpre, WTfile_all_binoc_contra(i).name)); 
end 

%KO mice 
KOfile_all_binoc_contra=dir(fullfile(AnalDirKOpre,'*_Oripref_pre_contra_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_contra)
    KODrift_all_binoc_contra_pre(i)=load(fullfile(AnalDirKOpre, KOfile_all_binoc_contra(i).name)); 
end 

%WT mice 
WTfile_all_binoc_ipsi=dir(fullfile(AnalDirWTpre,'*_Oripref_pre_ipsi_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_ipsi)
    WTDrift_all_binoc_ipsi_pre(i)=load(fullfile(AnalDirWTpre, WTfile_all_binoc_ipsi(i).name)); 
end 

%KO mice 
KOfile_all_binoc_ipsi=dir(fullfile(AnalDirKOpre,'*_Oripref_pre_ipsi_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_ipsi)
    KODrift_all_binoc_ipsi_pre(i)=load(fullfile(AnalDirKOpre, KOfile_all_binoc_ipsi(i).name)); 
end 


%binocular matching 
%WT mice 
WTfile_contra=dir(fullfile(AnalDirWTpre,'*Oripref_pre_contra.mat')); 
for i=1:numel(WTfile_contra)
    WTDrift_pre_contra(i)=load(fullfile(AnalDirWTpre, WTfile_contra(i).name)); 
end 
WTfile_ipsi=dir(fullfile(AnalDirWTpre,'*Oripref_pre_ipsi.mat')); 
for i=1:numel(WTfile_ipsi)
    WTDrift_pre_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile_ipsi(i).name)); 
end 

%KO mice 
KOfile_contra=dir(fullfile(AnalDirKOpre,'*Oripref_pre_contra.mat')); 
for i=1:numel(KOfile_contra)
    KODrift_pre_contra(i)=load(fullfile(AnalDirKOpre, KOfile_contra(i).name)); 
end 

KOfile_ipsi=dir(fullfile(AnalDirKOpre,'*Oripref_pre_ipsi.mat')); 
for i=1:numel(KOfile_ipsi)
    KODrift_pre_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile_ipsi(i).name)); 
end

%binocular tuning -cv 
%WT mice 
WTfile_cv_contra=dir(fullfile(AnalDirWTpre,'*cv_pre_contra.mat')); 
for i=1:numel(WTfile_cv_contra)
    WTDrift_pre_cv_contra(i)=load(fullfile(AnalDirWTpre, WTfile_cv_contra(i).name)); 
end 
WTfile_cv_ipsi=dir(fullfile(AnalDirWTpre,'*cv_pre_ipsi.mat')); 
for i=1:numel(WTfile_cv_ipsi)
    WTDrift_pre_cv_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile_cv_ipsi(i).name)); 
end 

%KO mice 
KOfile_cv_contra=dir(fullfile(AnalDirKOpre,'*cv_pre_contra.mat')); 
for i=1:numel(KOfile_cv_contra)
    KODrift_pre_cv_contra(i)=load(fullfile(AnalDirKOpre, KOfile_cv_contra(i).name)); 
end 

KOfile_cv_ipsi=dir(fullfile(AnalDirKOpre,'*cv_pre_ipsi.mat')); 
for i=1:numel(KOfile_cv_ipsi)
    KODrift_pre_cv_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile_cv_ipsi(i).name)); 
end


%contralateral and ipsilateral eye pref  

%WT mice 
WTfile_contra_only=dir(fullfile(AnalDirWTpre,'*Oripref_pre_contra_only.mat')); 
for i=1:numel(WTfile_contra_only)
    WTDrift_pre_contra_only(i)=load(fullfile(AnalDirWTpre, WTfile_contra_only(i).name)); 
end 
WTfile_ipsi_only=dir(fullfile(AnalDirWTpre,'*Oripref_pre_ipsi_only.mat')); 
for i=1:numel(WTfile_ipsi_only)
    WTDrift_pre_ipsi_only(i)=load(fullfile(AnalDirWTpre, WTfile_ipsi_only(i).name)); 
end 

%KO mice 
KOfile_contra_only=dir(fullfile(AnalDirKOpre,'*Oripref_pre_contra_only.mat')); 
for i=1:numel(KOfile_contra_only)
    KODrift_pre_contra_only(i)=load(fullfile(AnalDirKOpre, KOfile_contra_only(i).name)); 
end 

KOfile_ipsi_only=dir(fullfile(AnalDirKOpre,'*Oripref_pre_ipsi_only.mat')); 
for i=1:numel(KOfile_ipsi_only)
    KODrift_pre_ipsi_only(i)=load(fullfile(AnalDirKOpre, KOfile_ipsi_only(i).name)); 
end

%tuning- cv 
%WT mice 
WTfile_cv_contra_only=dir(fullfile(AnalDirWTpre,'*cv_pre_contra_only.mat')); 
for i=1:numel(WTfile_cv_contra_only)
    WTDrift_pre_cv_contra_only(i)=load(fullfile(AnalDirWTpre, WTfile_cv_contra_only(i).name)); 
end 
WTfile_cv_ipsi_only=dir(fullfile(AnalDirWTpre,'*cv_pre_ipsi_only.mat')); 
for i=1:numel(WTfile_cv_ipsi_only)
    WTDrift_pre_cv_ipsi_only(i)=load(fullfile(AnalDirWTpre, WTfile_cv_ipsi_only(i).name)); 
end 

%KO mice 
KOfile_cv_contra_only=dir(fullfile(AnalDirKOpre,'*cv_pre_contra_only.mat')); 
for i=1:numel(KOfile_cv_contra_only)
    KODrift_pre_cv_contra_only(i)=load(fullfile(AnalDirKOpre, KOfile_cv_contra_only(i).name)); 
end 

KOfile_cv_ipsi_only=dir(fullfile(AnalDirKOpre,'*cv_pre_ipsi_only.mat')); 
for i=1:numel(KOfile_cv_ipsi_only)
    KODrift_pre_cv_ipsi_only(i)=load(fullfile(AnalDirKOpre, KOfile_cv_ipsi_only(i).name)); 
end

% tuning width 
%binocular tuning -tuning width  
%WT mice 
WTfile_tw_contra=dir(fullfile(AnalDirWTpre,'*tuningwidth_pre_bin_contra.mat')); 
for i=1:numel(WTfile_tw_contra)
    WTDrift_pre_tw_contra(i)=load(fullfile(AnalDirWTpre, WTfile_tw_contra(i).name)); 
end 
WTfile_tw_ipsi=dir(fullfile(AnalDirWTpre,'*tuningwidth_pre_bin_ipsi.mat')); 
for i=1:numel(WTfile_tw_ipsi)
    WTDrift_pre_tw_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile_tw_ipsi(i).name)); 
end 

%KO mice 
KOfile_tw_contra=dir(fullfile(AnalDirKOpre,'*tuningwidth_pre_bin_contra.mat')); 
for i=1:numel(KOfile_tw_contra)
    KODrift_pre_tw_contra(i)=load(fullfile(AnalDirKOpre, KOfile_tw_contra(i).name)); 
end 

KOfile_tw_ipsi=dir(fullfile(AnalDirKOpre,'*tuningwidth_pre_bin_ipsi.mat')); 
for i=1:numel(KOfile_tw_ipsi)
    KODrift_pre_tw_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile_tw_ipsi(i).name)); 
end


%contralateral and ipsilateral   

%WT mice 
WTfile_tw_contra_only=dir(fullfile(AnalDirWTpre,'*tuningwidth_pre_contra.mat')); 
for i=1:numel(WTfile_tw_contra_only)
    WTDrift_tw_pre_contra_only(i)=load(fullfile(AnalDirWTpre, WTfile_tw_contra_only(i).name)); 
end 
WTfile_tw_ipsi_only=dir(fullfile(AnalDirWTpre,'*tuningwidth_pre_ipsi.mat')); 
for i=1:numel(WTfile_tw_ipsi_only)
    WTDrift_tw_pre_ipsi_only(i)=load(fullfile(AnalDirWTpre, WTfile_tw_ipsi_only(i).name)); 
end 

%KO mice 
KOfile_tw_contra_only=dir(fullfile(AnalDirKOpre,'*tuningwidth_pre_contra.mat')); 
for i=1:numel(KOfile_tw_contra_only)
    KODrift_tw_pre_contra_only(i)=load(fullfile(AnalDirKOpre, KOfile_tw_contra_only(i).name)); 
end 

KOfile_tw_ipsi_only=dir(fullfile(AnalDirKOpre,'*tuningwidth_pre_ipsi.mat')); 
for i=1:numel(KOfile_tw_ipsi_only)
    KODrift_tw_pre_ipsi_only(i)=load(fullfile(AnalDirKOpre, KOfile_tw_ipsi_only(i).name)); 
end

%response reliability metrics 
WTfile_cv_contra=dir(fullfile(AnalDirWTpre,'*reliability_preMD_contra.mat')); 
for i=1:numel(WTfile_cv_contra)
    WTDrift_cv_pre_contra(i)=load(fullfile(AnalDirWTpre, WTfile_cv_contra(i).name)); 
end 
WTfile_cv_ipsi=dir(fullfile(AnalDirWTpre,'*reliability_preMD_ipsi.mat')); 
for i=1:numel(WTfile_cv_ipsi)
    WTDrift_cv_pre_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile_cv_ipsi(i).name)); 
end 

KOfile_cv_contra=dir(fullfile(AnalDirKOpre,'*reliability_preMD_contra.mat')); 
for i=1:numel(KOfile_cv_contra)
    KODrift_cv_pre_contra(i)=load(fullfile(AnalDirKOpre, KOfile_cv_contra(i).name)); 
end 
KOfile_cv_ipsi=dir(fullfile(AnalDirKOpre,'*reliability_preMD_ipsi.mat')); 
for i=1:numel(KOfile_cv_ipsi)
    KODrift_cv_pre_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile_cv_ipsi(i).name)); 
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

%WT mice 
WTfile=dir(fullfile(AnalDirWTpost,'*_dFoF_contra_post.mat')); 
for i=1:numel(WTfile)
    WTDrift_dFoF_post_contra(i)=load(fullfile(AnalDirWTpost, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpost,'*_dFoF_contra_post.mat')); 
for i=1:numel(KOfile)
    KODrift_dFoF_post_contra(i)=load(fullfile(AnalDirKOpost, KOfile(i).name)); 
end 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpost,'*_dFoF_ipsi_post.mat')); 
for i=1:numel(WTfile)
    WTDrift_dFoF_post_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpost,'*_dFoF_ipsi_post.mat')); 
for i=1:numel(KOfile)
    KODrift_dFoF_post_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile(i).name)); 
end 

%ODI for all cells (regardless of longitudinal) 

%WT mice 
WTfile_all=dir(fullfile(AnalDirWTpost,'*_OD_post_AllCells.mat')); 
for i=1:numel(WTfile_all)
    WTDrift_post_all(i)=load(fullfile(AnalDirWTpost, WTfile_all(i).name)); 
end 

%KO mice 
KOfile_all=dir(fullfile(AnalDirKOpost,'*_OD_post_AllCells.mat')); 
for i=1:numel(KOfile_all)
    KODrift_post_all(i)=load(fullfile(AnalDirKOpost, KOfile_all(i).name)); 
end 

%binocular matching for all binoc cells (regardless of long. tracked)

%WT mice 
WTfile_all_binoc_contra=dir(fullfile(AnalDirWTpost,'*_Oripref_post_contra_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_contra)
    WTDrift_all_binoc_contra_post(i)=load(fullfile(AnalDirWTpost, WTfile_all_binoc_contra(i).name)); 
end 

%KO mice 
KOfile_all_binoc_contra=dir(fullfile(AnalDirKOpost,'*_Oripref_post_contra_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_contra)
    KODrift_all_binoc_contra_post(i)=load(fullfile(AnalDirKOpost, KOfile_all_binoc_contra(i).name)); 
end 

%WT mice 
WTfile_all_binoc_ipsi=dir(fullfile(AnalDirWTpost,'*_Oripref_post_ipsi_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_ipsi)
    WTDrift_all_binoc_ipsi_post(i)=load(fullfile(AnalDirWTpost, WTfile_all_binoc_ipsi(i).name)); 
end 

%KO mice 
KOfile_all_binoc_ipsi=dir(fullfile(AnalDirKOpost,'*_Oripref_post_ipsi_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_ipsi)
    KODrift_all_binoc_ipsi_post(i)=load(fullfile(AnalDirKOpost, KOfile_all_binoc_ipsi(i).name)); 
end 


%for the binocular matching (longitudinal)

%WT mice 
WTfile_contra=dir(fullfile(AnalDirWTpost,'*Oripref_post_contra.mat')); 
for i=1:numel(WTfile_contra)
    WTDrift_post_contra(i)=load(fullfile(AnalDirWTpost, WTfile_contra(i).name)); 
end 
WTfile_ipsi=dir(fullfile(AnalDirWTpost,'*Oripref_post_ipsi.mat')); 
for i=1:numel(WTfile_ipsi)
    WTDrift_post_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile_ipsi(i).name)); 
end


%KO mice 
KOfile_contra=dir(fullfile(AnalDirKOpost,'*Oripref_post_contra.mat')); 
for i=1:numel(KOfile_contra)
    KODrift_post_contra(i)=load(fullfile(AnalDirKOpost, KOfile_contra(i).name)); 
end 

KOfile_ipsi=dir(fullfile(AnalDirKOpost,'*Oripref_post_ipsi.mat')); 
for i=1:numel(KOfile_ipsi)
    KODrift_post_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile_ipsi(i).name)); 
end

% cv -binocular neurons 
%WT mice 
WTfile_cv_contra=dir(fullfile(AnalDirWTpost,'*cv_post_contra.mat')); 
for i=1:numel(WTfile_cv_contra)
    WTDrift_post_cv_contra(i)=load(fullfile(AnalDirWTpost, WTfile_cv_contra(i).name)); 
end 
WTfile_cv_ipsi=dir(fullfile(AnalDirWTpost,'*cv_post_ipsi.mat')); 
for i=1:numel(WTfile_cv_ipsi)
    WTDrift_post_cv_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile_cv_ipsi(i).name)); 
end 

%KO mice 
KOfile_cv_contra=dir(fullfile(AnalDirKOpost,'*cv_post_contra.mat')); 
for i=1:numel(KOfile_cv_contra)
    KODrift_post_cv_contra(i)=load(fullfile(AnalDirKOpost, KOfile_cv_contra(i).name)); 
end 

KOfile_cv_ipsi=dir(fullfile(AnalDirKOpost,'*cv_post_ipsi.mat')); 
for i=1:numel(KOfile_cv_ipsi)
    KODrift_post_cv_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile_cv_ipsi(i).name)); 
end


% contralateral and ipsilateral responses 
%WT mice 
WTfile_contra_only=dir(fullfile(AnalDirWTpost,'*Oripref_post_contra_only.mat')); 
for i=1:numel(WTfile_contra_only)
    WTDrift_post_contra_only(i)=load(fullfile(AnalDirWTpost, WTfile_contra_only(i).name)); 
end 
WTfile_ipsi_only=dir(fullfile(AnalDirWTpost,'*Oripref_post_ipsi_only.mat')); 
for i=1:numel(WTfile_ipsi_only)
    WTDrift_post_ipsi_only(i)=load(fullfile(AnalDirWTpost, WTfile_ipsi_only(i).name)); 
end 

%KO mice 
KOfile_contra_only=dir(fullfile(AnalDirKOpost,'*Oripref_post_contra_only.mat')); 
for i=1:numel(KOfile_contra_only)
    KODrift_post_contra_only(i)=load(fullfile(AnalDirKOpost, KOfile_contra_only(i).name)); 
end 

KOfile_ipsi_only=dir(fullfile(AnalDirKOpost,'*Oripref_post_ipsi_only.mat')); 
for i=1:numel(KOfile_ipsi_only)
    KODrift_post_ipsi_only(i)=load(fullfile(AnalDirKOpost, KOfile_ipsi_only(i).name)); 
end

% cv 
%WT mice 
WTfile_cv_contra_only=dir(fullfile(AnalDirWTpost,'*cv_post_contra_only.mat')); 
for i=1:numel(WTfile_cv_contra_only)
    WTDrift_post_cv_contra_only(i)=load(fullfile(AnalDirWTpost, WTfile_cv_contra_only(i).name)); 
end 
WTfile_cv_ipsi_only=dir(fullfile(AnalDirWTpost,'*cv_post_ipsi_only.mat')); 
for i=1:numel(WTfile_cv_ipsi_only)
    WTDrift_post_cv_ipsi_only(i)=load(fullfile(AnalDirWTpost, WTfile_cv_ipsi_only(i).name)); 
end 

%KO mice 
KOfile_cv_contra_only=dir(fullfile(AnalDirKOpost,'*cv_post_contra_only.mat')); 
for i=1:numel(KOfile_cv_contra_only)
    KODrift_post_cv_contra_only(i)=load(fullfile(AnalDirKOpost, KOfile_cv_contra_only(i).name)); 
end 

KOfile_cv_ipsi_only=dir(fullfile(AnalDirKOpost,'*cv_post_ipsi_only.mat')); 
for i=1:numel(KOfile_cv_ipsi_only)
    KODrift_post_cv_ipsi_only(i)=load(fullfile(AnalDirKOpost, KOfile_cv_ipsi_only(i).name)); 
end

% tuning width 
%binocular tuning -tuning width  
%WT mice 
WTfile_tw_contra=dir(fullfile(AnalDirWTpost,'*tuningwidth_post_bin_contra.mat')); 
for i=1:numel(WTfile_tw_contra)
    WTDrift_post_tw_contra(i)=load(fullfile(AnalDirWTpost, WTfile_tw_contra(i).name)); 
end 
WTfile_tw_ipsi=dir(fullfile(AnalDirWTpost,'*tuningwidth_post_bin_ipsi.mat')); 
for i=1:numel(WTfile_tw_ipsi)
    WTDrift_post_tw_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile_tw_ipsi(i).name)); 
end 

%KO mice 
KOfile_tw_contra=dir(fullfile(AnalDirKOpost,'*tuningwidth_post_bin_contra.mat')); 
for i=1:numel(KOfile_tw_contra)
    KODrift_post_tw_contra(i)=load(fullfile(AnalDirKOpost, KOfile_tw_contra(i).name)); 
end 

KOfile_tw_ipsi=dir(fullfile(AnalDirKOpost,'*tuningwidth_post_bin_ipsi.mat')); 
for i=1:numel(KOfile_tw_ipsi)
    KODrift_post_tw_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile_tw_ipsi(i).name)); 
end


%contralateral and ipsilateral   

%WT mice 
WTfile_tw_contra_only=dir(fullfile(AnalDirWTpost,'*tuningwidth_post_contra.mat')); 
for i=1:numel(WTfile_tw_contra_only)
    WTDrift_tw_post_contra_only(i)=load(fullfile(AnalDirWTpost, WTfile_tw_contra_only(i).name)); 
end 
WTfile_tw_ipsi_only=dir(fullfile(AnalDirWTpost,'*tuningwidth_post_ipsi.mat')); 
for i=1:numel(WTfile_tw_ipsi_only)
    WTDrift_tw_post_ipsi_only(i)=load(fullfile(AnalDirWTpost, WTfile_tw_ipsi_only(i).name)); 
end 

%KO mice 
KOfile_tw_contra_only=dir(fullfile(AnalDirKOpost,'*tuningwidth_post_contra.mat')); 
for i=1:numel(KOfile_tw_contra_only)
    KODrift_tw_post_contra_only(i)=load(fullfile(AnalDirKOpost, KOfile_tw_contra_only(i).name)); 
end 

KOfile_tw_ipsi_only=dir(fullfile(AnalDirKOpost,'*tuningwidth_post_ipsi.mat')); 
for i=1:numel(KOfile_tw_ipsi_only)
    KODrift_tw_post_ipsi_only(i)=load(fullfile(AnalDirKOpost, KOfile_tw_ipsi_only(i).name)); 
end

%response reliability metrics 
WTfile_cv_contra=dir(fullfile(AnalDirWTpost,'*reliability_postMD_contra.mat')); 
for i=1:numel(WTfile_cv_contra)
    WTDrift_cv_post_contra(i)=load(fullfile(AnalDirWTpost, WTfile_cv_contra(i).name)); 
end 
WTfile_cv_ipsi=dir(fullfile(AnalDirWTpost,'*reliability_postMD_ipsi.mat')); 
for i=1:numel(WTfile_cv_ipsi)
    WTDrift_cv_post_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile_cv_ipsi(i).name)); 
end 

KOfile_cv_contra=dir(fullfile(AnalDirKOpost,'*reliability_postMD_contra.mat')); 
for i=1:numel(KOfile_cv_contra)
    KODrift_cv_post_contra(i)=load(fullfile(AnalDirKOpost, KOfile_cv_contra(i).name)); 
end 
KOfile_cv_ipsi=dir(fullfile(AnalDirKOpost,'*reliability_postMD_ipsi.mat')); 
for i=1:numel(KOfile_cv_ipsi)
    KODrift_cv_post_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile_cv_ipsi(i).name)); 
end 
%% Response reliability - all responsive, longitudinally tracked neurons 

WT_pre_CV_contra=[]; 
for i=1:length(WTDrift_cv_pre_contra)
    WT_pre_CV_contra=[WT_pre_CV_contra; WTDrift_cv_pre_contra(i).reliability_preMD_contra'];
end

WT_pre_CV_ipsi=[]; 
for i=1:length(WTDrift_cv_pre_ipsi)
    WT_pre_CV_ipsi=[WT_pre_CV_ipsi; WTDrift_cv_pre_ipsi(i).reliability_preMD_ipsi'];
end

KO_pre_CV_contra=[]; 
for i=1:length(KODrift_cv_pre_contra)
    KO_pre_CV_contra=[KO_pre_CV_contra; KODrift_cv_pre_contra(i).reliability_preMD_contra'];
end

KO_pre_CV_ipsi=[]; 
for i=1:length(KODrift_cv_pre_ipsi)
    KO_pre_CV_ipsi=[KO_pre_CV_ipsi; KODrift_cv_pre_ipsi(i).reliability_preMD_ipsi'];
end

WT_post_CV_contra=[]; 
for i=1:length(WTDrift_cv_post_contra)
    WT_post_CV_contra=[WT_post_CV_contra; WTDrift_cv_post_contra(i).reliability_postMD_contra'];
end

WT_post_CV_ipsi=[]; 
for i=1:length(WTDrift_cv_post_ipsi)
    WT_post_CV_ipsi=[WT_post_CV_ipsi; WTDrift_cv_post_ipsi(i).reliability_postMD_ipsi'];
end

KO_post_CV_contra=[]; 
for i=1:length(KODrift_cv_post_contra)
    KO_post_CV_contra=[KO_post_CV_contra; KODrift_cv_post_contra(i).reliability_postMD_contra'];
end

KO_post_CV_ipsi=[]; 
for i=1:length(KODrift_cv_post_ipsi)
    KO_post_CV_ipsi=[KO_post_CV_ipsi; KODrift_cv_post_ipsi(i).reliability_postMD_ipsi'];
end

WT_pre_CV_contra=abs(WT_pre_CV_contra); 
WT_pre_CV_ipsi=abs(WT_pre_CV_ipsi); 
WT_post_CV_contra=abs(WT_post_CV_contra); 
WT_post_CV_ipsi=abs(WT_post_CV_ipsi); 

KO_pre_CV_contra=abs(KO_pre_CV_contra); 
KO_pre_CV_ipsi=abs(KO_pre_CV_ipsi); 
KO_post_CV_contra=abs(KO_post_CV_contra); 
KO_post_CV_ipsi=abs(KO_post_CV_ipsi); 

%% ODI score - ALL CELLS , regardless of longitudinally tracked or not 

%WT, preMD
WT_preOD_All=[]; 
for i=1:length(WTDrift_pre_all) %for all the mice 
    WT_preOD_All=[WT_preOD_All; WTDrift_pre_all(i).preMD_OD'];
end 

%WT,postMD
WT_postOD_All=[]; 
for i=1:length(WTDrift_post_all) %for all the mice 
    WT_postOD_All=[WT_postOD_All; WTDrift_post_all(i).postMD_OD'];
end 

%KO,preMD
KO_preOD_All=[]; 
for i=1:length(KODrift_pre_all) %for all the mice 
    KO_preOD_All=[KO_preOD_All; KODrift_pre_all(i).preMD_OD'];
end 

%KO,postMD
KO_postOD_All=[]; 
for i=1:length(KODrift_post_all) %for all the mice 
    KO_postOD_All=[KO_postOD_All; KODrift_post_all(i).postMD_OD'];
end 


%% run stats on ODI and plot distributions

char_WT_pre_all=strings(length(WT_preOD_All),3); 

for i=1:length(WT_preOD_All)
    char_WT_pre_all(i,1)='pre';
    char_WT_pre_all(i,2)='WT'; 
    char_WT_pre_all(i,3)='pre WT';
end 

char_WT_post_all=strings(length(WT_postOD_All),3); 

for i=1:length(WT_postOD_All)
    char_WT_post_all(i,1)='post';
    char_WT_post_all(i,2)='WT'; 
    char_WT_post_all(i,3)='post WT';
end 

char_KO_pre_all=strings(length(KO_preOD_All),3); 

for i=1:length(KO_preOD_All)
    char_KO_pre_all(i,1)='pre';
    char_KO_pre_all(i,2)='KO'; 
    char_KO_pre_all(i,3)='pre KO'; 
end 

char_KO_post_all=strings(length(KO_postOD_All),3); 

for i=1:length(KO_postOD_All)
    char_KO_post_all(i,1)='post';
    char_KO_post_all(i,2)='KO'; 
    char_KO_post_all(i,3)='post KO'; 
end 

%make an empty table

ODscore_all=vertcat(WT_preOD_All, WT_postOD_All, KO_preOD_All, KO_postOD_All); %pre, post, pre, post  
genotype_all=vertcat(char_WT_pre_all(:,2), char_WT_post_all(:,2), char_KO_pre_all(:,2), char_KO_post_all(:,2)); %WT then KO
condition_all=vertcat(char_WT_pre_all(:,1), char_WT_post_all(:,1), char_KO_pre_all(:,1), char_KO_post_all(:,1)); %pre, post, pre, post
group_all= vertcat(char_WT_pre_all(:,3), char_WT_post_all(:,3), char_KO_pre_all(:,3), char_KO_post_all(:,3)); 
ODscoretable_all=table(ODscore_all,genotype_all,condition_all,group_all); 

writetable(ODscoretable_all, fullfile(SaveDir, 'ODscoretable_all.xls'),'WriteMode','overwritesheet'); 
save(fullfile(SaveDir, 'ODscoretable_all.mat'), 'ODscoretable_all');

%two way anova 
[p_all,tbl_all,stats_all]=anovan(ODscoretable_all.ODscore_all,{ODscoretable_all.condition_all,ODscoretable_all.genotype_all},...
    'model', 'interaction', 'varnames', {'condition', 'genotype'},'display','off'); 
%save table 
save(fullfile(SaveDir,'AllCells_ANOVAresults.mat'),'tbl_all'); 
writecell(tbl_all, fullfile(SaveDir,'AllCells_ANOVAresults.xls')); 

%multicomparisons
[results_all,m_all,h_all,gnames_all]=multcompare(stats_all,"Dimension", [1 2],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi_all=array2table(results_all,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi_all.("Group A")=gnames_all(tbl_multi_all.("Group A")); 
tbl_multi_all.("Group B")=gnames_all(tbl_multi_all.("Group B")); 

%save
save(fullfile(SaveDir,'AllCells_MultipleComparisons.mat'),'tbl_multi_all'); 
writetable(tbl_multi_all,fullfile(SaveDir,'AllCells_ODscore_MultipleComparisons.xls'),'WriteMode','overwritesheet');

writematrix(WT_preOD_All,fullfile(SaveDir,'WT_preOD_All.xls')); 
writematrix(WT_postOD_All,fullfile(SaveDir,'WT_postOD_All.xls')); 
writematrix(KO_preOD_All,fullfile(SaveDir,'KO_preOD_All.xls')); 
writematrix(KO_postOD_All,fullfile(SaveDir,'KO_postOD_All.xls')); 

%make swarmchart plot 
swarmchartplot1=figure(1);
groupnames={'pre WT', 'post WT', 'pre KO', 'post KO'}; 
vio_color=vertcat([0 0 0], [0.4 0.4 0.4], [.8 0 1], [.8 0.7 1]); 
vs=violinplot(ODscoretable_all.ODscore_all, ODscoretable_all.group_all,'GroupOrder', groupnames,'ViolinColor', vio_color); 
ylim([-1 1]); 
title('All Cells-Ocular Dominance')
ylabel('ODI')
xlabel('Group')

saveas(swarmchartplot1, fullfile(SaveDir, 'AllCells_ODI-violinplot'), 'pdf');
saveas(swarmchartplot1, fullfile(SaveDir, 'AllCells_ODI-violinplot'), 'tif');
saveas(swarmchartplot1, fullfile(SaveDir, 'AllCells_ODI-violinplot'), 'fig');

%make box plot
box_ODscore_all=figure(2); 
groupnames_order={'pre WT', 'pre KO', 'post WT', 'post KO'};   
ODscoretable_all.group_all= categorical(ODscoretable_all.group_all,groupnames_order); 

% box_color=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
box1_ODscore_all=boxchart(ODscoretable_all.group_all, ODscoretable_all.ODscore_all,'MarkerStyle','none');
box off 
set(gca,'TickDir','out');
ylabel('ODI')
xlabel('Group')

saveas(box_ODscore_all, fullfile(SaveDir, 'AllCells_ODI-boxchart'), 'pdf');
saveas(box_ODscore_all, fullfile(SaveDir, 'AllCells_ODI-boxchart'), 'tif');
saveas(box_ODscore_all, fullfile(SaveDir, 'AllCells_ODI-boxchart'), 'fig');

%Plot the distribution 

f1=figure(3);
t=tiledlayout(2,2); 
%WT pre 
nexttile
h1=histogram(WT_preOD_All, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3]);
xlim([-1 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre MD')
box off 

%WT post 
nexttile
h2=histogram(WT_postOD_All, 10,'Normalization','probability','FaceColor', [0.7 0.7 0.7]);
xlim([-1 1]); 
ylim([0 0.5])
title('WT- post MD')
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
box off 

%KO pre 
nexttile
h3=histogram(KO_preOD_All, 10, 'Normalization','probability','FaceColor', [.8 0 1]);
xlim([-1 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre MD')
box off 

%KO post 
nexttile
h4=histogram(KO_postOD_All, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);
xlim([-1 1]);
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('KO- post MD')
box off 
title(t,'Ocular Dominance')
xlabel(t,'ODI-All Cells')
ylabel(t,'Percentage of Neurons')

%save figure 
saveas(f1, fullfile(SaveDir, 'AllCells_ODI-histograms'), 'pdf');
saveas(f1, fullfile(SaveDir, 'AllCells_ODI-histograms'), 'tif');
saveas(f1, fullfile(SaveDir, 'AllCells_ODI-histograms'), 'fig');



%% plot drifting gratings- OD score and dFoF contra/ipsi , longitudinally tracked 
%first organized the data into concatenated vectors 
%WT, preMD
WT_preOD=[]; 
for i=1:length(WTDrift_pre) %for all the mice 
    WT_preOD=[WT_preOD; WTDrift_pre(i).OD_pre];
end 

WT_dFoF_contra_pre=[]; 
for i=1:length(WTDrift_pre) %for all the mice 
    WT_dFoF_contra_pre=[WT_dFoF_contra_pre; WTDrift_dFoF_pre_contra(i).dFoF_contra_pre'];
end 

WT_dFoF_ipsi_pre=[]; 
for i=1:length(WTDrift_pre) %for all the mice 
    WT_dFoF_ipsi_pre=[WT_dFoF_ipsi_pre; WTDrift_dFoF_pre_ipsi(i).dFoF_ipsi_pre'];
end 

%WT,postMD
WT_postOD=[]; 
for i=1:length(WTDrift_post) %for all the mice 
    WT_postOD=[WT_postOD; WTDrift_post(i).OD_post];
end 

WT_dFoF_contra_post=[]; 
for i=1:length(WTDrift_post) %for all the mice 
    WT_dFoF_contra_post=[WT_dFoF_contra_post; WTDrift_dFoF_post_contra(i).dFoF_contra_post'];
end 

WT_dFoF_ipsi_post=[]; 
for i=1:length(WTDrift_post) %for all the mice 
    WT_dFoF_ipsi_post=[WT_dFoF_ipsi_post; WTDrift_dFoF_post_ipsi(i).dFoF_ipsi_post'];
end 

%KO,preMD
KO_preOD=[]; 
for i=1:length(KODrift_pre) %for all the mice 
    KO_preOD=[KO_preOD; KODrift_pre(i).OD_pre];
end 

KO_dFoF_contra_pre=[]; 
for i=1:length(KODrift_pre) %for all the mice 
    KO_dFoF_contra_pre=[KO_dFoF_contra_pre; KODrift_dFoF_pre_contra(i).dFoF_contra_pre'];
end 

KO_dFoF_ipsi_pre=[]; 
for i=1:length(KODrift_pre) %for all the mice 
    KO_dFoF_ipsi_pre=[KO_dFoF_ipsi_pre; KODrift_dFoF_pre_ipsi(i).dFoF_ipsi_pre'];
end


%KO,postMD
KO_postOD=[]; 
for i=1:length(KODrift_post) %for all the mice 
    KO_postOD=[KO_postOD; KODrift_post(i).OD_post];
end 

KO_dFoF_contra_post=[]; 
for i=1:length(KODrift_post) %for all the mice 
    KO_dFoF_contra_post=[KO_dFoF_contra_post; KODrift_dFoF_post_contra(i).dFoF_contra_post'];
end 

KO_dFoF_ipsi_post=[]; 
for i=1:length(KODrift_post) %for all the mice 
    KO_dFoF_ipsi_post=[KO_dFoF_ipsi_post; KODrift_dFoF_post_ipsi(i).dFoF_ipsi_post'];
end


writematrix(WT_preOD,fullfile(SaveDir,'WT_preOD.xls')); 
writematrix(WT_postOD,fullfile(SaveDir,'WT_postOD.xls')); 
writematrix(KO_preOD,fullfile(SaveDir,'KO_preOD.xls')); 
writematrix(KO_postOD,fullfile(SaveDir,'KO_postOD.xls')); 

writematrix(WT_dFoF_ipsi_post,fullfile(SaveDir,'WT_dFoF_ipsi_post.xls')); 
writematrix(WT_dFoF_ipsi_pre,fullfile(SaveDir,'WT_dFoF_ipsi_pre.xls')); 
writematrix(WT_dFoF_contra_post,fullfile(SaveDir,'WT_dFoF_contra_post.xls')); 
writematrix(WT_dFoF_contra_pre,fullfile(SaveDir,'WT_dFoF_contra_pre.xls')); 

writematrix(KO_dFoF_ipsi_post,fullfile(SaveDir,'KO_dFoF_ipsi_post.xls')); 
writematrix(KO_dFoF_ipsi_pre,fullfile(SaveDir,'KO_dFoF_ipsi_pre.xls')); 
writematrix(KO_dFoF_contra_post,fullfile(SaveDir,'KO_dFoF_contra_post.xls')); 
writematrix(KO_dFoF_contra_pre,fullfile(SaveDir,'KO_dFoF_contra_post.xls')); 

%now plot the OD score 
% plotODscore(WT_preOD, SaveDir, 'WT PreMD'); 
% plotODscore(WT_postOD, SaveDir, 'WT PostMD');
% plotODscore(KO_preOD, SaveDir, 'KO PreMD');
% plotODscore(KO_postOD, SaveDir, 'KO PostMD');

%% calculate change in contra/ipsi response and plot against initial ODI 

WT_Dcontra=((WT_dFoF_contra_post-WT_dFoF_contra_pre)./WT_dFoF_contra_pre)*100; 
WT_Dipsi=((WT_dFoF_ipsi_post-WT_dFoF_ipsi_pre)./WT_dFoF_ipsi_pre)*100; 

KO_Dcontra=((KO_dFoF_contra_post-KO_dFoF_contra_pre)./KO_dFoF_contra_pre)*100; 
KO_Dipsi=((KO_dFoF_ipsi_post-KO_dFoF_ipsi_pre)./KO_dFoF_ipsi_pre)*100; 

WT_response_preMD=horzcat (WT_preOD, WT_Dcontra, WT_Dipsi); 
KO_response_preMD=horzcat (KO_preOD, KO_Dcontra, KO_Dipsi); 

%sort by preMD ODI to bin into 8 groups 
%ODI [-1 to -.75], [-.74 to -.5] and [-.49 to -.25], [-.24 to 0]
% [0.1 to .25] [.26 to .5] [.5 to .75] [.76 to 1]

WT_responsebygroup=zeros(8,2); 
WT_responsebygroupsem=zeros(8,2);
WT_responsebygrouppvalue=zeros(8,2); 
WT_bootstatsbygroup_contra=zeros(8,1000); %nrun=1000, get mean 
WT_bootstatsbygroup_ipsi=zeros(8,1000); 
WT_CIbootstatsbygroup_contra=zeros(2,8); %number of groups,  CI for mean (upper and lower), 
WT_CIbootstatsbygroup_ipsi=zeros(2,8); 


WT_ind_Q1=find (WT_preOD>=-1 & WT_preOD<=-0.75); 
WT_ind_Q2=find (WT_preOD>=-0.76 & WT_preOD<=-0.5); 
WT_ind_Q3=find (WT_preOD>=-0.49 & WT_preOD<=-0.25); 
WT_ind_Q4=find (WT_preOD>=-0.24 & WT_preOD<=0); 
WT_ind_Q5=find (WT_preOD>=0.1 & WT_preOD<=0.25); 
WT_ind_Q6=find (WT_preOD>=.26 & WT_preOD<=.5); 
WT_ind_Q7=find (WT_preOD>=0.51 & WT_preOD<=0.75); 
WT_ind_Q8=find (WT_preOD>=0.76 & WT_preOD<=1.0); 

%get median of contralateral changes 
WT_responsebygroup(1,1)=median(WT_Dcontra(WT_ind_Q1)); 
WT_responsebygroup(2,1)=median(WT_Dcontra(WT_ind_Q2)); 
WT_responsebygroup(3,1)=median(WT_Dcontra(WT_ind_Q3)); 
WT_responsebygroup(4,1)=median(WT_Dcontra(WT_ind_Q4)); 
WT_responsebygroup(5,1)=median(WT_Dcontra(WT_ind_Q5)); 
WT_responsebygroup(6,1)=median(WT_Dcontra(WT_ind_Q6)); 
WT_responsebygroup(7,1)=median(WT_Dcontra(WT_ind_Q7)); 
WT_responsebygroup(8,1)=median(WT_Dcontra(WT_ind_Q8));

%bootstrapping
%[WT_CIbootstatsbygroup_contra(:,1),WT_bootstatsbygroup_contra(1,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q1)); 
[WT_CIbootstatsbygroup_contra(:,2),WT_bootstatsbygroup_contra(2,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q2));
[WT_CIbootstatsbygroup_contra(:,3),WT_bootstatsbygroup_contra(3,:)]=bootci(1000, @(x)[mean(x)], WT_Dcontra(WT_ind_Q3));
[WT_CIbootstatsbygroup_contra(:,4),WT_bootstatsbygroup_contra(4,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q4));
[WT_CIbootstatsbygroup_contra(:,5),WT_bootstatsbygroup_contra(5,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q5));
[WT_CIbootstatsbygroup_contra(:,6),WT_bootstatsbygroup_contra(6,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q6));
[WT_CIbootstatsbygroup_contra(:,7),WT_bootstatsbygroup_contra(7,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q7));
[WT_CIbootstatsbygroup_contra(:,8),WT_bootstatsbygroup_contra(8,:)]=bootci(1000, @(x)[mean(x) ],WT_Dcontra(WT_ind_Q8));

%significantly different from 0? 
WT_responsebygrouppvalue(1,1)=signrank(WT_Dcontra(WT_ind_Q1)); 
WT_responsebygrouppvalue(2,1)=signrank(WT_Dcontra(WT_ind_Q2)); 
WT_responsebygrouppvalue(3,1)=signrank(WT_Dcontra(WT_ind_Q3)); 
WT_responsebygrouppvalue(4,1)=signrank(WT_Dcontra(WT_ind_Q4)); 
WT_responsebygrouppvalue(5,1)=signrank(WT_Dcontra(WT_ind_Q5)); 
WT_responsebygrouppvalue(6,1)=signrank(WT_Dcontra(WT_ind_Q6)); 
WT_responsebygrouppvalue(7,1)=signrank(WT_Dcontra(WT_ind_Q7)); 
WT_responsebygrouppvalue(8,1)=signrank(WT_Dcontra(WT_ind_Q8));

%get sem of contralateral changes
WT_responsebygroupsem(1,1)=1.253*std(WT_Dcontra(WT_ind_Q1))/sqrt(length(WT_ind_Q1)); 
WT_responsebygroupsem(2,1)=1.253*std(WT_Dcontra(WT_ind_Q2))/sqrt(length(WT_ind_Q2)); 
WT_responsebygroupsem(3,1)=1.253*std(WT_Dcontra(WT_ind_Q3))/sqrt(length(WT_ind_Q3)); 
WT_responsebygroupsem(4,1)=1.253*std(WT_Dcontra(WT_ind_Q4))/sqrt(length(WT_ind_Q4)); 
WT_responsebygroupsem(5,1)=1.253*std(WT_Dcontra(WT_ind_Q5))/sqrt(length(WT_ind_Q5)); 
WT_responsebygroupsem(6,1)=1.253*std(WT_Dcontra(WT_ind_Q6))/sqrt(length(WT_ind_Q6)); 
WT_responsebygroupsem(7,1)=1.253*std(WT_Dcontra(WT_ind_Q7))/sqrt(length(WT_ind_Q7)); 
WT_responsebygroupsem(8,1)=1.253*std(WT_Dcontra(WT_ind_Q8))/sqrt(length(WT_ind_Q8));

%get median of ipsilateral changes 
WT_responsebygroup(1,2)=median(WT_Dipsi(WT_ind_Q1)); 
WT_responsebygroup(2,2)=median(WT_Dipsi(WT_ind_Q2)); 
WT_responsebygroup(3,2)=median(WT_Dipsi(WT_ind_Q3)); 
WT_responsebygroup(4,2)=median(WT_Dipsi(WT_ind_Q4)); 
WT_responsebygroup(5,2)=median(WT_Dipsi(WT_ind_Q5)); 
WT_responsebygroup(6,2)=median(WT_Dipsi(WT_ind_Q6)); 
WT_responsebygroup(7,2)=median(WT_Dipsi(WT_ind_Q7)); 
WT_responsebygroup(8,2)=median(WT_Dipsi(WT_ind_Q8));

%bootstrapping
%[WT_CIbootstatsbygroup_ipsi(:,1),WT_bootstatsbygroup_ipsi(1,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q1)); 
[WT_CIbootstatsbygroup_ipsi(:,2),WT_bootstatsbygroup_ipsi(2,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q2));
[WT_CIbootstatsbygroup_ipsi(:,3),WT_bootstatsbygroup_ipsi(3,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q3));
[WT_CIbootstatsbygroup_ipsi(:,4),WT_bootstatsbygroup_ipsi(4,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q4));
[WT_CIbootstatsbygroup_ipsi(:,5),WT_bootstatsbygroup_ipsi(5,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q5));
[WT_CIbootstatsbygroup_ipsi(:,6),WT_bootstatsbygroup_ipsi(6,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q6));
[WT_CIbootstatsbygroup_ipsi(:,7),WT_bootstatsbygroup_ipsi(7,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q7));
[WT_CIbootstatsbygroup_ipsi(:,8),WT_bootstatsbygroup_ipsi(8,:)]=bootci(1000, @(x)[mean(x) ],WT_Dipsi(WT_ind_Q8));


%significantly different from zero? 
WT_responsebygrouppvalue(1,2)=signrank(WT_Dipsi(WT_ind_Q1)); 
WT_responsebygrouppvalue(2,2)=signrank(WT_Dipsi(WT_ind_Q2)); 
WT_responsebygrouppvalue(3,2)=signrank(WT_Dipsi(WT_ind_Q3)); 
WT_responsebygrouppvalue(4,2)=signrank(WT_Dipsi(WT_ind_Q4)); 
WT_responsebygrouppvalue(5,2)=signrank(WT_Dipsi(WT_ind_Q5)); 
WT_responsebygrouppvalue(6,2)=signrank(WT_Dipsi(WT_ind_Q6)); 
WT_responsebygrouppvalue(7,2)=signrank(WT_Dipsi(WT_ind_Q7)); 
WT_responsebygrouppvalue(8,2)=signrank(WT_Dipsi(WT_ind_Q8));


%getstd of ipsi changes
WT_responsebygroupsem(1,2)=1.253*std(WT_Dipsi(WT_ind_Q1))/sqrt(length(WT_ind_Q1)); 
WT_responsebygroupsem(2,2)=1.253*std(WT_Dipsi(WT_ind_Q2))/sqrt(length(WT_ind_Q2)); 
WT_responsebygroupsem(3,2)=1.253*std(WT_Dipsi(WT_ind_Q3))/sqrt(length(WT_ind_Q3)); 
WT_responsebygroupsem(4,2)=1.253*std(WT_Dipsi(WT_ind_Q4))/sqrt(length(WT_ind_Q4)); 
WT_responsebygroupsem(5,2)=1.253*std(WT_Dipsi(WT_ind_Q5))/sqrt(length(WT_ind_Q5)); 
WT_responsebygroupsem(6,2)=1.253*std(WT_Dipsi(WT_ind_Q6))/sqrt(length(WT_ind_Q6)); 
WT_responsebygroupsem(7,2)=1.253*std(WT_Dipsi(WT_ind_Q7))/sqrt(length(WT_ind_Q7)); 
WT_responsebygroupsem(8,2)=1.253*std(WT_Dipsi(WT_ind_Q8))/sqrt(length(WT_ind_Q8));


KO_responsebygroup=zeros(8,2); 
KO_responsebygroupsem=zeros(8,2); 
KO_responsbygrouppvalue=zeros(8,2); 
KO_bootstatsbygroup_contra=zeros(8,1000); %nrun=1000, get mean 
KO_bootstatsbygroup_ipsi=zeros(8,1000); 
KO_CIbootstatsbygroup_contra=zeros(2,8); %number of groups,  CI for mean (upper and lower)
KO_CIbootstatsbygroup_ipsi=zeros(2,8); 


KO_ind_Q1=find (KO_preOD>=-1 & KO_preOD<=-0.75); 
KO_ind_Q2=find (KO_preOD>=-0.76 & KO_preOD<=-0.5); 
KO_ind_Q3=find (KO_preOD>=-0.49 & KO_preOD<=-0.25); 
KO_ind_Q4=find (KO_preOD>=-0.24 & KO_preOD<=0); 
KO_ind_Q5=find (KO_preOD>=0.1 & KO_preOD<=0.25); 
KO_ind_Q6=find (KO_preOD>=.26 & KO_preOD<=.5); 
KO_ind_Q7=find (KO_preOD>=0.51 & KO_preOD<=0.75); 
KO_ind_Q8=find (KO_preOD>=0.76 & KO_preOD<=1.0); 

%get median of contralateral changes 
KO_responsebygroup(1,1)=median(KO_Dcontra(KO_ind_Q1)); 
KO_responsebygroup(2,1)=median(KO_Dcontra(KO_ind_Q2)); 
KO_responsebygroup(3,1)=median(KO_Dcontra(KO_ind_Q3)); 
KO_responsebygroup(4,1)=median(KO_Dcontra(KO_ind_Q4)); 
KO_responsebygroup(5,1)=median(KO_Dcontra(KO_ind_Q5)); 
KO_responsebygroup(6,1)=median(KO_Dcontra(KO_ind_Q6)); 
KO_responsebygroup(7,1)=median(KO_Dcontra(KO_ind_Q7)); 
KO_responsebygroup(8,1)=median(KO_Dcontra(KO_ind_Q8));

%bootstrapping
[KO_CIbootstatsbygroup_contra(:,1),KO_bootstatsbygroup_contra(1,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q1)); 
[KO_CIbootstatsbygroup_contra(:,2),KO_bootstatsbygroup_contra(2,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q2));
[KO_CIbootstatsbygroup_contra(:,3),KO_bootstatsbygroup_contra(3,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q3));
[KO_CIbootstatsbygroup_contra(:,4),KO_bootstatsbygroup_contra(4,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q4));
[KO_CIbootstatsbygroup_contra(:,5),KO_bootstatsbygroup_contra(5,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q5));
[KO_CIbootstatsbygroup_contra(:,6),KO_bootstatsbygroup_contra(6,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q6));
[KO_CIbootstatsbygroup_contra(:,7),KO_bootstatsbygroup_contra(7,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q7));
[KO_CIbootstatsbygroup_contra(:,8),KO_bootstatsbygroup_contra(8,:)]=bootci(1000, @(x)[mean(x) ],KO_Dcontra(KO_ind_Q8));


KO_responsebygrouppvalue(1,1)=signrank(KO_Dcontra(KO_ind_Q1)); 
KO_responsebygrouppvalue(2,1)=signrank(KO_Dcontra(KO_ind_Q2)); 
KO_responsebygrouppvalue(3,1)=signrank(KO_Dcontra(KO_ind_Q3)); 
KO_responsebygrouppvalue(4,1)=signrank(KO_Dcontra(KO_ind_Q4)); 
KO_responsebygrouppvalue(5,1)=signrank(KO_Dcontra(KO_ind_Q5)); 
KO_responsebygrouppvalue(6,1)=signrank(KO_Dcontra(KO_ind_Q6)); 
KO_responsebygrouppvalue(7,1)=signrank(KO_Dcontra(KO_ind_Q7)); 
KO_responsebygrouppvalue(8,1)=signrank(KO_Dcontra(KO_ind_Q8));


%getstd of contralateral changes
KO_responsebygroupsem(1,1)=1.253*std(KO_Dcontra(KO_ind_Q1))/sqrt(length(KO_ind_Q1)); 
KO_responsebygroupsem(2,1)=1.253*std(KO_Dcontra(KO_ind_Q2))/sqrt(length(KO_ind_Q2)); 
KO_responsebygroupsem(3,1)=1.253*std(KO_Dcontra(KO_ind_Q3))/sqrt(length(KO_ind_Q3)); 
KO_responsebygroupsem(4,1)=1.253*std(KO_Dcontra(KO_ind_Q4))/sqrt(length(KO_ind_Q4)); 
KO_responsebygroupsem(5,1)=1.253*std(KO_Dcontra(KO_ind_Q5))/sqrt(length(KO_ind_Q5)); 
KO_responsebygroupsem(6,1)=1.253*std(KO_Dcontra(KO_ind_Q6))/sqrt(length(KO_ind_Q6)); 
KO_responsebygroupsem(7,1)=1.253*std(KO_Dcontra(KO_ind_Q7))/sqrt(length(KO_ind_Q7)); 
KO_responsebygroupsem(8,1)=1.253*std(KO_Dcontra(KO_ind_Q8))/sqrt(length(KO_ind_Q8));


%get median of ipsilateral changes 
KO_responsebygroup(1,2)=median(KO_Dipsi(KO_ind_Q1)); 
KO_responsebygroup(2,2)=median(KO_Dipsi(KO_ind_Q2)); 
KO_responsebygroup(3,2)=median(KO_Dipsi(KO_ind_Q3)); 
KO_responsebygroup(4,2)=median(KO_Dipsi(KO_ind_Q4)); 
KO_responsebygroup(5,2)=median(KO_Dipsi(KO_ind_Q5)); 
KO_responsebygroup(6,2)=median(KO_Dipsi(KO_ind_Q6)); 
KO_responsebygroup(7,2)=median(KO_Dipsi(KO_ind_Q7)); 
KO_responsebygroup(8,2)=median(KO_Dipsi(KO_ind_Q8));

%bootstrapping
[KO_CIbootstatsbygroup_ipsi(:,1),KO_bootstatsbygroup_ipsi(1,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q1)); 
[KO_CIbootstatsbygroup_ipsi(:,2),KO_bootstatsbygroup_ipsi(2,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q2));
[KO_CIbootstatsbygroup_ipsi(:,3),KO_bootstatsbygroup_ipsi(3,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q3));
[KO_CIbootstatsbygroup_ipsi(:,4),KO_bootstatsbygroup_ipsi(4,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q4));
[KO_CIbootstatsbygroup_ipsi(:,5),KO_bootstatsbygroup_ipsi(5,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q5));
[KO_CIbootstatsbygroup_ipsi(:,6),KO_bootstatsbygroup_ipsi(6,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q6));
[KO_CIbootstatsbygroup_ipsi(:,7),KO_bootstatsbygroup_ipsi(7,:)]=bootci(1000, @(x)[mean(x)],KO_Dipsi(KO_ind_Q7));
[KO_CIbootstatsbygroup_ipsi(:,8),KO_bootstatsbygroup_ipsi(8,:)]=bootci(1000, @(x)[mean(x) ],KO_Dipsi(KO_ind_Q8));



KO_responsebygrouppvalue(1,2)=signrank(KO_Dipsi(KO_ind_Q1)); 
KO_responsebygrouppvalue(2,2)=signrank(KO_Dipsi(KO_ind_Q2)); 
KO_responsebygrouppvalue(3,2)=signrank(KO_Dipsi(KO_ind_Q3)); 
KO_responsebygrouppvalue(4,2)=signrank(KO_Dipsi(KO_ind_Q4)); 
KO_responsebygrouppvalue(5,2)=signrank(KO_Dipsi(KO_ind_Q5)); 
KO_responsebygrouppvalue(6,2)=signrank(KO_Dipsi(KO_ind_Q6)); 
KO_responsebygrouppvalue(7,2)=signrank(KO_Dipsi(KO_ind_Q7)); 
KO_responsebygrouppvalue(8,2)=signrank(KO_Dipsi(KO_ind_Q8));


%getstd of ipsilateral changes
KO_responsebygroupsem(1,2)=1.253*std(KO_Dipsi(KO_ind_Q1))/sqrt(length(KO_ind_Q1)); 
KO_responsebygroupsem(2,2)=1.253*std(KO_Dipsi(KO_ind_Q2))/sqrt(length(KO_ind_Q2)); 
KO_responsebygroupsem(3,2)=1.253*std(KO_Dipsi(KO_ind_Q3))/sqrt(length(KO_ind_Q3)); 
KO_responsebygroupsem(4,2)=1.253*std(KO_Dipsi(KO_ind_Q4))/sqrt(length(KO_ind_Q4)); 
KO_responsebygroupsem(5,2)=1.253*std(KO_Dipsi(KO_ind_Q5))/sqrt(length(KO_ind_Q5)); 
KO_responsebygroupsem(6,2)=1.253*std(KO_Dipsi(KO_ind_Q6))/sqrt(length(KO_ind_Q6)); 
KO_responsebygroupsem(7,2)=1.253*std(KO_Dipsi(KO_ind_Q7))/sqrt(length(KO_ind_Q7)); 
KO_responsebygroupsem(8,2)=1.253*std(KO_Dipsi(KO_ind_Q8))/sqrt(length(KO_ind_Q8));

writematrix(WT_responsebygrouppvalue,fullfile(SaveDir,'WT_responsebygrouppvalue.xls')); 
writematrix(KO_responsebygrouppvalue,fullfile(SaveDir,'KO_responsebygrouppvalue.xls')); 
writematrix(WT_Dcontra,fullfile(SaveDir,'WT_Dcontra.xls')); 
writematrix(KO_Dcontra,fullfile(SaveDir,'KO_Dcontra.xls')); 

writematrix(WT_Dipsi,fullfile(SaveDir,'WT_Dipsi.xls')); 
writematrix(KO_Dipsi,fullfile(SaveDir,'KO_Dipsi.xls')); 

%% plot responses +/ sem 

figDeltaResponsebyODI=figure(25);
tiledlayout(1,2); 

x=1:8; 
x2=[x, fliplr(x)]; 


nexttile
plot(x,WT_responsebygroup(:,1),'b-o', 'LineWidth',2); 
hold on
plot(x,WT_responsebygroup(:,2),'g-o', 'LineWidth',2); 
hold on

xlim([1 8])
ylim([-200 500])
box off
title('WT changes')
set(gca,'TickDir','out');
xlabel('pre MD ODI')
ylabel('Response change %')
hold off

nexttile
%fill(x2,inBetween_WTcontra, [.2 .8 1], 'EdgeColor','none'); 
hold on
plot(x,KO_responsebygroup(:,1),'b-o', 'LineWidth',2); 
hold on
%fill(x2,inBetween_WTipsi, [.2 .8 .4], 'EdgeColor','none'); 
hold on
plot(x,KO_responsebygroup(:,2),'g-o', 'LineWidth',2); 
hold on
xlim([1 8])
ylim([-200 500])
set(gca,'TickDir','out');
title('KO changes')
xlabel('pre MD ODI')
box off
ylabel('Response change %')
hold off

%save figures 
%save figure 
saveas(figDeltaResponsebyODI, fullfile(SaveDir, 'figDeltaResponsebyODI'), 'pdf');
saveas(figDeltaResponsebyODI, fullfile(SaveDir, 'figDeltaResponsebyODI'), 'tif');
saveas(figDeltaResponsebyODI, fullfile(SaveDir, 'figDeltaResponsebyODI'), 'fig');

% plot bootstrapped means + CI 
figBootDeltaResponsebyODI=figure(26); 
tiledlayout (1,2)
inBetween_WTcontra=[WT_CIbootstatsbygroup_contra(1,:), fliplr(WT_CIbootstatsbygroup_contra(2,:))]; 
inBetween_WTipsi=[WT_CIbootstatsbygroup_ipsi(1,:), fliplr(WT_CIbootstatsbygroup_ipsi(2,:))];
inBetween_KOcontra=[KO_CIbootstatsbygroup_contra(1,:), fliplr(KO_CIbootstatsbygroup_contra(2,:))]; 
inBetween_KOipsi=[KO_CIbootstatsbygroup_ipsi(1,:), fliplr(KO_CIbootstatsbygroup_ipsi(2,:))];


nexttile
fill(x2,inBetween_WTcontra, [.4 .8 1], 'EdgeColor','none'); 
hold on
fill(x2,inBetween_WTipsi, [.6 1.0 .8], 'EdgeColor','none'); 
hold on
%add bootstrapped means 
plot (x,mean(WT_bootstatsbygroup_contra,2),'b--', 'LineWidth',2);
hold on 
plot (x,mean(WT_bootstatsbygroup_ipsi,2),'g--', 'LineWidth',2);
hold on
xlim([1 8])
ylim([-200 500])
title('WT changes')
set(gca,'TickDir','out');
xlabel('pre MD ODI')
ylabel('Response change %')
box off
hold off

nexttile
fill(x2,inBetween_KOcontra, [.4 .8 1], 'EdgeColor','none'); 
hold on
fill(x2,inBetween_KOipsi, [.6 1.0 .8], 'EdgeColor','none'); 
hold on
%add bootstrapped means 
plot (x,mean(KO_bootstatsbygroup_contra,2),'b--', 'LineWidth',2);
hold on 
plot (x,mean(KO_bootstatsbygroup_ipsi,2),'g--', 'LineWidth',2);
hold on
xlim([1 8])
ylim([-200 500])
set(gca,'TickDir','out');
title('KO changes')
xlabel('pre MD ODI')
ylabel('Response change %')
box off
hold off

%save figures 
%save figure 
saveas(figBootDeltaResponsebyODI, fullfile(SaveDir, 'figBootDeltaResponsebyODI'), 'pdf');
saveas(figBootDeltaResponsebyODI, fullfile(SaveDir, 'figBootDeltaResponsebyODI'), 'tif');
saveas(figBootDeltaResponsebyODI, fullfile(SaveDir, 'figBootDeltaResponsebyODI'), 'fig');
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

writetable(ODscoretable,fullfile(SaveDir, 'ODscoretable.xls'),'WriteMode','overwritesheet'); 

%two way anova 
[p,tbl,stats]=anovan(ODscoretable.ODscore,{ODscoretable.condition,ODscoretable.genotype},...
    'model', 'interaction', 'varnames', {'condition', 'genotype'},'display','off'); 
%save table 
save(fullfile(SaveDir,'ANOVAresults.mat'),'tbl'); 
writecell(tbl, fullfile(SaveDir, 'ODscore_ANOVAresults.xls')); 

%multicomparisons
[results,m,h,gnames]=multcompare(stats,"Dimension", [1 2],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi=array2table(results,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi.("Group A")=gnames(tbl_multi.("Group A")); 
tbl_multi.("Group B")=gnames(tbl_multi.("Group B")); 

%save
save(fullfile(SaveDir,'MultipleComparisons.mat'),'tbl_multi'); 
writetable(tbl_multi, fullfile(SaveDir, 'ODscore_MultipleComparisons.xls'),'WriteMode','overwritesheet'); 

%make swarmchart plot 
swarmchartplot2=figure(4);
groupnames={'pre WT', 'post WT', 'pre KO', 'post KO'}; 
vio_color=vertcat([0 0 0], [0.4 0.4 0.4], [.8 0 1], [.8 0.7 1]); 
vs=violinplot(ODscoretable.ODscore, ODscoretable.group,'GroupOrder', groupnames,'ViolinColor', vio_color); 
ylim([-1 1]); 
set(gca,'TickDir','out');
title('Ocular Dominance')
ylabel('ODI')
xlabel('Group')

saveas(swarmchartplot2, fullfile(SaveDir, 'ODI-violinplot'), 'pdf');
saveas(swarmchartplot2, fullfile(SaveDir, 'ODI-violinplot'), 'tif');
saveas(swarmchartplot2, fullfile(SaveDir, 'ODI-violinplot'), 'fig');

%make histograms for each condition 

%scales 

f3=figure(5);
t=tiledlayout(2,2); 
%WT pre 
nexttile
hist1=histogram(WT_preOD, 10, 'Normalization','probability','FaceColor', [0.3 0.3 0.3]);
xlim([-1 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre MD')
box off 

%WT post 
nexttile
hist2=histogram(WT_postOD, 10, 'Normalization','probability','FaceColor', [0.7 0.7 0.7]);
xlim([-1 1]); 
ylim([0 0.5])
title('WT- post MD')
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
box off 

%KO pre 
nexttile
hist3=histogram(KO_preOD, 10, 'Normalization','probability','FaceColor', [.8 0 1]);
xlim([-1 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre MD')
box off 

%KO post 
nexttile
hist4=histogram(KO_postOD, 10, 'Normalization','probability','FaceColor', [.8 0.7 1]);
xlim([-1 1]);
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('KO- post MD')
box off 
title(t,'Ocular Dominance')
xlabel(t,'ODI')
ylabel(t,'Percentage of Neurons')

%save figure 
saveas(f3, fullfile(SaveDir, 'ODI-histograms'), 'pdf');
saveas(f3, fullfile(SaveDir, 'ODI-histograms'), 'tif');
saveas(f3, fullfile(SaveDir, 'ODI-histograms'), 'fig');


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

fOD_WT=figure(6); 
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

fOD_KO=figure(7); 
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

%% scatter plot of ODI 

ODI_scatter=figure(8);
orient(ODI_scatter,'landscape')
tiledlayout(1,2)
nexttile 
x=linspace(-1,1); 
y=linspace(-1,1); 
scatter(WT_postOD, WT_preOD,40,'black','filled')

xlim([-1 1]);
ylim([-1 1]); 
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
ylabel('Pre MD', 'FontSize',10)
xlabel ('Post MD', 'FontSize',10)

title('WT')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';


nexttile 
scatter(KO_postOD, KO_preOD,40,[.8 0 1],'filled')
xlim([-1 1]);
ylim([-1 1]); 
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
ylabel('Pre MD', 'FontSize',10)
xlabel ('Post MD', 'FontSize',10)
title('KO')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

saveas(ODI_scatter, fullfile(SaveDir, 'ODI_scatter'), 'pdf');
saveas(ODI_scatter, fullfile(SaveDir, 'ODI_scatter'), 'tif');
saveas(ODI_scatter, fullfile(SaveDir, 'ODI_scatter'), 'fig');

%% Tuning width 
%binocular cells -contralateral
WT_twidth_pre_bin_contra=[]; 
for i=1:length(WTDrift_pre_tw_contra) %for all the mice 
    WT_twidth_pre_bin_contra=[WT_twidth_pre_bin_contra; WTDrift_pre_tw_contra(i).tuningwidth_pre_bin_contra'];
end 

%WT,postMD
WT_twidth_post_bin_contra=[]; 
for i=1:length(WTDrift_post_tw_contra) %for all the mice 
    WT_twidth_post_bin_contra=[WT_twidth_post_bin_contra; WTDrift_post_tw_contra(i).tuningwidth_post_bin_contra'];
end 

%KO,preMD
KO_twidth_pre_bin_contra=[]; 
for i=1:length(KODrift_pre_tw_contra) %for all the mice 
    KO_twidth_pre_bin_contra=[KO_twidth_pre_bin_contra; KODrift_pre_tw_contra(i).tuningwidth_pre_bin_contra'];
end 

%KO,postMD
KO_twidth_post_bin_contra=[]; 
for i=1:length(KODrift_post_tw_contra) %for all the mice 
    KO_twidth_post_bin_contra=[KO_twidth_post_bin_contra; KODrift_post_tw_contra(i).tuningwidth_post_bin_contra'];
end 

%binocular-ipsilateral 
WT_twidth_pre_bin_ipsi=[]; 
for i=1:length(WTDrift_pre_tw_ipsi) %for all the mice 
    WT_twidth_pre_bin_ipsi=[WT_twidth_pre_bin_ipsi; WTDrift_pre_tw_ipsi(i).tuningwidth_pre_bin_ipsi'];
end 

%WT,postMD
WT_twidth_post_bin_ipsi=[]; 
for i=1:length(WTDrift_post_tw_ipsi) %for all the mice 
    WT_twidth_post_bin_ipsi=[WT_twidth_post_bin_ipsi; WTDrift_post_tw_ipsi(i).tuningwidth_post_bin_ipsi'];
end 

%KO,preMD
KO_twidth_pre_bin_ipsi=[]; 
for i=1:length(KODrift_pre_tw_ipsi) %for all the mice 
    KO_twidth_pre_bin_ipsi=[KO_twidth_pre_bin_ipsi; KODrift_pre_tw_ipsi(i).tuningwidth_pre_bin_ipsi'];
end 

%KO,postMD
KO_twidth_post_bin_ipsi=[]; 
for i=1:length(KODrift_post_tw_ipsi) %for all the mice 
    KO_twidth_post_bin_ipsi=[KO_twidth_post_bin_ipsi; KODrift_post_tw_ipsi(i).tuningwidth_post_bin_ipsi'];
end 


%contralateral cells 
WT_twidth_pre_contra=[]; 
for i=1:length(WTDrift_tw_pre_contra_only) %for all the mice 
    WT_twidth_pre_contra=[WT_twidth_pre_contra; WTDrift_tw_pre_contra_only(i).tuningwidth_pre_contra'];
end 

%WT,postMD
WT_twidth_post_contra=[]; 
for i=1:length(WTDrift_tw_post_contra_only) %for all the mice 
    WT_twidth_post_contra=[WT_twidth_post_contra; WTDrift_tw_post_contra_only(i).tuningwidth_post_contra'];
end 

%KO,preMD
KO_twidth_pre_contra=[]; 
for i=1:length(KODrift_tw_pre_contra_only) %for all the mice 
    KO_twidth_pre_contra=[KO_twidth_pre_contra; KODrift_tw_pre_contra_only(i).tuningwidth_pre_contra'];
end 

%KO,postMD
KO_twidth_post_contra=[]; 
for i=1:length(KODrift_tw_post_contra_only) %for all the mice 
    KO_twidth_post_contra=[KO_twidth_post_contra; KODrift_tw_post_contra_only(i).tuningwidth_post_contra'];
end 

%ipsilateral cells 
WT_twidth_pre_ipsi=[]; 
for i=1:length(WTDrift_tw_pre_ipsi_only) %for all the mice 
    WT_twidth_pre_ipsi=[WT_twidth_pre_ipsi; WTDrift_tw_pre_ipsi_only(i).tuningwidth_pre_ipsi'];
end 

%WT,postMD
WT_twidth_post_ipsi=[]; 
for i=1:length(WTDrift_tw_post_ipsi_only) %for all the mice 
    WT_twidth_post_ipsi=[WT_twidth_post_ipsi; WTDrift_tw_post_ipsi_only(i).tuningwidth_post_ipsi'];
end 

%KO,preMD
KO_twidth_pre_ipsi=[]; 
for i=1:length(KODrift_tw_pre_ipsi_only) %for all the mice 
    KO_twidth_pre_ipsi=[KO_twidth_pre_ipsi; KODrift_tw_pre_ipsi_only(i).tuningwidth_pre_ipsi'];
end 

%KO,postMD
KO_twidth_post_ipsi=[]; 
for i=1:length(KODrift_tw_post_ipsi_only) %for all the mice 
    KO_twidth_post_ipsi=[KO_twidth_post_ipsi; KODrift_tw_post_ipsi_only(i).tuningwidth_post_ipsi'];
end 

% save matrices 
%save files 
writematrix(WT_twidth_pre_bin_contra, fullfile(SaveDir, 'WT_twidth_pre_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_twidth_post_bin_contra, fullfile(SaveDir, 'WT_twidth_post_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_twidth_pre_bin_ipsi, fullfile(SaveDir, 'WT_twidth_pre_bin_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_twidth_post_bin_ipsi, fullfile(SaveDir, 'WT_twidth_post_bin_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(KO_twidth_pre_bin_contra, fullfile(SaveDir, 'KO_twidth_pre_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_twidth_post_bin_contra, fullfile(SaveDir, 'KO_twidth_post_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_twidth_pre_bin_ipsi, fullfile(SaveDir, 'KO_twidth_pre_bin_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_twidth_post_bin_ipsi, fullfile(SaveDir, 'KO_twidth_post_bin_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(WT_twidth_pre_contra, fullfile(SaveDir, 'WT_twidth_pre_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_twidth_pre_ipsi, fullfile(SaveDir, 'WT_twidth_pre_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_twidth_post_contra, fullfile(SaveDir, 'WT_twidth_post_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_twidth_post_ipsi, fullfile(SaveDir, 'WT_twidth_post_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(KO_twidth_pre_contra, fullfile(SaveDir, 'KO_twidth_pre_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_twidth_pre_ipsi, fullfile(SaveDir, 'KO_twidth_pre_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_twidth_post_contra, fullfile(SaveDir, 'KO_twidth_post_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_twidth_post_ipsi, fullfile(SaveDir, 'KO_twidth_post_ipsi.xls'),'WriteMode','overwritesheet'); 

%% plot tuning width 

% char_WT_ori_pre_all=strings(length(WT_twidth_pre_bin_contra),6); 
% 
% for i=1:length(WT_twidth_pre_bin_contra)
%     char_WT_ori_pre_all(i,1)='pre';
%     char_WT_ori_pre_all(i,2)='WT'; 
%     char_WT_ori_pre_all(i,3)='contra'; 
%     char_WT_ori_pre_all(i,4)='ipsi'; 
%     char_WT_ori_pre_all(i,5)='pre WT contra'; 
%     char_WT_ori_pre_all(i,6)='pre WT ipsi'; 
% end 
% 
% char_WT_ori_post_all=strings(length(WT_postORI_contra_all),6); 
% 
% for i=1:length(WT_postORI_contra_all)
%     char_WT_ori_post_all(i,1)='post';
%     char_WT_ori_post_all(i,2)='WT'; 
%     char_WT_ori_post_all(i,3)='contra'; 
%     char_WT_ori_post_all(i,4)='ipsi'; 
%     char_WT_ori_post_all(i,5)='post WT contra'; 
%     char_WT_ori_post_all(i,6)='post WT ipsi'; 
% end 
% 
% char_KO_ori_pre_all=strings(length(KO_preORI_contra_all),6); 
% 
% for i=1:length(KO_preORI_contra_all)
%     char_KO_ori_pre_all(i,1)='pre';
%     char_KO_ori_pre_all(i,2)='KO'; 
%     char_KO_ori_pre_all(i,3)='contra'; 
%     char_KO_ori_pre_all(i,4)='ipsi'; 
%     char_KO_ori_pre_all(i,5)='pre KO contra'; 
%     char_KO_ori_pre_all(i,6)='pre KO ipsi'; 
% end 
% 
% char_KO_ori_post_all=strings(length(KO_postORI_contra_all),6); 
% 
% for i=1:length(KO_postORI_contra_all)
%     char_KO_ori_post_all(i,1)='post';
%     char_KO_ori_post_all(i,2)='KO'; 
%     char_KO_ori_post_all(i,3)='contra'; 
%     char_KO_ori_post_all(i,4)='ipsi'; 
%     char_KO_ori_post_all(i,5)='post KO contra'; 
%     char_KO_ori_post_all(i,6)='post KO ipsi'; 
% end 


%% binocular matching - ALL CELLS , regardless of longitudinally tracked or not 

WT_preORI_contra_all=[]; 
for i=1:length(WTDrift_all_binoc_contra_pre) %for all the mice 
    WT_preORI_contra_all=[WT_preORI_contra_all; WTDrift_all_binoc_contra_pre(i).pre_ori_pref_contra'];
end 

%WT,postMD
WT_postORI_contra_all=[]; 
for i=1:length(WTDrift_all_binoc_contra_post) %for all the mice 
    WT_postORI_contra_all=[WT_postORI_contra_all; WTDrift_all_binoc_contra_post(i).post_ori_pref_contra'];
end 

%KO,preMD
KO_preORI_contra_all=[]; 
for i=1:length(KODrift_all_binoc_contra_pre) %for all the mice 
    KO_preORI_contra_all=[KO_preORI_contra_all; KODrift_all_binoc_contra_pre(i).pre_ori_pref_contra'];
end 

%KO,postMD
KO_postORI_contra_all=[]; 
for i=1:length(KODrift_all_binoc_contra_post) %for all the mice 
    KO_postORI_contra_all=[KO_postORI_contra_all; KODrift_all_binoc_contra_post(i).post_ori_pref_contra'];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_preORI_ipsi_all=[]; 
for i=1:length(WTDrift_all_binoc_ipsi_pre) %for all the mice 
    WT_preORI_ipsi_all=[WT_preORI_ipsi_all; WTDrift_all_binoc_ipsi_pre(i).pre_ori_pref_ipsi'];
end 

%WT,postMD
WT_postORI_ipsi_all=[]; 
for i=1:length(WTDrift_all_binoc_ipsi_post) %for all the mice 
    WT_postORI_ipsi_all=[WT_postORI_ipsi_all; WTDrift_all_binoc_ipsi_post(i).post_ori_pref_ipsi'];
end 

%KO,preMD
KO_preORI_ipsi_all=[]; 
for i=1:length(KODrift_all_binoc_ipsi_pre) %for all the mice 
    KO_preORI_ipsi_all=[KO_preORI_ipsi_all; KODrift_all_binoc_ipsi_pre(i).pre_ori_pref_ipsi'];
end 

%KO,postMD
KO_postORI_ipsi_all=[]; 
for i=1:length(KODrift_all_binoc_ipsi_post) %for all the mice 
    KO_postORI_ipsi_all=[KO_postORI_ipsi_all; KODrift_all_binoc_ipsi_post(i).post_ori_pref_ipsi'];
end 

%Calculate change in pref ori 
WT_preORI_diff_all=abs(WT_preORI_contra_all- WT_preORI_ipsi_all); 
WT_postORI_diff_all=abs(WT_postORI_contra_all- WT_postORI_ipsi_all); 

KO_preORI_diff_all=abs(KO_preORI_contra_all- KO_preORI_ipsi_all); 
KO_postORI_diff_all=abs(KO_postORI_contra_all- KO_postORI_ipsi_all); 

WT_pre_idx=WT_preORI_diff_all>90; % if diff ori >90 then the actual value is 180- diff ori
WT_preORI_diff_all(WT_pre_idx)=180-WT_preORI_diff_all(WT_pre_idx);
WT_post_idx=WT_postORI_diff_all>90; 
WT_postORI_diff_all(WT_post_idx)=180-WT_postORI_diff_all(WT_post_idx);

KO_pre_idx=KO_preORI_diff_all>90; % if diff ori >90 then the actual value is 180- diff ori
KO_preORI_diff_all(KO_pre_idx)=180-KO_preORI_diff_all(KO_pre_idx);
KO_post_idx=KO_postORI_diff_all>90; 
KO_postORI_diff_all(KO_post_idx)=180-KO_postORI_diff_all(KO_post_idx);

%% ALL cells binocular matching 

char_WT_ori_pre_all=strings(length(WT_preORI_contra_all),6); 

for i=1:length(WT_preORI_contra_all)
    char_WT_ori_pre_all(i,1)='pre';
    char_WT_ori_pre_all(i,2)='WT'; 
    char_WT_ori_pre_all(i,3)='contra'; 
    char_WT_ori_pre_all(i,4)='ipsi'; 
    char_WT_ori_pre_all(i,5)='pre WT contra'; 
    char_WT_ori_pre_all(i,6)='pre WT ipsi'; 
end 

char_WT_ori_post_all=strings(length(WT_postORI_contra_all),6); 

for i=1:length(WT_postORI_contra_all)
    char_WT_ori_post_all(i,1)='post';
    char_WT_ori_post_all(i,2)='WT'; 
    char_WT_ori_post_all(i,3)='contra'; 
    char_WT_ori_post_all(i,4)='ipsi'; 
    char_WT_ori_post_all(i,5)='post WT contra'; 
    char_WT_ori_post_all(i,6)='post WT ipsi'; 
end 

char_KO_ori_pre_all=strings(length(KO_preORI_contra_all),6); 

for i=1:length(KO_preORI_contra_all)
    char_KO_ori_pre_all(i,1)='pre';
    char_KO_ori_pre_all(i,2)='KO'; 
    char_KO_ori_pre_all(i,3)='contra'; 
    char_KO_ori_pre_all(i,4)='ipsi'; 
    char_KO_ori_pre_all(i,5)='pre KO contra'; 
    char_KO_ori_pre_all(i,6)='pre KO ipsi'; 
end 

char_KO_ori_post_all=strings(length(KO_postORI_contra_all),6); 

for i=1:length(KO_postORI_contra_all)
    char_KO_ori_post_all(i,1)='post';
    char_KO_ori_post_all(i,2)='KO'; 
    char_KO_ori_post_all(i,3)='contra'; 
    char_KO_ori_post_all(i,4)='ipsi'; 
    char_KO_ori_post_all(i,5)='post KO contra'; 
    char_KO_ori_post_all(i,6)='post KO ipsi'; 
end 

%make an empty table

ori_all=vertcat(WT_preORI_contra_all, WT_postORI_contra_all, KO_preORI_contra_all, KO_postORI_contra_all,...
    WT_preORI_ipsi_all, WT_postORI_ipsi_all, KO_preORI_ipsi_all, KO_postORI_ipsi_all); %pre, post, pre, post  

genotype_ori_all=vertcat(char_WT_ori_pre_all(:,2), char_WT_ori_post_all(:,2), char_KO_ori_pre_all(:,2), char_KO_ori_post_all(:,2),...
    char_WT_ori_pre_all(:,2), char_WT_ori_post_all(:,2), char_KO_ori_pre_all(:,2), char_KO_ori_post_all(:,2)); %WT  then KO pre post 

condition_ori_all=vertcat(char_WT_ori_pre_all(:,1), char_WT_ori_post_all(:,1), char_KO_ori_pre_all(:,1), char_KO_ori_post_all(:,1),...
    char_WT_ori_pre_all(:,1), char_WT_ori_post_all(:,1), char_KO_ori_pre_all(:,1), char_KO_ori_post_all(:,1)); %pre, post, pre, post

eye_ori_all=vertcat(char_WT_ori_pre_all(:,3), char_WT_ori_post_all(:,3), char_KO_ori_pre_all(:,3), char_KO_ori_post_all(:,3),...
    char_WT_ori_pre_all(:,4), char_WT_ori_post_all(:,4), char_KO_ori_pre_all(:,4), char_KO_ori_post_all(:,4)); %contra, then ipsi 

group_ori_all= vertcat(char_WT_ori_pre_all(:,5), char_WT_ori_post_all(:,5), char_KO_ori_pre_all(:,5), char_KO_ori_post_all(:,5),...
    char_WT_ori_pre_all(:,6), char_WT_ori_post_all(:,6), char_KO_ori_pre_all(:,6), char_KO_ori_post_all(:,6)); 

Oritable_all=table(ori_all,condition_ori_all,genotype_ori_all,eye_ori_all,group_ori_all); 

%two way anova 
[p_ori_all,tbl_ori_all,stats_ori_all]=anovan(Oritable_all.ori_all,{Oritable_all.condition_ori_all,Oritable_all.genotype_ori_all,Oritable_all.eye_ori_all},...
    'model', 'interaction', 'varnames', {'condition_ori_all', 'genotype_ori_all', 'eye_ori_all'},'display','off'); 
%save table 
save(fullfile(SaveDir,'PrefOri_ANOVAresults_all.mat'),'tbl_ori_all'); 
writecell(tbl_ori_all,fullfile(SaveDir, 'PrefOri_ANOVAresults_all.xls')); 

%multicomparisons
[results_ori_all,m_ori_all,h_ori_all,gnames_ori_all]=multcompare(stats_ori_all,"Dimension", [1 2 3],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi_ori_all=array2table(results,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi_ori_all.("Group A")=gnames_ori_all(tbl_multi_ori_all.("Group A")); 
tbl_multi_ori_all.("Group B")=gnames_ori_all(tbl_multi_ori_all.("Group B")); 

%save
save(fullfile(SaveDir,'Pref_ori_MultipleComparisons_all.mat'),'tbl_multi_ori_all'); 
writetable(tbl_multi_ori_all,fullfile(SaveDir, 'Pref_ori_MultipleComparisons_all.xls'),'WriteMode','overwritesheet'); 


%make swarmchart plot 
swarmchartplot_all=figure(9);
groupnames_all={'pre WT contra', 'pre KO contra', 'post WT contra', 'post KO contra',...
    'pre WT ipsi', 'pre KO ipsi', 'post WT ipsi', 'post KO ipsi'}; 
vio_color_all=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1],...
    [0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
vs_all=violinplot(Oritable_all.ori_all, Oritable_all.group_ori_all,'GroupOrder', groupnames_all,'ViolinColor', vio_color_all); 
ylim([0 180]); 
set(gca,'TickDir','out');
title('Pref Ori-All cells')
ylabel('ori')
xlabel('Group')


%make histograms for each condition 

%scales 

hist_binocularmatch_all=figure(10); 
t_ori_all=tiledlayout(2,2); 
%WT pre 
nexttile
h1_all=histogram(WT_preORI_diff_all, 10,'Normalization','probability', 'FaceColor', [0.3 0.3 0.3]);
ylim([0 .5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre MD')
box off 

%WT post 
nexttile
h2_all=histogram(WT_postORI_diff_all, 10,'Normalization','probability', 'FaceColor', [0.7 0.7 0.7]);
ylim([0 .5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('WT- post MD')
box off 

%KO pre 
nexttile
h3_all=histogram(KO_preORI_diff_all, 10, 'Normalization','probability','FaceColor', [.8 0 1]);
ylim([0 .5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre MD')
box off 

%KO post 
nexttile
h4_all=histogram(KO_postORI_diff_all, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);

ylim([0 .5])
title ('KO- post MD')
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
box off 
title(t_ori_all,'Binocular Matching')
xlabel(t_ori_all,'Delta O')
ylabel(t_ori_all,'Percentage of Neurons')

%save figure 
saveas(hist_binocularmatch_all, fullfile(SaveDir, 'BinocularMatching_all-histograms'), 'pdf');
saveas(hist_binocularmatch_all, fullfile(SaveDir, 'BinocularMatching_all-histograms'), 'tif');
saveas(hist_binocularmatch_all, fullfile(SaveDir, 'BinocularMatching_all-histograms'), 'fig');

%make box plots
char_WT_ori_diff_pre_all=strings(length(WT_preORI_diff_all),3); 
char_KO_ori_diff_pre_all=strings(length(KO_preORI_diff_all),3);

for i=1:length(WT_preORI_diff_all)
    char_WT_ori_diff_pre_all(i,1)='WT';
    char_WT_ori_diff_pre_all(i,2)='pre';
    char_WT_ori_diff_pre_all(i,3)='pre WT';
end
for i=1:length(KO_preORI_diff_all)
    char_KO_ori_diff_pre_all(i,1)='KO'; 
    char_KO_ori_diff_pre_all(i,2)='pre';
    char_KO_ori_diff_pre_all(i,3)='pre KO';
end

char_WT_ori_diff_post_all=strings(length(WT_postORI_diff_all),3); 
char_KO_ori_diff_post_all=strings(length(KO_postORI_diff_all),3);

for i=1:length(WT_postORI_diff_all)
    char_WT_ori_diff_post_all(i,1)='WT';
    char_WT_ori_diff_post_all(i,2)='post';
    char_WT_ori_diff_post_all(i,3)='post WT';
end
for i=1:length(KO_postORI_diff_all)
    char_KO_ori_diff_post_all(i,1)='KO'; 
    char_KO_ori_diff_post_all(i,2)='post';
    char_KO_ori_diff_post_all(i,3)='post KO';
end

%compile table 
ori_diff_all=vertcat(WT_preORI_diff_all, WT_postORI_diff_all,KO_preORI_diff_all, KO_postORI_diff_all); 
genotype_diff_all=vertcat(char_WT_ori_diff_pre_all(:,1), char_WT_ori_diff_post_all(:,1), char_KO_ori_diff_pre_all (:,1), char_KO_ori_diff_post_all (:,1)); 
condition_diff_all=vertcat(char_WT_ori_diff_pre_all(:,2), char_WT_ori_diff_post_all(:,2), char_KO_ori_diff_pre_all(:,2), char_KO_ori_diff_post_all(:,2)); 
group_diff_all=vertcat(char_WT_ori_diff_pre_all(:,3), char_WT_ori_diff_post_all(:,3), char_KO_ori_diff_pre_all(:,3), char_KO_ori_diff_post_all(:,3));
Ori_diff_table_all=table(ori_diff_all,condition_diff_all,genotype_diff_all,group_diff_all); 

writetable(Ori_diff_table_all, fullfile(SaveDir, 'OriMatching_diff_table_all.xls'),'WriteMode','overwritesheet'); 

%two-way ANOVA 
[p_ori_diff_all,tbl_ori_diff_all,stats_ori_diff_all]=anovan(Ori_diff_table_all.ori_diff_all,{Ori_diff_table_all.condition_diff_all,Ori_diff_table_all.genotype_diff_all},...
    'model', 'interaction', 'varnames', {'condition_ori_diff_all', 'genotype_ori_diff_all'},'display','off'); 
%save table 
save(fullfile(SaveDir,'Diff_Ori_ANOVAresults_all.mat'),'tbl_ori_diff_all'); 
writecell(tbl_ori_diff_all, fullfile(SaveDir, 'Diff_Ori_ANOVAresults_all.xls')); 


%multicomparisons
[results_ori_diff_all,m_ori_diff_all,h_ori_diff_all,gnames_ori_diff_all]=multcompare(stats_ori_diff_all,"Dimension", [1 2],"CriticalValueType","hsd", 'Display','off'); 

tbl_multi_ori_diff_all=array2table(results_all,"VariableNames",...
    ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
tbl_multi_ori_diff_all.("Group A")=gnames_ori_diff_all(tbl_multi_ori_diff_all.("Group A")); 
tbl_multi_ori_diff_all.("Group B")=gnames_ori_diff_all(tbl_multi_ori_diff_all.("Group B")); 

%save
save(fullfile(SaveDir,'Diff_Ori_MultipleComparisons_all.mat'),'tbl_multi_ori_diff_all'); 
writetable(tbl_multi_ori_diff_all, fullfile(SaveDir, 'Diff_Ori_MultipleComparisons_all.xls'),'WriteMode','overwritesheet'); 

%make box plot
box_bm_all=figure(11); 
% groupnames_diff={'pre WT', 'pre KO', 'post WT', 'post KO'};   
Ori_diff_table_all.group_diff_all= categorical(Ori_diff_table_all.group_diff_all); 
% groups_diff=reordercats(groups_diff, {'pre WT', 'pre KO', 'post WT','post KO'});
% ori_diff_horz=horzcat(WT_preORI_diff, KO_preORI_diff, WT_postORI_diff,KO_preORI_diff, KO_postORI_diff); 

% box_color=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
b1_all=boxchart(Ori_diff_table_all.group_diff_all, Ori_diff_table_all.ori_diff_all,'MarkerStyle','none');
box off 
ylabel('Deltaori')
xlabel('Group')
title('Binocular Matching-AllCells');
saveas(box_bm_all, fullfile(SaveDir, 'BinocularMatching-boxplot_all'), 'pdf');
saveas(box_bm_all, fullfile(SaveDir, 'BinocularMatching-boxplot_all'), 'tif');
saveas(box_bm_all, fullfile(SaveDir, 'BinocularMatching-boxplot_all'), 'fig');

%% CV for orientation- binocular cells 
%WT, preMD
% CONTRALATERAL EYE RESPONSES 
%WT, preMD
WT_pre_cv_contra=[]; 
for i=1:length(WTDrift_pre_cv_contra) %for all the mice 
    WT_pre_cv_contra=[WT_pre_cv_contra; WTDrift_pre_cv_contra(i).cv_pre_contra'];
end 

%WT,postMD
WT_post_cv_contra=[]; 
for i=1:length(WTDrift_post_cv_contra) %for all the mice 
    WT_post_cv_contra=[WT_post_cv_contra; WTDrift_post_cv_contra(i).cv_post_contra'];
end 

%KO,preMD
KO_pre_cv_contra=[]; 
for i=1:length(KODrift_pre_cv_contra) %for all the mice 
    KO_pre_cv_contra=[KO_pre_cv_contra; KODrift_pre_cv_contra(i).cv_pre_contra'];
end 

%KO,postMD
KO_post_cv_contra=[]; 
for i=1:length(KODrift_post_cv_contra) %for all the mice 
    KO_post_cv_contra=[KO_post_cv_contra; KODrift_post_cv_contra(i).cv_post_contra'];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_pre_cv_ipsi=[]; 
for i=1:length(WTDrift_pre_cv_ipsi) %for all the mice 
    WT_pre_cv_ipsi=[WT_pre_cv_ipsi; WTDrift_pre_cv_ipsi(i).cv_pre_ipsi'];
end 

%WT,postMD
WT_post_cv_ipsi=[]; 
for i=1:length(WTDrift_post_cv_ipsi) %for all the mice 
    WT_post_cv_ipsi=[WT_post_cv_ipsi; WTDrift_post_cv_ipsi(i).cv_post_ipsi'];
end 

%KO,preMD
KO_pre_cv_ipsi=[]; 
for i=1:length(KODrift_pre_cv_ipsi) %for all the mice 
    KO_pre_cv_ipsi=[KO_pre_cv_ipsi; KODrift_pre_cv_ipsi(i).cv_pre_ipsi'];
end 

%KO,postMD
KO_post_cv_ipsi=[]; 
for i=1:length(KODrift_post_cv_ipsi) %for all the mice 
    KO_post_cv_ipsi=[KO_post_cv_ipsi; KODrift_post_cv_ipsi(i).cv_post_ipsi'];
end 

%contralateral and ipsilateral cells ori pref 
% CONTRALATERAL EYE RESPONSES 
%WT, preMD
WT_pre_cv_contra_only=[]; 
for i=1:length(WTDrift_pre_cv_contra_only) %for all the mice 
    WT_pre_cv_contra_only=[WT_pre_cv_contra_only; WTDrift_pre_cv_contra_only(i).cv_pre_contra_only'];
end 

%WT,postMD
WT_post_cv_contra_only=[]; 
for i=1:length(WTDrift_post_cv_contra_only) %for all the mice 
    WT_post_cv_contra_only=[WT_post_cv_contra_only; WTDrift_post_cv_contra_only(i).cv_post_contra_only'];
end 

%KO,preMD
KO_pre_cv_contra_only=[]; 
for i=1:length(KODrift_pre_cv_contra_only) %for all the mice 
    KO_pre_cv_contra_only=[KO_pre_cv_contra_only; KODrift_pre_cv_contra_only(i).cv_pre_contra_only'];
end 

%KO,postMD
KO_post_cv_contra_only=[]; 
for i=1:length(KODrift_post_cv_contra_only) %for all the mice 
    KO_post_cv_contra_only=[KO_post_cv_contra_only; KODrift_post_cv_contra_only(i).cv_post_contra_only'];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_pre_cv_ipsi_only=[]; 
for i=1:length(WTDrift_pre_cv_ipsi_only) %for all the mice 
    WT_pre_cv_ipsi_only=[WT_pre_cv_ipsi_only; WTDrift_pre_cv_ipsi_only(i).cv_pre_ipsi_only'];
end 

%WT,postMD
WT_post_cv_ipsi_only=[]; 
for i=1:length(WTDrift_post_cv_ipsi_only) %for all the mice 
    WT_post_cv_ipsi_only=[WT_post_cv_ipsi_only; WTDrift_post_cv_ipsi_only(i).cv_post_ipsi_only'];
end 

%KO,preMD
KO_pre_cv_ipsi_only=[]; 
for i=1:length(KODrift_pre_cv_ipsi_only) %for all the mice 
    KO_pre_cv_ipsi_only=[KO_pre_cv_ipsi_only; KODrift_pre_cv_ipsi_only(i).cv_pre_ipsi_only'];
end 

%KO,postMD
KO_post_cv_ipsi_only=[]; 
for i=1:length(KODrift_post_cv_ipsi_only) %for all the mice 
    KO_post_cv_ipsi_only=[KO_post_cv_ipsi_only; KODrift_post_cv_ipsi_only(i).cv_post_ipsi_only'];
end 

%save files 
writematrix(WT_pre_cv_contra_only, fullfile(SaveDir, 'WT_pre_cv_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_post_cv_contra_only, fullfile(SaveDir, 'WT_post_cv_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_pre_cv_ipsi_only, fullfile(SaveDir, 'WT_pre_cv_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_post_cv_ipsi_only, fullfile(SaveDir, 'WT_post_cv_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(KO_pre_cv_contra_only, fullfile(SaveDir, 'KO_pre_cv_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_post_cv_contra_only, fullfile(SaveDir, 'KO_post_cv_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_pre_cv_ipsi_only, fullfile(SaveDir, 'KO_pre_cv_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_post_cv_ipsi_only, fullfile(SaveDir, 'KO_post_cv_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(WT_pre_cv_contra, fullfile(SaveDir, 'WT_pre_cv_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_post_cv_contra, fullfile(SaveDir, 'WT_post_cv_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_pre_cv_ipsi, fullfile(SaveDir, 'WT_pre_cv_bin_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_post_cv_ipsi, fullfile(SaveDir, 'WT_post_cv_bin_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(KO_pre_cv_contra, fullfile(SaveDir, 'KO_pre_cv_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_post_cv_contra, fullfile(SaveDir, 'KO_post_cv_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_pre_cv_ipsi, fullfile(SaveDir, 'KO_pre_cv_bin_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_post_cv_ipsi, fullfile(SaveDir, 'KO_post_cv_bin_ipsi.xls'),'WriteMode','overwritesheet'); 


%% plot drifting gratings- BINOCULAR MATCHING  
%first organized the data into concatenated vectors 
%WT, preMD
% CONTRALATERAL EYE RESPONSES 
%WT, preMD
WT_preORI_contra=[]; 
for i=1:length(WTDrift_pre_contra) %for all the mice 
    WT_preORI_contra=[WT_preORI_contra; WTDrift_pre_contra(i).Oripref_pre_contra];
end 

%WT,postMD
WT_postORI_contra=[]; 
for i=1:length(WTDrift_post_contra) %for all the mice 
    WT_postORI_contra=[WT_postORI_contra; WTDrift_post_contra(i).Oripref_post_contra];
end 

%KO,preMD
KO_preORI_contra=[]; 
for i=1:length(KODrift_pre_contra) %for all the mice 
    KO_preORI_contra=[KO_preORI_contra; KODrift_pre_contra(i).Oripref_pre_contra];
end 

%KO,postMD
KO_postORI_contra=[]; 
for i=1:length(KODrift_post_contra) %for all the mice 
    KO_postORI_contra=[KO_postORI_contra; KODrift_post_contra(i).Oripref_post_contra];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_preORI_ipsi=[]; 
for i=1:length(WTDrift_pre_ipsi) %for all the mice 
    WT_preORI_ipsi=[WT_preORI_ipsi; WTDrift_pre_ipsi(i).Oripref_pre_ipsi];
end 

%WT,postMD
WT_postORI_ipsi=[]; 
for i=1:length(WTDrift_post_ipsi) %for all the mice 
    WT_postORI_ipsi=[WT_postORI_ipsi; WTDrift_post_ipsi(i).Oripref_post_ipsi];
end 

%KO,preMD
KO_preORI_ipsi=[]; 
for i=1:length(KODrift_pre_ipsi) %for all the mice 
    KO_preORI_ipsi=[KO_preORI_ipsi; KODrift_pre_ipsi(i).Oripref_pre_ipsi];
end 

%KO,postMD
KO_postORI_ipsi=[]; 
for i=1:length(KODrift_post_ipsi) %for all the mice 
    KO_postORI_ipsi=[KO_postORI_ipsi; KODrift_post_ipsi(i).Oripref_post_ipsi];
end 

%contralateral and ipsilateral cells ori pref 
% CONTRALATERAL EYE RESPONSES 
%WT, preMD
WT_preORI_contra_only=[]; 
for i=1:length(WTDrift_pre_contra_only) %for all the mice 
    WT_preORI_contra_only=[WT_preORI_contra_only; WTDrift_pre_contra_only(i).Oripref_pre_contra_only'];
end 

%WT,postMD
WT_postORI_contra_only=[]; 
for i=1:length(WTDrift_post_contra_only) %for all the mice 
    WT_postORI_contra_only=[WT_postORI_contra_only; WTDrift_post_contra_only(i).Oripref_post_contra_only'];
end 

%KO,preMD
KO_preORI_contra_only=[]; 
for i=1:length(KODrift_pre_contra_only) %for all the mice 
    KO_preORI_contra_only=[KO_preORI_contra_only; KODrift_pre_contra_only(i).Oripref_pre_contra_only'];
end 

%KO,postMD
KO_postORI_contra_only=[]; 
for i=1:length(KODrift_post_contra_only) %for all the mice 
    KO_postORI_contra_only=[KO_postORI_contra_only; KODrift_post_contra_only(i).Oripref_post_contra_only'];
end 

% IPSILATERAL EYE RESPONSES 
%WT, preMD
WT_preORI_ipsi_only=[]; 
for i=1:length(WTDrift_pre_ipsi_only) %for all the mice 
    WT_preORI_ipsi_only=[WT_preORI_ipsi_only; WTDrift_pre_ipsi_only(i).Oripref_pre_ipsi_only'];
end 

%WT,postMD
WT_postORI_ipsi_only=[]; 
for i=1:length(WTDrift_post_ipsi_only) %for all the mice 
    WT_postORI_ipsi_only=[WT_postORI_ipsi_only; WTDrift_post_ipsi_only(i).Oripref_post_ipsi_only'];
end 

%KO,preMD
KO_preORI_ipsi_only=[]; 
for i=1:length(KODrift_pre_ipsi_only) %for all the mice 
    KO_preORI_ipsi_only=[KO_preORI_ipsi_only; KODrift_pre_ipsi_only(i).Oripref_pre_ipsi_only'];
end 

%KO,postMD
KO_postORI_ipsi_only=[]; 
for i=1:length(KODrift_post_ipsi_only) %for all the mice 
    KO_postORI_ipsi_only=[KO_postORI_ipsi_only; KODrift_post_ipsi_only(i).Oripref_post_ipsi_only'];
end 


%Calculate change in pref ori 
WT_preORI_diff=abs(WT_preORI_contra- WT_preORI_ipsi); 
WT_postORI_diff=abs(WT_postORI_contra- WT_postORI_ipsi); 

KO_preORI_diff=abs(KO_preORI_contra- KO_preORI_ipsi); 
KO_postORI_diff=abs(KO_postORI_contra- KO_postORI_ipsi); 

WT_pre_idx=WT_preORI_diff>90; % if diff ori >90 then the actual value is 180- diff ori
WT_preORI_diff(WT_pre_idx)=180-WT_preORI_diff(WT_pre_idx);
WT_post_idx=WT_postORI_diff>90; 
WT_postORI_diff(WT_post_idx)=180-WT_postORI_diff(WT_post_idx);

KO_pre_idx=KO_preORI_diff>90; % if diff ori >90 then the actual value is 180- diff ori
KO_preORI_diff(KO_pre_idx)=180-KO_preORI_diff(KO_pre_idx);
KO_post_idx=KO_postORI_diff>90; 
KO_postORI_diff(KO_post_idx)=180-KO_postORI_diff(KO_post_idx);

%% put data in a table for two way anova 
char_WT_ori=strings(length(WT_preORI_contra),9); 

for i=1:length(WT_preORI_contra)
    char_WT_ori(i,1)='pre';
    char_WT_ori(i,2)='post';
    char_WT_ori(i,3)='WT'; 
    char_WT_ori(i,4)='contra'; 
    char_WT_ori (i,5)='ipsi'; 
    char_WT_ori(i,6)='pre WT contra'; 
    char_WT_ori(i,7)='pre WT ipsi'; 
    char_WT_ori(i,8)='post WT contra'; 
    char_WT_ori(i,9)='post WT ipsi'; 
end 

char_KO_ori=strings(length(KO_preORI_contra),9); 

for i=1:length(KO_preORI_contra)
    char_KO_ori(i,1)='pre';
    char_KO_ori(i,2)='post';
    char_KO_ori(i,3)='KO'; 
    char_KO_ori(i,4)='contra'; 
    char_KO_ori (i,5)='ipsi'; 
    char_KO_ori(i,6)='pre KO contra'; 
    char_KO_ori(i,7)='pre KO ipsi'; 
    char_KO_ori(i,8)='post KO contra'; 
    char_KO_ori(i,9)='post KO ipsi';  
end 

%make an empty table

ori=vertcat(WT_preORI_contra, WT_postORI_contra, KO_preORI_contra, KO_postORI_contra,...
    WT_preORI_ipsi, WT_postORI_ipsi, KO_preORI_ipsi, KO_postORI_ipsi); %pre, post, pre, post  

genotype_ori=vertcat(char_WT_ori(:,3), char_WT_ori(:,3), char_KO_ori(:,3), char_KO_ori(:,3),...
    char_WT_ori(:,3), char_WT_ori(:,3), char_KO_ori(:,3), char_KO_ori(:,3)); %WT then KO

condition_ori=vertcat(char_WT_ori(:,1), char_WT_ori(:,2), char_KO_ori(:,1), char_KO_ori(:,2),...
    char_WT_ori(:,1), char_WT_ori(:,2), char_KO_ori(:,1), char_KO_ori(:,2)); %pre, post, pre, post

eye_ori=vertcat(char_WT_ori(:,4), char_WT_ori(:,4), char_KO_ori(:,4), char_KO_ori(:,4),...
    char_WT_ori(:,5), char_WT_ori(:,5), char_KO_ori(:,5), char_KO_ori(:,5)); %contra, then ipsi 

group_ori= vertcat(char_WT_ori(:,6), char_WT_ori(:,8), char_KO_ori(:,6), char_KO_ori(:,8),...
    char_WT_ori(:,7), char_WT_ori(:,9), char_KO_ori(:,7), char_KO_ori(:,9)); 

Oritable=table(ori,condition_ori,genotype_ori,eye_ori,group_ori); 

%two way anova 
[p_ori,tbl_ori,stats_ori]=anovan(Oritable.ori,{Oritable.condition_ori,Oritable.genotype_ori,Oritable.eye_ori},...
    'model', 'interaction', 'varnames', {'condition_ori', 'genotype_ori', 'eye_ori'},'display','off'); 
%save table 
save(fullfile(SaveDir,'PrefOri_ANOVAresults.mat'),'tbl_ori'); 
writecell(tbl_ori,fullfile(SaveDir, 'PrefOri_ANOVAresults.xls')); 

%multicomparisons
%[results_ori,m_ori,h_ori,gnames_ori]=multcompare(stats_ori,"Dimension", [1 2 3],"CriticalValueType","hsd", 'Display','off'); 

% tbl_multi_ori=array2table(results,"VariableNames",...
%     ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
% tbl_multi_ori.("Group A")=gnames_ori(tbl_multi_ori.("Group A")); 
% tbl_multi_ori.("Group B")=gnames_ori(tbl_multi_ori.("Group B")); 
% 
% %save
% save(fullfile(SaveDir,'Pref_ori_MultipleComparisons.mat'),'tbl_multi_ori'); 
% writetable(tbl_multi_ori,fullfile(SaveDir, 'Pref_ori_MultipleComparisons.xls')); 


%make swarmchart plot 
swarmchartplot=figure(12);
groupnames={'pre WT contra', 'pre KO contra', 'post WT contra', 'post KO contra',...
    'pre WT ipsi', 'pre KO ipsi', 'post WT ipsi', 'post KO ipsi'}; 
vio_color=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1],...
    [0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
vs=violinplot(Oritable.ori, Oritable.group_ori,'GroupOrder', groupnames,'ViolinColor', vio_color); 
ylim([0 180]); 
set(gca,'TickDir','out');
title('Pref Ori')
ylabel('ori')
xlabel('Group')


%make histograms for each condition 

%scales 

hist_binocularmatch=figure(13); 
t_ori=tiledlayout(2,2); 
%WT pre 
nexttile
h1=histogram(WT_preORI_diff, 10,'Normalization','probability', 'FaceColor', [0.3 0.3 0.3]);
ylim([0 .5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre MD')
box off 

%WT post 
nexttile
h2=histogram(WT_postORI_diff, 10,'Normalization','probability', 'FaceColor', [0.7 0.7 0.7]);
ylim([0 .5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('WT- post MD')
box off 

%KO pre 
nexttile
h3=histogram(KO_preORI_diff, 10, 'Normalization','probability','FaceColor', [.8 0 1]);
ylim([0 .5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre MD')
box off 

%KO post 
nexttile
h4=histogram(KO_postORI_diff, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);

ylim([0 .5])
title ('KO- post MD')
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
box off 
title(t_ori,'Binocular Matching')
xlabel(t_ori,'Delta O')
ylabel(t_ori,'Percentage of Neurons')

%save figure 
saveas(hist_binocularmatch, fullfile(SaveDir, 'BinocularMatching-histograms'), 'pdf');
saveas(hist_binocularmatch, fullfile(SaveDir, 'BinocularMatching-histograms'), 'tif');
saveas(hist_binocularmatch, fullfile(SaveDir, 'BinocularMatching-histograms'), 'fig');

%make box plots
char_WT_ori_diff=strings(length(WT_preORI_diff),5); 
char_KO_ori_diff=strings(length(KO_preORI_diff),5);

for i=1:length(WT_preORI_diff)
    char_WT_ori_diff(i,1)='WT';
    char_WT_ori_diff(i,2)='pre';
    char_WT_ori_diff(i,3)='post';
    char_WT_ori_diff(i,4)='pre WT';
    char_WT_ori_diff(i,5)='post WT';
end
for i=1:length(KO_preORI_diff)
    char_KO_ori_diff(i,1)='KO'; 
    char_KO_ori_diff(i,2)='pre';
    char_KO_ori_diff(i,3)='post';
    char_KO_ori_diff(i,4)='pre KO';
    char_KO_ori_diff(i,5)='post KO';
end

ori_diff=vertcat(WT_preORI_diff, WT_postORI_diff,KO_preORI_diff, KO_postORI_diff); 
genotype_diff=vertcat(char_WT_ori_diff(:,1), char_WT_ori_diff(:,1), char_KO_ori_diff (:,1), char_KO_ori_diff (:,1)); 
condition_diff=vertcat(char_WT_ori_diff(:,2), char_WT_ori_diff(:,3), char_KO_ori_diff(:,2), char_KO_ori_diff(:,3)); 
group_diff=vertcat(char_WT_ori_diff(:,4), char_WT_ori_diff(:,5), char_KO_ori_diff(:,4), char_KO_ori_diff(:,5));
Ori_diff_table=table(ori_diff,condition_diff,genotype_diff,group_diff); 

writetable(Ori_diff_table, fullfile(SaveDir, 'OriMatching_diff_table.xls'),'WriteMode','overwritesheet'); 

%two-way ANOVA 
[p_ori_diff,tbl_ori_diff,stats_ori_diff]=anovan(Ori_diff_table.ori_diff,{Ori_diff_table.condition_diff,Ori_diff_table.genotype_diff},...
    'model', 'interaction', 'varnames', {'condition_ori_diff', 'genotype_ori_diff'},'display','off'); 
%save table 
save(fullfile(SaveDir,'Diff_Ori_ANOVAresults.mat'),'tbl_ori_diff'); 
writecell(tbl_ori_diff, fullfile(SaveDir, 'Diff_Ori_ANOVAresults.xls')); 


%multicomparisons
% [results_ori_diff,m_ori_diff,h_ori_diff,gnames_ori_diff]=multcompare(stats_ori_diff,"Dimension", [1 2],"CriticalValueType","hsd", 'Display','off'); 
% 
% tbl_multi_ori_diff=array2table(results,"VariableNames",...
%     ["Group A", "Group B", "Lower limit", "A-B", "Upper limit", "P-value"]); 
% tbl_multi_ori_diff.("Group A")=gnames_ori_diff(tbl_multi_ori_diff.("Group A")); 
% tbl_multi_ori_diff.("Group B")=gnames_ori_diff(tbl_multi_ori_diff.("Group B")); 
% 
% %save
% save(fullfile(SaveDir,'Diff_Ori_MultipleComparisons.mat'),'tbl_multi_ori_diff'); 
% writetable(tbl_multi_ori_diff, fullfile(SaveDir, 'Diff_Ori_MultipleComparisons.xls')); 

%make box plot
box_bm=figure(14); 
% groupnames_diff={'pre WT', 'pre KO', 'post WT', 'post KO'};   
Ori_diff_table.group_diff= categorical(Ori_diff_table.group_diff); 
% groups_diff=reordercats(groups_diff, {'pre WT', 'pre KO', 'post WT','post KO'});
% ori_diff_horz=horzcat(WT_preORI_diff, KO_preORI_diff, WT_postORI_diff,KO_preORI_diff, KO_postORI_diff); 

% box_color=vertcat([0 0 0],[.8 0 1], [0.4 0.4 0.4],[.8 0.7 1]); 
b1=boxchart(Ori_diff_table.group_diff, Ori_diff_table.ori_diff,'MarkerStyle','none');
box off 
ylabel('Deltaori')
xlabel('Group')

saveas(box_bm, fullfile(SaveDir, 'BinocularMatching-boxplot'), 'pdf');
saveas(box_bm, fullfile(SaveDir, 'BinocularMatching-boxplot'), 'tif');
saveas(box_bm, fullfile(SaveDir, 'BinocularMatching-boxplot'), 'fig');

%% make histograms for preferred orientations for contra, ipsi,and binoc cells 

WT_pre_allcontra=[]; 
WT_post_allcontra=[]; 
KO_pre_allcontra=[]; 
KO_post_allcontra=[];

%ipsilateral responses
WT_pre_allipsi=[]; 
WT_post_allipsi=[]; 
KO_pre_allipsi=[]; 
KO_post_allipsi=[]; 

%contralateral responses 
WT_pre_allcontra=[WT_preORI_contra; WT_preORI_contra_only]; 
WT_post_allcontra=[WT_postORI_contra; WT_postORI_contra_only]; 
KO_pre_allcontra=[KO_preORI_contra; KO_preORI_contra_only]; 
KO_post_allcontra=[KO_postORI_contra; KO_postORI_contra_only];


%ipsilateral responses
WT_pre_allipsi=[WT_preORI_ipsi; WT_preORI_ipsi_only]; 
WT_post_allipsi=[WT_postORI_ipsi; WT_postORI_ipsi_only]; 
KO_pre_allipsi=[KO_preORI_ipsi; KO_preORI_ipsi_only]; 
KO_post_allipsi=[KO_postORI_ipsi; KO_postORI_ipsi_only]; 

labels={'Binoc','Con', 'Ipsi', 'Unresp'};
newColors=[...
    0.47, .93, .48;
    .04, .75, .66;
    .25, .2, .58; 
    .5, .5, .5]; %binoc, con, ipsi custom colors for slices 


%responses -WT
%so we have contralateral responses, binoc contralateral responses
%and then ipsilateral responses, binoc ipsilateral responses
%Pre and post 
polar_hist_WT=figure(30); 
t_ori4=tiledlayout(2,4); 
polar_hist_WT.Position=[2024 225 800 400];

t_ori4.TileSpacing = 'compact';
t_ori4.Padding = 'compact';

%WT pre - contralateral cells  
ax1=nexttile;
h1=polarhistogram(deg2rad(WT_preORI_contra_only), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %contra color
hold on 
polarhistogram(deg2rad(WT_preORI_contra_only-180), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %mirrored /reversed 
hold off
title('Contralateral')
rlim([0 .4])

%WT pre-binoc contralateral response 
ax2=nexttile;
h2=polarhistogram(deg2rad(WT_preORI_contra), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(WT_preORI_contra-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
title('Contralateral-Binoc')
rlim([0 .4])

%WT pre-ipsilateral responses 
ax3=nexttile;
h3=polarhistogram(deg2rad(WT_preORI_ipsi_only), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %ipsi color
hold on 
polarhistogram(deg2rad(WT_preORI_ipsi_only-180), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %mirrored /reversed 
title('Ipsilateral')
hold off
rlim([0 .4])

%WT pre-binoc ipsilateral responses 
ax4=nexttile;
h4=polarhistogram(deg2rad(WT_preORI_ipsi),16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(WT_preORI_ipsi-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
title('Ipsilateral-Binoc')
rlim([0 .4])

title(t_ori4, 'WT')

% POST 
%WT post - contralateral cells  
ax5=nexttile;
h1=polarhistogram(deg2rad(WT_postORI_contra_only), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %contra color
hold on 
polarhistogram(deg2rad(WT_postORI_contra_only-180), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %mirrored /reversed 
hold off
%title('Contralateral')
rlim([0 .4])

%WT post-binoc contralateral response 
ax6=nexttile;
h2=polarhistogram(deg2rad(WT_postORI_contra), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(WT_postORI_contra-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
%title('Contralateral-Binoc')
rlim([0 .4])

%WT ppost-ipsilateral responses 
ax7=nexttile;
h3=polarhistogram(deg2rad(WT_postORI_ipsi_only), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %ipsi color
hold on 
polarhistogram(deg2rad(WT_postORI_ipsi_only-180), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %mirrored /reversed 
%title('Ipsilateral')
hold off
rlim([0 .4])

%WT post-binoc ipsilateral responses 
ax8=nexttile;
h4=polarhistogram(deg2rad(WT_postORI_ipsi), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(WT_postORI_ipsi-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
%title('Ipsilateral-Binoc')
rlim([0 .4])
title(t_ori4, 'WT')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%KO cells 
polar_hist_KO=figure(31); 
t_ori5=tiledlayout(2,4); 
polar_hist_KO.Position=[2024 225 800 400];

t_ori5.TileSpacing = 'compact';
t_ori5.Padding = 'compact';
title(t_ori5, 'KO')

%KO pre - contralateral cells  
ax1=nexttile;
h1=polarhistogram(deg2rad(KO_preORI_contra_only), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %contra color
hold on 
polarhistogram(deg2rad(KO_preORI_contra_only-180), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %mirrored /reversed 
hold off
title('Contralateral')
rlim([0 .4])

%KO pre-binoc contralateral response 
ax2=nexttile;
h2=polarhistogram(deg2rad(KO_preORI_contra), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(KO_preORI_contra-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
title('Contralateral-Binoc')
rlim([0 .4])

%KO pre-ipsilateral responses 
ax3=nexttile;
h3=polarhistogram(deg2rad(KO_preORI_ipsi_only), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %ipsi color
hold on 
polarhistogram(deg2rad(KO_preORI_ipsi_only-180), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %mirrored /reversed 
title('Ipsilateral')
hold off
rlim([0 .4])

%KO pre-binoc ipsilateral responses 
ax4=nexttile;
h4=polarhistogram(deg2rad(KO_preORI_ipsi), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(KO_preORI_ipsi-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
title('Ipsilateral-Binoc')
rlim([0 .4])



% POST 
%KO post - contralateral cells  
ax5=nexttile;
h1=polarhistogram(deg2rad(KO_postORI_contra_only), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %contra color
hold on 
polarhistogram(deg2rad(KO_postORI_contra_only-180), 16,'Normalization','probability', 'FaceColor', [.1540 .5902 .9218]); %mirrored /reversed 
hold off
%title('Contralateral')
rlim([0 .4])

%KO post-binoc contralateral response 
ax6=nexttile;
h2=polarhistogram(deg2rad(KO_postORI_contra),16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(KO_postORI_contra-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
%title('Contralateral-Binoc')
rlim([0 .4])

%KO ppost-ipsilateral responses 
ax7=nexttile;
h3=polarhistogram(deg2rad(KO_postORI_ipsi_only), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %ipsi color
hold on 
polarhistogram(deg2rad(KO_postORI_ipsi_only-180), 16,'Normalization','probability', 'FaceColor', [.5044 .7993 0.3480]); %mirrored /reversed 
%title('Ipsilateral')
hold off
rlim([0 .4])

%KO post-binoc ipsilateral responses 
ax8=nexttile;
h4=polarhistogram(deg2rad(KO_postORI_ipsi), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %binoc color
hold on 
polarhistogram(deg2rad(KO_postORI_ipsi-180), 16,'Normalization','probability', 'FaceColor', [.9769 .9839 0.0805]); %mirrored /reversed 
hold off
%title('Ipsilateral-Binoc')
rlim([0 .4])

saveas(polar_hist_WT, fullfile(SaveDir, 'WT-polarhistprefori'), 'pdf');
saveas(polar_hist_WT, fullfile(SaveDir, 'WT-polarhistprefori'), 'tif');
saveas(polar_hist_WT, fullfile(SaveDir, 'WT-polarhistprefori'), 'fig');

saveas(polar_hist_KO, fullfile(SaveDir, 'KO-polarhistprefori'), 'pdf');
saveas(polar_hist_KO, fullfile(SaveDir, 'KO-polarhistprefori'), 'tif');
saveas(polar_hist_KO, fullfile(SaveDir, 'KO-polarhistprefori'), 'fig');

% cumulative distributions  
step=11.25; 

%contralateral responses 
bins=0:step:180; 
dist_contra_ori_WTpre=hist(WT_preORI_contra_only,bins); %get the distribution
ndist_contra_ori_WTpre= dist_contra_ori_WTpre/ sum(dist_contra_ori_WTpre); %normalize to 0 -1 
cdist_contra_ori_WTpre=cumsum(ndist_contra_ori_WTpre); %cumulative distribution 

dist_contra_ori_WTpost=hist(WT_postORI_contra_only,bins); %get the distribution
ndist_contra_ori_WTpost= dist_contra_ori_WTpost/ sum(dist_contra_ori_WTpost); %normalize to 0 -1 
cdist_contra_ori_WTpost=cumsum(ndist_contra_ori_WTpost); %cumulative distribution 

dist_contra_ori_KOpre=hist(KO_preORI_contra_only,bins); %get the distribution
ndist_contra_ori_KOpre= dist_contra_ori_KOpre/ sum(dist_contra_ori_KOpre); %normalize to 0 -1 
cdist_contra_ori_KOpre=cumsum(ndist_contra_ori_KOpre); %cumulative distribution 

dist_contra_ori_KOpost=hist(KO_postORI_contra_only,bins); %get the distribution
ndist_contra_ori_KOpost= dist_contra_ori_KOpost/ sum(dist_contra_ori_KOpost); %normalize to 0 -1 
cdist_contra_ori_KOpost=cumsum(ndist_contra_ori_KOpost); %cumulative distribution 

%ipsilateral responses 
dist_ipsi_ori_WTpre=hist(WT_preORI_ipsi_only,bins); %get the distribution
ndist_ipsi_ori_WTpre= dist_ipsi_ori_WTpre/ sum(dist_ipsi_ori_WTpre); %normalize to 0 -1 
cdist_ipsi_ori_WTpre=cumsum(ndist_ipsi_ori_WTpre); %cumulative distribution 

dist_ipsi_ori_WTpost=hist(WT_postORI_ipsi_only,bins); %get the distribution
ndist_ipsi_ori_WTpost= dist_ipsi_ori_WTpost/ sum(dist_ipsi_ori_WTpost); %normalize to 0 -1 
cdist_ipsi_ori_WTpost=cumsum(ndist_ipsi_ori_WTpost); %cumulative distribution 

dist_ipsi_ori_KOpre=hist(KO_preORI_ipsi_only,bins); %get the distribution
ndist_ipsi_ori_KOpre= dist_ipsi_ori_KOpre/ sum(dist_ipsi_ori_KOpre); %normalize to 0 -1 
cdist_ipsi_ori_KOpre=cumsum(ndist_ipsi_ori_KOpre); %cumulative distribution 

dist_ipsi_ori_KOpost=hist(KO_postORI_ipsi_only,bins); %get the distribution
ndist_ipsi_ori_KOpost= dist_ipsi_ori_KOpost/ sum(dist_ipsi_ori_KOpost); %normalize to 0 -1 
cdist_ipsi_ori_KOpost=cumsum(ndist_ipsi_ori_KOpost); %cumulative distribution 

%binocular responses - contralateral 
bins=0:step:180; 
dist_bincontra_ori_WTpre=hist(WT_preORI_contra,bins); %get the distribution
ndist_bincontra_ori_WTpre= dist_bincontra_ori_WTpre/ sum(dist_bincontra_ori_WTpre); %normalize to 0 -1 
cdist_bincontra_ori_WTpre=cumsum(ndist_bincontra_ori_WTpre); %cumulative distribution 

dist_bincontra_ori_WTpost=hist(WT_postORI_contra,bins); %get the distribution
ndist_bincontra_ori_WTpost= dist_bincontra_ori_WTpost/ sum(dist_bincontra_ori_WTpost); %normalize to 0 -1 
cdist_bincontra_ori_WTpost=cumsum(ndist_bincontra_ori_WTpost); %cumulative distribution 

dist_bincontra_ori_KOpre=hist(KO_preORI_contra,bins); %get the distribution
ndist_bincontra_ori_KOpre= dist_bincontra_ori_KOpre/ sum(dist_bincontra_ori_KOpre); %normalize to 0 -1 
cdist_bincontra_ori_KOpre=cumsum(ndist_bincontra_ori_KOpre); %cumulative distribution 

dist_bincontra_ori_KOpost=hist(KO_postORI_contra,bins); %get the distribution
ndist_bincontra_ori_KOpost= dist_bincontra_ori_KOpost/ sum(dist_bincontra_ori_KOpost); %normalize to 0 -1 
cdist_bincontra_ori_KOpost=cumsum(ndist_bincontra_ori_KOpost); %cumulative distribution 

%binocular responses -ipsilateral 
dist_binipsi_ori_WTpre=hist(WT_preORI_ipsi,bins); %get the distribution
ndist_binipsi_ori_WTpre= dist_binipsi_ori_WTpre/ sum(dist_binipsi_ori_WTpre); %normalize to 0 -1 
cdist_binipsi_ori_WTpre=cumsum(ndist_binipsi_ori_WTpre); %cumulative distribution 

dist_binipsi_ori_WTpost=hist(WT_postORI_ipsi,bins); %get the distribution
ndist_binipsi_ori_WTpost= dist_binipsi_ori_WTpost/ sum(dist_binipsi_ori_WTpost); %normalize to 0 -1 
cdist_binipsi_ori_WTpost=cumsum(ndist_binipsi_ori_WTpost); %cumulative distribution 

dist_binipsi_ori_KOpre=hist(KO_preORI_ipsi,bins); %get the distribution
ndist_binipsi_ori_KOpre= dist_binipsi_ori_KOpre/ sum(dist_binipsi_ori_KOpre); %normalize to 0 -1 
cdist_binipsi_ori_KOpre=cumsum(ndist_binipsi_ori_KOpre); %cumulative distribution 

dist_binipsi_ori_KOpost=hist(KO_postORI_ipsi,bins); %get the distribution
ndist_binipsi_ori_KOpost= dist_binipsi_ori_KOpost/ sum(dist_binipsi_ori_KOpost); %normalize to 0 -1 
cdist_binipsi_ori_KOpost=cumsum(ndist_binipsi_ori_KOpost); %cumulative distribution 


%plot distribution  

fori=figure(40); 
fori.Position=[2024 225 800 300];
T_ori=tiledlayout(1,4)
contratile=nexttile ;
plot(bins, cdist_contra_ori_WTpre, 'LineWidth',1.5, 'Color', [0.3 0.3 0.3]);
hold on 
ylim ([0 1])
xlim ([0 180])
title (contratile, 'Contralateral')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('Preferred Ori', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
plot(bins,cdist_contra_ori_WTpost, 'LineWidth', 1.5, 'Color', [0.7 0.7 0.7]); 
hold on 
plot(bins, cdist_contra_ori_KOpre, 'LineWidth',1.5, 'Color', [.8 0 1]);
hold on 
plot(bins, cdist_contra_ori_KOpost, 'LineWidth',1.5, 'Color', [.8 0.7 1]);
hold off 
box off 
xticks([0 30 60 90 120 150 180]);
legend('WT pre','WT post', 'KO pre', 'KO post', 'Location','northwest'); 


ipsitile=nexttile ;
plot(bins, cdist_ipsi_ori_WTpre, 'LineWidth',1.5, 'Color', [0.3 0.3 0.3]);
hold on 
ylim ([0 1])
xlim ([0 180])
title (ipsitile,'Ipsilateral')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('Preferred Ori', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
plot(bins,cdist_ipsi_ori_WTpost, 'LineWidth', 1.5, 'Color', [0.7 0.7 0.7]); 
hold on 
plot(bins, cdist_ipsi_ori_KOpre, 'LineWidth',1.5, 'Color', [.8 0 1]);
hold on 
plot(bins, cdist_ipsi_ori_KOpost, 'LineWidth',1.5, 'Color', [.8 0.7 1]);
xticks([0 30 60 90 120 150 180]);

hold off 
box off 

bincontratile=nexttile ;
plot(bins, cdist_bincontra_ori_WTpre, 'LineWidth',1.5, 'Color', [0.3 0.3 0.3]);
hold on 
ylim ([0 1])
xlim ([0 180])
title (bincontratile, 'Binocular cells- contra responses')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('Preferred Ori', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
plot(bins,cdist_bincontra_ori_WTpost, 'LineWidth', 1.5, 'Color', [0.7 0.7 0.7]); 
hold on 
plot(bins, cdist_bincontra_ori_KOpre, 'LineWidth',1.5, 'Color', [.8 0 1]);
hold on 
plot(bins, cdist_bincontra_ori_KOpost, 'LineWidth',1.5, 'Color', [.8 0.7 1]);
xticks([0 30 60 90 120 150 180]);
hold off 
box off 

binipsitile=nexttile ;
plot(bins, cdist_binipsi_ori_WTpre, 'LineWidth',1.5, 'Color', [0.3 0.3 0.3]);
hold on 
ylim ([0 1])
xlim ([0 180])
title (binipsitile, 'Binocular cells- ipsi responses')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('Preferred Ori', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
plot(bins,cdist_binipsi_ori_WTpost, 'LineWidth', 1.5, 'Color', [0.7 0.7 0.7]); 
hold on 
plot(bins, cdist_binipsi_ori_KOpre, 'LineWidth',1.5, 'Color', [.8 0 1]);
hold on 
plot(bins, cdist_binipsi_ori_KOpost, 'LineWidth',1.5, 'Color', [.8 0.7 1]);
xticks([0 30 60 90 120 150 180]);

hold off 
box off 

saveas(fori, fullfile(SaveDir, 'PreferredOri-CumDist'), 'pdf');
saveas(fori, fullfile(SaveDir, 'PreferredOri-CumDist'), 'tif');
saveas(fori, fullfile(SaveDir, 'PreferredOri-CumDist'), 'fig');

%statistical tests


%% cardinal proportion
% 90degree +/- 16.875 

%WT 

%contralateral  
WT_pre_contraprop=length(find((WT_preORI_contra_only<(90+16.875) & WT_preORI_contra_only>(90-16.875) |...
    (WT_preORI_contra_only<(180) & WT_preORI_contra_only>(180-16.875)) |...
    (WT_preORI_contra_only>(0) & WT_preORI_contra_only<(16.875)))));

WT_post_contraprop=length(find((WT_postORI_contra_only<(90+16.875) & WT_postORI_contra_only>(90-16.875) |...
    (WT_postORI_contra_only<(180) & WT_postORI_contra_only>(180-16.875)) |...
    (WT_postORI_contra_only>(0) & WT_postORI_contra_only<(16.875)))));

%ipsilateral  
WT_pre_ipsiprop=length(find((WT_preORI_ipsi_only<(90+16.875) & WT_preORI_ipsi_only>(90-16.875) |...
    (WT_preORI_ipsi_only<(180) & WT_preORI_ipsi_only>(180-16.875)) |...
    (WT_preORI_ipsi_only>(0) & WT_preORI_ipsi_only<(16.875)))));

WT_post_ipsiprop=length(find((WT_postORI_ipsi_only<(90+16.875) & WT_postORI_ipsi_only>(90-16.875) |...
    (WT_postORI_ipsi_only<(180) & WT_postORI_ipsi_only>(180-16.875)) |...
    (WT_postORI_ipsi_only>(0) & WT_postORI_ipsi_only<(16.875)))));

%binoc-contra
WT_pre_contraprop_binoc=length(find((WT_preORI_contra<(90+16.875) & WT_preORI_contra>(90-16.875) |...
    (WT_preORI_contra<(180) & WT_preORI_contra>(180-16.875)) |...
    (WT_preORI_contra>(0) & WT_preORI_contra<(16.875)))));

WT_post_contraprop_binoc=length(find((WT_postORI_contra<(90+16.875) & WT_postORI_contra>(90-16.875) |...
    (WT_postORI_contra<(180) & WT_postORI_contra>(180-16.875)) |...
    (WT_postORI_contra>(0) & WT_postORI_contra<(16.875)))));

%binoc-ipsi 
WT_pre_ipsiprop_binoc=length(find((WT_preORI_ipsi<(90+16.875) & WT_preORI_ipsi>(90-16.875) |...
    (WT_preORI_ipsi<(180) & WT_preORI_ipsi>(180-16.875)) |...
    (WT_preORI_ipsi>(0) & WT_preORI_ipsi<(16.875)))));

WT_post_ipsiprop_binoc=length(find((WT_postORI_ipsi<(90+16.875) & WT_postORI_ipsi>(90-16.875) |...
    (WT_postORI_ipsi<(180) & WT_postORI_ipsi>(180-16.875)) |...
    (WT_postORI_ipsi>(0) & WT_postORI_ipsi<(16.875)))));

%binoc 
WT_pre_prop_binoc=mean(WT_pre_contraprop_binoc,WT_pre_ipsiprop_binoc);
WT_post_prop_binoc=mean(WT_post_contraprop_binoc,WT_post_ipsiprop_binoc);

% KO

%contralateral  
KO_pre_contraprop=length(find((KO_preORI_contra_only<(90+16.875) & KO_preORI_contra_only>(90-16.875) |...
    (KO_preORI_contra_only<(180) & KO_preORI_contra_only>(180-16.875)) |...
    (KO_preORI_contra_only>(0) & KO_preORI_contra_only<(16.875)))));

KO_post_contraprop=length(find((KO_postORI_contra_only<(90+16.875) & KO_postORI_contra_only>(90-16.875) |...
    (KO_postORI_contra_only<(180) & KO_postORI_contra_only>(180-16.875)) |...
    (KO_postORI_contra_only>(0) & KO_postORI_contra_only<(16.875)))));

%ipsilateral  
KO_pre_ipsiprop=length(find((KO_preORI_ipsi_only<(90+16.875) & KO_preORI_ipsi_only>(90-16.875) |...
    (KO_preORI_ipsi_only<(180) & KO_preORI_ipsi_only>(180-16.875)) |...
    (KO_preORI_ipsi_only>(0) & KO_preORI_ipsi_only<(16.875)))));

KO_post_ipsiprop=length(find((KO_postORI_ipsi_only<(90+16.875) & KO_postORI_ipsi_only>(90-16.875) |...
    (KO_postORI_ipsi_only<(180) & KO_postORI_ipsi_only>(180-16.875)) |...
    (KO_postORI_ipsi_only>(0) & KO_postORI_ipsi_only<(16.875)))));

%binoc-contra
KO_pre_contraprop_binoc=length(find((KO_preORI_contra<(90+16.875) & KO_preORI_contra>(90-16.875) |...
    (KO_preORI_contra<(180) & KO_preORI_contra>(180-16.875)) |...
    (KO_preORI_contra>(0) & KO_preORI_contra<(16.875)))));

KO_post_contraprop_binoc=length(find((KO_postORI_contra<(90+16.875) & KO_postORI_contra>(90-16.875) |...
    (KO_postORI_contra<(180) & KO_postORI_contra>(180-16.875)) |...
    (KO_postORI_contra>(0) & KO_postORI_contra<(16.875)))));

%binoc-ipsi 
KO_pre_ipsiprop_binoc=length(find((KO_preORI_ipsi<(90+16.875) & KO_preORI_ipsi>(90-16.875) |...
    (KO_preORI_ipsi<(180) & KO_preORI_ipsi>(180-16.875)) |...
    (KO_preORI_ipsi>(0) & KO_preORI_ipsi<(16.875)))));

KO_post_ipsiprop_binoc=length(find((KO_postORI_ipsi<(90+16.875) & KO_postORI_ipsi>(90-16.875) |...
    (KO_postORI_ipsi<(180) & KO_postORI_ipsi>(180-16.875)) |...
    (KO_postORI_ipsi>(0) & KO_postORI_ipsi<(16.875)))));

%binoc 
KO_pre_prop_binoc=mean(KO_pre_contraprop_binoc,KO_pre_ipsiprop_binoc);
KO_post_prop_binoc=mean(KO_post_contraprop_binoc,KO_post_ipsiprop_binoc);

%make some plots 

%WT 
props=figure(33); 
props.Position=[2024 380 700 300];
t=tiledlayout(1,2);

t.TileSpacing = 'compact';
t.Padding = 'compact';

x=categorical(["pre", "post"]); 
x=reordercats(x,cellstr(x));

t_wt=nexttile; 
plot(x, [WT_pre_contraprop/length(WT_preORI_contra_only); WT_post_contraprop/length(WT_preORI_contra_only)],...
    'Marker','o','Color', [.1540 .5902 .9218], 'LineWidth',2);
hold on
plot(x, [WT_pre_ipsiprop/length(WT_preORI_ipsi_only); WT_post_ipsiprop/length(WT_preORI_ipsi_only)],...
    'Marker','o','Color', [.5044 .7993 0.3480], 'LineWidth',2);
hold on 
plot(x, [WT_pre_prop_binoc/length(WT_preORI_contra); WT_post_prop_binoc/length(WT_postORI_contra)],...
    'Marker','o','Color', [.9769 .9839 0.0805], 'LineWidth',2);
hold off 
box off 
ylim([0 1]);
set(gca,'TickDir','out'); 
title(t_wt, 'WT')

%KO
t_ko=nexttile; 
plot(x, [KO_pre_contraprop/length(KO_preORI_contra_only); KO_post_contraprop/length(KO_preORI_contra_only)],...
    'Marker','o','Color', [.1540 .5902 .9218], 'LineWidth',2);
hold on
plot(x, [KO_pre_ipsiprop/length(KO_preORI_ipsi_only); KO_post_ipsiprop/length(KO_preORI_ipsi_only)],...
    'Marker','o','Color', [.5044 .7993 0.3480], 'LineWidth',2);
hold on 
plot(x, [KO_pre_prop_binoc/length(KO_preORI_contra); KO_post_prop_binoc/length(KO_postORI_contra)],...
    'Marker','o','Color', [.9769 .9839 0.0805], 'LineWidth',2);
hold off 
box off 
ylim([0 1]);
set(gca,'TickDir','out'); 
title(t_ko,'KO')
legend('Contra','Ipsi','Binoc','Location','northwest')

saveas(props, fullfile(SaveDir, 'CardinalProportions'), 'pdf');
saveas(props, fullfile(SaveDir, 'CardinalProportions'), 'tif');
saveas(props, fullfile(SaveDir, 'CardinalProportions'), 'fig');

%WT vs KO
propsWTvsKO=figure(34); 
propsWTvsKO.Position=[2024 380 700 300];
t90=tiledlayout(1,3);
t90.TileSpacing = 'compact';
t90.Padding = 'compact';

%contra
contra=nexttile;
plot(x, [WT_pre_contraprop/length(WT_preORI_contra_only); WT_post_contraprop/length(WT_preORI_contra_only)],...
    'Marker','o','Color', [0.3 0.3 0.3], 'LineWidth',2);
hold on
plot(x, [KO_pre_contraprop/length(KO_preORI_contra_only); KO_post_contraprop/length(KO_preORI_contra_only)],...
    'Marker','o','Color', [.8 0 1], 'LineWidth',2);
hold off 
box off 
ylim([0 1]);
set(gca,'TickDir','out'); 
title(contra, 'Contra')


%ipsi
ipsi=nexttile;
plot(x, [WT_pre_ipsiprop/length(WT_preORI_ipsi_only); WT_post_ipsiprop/length(WT_preORI_ipsi_only)],...
    'Marker','o','Color', [0.3 0.3 0.3], 'LineWidth',2);
hold on
plot(x, [KO_pre_ipsiprop/length(KO_preORI_ipsi_only); KO_post_ipsiprop/length(KO_preORI_ipsi_only)],...
    'Marker','o','Color', [.8 0 1], 'LineWidth',2);
hold off 
box off 
ylim([0 1]);
set(gca,'TickDir','out'); 
title(ipsi, 'Ipsi')


%binoc
binoc=nexttile;
plot(x, [WT_pre_prop_binoc/length(WT_preORI_contra); WT_post_prop_binoc/length(WT_postORI_contra)],...
    'Marker','o','Color', [0.3 0.3 0.3], 'LineWidth',2);
hold on
plot(x, [KO_pre_prop_binoc/length(KO_preORI_contra); KO_post_prop_binoc/length(KO_postORI_contra)],...
    'Marker','o','Color', [.8 0 1], 'LineWidth',2);
hold off 
box off 
ylim([0 1]);
set(gca,'TickDir','out'); 
title(binoc, 'Binoc')
legend('WT','KO')

saveas(propsWTvsKO, fullfile(SaveDir, 'propsWTvsKO-CardinalProportions'), 'pdf');
saveas(propsWTvsKO, fullfile(SaveDir, 'propsWTvsKO-CardinalProportions'), 'tif');
saveas(propsWTvsKO, fullfile(SaveDir, 'propsWTvsKO-CardinalProportions'), 'fig');

writematrix(WT_preORI_contra_only, fullfile(SaveDir, 'WT_preORI_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_postORI_contra_only, fullfile(SaveDir, 'WT_postORI_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_preORI_ipsi_only, fullfile(SaveDir, 'WT_preORI_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_postORI_ipsi_only, fullfile(SaveDir, 'WT_postORI_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(KO_preORI_contra_only, fullfile(SaveDir, 'KO_preORI_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_postORI_contra_only, fullfile(SaveDir, 'KO_postORI_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_preORI_ipsi_only, fullfile(SaveDir, 'KO_preORI_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_postORI_ipsi_only, fullfile(SaveDir, 'KO_postORI_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(WT_preORI_contra, fullfile(SaveDir, 'WT_preORI_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_postORI_contra, fullfile(SaveDir, 'WT_postORI_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_preORI_ipsi, fullfile(SaveDir, 'WT_preORI_bin_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(WT_postORI_ipsi, fullfile(SaveDir, 'WT_postORI_bin_ipsi.xls'),'WriteMode','overwritesheet'); 

writematrix(KO_preORI_contra, fullfile(SaveDir, 'KO_preORI_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_postORI_contra, fullfile(SaveDir, 'KO_postORI_bin_contra.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_preORI_ipsi, fullfile(SaveDir, 'KO_preORI_bin_ipsi.xls'),'WriteMode','overwritesheet'); 
writematrix(KO_postORI_ipsi, fullfile(SaveDir, 'KO_postORI_bin_ipsi.xls'),'WriteMode','overwritesheet'); 



%% Chi-square tests of cardinal proportions 

%CONTRALATERAL RESPONSES -WT pre vs post 
p0_WTcontra=(WT_pre_contraprop+WT_post_contraprop)/(length(WT_preORI_contra_only)+length(WT_postORI_contra_only));
WT_contrapre_exp=length(WT_preORI_contra_only)*p0_WTcontra; 
WT_contrapost_exp=length(WT_postORI_contra_only)*p0_WTcontra;

observed_WTcontra=[WT_pre_contraprop length(WT_preORI_contra_only)-WT_pre_contraprop WT_post_contraprop length(WT_postORI_contra_only)-WT_post_contraprop]; 
expected_WTcontra=[WT_contrapre_exp length(WT_preORI_contra_only)-WT_contrapre_exp WT_contrapost_exp length(WT_postORI_contra_only)-WT_contrapost_exp]; 

chi2stat_WTcontra=sum((observed_WTcontra-expected_WTcontra).^2 ./expected_WTcontra); 
p_WTcontra = 1 - chi2cdf(chi2stat_WTcontra,1);

%CONTRALATERAL RESPONSES -KO pre vs post 
p0_KOcontra=(KO_pre_contraprop+KO_post_contraprop)/(length(KO_preORI_contra_only)+length(KO_postORI_contra_only));
KO_contrapre_exp=length(KO_preORI_contra_only)*p0_KOcontra; 
KO_contrapost_exp=length(KO_postORI_contra_only)*p0_KOcontra;

observed_KOcontra=[KO_pre_contraprop length(KO_preORI_contra_only)-KO_pre_contraprop KO_post_contraprop length(KO_postORI_contra_only)-KO_post_contraprop]; 
expected_KOcontra=[KO_contrapre_exp length(KO_preORI_contra_only)-KO_contrapre_exp KO_contrapost_exp length(KO_postORI_contra_only)-KO_contrapost_exp]; 

chi2stat_KOcontra=sum((observed_KOcontra-expected_KOcontra).^2 ./expected_KOcontra); 
p_KOcontra = 1 - chi2cdf(chi2stat_KOcontra,1);

%IPSILATERAL RESPONSES -WT pre vs post 
p0_WTipsi=(WT_pre_ipsiprop+WT_post_ipsiprop)/(length(WT_preORI_ipsi_only)+length(WT_postORI_ipsi_only));
WT_ipsipre_exp=length(WT_preORI_ipsi_only)*p0_WTipsi; 
WT_ipsipost_exp=length(WT_postORI_ipsi_only)*p0_WTipsi;

observed_WTipsi=[WT_pre_ipsiprop length(WT_preORI_ipsi_only)-WT_pre_ipsiprop WT_post_ipsiprop length(WT_postORI_ipsi_only)-WT_post_ipsiprop]; 
expected_WTipsi=[WT_ipsipre_exp length(WT_preORI_ipsi_only)-WT_ipsipre_exp WT_ipsipost_exp length(WT_postORI_ipsi_only)-WT_ipsipost_exp]; 

chi2stat_WTipsi=sum((observed_WTipsi-expected_WTipsi).^2 ./expected_WTipsi); 
p_WTipsi = 1 - chi2cdf(chi2stat_WTipsi,1);

%IPSILATERAL RESPONSES -KO pre vs post 
p0_KOipsi=(KO_pre_ipsiprop+KO_post_ipsiprop)/(length(KO_preORI_ipsi_only)+length(KO_postORI_ipsi_only));
KO_ipsipre_exp=length(KO_preORI_ipsi_only)*p0_KOipsi; 
KO_ipsipost_exp=length(KO_postORI_ipsi_only)*p0_KOipsi;

observed_KOipsi=[KO_pre_ipsiprop length(KO_preORI_ipsi_only)-KO_pre_ipsiprop KO_post_ipsiprop length(KO_postORI_ipsi_only)-KO_post_ipsiprop]; 
expected_KOipsi=[KO_ipsipre_exp length(KO_preORI_ipsi_only)-KO_ipsipre_exp KO_ipsipost_exp length(KO_postORI_ipsi_only)-KO_ipsipost_exp]; 

chi2stat_KOipsi=sum((observed_KOipsi-expected_KOipsi).^2 ./expected_KOipsi); 
p_KOipsi = 1 - chi2cdf(chi2stat_KOipsi,1);

%BINOCULAR RESPONSES -WT pre vs post 
p0_WTbinoc=(WT_pre_prop_binoc+WT_post_prop_binoc)/(length(WT_preORI_contra)+length(WT_postORI_contra));
WT_binocpre_exp=length(WT_preORI_contra)*p0_WTbinoc; 
WT_binocpost_exp=length(WT_preORI_contra)*p0_WTbinoc;

observed_WTbinoc=[WT_pre_prop_binoc length(WT_preORI_contra)-WT_pre_prop_binoc WT_post_prop_binoc length(WT_postORI_contra)-WT_post_prop_binoc]; 
expected_WTbinoc=[WT_binocpre_exp length(WT_preORI_contra)-WT_binocpre_exp WT_binocpost_exp length(WT_postORI_contra)-WT_binocpost_exp]; 

chi2stat_WTbinoc=sum((observed_WTbinoc-expected_WTbinoc).^2 ./expected_WTbinoc); 
p_WTbinoc = 1 - chi2cdf(chi2stat_WTbinoc,1);

%BINOCULAR RESPONSES -KO pre vs post 
p0_KObinoc=(KO_pre_prop_binoc+KO_post_prop_binoc)/(length(KO_preORI_contra)+length(KO_postORI_contra));
KO_binocpre_exp=length(KO_preORI_contra)*p0_KObinoc; 
KO_binocpost_exp=length(KO_preORI_contra)*p0_KObinoc;

observed_KObinoc=[KO_pre_prop_binoc length(KO_preORI_contra)-KO_pre_prop_binoc KO_post_prop_binoc length(KO_postORI_contra)-KO_post_prop_binoc]; 
expected_KObinoc=[KO_binocpre_exp length(KO_preORI_contra)-KO_binocpre_exp KO_binocpost_exp length(KO_postORI_contra)-KO_binocpost_exp]; 

chi2stat_KObinoc=sum((observed_KObinoc-expected_KObinoc).^2 ./expected_KObinoc); 
p_KObinoc = 1 - chi2cdf(chi2stat_KObinoc,1);

%% 
%CONTRALATERAL RESPONSES - PRE- WT vs KO 
p0_precontra=(WT_pre_contraprop+KO_pre_contraprop)/(length(WT_preORI_contra_only)+length(KO_preORI_contra_only));
WT_contrapre_exp=length(WT_preORI_contra_only)*p0_precontra; 
KO_contrapre_exp=length(KO_preORI_contra_only)*p0_precontra;

observed_precontra=[WT_pre_contraprop length(WT_preORI_contra_only)-WT_pre_contraprop KO_pre_contraprop length(KO_preORI_contra_only)-KO_pre_contraprop]; 
expected_precontra=[WT_contrapre_exp length(WT_preORI_contra_only)-WT_contrapre_exp KO_contrapre_exp length(KO_preORI_contra_only)-KO_contrapre_exp]; 

chi2stat_precontra=sum((observed_precontra-expected_precontra).^2 ./expected_precontra); 
p_precontra = 1 - chi2cdf(chi2stat_precontra,1);

%CONTRALATERAL RESPONSES - POST- WT vs KO 
p0_postcontra=(WT_post_contraprop+KO_post_contraprop)/(length(WT_postORI_contra_only)+length(KO_postORI_contra_only));
WT_contrapost_exp=length(WT_postORI_contra_only)*p0_postcontra; 
KO_contrapost_exp=length(KO_postORI_contra_only)*p0_postcontra;

observed_postcontra=[WT_post_contraprop length(WT_postORI_contra_only)-WT_post_contraprop KO_post_contraprop length(KO_postORI_contra_only)-KO_post_contraprop]; 
expected_postcontra=[WT_contrapost_exp length(WT_postORI_contra_only)-WT_contrapost_exp KO_contrapost_exp length(KO_postORI_contra_only)-KO_contrapost_exp]; 

chi2stat_postcontra=sum((observed_postcontra-expected_postcontra).^2 ./expected_postcontra); 
p_postcontra = 1 - chi2cdf(chi2stat_postcontra,1);

%IPSILATERAL RESPONSES - PRE- WT vs KO 
p0_preipsi=(WT_pre_ipsiprop+KO_pre_ipsiprop)/(length(WT_preORI_ipsi_only)+length(KO_preORI_ipsi_only));
WT_ipsipre_exp=length(WT_preORI_ipsi_only)*p0_preipsi; 
KO_ipsipre_exp=length(KO_preORI_ipsi_only)*p0_preipsi;

observed_preipsi=[WT_pre_ipsiprop length(WT_preORI_ipsi_only)-WT_pre_ipsiprop KO_pre_ipsiprop length(KO_preORI_ipsi_only)-KO_pre_ipsiprop]; 
expected_preipsi=[WT_ipsipre_exp length(WT_preORI_ipsi_only)-WT_ipsipre_exp KO_ipsipre_exp length(KO_preORI_ipsi_only)-KO_ipsipre_exp]; 

chi2stat_preipsi=sum((observed_preipsi-expected_preipsi).^2 ./expected_preipsi); 
p_preipsi = 1 - chi2cdf(chi2stat_preipsi,1);

%IPSILATERAL RESPONSES - POST- WT vs KO 
p0_postipsi=(WT_post_ipsiprop+KO_post_ipsiprop)/(length(WT_postORI_ipsi_only)+length(KO_postORI_ipsi_only));
WT_ipsipost_exp=length(WT_postORI_ipsi_only)*p0_postipsi; 
KO_ipsipost_exp=length(KO_postORI_ipsi_only)*p0_postipsi;

observed_postipsi=[WT_post_ipsiprop length(WT_postORI_ipsi_only)-WT_post_ipsiprop KO_post_ipsiprop length(KO_postORI_ipsi_only)-KO_post_ipsiprop]; 
expected_postipsi=[WT_ipsipost_exp length(WT_postORI_ipsi_only)-WT_ipsipost_exp KO_ipsipost_exp length(KO_postORI_ipsi_only)-KO_ipsipost_exp]; 

chi2stat_postipsi=sum((observed_postipsi-expected_postipsi).^2 ./expected_postipsi); 
p_postipsi = 1 - chi2cdf(chi2stat_postipsi,1);

%BINOCULAR RESPONSES - PRE- WT vs KO 
p0_prebinoc=(WT_pre_prop_binoc+KO_pre_prop_binoc)/(length(WT_preORI_contra)+length(KO_preORI_contra));
WT_binocpre_exp=length(WT_preORI_contra)*p0_prebinoc; 
KO_binocpre_exp=length(KO_preORI_contra)*p0_prebinoc;

observed_prebinoc=[WT_pre_prop_binoc length(KO_preORI_contra)-WT_pre_prop_binoc KO_pre_prop_binoc length(KO_preORI_contra)-KO_pre_prop_binoc]; 
expected_prebinoc=[WT_binocpre_exp length(KO_preORI_contra)-WT_binocpre_exp KO_binocpre_exp length(KO_preORI_contra)-KO_binocpre_exp]; 

chi2stat_prebinoc=sum((observed_prebinoc-expected_prebinoc).^2 ./expected_prebinoc); 
p_prebinoc = 1 - chi2cdf(chi2stat_prebinoc,1);

%BINOCLATERAL RESPONSES - POST- WT vs KO 
p0_postbinoc=(WT_post_prop_binoc+KO_post_prop_binoc)/(length(KO_postORI_contra)+length(WT_postORI_contra));
WT_binocpost_exp=length(WT_postORI_contra)*p0_postbinoc; 
KO_binocpost_exp=length(KO_postORI_contra)*p0_postbinoc;

observed_postbinoc=[WT_post_prop_binoc length(WT_postORI_contra)-WT_post_prop_binoc KO_post_prop_binoc length(KO_postORI_contra)-KO_post_prop_binoc]; 
expected_postbinoc=[WT_binocpost_exp length(WT_postORI_contra)-WT_binocpost_exp KO_binocpost_exp length(KO_postORI_contra)-KO_binocpost_exp]; 

chi2stat_postbinoc=sum((observed_postbinoc-expected_postbinoc).^2 ./expected_postbinoc); 
p_postbinoc = 1 - chi2cdf(chi2stat_postbinoc,1);

%% save chi-square p-values 


%% look at proportion of binocular/ contralateral/ ipsilateral/unresp cells 

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
    WT_unresp_pre_prop(i)=WTDrift_prop_pre(i).cell_count_prop_pre.unresp;
    WT_unresp_post_prop(i)=WTDrift_prop_post(i).cell_count_prop_post.unresp;
end 

%KO mice 
for i=1:length(KODrift_prop_pre)
    KO_binoc_pre_prop(i)= KODrift_prop_pre(i).cell_count_prop_pre.binoc;
   KO_con_pre_prop(i)= KODrift_prop_pre(i).cell_count_prop_pre.con;
    KO_ipsi_pre_prop(i)= KODrift_prop_pre(i).cell_count_prop_pre.ipsi;
   KO_binoc_post_prop(i)= KODrift_prop_post(i).cell_count_prop_post.binoc;
   KO_con_post_prop(i)= KODrift_prop_post(i).cell_count_prop_post.con;
    KO_ipsi_post_prop(i)= KODrift_prop_post(i).cell_count_prop_post.ipsi;
    KO_unresp_pre_prop(i)=KODrift_prop_pre(i).cell_count_prop_pre.unresp;
    KO_unresp_post_prop(i)=KODrift_prop_post(i).cell_count_prop_post.unresp;
end 

%WT, pre 
WT_binoc_pre=sum(WT_binoc_pre_prop); 
WT_con_pre=sum(WT_con_pre_prop); 
WT_ipsi_pre=sum(WT_ipsi_pre_prop); 
WT_unresp_pre=sum(WT_unresp_pre_prop); 

%WT, post 
WT_binoc_post=sum(WT_binoc_post_prop); 
WT_con_post=sum(WT_con_post_prop); 
WT_ipsi_post=sum(WT_ipsi_post_prop); 
WT_unresp_post=sum(WT_unresp_post_prop); 

%KO, pre 
KO_binoc_pre=sum(KO_binoc_pre_prop); 
KO_con_pre=sum(KO_con_pre_prop); 
KO_ipsi_pre=sum(KO_ipsi_pre_prop); 
KO_unresp_pre=sum(KO_unresp_pre_prop); 

%KO, post 
KO_binoc_post=sum(KO_binoc_post_prop); 
KO_con_post=sum(KO_con_post_prop); 
KO_ipsi_post=sum(KO_ipsi_post_prop); 
KO_unresp_post=sum(KO_unresp_post_prop); 

%% make pie chart for cell identities 
WT_pre=[WT_binoc_pre WT_con_pre WT_ipsi_pre WT_unresp_pre];
WT_post=[WT_binoc_post WT_con_post WT_ipsi_post WT_unresp_post]; 
KO_pre=[KO_binoc_pre KO_con_pre KO_ipsi_pre KO_unresp_pre];
KO_post=[KO_binoc_post KO_con_post KO_ipsi_post KO_unresp_post]; 

labels={'Binoc','Con', 'Ipsi', 'Unresp'};
newColors=[...
    0.47, .93, .48;
    .04, .75, .66;
    .25, .2, .58; 
    .5, .5, .5]; %binoc, con, ipsi custom colors for pie slices 


fpie=figure(15); 
tiledlayout(2,2); 

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

%% count of binocular/ contralateral/ ipsilateral/unresp cells not necessarily longitudinally tracked 

% %PRE MD
% %WT mice 
% WTfile_counts_pre=dir(fullfile(AnalDirWTpre,'*_cell_counts_pre.mat')); 
% for i=1:numel(WTfile_counts_pre)
%     WTDrift_counts_pre(i)=load(fullfile(AnalDirWTpre, WTfile_counts_pre(i).name)); 
% end 
% 
% %KO mice 
% KOfile_counts_pre=dir(fullfile(AnalDirKOpre,'*_cell_counts_pre.mat')); 
% for i=1:numel(KOfile_counts_pre)
%     KODrift_counts_pre(i)=load(fullfile(AnalDirKOpre, KOfile_counts_pre(i).name)); 
% end 
% 
% %POST MD
% %WT mice 
% WTfile_counts_post=dir(fullfile(AnalDirWTpost,'*_cell_counts_post.mat')); 
% for i=1:numel(WTfile_counts_post)
%     WTDrift_counts_post(i)=load(fullfile(AnalDirWTpost, WTfile_counts_post(i).name)); 
% end 
% 
% %KO mice 
% KOfile_counts_post=dir(fullfile(AnalDirKOpost,'*_cell_counts_post.mat')); 
% for i=1:numel(KOfile_counts_post)
%     KODrift_counts_post(i)=load(fullfile(AnalDirKOpost, KOfile_counts_post(i).name)); 
% end 
% 
% %WT mice
% for i=1:length(WTDrift_counts_pre)
%     WT_binoc_pre_counts(i)= WTDrift_counts_pre(i).cell_count_counts_pre.binoc;
%    WT_con_pre_counts(i)= WTDrift_counts_pre(i).cell_count_counts_pre.con;
%     WT_ipsi_pre_counts(i)= WTDrift_counts_pre(i).cell_count_counts_pre.ipsi;
%    WT_binoc_post_counts(i)= WTDrift_counts_post(i).cell_count_counts_post.binoc;
%    WT_con_post_counts(i)= WTDrift_counts_post(i).cell_count_counts_post.con;
%     WT_ipsi_post_counts(i)= WTDrift_counts_post(i).cell_count_counts_post.ipsi;
%     WT_unresp_pre_counts(i)=WTDrift_counts_pre(i).cell_count_counts_pre.unresp;
%     WT_unresp_post_counts(i)=WTDrift_counts_post(i).cell_count_counts_post.unresp;
% end 
% 
% %KO mice 
% for i=1:length(KODrift_counts_pre)
%     KO_binoc_pre_counts(i)= KODrift_counts_pre(i).cell_count_counts_pre.binoc;
%    KO_con_pre_counts(i)= KODrift_counts_pre(i).cell_count_counts_pre.con;
%     KO_ipsi_pre_counts(i)= KODrift_counts_pre(i).cell_count_counts_pre.ipsi;
%    KO_binoc_post_counts(i)= KODrift_counts_post(i).cell_count_counts_post.binoc;
%    KO_con_post_counts(i)= KODrift_counts_post(i).cell_count_counts_post.con;
%     KO_ipsi_post_counts(i)= KODrift_counts_post(i).cell_count_counts_post.ipsi;
%     KO_unresp_pre_counts(i)=KODrift_counts_pre(i).cell_count_counts_pre.unresp;
%     KO_unresp_post_counts(i)=KODrift_counts_post(i).cell_count_counts_post.unresp;
% end 
% 
% %WT, pre 
% WT_binoc_pre=sum(WT_binoc_pre_counts); 
% WT_con_pre=sum(WT_con_pre_counts); 
% WT_ipsi_pre=sum(WT_ipsi_pre_counts); 
% WT_unresp_pre=sum(WT_unresp_pre_counts); 
% 
% %WT, post 
% WT_binoc_post=sum(WT_binoc_post_counts); 
% WT_con_post=sum(WT_con_post_counts); 
% WT_ipsi_post=sum(WT_ipsi_post_counts); 
% WT_unresp_post=sum(WT_unresp_post_counts); 
% 
% %KO, pre 
% KO_binoc_pre=sum(KO_binoc_pre_counts); 
% KO_con_pre=sum(KO_con_pre_counts); 
% KO_ipsi_pre=sum(KO_ipsi_pre_counts); 
% KO_unresp_pre=sum(KO_unresp_pre_counts); 
% 
% %KO, post 
% KO_binoc_post=sum(KO_binoc_post_counts); 
% KO_con_post=sum(KO_con_post_counts); 
% KO_ipsi_post=sum(KO_ipsi_post_counts); 
% KO_unresp_post=sum(KO_unresp_post_counts); 



%% pie chart chi square tests 
% 
% %WT pre vs post - CONTRA 
% p0_WTcontra=(WT_con_pre+WT_con_post)/(WT_pre+WT_post);
% WT_pre_contra=WT_pre*p0_WTcontra; 
% WT_post_contra=WT_post*p0_WTcontra;
% 
% observed_WTcontra=[WT_con_pre WT_pre-WT_con_pre WT_con_post WT_post-WT_con_post]; 
% expected_WTcontra=[WT_pre_contra WT_pre-WT_pre_contra WT_post_contra WT_post-WT_post_contra]; 
% 
% chi2stat_WT_contra=sum((observed_WTcontra-expected_WTcontra).^2 ./expected_WTcontra); 
% p_WTcontra_all = 1 - chi2cdf(chi2stat_WT_contra,1);
% 
% %WT pre vs post - IPSI 
% p0_WTipsi=(WT_ipsi_pre+WT_ipsi_post)/(WT_pre+WT_post);
% WT_pre_ipsi=WT_pre*p0_WTipsi; 
% WT_post_ipsi=WT_post*p0_WTipsi;
% 
% observed_WTipsi=[WT_ipsi_pre WT_pre-WT_ipsi_pre WT_ipsi_post WT_post-WT_ipsi_post]; 
% expected_WTipsi=[WT_pre_ipsi WT_pre-WT_pre_ipsi WT_post_ipsi WT_post-WT_post_ipsi]; 
% 
% chi2stat_WT_ipsi=sum((observed_WTipsi-expected_WTipsi).^2 ./expected_WTipsi); 
% p_WTipsi_all = 1 - chi2cdf(chi2stat_WT_ipsi,1);
% 
% %WT pre vs post - BINOC 
% p0_WTbinoc=(WT_binoc_pre+WT_binoc_post)/(WT_pre+WT_post);
% WT_pre_binoc=WT_pre*p0_WTbinoc; 
% WT_post_binoc=WT_post*p0_WTbinoc;
% 
% observed_WTbinoc=[WT_binoc_pre WT_pre-WT_binoc_pre WT_binoc_post WT_post-WT_binoc_post]; 
% expected_WTbinoc=[WT_pre_binoc WT_pre-WT_pre_binoc WT_post_binoc WT_post-WT_post_binoc]; 
% 
% chi2stat_WT_binoc=sum((observed_WTbinoc-expected_WTbinoc).^2 ./expected_WTbinoc); 
% p_WTbinoc_all = 1 - chi2cdf(chi2stat_WT_binoc,1);
% 
% %WT pre vs post - UNRESP 
% p0_WTunresp=(WT_unresp_pre+WT_unresp_post)/(WT_pre+WT_post);
% WT_pre_unresp=WT_pre*p0_WTunresp; 
% WT_post_unresp=WT_post*p0_WTunresp;
% 
% observed_WTunresp=[WT_unresp_pre WT_pre-WT_unresp_pre WT_unresp_post WT_post-WT_unresp_post]; 
% expected_WTunresp=[WT_pre_unresp WT_pre-WT_pre_unresp WT_post_unresp WT_post-WT_post_unresp]; 
% 
% chi2stat_WT_unresp=sum((observed_WTunresp-expected_WTunresp).^2 ./expected_WTunresp); 
% p_WTunresp_all = 1 - chi2cdf(chi2stat_WT_unresp,1);
% 
% 
% %KO pre vs post - CONTRA 
% p0_KOcontra=(KO_con_pre+KO_con_post)/(KO_pre+KO_post);
% KO_pre_contra=KO_pre*p0_KOcontra; 
% KO_post_contra=KO_post*p0_KOcontra;
% 
% observed_KOcontra=[KO_con_pre KO_pre-KO_con_pre KO_con_post KO_post-KO_con_post]; 
% expected_KOcontra=[KO_pre_contra KO_pre-KO_pre_contra KO_post_contra KO_post-KO_post_contra]; 
% 
% chi2stat_KO_contra=sum((observed_KOcontra-expected_KOcontra).^2 ./expected_KOcontra); 
% p_KOcontra_all = 1 - chi2cdf(chi2stat_KO_contra,1);
% 
% %KO pre vs post - IPSI 
% p0_KOipsi=(KO_ipsi_pre+KO_ipsi_post)/(KO_pre+KO_post);
% KO_pre_ipsi=KO_pre*p0_KOipsi; 
% KO_post_ipsi=KO_post*p0_KOipsi;
% 
% observed_KOipsi=[KO_ipsi_pre KO_pre-KO_ipsi_pre KO_ipsi_post KO_post-KO_ipsi_post]; 
% expected_KOipsi=[KO_pre_ipsi KO_pre-KO_pre_ipsi KO_post_ipsi KO_post-KO_post_ipsi]; 
% 
% chi2stat_KO_ipsi=sum((observed_KOipsi-expected_KOipsi).^2 ./expected_KOipsi); 
% p_KOipsi_all = 1 - chi2cdf(chi2stat_KO_ipsi,1);
% 
% %KO pre vs post - BINOC 
% p0_KObinoc=(KO_binoc_pre+KO_binoc_post)/(KO_pre+KO_post);
% KO_pre_binoc=KO_pre*p0_KObinoc; 
% KO_post_binoc=KO_post*p0_KObinoc;
% 
% observed_KObinoc=[KO_binoc_pre KO_pre-KO_binoc_pre KO_binoc_post KO_post-KO_binoc_post]; 
% expected_KObinoc=[KO_pre_binoc KO_pre-KO_pre_binoc KO_post_binoc KO_post-KO_post_binoc]; 
% 
% chi2stat_KO_binoc=sum((observed_KObinoc-expected_KObinoc).^2 ./expected_KObinoc); 
% p_KObinoc_all = 1 - chi2cdf(chi2stat_KO_binoc,1);
% 
% %KO pre vs post - UNRESP 
% p0_KOunresp=(KO_unresp_pre+KO_unresp_post)/(KO_pre+KO_post);
% KO_pre_unresp=KO_pre*p0_KOunresp; 
% KO_post_unresp=KO_post*p0_KOunresp;
% 
% observed_KOunresp=[KO_unresp_pre KO_pre-KO_unresp_pre KO_unresp_post KO_post-KO_unresp_post]; 
% expected_KOunresp=[KO_pre_unresp KO_pre-KO_pre_unresp KO_post_unresp KO_post-KO_post_unresp]; 
% 
% chi2stat_KO_unresp=sum((observed_KOunresp-expected_KOunresp).^2 ./expected_KOunresp); 
% p_KOunresp_all = 1 - chi2cdf(chi2stat_KO_unresp,1);


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

WT_totalcells=WT_C2I+WT_C2C+WT_C2B+WT_C2U+WT_I2C+WT_I2I+WT_I2B+WT_I2U+WT_B2C+...
    WT_B2I+WT_B2B+WT_B2U+WT_U2C+WT_U2I+WT_U2B+WT_U2U; 


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

KO_totalcells=KO_C2I+KO_C2C+KO_C2B+KO_C2U+KO_I2C+KO_I2I+KO_I2B+KO_I2U+KO_B2C+...
    KO_B2I+KO_B2B+KO_B2U+KO_U2C+KO_U2I+KO_U2B+KO_U2U;

% proportion of ipsilateral cells after MD
WT_Iconversion=WT_U2I+WT_C2I+ WT_B2I; 
KO_Iconversion=KO_U2I+KO_C2I+ KO_B2I; 

%proportion of binocular cells 
WT_Bconversion=WT_U2B+WT_C2B+WT_I2B; 
KO_Bconversion=KO_U2B+KO_C2B+ KO_I2B;

%proportion of unresponsive cells 
WT_Uconversion=WT_C2U+ WT_B2U+WT_I2U; 
KO_Uconversion=KO_C2U+ KO_B2U+KO_I2U;


%SAVE 

save(fullfile(SaveDir,'WT_Iconversion.mat'),'WT_Iconversion'); 
save(fullfile(SaveDir,'KO_Iconversion.mat'),'KO_Iconversion'); 

save(fullfile(SaveDir,'WT_Bconversion.mat'),'WT_Bconversion'); 
save(fullfile(SaveDir,'KO_Bconversion.mat'),'KO_Bconversion'); 

save(fullfile(SaveDir,'WT_Uconversion.mat'),'WT_Uconversion'); 
save(fullfile(SaveDir,'KO_Uconversion.mat'),'KO_Uconversion'); 

save(fullfile(SaveDir, 'WT_C2C.mat'),'WT_C2C');
save(fullfile(SaveDir, 'WT_C2I.mat'),'WT_C2I'); 
save(fullfile(SaveDir, 'WT_C2B.mat'),'WT_C2B');
save(fullfile(SaveDir, 'WT_C2U.mat'),'WT_C2U');

save(fullfile(SaveDir, 'WT_I2C.mat'),'WT_I2C'); 
save(fullfile(SaveDir, 'WT_I2I.mat'),'WT_I2I');
save(fullfile(SaveDir, 'WT_I2B.mat'),'WT_I2B');
save(fullfile(SaveDir, 'WT_I2U.mat'),'WT_I2U');

save(fullfile(SaveDir, 'WT_B2C.mat'),'WT_B2C'); 
save(fullfile(SaveDir, 'WT_B2I.mat'),'WT_B2I');
save(fullfile(SaveDir, 'WT_B2B.mat'),'WT_B2B');
save(fullfile(SaveDir, 'WT_B2U.mat'),'WT_B2U');

save(fullfile(SaveDir, 'WT_U2C.mat'),'WT_U2C'); 
save(fullfile(SaveDir, 'WT_U2I.mat'),'WT_U2I');
save(fullfile(SaveDir, 'WT_U2B.mat'),'WT_U2B');
save(fullfile(SaveDir, 'WT_U2U.mat'),'WT_U2U');

save(fullfile(SaveDir, 'KO_C2C.mat'),'KO_C2C');
save(fullfile(SaveDir, 'KO_C2I.mat'),'KO_C2I'); 
save(fullfile(SaveDir, 'KO_C2B.mat'),'KO_C2B');
save(fullfile(SaveDir, 'KO_C2U.mat'),'KO_C2U');

save(fullfile(SaveDir, 'KO_I2C.mat'),'KO_I2C'); 
save(fullfile(SaveDir, 'KO_I2I.mat'),'KO_I2I');
save(fullfile(SaveDir, 'KO_I2B.mat'),'KO_I2B');
save(fullfile(SaveDir, 'KO_I2U.mat'),'KO_I2U');

save(fullfile(SaveDir, 'KO_B2C.mat'),'KO_B2C'); 
save(fullfile(SaveDir, 'KO_B2I.mat'),'KO_B2I');
save(fullfile(SaveDir, 'KO_B2B.mat'),'KO_B2B');
save(fullfile(SaveDir, 'KO_B2U.mat'),'KO_B2U');

save(fullfile(SaveDir, 'KO_U2C.mat'),'KO_U2C'); 
save(fullfile(SaveDir, 'KO_U2I.mat'),'KO_U2I');
save(fullfile(SaveDir, 'KO_U2B.mat'),'KO_U2B');
save(fullfile(SaveDir, 'KO_U2U.mat'),'KO_U2U');



%monocular to binocular
WT_M2B=WT_C2B+WT_I2B; 
KO_M2B=KO_C2B+KO_I2B; 
%stable monocular 
WT_M2M=WT_C2I+WT_C2C; 
KO_M2M=KO_C2I+KO_C2C;

%binocular to monocular 
WT_B2M=WT_B2C+WT_B2I; 
KO_B2M=KO_B2C+KO_B2I; 
%stable binocular  
WT_B2B;
KO_B2B; 

%responsive to ipsilateral
WT_R2I=WT_C2I+WT_B2I; 
KO_R2I=KO_C2I+KO_B2I; 


%responsive to binocular
WT_R2B=WT_C2B+WT_I2B; 
KO_R2B=KO_C2B+KO_I2B; 


%contralateral cell fate
WT_Cfate=WT_C2U+WT_C2I+WT_C2B; 
KO_Cfate=KO_C2U+KO_C2I+KO_C2B; 

%% plot cell id changes 

fig_cellID=figure(16); 
%plot for ipsilateral cells 
%3 categories, B to I/ C to I, U to I, no change 

tiledlayout(1,8)
nexttile
categoriesIPSI=categorical({'U2I', 'B2I', 'C2I'}); 
categoriesIPSI=reordercats(categoriesIPSI, {'U2I', 'B2I', 'C2I'}); 

U2I=[(WT_U2I/WT_Iconversion) (KO_U2I/KO_Iconversion)]; 
B2I=[WT_B2I/WT_Iconversion KO_B2I/KO_Iconversion]; 
C2I=[WT_C2I/WT_Iconversion KO_C2I/KO_Iconversion]; 


y_ipsi=[U2I; B2I; C2I]; 
b1=bar(categoriesIPSI,y_ipsi, 0.9); 
hold on 
b1(1).FaceColor=[0.3 0.3 0.3]; 
b1(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Ipsilateral Neurons')
legend('WT', 'KO'); 
box off; 

%plot for binocular cells 
nexttile
categoriesBINOC=categorical({'U2B', 'I2B', 'C2B'}); 
categoriesBINOC=reordercats(categoriesBINOC, {'U2B', 'I2B', 'C2B'}); 

U2B=[(WT_U2B/WT_Bconversion) KO_U2B/KO_Bconversion];  
I2B=[WT_I2B/WT_Bconversion KO_I2B/KO_Bconversion];
C2B=[WT_C2B/WT_Bconversion KO_C2B/KO_Bconversion]; 

y_binoc=[U2B; I2B; C2B]; 
b2=bar(categoriesBINOC,y_binoc, 0.9); 
hold on 
b2(1).FaceColor=[0.3 0.3 0.3]; 
b2(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Binocular Neurons')
legend('WT', 'KO'); 
box off; 
hold off 

%plot for unresponsive cells 
nexttile
categoriesUNRESP=categorical({'B2U', 'I2U', 'C2U'}); 
categoriesUNRESP=reordercats(categoriesUNRESP, {'B2U', 'I2U', 'C2U'}); 

B2U=[(WT_B2U/WT_Uconversion) (KO_B2U/KO_Uconversion)]; 
I2U=[ WT_I2U/WT_Uconversion KO_I2U/KO_Uconversion];
C2U=[WT_C2U/WT_Uconversion KO_C2U/KO_Uconversion]; 

y_unresp=[B2U; I2U; C2U]; 
b3=bar(categoriesUNRESP,y_unresp, 0.9); 
hold on 
b3(1).FaceColor=[0.3 0.3 0.3]; 
b3(2).FaceColor=[.8 0 1]; 
ylim([0 1]); 
set(gca,'TickDir','out');
title('Unresponsive Neurons')
legend('WT', 'KO'); 
box off; 
hold off 

%plot for gain of binocular cells  
nexttile 
categoriesBINchange=categorical({'M2B','B2M','stable B'}); 
categoriesBINchange=reordercats(categoriesBINchange,{'M2B','B2M','stable B'}); 

WT_binchange=[WT_M2B/(WT_B2B+WT_M2B+WT_B2M) WT_B2M/(WT_B2B+WT_B2M+WT_M2B) WT_B2B/(WT_B2B+WT_B2M+WT_M2B)]; 
KO_binchange=[KO_M2B/(KO_B2B+KO_M2B+KO_B2M) KO_B2M/(KO_B2B+KO_B2M+KO_M2B) KO_B2B/(KO_B2B+KO_B2M+KO_M2B)];
y_binchange=[WT_binchange; KO_binchange]; 
b4=bar(categoriesBINchange,y_binchange, 0.9); 
hold on 
b4(1).FaceColor=[0.3 0.3 0.3]; 
b4(2).FaceColor=[.8 0 1]; 
ylim([0 1]); 
set(gca,'TickDir','out');
title('Turnover in binocular neurons')
legend('WT', 'KO'); 
box off; 
hold off 

%ipsilateral conversion 
nexttile
categoriesIPSI_2=categorical({'U2I', 'R2I'}); 
categoriesIPSI_2=reordercats(categoriesIPSI_2, {'U2I', 'R2I'}); 

U2I_ipsi_2=[(WT_U2I/WT_Iconversion) KO_U2I/KO_Iconversion]; 
R2I_ipsi_2=[(WT_R2I/WT_Iconversion) KO_R2I/KO_Iconversion]; 

y_ipsi_2=[U2I_ipsi_2; R2I_ipsi_2]; 
b1=bar(categoriesIPSI_2,y_ipsi_2, 0.9); 
hold on 
b1(1).FaceColor=[0.3 0.3 0.3]; 
b1(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Ipsilateral Neurons')
legend('WT', 'KO'); 
box off; 

%binoc conversion 
nexttile
categoriesbinoc_2=categorical({'U2B', 'R2B'}); 
categoriesbinoc_2=reordercats(categoriesbinoc_2, {'U2B', 'R2B'}); 

U2B=[(WT_U2B/WT_Bconversion) KO_U2B/KO_Bconversion]; 
R2B=[(WT_R2B/WT_Bconversion) KO_R2B/KO_Bconversion]; 

y_B_2=[U2B; R2B]; 
b1NEWBINC=bar(categoriesbinoc_2,y_B_2, 0.9); 
hold on 
b1NEWBINC(1).FaceColor=[0.3 0.3 0.3]; 
b1NEWBINC(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Binocular Neurons')
legend('WT', 'KO'); 
box off; 


%contralateral cells fate 
nexttile
categoriesCONTRA_2=categorical({'C2I', 'C2B', 'C2U',}); 
categoriesCONTRA_2=reordercats(categoriesCONTRA_2, {'C2I', 'C2B', 'C2U'}); 

C2I=[WT_C2I/WT_Cfate KO_C2I/KO_Cfate]; 
C2B=[WT_C2B/WT_Cfate KO_C2B/KO_Cfate]; 
C2U=[WT_C2U/WT_Cfate KO_C2U/KO_Cfate]; 

y_contra_2=[C2I; C2B; C2U]; 
b1=bar(categoriesCONTRA_2,y_contra_2, 0.9); 
hold on 
b1(1).FaceColor=[0.3 0.3 0.3]; 
b1(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Contralateral Neuron Fate')
legend('WT', 'KO'); 
box off; 

% %plot loss of binocular cells 
% nexttile 
% categoriesBINloss=categorical({'B2M'}); 
% 
% WT_binlost=[WT_B2M/(WT_B2B+WT_B2M)]; %fraction gained
% KO_binlost=[KO_B2M/(KO_B2B+KO_B2M)];
% y_binlost=[WT_binlost; KO_binlost]; 
% b5=bar(categoriesBINloss,y_binlost, 0.9); 
% hold on 
% b5(1).FaceColor=[0.3 0.3 0.3]; 
% b5(2).FaceColor=[.8 0 1]; 
% ylim([0 1]); 
% set(gca,'TickDir','out');
% title('Loss of binocular neurons')
% legend('WT', 'KO'); 
% box off; 
% hold off 


saveas(fig_cellID, fullfile(SaveDir,'CellConversionWTvsKO'),'pdf'); 
saveas(fig_cellID, fullfile(SaveDir,'CellConversionWTvsKO'),'tif');
saveas(fig_cellID, fullfile(SaveDir,'CellConversionWTvsKO'),'fig');

%% statistical test for proportions 
%chi-square test 

%------IPSILATERAL-----
%U2I
p0_U2I=(WT_U2I+KO_U2I)/(WT_Iconversion+KO_Iconversion);
WT_U2I_exp=WT_Iconversion*p0_U2I; 
KO_U2I_exp=KO_Iconversion*p0_U2I;

observed_U2I=[WT_U2I WT_Iconversion-WT_U2I KO_U2I KO_Iconversion-KO_U2I]; 
expected_U2I=[WT_U2I_exp WT_Iconversion-WT_U2I_exp KO_U2I_exp KO_Iconversion-KO_U2I_exp]; 

chi2stat_U2I=sum((observed_U2I-expected_U2I).^2 ./expected_U2I); 
p_U2I = 1 - chi2cdf(chi2stat_U2I,1);

%B2I
p0_Iconv_B2I=(WT_B2I+KO_B2I)/(WT_Iconversion+KO_Iconversion);
WT_B2I_exp=WT_Iconversion*p0_Iconv_B2I; 
KO_B2I_exp=KO_Iconversion*p0_Iconv_B2I;

observed_B2I=[WT_B2I WT_Iconversion-WT_B2I KO_B2I KO_Iconversion-KO_B2I]; 
expected_B2I=[WT_B2I_exp WT_Iconversion-WT_B2I_exp KO_B2I_exp KO_Iconversion-KO_B2I_exp]; 

chi2stat_B2I=sum((observed_B2I-expected_B2I).^2 ./expected_B2I); 
p_B2I = 1 - chi2cdf(chi2stat_B2I,1);

%C2I
p0_C2I=(WT_C2I+KO_C2I)/(WT_Iconversion+KO_Iconversion);
WT_C2I_exp=WT_Iconversion*p0_C2I; 
KO_C2I_exp=KO_Iconversion*p0_C2I;

observed_C2I=[WT_C2I WT_Iconversion-WT_C2I KO_C2I KO_Iconversion-KO_C2I]; 
expected_C2I=[WT_C2I_exp WT_Iconversion-WT_C2I_exp KO_C2I_exp KO_Iconversion-KO_C2I_exp]; 

chi2stat_C2I=sum((observed_C2I-expected_C2I).^2 ./expected_C2I); 
p_C2I = 1 - chi2cdf(chi2stat_C2I,1);

%WT-U2I vs B2I
p0_WT_U2IvsB2I=(WT_U2I+WT_B2I)/(WT_Iconversion+WT_Iconversion);
WT_U2I_exp=WT_Iconversion*p0_WT_U2IvsB2I; 
WT_B2I_exp=WT_Iconversion*p0_WT_U2IvsB2I;

observed_WT_U2IvsB2I=[WT_U2I WT_Iconversion-WT_U2I WT_B2I WT_Iconversion-WT_B2I]; 
expected_WT_U2IvsB2I=[WT_U2I_exp WT_Iconversion-WT_U2I_exp WT_B2I_exp KO_Iconversion-WT_B2I_exp]; 

chi2stat_WT_U2IvsB2I=sum((observed_WT_U2IvsB2I-expected_WT_U2IvsB2I).^2 ./expected_WT_U2IvsB2I); 
p_WT_U2IvsB2I = 1 - chi2cdf(chi2stat_WT_U2IvsB2I,1);

%WT-C2I vs B2I
p0_WT_C2IvsB2I=(WT_C2I+WT_B2I)/(WT_Iconversion+WT_Iconversion);
WT_C2I_exp=WT_Iconversion*p0_WT_C2IvsB2I; 
WT_B2I_exp=WT_Iconversion*p0_WT_C2IvsB2I;

observed_WT_C2IvsB2I=[WT_C2I WT_Iconversion-WT_C2I WT_B2I WT_Iconversion-WT_B2I]; 
expected_WT_C2IvsB2I=[WT_C2I_exp WT_Iconversion-WT_C2I_exp WT_B2I_exp KO_Iconversion-WT_B2I_exp]; 

chi2stat_WT_C2IvsB2I=sum((observed_WT_C2IvsB2I-expected_WT_C2IvsB2I).^2 ./expected_WT_C2IvsB2I); 
p_WT_C2IvsB2I = 1 - chi2cdf(chi2stat_WT_C2IvsB2I,1);

%WT-C2I vs U2I
p0_WT_C2IvsU2I=(WT_C2I+WT_U2I)/(WT_Iconversion+WT_Iconversion);
WT_C2I_exp=WT_Iconversion*p0_WT_C2IvsU2I; 
WT_U2I_exp=WT_Iconversion*p0_WT_C2IvsU2I;

observed_WT_C2IvsU2I=[WT_C2I WT_Iconversion-WT_C2I WT_U2I WT_Iconversion-WT_U2I]; 
expected_WT_C2IvsU2I=[WT_C2I_exp WT_Iconversion-WT_C2I_exp WT_U2I_exp KO_Iconversion-WT_U2I_exp]; 

chi2stat_WT_C2IvsU2I=sum((observed_WT_C2IvsU2I-expected_WT_C2IvsU2I).^2 ./expected_WT_C2IvsU2I); 
p_WT_C2IvsU2I = 1 - chi2cdf(chi2stat_WT_C2IvsU2I,1);

%KO-U2I vs B2I
p0_KO_U2IvsB2I=(KO_U2I+KO_B2I)/(KO_Iconversion+KO_Iconversion);
KO_U2I_exp=KO_Iconversion*p0_KO_U2IvsB2I; 
KO_B2I_exp=KO_Iconversion*p0_KO_U2IvsB2I;

observed_KO_U2IvsB2I=[KO_U2I KO_Iconversion-KO_U2I KO_B2I KO_Iconversion-KO_B2I]; 
expected_KO_U2IvsB2I=[KO_U2I_exp KO_Iconversion-KO_U2I_exp KO_B2I_exp KO_Iconversion-KO_B2I_exp]; 

chi2stat_KO_U2IvsB2I=sum((observed_KO_U2IvsB2I-expected_KO_U2IvsB2I).^2 ./expected_KO_U2IvsB2I); 
p_KO_U2IvsB2I = 1 - chi2cdf(chi2stat_KO_U2IvsB2I,1);

%KO-C2I vs B2I
p0_KO_C2IvsB2I=(KO_C2I+KO_B2I)/(KO_Iconversion+KO_Iconversion);
KO_C2I_exp=KO_Iconversion*p0_KO_C2IvsB2I; 
KO_B2I_exp=KO_Iconversion*p0_KO_C2IvsB2I;

observed_KO_C2IvsB2I=[KO_C2I KO_Iconversion-KO_C2I KO_B2I KO_Iconversion-KO_B2I]; 
expected_KO_C2IvsB2I=[KO_C2I_exp KO_Iconversion-KO_C2I_exp KO_B2I_exp KO_Iconversion-KO_B2I_exp]; 

chi2stat_KO_C2IvsB2I=sum((observed_KO_C2IvsB2I-expected_KO_C2IvsB2I).^2 ./expected_KO_C2IvsB2I); 
p_KO_C2IvsB2I = 1 - chi2cdf(chi2stat_KO_C2IvsB2I,1);

%KO-C2I vs U2I
p0_KO_C2IvsU2I=(KO_C2I+KO_U2I)/(KO_Iconversion+KO_Iconversion);
KO_C2I_exp=KO_Iconversion*p0_KO_C2IvsU2I; 
KO_U2I_exp=KO_Iconversion*p0_KO_C2IvsU2I;

observed_KO_C2IvsU2I=[KO_C2I KO_Iconversion-KO_C2I KO_U2I KO_Iconversion-KO_U2I]; 
expected_KO_C2IvsU2I=[KO_C2I_exp KO_Iconversion-KO_C2I_exp KO_U2I_exp KO_Iconversion-KO_U2I_exp]; 

chi2stat_KO_C2IvsU2I=sum((observed_KO_C2IvsU2I-expected_KO_C2IvsU2I).^2 ./expected_KO_C2IvsU2I); 
p_KO_C2IvsU2I = 1 - chi2cdf(chi2stat_KO_C2IvsU2I,1);

% resp total to ipsi
p0_R2I=(WT_R2I+KO_R2I)/(WT_Iconversion+KO_Iconversion);
WT_R2I_exp=WT_Iconversion*p0_R2I; 
KO_R2I_exp=KO_Iconversion*p0_R2I;

observed_R2I=[WT_R2I WT_Iconversion-WT_R2I KO_R2I KO_Iconversion-KO_R2I]; 
expected_R2I=[WT_R2I_exp WT_Iconversion-WT_R2I_exp KO_R2I_exp KO_Iconversion-KO_R2I_exp]; 

chi2stat_R2I=sum((observed_R2I-expected_R2I).^2 ./expected_R2I); 
p_R2I = 1 - chi2cdf(chi2stat_R2I,1);


%WT- U2I vs R2I
p0_2I_WT=(WT_U2I+WT_R2I)/(WT_Iconversion+WT_Iconversion);
WT_R2I_exp_2=WT_Iconversion*p0_2I_WT; 
WT_U2I_exp_2=WT_Iconversion*p0_2I_WT;

observed_2I_WT=[WT_R2I WT_Iconversion-WT_R2I WT_U2I KO_Iconversion-WT_I2I]; 
expected_2I_WT=[WT_R2I_exp_2 WT_Iconversion-WT_R2I_exp_2 WT_U2I_exp_2 KO_Iconversion-WT_U2I_exp_2]; 

chi2stat_2I_WT=sum((observed_2I_WT-expected_2I_WT).^2 ./expected_2I_WT); 
p_2I_WT = 1 - chi2cdf(chi2stat_2I_WT,1);

%KO- U2I vs R2I
p0_2I_KO=(KO_U2I+KO_R2I)/(KO_Iconversion+KO_Iconversion);
KO_R2I_exp_2=KO_Iconversion*p0_2I_KO; 
KO_U2I_exp_2=KO_Iconversion*p0_2I_KO;

observed_2I_KO=[KO_R2I KO_Iconversion-KO_R2I KO_U2I KO_Iconversion-KO_I2I]; 
expected_2I_KO=[KO_R2I_exp_2 KO_Iconversion-KO_R2I_exp_2 KO_U2I_exp_2 KO_Iconversion-KO_U2I_exp_2]; 

chi2stat_2I_KO=sum((observed_2I_KO-expected_2I_KO).^2 ./expected_2I_KO); 
p_2I_KO = 1 - chi2cdf(chi2stat_2I_KO,1);



%----UNRESPONSIVE-----
%B2U
p0_B2U=(WT_B2U+KO_B2U)/(WT_Uconversion+KO_Uconversion);
WT_B2U_exp=WT_Uconversion*p0_B2U; 
KO_B2U_exp=KO_Uconversion*p0_B2U;

observed_B2U=[WT_B2U WT_Uconversion-WT_B2U KO_B2U KO_Uconversion-KO_B2U]; 
expected_B2U=[WT_B2U_exp WT_Uconversion-WT_B2U_exp KO_B2U_exp KO_Uconversion-KO_B2U_exp]; 

chi2stat_B2U=sum((observed_B2U-expected_B2U).^2 ./expected_B2U); 
p_B2U = 1 - chi2cdf(chi2stat_B2U,1);

%I2U
p0_I2U=(WT_I2U+KO_I2U)/(WT_Uconversion+KO_Uconversion);
WT_I2U_exp=WT_Uconversion*p0_I2U; 
KO_I2U_exp=KO_Uconversion*p0_I2U;

observed_I2U=[WT_I2U WT_Uconversion-WT_I2U KO_I2U KO_Uconversion-KO_I2U]; 
expected_I2U=[WT_I2U_exp WT_Uconversion-WT_I2U_exp KO_I2U_exp KO_Uconversion-KO_I2U_exp]; 

chi2stat_I2U=sum((observed_I2U-expected_I2U).^2 ./expected_I2U); 
p_I2U = 1 - chi2cdf(chi2stat_I2U,1);

%C2U
p0_C2U=(WT_C2U+KO_C2U)/(WT_Uconversion+KO_Uconversion);
WT_C2U_exp=WT_Uconversion*p0_C2U; 
KO_C2U_exp=KO_Uconversion*p0_C2U;

observed_C2U=[WT_C2U WT_Uconversion-WT_C2U KO_C2U KO_Uconversion-KO_C2U]; 
expected_C2U=[WT_C2U_exp WT_Uconversion-WT_C2U_exp KO_C2U_exp KO_Uconversion-KO_C2U_exp]; 

chi2stat_C2U=sum((observed_C2U-expected_C2U).^2 ./expected_C2U); 
p_C2U = 1 - chi2cdf(chi2stat_C2U,1);

%WT-C2U vs I2U
p0_WT_C2UvsI2U=(WT_C2U+WT_I2U)/(WT_Uconversion+WT_Uconversion);
WT_C2U_exp=WT_Uconversion*p0_WT_C2UvsI2U; 
WT_I2U_exp=WT_Uconversion*p0_WT_C2UvsI2U;

observed_WT_C2UvsI2U=[WT_C2U WT_Uconversion-WT_C2U WT_I2U WT_Uconversion-WT_I2U]; 
expected_WT_C2UvsI2U=[WT_C2U_exp WT_Uconversion-WT_C2U_exp WT_I2U_exp KO_Uconversion-WT_I2U_exp]; 

chi2stat_WT_C2UvsI2U=sum((observed_WT_C2UvsI2U-expected_WT_C2UvsI2U).^2 ./expected_WT_C2UvsI2U); 
p_WT_C2UvsI2U = 1 - chi2cdf(chi2stat_WT_C2UvsI2U,1);

%WT-C2U vs B2U
p0_WT_C2UvsB2U=(WT_C2U+WT_B2U)/(WT_Uconversion+WT_Uconversion);
WT_C2U_exp=WT_Uconversion*p0_WT_C2UvsB2U; 
WT_B2U_exp=WT_Uconversion*p0_WT_C2UvsB2U;

observed_WT_C2UvsB2U=[WT_C2U WT_Uconversion-WT_C2U WT_B2U WT_Uconversion-WT_B2U]; 
expected_WT_C2UvsB2U=[WT_C2U_exp WT_Uconversion-WT_C2U_exp WT_B2U_exp KO_Uconversion-WT_B2U_exp]; 

chi2stat_WT_C2UvsB2U=sum((observed_WT_C2UvsB2U-expected_WT_C2UvsB2U).^2 ./expected_WT_C2UvsB2U); 
p_WT_C2UvsB2U = 1 - chi2cdf(chi2stat_WT_C2UvsB2U,1);

%WT-B2U vs I2U
p0_WT_B2UvsI2U=(WT_B2U+WT_I2U)/(WT_Uconversion+WT_Uconversion);
WT_B2U_exp=WT_Uconversion*p0_WT_B2UvsI2U; 
WT_I2U_exp=WT_Uconversion*p0_WT_B2UvsI2U;

observed_WT_B2UvsI2U=[WT_B2U WT_Uconversion-WT_B2U WT_I2U WT_Uconversion-WT_I2U]; 
expected_WT_B2UvsI2U=[WT_B2U_exp WT_Uconversion-WT_B2U_exp WT_I2U_exp WT_Uconversion-WT_I2U_exp]; 

chi2stat_WT_B2UvsI2U=sum((observed_WT_B2UvsI2U-expected_WT_B2UvsI2U).^2 ./expected_WT_B2UvsI2U); 
p_WT_B2UvsI2U = 1 - chi2cdf(chi2stat_WT_B2UvsI2U,1);


%KO-B2U vs I2U
p0_KO_B2UvsI2U=(KO_B2U+KO_I2U)/(KO_Uconversion+KO_Uconversion);
KO_B2U_exp=KO_Uconversion*p0_KO_B2UvsI2U; 
KO_I2U_exp=KO_Uconversion*p0_KO_B2UvsI2U;

observed_KO_B2UvsI2U=[KO_B2U KO_Uconversion-KO_B2U KO_I2U KO_Uconversion-KO_I2U]; 
expected_KO_B2UvsI2U=[KO_B2U_exp KO_Uconversion-KO_B2U_exp KO_I2U_exp KO_Uconversion-KO_I2U_exp]; 

chi2stat_KO_B2UvsI2U=sum((observed_KO_B2UvsI2U-expected_KO_B2UvsI2U).^2 ./expected_KO_B2UvsI2U); 
p_KO_B2UvsI2U = 1 - chi2cdf(chi2stat_KO_B2UvsI2U,1);

%KO-C2U vs I2U
p0_KO_C2UvsI2U=(KO_C2U+KO_I2U)/(KO_Uconversion+KO_Uconversion);
KO_C2U_exp=KO_Uconversion*p0_KO_C2UvsI2U; 
KO_I2U_exp=KO_Uconversion*p0_KO_C2UvsI2U;

observed_KO_C2UvsI2U=[KO_C2U KO_Uconversion-KO_C2U KO_I2U KO_Uconversion-KO_I2U]; 
expected_KO_C2UvsI2U=[KO_C2U_exp KO_Uconversion-KO_C2U_exp KO_I2U_exp KO_Uconversion-KO_I2U_exp]; 

chi2stat_KO_C2UvsI2U=sum((observed_KO_C2UvsI2U-expected_KO_C2UvsI2U).^2 ./expected_KO_C2UvsI2U); 
p_KO_C2UvsI2U = 1 - chi2cdf(chi2stat_KO_C2UvsI2U,1);

%KO-C2U vs B2U
p0_KO_C2UvsB2U=(KO_C2U+KO_B2U)/(KO_Uconversion+KO_Uconversion);
KO_C2U_exp=KO_Uconversion*p0_KO_C2UvsB2U; 
KO_B2U_exp=KO_Uconversion*p0_KO_C2UvsB2U;

observed_KO_C2UvsB2U=[KO_C2U KO_Uconversion-KO_C2U KO_B2U KO_Uconversion-KO_B2U]; 
expected_KO_C2UvsB2U=[KO_C2U_exp KO_Uconversion-KO_C2U_exp KO_B2U_exp KO_Uconversion-KO_B2U_exp]; 

chi2stat_KO_C2UvsB2U=sum((observed_KO_C2UvsB2U-expected_KO_C2UvsB2U).^2 ./expected_KO_C2UvsB2U); 
p_KO_C2UvsB2U = 1 - chi2cdf(chi2stat_KO_C2UvsB2U,1);



%-----BINOCULAR----

%U2B
p0_U2B=(WT_U2B+KO_U2B)/(WT_Bconversion+KO_Bconversion);
WT_U2B_exp=WT_Bconversion*p0_U2B; 
KO_U2B_exp=KO_Bconversion*p0_U2B;

observed_U2B=[WT_U2B WT_Bconversion-WT_U2B KO_U2B KO_Bconversion-KO_U2B]; 
expected_U2B=[WT_U2B_exp WT_Bconversion-WT_U2B_exp KO_U2B_exp KO_Bconversion-KO_U2B_exp]; 

chi2stat_U2B=sum((observed_U2B-expected_U2B).^2 ./expected_U2B); 
p_U2B = 1 - chi2cdf(chi2stat_U2B,1);

%I2B
p0_I2B=(WT_I2B+KO_I2B)/(WT_Bconversion+KO_Bconversion);
WT_I2B_exp=WT_Bconversion*p0_I2B; 
KO_I2B_exp=KO_Bconversion*p0_I2B;

observed_I2B=[WT_I2B WT_Bconversion-WT_I2B KO_I2B KO_Bconversion-KO_I2B]; 
expected_I2B=[WT_I2B_exp WT_Bconversion-WT_I2B_exp KO_I2B_exp KO_Bconversion-KO_I2B_exp]; 

chi2stat_I2B=sum((observed_I2B-expected_I2B).^2 ./expected_I2B); 
p_I2B = 1 - chi2cdf(chi2stat_I2B,1);


%C2B
p0_C2B=(WT_C2B+KO_C2B)/(WT_Bconversion+KO_Bconversion);
WT_C2B_exp=WT_Bconversion*p0_C2B; 
KO_C2B_exp=KO_Bconversion*p0_C2B;

observed_C2B=[WT_C2B WT_Bconversion-WT_C2B KO_C2B KO_Bconversion-KO_C2B]; 
expected_C2B=[WT_C2B_exp WT_Bconversion-WT_C2B_exp KO_C2B_exp KO_Bconversion-KO_C2B_exp]; 

chi2stat_C2B=sum((observed_C2B-expected_C2B).^2 ./expected_C2B); 
p_C2B = 1 - chi2cdf(chi2stat_C2B,1);

%loss of binocular cells 
p0_B2M=(WT_B2M+KO_B2M)/((WT_B2M+WT_B2B+WT_M2B)+(KO_B2M+KO_B2B+KO_M2B));
WT_B2M_exp=(WT_B2M+WT_B2B)*p0_B2M; 
KO_B2M_exp=(KO_B2M+KO_B2B)*p0_B2M;

observed_B2M=[WT_B2M (WT_B2M+WT_B2B +WT_M2B)-WT_B2M KO_B2M (KO_B2M+KO_B2B+KO_M2B)-KO_B2M]; 
expected_B2M=[WT_B2M_exp (WT_B2M+WT_B2B +WT_M2B)-WT_B2M_exp KO_B2M_exp (KO_B2M+KO_B2B+KO_M2B)-KO_B2M_exp]; 

chi2stat_B2M=sum((observed_B2M-expected_B2M).^2 ./expected_B2M); 
p_B2M = 1 - chi2cdf(chi2stat_C2B,1);

%WT-C2B vs I2B
p0_WT_C2BvsI2B=(WT_C2B+WT_I2B)/(WT_Bconversion+WT_Bconversion);
WT_C2B_exp=WT_Bconversion*p0_WT_C2BvsI2B; 
WT_I2B_exp=WT_Bconversion*p0_WT_C2BvsI2B;

observed_WT_C2BvsI2B=[WT_C2B WT_Bconversion-WT_C2B WT_I2B WT_Bconversion-WT_I2B]; 
expected_WT_C2BvsI2B=[WT_C2B_exp WT_Bconversion-WT_C2B_exp WT_I2B_exp KO_Bconversion-WT_I2B_exp]; 

chi2stat_WT_C2BvsI2B=sum((observed_WT_C2BvsI2B-expected_WT_C2BvsI2B).^2 ./expected_WT_C2BvsI2B); 
p_WT_C2BvsI2B = 1 - chi2cdf(chi2stat_WT_C2BvsI2B,1);

%WT-C2B vs U2B
p0_WT_C2BvsU2B=(WT_C2B+WT_U2B)/(WT_Bconversion+WT_Bconversion);
WT_C2B_exp=WT_Bconversion*p0_WT_C2BvsU2B; 
WT_U2B_exp=WT_Bconversion*p0_WT_C2BvsU2B;

observed_WT_C2BvsU2B=[WT_C2B WT_Bconversion-WT_C2B WT_U2B WT_Bconversion-WT_U2B]; 
expected_WT_C2BvsU2B=[WT_C2B_exp WT_Bconversion-WT_C2B_exp WT_U2B_exp KO_Bconversion-WT_U2B_exp]; 

chi2stat_WT_C2BvsU2B=sum((observed_WT_C2BvsU2B-expected_WT_C2BvsU2B).^2 ./expected_WT_C2BvsU2B); 
p_WT_C2BvsU2B = 1 - chi2cdf(chi2stat_WT_C2BvsU2B,1);

%WT-U2B vs I2B
p0_WT_U2BvsI2B=(WT_U2B+WT_I2B)/(WT_Bconversion+WT_Bconversion);
WT_U2B_exp=WT_Bconversion*p0_WT_U2BvsI2B; 
WT_I2B_exp=WT_Bconversion*p0_WT_U2BvsI2B;

observed_WT_U2BvsI2B=[WT_U2B WT_Bconversion-WT_U2B WT_I2B WT_Bconversion-WT_I2B]; 
expected_WT_U2BvsI2B=[WT_U2B_exp WT_Bconversion-WT_U2B_exp WT_I2B_exp WT_Bconversion-WT_I2B_exp]; 

chi2stat_WT_U2BvsI2B=sum((observed_WT_U2BvsI2B-expected_WT_U2BvsI2B).^2 ./expected_WT_U2BvsI2B); 
p_WT_U2BvsI2B = 1 - chi2cdf(chi2stat_WT_U2BvsI2B,1);



%KO-U2B vs I2B
p0_KO_U2BvsI2B=(KO_U2B+KO_I2B)/(KO_Bconversion+KO_Bconversion);
KO_U2B_exp=KO_Bconversion*p0_KO_U2BvsI2B; 
KO_I2B_exp=KO_Bconversion*p0_KO_U2BvsI2B;

observed_KO_U2BvsI2B=[KO_U2B KO_Bconversion-KO_U2B KO_I2B KO_Bconversion-KO_I2B]; 
expected_KO_U2BvsI2B=[KO_U2B_exp KO_Bconversion-KO_U2B_exp KO_I2B_exp KO_Bconversion-KO_I2B_exp]; 

chi2stat_KO_U2BvsI2B=sum((observed_KO_U2BvsI2B-expected_KO_U2BvsI2B).^2 ./expected_KO_U2BvsI2B); 
p_KO_U2BvsI2B = 1 - chi2cdf(chi2stat_KO_U2BvsI2B,1);

%KO-C2B vs I2B
p0_KO_C2BvsI2B=(KO_C2B+KO_I2B)/(KO_Bconversion+KO_Bconversion);
KO_C2B_exp=KO_Bconversion*p0_KO_C2BvsI2B; 
KO_I2B_exp=KO_Bconversion*p0_KO_C2BvsI2B;

observed_KO_C2BvsI2B=[KO_C2B KO_Bconversion-KO_C2B KO_I2B KO_Bconversion-KO_I2B]; 
expected_KO_C2BvsI2B=[KO_C2B_exp KO_Bconversion-KO_C2B_exp KO_I2B_exp KO_Bconversion-KO_I2B_exp]; 

chi2stat_KO_C2BvsI2B=sum((observed_KO_C2BvsI2B-expected_KO_C2BvsI2B).^2 ./expected_KO_C2BvsI2B); 
p_KO_C2BvsI2B = 1 - chi2cdf(chi2stat_KO_C2BvsI2B,1);

%KO-C2B vs U2B
p0_KO_C2BvsU2B=(KO_C2B+KO_U2B)/(KO_Bconversion+KO_Bconversion);
KO_C2B_exp=KO_Bconversion*p0_KO_C2BvsU2B; 
KO_U2B_exp=KO_Bconversion*p0_KO_C2BvsU2B;

observed_KO_C2BvsU2B=[KO_C2B KO_Bconversion-KO_C2B KO_U2B KO_Bconversion-KO_U2B]; 
expected_KO_C2BvsU2B=[KO_C2B_exp KO_Bconversion-KO_C2B_exp KO_U2B_exp KO_Bconversion-KO_U2B_exp]; 

chi2stat_KO_C2BvsU2B=sum((observed_KO_C2BvsU2B-expected_KO_C2BvsU2B).^2 ./expected_KO_C2BvsU2B); 
p_KO_C2BvsU2B = 1 - chi2cdf(chi2stat_KO_C2BvsU2B,1);



%gain of binocular cells 
p0_M2B=(WT_M2B+KO_M2B)/((WT_M2B+WT_B2B+WT_B2M)+(KO_M2B+KO_B2B+KO_B2M));
WT_M2B_exp=(WT_M2B+WT_B2B)*p0_M2B; 
KO_M2B_exp=(KO_M2B+KO_B2B)*p0_M2B;

observed_M2B=[WT_M2B (WT_M2B+WT_B2B+WT_B2M)-WT_M2B KO_M2B (KO_M2B+KO_B2B+KO_B2M)-KO_M2B]; 
expected_M2B=[WT_M2B_exp (WT_M2B+WT_B2B+WT_B2M)-WT_M2B_exp KO_M2B_exp (KO_M2B+KO_B2B+KO_B2M)-KO_M2B_exp]; 

chi2stat_M2B=sum((observed_M2B-expected_M2B).^2 ./expected_M2B); 
p_M2B = 1 - chi2cdf(chi2stat_M2B,1);

%no change in binocular 
p0_B2B=(WT_B2B+KO_B2B)/((WT_B2B+WT_M2B+KO_B2M)+(KO_B2B+KO_M2B+KO_B2M));
WT_B2B_exp=(WT_B2B+WT_B2B)*p0_B2B; 
KO_B2B_exp=(KO_B2B+KO_B2B)*p0_B2B;

observed_B2B=[WT_B2B (WT_B2B+WT_B2M+WT_M2B)-WT_B2B KO_B2B (KO_B2B+KO_B2M+KO_M2B)-KO_B2B]; 
expected_B2B=[WT_B2B_exp (WT_B2B+WT_B2M+WT_M2B)-WT_B2B_exp KO_B2B_exp (KO_B2B+KO_B2M+KO_M2B)-KO_B2B_exp]; 

chi2stat_B2B=sum((observed_B2B-expected_B2B).^2 ./expected_B2B); 
p_B2B = 1 - chi2cdf(chi2stat_B2B,1);

% resp total to binoc
p0_R2B=(WT_R2B+KO_R2B)/(WT_Bconversion+KO_Bconversion);
WT_R2B_exp=WT_Bconversion*p0_R2B; 
KO_R2B_exp=KO_Bconversion*p0_R2B;

observed_R2B=[WT_R2B WT_Bconversion-WT_R2B KO_R2B KO_Bconversion-KO_R2B]; 
expected_R2B=[WT_R2B_exp WT_Bconversion-WT_R2B_exp KO_R2B_exp KO_Bconversion-KO_R2B_exp]; 

chi2stat_R2B=sum((observed_R2B-expected_R2B).^2 ./expected_R2B); 
p_R2B = 1 - chi2cdf(chi2stat_R2B,1);

%WT- U2B vs R2B
p0_2B_WT=(WT_U2B+WT_R2B)/(WT_Bconversion+WT_Bconversion);
WT_R2B_exp_2=WT_Bconversion*p0_2B_WT; 
WT_U2B_exp_2=WT_Bconversion*p0_2B_WT;

observed_2B_WT=[WT_R2B WT_Bconversion-WT_R2B WT_U2B WT_Bconversion-WT_U2B]; 
expected_2B_WT=[WT_R2B_exp_2 WT_Bconversion-WT_R2B_exp_2 WT_U2B_exp_2 WT_Bconversion-WT_U2B_exp_2]; 

chi2stat_2B_WT=sum((observed_2B_WT-expected_2B_WT).^2 ./expected_2B_WT); 
p_2B_WT = 1 - chi2cdf(chi2stat_2B_WT,1);

%KO- U2B vs R2B
p0_2B_KO=(KO_U2B+KO_R2B)/(KO_Bconversion+KO_Bconversion);
KO_R2B_exp_2=KO_Bconversion*p0_2B_KO; 
KO_U2B_exp_2=KO_Bconversion*p0_2B_KO;

observed_2B_KO=[KO_R2B KO_Bconversion-KO_R2B KO_U2B KO_Bconversion-KO_U2B]; 
expected_2B_KO=[KO_R2B_exp_2 KO_Bconversion-KO_R2B_exp_2 KO_U2B_exp_2 KO_Bconversion-KO_U2B_exp_2]; 

chi2stat_2B_KO=sum((observed_2B_KO-expected_2B_KO).^2 ./expected_2B_KO); 
p_2B_KO = 1 - chi2cdf(chi2stat_2B_KO,1);





%% what percent of longitidinally tracked cells are unresponsive pre, post MD

WT_pre_U=WT_U2I+ WT_U2C+WT_U2B+WT_U2U; 
WT_post_U=WT_I2U+WT_C2U+WT_B2U+WT_U2U;

KO_pre_U=KO_U2I+ KO_U2C+KO_U2B+KO_U2U; 
KO_post_U=KO_I2U+KO_C2U+KO_B2U+KO_U2U;

%save 
save(fullfile(SaveDir, 'WT_pre_U.mat'),'WT_pre_U');
save(fullfile(SaveDir, 'KO_pre_U.mat'),'KO_pre_U');
save(fullfile(SaveDir, 'WT_post_U.mat'),'WT_post_U');
save(fullfile(SaveDir, 'KO_post_U.mat'),'KO_post_U');

save(fullfile(SaveDir,'WT_totalcells.mat'),'WT_totalcells'); 
save(fullfile(SaveDir, 'KO_totalcells.mat'), 'KO_totalcells'); 

fig_unresponsive=figure(17); 


categoriesURtotal=categorical({'Pre MD', 'Post MD'}); 
categoriesURtotal=reordercats(categoriesURtotal, {'Pre MD', 'Post MD'}); 

pre_URtotal=[(WT_pre_U/WT_totalcells)  KO_pre_U/KO_totalcells ]; 
post_URtotal=[(WT_post_U/WT_totalcells)  KO_post_U/KO_totalcells ]; 

y_URtotal=[pre_URtotal; post_URtotal]; 
b1=bar(categoriesURtotal,y_URtotal, 0.9); 
hold on 
b1(1).FaceColor=[0.3 0.3 0.3]; 
b1(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Total Unresponsiveness')
legend('WT', 'KO'); 
box off; 

saveas(fig_unresponsive, fullfile(SaveDir,'UnresponsiveTotal'),'pdf'); 
saveas(fig_unresponsive, fullfile(SaveDir,'UnresponsiveTotal'),'tif');
saveas(fig_unresponsive, fullfile(SaveDir,'UnresponsiveTotal'),'fig');

%longitudinally tracked cells 
% ipsi_pre_WT=WT_I2U+WT_I2I+WT_I2B+WT_I2C; 
% ipsi_pre_KO=KO_I2U+KO_I2I+KO_I2B+KO_I2C; 
% 
% ipsi_post_WT
% ipsi_post_KO

%% what percent of longitidinally tracked cells are ipsilateral pre, post MD (responsive cells only) 

WT_pre_I=WT_I2I+ WT_I2C+WT_I2B+WT_I2U; 
WT_post_I=WT_I2I+WT_C2I+WT_B2I+WT_U2I;

KO_pre_I=KO_I2I+ KO_I2C+KO_I2B+KO_I2U; 
KO_post_I=KO_I2I+KO_C2I+KO_B2I+KO_U2I;

%save 
save(fullfile(SaveDir, 'WT_pre_I.mat'),'WT_pre_I');
save(fullfile(SaveDir, 'KO_pre_I.mat'),'KO_pre_I');
save(fullfile(SaveDir, 'WT_post_I.mat'),'WT_post_I');
save(fullfile(SaveDir, 'KO_post_I.mat'),'KO_post_I');

fig_ipsilateral=figure(18); 
%plot for ipsilateral cells 

categoriesIRtotal=categorical({'Pre MD', 'Post MD'}); 
categoriesIRtotal=reordercats(categoriesIRtotal, {'Pre MD', 'Post MD'}); 

pre_IRtotal=[WT_pre_I/(WT_totalcells-WT_pre_U)  KO_pre_I/(KO_totalcells-KO_pre_U) ]; 
post_IRtotal=[WT_post_I/(WT_totalcells-WT_post_U)  KO_post_I/(KO_totalcells-KO_post_U) ]; 

y_IRtotal=[pre_IRtotal; post_IRtotal]; 
bI=bar(categoriesIRtotal,y_IRtotal, 0.9); 
hold on 
bI(1).FaceColor=[0.3 0.3 0.3]; 
bI(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
ylabel('Proportion of Responsive Neurons')
title('Total Ipsilateral')
legend('WT', 'KO'); 
box off; 

saveas(fig_ipsilateral, fullfile(SaveDir,'IpsiTotal'),'pdf'); 
saveas(fig_ipsilateral, fullfile(SaveDir,'IpsiTotal'),'tif');
saveas(fig_ipsilateral, fullfile(SaveDir,'IpsiTotal'),'fig');

%% what percent of longitidinall, responsive tracked cells are ipsilateral and binocular pre, post MD 

WT_pre_IB=WT_I2I+ WT_I2C+WT_I2B+WT_B2I+WT_B2C+WT_B2B; 
WT_post_IB=WT_I2I+WT_C2I+WT_B2I+WT_I2B+WT_C2B+WT_B2B;

KO_pre_IB=KO_I2I+ KO_I2C+KO_I2B+KO_B2I+KO_B2C+KO_B2B; 
KO_post_IB=KO_I2I+KO_C2I+KO_B2I+KO_I2B+KO_C2B+KO_B2B;

fig_ipsilateralandbinoc=figure(19); 
%plot for ipsilateral cells 

categoriesIBtotal=categorical({'Pre MD', 'Post MD'}); 
categoriesIBtotal=reordercats(categoriesIBtotal, {'Pre MD', 'Post MD'}); 

pre_IBtotal=[WT_pre_IB/(WT_totalcells-WT_pre_U)  KO_pre_IB/(KO_totalcells-KO_pre_U) ]; 
post_IBtotal=[WT_post_IB/(WT_totalcells-WT_post_U)  KO_post_IB/(KO_totalcells-KO_post_U) ]; 

y_IBtotal=[pre_IBtotal; post_IBtotal]; 
bIB=bar(categoriesIBtotal,y_IBtotal, 0.9); 
hold on 
bIB(1).FaceColor=[0.3 0.3 0.3]; 
bIB(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Total Ipsilateral+Binocular')
ylabel('Proportion of Responsive Neurons')
legend('WT', 'KO'); 
box off; 

saveas(fig_ipsilateralandbinoc, fullfile(SaveDir,'IpsiBinocTotal'),'pdf'); 
saveas(fig_ipsilateralandbinoc, fullfile(SaveDir,'IpsiBinocTotal'),'tif');
saveas(fig_ipsilateralandbinoc, fullfile(SaveDir,'IpsiBinocTotal'),'fig');

%% what percent of cells are binocular? (of responsive cells only?)
WT_pre_B=WT_B2C+ WT_B2I+WT_B2B+WT_B2U; 
WT_post_B=WT_C2B+WT_I2B+WT_B2B+WT_U2B;

KO_pre_B=KO_B2C+ KO_B2I+KO_B2B+KO_B2U; 
KO_post_B=KO_C2B+KO_I2B+KO_B2B+KO_U2B;

%save 
save(fullfile(SaveDir, 'WT_pre_B.mat'),'WT_pre_B');
save(fullfile(SaveDir, 'KO_pre_B.mat'),'KO_pre_B');
save(fullfile(SaveDir, 'WT_post_B.mat'),'WT_post_B');
save(fullfile(SaveDir, 'KO_post_B.mat'),'KO_post_B');

fig_binoc=figure(20); 
%plot for binoc cells 

categoriesBtotal=categorical({'Pre MD', 'Post MD'}); 
categoriesBtotal=reordercats(categoriesBtotal, {'Pre MD', 'Post MD'}); 

pre_Btotal=[WT_pre_B/(WT_totalcells-WT_pre_U)  KO_pre_B/(KO_totalcells-KO_pre_U) ]; 
post_Btotal=[WT_post_B/(WT_totalcells-WT_post_U)  KO_post_B/(KO_totalcells-KO_post_U) ]; 

y_Btotal=[pre_Btotal; post_Btotal]; 
bIC=bar(categoriesBtotal,y_Btotal, 0.9); 
hold on 
bIC(1).FaceColor=[0.3 0.3 0.3]; 
bIC(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
ylabel('Proportion of Responsive Neurons')
title('Total Binocular')
legend('WT', 'KO'); 
box off; 

saveas(fig_binoc, fullfile(SaveDir,'TotalBinoc'),'pdf'); 
saveas(fig_binoc, fullfile(SaveDir,'TotalBinoc'),'tif');
saveas(fig_binoc, fullfile(SaveDir,'TotalBinoc'),'fig');

%% what percent of cells are contralateral (of responsive cells only?)
WT_pre_C=WT_C2C+ WT_C2I+WT_C2B+WT_C2U; 
WT_post_C=WT_C2C+WT_I2C+WT_B2C+WT_U2C;

KO_pre_C=KO_C2C+ KO_C2I+KO_C2B+KO_C2U; 
KO_post_C=KO_C2C+KO_I2C+KO_B2C+KO_U2C;

%save 
save(fullfile(SaveDir, 'WT_pre_C.mat'),'WT_pre_C');
save(fullfile(SaveDir, 'KO_pre_C.mat'),'KO_pre_C');
save(fullfile(SaveDir, 'WT_post_C.mat'),'WT_post_C');
save(fullfile(SaveDir, 'KO_post_C.mat'),'KO_post_C');

fig_contralateral=figure(21); 
%plot for contra cells 

categoriesCtotal=categorical({'Pre MD', 'Post MD'}); 
categoriesCtotal=reordercats(categoriesCtotal, {'Pre MD', 'Post MD'}); 

pre_Ctotal=[WT_pre_C/(WT_totalcells-WT_pre_U)  KO_pre_C/(KO_totalcells-KO_pre_U) ]; 
post_Ctotal=[WT_post_C/(WT_totalcells-WT_post_U)  KO_post_C/(KO_totalcells-KO_post_U) ]; 

y_Ctotal=[pre_Ctotal; post_Ctotal]; 
bIC=bar(categoriesCtotal,y_Ctotal, 0.9); 
hold on 
bIC(1).FaceColor=[0.3 0.3 0.3]; 
bIC(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
ylabel('Proportion of Responsive Neurons')
title('Total Contralateral')
legend('WT', 'KO'); 
box off; 

saveas(fig_contralateral, fullfile(SaveDir,'TotalContra'),'pdf'); 
saveas(fig_contralateral, fullfile(SaveDir,'TotalContra'),'tif');
saveas(fig_contralateral, fullfile(SaveDir,'TotalContra'),'fig');


%% Unresponsive tests
%total prop unresp- pre
p0_U_pre=(WT_pre_U+ KO_pre_U)/((WT_totalcells)+(KO_totalcells));
WT_U_exp_pre=(WT_totalcells)*p0_U_pre; 
KO_U_exp_pre=(KO_totalcells)*p0_U_pre;

observed_U_pre=[WT_pre_U (WT_totalcells-WT_pre_U) KO_pre_U (KO_totalcells-KO_pre_U)]; 
expected_U_pre=[WT_U_exp_pre WT_totalcells-WT_U_exp_pre KO_U_exp_pre KO_totalcells-KO_U_exp_pre]; 

chi2stat_U_pre=sum((observed_U_pre-expected_U_pre).^2 ./expected_U_pre); 
p_U_pre = 1 - chi2cdf(chi2stat_U_pre,1);

%total prop unresp - post
p0_U_post=(WT_post_U+ KO_post_U)/((WT_totalcells)+(KO_totalcells));
WT_U_exp_post=(WT_totalcells)*p0_U_post; 
KO_U_exp_post=(KO_totalcells)*p0_U_post;

observed_U_post=[WT_post_U (WT_totalcells)-WT_post_U KO_post_U (KO_totalcells)-KO_post_U]; 
expected_U_post=[WT_U_exp_post (WT_totalcells)-WT_U_exp_post KO_U_exp_post (KO_totalcells)-KO_U_exp_post]; 

chi2stat_U_post=sum((observed_U_post-expected_U_post).^2 ./expected_U_post); 
p_U_post = 1 - chi2cdf(chi2stat_U_post,1);


%total prop unresp- pre
p0_WT_U=(WT_pre_U+ WT_post_U)/(WT_totalcells+WT_totalcells);
WT_U_exp_pre=(WT_totalcells)*p0_WT_U; 
WT_U_exp_post=(WT_totalcells)*p0_WT_U;

observed_WT_U=[WT_pre_U (WT_totalcells-WT_pre_U) WT_post_U (WT_totalcells-WT_post_U)]; 
expected_WT_U=[WT_U_exp_pre (WT_totalcells-WT_U_exp_pre) WT_U_exp_post (WT_totalcells-WT_U_exp_post)]; 

chi2stat_WT_U=sum((observed_WT_U-expected_WT_U).^2 ./expected_WT_U); 
p_WT_U = 1 - chi2cdf(chi2stat_WT_U,1);

%ko pre vs post unresp
p0_KO_U=(KO_pre_U+ KO_post_U)/(KO_totalcells+KO_totalcells);
KO_U_exp_pre=(KO_totalcells)*p0_KO_U; 
KO_U_exp_post=(KO_totalcells)*p0_KO_U;

observed_KO_U=[KO_pre_U (KO_totalcells-KO_pre_U) KO_post_U (KO_totalcells-KO_post_U)]; 
expected_KO_U=[KO_U_exp_pre (KO_totalcells-KO_U_exp_pre) KO_U_exp_post (KO_totalcells-KO_U_exp_post)]; 

chi2stat_KO_U=sum((observed_KO_U-expected_KO_U).^2 ./expected_KO_U); 
p_KO_U = 1 - chi2cdf(chi2stat_KO_U,1);

%% ipsilateral (responsive only)

%total prop IPSI- pre
p0_I_pre=(WT_pre_I+ KO_pre_I)/((WT_totalcells-WT_pre_U)+(KO_totalcells-KO_pre_U));
WT_I_exp_pre=(WT_totalcells-WT_pre_U)*p0_I_pre; 
KO_I_exp_pre=(KO_totalcells-KO_pre_U)*p0_I_pre;

observed_I_pre=[WT_pre_I (WT_totalcells-WT_pre_U)-WT_pre_I KO_pre_I (KO_totalcells-KO_pre_U)-KO_pre_I]; 
expected_I_pre=[WT_I_exp_pre (WT_totalcells-WT_pre_U)-WT_I_exp_pre KO_I_exp_pre (KO_totalcells-KO_pre_U)-KO_I_exp_pre]; 

chi2stat_I_pre=sum((observed_I_pre-expected_I_pre).^2 ./expected_I_pre); 
p_I_pre = 1 - chi2cdf(chi2stat_I_pre,1);

%total prop IPSI - post
p0_I_post=(WT_post_I+ KO_post_I)/((WT_totalcells-WT_post_U)+(KO_totalcells-KO_post_U));
WT_I_exp_post=(WT_totalcells-WT_post_U)*p0_I_post; 
KO_I_exp_post=(KO_totalcells-KO_post_U)*p0_I_post;

observed_I_post=[WT_post_I (WT_totalcells-WT_post_U)-WT_post_I KO_post_I (KO_totalcells-KO_post_U)-KO_post_I]; 
expected_I_post=[WT_I_exp_post (WT_totalcells-WT_post_U)-WT_I_exp_post KO_I_exp_post (KO_totalcells-KO_post_U)-KO_I_exp_post]; 

chi2stat_I_post=sum((observed_I_post-expected_I_post).^2 ./expected_I_post); 
p_I_post = 1 - chi2cdf(chi2stat_I_post,1);

% WT- pre vs post 
p0_I_WT=(WT_pre_I+ WT_post_I)/((WT_totalcells-WT_pre_U)+(WT_totalcells-WT_post_U));
WT_I_exp_pre=(WT_totalcells-WT_pre_U)*p0_I_WT; 
WT_I_exp_post=(WT_totalcells-WT_post_U)*p0_I_WT;

observed_I_WT=[WT_pre_I (WT_totalcells-WT_pre_U)-WT_pre_I WT_post_I (WT_totalcells-WT_post_U)-WT_post_I]; 
expected_I_WT=[WT_I_exp_pre (WT_totalcells-WT_pre_U)-WT_I_exp_pre WT_I_exp_post (WT_totalcells-WT_post_U)-WT_I_exp_post]; 

chi2stat_I_WT=sum((observed_I_WT-expected_I_WT).^2 ./expected_I_WT); 
p_WT_I = 1 - chi2cdf(chi2stat_I_WT,1);

% KO - pre vs post 
p0_I_KO=(KO_pre_I+ KO_post_I)/((KO_totalcells-KO_pre_U)+(KO_totalcells-KO_post_U));
KO_I_exp_pre=(KO_totalcells-KO_pre_U)*p0_I_KO; 
KO_I_exp_post=(KO_totalcells-KO_post_U)*p0_I_KO;

observed_I_KO=[KO_pre_I (KO_totalcells-KO_pre_U)-KO_pre_I KO_post_I (KO_totalcells-KO_post_U)-KO_post_I]; 
expected_I_KO=[KO_I_exp_pre (KO_totalcells-KO_pre_U)-KO_I_exp_pre KO_I_exp_post (KO_totalcells-KO_post_U)-KO_I_exp_post]; 

chi2stat_I_KO=sum((observed_I_KO-expected_I_KO).^2 ./expected_I_KO); 
p_KO_I = 1 - chi2cdf(chi2stat_I_KO,1);

%% contralateral- responsive only 

%pre - wt vs ko 
p0_C_pre=(WT_pre_C+ KO_pre_C)/((WT_totalcells-WT_pre_U)+(KO_totalcells-KO_pre_U));
WT_C_exp_pre=(WT_totalcells-WT_pre_U)*p0_C_pre; 
KO_C_exp_pre=(KO_totalcells-KO_pre_U)*p0_C_pre;

observed_C_pre=[WT_pre_C (WT_totalcells-WT_pre_U)-WT_pre_C KO_pre_C (KO_totalcells-KO_pre_U)-KO_pre_C]; 
expected_C_pre=[WT_C_exp_pre (WT_totalcells-WT_pre_U)-WT_C_exp_pre KO_C_exp_pre (KO_totalcells-KO_pre_U)-KO_C_exp_pre]; 

chi2stat_C_pre=sum((observed_C_pre-expected_C_pre).^2 ./expected_C_pre); 
p_C_pre = 1 - chi2cdf(chi2stat_C_pre,1);

%post-- wt vs ko 
p0_C_post=(WT_post_C+ KO_post_C)/((WT_totalcells-WT_post_U)+(KO_totalcells-KO_post_U));
WT_C_exp_post=(WT_totalcells-WT_post_U)*p0_C_post; 
KO_C_exp_post=(KO_totalcells-KO_post_U)*p0_C_post;

observed_C_post=[WT_post_C (WT_totalcells-WT_post_U)-WT_post_C KO_post_C (KO_totalcells-KO_post_U)-KO_post_C]; 
expected_C_post=[WT_C_exp_post (WT_totalcells-WT_post_U)-WT_C_exp_post KO_C_exp_post (KO_totalcells-KO_post_U)-KO_C_exp_post]; 

chi2stat_C_post=sum((observed_C_post-expected_C_post).^2 ./expected_C_post); 
p_C_post = 1 - chi2cdf(chi2stat_C_post,1);

% WT- pre vs post 
p0_C_WT=(WT_pre_C+ WT_post_C)/((WT_totalcells-WT_pre_U)+(WT_totalcells-WT_post_U));
WT_C_exp_pre=(WT_totalcells-WT_pre_U)*p0_C_WT; 
WT_C_exp_post=(WT_totalcells-WT_post_U)*p0_C_WT;

observed_C_WT=[WT_pre_C (WT_totalcells-WT_pre_U)-WT_pre_C WT_post_C (WT_totalcells-WT_post_U)-WT_post_C]; 
expected_C_WT=[WT_C_exp_pre (WT_totalcells-WT_pre_U)-WT_C_exp_pre WT_C_exp_post (WT_totalcells-WT_post_U)-WT_C_exp_post]; 

chi2stat_C_WT=sum((observed_C_WT-expected_C_WT).^2 ./expected_C_WT); 
p_WT_C = 1 - chi2cdf(chi2stat_C_WT,1);

% KO - pre vs post 
p0_C_KO=(KO_pre_C+ KO_post_C)/((KO_totalcells-KO_pre_U)+(KO_totalcells-KO_post_U));
KO_C_exp_pre=(KO_totalcells-KO_pre_U)*p0_C_KO; 
KO_C_exp_post=(KO_totalcells-KO_post_U)*p0_C_KO;

observed_C_KO=[KO_pre_C (KO_totalcells-KO_pre_U)-KO_pre_C KO_post_C (KO_totalcells-KO_post_U)-KO_post_C]; 
expected_C_KO=[KO_C_exp_pre (KO_totalcells-KO_pre_U)-KO_C_exp_pre KO_C_exp_post (KO_totalcells-KO_post_U)-KO_C_exp_post]; 

chi2stat_C_KO=sum((observed_C_KO-expected_C_KO).^2 ./expected_C_KO); 
p_KO_C = 1 - chi2cdf(chi2stat_C_KO,1);

%% binoc- responsive cells only 

p0_B_pre=(WT_pre_B+ KO_pre_B)/((WT_totalcells-WT_pre_U)+(KO_totalcells-KO_pre_U));
WT_B_exp_pre=(WT_totalcells-WT_pre_U)*p0_B_pre; 
KO_B_exp_pre=(KO_totalcells-KO_pre_U)*p0_B_pre;

observed_B_pre=[WT_pre_B (WT_totalcells-WT_pre_U)-WT_pre_B KO_pre_B (KO_totalcells-KO_pre_U)-KO_pre_B]; 
expected_B_pre=[WT_B_exp_pre (WT_totalcells-WT_pre_U)-WT_B_exp_pre KO_B_exp_pre (KO_totalcells-KO_pre_U)-KO_B_exp_pre]; 

chi2stat_B_pre=sum((observed_B_pre-expected_B_pre).^2 ./expected_B_pre); 
p_B_pre = 1 - chi2cdf(chi2stat_B_pre,1);

%post-- wt vs ko 
p0_B_post=(WT_post_B+ KO_post_B)/((WT_totalcells-WT_post_U)+(KO_totalcells-KO_post_U));
WT_B_exp_post=(WT_totalcells-WT_post_U)*p0_B_post; 
KO_B_exp_post=(KO_totalcells-KO_post_U)*p0_B_post;

observed_B_post=[WT_post_B (WT_totalcells-WT_post_U)-WT_post_B KO_post_B (KO_totalcells-KO_post_U)-KO_post_B]; 
expected_B_post=[WT_B_exp_post (WT_totalcells-WT_post_U)-WT_B_exp_post KO_B_exp_post (KO_totalcells-KO_post_U)-KO_B_exp_post]; 

chi2stat_B_post=sum((observed_B_post-expected_B_post).^2 ./expected_B_post); 
p_B_post = 1 - chi2cdf(chi2stat_B_post,1);

% WT- pre vs post 
p0_B_WT=(WT_pre_B+ WT_post_B)/((WT_totalcells-WT_pre_U)+(WT_totalcells-WT_post_U));
WT_B_exp_pre=(WT_totalcells-WT_pre_U)*p0_B_WT; 
WT_B_exp_post=(WT_totalcells-WT_post_U)*p0_B_WT;

observed_B_WT=[WT_pre_B (WT_totalcells-WT_pre_U)-WT_pre_B WT_post_B (WT_totalcells-WT_post_U)-WT_post_B]; 
expected_B_WT=[WT_B_exp_pre (WT_totalcells-WT_pre_U)-WT_B_exp_pre WT_B_exp_post (WT_totalcells-WT_post_U)-WT_B_exp_post]; 

chi2stat_B_WT=sum((observed_B_WT-expected_B_WT).^2 ./expected_B_WT); 
p_WT_B = 1 - chi2cdf(chi2stat_B_WT,1);

% KO - pre vs post 
p0_B_KO=(KO_pre_B+ KO_post_B)/((KO_totalcells-KO_pre_U)+(KO_totalcells-KO_post_U));
KO_B_exp_pre=(KO_totalcells-KO_pre_U)*p0_B_KO; 
KO_B_exp_post=(KO_totalcells-KO_post_U)*p0_B_KO;

observed_B_KO=[KO_pre_B (KO_totalcells-KO_pre_U)-KO_pre_B KO_post_B (KO_totalcells-KO_post_U)-KO_post_B]; 
expected_B_KO=[KO_B_exp_pre (KO_totalcells-KO_pre_U)-KO_B_exp_pre KO_B_exp_post (KO_totalcells-KO_post_U)-KO_B_exp_post]; 

chi2stat_B_KO=sum((observed_B_KO-expected_B_KO).^2 ./expected_B_KO); 
p_KO_B = 1 - chi2cdf(chi2stat_B_KO,1);

%% Ipsi+ binoc responsive only 

%total prop IPSI+BINOC- pre
p0_IB_pre=(WT_pre_IB+ KO_pre_IB)/((WT_totalcells-WT_pre_U)+(KO_totalcells-KO_pre_U));
WT_IB_exp_pre=(WT_totalcells-WT_pre_U)*p0_IB_pre; 
KO_IB_exp_pre=(KO_totalcells-KO_pre_U)*p0_IB_pre;

observed_IB_pre=[WT_pre_IB (WT_totalcells-WT_pre_U)-WT_pre_IB KO_pre_IB (KO_totalcells-KO_pre_U)-KO_pre_IB]; 
expected_IB_pre=[WT_IB_exp_pre (WT_totalcells-WT_pre_U)-WT_IB_exp_pre KO_IB_exp_pre (KO_totalcells-KO_pre_U)-KO_IB_exp_pre]; 

chi2stat_IB_pre=sum((observed_IB_pre-expected_IB_pre).^2 ./expected_IB_pre); 
p_IB_pre = 1 - chi2cdf(chi2stat_IB_pre,1);

%total prop ipsi and binoc- wt pre vs post 
p0_IB_WT=(WT_pre_IB+ WT_post_IB)/((WT_totalcells-WT_pre_U)+(WT_totalcells-WT_post_U));
WT_IB_exp_pre=(WT_totalcells-WT_pre_U)*p0_IB_WT; 
WT_IB_exp_post=(WT_totalcells-WT_post_U)*p0_IB_WT;

observed_IB_WT=[WT_pre_IB (WT_totalcells-WT_pre_U)-WT_pre_IB WT_post_IB (WT_totalcells-WT_post_U)-WT_post_IB]; 
expected_IB_WT=[WT_IB_exp_pre (WT_totalcells-WT_pre_U)-WT_IB_exp_pre WT_IB_exp_post (WT_totalcells-WT_post_U)-WT_IB_exp_post]; 

chi2stat_IB_WT=sum((observed_IB_WT-expected_IB_WT).^2 ./expected_IB_WT); 
p_IB_WT = 1 - chi2cdf(chi2stat_IB_WT,1);

%total prop ipsi and binoc - ko pre vs post 

p0_IB_KO=(KO_pre_IB+ KO_post_IB)/((KO_totalcells-KO_pre_U)+(KO_totalcells-KO_post_U));
KO_IB_exp_pre=(KO_totalcells-KO_pre_U)*p0_IB_KO; 
KO_IB_exp_post=(KO_totalcells-KO_post_U)*p0_IB_KO;

observed_IB_KO=[KO_pre_IB (KO_totalcells-KO_pre_U)-KO_pre_IB KO_post_IB (KO_totalcells-KO_post_U)-KO_post_IB]; 
expected_IB_KO=[KO_IB_exp_pre (KO_totalcells-KO_pre_U)-KO_IB_exp_pre KO_IB_exp_post (KO_totalcells-KO_post_U)-KO_IB_exp_post]; 

chi2stat_IB_KO=sum((observed_IB_KO-expected_IB_KO).^2 ./expected_IB_KO); 
p_IB_KO = 1 - chi2cdf(chi2stat_IB_KO,1);


%total prop IPSI+BINOC - post
p0_IB_post=(WT_post_IB+ KO_post_IB)/((WT_totalcells-WT_post_U)+(KO_totalcells-KO_post_U));
WT_IB_exp_post=(WT_totalcells-WT_post_U)*p0_IB_post; 
KO_IB_exp_post=(KO_totalcells-KO_post_U)*p0_IB_post;

observed_IB_post=[WT_post_IB (WT_totalcells-WT_post_U)-WT_post_IB KO_post_IB (KO_totalcells-KO_post_U)-KO_post_IB]; 
expected_IB_post=[WT_IB_exp_post (WT_totalcells-WT_post_U)-WT_IB_exp_post KO_IB_exp_post (KO_totalcells-KO_post_U)-KO_IB_exp_post]; 

chi2stat_IB_post=sum((observed_IB_post-expected_IB_post).^2 ./expected_IB_post); 
p_IB_post = 1 - chi2cdf(chi2stat_IB_post,1);


% Bonferroni correction 
%n=number of pairwise comparisons for binocular cells, which is n 
%alpha/n = new p-value for significance
p_corr_MD=0.05/ 2; 

p_corr_6WAYtotal=0.05/6; 

%put in mat file and save 
char_pvalues_UandIandBandC=strings(21,1); 
char_pvalues_UandIandBandC(1)= 'U_pre'; 
char_pvalues_UandIandBandC(2)= 'U_post'; 
char_pvalues_UandIandBandC(3)= 'WT_U'; 
char_pvalues_UandIandBandC(4)= 'KO_U'; 

char_pvalues_UandIandBandC(5)= 'I_pre'; 
char_pvalues_UandIandBandC(6)= 'I_post'; 
char_pvalues_UandIandBandC(7)= 'WT_I'; 
char_pvalues_UandIandBandC(8)= 'KO_I'; 

char_pvalues_UandIandBandC(9)= 'C_pre'; 
char_pvalues_UandIandBandC(10)= 'C_post'; 
char_pvalues_UandIandBandC(11)= 'WT_C'; 
char_pvalues_UandIandBandC(12)= 'KO_C'; 

char_pvalues_UandIandBandC(13)= 'B_pre'; 
char_pvalues_UandIandBandC(14)= 'B_post'; 
char_pvalues_UandIandBandC(15)= 'WT_B'; 
char_pvalues_UandIandBandC(16)= 'KO_B'; 

char_pvalues_UandIandBandC(17)= 'IB_pre'; 
char_pvalues_UandIandBandC(18)= 'IB_post'; 
char_pvalues_UandIandBandC(19)= 'IB_WT'; 
char_pvalues_UandIandBandC(20)= 'IB_KO'; 

char_pvalues_UandIandBandC(21)= 'p_corr_MD'; 
 

pvalues_cellprop_UandIandBandC=vertcat(p_U_pre, p_U_post, p_WT_U, p_KO_U,...
    p_I_pre, p_I_post, p_WT_I, p_KO_I,...
    p_C_pre, p_C_post, p_WT_C, p_KO_C,...
    p_B_pre, p_B_post, p_WT_B, p_KO_B,...
    p_IB_pre, p_IB_post, p_IB_WT, p_IB_KO, p_corr_6WAYtotal);
chi2_cellprop_UandIandBandC_results=table(char_pvalues_UandIandBandC, pvalues_cellprop_UandIandBandC);

%save
save(fullfile(SaveDir,'chi2_cellprop_UandIandBandC_results.mat'),'chi2_cellprop_UandIandBandC_results'); 
writetable(chi2_cellprop_UandIandBandC_results, fullfile(SaveDir,'chi2_cellprop_UandIandBandC_results.xls'),'WriteMode','overwritesheet'); 
% 
%put groups in an excel 


char_strings=strings(16,1); 
char_strings(1)= 'WT_pre_U'; 
char_strings(2)= 'WT_post_U'; 
char_strings(3)= 'KO_pre_U'; 
char_strings(4)= 'KO_post_U'; 

char_strings(5)= 'WT_pre_I'; 
char_strings(6)= 'WT_post_I'; 
char_strings(7)= 'KO_pre_I'; 
char_strings(8)= 'KO_post_I'; 

char_strings(9)=  'WT_pre_C'; 
char_strings(10)= 'WT_post_C'; 
char_strings(11)= 'KO_pre_C'; 
char_strings(12)= 'KO_post_C'; 

char_strings(13)= 'WT_pre_B'; 
char_strings(14)= 'WT_post_B'; 
char_strings(15)= 'KO_pre_B'; 
char_strings(16)= 'KO_post_B'; 

nums_cellprop=vertcat(WT_pre_U/WT_totalcells, WT_post_U/WT_totalcells, KO_pre_U/KO_totalcells, KO_post_U/KO_totalcells,...
    WT_pre_I/(WT_totalcells-WT_pre_U), WT_post_I/(WT_totalcells-WT_post_U), KO_pre_I/(KO_totalcells-KO_pre_U),KO_post_I/(KO_totalcells-KO_post_U),...
    WT_pre_C/(WT_totalcells-WT_pre_U),WT_post_C/(WT_totalcells-WT_post_U),KO_pre_C/(KO_totalcells-KO_pre_U),KO_post_C/(KO_totalcells-KO_post_U),...
    WT_pre_B/(WT_totalcells-WT_pre_U),WT_post_B/(WT_totalcells-WT_post_U),KO_pre_B/(KO_totalcells-KO_pre_U),KO_post_B/(KO_totalcells-KO_post_U));

nums_cellprop_results=table(char_strings, nums_cellprop);

save(fullfile(SaveDir,'nums_cellprop_results.mat'),'nums_cellprop_results'); 
writetable(nums_cellprop_results, fullfile(SaveDir,'nums_cellprop_results.xls'),'WriteMode','overwritesheet'); 

%% contralateral cell fate 
%C2I
p0_C2I_Cfate=(WT_C2I+KO_C2I)/(WT_Cfate+KO_Cfate);
WT_C2I_Cfate_exp=WT_Cfate*p0_C2I_Cfate; 
KO_C2I_Cfate_exp=KO_Cfate*p0_C2I_Cfate;

observed_C2I_Cfate=[WT_C2I WT_Cfate-WT_C2I KO_C2I KO_Cfate-KO_C2I]; 
expected_C2I_Cfate=[WT_C2I_Cfate_exp WT_Cfate-WT_C2I_Cfate_exp KO_C2I_Cfate_exp KO_Cfate-KO_C2I_Cfate_exp]; 

chi2stat_C2I_Cfate=sum((observed_C2I_Cfate-expected_C2I_Cfate).^2 ./expected_C2I_Cfate); 
p_C2I_Cfate = 1 - chi2cdf(chi2stat_C2I_Cfate,1);

clear WT_C2I_Cfate_exp; clear KO_C2I_Cfate_exp

%C2B
p0_C2B_Cfate=(WT_C2B+KO_C2B)/(WT_Cfate+KO_Cfate);
WT_C2B_Cfate_exp=WT_Cfate*p0_C2B_Cfate; 
KO_C2B_Cfate_exp=KO_Cfate*p0_C2B_Cfate;

observed_C2B_Cfate=[WT_C2B WT_Cfate-WT_C2B KO_C2B KO_Cfate-KO_C2B]; 
expected_C2B_Cfate=[WT_C2B_Cfate_exp WT_Cfate-WT_C2B_Cfate_exp KO_C2B_Cfate_exp KO_Cfate-KO_C2B_Cfate_exp]; 

chi2stat_C2B_Cfate=sum((observed_C2B_Cfate-expected_C2B_Cfate).^2 ./expected_C2B_Cfate); 
p_C2B_Cfate = 1 - chi2cdf(chi2stat_C2B_Cfate,1);

clear WT_C2B_Cfate; clear KO_C2B_Cfate_exp

%C2U
p0_C2U_Cfate=(WT_C2U+KO_C2U)/(WT_Cfate+KO_Cfate);
WT_C2U_Cfate_exp=WT_Cfate*p0_C2U_Cfate; 
KO_C2U_Cfate_exp=KO_Cfate*p0_C2U_Cfate;

observed_C2U_Cfate=[WT_C2U WT_Cfate-WT_C2U KO_C2U KO_Cfate-KO_C2U]; 
expected_C2U_Cfate=[WT_C2U_Cfate_exp WT_Cfate-WT_C2U_Cfate_exp KO_C2U_Cfate_exp KO_Cfate-KO_C2U_Cfate_exp]; 

chi2stat_C2U_Cfate=sum((observed_C2U_Cfate-expected_C2U_Cfate).^2 ./expected_C2U_Cfate); 
p_C2U_Cfate = 1 - chi2cdf(chi2stat_C2U_Cfate,1);

clear WT_C2U_Cfate_exp; clear KO_C2U_Cfate_exp

%WT-C2B vs C2I
p0_WT_C2BvsC2I=(WT_C2B+WT_C2I)/(WT_Cfate+WT_Cfate);
WT_C2B_exp=WT_Cfate*p0_WT_C2BvsC2I; 
WT_C2I_exp=WT_Cfate*p0_WT_C2BvsC2I;

observed_WT_C2BvsC2I=[WT_C2B WT_Cfate-WT_C2B WT_C2I WT_Cfate-WT_C2I]; 
expected_WT_C2BvsC2I=[WT_C2B_exp WT_Cfate-WT_C2B_exp WT_C2I_exp WT_Cfate-WT_C2I_exp]; 

chi2stat_WT_C2BvsC2I=sum((observed_WT_C2BvsC2I-expected_WT_C2BvsC2I).^2 ./expected_WT_C2BvsC2I); 
p_WT_C2BvsC2I = 1 - chi2cdf(chi2stat_WT_C2BvsC2I,1);

clear WT_C2I_exp; clear WT_C2B_exp

%WT-C2B vs C2U
p0_WT_C2BvsC2U=(WT_C2B+WT_C2U)/(WT_Cfate+WT_Cfate);
WT_C2B_exp=WT_Cfate*p0_WT_C2BvsC2U; 
WT_C2U_exp=WT_Cfate*p0_WT_C2BvsC2U;

observed_WT_C2BvsC2U=[WT_C2B WT_Cfate-WT_C2B WT_C2U WT_Cfate-WT_C2U]; 
expected_WT_C2BvsC2U=[WT_C2B_exp WT_Cfate-WT_C2B_exp WT_C2U_exp WT_Cfate-WT_C2U_exp]; 

chi2stat_WT_C2BvsC2U=sum((observed_WT_C2BvsC2U-expected_WT_C2BvsC2U).^2 ./expected_WT_C2BvsC2U); 
p_WT_C2BvsC2U = 1 - chi2cdf(chi2stat_WT_C2BvsC2U,1);

clear WT_C2B_exp; clear WT_C2U_exp

%WT-C2I vs C2U
p0_WT_C2UvsC2I=(WT_C2U+WT_C2I)/(WT_Cfate+WT_Cfate);
WT_C2I_exp=WT_Cfate*p0_WT_C2UvsC2I; 
WT_C2U_exp=WT_Cfate*p0_WT_C2UvsC2I;

observed_WT_C2IvsC2U=[WT_C2I WT_Cfate-WT_C2I WT_C2U WT_Cfate-WT_C2U]; 
expected_WT_C2IvsC2U=[WT_C2I_exp WT_Cfate-WT_C2I_exp WT_C2U_exp WT_Cfate-WT_C2U_exp]; 

chi2stat_WT_C2IvsC2U=sum((observed_WT_C2IvsC2U-expected_WT_C2IvsC2U).^2 ./expected_WT_C2IvsC2U); 
p_WT_C2IvsC2U = 1 - chi2cdf(chi2stat_WT_C2IvsC2U,1);

clear WT_C2I_exp; clear WT_C2U_exp

%KO-C2B vs C2I
p0_KO_C2BvsC2I=(KO_C2B+KO_C2I)/(KO_Cfate+KO_Cfate);
KO_C2B_exp=KO_Cfate*p0_KO_C2BvsC2I; 
KO_C2I_exp=KO_Cfate*p0_KO_C2BvsC2I;

observed_KO_C2BvsC2I=[KO_C2B KO_Cfate-KO_C2B KO_C2I KO_Cfate-KO_C2I]; 
expected_KO_C2BvsC2I=[KO_C2B_exp KO_Cfate-KO_C2B_exp KO_C2I_exp KO_Cfate-KO_C2I_exp]; 

chi2stat_KO_C2BvsC2I=sum((observed_KO_C2BvsC2I-expected_KO_C2BvsC2I).^2 ./expected_KO_C2BvsC2I); 
p_KO_C2BvsC2I = 1 - chi2cdf(chi2stat_KO_C2BvsC2I,1);

clear KO_C2B_exp; clear KO_C2I_exp

%KO-C2B vs C2U
p0_KO_C2BvsC2U=(KO_C2B+KO_C2U)/(KO_Cfate+KO_Cfate);
KO_C2B_exp=KO_Cfate*p0_KO_C2BvsC2U; 
KO_C2U_exp=KO_Cfate*p0_KO_C2BvsC2U;

observed_KO_C2BvsC2U=[KO_C2B KO_Cfate-KO_C2B KO_C2U KO_Cfate-KO_C2U]; 
expected_KO_C2BvsC2U=[KO_C2B_exp KO_Cfate-KO_C2B_exp KO_C2U_exp KO_Cfate-KO_C2U_exp]; 

chi2stat_KO_C2BvsC2U=sum((observed_KO_C2BvsC2U-expected_KO_C2BvsC2U).^2 ./expected_KO_C2BvsC2U); 
p_KO_C2BvsC2U = 1 - chi2cdf(chi2stat_KO_C2BvsC2U,1);

clear KO_C2B_exp; clear KO_C2U_exp

%KO-C2I vs C2U
p0_KO_C2UvsC2I=(KO_C2U+KO_C2I)/(KO_Cfate+KO_Cfate);
KO_C2I_exp=KO_Cfate*p0_KO_C2UvsC2I; 
KO_C2U_exp=KO_Cfate*p0_KO_C2UvsC2I;

observed_KO_C2IvsC2U=[KO_C2I KO_Cfate-KO_C2I KO_C2U KO_Cfate-KO_C2U]; 
expected_KO_C2IvsC2U=[KO_C2I_exp KO_Cfate-KO_C2I_exp KO_C2U_exp KO_Cfate-KO_C2U_exp]; 

chi2stat_KO_C2IvsC2U=sum((observed_KO_C2IvsC2U-expected_KO_C2IvsC2U).^2 ./expected_KO_C2IvsC2U); 
p_KO_C2IvsC2U = 1 - chi2cdf(chi2stat_KO_C2IvsC2U,1);

clear KO_C2I_exp; clear KO_C2U_exp

% 
% %C2C
% p0_C2C=(WT_C2C+KO_C2C)/(WT_Cfate+KO_Cfate);
% WT_C2C_exp=WT_Cfate*p0_C2C; 
% KO_C2C_exp=KO_Cfate*p0_C2C;
% 
% observed_C2C=[WT_C2C WT_Cfate-WT_C2C KO_C2C KO_Cfate-KO_C2C]; 
% expected_C2C=[WT_C2C_exp WT_Cfate-WT_C2C_exp KO_C2C_exp KO_Cfate-KO_C2C_exp]; 
% 
% chi2stat_C2C=sum((observed_C2C-expected_C2C).^2 ./expected_C2C); 
% p_C2C = 1 - chi2cdf(chi2stat_C2C,1);

% Bonferroni correction 
%n=number of pairwise comparisons for binocular cells, which is n 
%alpha/n = new p-value for significance
p_corr_C=0.05/ 6; 

%put in mat file and save 
char_pvalues_CONTRAfate=strings(4,1); 

char_pvalues_CONTRAfate(1)= 'C2I'; 
char_pvalues_CONTRAfate(2)= 'C2B'; 
char_pvalues_CONTRAfate(3)= 'C2U'; 
char_pvalues_CONTRAfate(4)= 'p_corr_C'; 

pvalues_CONTRAfate=vertcat(p_C2I, p_C2B, p_C2U, p_corr_C);
chi2_CONTRAfate_results=table(char_pvalues_CONTRAfate, pvalues_CONTRAfate);

%save
save(fullfile(SaveDir,'chi2_CONTRAfate_results.mat'),'chi2_CONTRAfate_results'); 
writetable(chi2_CONTRAfate_results, fullfile(SaveDir,'chi2_CONTRAfate_results.xls'),'WriteMode','overwritesheet'); 


% Bonferroni correction 
%n=number of pairwise comparisons for binocular cells, which is n 
%alpha/n = new p-value for significance
p_corr=0.05/ 6; 

%put in mat file and save 
char_pvalues_cellprop=strings(44,1); 

char_pvalues_cellprop(1)= 'U2I'; 
char_pvalues_cellprop(2)= 'B2I'; 
char_pvalues_cellprop(3)= 'C2I'; 
char_pvalues_cellprop(4)= 'U2B'; 
char_pvalues_cellprop(5)= 'I2B'; 
char_pvalues_cellprop(6)= 'C2B'; 
char_pvalues_cellprop(7)= 'B2U'; 
char_pvalues_cellprop(8)= 'I2U'; 
char_pvalues_cellprop(9)= 'C2U'; 
char_pvalues_cellprop(10)='B2M'; 
char_pvalues_cellprop(11)='M2B'; 
char_pvalues_cellprop(12)='B2B';
char_pvalues_cellprop(13)='R2I';
char_pvalues_cellprop(14)='WT_2I';
char_pvalues_cellprop(15)='KO_2I';
char_pvalues_cellprop(16)='R2B';
char_pvalues_cellprop(17)='WT_2B';
char_pvalues_cellprop(18)='KO_2B';
char_pvalues_cellprop(19)= 'p_corr'; 

char_pvalues_cellprop(20)='p_WT_U2IvsB2I'; 
char_pvalues_cellprop(21)='p_WT_C2IvsB2I';
char_pvalues_cellprop(22)='p_WT_C2IvsU2I';
char_pvalues_cellprop(23)='p_KO_U2IvsB2I';
char_pvalues_cellprop(24)='p_KO_C2IvsB2I';
char_pvalues_cellprop(25)='p_KO_C2IvsU2I';

char_pvalues_cellprop(26)='p_WT_C2UvsI2U'; 
char_pvalues_cellprop(27)='p_WT_C2UvsB2U';
char_pvalues_cellprop(28)='p_WT_B2UvsI2U';
char_pvalues_cellprop(29)='p_KO_C2UvsI2U';
char_pvalues_cellprop(30)='p_KO_C2UvsB2U';
char_pvalues_cellprop(31)='p_KO_B2UvsI2U';

char_pvalues_cellprop(32)='p_WT_C2BvsI2B'; 
char_pvalues_cellprop(33)='p_WT_C2BvsU2B';
char_pvalues_cellprop(34)='p_WT_U2BvsI2B';
char_pvalues_cellprop(35)='p_KO_C2BvsI2B';
char_pvalues_cellprop(36)='p_KO_C2BvsU2B';
char_pvalues_cellprop(37)='p_KO_U2BvsI2B';

char_pvalues_cellprop(38)='p_WT_C2BvsC2I'; 
char_pvalues_cellprop(39)='p_WT_C2BvsC2U';
char_pvalues_cellprop(40)='p_WT_C2IvsC2U';
char_pvalues_cellprop(41)='p_KO_C2BvsC2I';
char_pvalues_cellprop(42)='p_KO_C2BvsC2U';
char_pvalues_cellprop(43)='p_KO_C2IvsC2U';
char_pvalues_cellprop(44)='p_corr_6way';

p_corr_6way=0.05/6; 
pvalues_cellprop=vertcat(p_U2I, p_B2I, p_C2I, p_U2B, p_I2B, p_C2B, p_B2U,p_I2U, p_C2U, p_B2M,...
    p_M2B, p_B2B, p_R2I, p_2I_WT, p_2I_KO,p_R2B, p_2B_WT, p_2B_KO,p_corr,...
    p_WT_U2IvsB2I, p_WT_C2IvsB2I, p_WT_C2IvsU2I,p_KO_U2IvsB2I, p_KO_C2IvsB2I, p_KO_C2IvsU2I,...
    p_WT_C2UvsI2U, p_WT_C2UvsB2U, p_WT_B2UvsI2U,p_KO_C2UvsI2U, p_KO_C2UvsB2U,  p_KO_B2UvsI2U,...
    p_WT_C2BvsI2B, p_WT_C2BvsU2B, p_WT_U2BvsI2B, p_KO_C2BvsI2B,p_KO_C2BvsU2B, p_KO_U2BvsI2B,...
    p_WT_C2BvsC2I, p_WT_C2BvsC2U,p_WT_C2IvsC2U,p_KO_C2BvsC2I,p_KO_C2BvsC2U,p_KO_C2IvsC2U,p_corr_6way);
chi2_cellprop_results=table(char_pvalues_cellprop, pvalues_cellprop);


%save
save(fullfile(SaveDir,'Chi2_cellproportion.mat'),'chi2_cellprop_results'); 
writetable(chi2_cellprop_results, fullfile(SaveDir,'Chi2_cellproportion.xls'),'WriteMode','overwritesheet'); 

%put groups in an excel 
char_cellprop=strings(13,1); 

char_cellprop(1)= 'U2I'; 
char_cellprop(2)= 'B2I'; 
char_cellprop(3)= 'C2I';  
char_cellprop(4)= 'U2B'; 
char_cellprop(5)= 'I2B'; 
char_cellprop(6)= 'C2B'; 
char_cellprop(7)= 'B2U'; 
char_cellprop(8)= 'I2U'; 
char_cellprop(9)= 'C2U'; 
char_cellprop(10)='B2M'; 
char_cellprop(11)='M2B'; 
char_cellprop(12)='B2B';
char_cellprop(13)='R2I';



nums_cellprop_WT=vertcat(WT_U2I, WT_B2I, WT_C2I, WT_U2B, WT_I2B, WT_C2B, WT_B2U,WT_I2U,WT_C2U, WT_B2M, WT_M2B, WT_B2B, WT_R2I);
nums_cellprop_KO=vertcat(KO_U2I, KO_B2I, KO_C2I, KO_U2B, KO_I2B, KO_C2B, KO_B2U,KO_I2U,KO_C2U, KO_B2M, KO_M2B, KO_B2B, KO_R2I);
nums_cellprop_conversion_results=table(char_cellprop, nums_cellprop_WT, nums_cellprop_KO);

save(fullfile(SaveDir,'nums_cellprop_conversion_results.mat'),'nums_cellprop_conversion_results'); 
writetable(nums_cellprop_conversion_results, fullfile(SaveDir,'nums_cellprop_conversion_results.xls'),'WriteMode','overwritesheet'); 


%% total ipsilateral conversion and binocular conversion (new ipsi and new binoc cells)

fig_ipsilateralandbinocconversion=figure(22); 
%plot for ipsilateral cells 

categoriesIBconvtotal=categorical({'Ipsi', 'Binoc'}); 
categoriesIBconvtotal=reordercats(categoriesIBconvtotal, {'Ipsi', 'Binoc'}); 

Iconvtotal=[WT_Iconversion/WT_totalcells KO_Iconversion/KO_totalcells]; 
Bconvtotal=[WT_Bconversion/WT_totalcells KO_Bconversion/KO_totalcells]; 

y_IBconvtotal=[Iconvtotal; Bconvtotal]; 
bIBconv=bar(categoriesIBconvtotal,y_IBconvtotal, 0.9); 
hold on 
bIBconv(1).FaceColor=[0.3 0.3 0.3]; 
bIBconv(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 .15]); 
title('New Ipsilateral and Binocular')
legend('WT', 'KO'); 
box off; 

saveas(fig_ipsilateralandbinocconversion, fullfile(SaveDir,'IpsiBinocConversionTotal'),'pdf'); 
saveas(fig_ipsilateralandbinocconversion, fullfile(SaveDir,'IpsiBinocConversionTotal'),'tif');
saveas(fig_ipsilateralandbinocconversion, fullfile(SaveDir,'IpsiBinocConversionTotal'),'fig');


%p values 
%Ipsi conversion- WT vs KO
p0_Iconv=(WT_Iconversion+KO_Iconversion)/(WT_totalcells+KO_totalcells);
WT_Iconv_exp=WT_totalcells*p0_Iconv; 
KO_Iconv_exp=KO_totalcells*p0_Iconv;

observed_Iconv=[WT_Iconversion WT_totalcells-WT_Iconversion KO_Iconversion KO_totalcells-KO_Iconversion]; 
expected_Iconv=[WT_Iconv_exp WT_totalcells-WT_Iconv_exp KO_Iconv_exp KO_totalcells-KO_Iconv_exp]; 

chi2stat_Iconv=sum((observed_Iconv-expected_Iconv).^2 ./expected_Iconv); 
p_Iconv = 1 - chi2cdf(chi2stat_Iconv,1);


%p values 
%BinoC conversion
p0_Bconv=(WT_Bconversion+KO_Bconversion)/(WT_totalcells+KO_totalcells);
WT_Bconv_exp=WT_totalcells*p0_Bconv; 
KO_Bconv_exp=KO_totalcells*p0_Bconv;

observed_Bconv=[WT_Bconversion WT_totalcells-WT_Bconversion KO_Bconversion KO_totalcells-KO_Bconversion]; 
expected_Bconv=[WT_Bconv_exp WT_totalcells-WT_Bconv_exp KO_Bconv_exp KO_totalcells-KO_Bconv_exp]; 

chi2stat_Bconv=sum((observed_Bconv-expected_Bconv).^2 ./expected_Bconv); 
p_Bconv = 1 - chi2cdf(chi2stat_Bconv,1);

%put in mat file and save 
char_pvalues_IandBconvcellprop=strings(3,1); 

char_pvalues_IandBconvcellprop(1)= 'Iconv'; 
char_pvalues_IandBconvcellprop(2)= 'Bconv'; 
char_pvalues_IandBconvcellprop(3)= 'p_corr'; 


pvalues_cellpropIandBconv=vertcat(p_Iconv, p_Bconv, p_corr);
chi2_cellprop_IandBconv_results=table(char_pvalues_IandBconvcellprop, pvalues_cellpropIandBconv);


%save
save(fullfile(SaveDir,'Chi2_IandBconvcellproportion.mat'),'chi2_cellprop_IandBconv_results'); 
writetable(chi2_cellprop_IandBconv_results, fullfile(SaveDir,'chi2_cellprop_IandBconv_results.xls'),'WriteMode','overwritesheet'); 



end 


