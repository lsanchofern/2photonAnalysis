function compareMD (anim,preMDday, postMDday)
%anim is animal 
%preMDday is D2
%postMD day is D6
% function to compare cells across MD within an animal
%monocularity vs binocularity and tuning properties

%% set directories to load data from 
%set SaveDir for drifting gratings-preMD
global SaveDirpre
SaveDirpre = ['L:\Laura\AnalyzedData\calcium\drifting_gratings\', anim, '\', preMDday, '\'];
if exist(SaveDirpre,'dir') == 0
            mkdir(SaveDirpre)
end

%set SaveDir for flashing gratings- preMD
global SaveDir1pre
SaveDir1pre = ['L:\Laura\AnalyzedData\calcium\flashing_gratings\', anim, '\', preMDday, '\'];
if exist(SaveDir1pre,'dir') == 0
            mkdir(SaveDir1pre)
end

%set SaveDir for drifting gratings-postMD
global SaveDirpost
SaveDirpost = ['L:\Laura\AnalyzedData\calcium\drifting_gratings\', anim, '\', postMDday, '\'];
if exist(SaveDirpost,'dir') == 0
            mkdir(SaveDirpost)
end

%set SaveDir for flashing gratings- postMD
global SaveDir1post
SaveDir1post = ['L:\Laura\AnalyzedData\calcium\flashing_gratings\', anim, '\', postMDday, '\'];
if exist(SaveDir1post,'dir') == 0
            mkdir(SaveDir1post)
end

%set SaveDir for drifting gratings- cell identity 
global SaveDir 
SaveDir=['L:\Laura\AnalyzedData\calcium\drifting_gratings\', anim, '\']; 
if exist(SaveDir,'dir')==0
    mkdir (SaveDir)
end


%% load the structures 

preMD_responseCV_contra=dir(fullfile(SaveDirpre,'*_response_CV_contra_resp_mean.mat')) %load reliabilty metrics 
responseCV_preMD_contra=load(fullfile(SaveDirpre,preMD_responseCV_contra.name)); 
preMD_responseCV_ipsi=dir(fullfile(SaveDirpre,'*_response_CV_ipsi_resp_mean.mat')) %load reliabilty metrics 
responseCV_preMD_ipsi=load(fullfile(SaveDirpre,preMD_responseCV_ipsi.name)); 

preMD_dFoFfile=dir(fullfile(SaveDirpre,'*_SigCellsDrift.mat')); %load sig. responsive cells 
dFoF_preMD=load(fullfile(SaveDirpre, preMD_dFoFfile.name)); 
preMD_cellsfile=dir(fullfile(SaveDirpre,'*_dFoF.mat')); %load all cells 
pre_Allcells=load(fullfile(SaveDirpre,preMD_cellsfile.name)); 
preMD_ID_cellsfile=dir(fullfile(SaveDirpre,'*_indices.mat')); %load all indices 
pre_ind=load(fullfile(SaveDirpre,preMD_ID_cellsfile.name)); 
pre_cellstatfile=dir(fullfile(SaveDirpre,'*_cellstats.mat'));%load cell stats 
pre_cellstats=load(fullfile(SaveDirpre,pre_cellstatfile.name)); 
pre_meanimgfile=dir(fullfile(SaveDirpre,'*_meanImage.mat'));%load mean image 
pre_meanimg=load(fullfile(SaveDirpre,pre_meanimgfile.name)); 

% preMD_spksfile=dir(fullfile(SaveDirpre,'*_spks.mat')); %load sig. responsive cells 
% spks_preMD=load(fullfile(SaveDirpre, preMD_spksfile.name)); 

postMD_responseCV_contra=dir(fullfile(SaveDirpost,'*_response_CV_contra_resp_mean.mat')) %load reliabilty metrics 
responseCV_postMD_contra=load(fullfile(SaveDirpost,postMD_responseCV_contra.name)); 
postMD_responseCV_ipsi=dir(fullfile(SaveDirpost,'*_response_CV_ipsi_resp_mean.mat')) %load reliabilty metrics 
responseCV_postMD_ipsi=load(fullfile(SaveDirpost,postMD_responseCV_ipsi.name)); 

postMD_dFoFfile=dir(fullfile(SaveDirpost,'*_SigCellsDrift.mat'));
dFoF_postMD=load(fullfile(SaveDirpost, postMD_dFoFfile.name));
postMD_cellsfile=dir(fullfile(SaveDirpost,'*_dFoF.mat'));
post_Allcells=load(fullfile(SaveDirpost,postMD_cellsfile.name)); 
postMD_ID_cellsfile=dir(fullfile(SaveDirpost,'*_indices.mat')); %load all indices 
post_ind=load(fullfile(SaveDirpost,postMD_ID_cellsfile.name)); 
post_cellstatfile=dir(fullfile(SaveDirpost,'*_cellstats.mat'));%load cell stats 
post_cellstats=load(fullfile(SaveDirpost,post_cellstatfile.name)); 
post_meanimgfile=dir(fullfile(SaveDirpost,'*_meanImage.mat'));%load mean image 
post_meanimg=load(fullfile(SaveDirpost,post_meanimgfile.name)); 

% postMD_spksfile=dir(fullfile(SaveDirpost,'*_spks.mat')); %load sig. responsive cells 
% spks_postMD=load(fullfile(SaveDirpost, postMD_spksfile.name)); 

%% load longitudinally matched cells 

AnalDir = ['L:\Laura\ToAnalyze\', anim, '\'];
if exist(AnalDir,'dir') == 0
            mkdir(AnalDir)
end

match= dir (fullfile(AnalDir,'*.mat'));
match=load(fullfile(AnalDir,match.name)); 

%% load spiking data - FLASHING GRATINGS
% preMD_flash_contra_csv=dir(fullfile (SaveDirpre, '*_contra_trial.csv'));
% preMD_flash_contra=table2array(readtable(fullfile(SaveDirpre, preMD_flash_contra_csv.name)));
% 
% postMD_flash_contra_csv=dir(fullfile (SaveDirpost, '*_contra_trial.csv'));
% postMD_flash_contra=table2array(readtable(fullfile(SaveDirpost, postMD_flash_contra_csv.name)));
% 
% preMD_flash_ipsi_csv=dir(fullfile (SaveDirpre, '*_ipsi_trial.csv'));
% preMD_flash_ipsi=table2array(readtable(fullfile(SaveDirpre, preMD_flash_ipsi_csv.name)));
% 
% postMD_flash_ipsi_csv=dir(fullfile (SaveDirpost, '*_ipsi_trial.csv'));
% postMD_flash_ipsi=table2array(readtable(fullfile(SaveDirpost, postMD_flash_ipsi_csv.name)));
% 
% %cell responsivity 
% preMD_flash_resp_csv=dir(fullfile (SaveDirpre, '*_resp.csv'));
% preMD_flash_resp=table2array(readtable(fullfile(SaveDirpre, preMD_flash_resp_csv.name)));
% 
% postMD_flash_resp_csv=dir(fullfile (SaveDirpre, '*_resp.csv'));
% postMD_flash_resp=table2array(readtable(fullfile(SaveDirpre, postMD_flash_resp_csv.name)));

%% load spiking data - DRIFTING GRATINGS 

%full trace - activity and noise 
preMD_drift_contra_csv=dir(fullfile (SaveDirpre, '*_drift_spks_contra.csv'));
preMD_drift_contra=table2array(readtable(fullfile(SaveDirpre, preMD_drift_contra_csv.name)));

postMD_drift_contra_csv=dir(fullfile (SaveDirpost, '*_drift_spks_contra.csv'));
postMD_drift_contra=table2array(readtable(fullfile(SaveDirpost, postMD_drift_contra_csv.name)));

preMD_drift_ipsi_csv=dir(fullfile (SaveDirpre, '*_drift_spks_ipsi.csv'));
preMD_drift_ipsi=table2array(readtable(fullfile(SaveDirpre, preMD_drift_ipsi_csv.name)));

postMD_drift_ipsi_csv=dir(fullfile (SaveDirpost, '*_drift_spks_ipsi.csv'));
postMD_drift_ipsi=table2array(readtable(fullfile(SaveDirpost, postMD_drift_ipsi_csv.name)));

%only trial on traces - activity 
preMD_drift_trial_contra_csv=dir(fullfile (SaveDirpre, '*_drift_spks_trial_contra.csv'));
preMD_drift_trial_contra=table2array(readtable(fullfile(SaveDirpre, preMD_drift_trial_contra_csv.name)));

postMD_drift_trial_contra_csv=dir(fullfile (SaveDirpost, '*_drift_spks_trial_contra.csv'));
postMD_drift_trial_contra=table2array(readtable(fullfile(SaveDirpost, postMD_drift_trial_contra_csv.name)));

preMD_drift_trial_ipsi_csv=dir(fullfile (SaveDirpre, '*_drift_spks_trial_ipsi.csv'));
preMD_drift_trial_ipsi=table2array(readtable(fullfile(SaveDirpre, preMD_drift_trial_ipsi_csv.name)));

postMD_drift_trial_ipsi_csv=dir(fullfile (SaveDirpost, '*_drift_spks_trial_ipsi.csv'));
postMD_drift_trial_ipsi=table2array(readtable(fullfile(SaveDirpost, postMD_drift_trial_ipsi_csv.name)));

%% Did the cell identity change with MD? 

matchcells=match.roiMatchData.allSessionMapping; 
pre_ID=1:1:length(pre_Allcells.dFoF.drift.contra.conds(1).cells); %list of cells before MD
post_ID=1:1:length(post_Allcells.dFoF.drift.contra.conds(1).cells); %list of cells after MD 

% %for all cells present in pre and post MD datasets, not necessarily
% responsive 
pre_long_ID=pre_ID(matchcells(:,1)); %use matchcells to index into it
post_long_ID=post_ID(matchcells(:,2)); 

percent_tracked=(length(pre_long_ID)/length(pre_ID))*100; 
save(fullfile(SaveDir, strcat(anim, '_percent_tracked.mat')), 'percent_tracked');
preMD_trace_contra=zeros(length(dFoF_preMD.SigCellsDrift.AllCells),16,30); 
preMD_trace_ipsi=zeros(length(dFoF_preMD.SigCellsDrift.AllCells),16,30);
postMD_trace_contra=zeros(length(dFoF_postMD.SigCellsDrift.AllCells),16,30); 
postMD_trace_ipsi=zeros(length(dFoF_postMD.SigCellsDrift.AllCells),16,30);


for i=1:length(dFoF_preMD.SigCellsDrift.AllCells)
    preMD_ID(i)= dFoF_preMD.SigCellsDrift.AllCells(i).ID;
    preMD_OD(i)= dFoF_preMD.SigCellsDrift.AllCells(i).odscore;   
    preMD_dFoF_contra(i)=dFoF_preMD.SigCellsDrift.AllCells(i).oripeak.contra; 
    preMD_dFoF_ipsi(i)=dFoF_preMD.SigCellsDrift.AllCells(i).oripeak.ipsi; 
    preMD_OSI_contra(i)=dFoF_preMD.SigCellsDrift.AllCells(i).cv_ori.contra; 
    preMD_OSI_ipsi(i)=dFoF_preMD.SigCellsDrift.AllCells(i).cv_ori.ipsi; 
    preMD_DSI_contra(i)=dFoF_preMD.SigCellsDrift.AllCells(i).cv_dir.contra; 
    preMD_DSI_ipsi(i)=dFoF_preMD.SigCellsDrift.AllCells(i).cv_dir.ipsi; 
    for j=1:16 %16 oris
        preMD_trace_contra(i,j,:)= dFoF_preMD.SigCellsDrift.AllCells(i).ori(j).avgtrace.contra(1:30)';
        preMD_trace_ipsi(i,j,:)=dFoF_preMD.SigCellsDrift.AllCells(i).ori(j).avgtrace.ipsi(1:30)';
    end
end 

for i=1:length(dFoF_postMD.SigCellsDrift.AllCells)
    postMD_ID(i)= dFoF_postMD.SigCellsDrift.AllCells(i).ID;
    postMD_OD(i)= dFoF_postMD.SigCellsDrift.AllCells(i).odscore;   
    postMD_dFoF_contra(i)=dFoF_postMD.SigCellsDrift.AllCells(i).oripeak.contra; 
    postMD_dFoF_ipsi(i)=dFoF_postMD.SigCellsDrift.AllCells(i).oripeak.ipsi;
    postMD_OSI_contra(i)=dFoF_postMD.SigCellsDrift.AllCells(i).cv_ori.contra; 
    postMD_OSI_ipsi(i)=dFoF_postMD.SigCellsDrift.AllCells(i).cv_ori.ipsi; 
    postMD_DSI_contra(i)=dFoF_postMD.SigCellsDrift.AllCells(i).cv_dir.contra; 
    postMD_DSI_ipsi(i)=dFoF_postMD.SigCellsDrift.AllCells(i).cv_dir.ipsi; 
    for j=1:16 %16 oris
        postMD_trace_contra(i,j,:)=dFoF_postMD.SigCellsDrift.AllCells(i).ori(j).avgtrace.contra(1:30)';
        postMD_trace_ipsi(i,j,:)=dFoF_postMD.SigCellsDrift.AllCells(i).ori(j).avgtrace.ipsi(1:30)';
    end
end

%save all significant cells REGARDLESS of whether longitudinally tracked or
%not 
save(fullfile(SaveDirpre, strcat(anim, '_OD_pre_AllCells.mat')), 'preMD_OD');
save(fullfile(SaveDirpost, strcat(anim, '_OD_post_AllCells.mat')), 'postMD_OD');

save(fullfile(SaveDirpre, strcat(anim, '_dFoF_contra_pre_AllCells.mat')), 'preMD_dFoF_contra');
save(fullfile(SaveDirpre, strcat(anim, '_dFoF_ipsi_pre_AllCells.mat')), 'preMD_dFoF_ipsi');

save(fullfile(SaveDirpost, strcat(anim, '_dFoF_contra_post_AllCells.mat')), 'postMD_dFoF_contra');
save(fullfile(SaveDirpost, strcat(anim, '_dFoF_ipsi_post_AllCells.mat')), 'postMD_dFoF_ipsi');

save(fullfile(SaveDirpre, strcat(anim, '_preMD_OSI_contra_AllCells.mat')), 'preMD_OSI_contra');
save(fullfile(SaveDirpost, strcat(anim, '_postMD_OSI_contra_AllCells.mat')), 'postMD_OSI_contra');

save(fullfile(SaveDirpre, strcat(anim, '_preMD_DSI_contra_AllCells.mat')), 'preMD_DSI_contra');
save(fullfile(SaveDirpost, strcat(anim, '_postMD_DSI_contra_AllCells.mat')), 'postMD_DSI_contra');

save(fullfile(SaveDirpre, strcat(anim, '_preMD_OSI_ipsi_AllCells.mat')), 'preMD_OSI_ipsi');
save(fullfile(SaveDirpost, strcat(anim, '_postMD_OSI_ipsi_AllCells.mat')), 'postMD_OSI_ipsi');

save(fullfile(SaveDirpre, strcat(anim, '_preMD_DSI_ipsi_AllCells.mat')), 'preMD_DSI_ipsi');
save(fullfile(SaveDirpost, strcat(anim, '_postMD_DSI_ipsi_AllCells.mat')), 'postMD_DSI_ipsi');

%now take mouse medians 
median_preMD_OD=median(preMD_OD); 
median_postMD_OD=median(postMD_OD);

mean_preMD_dFoF_contra=mean(preMD_dFoF_contra); 
mean_preMD_dFoF_ipsi=mean(preMD_dFoF_ipsi);

mean_postMD_dFoF_contra=mean(postMD_dFoF_contra); 
mean_postMD_dFoF_ipsi=mean(postMD_dFoF_ipsi);

%save mouse averages
save(fullfile(SaveDirpre, strcat(anim, '_median_preMD_OD.mat')), 'median_preMD_OD');
save(fullfile(SaveDirpost, strcat(anim, '_median_postMD_OD.mat')), 'median_postMD_OD');

save(fullfile(SaveDirpre, strcat(anim, '_mean_preMD_dFoF_contra.mat')), 'mean_preMD_dFoF_contra');
save(fullfile(SaveDirpre, strcat(anim, '_mean_preMD_dFoF_ipsi.mat')), 'mean_preMD_dFoF_ipsi');

save(fullfile(SaveDirpost, strcat(anim, '_mean_postMD_dFoF_contra.mat')), 'mean_postMD_dFoF_contra');
save(fullfile(SaveDirpost, strcat(anim, '_mean_postMD_dFoF_ipsi.mat')), 'mean_postMD_dFoF_ipsi');


cellstats_pre_allresp=cell(1,length(preMD_ID)); 
cellstats_post_allresp=cell(1,length(postMD_ID));

for i=1:length(preMD_ID)
    cellstats_pre_all{1,i}=pre_cellstats.cell_stat{1,preMD_ID((i))}; 
end 
for i=1:length(postMD_ID)
    cellstats_post_all{1,i}=post_cellstats.cell_stat{1,postMD_ID((i))}; 
end 

%  binocular matching and dir and ori tuning for binocular cells only 

for i=1:length(dFoF_preMD.SigCellsDrift.BinocCell)
    preMD_binoc_ID(i)= dFoF_preMD.SigCellsDrift.BinocCell(i).ID;
    preMD_binoc_contra_cv(i)=dFoF_preMD.SigCellsDrift.BinocCell(i).cv_ori.contra;
    preMD_binoc_ipsi_cv(i)=dFoF_preMD.SigCellsDrift.BinocCell(i).cv_ori.ipsi;
    pre_ori_pref_contra(i)=dFoF_preMD.SigCellsDrift.BinocCell(i).pref_ori.contra;
    pre_ori_pref_ipsi(i)=dFoF_preMD.SigCellsDrift.BinocCell(i).pref_ori.ipsi;
    for j=1:16
        pre_ori_bin_contra(i,j)=dFoF_preMD.SigCellsDrift.BinocCell(i).ori(j).peak.contra; 
        pre_ori_bin_ipsi(i,j)=dFoF_preMD.SigCellsDrift.BinocCell(i).ori(j).peak.ipsi; 
        
        pre_ori_avg_bin_contra(i,j,:)=mean(dFoF_preMD.SigCellsDrift.BinocCell(i).ori(j).trace.contra, 2); 
        pre_ori_avg_bin_ipsi(i,j,:)=mean(dFoF_preMD.SigCellsDrift.BinocCell(i).ori(j).trace.ipsi,2); 
    end
end

for i=1:length(dFoF_postMD.SigCellsDrift.BinocCell)
    postMD_binoc_ID(i)= dFoF_postMD.SigCellsDrift.BinocCell(i).ID;
    postMD_binoc_contra_cv(i)=dFoF_postMD.SigCellsDrift.BinocCell(i).cv_ori.contra;
    postMD_binoc_ipsi_cv(i)=dFoF_postMD.SigCellsDrift.BinocCell(i).cv_ori.ipsi;
    post_ori_pref_contra(i)=dFoF_postMD.SigCellsDrift.BinocCell(i).pref_ori.contra;
    post_ori_pref_ipsi(i)=dFoF_postMD.SigCellsDrift.BinocCell(i).pref_ori.ipsi;
    for j=1:16
        post_ori_bin_contra(i,j)=dFoF_postMD.SigCellsDrift.BinocCell(i).ori(j).peak.contra; 
        post_ori_bin_ipsi(i,j)=dFoF_postMD.SigCellsDrift.BinocCell(i).ori(j).peak.ipsi; 

        post_ori_avg_bin_contra(i,j,:)=mean(dFoF_postMD.SigCellsDrift.BinocCell(i).ori(j).trace.contra, 2); 
        post_ori_avg_bin_ipsi(i,j,:)=mean(dFoF_postMD.SigCellsDrift.BinocCell(i).ori(j).trace.ipsi,2); 
    end
end



%save all binocular responses regardless of whether long. tracked
save(fullfile(SaveDirpre, strcat(anim, '_Oripref_pre_contra_AllCells.mat')), 'pre_ori_pref_contra');
save(fullfile(SaveDirpre, strcat(anim, '_Oripref_pre_ipsi_AllCells.mat')), 'pre_ori_pref_ipsi');
save(fullfile(SaveDirpost, strcat(anim, '_Oripref_post_contra_AllCells.mat')), 'post_ori_pref_contra');
save(fullfile(SaveDirpost, strcat(anim, '_Oripref_post_ipsi_AllCells.mat')), 'post_ori_pref_ipsi');



OD_pre=[]; 
OD_post=[]; 
OSI_pre_contra=[]; 
OSI_pre_ipsi=[]; 
OSI_post_contra=[]; 
OSI_post_ipsi=[]; 

DSI_pre_contra=[]; 
DSI_pre_ipsi=[]; 
DSI_post_contra=[]; 
DSI_post_ipsi=[]; 

Oripref_pre_contra_only=[]; %for contralateral and ipsilateral cells only 
Oripref_pre_ipsi_only=[]; 
Oripref_post_contra_only=[]; 
Oripref__post_ipsi_only=[]; 

Oripref_pre_contra=[]; %for binocular cells 
Oripref_pre_ipsi=[]; 
Oripref_post_contra=[]; 
Oripref__post_ipsi=[]; 

cv_pre_contra_only=[]; %for contralateral and ipsilateral cells only 
cv_pre_ipsi_only=[]; 
cv_post_contra_only=[]; 
cv_post_ipsi_only=[]; 

cv_pre_contra=[]; %for binocular cells 
cv_pre_ipsi=[]; 
cv_post_contra=[]; 
cv_post_ipsi=[]; 

ori_pre_contra_only=[]; %for contralateral and ipsilateral cells only 
ori_pre_ipsi_only=[]; 
ori_post_contra_only=[]; 
ori_post_ipsi_only=[]; 

ori_pre_contra=[]; %for binocular cells 
ori_pre_ipsi=[]; 
ori_post_contra=[]; 
ori_post_ipsi=[]; 


%for OCULAR DOMINANCE INDEX 
[ID_pre,ind_preMD,ind_longpre]=intersect(preMD_ID,matchcells(:,1)); %cells located pre MD that are responsive
[ID_post,ind_postMD,ind_longpost]=intersect(postMD_ID,matchcells(:,2)); %cells located post MD that are responsive 

ind_long=intersect(ind_longpre,ind_longpost); %where were the indices the same? indicating the same longitudinally tracked cell, even though the cell ID changes 

%cell IDs of actual long. tracked cells that were responsive
long_pre=matchcells(ind_long,1); 
long_post=matchcells(ind_long,2);

[~,ind_pre]=ismember(long_pre,preMD_ID'); %where are the cells 
[~,ind_post]=ismember(long_post,postMD_ID'); %where are the cells 

dFoF_contra_pre=preMD_dFoF_contra(ind_pre); 
dFoF_contra_post=postMD_dFoF_contra(ind_post); 
dFoF_ipsi_pre=preMD_dFoF_ipsi(ind_pre); 
dFoF_ipsi_post=postMD_dFoF_ipsi(ind_post); 

%response reliability 
reliability_preMD_contra=responseCV_preMD_contra.response_CV_contra_resp_mean (ind_pre); 
reliability_postMD_contra=responseCV_postMD_contra.response_CV_contra_resp_mean(ind_post); 

reliability_preMD_ipsi=responseCV_preMD_ipsi.response_CV_ipsi_resp_mean (ind_pre); 
reliability_postMD_ipsi=responseCV_postMD_ipsi.response_CV_ipsi_resp_mean(ind_post); 

save(fullfile(SaveDirpre, strcat(anim, '_reliability_preMD_contra.mat')), 'reliability_preMD_contra');
save(fullfile(SaveDirpost, strcat(anim, '_reliability_postMD_contra.mat')), 'reliability_postMD_contra');

save(fullfile(SaveDirpre, strcat(anim, '_reliability_preMD_ipsi.mat')), 'reliability_preMD_ipsi');
save(fullfile(SaveDirpost, strcat(anim, '_reliability_postMD_ipsi.mat')), 'reliability_postMD_ipsi');
% spiking data-drifting gratings 

%full trace
spks_drift_contra_pre=preMD_drift_contra(ind_pre,:); 
spks_drift_ipsi_pre=preMD_drift_ipsi(ind_pre,:); 
spks_drift_contra_post=postMD_drift_contra(ind_post,:); 
spks_drift_ipsi_post=postMD_drift_ipsi(ind_post,:); 

%just trial on 
spks_drift_trial_contra_pre=preMD_drift_trial_contra(ind_pre,:); 
spks_drift_trial_ipsi_pre=preMD_drift_trial_ipsi(ind_pre,:); 
spks_drift_trial_contra_post=postMD_drift_trial_contra(ind_post,:); 
spks_drift_trial_ipsi_post=postMD_drift_trial_ipsi(ind_post,:); 

dfof_contra_pre_on=preMD_trace_contra(ind_pre,:,:);
dfof_ipsi_pre_on=preMD_trace_ipsi(ind_pre,:,:);
dfof_contra_post_on=postMD_trace_contra(ind_post,:,:);
dfof_ipsi_post_on=postMD_trace_ipsi(ind_post,:,:);



dfof_contra_pre_on=permute(dfof_contra_pre_on,[1 3 2]);
dfof_contra_pre_on=reshape(dfof_contra_pre_on,[],16*30);
dfof_contra_post_on=permute(dfof_contra_post_on,[1 3 2]);
dfof_contra_post_on=reshape(dfof_contra_post_on,[],16*30);

dfof_ipsi_pre_on=permute(dfof_ipsi_pre_on,[1 3 2]);
dfof_ipsi_pre_on=reshape(dfof_ipsi_pre_on,[],16*30);
dfof_ipsi_post_on=permute(dfof_ipsi_post_on,[1 3 2]);
dfof_ipsi_post_on=reshape(dfof_ipsi_post_on,[],16*30);


writematrix(spks_drift_contra_pre,fullfile(SaveDir,strcat(anim, '_preMD_contra_spks.csv'))); 
writematrix(spks_drift_ipsi_pre,fullfile(SaveDir,strcat(anim, '_preMD_ipsi_spks.csv'))); 
writematrix(spks_drift_contra_post,fullfile(SaveDir,strcat(anim, '_postMD_contra_spks.csv'))); 
writematrix(spks_drift_ipsi_post,fullfile(SaveDir,strcat(anim, '_postMD_ipsi_spks.csv'))); 

writematrix(spks_drift_trial_contra_pre,fullfile(SaveDir,strcat(anim, '_preMD_drift_trial_contra.csv'))); 
writematrix(spks_drift_trial_ipsi_pre,fullfile(SaveDir,strcat(anim, '_preMD_drift_trial_ipsi.csv'))); 
writematrix(spks_drift_trial_contra_post,fullfile(SaveDir,strcat(anim, '_postMD_drift_trial_contra.csv'))); 
writematrix(spks_drift_trial_ipsi_post,fullfile(SaveDir,strcat(anim, '_postMD_drift_trial_ipsi.csv'))); 

writematrix(dfof_contra_pre_on,fullfile(SaveDir,strcat(anim, '_dfof_contra_pre_on.csv'))); 
writematrix(dfof_contra_post_on,fullfile(SaveDir,strcat(anim, '_dfof_contra_post_on.csv'))); 
writematrix(dfof_ipsi_pre_on,fullfile(SaveDir,strcat(anim, '_dfof_ipsi_pre_on.csv'))); 
writematrix(dfof_ipsi_post_on,fullfile(SaveDir,strcat(anim, '_dfof_ipsi_post_on.csv'))); 


%%spiking data 

% spks_ind_pre_ID=find(preMD_flash_resp);
% spks_ind_post_ID=find(postMD_flash_resp);
% 
% [ID_pre_spks,ind_preMD_spks,ind_longpre_spks]=intersect(spks_ind_pre_ID,matchcells(:,1)); %cells located pre MD that are responsive
% [ID_post_spks,ind_postMD_spks,ind_longpost_spks]=intersect(spks_ind_post_ID,matchcells(:,2)); %cells located post MD that are responsive 
% 
% ind_long_spks=intersect(ind_longpre_spks,ind_longpost_spks); %where were the indices the same? indicating the same longitudinally tracked cell, even though the cell ID changes 
% 
% %cell IDs of actual long. tracked cells that were responsive
% long_pre_spks=matchcells(ind_long_spks,1); 
% long_post_spks=matchcells(ind_long_spks,2);
% 
% [~,ind_pre_spks]=ismember(long_pre_spks,spks_ind_pre_ID'); %where are the cells 
% [~,ind_post_spks]=ismember(long_post_spks,spks_ind_post_ID'); %where are the cells 
% 
% 
% spiking_preMD_flash_contra=preMD_flash_contra(ind_pre_spks,:); 
% spiking_preMD_flash_ipsi=preMD_flash_ipsi(ind_pre_spks,:); 
% spiking_postMD_flash_contra=postMD_flash_contra(ind_post_spks,:); 
% spiking_postMD_flash_ipsi=postMD_flash_ipsi(ind_post_spks,:); 



save(fullfile(SaveDirpre, strcat(anim, '_dFoF_contra_pre.mat')), 'dFoF_contra_pre');
save(fullfile(SaveDirpre, strcat(anim, '_dFoF_ipsi_pre.mat')), 'dFoF_ipsi_pre');

save(fullfile(SaveDirpost, strcat(anim, '_dFoF_contra_post.mat')), 'dFoF_contra_post');
save(fullfile(SaveDirpost, strcat(anim, '_dFoF_ipsi_post.mat')), 'dFoF_ipsi_post');


OD_pre=preMD_OD(ind_pre);
OD_post=postMD_OD(ind_post);

cellstats_pre=cell(1,length(ind_pre)); 
cellstats_post=cell(1,length(ind_post));

for i=1:length(ind_pre)
    cellstats_pre{1,i}=pre_cellstats.cell_stat{1,preMD_ID(ind_pre(i))}; 
    cellstats_post{1,i}=post_cellstats.cell_stat{1,postMD_ID(ind_post(i))}; 
end 

% for cell identity changes, all cells longitidunally tracked, not
% necessary responsive 
cellstats_pre_ident=cell(1,length(pre_long_ID)); 
cellstats_post_ident=cell(1,length(post_long_ID));

for i=1:length(pre_long_ID)
    cellstats_pre_ident{1,i}=pre_cellstats.cell_stat{1,pre_ID(pre_long_ID(i))}; 
    cellstats_post_ident{1,i}=post_cellstats.cell_stat{1,post_ID(post_long_ID(i))}; 
end 


%tuning properties for  cells,  not necessarily responsive because we
%also want properties for cells that become unresponsive 
OSI_pre_contra=preMD_OSI_contra(ind_pre); 
OSI_pre_ipsi=preMD_OSI_ipsi(ind_pre);
OSI_post_contra=postMD_OSI_contra(ind_post); 
OSI_post_ipsi=postMD_OSI_ipsi(ind_post);

DSI_pre_contra=preMD_DSI_contra(ind_pre); 
DSI_pre_ipsi=preMD_DSI_ipsi(ind_pre);
DSI_post_contra=postMD_DSI_contra(ind_post); 
DSI_post_ipsi=postMD_DSI_ipsi(ind_post);

% orientation preference 
pre_ori_contra_only=zeros(length(dFoF_preMD.SigCellsDrift.ContraCell),16);
%for contralateral cells 
for i=1:length(dFoF_preMD.SigCellsDrift.ContraCell)
    preMD_contra_ID(i)= dFoF_preMD.SigCellsDrift.ContraCell(i).ID;
    pre_ori_pref_contra_only(i)=dFoF_preMD.SigCellsDrift.ContraCell(i).pref_ori;
    pre_cv_contra_only(i)=dFoF_preMD.SigCellsDrift.ContraCell(i).cv_ori;
    for j=1:16
        pre_ori_contra_only(i,j)=dFoF_preMD.SigCellsDrift.ContraCell(i).ori(j).peak; 
    end
end

for i=1:length(dFoF_postMD.SigCellsDrift.ContraCell)
    postMD_contra_ID(i)= dFoF_postMD.SigCellsDrift.ContraCell(i).ID;
    post_ori_pref_contra_only(i)=dFoF_postMD.SigCellsDrift.ContraCell(i).pref_ori;
    post_cv_contra_only(i)=dFoF_postMD.SigCellsDrift.ContraCell(i).cv_ori;
     for j=1:16
        post_ori_contra_only(i,j)=dFoF_postMD.SigCellsDrift.ContraCell(i).ori(j).peak; 
    end
end

%for ipsilateral cells 
for i=1:length(dFoF_preMD.SigCellsDrift.IpsiCell)
    preMD_ipsi_ID(i)= dFoF_preMD.SigCellsDrift.IpsiCell(i).ID;
    pre_ori_pref_ipsi_only(i)=dFoF_preMD.SigCellsDrift.IpsiCell(i).pref_ori;
    pre_cv_ipsi_only(i)=dFoF_preMD.SigCellsDrift.IpsiCell(i).cv_ori;
    for j=1:16
        pre_ori_ipsi_only(i,j)=dFoF_preMD.SigCellsDrift.IpsiCell(i).ori(j).peak; 
    end
end

for i=1:length(dFoF_postMD.SigCellsDrift.IpsiCell)
    postMD_ipsi_ID(i)= dFoF_postMD.SigCellsDrift.IpsiCell(i).ID;
    post_ori_pref_ipsi_only(i)=dFoF_postMD.SigCellsDrift.IpsiCell(i).pref_ori;
    post_cv_ipsi_only(i)=dFoF_postMD.SigCellsDrift.IpsiCell(i).cv_ori;
    for j=1:16
        post_ori_ipsi_only(i,j)=dFoF_postMD.SigCellsDrift.IpsiCell(i).ori(j).peak; 
    end
end

%for contralateral cells 
[ID_pre_contra,ind_preMD_contra,ind_longpre_contra]=intersect(preMD_contra_ID,matchcells(:,1)); %cells located pre MD that are binocular 
[ID_post_contra,ind_postMD_contra,ind_longpost_contra]=intersect(postMD_contra_ID,matchcells(:,2)); %cells located post MD that are binocular 

ind_long_contra=intersect(ind_longpre_contra,ind_longpost_contra); %where were the indices the same? indicating the same longitudinally tracked cell, even though the cell ID changes 

%cell IDs of actual long. tracked cells that were responsive
long_pre_contra=matchcells(ind_long_contra,1); 
long_post_contra=matchcells(ind_long_contra,2);

[~,ind_pre_contra]=ismember(long_pre_contra,preMD_contra_ID'); %where are the cells 
[~,ind_post_contra]=ismember(long_post_contra,postMD_contra_ID'); %where are the cells 

% matching 
Oripref_pre_contra_only=pre_ori_pref_contra_only(ind_pre_contra); 
Oripref_post_contra_only=post_ori_pref_contra_only(ind_post_contra);

cv_pre_contra_only=pre_cv_contra_only(ind_pre_contra); 
cv_post_contra_only=post_cv_contra_only(ind_post_contra);

ori_pre_contra_only=pre_ori_contra_only(ind_pre_contra,:);
ori_post_contra_only=post_ori_contra_only(ind_post_contra,:);


%for ipsilateral cells 
[ID_pre_ipsi,ind_preMD_ipsi,ind_longpre_ipsi]=intersect(preMD_ipsi_ID,matchcells(:,1)); %cells located pre MD that are binocular 
[ID_post_ipsi,ind_postMD_ipsi,ind_longpost_ipsi]=intersect(postMD_ipsi_ID,matchcells(:,2)); %cells located post MD that are binocular 

ind_long_ipsi=intersect(ind_longpre_ipsi,ind_longpost_ipsi); %where were the indices the same? indicating the same longitudinally tracked cell, even though the cell ID changes 

%cell IDs of actual long. tracked cells that were responsive
long_pre_ipsi=matchcells(ind_long_ipsi,1); 
long_post_ipsi=matchcells(ind_long_ipsi,2);

[~,ind_pre_ipsi]=ismember(long_pre_ipsi,preMD_ipsi_ID'); %where are the cells 
[~,ind_post_ipsi]=ismember(long_post_ipsi,postMD_ipsi_ID'); %where are the cells 

% matching 
Oripref_pre_ipsi_only=pre_ori_pref_ipsi_only(ind_pre_ipsi); 
Oripref_post_ipsi_only=post_ori_pref_ipsi_only(ind_post_ipsi);

cv_pre_ipsi_only=pre_cv_ipsi_only(ind_pre_ipsi); 
cv_post_ipsi_only=post_cv_ipsi_only(ind_post_ipsi);

ori_pre_ipsi_only=pre_ori_ipsi_only(ind_pre_ipsi,:);
ori_post_ipsi_only=post_ori_ipsi_only(ind_post_ipsi,:);


save(fullfile(SaveDirpre, strcat(anim, '_Oripref_pre_contra_only.mat')), 'Oripref_pre_contra_only');
save(fullfile(SaveDirpre, strcat(anim, '_Oripref_pre_ipsi_only.mat')), 'Oripref_pre_ipsi_only');

save(fullfile(SaveDirpost, strcat(anim, '_Oripref_post_contra_only.mat')), 'Oripref_post_contra_only');
save(fullfile(SaveDirpost, strcat(anim, '_Oripref_post_ipsi_only.mat')), 'Oripref_post_ipsi_only');

save(fullfile(SaveDirpre, strcat(anim, '_cv_pre_contra_only.mat')), 'cv_pre_contra_only');
save(fullfile(SaveDirpre, strcat(anim, '_cv_pre_ipsi_only.mat')), 'cv_pre_ipsi_only');

save(fullfile(SaveDirpost, strcat(anim, '_cv_post_contra_only.mat')), 'cv_post_contra_only');
save(fullfile(SaveDirpost, strcat(anim, '_cv_post_ipsi_only.mat')), 'cv_post_ipsi_only');

save(fullfile(SaveDirpre, strcat(anim, 'ori_pre_contra_only.mat')), 'ori_pre_contra_only');
save(fullfile(SaveDirpre, strcat(anim, 'ori_pre_ipsi_only.mat')), 'ori_pre_ipsi_only');

save(fullfile(SaveDirpost, strcat(anim, 'ori_post_contra_only.mat')), 'ori_post_contra_only');
save(fullfile(SaveDirpost, strcat(anim, 'ori_post_ipsi_only.mat')), 'ori_post_ipsi_only');

writematrix(ori_pre_contra_only,fullfile(SaveDir,strcat(anim, '_ori_pre_contra_only.csv'))); 
writematrix(ori_pre_ipsi_only,fullfile(SaveDir,strcat(anim, '_ori_pre_ipsi_only.csv'))); 
writematrix(ori_post_contra_only,fullfile(SaveDir,strcat(anim, '_ori_post_contra_only.csv'))); 
writematrix(ori_post_ipsi_only,fullfile(SaveDir,strcat(anim, '_ori_post_ipsi_only.csv'))); 

%for TUNING AND BINOCULAR MATCHING for longitudinally tracked cells 

[ID_pre_binoc,ind_preMD_binoc,ind_longpre_binoc]=intersect(preMD_binoc_ID,matchcells(:,1)); %cells located pre MD that are binocular 
[ID_post_binoc,ind_postMD_binoc,ind_longpost_binoc]=intersect(postMD_binoc_ID,matchcells(:,2)); %cells located post MD that are binocular 

ind_long_binoc=intersect(ind_longpre_binoc,ind_longpost_binoc); %where were the indices the same? indicating the same longitudinally tracked cell, even though the cell ID changes 

%cell IDs of actual long. tracked cells that were responsive
long_pre_binoc=matchcells(ind_long_binoc,1); 
long_post_binoc=matchcells(ind_long_binoc,2);

[~,ind_pre_binoc]=ismember(long_pre_binoc,preMD_binoc_ID'); %where are the cells 
[~,ind_post_binoc]=ismember(long_post_binoc,postMD_binoc_ID'); %where are the cells 


%binocular matching 
Oripref_pre_contra=pre_ori_pref_contra(ind_pre_binoc); 
Oripref_pre_ipsi=pre_ori_pref_ipsi(ind_pre_binoc);
Oripref_post_contra=post_ori_pref_contra(ind_post_binoc); 
Oripref_post_ipsi=post_ori_pref_ipsi(ind_post_binoc);

cv_pre_contra=preMD_binoc_contra_cv(ind_pre_binoc); 
cv_pre_ipsi=preMD_binoc_ipsi_cv(ind_pre_binoc); 
cv_post_contra=postMD_binoc_contra_cv(ind_post_binoc); 
cv_post_ipsi=postMD_binoc_ipsi_cv(ind_post_binoc); 

ori_pre_bin_contra= pre_ori_bin_contra(ind_pre_binoc,:);
ori_pre_bin_ipsi=pre_ori_bin_ipsi(ind_pre_binoc,:); 
ori_post_bin_contra=post_ori_bin_contra(ind_post_binoc,:);
ori_post_bin_ipsi=post_ori_bin_ipsi(ind_post_binoc,:); 

trace_oris_pre_bin_contra=pre_ori_avg_bin_contra(ind_pre_binoc, :, :);
trace_oris_pre_bin_ipsi=pre_ori_avg_bin_ipsi(ind_pre_binoc, :, :);
trace_oris_post_bin_contra=post_ori_avg_bin_contra(ind_post_binoc, :, :);
trace_oris_post_bin_ipsi=post_ori_avg_bin_ipsi(ind_post_binoc, :, :);

oris=linspace(0,337.5,16); 
SaveDirtuningfigures = ['L:\Laura\AnalyzedData\calcium\drifting_gratings\', anim, '\', preMDday, '\tuningcurves\'];
if exist(SaveDirtuningfigures,'dir') == 0
            mkdir(SaveDirtuningfigures)
end

%plot the response curves
for i=1:length(ind_pre_binoc)
    f=figure('Visible','off');
    t=tiledlayout(f,2,2); 
      
    ax=nexttile;
    errorbar(oris,mean(trace_oris_pre_bin_contra (i,:,:),3), std(trace_oris_pre_bin_contra (i,:,:),[], 3)/sqrt(10),'Color','black');
    title(ax, 'Pre MD- Contralateral Responses');

    ax1=nexttile;
    errorbar(oris,mean(trace_oris_pre_bin_ipsi (i,:,:),3), std(trace_oris_pre_bin_ipsi (i,:,:),[], 3)/sqrt(10),'Color','black');
    title(ax1, 'Pre MD- Ipsilateral Responses');

     ax2=nexttile;
    errorbar(oris,mean(trace_oris_post_bin_contra (i,:,:),3), std(trace_oris_post_bin_contra (i,:,:),[], 3)/sqrt(10),'Color', [0.7 .7 .7]);
    title(ax2, 'Post MD- Contralateral Responses');

    ax3=nexttile;
    errorbar(oris,mean(trace_oris_post_bin_ipsi (i,:,:),3), std(trace_oris_post_bin_ipsi (i,:,:),[], 3)/sqrt(10),'Color', [0.7 .7 .7]);
    title(ax3, 'Post MD- Ipsilateral Responses');
    
    saveas(f, fullfile(SaveDir, strcat(anim, '_', num2str(ind_pre_binoc(i)),'_tuningbandwidth_binoccells')), 'pdf'); 
end 

save(fullfile(SaveDirpre, strcat(anim, '_cv_pre_contra.mat')), 'cv_pre_contra');
save(fullfile(SaveDirpre, strcat(anim, '_cv_pre_ipsi.mat')), 'cv_pre_ipsi');

save(fullfile(SaveDirpost, strcat(anim, '_cv_post_contra.mat')), 'cv_post_contra');
save(fullfile(SaveDirpost, strcat(anim, '_cv_post_ipsi.mat')), 'cv_post_ipsi');

%orientation curves
save(fullfile(SaveDirpre, strcat(anim, '_ori_pre_bin_contra.mat')), 'ori_pre_bin_contra');
save(fullfile(SaveDirpre, strcat(anim, '_ori_pre_bin_ipsi.mat')), 'ori_pre_bin_ipsi');

save(fullfile(SaveDirpost, strcat(anim, '_ori_post_bin_contra.mat')), 'ori_post_bin_contra');
save(fullfile(SaveDirpost, strcat(anim, '_ori_post_bin_ipsi.mat')), 'ori_post_bin_ipsi');

writematrix(ori_pre_bin_contra,fullfile(SaveDir,strcat(anim, '_ori_pre_bin_contra.csv'))); 
writematrix(ori_pre_bin_ipsi,fullfile(SaveDir,strcat(anim, '_ori_pre_bin_ipsi.csv'))); 
writematrix(ori_post_bin_contra,fullfile(SaveDir,strcat(anim, '_ori_post_bin_contra.csv'))); 
writematrix(ori_post_bin_ipsi,fullfile(SaveDir,strcat(anim, '_ori_post_bin_ipsi.csv'))); 

%OD
OD_pre=OD_pre'; 
OD_post=OD_post'; 

%tuning
OSI_pre_contra=OSI_pre_contra';
OSI_pre_ipsi=OSI_pre_ipsi';
OSI_post_contra=OSI_post_contra';
OSI_post_ipsi=OSI_post_ipsi';

DSI_pre_contra=DSI_pre_contra';
DSI_pre_ipsi=DSI_pre_ipsi';
DSI_post_contra=DSI_post_contra';
DSI_post_ipsi=DSI_post_ipsi';

%binocular matching 
Oripref_pre_contra=Oripref_pre_contra'; 
Oripref_pre_ipsi=Oripref_pre_ipsi';
Oripref_post_contra=Oripref_post_contra'; 
Oripref_post_ipsi=Oripref_post_ipsi';

%averages
avg_OD_pre=mean(OD_pre, 'omitnan'); 
avg_OD_post=mean(OD_post, 'omitnan');
avg_OSI_pre_contra=mean(OSI_pre_contra,'omitnan'); 
avg_OSI_pre_ipsi=mean(OSI_pre_ipsi,'omitnan'); 
avg_OSI_post_contra=mean(OSI_post_contra,'omitnan'); 
avg_OSI_post_ipsi=mean(OSI_post_ipsi,'omitnan');

%% tuning curve fits - local measure of selectivity 

x=linspace(0,337.5,16); 

%Tuning width for orientation/ direction  

length_bin_contra=size(ori_pre_bin_contra); 
length_bin_ipsi=size(ori_pre_bin_ipsi); 

tuningwidth_pre_bin_contra=zeros(1,length_bin_contra(1)); 
tuningwidth_pre_bin_ipsi=zeros(1,length_bin_ipsi(1)); 
tuningwidth_post_bin_contra=zeros(1,length_bin_contra(1)); 
tuningwidth_post_bin_ipsi=zeros(1,length_bin_ipsi(1)); 

%for binocular cells- tuning bandwidth 
for ii=1:length_bin_contra
    tuningwidth_pre_bin_contra(ii) = compute_tuningwidth( x, ori_pre_bin_contra(ii,:) ); 
    tuningwidth_pre_bin_ipsi(ii) = compute_tuningwidth( x, ori_pre_bin_ipsi(ii,:) ); 
    tuningwidth_post_bin_contra(ii) = compute_tuningwidth( x, ori_post_bin_contra(ii,:) ); 
    tuningwidth_post_bin_ipsi(ii) = compute_tuningwidth( x, ori_post_bin_ipsi(ii,:) ); 
end

length_contra=size(ori_pre_contra_only); 
length_ipsi=size(ori_post_ipsi_only); 

tuningwidth_pre_contra=zeros(1,length_contra(1)); 
tuningwidth_pre_ipsi=zeros(1,length_ipsi(1)); 

tuningwidth_post_contra=zeros(1,length_contra(1)); 
tuningwidth_post_ipsi=zeros(1,length_ipsi(1)); 

%for contralateral cells- tuning bandwidth 
for ii=1:length_contra
    tuningwidth_pre_contra(ii) = compute_tuningwidth( x, ori_pre_contra_only(ii,:) ); 
    tuningwidth_post_contra(ii) = compute_tuningwidth( x, ori_post_contra_only(ii,:) ); 
end

for ii=1:length_ipsi
    tuningwidth_pre_ipsi(ii) = compute_tuningwidth( x, ori_pre_ipsi_only(ii,:) ); 
    tuningwidth_post_ipsi(ii) = compute_tuningwidth( x, ori_post_ipsi_only(ii,:) ); 
end

%save 
save(fullfile(SaveDirpre, strcat(anim, 'tuningwidth_pre_bin_contra.mat')), 'tuningwidth_pre_bin_contra');
save(fullfile(SaveDirpre, strcat(anim, 'tuningwidth_pre_bin_ipsi.mat')), 'tuningwidth_pre_bin_ipsi');

save(fullfile(SaveDirpre, strcat(anim, 'tuningwidth_pre_contra.mat')), 'tuningwidth_pre_contra');
save(fullfile(SaveDirpre, strcat(anim, 'tuningwidth_pre_ipsi.mat')), 'tuningwidth_pre_ipsi');


save(fullfile(SaveDirpost, strcat(anim, 'tuningwidth_post_bin_contra.mat')), 'tuningwidth_post_bin_contra');
save(fullfile(SaveDirpost, strcat(anim, 'tuningwidth_post_bin_ipsi.mat')), 'tuningwidth_post_bin_ipsi');

save(fullfile(SaveDirpost, strcat(anim, 'tuningwidth_post_contra.mat')), 'tuningwidth_post_contra');
save(fullfile(SaveDirpost, strcat(anim, 'tuningwidth_post_ipsi.mat')), 'tuningwidth_post_ipsi');

%% plot ODI as cell ROIs 

im_pre=zeros(512,756); 
im_post=zeros(512,756); 
im2=zeros(512,756); 
im3=zeros(512,756); 

%pre MD 
for i=1:length(OD_pre)
    for q=1:length(cellstats_pre{1,i}.ypix)
        im_pre(cellstats_pre{1,i}.ypix(q), cellstats_pre{1, i}.xpix(q))= 1; 
        im2(cellstats_pre{1,i}.ypix(q), cellstats_pre{1, i}.xpix(q))= OD_pre(i)+2;%transformation so that 0 is transparent 
    end    
end

%post MD 
for i=1:length(OD_post)
    for q=1:length(cellstats_post{1,i}.ypix)
        im_post(cellstats_post{1,i}.ypix(q), cellstats_post{1, i}.xpix(q))= 1;         
        im3(cellstats_post{1,i}.ypix(q), cellstats_post{1, i}.xpix(q))= OD_post(i)+2;%transformation so that 0 is transparent 
    end    
end

%new ODI scale is 1 to 3 

%im is binary mask for transparency
roimask_pre=im_pre; 
roimask_post=im_post; 

%plot meanImg pre and post MD 
f1= figure; 
c1=gray; 
ax1=axes; 
colormap(c1); 
imagesc(pre_meanimg.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 
title('Pre MD')


f2= figure; 
c2=gray; 
ax2=axes; 
colormap(c2); 
imagesc(post_meanimg.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 
title('Post MD')


f3=figure('Name', 'Color coded ODI', 'NumberTitle','off'); 
tiledlayout(1,2)
nexttile
p2=imagesc(im2, 'AlphaDataMapping','none');
set(p2, 'AlphaData', roimask_pre); %make background transparent
CellColorMap=turbo(256); %make colormap
CellColorMap(1,:) = 1; %make first value white 
colormap(CellColorMap)
bar1=colorbar; 
bar1.Label.String= 'ODI'; 
bar1.Label.FontSize= 10; 
bar1.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
set(bar1, 'XTickLabel', {'1','0.5','1.0', '1.5', '2.0','2.5', '3'},...
    'XTick', 1:0.5:3); 
clim([1 3]); 
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 

nexttile
f3=imagesc(im3, 'AlphaDataMapping','none');
set(f3, 'AlphaData', roimask_post); %make background transparent
CellColorMap=turbo(256);
CellColorMap(1,:) = 1;
colormap(CellColorMap)
bar3=colorbar; 
bar3.Label.String= 'ODI'; 
bar3.Label.FontSize= 10; 
bar3.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
set(bar3, 'XTickLabel', {'1','0.5','1.0', '1.5', '2.0','2.5', '3'},...
    'XTick', 1:0.5:3);
clim([1 3]); 

%colorbar scale is modified so that 0 is not the background 

%save plots 
saveas(f1, fullfile(SaveDir, strcat(anim, '_MeanImagepreMD')), 'tif'); 
saveas(f1, fullfile(SaveDir, strcat(anim, '_MeanImagepreMD')), 'pdf'); 
saveas(f1, fullfile(SaveDir, strcat(anim, '_MeanImagepreMD')), 'fig'); 

saveas(f2, fullfile(SaveDir, strcat(anim, '_MeanImagepostMD')), 'tif'); 
saveas(f2, fullfile(SaveDir, strcat(anim, '_MeanImagepostMD')), 'pdf'); 
saveas(f2, fullfile(SaveDir, strcat(anim, '_MeanImagepostMD')), 'fig'); 

saveas(f3, fullfile(SaveDir, strcat(anim, '_ROIsODI')), 'tif'); 
saveas(f3, fullfile(SaveDir,strcat(anim, '_ROIsODI')), 'pdf'); 
saveas(f3, fullfile(SaveDir,strcat(anim, '_ROIsODI')), 'fig'); 

%% plot ALL CELLS ODI as cell ROIs 

im_pre=zeros(512,756); 
im_post=zeros(512,756); 
im2=zeros(512,756); 
im3=zeros(512,756); 

%pre MD 
for i=1:length(preMD_OD)
    for q=1:length(cellstats_pre_all{1,i}.ypix)
        im_pre(cellstats_pre_all{1,i}.ypix(q), cellstats_pre_all{1, i}.xpix(q))= 1; 
        im2(cellstats_pre_all{1,i}.ypix(q), cellstats_pre_all{1, i}.xpix(q))= preMD_OD(i)+2;%transformation so that 0 is transparent 
    end    
end

%post MD 
for i=1:length(postMD_OD)
    for q=1:length(cellstats_post_all{1,i}.ypix)
        im_post(cellstats_post_all{1,i}.ypix(q), cellstats_post_all{1, i}.xpix(q))= 1;         
        im3(cellstats_post_all{1,i}.ypix(q), cellstats_post_all{1, i}.xpix(q))= postMD_OD(i)+2;%transformation so that 0 is transparent 
    end    
end

%new ODI scale is 1 to 3 

%im is binary mask for transparency
roimask_pre=im_pre; 
roimask_post=im_post; 

%plot meanImg pre and post MD 
f4= figure; 
c1=gray; 
ax1=axes; 
colormap(c1); 
imagesc(pre_meanimg.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 
title('Pre MD')


f5= figure; 
c2=gray; 
ax2=axes; 
colormap(c2); 
imagesc(post_meanimg.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 
title('Post MD')


f6=figure('Name', 'Color coded ODI', 'NumberTitle','off'); 
tiledlayout(1,2)
nexttile
p7=imagesc(im2, 'AlphaDataMapping','none');
set(p7, 'AlphaData', roimask_pre); %make background transparent
CellColorMap=turbo(256); %make colormap
CellColorMap(1,:) = 1; %make first value white 
colormap(CellColorMap)
bar1=colorbar; 
bar1.Label.String= 'ODI'; 
bar1.Label.FontSize= 10; 
bar1.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
set(bar1, 'XTickLabel', {'1','0.5','1.0', '1.5', '2.0','2.5', '3'},...
    'XTick', 1:0.5:3); 
clim([1 3]); 
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 

nexttile
p8=imagesc(im3, 'AlphaDataMapping','none');
set(p8, 'AlphaData', roimask_post); %make background transparent
CellColorMap=turbo(256);
CellColorMap(1,:) = 1;
colormap(CellColorMap)
bar3=colorbar; 
bar3.Label.String= 'ODI'; 
bar3.Label.FontSize= 10; 
bar3.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
set(bar3, 'XTickLabel', {'1','0.5','1.0', '1.5', '2.0','2.5', '3'},...
    'XTick', 1:0.5:3);
clim([1 3]); 

%colorbar scale is modified so that 0 is not the background 

%save plots 
saveas(f4, fullfile(SaveDir, strcat(anim, '_MeanImagepreMD_ALLCells')), 'tif'); 
saveas(f4, fullfile(SaveDir, strcat(anim, '_MeanImagepreMD_ALLCells')), 'pdf'); 
saveas(f4, fullfile(SaveDir, strcat(anim, '_MeanImagepreMD_ALLCells')), 'fig'); 

saveas(f5, fullfile(SaveDir, strcat(anim, '_MeanImagepostMD_ALLCells')), 'tif'); 
saveas(f5, fullfile(SaveDir, strcat(anim, '_MeanImagepostMD_ALLCells')), 'pdf'); 
saveas(f5, fullfile(SaveDir, strcat(anim, '_MeanImagepostMD_ALLCells')), 'fig'); 

saveas(f6, fullfile(SaveDir,strcat(anim, '_ROIsODI_ALLCells')), 'tif'); 
saveas(f6, fullfile(SaveDir,strcat(anim, '_ROIsODI_ALLCells')), 'pdf'); 
saveas(f6, fullfile(SaveDir,strcat(anim, '_ROIsODI_ALLCells')), 'fig'); 


%% save OD scores,tuning, and binocular matching for longitudinally tracked cells. 

save(fullfile(SaveDirpre, strcat(anim, '_OD_pre.mat')), 'OD_pre');
save(fullfile(SaveDirpost, strcat(anim, '_OD_post.mat')), 'OD_post');
save(fullfile(SaveDirpre, strcat(anim, '_OSI_pre_contra.mat')), 'OSI_pre_contra'); 
save(fullfile(SaveDirpre, strcat(anim, '_OSI_pre_ipsi.mat')), 'OSI_pre_ipsi'); 
save(fullfile(SaveDirpost, strcat(anim, '_OSI_post_contra.mat')), 'OSI_post_contra');
save(fullfile(SaveDirpost, strcat(anim, '_OSI_post_ipsi.mat')), 'OSI_post_ipsi');

save(fullfile(SaveDirpre, strcat(anim, '_Oripref_pre_contra.mat')), 'Oripref_pre_contra'); 
save(fullfile(SaveDirpre, strcat(anim, '_Oripref_pre_ipsi.mat')), 'Oripref_pre_ipsi'); 
save(fullfile(SaveDirpost, strcat(anim, '_Oripref_post_contra.mat')), 'Oripref_post_contra');
save(fullfile(SaveDirpost, strcat(anim, '_Oripref_post_ipsi.mat')), 'Oripref_post_ipsi');


%% look at proportions of binoc/c/i cells 

%PRE MD 
%number of cells 
binoc_count_pre=length(dFoF_preMD.SigCellsDrift.BinocCell); 
if isfield(dFoF_preMD.SigCellsDrift, 'IpsiCell')
    ipsi_count_pre=length(dFoF_preMD.SigCellsDrift.IpsiCell);
else 
    ipsi_count_pre=0; 
end

con_count_pre=length(dFoF_preMD.SigCellsDrift.ContraCell); 
unresp_count_pre=length(pre_ID)-length(dFoF_preMD.SigCellsDrift.AllCells);
all_count_pre=length(pre_ID); 

%proportion of cells 
binoc_count_prop_pre=(binoc_count_pre/ all_count_pre)*100; 
ipsi_count_prop_pre=(ipsi_count_pre/ all_count_pre)*100;
con_count_prop_pre=(con_count_pre/ all_count_pre)*100; 
unresp_count_prop_pre=(unresp_count_pre/all_count_pre)*100; 


%POST MD 
%number of cells 
binoc_count_post  =length(dFoF_postMD.SigCellsDrift.BinocCell); 
if isfield(dFoF_postMD.SigCellsDrift, 'IpsiCell')
    ipsi_count_post  =length(dFoF_postMD.SigCellsDrift.IpsiCell);
else
    ipsi_count_post=0;
end

con_count_post  =length(dFoF_postMD.SigCellsDrift.ContraCell); 
unresp_count_post=(length(post_ID))-(length(dFoF_postMD.SigCellsDrift.AllCells));
all_count_post=length(post_ID); 

%proportion of cells 
binoc_count_prop_post=(binoc_count_post  / all_count_post  )*100; 
ipsi_count_prop_post=(ipsi_count_post  / all_count_post  )*100;
con_count_prop_post=(con_count_post  / all_count_post  )*100; 
unresp_count_prop_post=(unresp_count_post/all_count_post)*100; 

%make structure 
cell_count_prop_pre=struct('binoc',binoc_count_prop_pre, 'con', con_count_prop_pre, 'ipsi', ipsi_count_prop_pre, 'unresp',unresp_count_prop_pre); 
cell_count_prop_post=struct('binoc',binoc_count_prop_post, 'con', con_count_prop_post, 'ipsi', ipsi_count_prop_post, 'unresp',unresp_count_prop_post); 

%make structure 
cell_count_pre=struct('binoc',binoc_count_pre, 'con', con_count_pre, 'ipsi', ipsi_count_pre, 'unresp',unresp_count_pre); 
cell_count_post=struct('binoc',binoc_count_post, 'con', con_count_post, 'ipsi', ipsi_count_post, 'unresp',unresp_count_post); 

%save structures
save(fullfile(SaveDirpre, strcat(anim, '_cell_prop_pre.mat')), 'cell_count_prop_pre');
save(fullfile(SaveDirpost, strcat(anim, '_cell_prop_post.mat')), 'cell_count_prop_post');

save(fullfile(SaveDirpre, strcat(anim, '_cell_counts_pre.mat')), 'cell_count_pre');
save(fullfile(SaveDirpost, strcat(anim, '_cell_counts_post.mat')), 'cell_count_post');

%% look at cell identity changes 

%must upload all cells, not just ones that are significantly responsive 
ID_pre=zeros (1,length(pre_long_ID)); 
ID_post=zeros (1,length(post_long_ID)); 

C2C=zeros (length(pre_long_ID),2); 
C2I=zeros (length(pre_long_ID),2);  
C2B=zeros (length(pre_long_ID),2);  
C2U=zeros (length(pre_long_ID),2);  

I2I=zeros (length(pre_long_ID),2);  
I2C=zeros (length(pre_long_ID),2);  
I2B=zeros (length(pre_long_ID),2);  
I2U=zeros (length(pre_long_ID),2); 

B2B=zeros (length(pre_long_ID),2);  
B2C=zeros (length(pre_long_ID),2);    
B2I=zeros (length(pre_long_ID),2);   
B2U=zeros (length(pre_long_ID),2);   

U2U=zeros (length(pre_long_ID),2);   
U2C=zeros (length(pre_long_ID),2);   
U2I=zeros (length(pre_long_ID),2);   
U2B=zeros (length(pre_long_ID),2);   

%PRE MD 
for i=1:length(pre_long_ID) % for all longitudinally tracked cells 
    if length(find(pre_ind.indices.drift.respcells==pre_long_ID(i)))==0 %if unresponsive in pre MD condition 
        ID_pre(i)=0; %if unresponsive, score a 0
    elseif length(find(pre_ind.indices.drift.contraresp==pre_long_ID(i)))>0 %if contra in pre MD condition 
        ID_pre(i)=1; %score of a 1 for contra
    elseif length(find(pre_ind.indices.drift.ipsiresp==pre_long_ID(i)))>0 %if ipsi in pre MD 
        ID_pre(i)=2; %score a 2 
    elseif length(find(pre_ind.indices.drift.binocresp==pre_long_ID(i)))>0 %if binoc in pre MD
        ID_pre(i)=3; %if binoc 
    end
end 

%POSTMD 
for i=1:length(post_long_ID) % for all longitudinally tracked cells 
    if length(find(post_ind.indices.drift.respcells==post_long_ID(i)))==0 %if unresponsive in post MD condition 
        ID_post(i)=0; %if unresponsive, score a 0
    elseif length(find(post_ind.indices.drift.contraresp==post_long_ID(i)))>0 %if contra in post MD condition 
        ID_post(i)=1; %score of a 1 for contra
    elseif length(find(post_ind.indices.drift.ipsiresp==post_long_ID(i)))>0 %if ipsi in post MD 
        ID_post(i)=2; %score a 2 for ipsi 
    elseif length(find(post_ind.indices.drift.binocresp==post_long_ID(i)))>0 %if binoc in post MD
        ID_post(i)=3; %if binoc 
    end
end 

%does cell identity change pre to post? what are the tuning properties
%before and after transition? 

%Ipsilateral pre to what post MD? 
for i=1:length(pre_long_ID)
    if ID_pre(i)==2 && ID_post(i)==2 %if ipsi to ipsi 
        I2I(i,1)=pre_long_ID(i); % cell ID of pre MD  
        I2I(i,2)=post_long_ID(i); %cell ID of post MD 
       
    elseif ID_pre(i)==2 && ID_post(i)==1 %if ipsi to contra 
        I2C(i,1)=pre_long_ID(i); 
        I2C(i,2)=post_long_ID(i);
       

    elseif ID_pre(i)==2 && ID_post(i)==3 %if ipsi to binoc 
        I2B(i,1)=pre_long_ID(i); 
        I2B(i,2)=post_long_ID(i);

    elseif ID_pre(i)==2 && ID_post(i)==0 %if ipsi to unresponsive 
        I2U(i,1)=pre_long_ID(i); 
        I2U(i,2)=post_long_ID(i);
    end
end

%Contralateral pre to what post MD? 
for i=1:length(pre_long_ID)
    if ID_pre(i)==1 && ID_post(i)==1 %if contra to contra 
        C2C(i,1)=pre_long_ID(i); % cell ID of pre MD  
        C2C(i,2)=post_long_ID(i); %cell ID of post MD 
      

    elseif ID_pre(i)==1 && ID_post(i)==2 %if contra to ipsi 
        C2I(i,1)=pre_long_ID(i); 
        C2I(i,2)=post_long_ID(i);

    elseif ID_pre(i)==1 && ID_post(i)==3 %if contra to binoc 
        C2B(i,1)=pre_long_ID(i); 
        C2B(i,2)=post_long_ID(i);
       
    elseif ID_pre(i)==1 && ID_post(i)==0 %if contra to unresponsive 
        C2U(i,1)=pre_long_ID(i); 
        C2U(i,2)=post_long_ID(i);
       
    end 
end

%Binoc pre to what post MD? 
for i=1:length(pre_long_ID)
    if ID_pre(i)==3 && ID_post(i)==3 %if binoc to binoc 
        B2B(i,1)=pre_long_ID(i); % cell ID of pre MD  
        B2B(i,2)=post_long_ID(i); %cell ID of post MD 
       
    elseif ID_pre(i)== 3 && ID_post(i)==1 %if binoc to contra 
        B2C(i,1)=pre_long_ID(i); 
        B2C(i,2)=post_long_ID(i);
       
    elseif ID_pre(i)==3 && ID_post(i)==2 %if binoc to ipsi 
        B2I(i,1)=pre_long_ID(i); 
        B2I(i,2)=post_long_ID(i);
      
    elseif ID_pre(i)==3 && ID_post(i)==0 %if binoc to unresponsive 
        B2U(i,1)=pre_long_ID(i); 
        B2U(i,2)=post_long_ID(i);
        
    end 
end

%Unresponsive pre to what post MD? 
for i=1:length(pre_long_ID)
    if ID_pre(i)==0 && ID_post(i)==0 %if unresponsive to unresponsive  
        U2U(i,1)=pre_long_ID(i); % cell ID of pre MD  
        U2U(i,2)=post_long_ID(i); %cell ID of post MD       
    elseif ID_pre(i)== 0 && ID_post(i)==1 %if unresp to contra 
        U2C(i,1)=pre_long_ID(i); 
        U2C(i,2)=post_long_ID(i);
      
    elseif ID_pre(i)==0 && ID_post(i)==2 %if unresp to ipsi 
        U2I(i,1)=pre_long_ID(i); 
        U2I(i,2)=post_long_ID(i);
       
    elseif ID_pre(i)==0 && ID_post(i)==3 %if unresp to binoc 
        U2B(i,1)=pre_long_ID(i); 
        U2B(i,2)=post_long_ID(i);
    end 
end

for i=1:length(ind_pre)
    if ID_pre(i)==3 && ID_post(i)==3 %if binoc to binoc 
        B2B(i,1)=pre_long_ID(i); % cell ID of pre MD  
        B2B(i,2)=post_long_ID(i); %cell ID of post MD 
        
    elseif ID_pre(i)== 3 && ID_post(i)==1 %if binoc to contra 
        B2C(i,1)=pre_long_ID(i); 
        B2C(i,2)=post_long_ID(i);
      
    elseif ID_pre(i)==3 && ID_post(i)==2 %if binoc to ipsi 
        B2I(i,1)=pre_long_ID(i); 
        B2I(i,2)=post_long_ID(i);
       
    elseif ID_pre(i)==3 && ID_post(i)==0 %if binoc to unresponsive 
        B2U(i,1)=pre_long_ID(i); 
        B2U(i,2)=post_long_ID(i);
     
    end 
end

%Unresponsive pre to what post MD? 
for i=1:length(pre_long_ID)
    if ID_pre(i)==0 && ID_post(i)==0 %if unresponsive to unresponsive  
        U2U(i,1)=pre_long_ID(i); % cell ID of pre MD  
        U2U(i,2)=post_long_ID(i); %cell ID of post MD 
        
    elseif ID_pre(i)== 0 && ID_post(i)==1 %if unresp to contra 
        U2C(i,1)=pre_long_ID(i); 
        U2C(i,2)=post_long_ID(i);
        
    elseif ID_pre(i)==0 && ID_post(i)==2 %if unresp to ipsi 
        U2I(i,1)=pre_long_ID(i); 
        U2I(i,2)=post_long_ID(i);
        
    elseif ID_pre(i)==0 && ID_post(i)==3 %if unresp to binoc 
        U2B(i,1)=pre_long_ID(i); 
        U2B(i,2)=post_long_ID(i);
        
    end 
end

C2C(C2C==0)=nan; 
C2I(C2I==0)=nan; 
C2B(C2B==0)=nan; 
C2U(C2U==0)=nan; 

I2I(I2I==0)=nan; 
I2C(I2C==0)=nan; 
I2B(I2B==0)=nan; 
I2U(I2U==0)=nan; 

B2B(B2B==0)=nan; 
B2C(B2C==0)=nan; 
B2I(B2I==0)=nan; 
B2U(B2U==0)=nan; 

U2U(U2U==0)=nan; 
U2C(U2C==0)=nan; 
U2I(U2I==0)=nan; 
U2B(U2B==0)=nan; 

C2C=rmmissing(C2C); 
C2I=rmmissing(C2I); 
C2B=rmmissing(C2B); 
C2U=rmmissing(C2U);  

I2I=rmmissing(I2I); 
I2C=rmmissing(I2C);
I2B=rmmissing(I2B); 
I2U=rmmissing(I2U); 

B2B=rmmissing(B2B); 
B2C=rmmissing(B2C); 
B2I=rmmissing(B2I); 
B2U=rmmissing(B2U); 

U2U=rmmissing(U2U); 
U2C=rmmissing(U2C); 
U2I=rmmissing(U2I); 
U2B=rmmissing(U2B); 

%% Cell tuning properties by cell conversion 

ID_pre_OSI=zeros (1,length(ind_pre)); 
ID_post_OSI=zeros (1,length(ind_post)); 

C2C_OSI=zeros (length(ind_pre),4); 
C2I_OSI=zeros (length(ind_pre),4);  
C2B_OSI=zeros (length(ind_pre),4);  
C2U_OSI=zeros (length(ind_pre),4);  

I2I_OSI=zeros (length(ind_pre),4);  
I2C_OSI=zeros (length(ind_pre),4);  
I2B_OSI=zeros (length(ind_pre),4);  
I2U_OSI=zeros (length(ind_pre),4); 

B2B_OSI=zeros (length(ind_pre),4);  
B2C_OSI=zeros (length(ind_pre),4);    
B2I_OSI=zeros (length(ind_pre),4);   
B2U_OSI=zeros (length(ind_pre),4);   

U2U_OSI=zeros (length(ind_pre),4);   
U2C_OSI=zeros (length(ind_pre),4);   
U2I_OSI=zeros (length(ind_pre),4);   
U2B_OSI=zeros (length(ind_pre),4);   

%PRE MD 
for i=1:length(ind_pre) % for all longitudinally tracked cells 
    if length(find(pre_ind.indices.drift.respcells==ind_pre(i)))==0 %if unresponsive in pre MD condition 
        ID_pre_OSI(i)=0; %if unresponsive, score a 0
    elseif length(find(pre_ind.indices.drift.contraresp==ind_pre(i)))>0 %if contra in pre MD condition 
        ID_pre_OSI(i)=1; %score of a 1 for contra
    elseif length(find(pre_ind.indices.drift.ipsiresp==ind_pre(i)))>0 %if ipsi in pre MD 
        ID_pre_OSI(i)=2; %score a 2 
    elseif length(find(pre_ind.indices.drift.binocresp==ind_pre(i)))>0 %if binoc in pre MD
        ID_pre_OSI(i)=3; %if binoc 
    end
end 

%POSTMD 
for i=1:length(ind_post) % for all longitudinally tracked cells 
    if length(find(post_ind.indices.drift.respcells==ind_post(i)))==0 %if unresponsive in post MD condition 
        ID_post_OSI(i)=0; %if unresponsive, score a 0
    elseif length(find(post_ind.indices.drift.contraresp==ind_post(i)))>0 %if contra in post MD condition 
        ID_post_OSI(i)=1; %score of a 1 for contra
    elseif length(find(post_ind.indices.drift.ipsiresp==ind_post(i)))>0 %if ipsi in post MD 
        ID_post_OSI(i)=2; %score a 2 for ipsi 
    elseif length(find(post_ind.indices.drift.binocresp==ind_post(i)))>0 %if binoc in post MD
        ID_post_OSI(i)=3; %if binoc 
    end
end 

C2C_DSI=zeros (length(ind_pre),4); 
C2I_DSI=zeros (length(ind_pre),4);  
C2B_DSI=zeros (length(ind_pre),4);  
C2U_DSI=zeros (length(ind_pre),4);  

I2I_DSI=zeros (length(ind_pre),4);  
I2C_DSI=zeros (length(ind_pre),4);  
I2B_DSI=zeros (length(ind_pre),4);  
I2U_DSI=zeros (length(ind_pre),4); 

B2B_DSI=zeros (length(ind_pre),4);  
B2C_DSI=zeros (length(ind_pre),4);    
B2I_DSI=zeros (length(ind_pre),4);   
B2U_DSI=zeros (length(ind_pre),4);   

U2U_DSI=zeros (length(ind_pre),4);   
U2C_DSI=zeros (length(ind_pre),4);   
U2I_DSI=zeros (length(ind_pre),4);   
U2B_DSI=zeros (length(ind_pre),4);   

%PRE MD 
for i=1:length(ind_pre) % for all longitudinally tracked cells 
    if length(find(pre_ind.indices.drift.respcells==ind_pre(i)))==0 %if unresponsive in pre MD condition 
        ID_pre_DSI(i)=0; %if unresponsive, score a 0
    elseif length(find(pre_ind.indices.drift.contraresp==ind_pre(i)))>0 %if contra in pre MD condition 
        ID_pre_DSI(i)=1; %score of a 1 for contra
    elseif length(find(pre_ind.indices.drift.ipsiresp==ind_pre(i)))>0 %if ipsi in pre MD 
        ID_pre_DSI(i)=2; %score a 2 
    elseif length(find(pre_ind.indices.drift.binocresp==ind_pre(i)))>0 %if binoc in pre MD
        ID_pre_DSI(i)=3; %if binoc 
    end
end 

%POSTMD 
for i=1:length(ind_post) % for all longitudinally tracked cells 
    if length(find(post_ind.indices.drift.respcells==ind_post(i)))==0 %if unresponsive in post MD condition 
        ID_post_DSI(i)=0; %if unresponsive, score a 0
    elseif length(find(post_ind.indices.drift.contraresp==ind_post(i)))>0 %if contra in post MD condition 
        ID_post_DSI(i)=1; %score of a 1 for contra
    elseif length(find(post_ind.indices.drift.ipsiresp==ind_post(i)))>0 %if ipsi in post MD 
        ID_post_DSI(i)=2; %score a 2 for ipsi 
    elseif length(find(post_ind.indices.drift.binocresp==ind_post(i)))>0 %if binoc in post MD
        ID_post_DSI(i)=3; %if binoc 
    end
end 


for i=1:length(ind_pre)
    if ID_pre_OSI(i)==3 && ID_post_OSI(i)==3 %if binoc to binoc 
        
        B2B_OSI(i,1)=OSI_pre_contra(i); 
        B2B_OSI(i,2)=OSI_pre_ipsi((i));
        B2B_OSI(i,3)=OSI_post_contra((i)); 
        B2B_OSI(i,4)=OSI_post_ipsi((i));
        B2B_DSI(i,1)=DSI_pre_contra((i)); 
        B2B_DSI(i,2)=DSI_pre_ipsi((i));
        B2B_DSI(i,3)=DSI_post_contra((i)); 
        B2B_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)== 3 && ID_post_OSI(i)==1 %if binoc to contra 
  
        B2C_OSI(i,1)=OSI_pre_contra((i)); 
        B2C_OSI(i,2)=OSI_pre_ipsi((i));
        B2C_OSI(i,3)=OSI_post_contra((i)); 
        B2C_OSI(i,4)=OSI_post_ipsi((i));
        B2C_DSI(i,1)=DSI_pre_contra((i)); 
        B2C_DSI(i,2)=DSI_pre_ipsi((i));
        B2C_DSI(i,3)=DSI_post_contra((i)); 
        B2C_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)==3 && ID_post_OSI(i)==2 %if binoc to ipsi 
       
        B2I_OSI(i,1)=OSI_pre_contra((i)); 
        B2I_OSI(i,2)=OSI_pre_ipsi((i));
        B2I_OSI(i,3)=OSI_post_contra((i)); 
        B2I_OSI(i,4)=OSI_post_ipsi((i));
        B2I_DSI(i,1)=DSI_pre_contra((i)); 
        B2I_DSI(i,2)=DSI_pre_ipsi((i));
        B2I_DSI(i,3)=DSI_post_contra((i)); 
        B2I_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)==3 && ID_post_OSI(i)==0 %if binoc to unresponsive 
       
        B2U_OSI(i,1)=OSI_pre_contra((i)); 
        B2U_OSI(i,2)=OSI_pre_ipsi((i));
        B2U_OSI(i,3)=OSI_post_contra((i)); 
        B2U_OSI(i,4)=OSI_post_ipsi((i));
        B2U_DSI(i,1)=DSI_pre_contra((i)); 
        B2U_DSI(i,2)=DSI_pre_ipsi((i));
        B2U_DSI(i,3)=DSI_post_contra((i)); 
        B2U_DSI(i,4)=DSI_post_ipsi((i));
    end 
end

for i=1:length(ind_pre)
    if ID_pre_OSI(i)==3 && ID_post_OSI(i)==3 %if binoc to binoc 
        
        B2B_OSI(i,1)=OSI_pre_contra(i); 
        B2B_OSI(i,2)=OSI_pre_ipsi((i));
        B2B_OSI(i,3)=OSI_post_contra((i)); 
        B2B_OSI(i,4)=OSI_post_ipsi((i));
        B2B_DSI(i,1)=DSI_pre_contra((i)); 
        B2B_DSI(i,2)=DSI_pre_ipsi((i));
        B2B_DSI(i,3)=DSI_post_contra((i)); 
        B2B_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)== 3 && ID_post_OSI(i)==1 %if binoc to contra 
  
        B2C_OSI(i,1)=OSI_pre_contra((i)); 
        B2C_OSI(i,2)=OSI_pre_ipsi((i));
        B2C_OSI(i,3)=OSI_post_contra((i)); 
        B2C_OSI(i,4)=OSI_post_ipsi((i));
        B2C_DSI(i,1)=DSI_pre_contra((i)); 
        B2C_DSI(i,2)=DSI_pre_ipsi((i));
        B2C_DSI(i,3)=DSI_post_contra((i)); 
        B2C_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)==3 && ID_post_OSI(i)==2 %if binoc to ipsi 
       
        B2I_OSI(i,1)=OSI_pre_contra((i)); 
        B2I_OSI(i,2)=OSI_pre_ipsi((i));
        B2I_OSI(i,3)=OSI_post_contra((i)); 
        B2I_OSI(i,4)=OSI_post_ipsi((i));
        B2I_DSI(i,1)=DSI_pre_contra((i)); 
        B2I_DSI(i,2)=DSI_pre_ipsi((i));
        B2I_DSI(i,3)=DSI_post_contra((i)); 
        B2I_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)==3 && ID_post_OSI(i)==0 %if binoc to unresponsive 
       
        B2U_OSI(i,1)=OSI_pre_contra((i)); 
        B2U_OSI(i,2)=OSI_pre_ipsi((i));
        B2U_OSI(i,3)=OSI_post_contra((i)); 
        B2U_OSI(i,4)=OSI_post_ipsi((i));
        B2U_DSI(i,1)=DSI_pre_contra((i)); 
        B2U_DSI(i,2)=DSI_pre_ipsi((i));
        B2U_DSI(i,3)=DSI_post_contra((i)); 
        B2U_DSI(i,4)=DSI_post_ipsi((i));
    end 
end


%Unresponsive pre to what post MD? 
for i=1:length(ind_pre)
    if ID_pre_OSI(i)==0 && ID_post_OSI(i)==0 %if unresponsive to unresponsive  
        
        U2U_OSI(i,1)=OSI_pre_contra((i)); 
        U2U_OSI(i,2)=OSI_pre_ipsi((i));
        U2U_OSI(i,3)=OSI_post_contra((i)); 
        U2U_OSI(i,4)=OSI_post_ipsi((i));
        U2U_DSI(i,1)=DSI_pre_contra((i)); 
        U2U_DSI(i,2)=DSI_pre_ipsi((i));
        U2U_DSI(i,3)=DSI_post_contra((i)); 
        U2U_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)== 0 && ID_post_OSI(i)==1 %if unresp to contra 
       
        U2C_OSI(i,1)=OSI_pre_contra((i)); 
        U2C_OSI(i,2)=OSI_pre_ipsi((i));
        U2C_OSI(i,3)=OSI_post_contra((i)); 
        U2C_OSI(i,4)=OSI_post_ipsi((i));
        U2C_DSI(i,1)=DSI_pre_contra((i)); 
        U2C_DSI(i,2)=DSI_pre_ipsi((i));
        U2C_DSI(i,3)=DSI_post_contra((i)); 
        U2C_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)==0 && ID_post_OSI(i)==2 %if unresp to ipsi 
        
        U2I_OSI(i,1)=OSI_pre_contra((i)); 
        U2I_OSI(i,2)=OSI_pre_ipsi((i));
        U2I_OSI(i,3)=OSI_post_contra((i)); 
        U2I_OSI(i,4)=OSI_post_ipsi((i));
        U2I_DSI(i,1)=DSI_pre_contra((i)); 
        U2I_DSI(i,2)=DSI_pre_ipsi((i));
        U2I_DSI(i,3)=DSI_post_contra((i)); 
        U2I_DSI(i,4)=DSI_post_ipsi((i));
    elseif ID_pre_OSI(i)==0 && ID_post_OSI(i)==3 %if unresp to binoc 
        
        U2B_OSI(i,1)=OSI_pre_contra((i)); 
        U2B_OSI(i,2)=OSI_pre_ipsi((i));
        U2B_OSI(i,3)=OSI_post_contra((i)); 
        U2B_OSI(i,4)=OSI_post_ipsi((i));
        U2B_DSI(i,1)=DSI_pre_contra((i)); 
        U2B_DSI(i,2)=DSI_pre_ipsi((i));
        U2B_DSI(i,3)=DSI_post_contra((i)); 
        U2B_DSI(i,4)=DSI_post_ipsi((i));
    end 
end

C2C_OSI(C2C_OSI==0)=nan; 
C2I_OSI(C2I_OSI==0)=nan; 
C2B_OSI(C2B_OSI==0)=nan; 
C2U_OSI(C2U_OSI==0)=nan; 

I2I_OSI(I2I_OSI==0)=nan; 
I2C_OSI(I2C_OSI==0)=nan; 
I2B_OSI(I2B_OSI==0)=nan; 
I2U_OSI(I2U_OSI==0)=nan; 

B2B_OSI(B2B==0)=nan; 
B2C_OSI(B2C==0)=nan; 
B2I_OSI(B2I_OSI==0)=nan; 
B2U_OSI(B2U_OSI==0)=nan; 

U2U_OSI(U2U_OSI==0)=nan; 
U2C_OSI(U2C_OSI==0)=nan; 
U2I_OSI(U2I_OSI==0)=nan; 
U2B_OSI(U2B_OSI==0)=nan; 

C2C_OSI=rmmissing(C2C_OSI); 
C2I_OSI=rmmissing(C2I_OSI); 
C2B_OSI=rmmissing(C2B_OSI); 
C2U_OSI=rmmissing(C2U_OSI);  

I2I_OSI=rmmissing(I2I_OSI); 
I2C_OSI=rmmissing(I2C_OSI);
I2B_OSI=rmmissing(I2B_OSI); 
I2U_OSI=rmmissing(I2U_OSI); 

B2B_OSI=rmmissing(B2B_OSI); 
B2C_OSI=rmmissing(B2C_OSI); 
B2I_OSI=rmmissing(B2I_OSI); 
B2U_OSI=rmmissing(B2U_OSI); 

U2U_OSI=rmmissing(U2U); 
U2C_OSI=rmmissing(U2C); 
U2I_OSI=rmmissing(U2I); 
U2B_OSI=rmmissing(U2B); 


%% plot cell identity as cell ROIs 

im_pre=zeros(512,756); 
im_post=zeros(512,756); 
im2=zeros(512,756); 
im3=zeros(512,756); 

ID_pre_ROI=ID_pre; 
ID_post_ROI=ID_post;
% 
% ID_pre_ROI(ID_pre_ROI==0)=nan; 
% ID_post_ROI(ID_post_ROI==0)=nan; 
% 
% ID_pre_ROI=rmmissing(ID_pre_ROI);
% ID_post_ROI=rmmissing(ID_post_ROI); 


%pre MD 
for i=1:length(ID_pre_ROI)
    for q=1:length(cellstats_pre_ident{1,i}.ypix)
        im_pre(cellstats_pre_ident{1,i}.ypix(q), cellstats_pre_ident{1,i}.xpix(q))= 1; 
        im2(cellstats_pre_ident{1,i}.ypix(q), cellstats_pre_ident{1, i}.xpix(q))= ID_pre_ROI(i);%transformation so that 0 is transparent 
    end    
end

%post MD 
for i=1:length(ID_post_ROI)
    for q=1:length(cellstats_post_ident{1,i}.ypix)
        im_post(cellstats_post_ident{1,i}.ypix(q), cellstats_post_ident{1, i}.xpix(q))= 1;         
        im3(cellstats_post_ident{1,i}.ypix(q), cellstats_post_ident{1, i}.xpix(q))= ID_post_ROI(i);%transformation so that 0 is transparent 
    end    
end

%0,unresp, 1 contra, 2 ipsi, 3 binoc 
%unresp will be transparent, so will be invisible 
%im is binary mask for transparency
roimask_pre=im_pre; 
roimask_post=im_post; 

%plot meanImg pre and post MD 
f9= figure; 
c5=gray; 
ax5=axes; 
colormap(c5); 
imagesc(pre_meanimg.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 
title('Pre MD')


f10= figure; 
c6=gray; 
ax6=axes; 
colormap(c6); 
imagesc(post_meanimg.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 
title('Post MD')


f11=figure('Name', 'Color coded Cell identity', 'NumberTitle','off'); 
tiledlayout(1,2)
nexttile
p10=imagesc(im2, 'AlphaDataMapping','none');
set(p10, 'AlphaData', roimask_pre); %make background transparent
CellIdentColorMap=parula (4); %make colormap
%CellIdentColorMap(1,:) = 1; %make first value white 
bar3=colorbar; 
bar3.Label.String= 'Cell ID'; 
bar3.Label.FontSize= 10; 
bar3.Location="southoutside";
colormap(CellIdentColorMap)
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
clim([0 3]); 

nexttile
f15=imagesc(im3, 'AlphaDataMapping','none');
set(f15, 'AlphaData', roimask_post); %make background transparent
%CellColorMap(1,:) = 1;
colormap(CellIdentColorMap)
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
clim([0 3]); 

%colorbar scale is modified so that 0 is not the background 

%save plots 
saveas(f9, fullfile(SaveDir, strcat(anim, '_MeanImagepreMDCellIdentity')), 'tif'); 
saveas(f9, fullfile(SaveDir, strcat(anim, '_MeanImagepreMDCellIdentity')), 'pdf'); 
saveas(f9, fullfile(SaveDir, strcat(anim, '_MeanImagepreMDCellIdentity')), 'fig'); 

saveas(f10, fullfile(SaveDir, strcat(anim, '_MeanImagepostMDCellIdentity')), 'tif'); 
saveas(f10, fullfile(SaveDir, strcat(anim, '_MeanImagepostMDCellIdentity')), 'pdf'); 
saveas(f10, fullfile(SaveDir, strcat(anim, '_MeanImagepostMDCellIdentity')), 'fig'); 

saveas(f11, fullfile(SaveDir,strcat(anim, '_CellIdentityROIs')), 'tif'); 
saveas(f11, fullfile(SaveDir,strcat(anim, '_CellIdentityROIs')), 'pdf'); 
saveas(f11, fullfile(SaveDir,strcat(anim, '_CellIdentityROIs')), 'fig'); 

%% Save as structure 

C=struct('C2C', C2C, 'C2I', C2I, 'C2B', C2B, 'C2U', C2U); 
I=struct('I2I', I2I, 'I2C', I2C, 'I2B', I2B, 'I2U', I2U); 
B=struct('B2B', B2B, 'B2C', B2C, 'B2I', B2I, 'B2U', B2U); 
U=struct('U2U', U2U, 'U2C', U2C, 'U2I', U2I, 'U2B', U2B); 

C_OSI=struct('C2C_OSI', C2C_OSI, 'C2I_OSI', C2I_OSI, 'C2B_OSI', C2B_OSI, 'C2U_OSI', C2U_OSI); 
I_OSI=struct('I2I_OSI', I2I_OSI, 'I2C_OSI', I2C_OSI, 'I2B_OSI', I2B_OSI, 'I2U_OSI', I2U_OSI); 
B_OSI=struct('B2B_OSI', B2B_OSI, 'B2C_OSI', B2C_OSI, 'B2I_OSI', B2I_OSI, 'B2U_OSI', B2U_OSI); 
U_OSI=struct('U2U_OSI', U2U_OSI, 'U2C_OSI', U2C_OSI, 'U2I_OSI', U2I_OSI, 'U2B_OSI', U2B_OSI); 

C_DSI=struct('C2C_DSI', C2C_DSI, 'C2I_DSI', C2I_DSI, 'C2B_DSI', C2B_DSI, 'C2U_DSI', C2U_DSI); 
I_DSI=struct('I2I_DSI', I2I_DSI, 'I2C_DSI', I2C_DSI, 'I2B_DSI', I2B_DSI, 'I2U_DSI', I2U_DSI); 
B_DSI=struct('B2B_DSI', B2B_DSI, 'B2C_DSI', B2C_DSI, 'B2I_DSI', B2I_DSI, 'B2U_DSI', B2U_DSI); 
U_DSI=struct('U2U_DSI', U2U_DSI, 'U2C_DSI', U2C_DSI, 'U2I_DSI', U2I_DSI, 'U2B_DSI', U2B_DSI); 

Cell_type=struct('CON', C, 'IPSI', I, 'BINOC', B, 'UNRESP', U); 
Cell_type_OSI=struct('CON_OSI', C_OSI, 'IPSI_OSI', I_OSI, 'BINOC_OSI', B_OSI, 'UNRESP_OSI', U_OSI); 
Cell_type_DSI=struct('CON_DSI', C_DSI, 'IPSI_DSI', I_DSI, 'BINOC_DSI', B_DSI, 'UNRESP_DSI', U_DSI); 

save(fullfile(SaveDir, strcat(anim, '_CellIdentity.mat')), 'Cell_type');
save(fullfile(SaveDir, strcat(anim, '_CellIdentity_OSI.mat')), 'Cell_type_OSI');
save(fullfile(SaveDir, strcat(anim, '_CellIdentity_DSI.mat')), 'Cell_type_DSI');

end 