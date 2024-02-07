function analyze_gratings(anim,day,fov,exp1, exp2)
%anim is anim ID , eg L007
%day is day of experiment in sequence "D1"
%exp1 is contralateral eye file
%exp2 is ipsilateral eye file 
global anim 

%if 1, then this is a drifting gratings experiment
analyze_drift=1; 

%if 1, then this is a flashing gratings experiment 
analyze_flash=1; 

%if 1, then both eye imaging files are concatenated
binocular_exp=1; 

%so it goes eye1, drifting then flashing and then eye2, drifting then
%flashing

%make sure contralateral eye file is first 

%% load the data 

%set SaveDir for drifting gratings 
global SaveDir
SaveDir = ['Z:\AnalyzedData\calcium\drifting_gratings\', anim, '\', day, '\'];
if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

%set SaveDir for flashing gratings
global SaveDir1
SaveDir1 = ['Z:\AnalyzedData\calcium\flashing_gratings\', anim, '\', day, '\'];
if exist(SaveDir1,'dir') == 0
            mkdir(SaveDir1)
end

%load the sbx .mat file with the stimulus frame on/off index
[stim_info_contra, stim_info_ipsi]= loadsbxmat (anim, day, fov, exp1, exp2); %because binocular experiment 

%load the suite2p data 
[Fall] = loadsuite2p(anim,day); 

%load the stimulus information, loaded as a table  
[stim_table_contra, stim_table_ipsi]= loadstimid(anim,day, exp1,exp2); %for contralateral eye and ipsilateral eye files  


%% load sbx parameters
%get stim on/off indices 
[stim_frame_contra]= trialinfo(stim_info_contra); %for contra eye
[stim_frame_ipsi]=trialinfo(stim_info_ipsi); %for ipsi eye 

%% extract data from suite2p Fall .mat file 
%normally, switch eye order presentation but then contralateral eye file is put
%first for segmentation 

contra_end=31640; %change this depending on what the last frame of the first eye file is 
ca_delay=7; 
%neuropil correction factor 
corr_factor=.7; %according to suite2p documentation, we can start with this

%get the indices of cells, don't do this analysis for non-cell ROIs 
iscellind= find (Fall.iscell(:,1)==1); %indices of cells 

for i=1:length(iscellind)
    if max(Fall.F(i,:))-min(Fall.F(i,:))==0
        iscellind(i)=0; %remove any traces that are zero
    end
end 
iscellind(iscellind==0)=[]; 
global numCells; 

numCells=length(iscellind); % count all 'iscell'= total ROIs that are cells
cells.total.GCaMP=numCells; %make structure with cell information 

%neuropil correction of F
F_corr_cells= Fall.F(iscellind,:)-(corr_factor*Fall.Fneu(iscellind,:)); %extract info only for cells 

%normalize fluorescences (you don't want negative fluorescence), make min 0
F_corr_cells=F_corr_cells-min(F_corr_cells, [], 2); 

Fneu_cell=Fall.Fneu(iscellind,:); %neuropil for cells 
F_cell=Fall.F(iscellind,:); %F raw for cells 

%now we must split F and Fneu, and spks into contralateral and ipsilateral
%if a binocular experiment
 
if binocular_exp==1 
    F_contra= F_cell(:,1:contra_end); %raw F for cells 
    Fneu_contra=Fneu_cell(:,1:contra_end); %raw neuropil for cells  
    F_corr_cells_contra= F_corr_cells(:,1:contra_end);%neuropil correct F for cells 
    spks_contra=Fall.spks(:,1:contra_end); %spikes for 

    F_ipsi=F_cell (:, contra_end+1:end); %raw F for cells 
    Fneu_ipsi=Fneu_cell(:, contra_end+1:end);%raw neuropil for cells  
    F_corr_cells_ipsi=F_corr_cells(:, contra_end+1:end); % neuropil corrected 
    spks_ipsi=Fall.spks(:, contra_end+1:end);
end 


%% Get trial information, e.g. orientations, sfs used 

%if drifting and flashing gratings experiment  
if (analyze_drift ==1) && (analyze_flash==1) %this should be the same for both eyes 
    %DRIFTING, for contralateral eye 
    [unique_trial_drift_contra,stimulus_drift_contra] = uniquetrial_drifting(stim_table_contra);
     unique_trialnum_drift_contra= size (unique_trial_drift_contra,1); %number of unique  trial conditions
     unique_sf_drift_contra= unique (unique_trial_drift_contra(:,1)); % unique spatial freq, sorted
     unique_ori_drift_contra= unique (unique_trial_drift_contra(:,2)); %unique orientation , sorted
    %DRIFTING, for ipsilateral eye 
    [unique_trial_drift_ipsi,stimulus_drift_ipsi] = uniquetrial_drifting(stim_table_ipsi);
     unique_trialnum_drift_ipsi= size (unique_trial_drift_ipsi,1); %number of unique  trial conditions
     unique_sf_drift_ipsi= unique (unique_trial_drift_ipsi(:,1)); % unique spatial freq, sorted
     unique_ori_drift_ipsi= unique (unique_trial_drift_ipsi(:,2)); %unique orientation , sorted
    
     %FLASHING, for contralateral eye
     [unique_trial_flash_contra,stimulus_flash_contra] = uniquetrial_flashing(stim_table_contra);
     unique_trialnum_flash_contra= size (unique_trial_flash_contra,1); %number of unique  trial conditions
     unique_sf_flash_contra= unique (unique_trial_flash_contra(:,1)); %unique spatial freq, sorted
     unique_ori_flash_contra= unique (unique_trial_flash_contra(:,2)); %unique orientation, sorted
     unique_sp_flash_contra= unique (unique_trial_flash_contra(:,3)); %unique spatial phase , sorted
     %FLASHING, for ipsilateral eye 
     [unique_trial_flash_ipsi,stimulus_flash_ipsi] = uniquetrial_flashing(stim_table_ipsi);
     unique_trialnum_flash_ipsi= size (unique_trial_flash_ipsi,1); %number of unique  trial conditions
     unique_sf_flash_ipsi= unique (unique_trial_flash_ipsi(:,1)); %unique spatial freq, sorted
     unique_ori_flash_ipsi= unique (unique_trial_flash_ipsi(:,2)); %unique orientation, sorted
     unique_sp_flash_ipsi= unique (unique_trial_flash_ipsi(:,3)); %unique spatial phase , sorted
end

%% get dFoF for each eye for drifting gratings, if binocular experiment  

%for contralateral eye 
[dFoF_on_peak_drift_contra,dFoF_on_drift_contra, dFoF_off_drift_contra, bs_drift_contra, alldFoF_drift_contra] = dFoF_drifting(...
    stim_frame_contra,F_corr_cells_contra, ca_delay,numCells);

%for ipsilateral eye 
[dFoF_on_peak_drift_ipsi,dFoF_on_drift_ipsi, dFoF_off_drift_ipsi, bs_drift_ipsi, alldFoF_drift_ipsi] = dFoF_drifting(...
    stim_frame_ipsi,F_corr_cells_ipsi, ca_delay,numCells);

%for drifting gratings, CONTRALATERAL  
    for j=1:unique_trialnum_drift_contra % for every unique trial , one field in index 
      ind_drift_contra(:,j)= ismember(stimulus_drift_contra, unique_trial_drift_contra (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
      indices.drift.contra(j).trial_rep= find(ind_drift_contra(:,j)==1); % index of where j trial is in entire trial sequence 
      indices.drift.contra(j).pos= stimulus_drift_contra(j,:); 

    %now organize for sf 
     for l= 1:length(unique_sf_drift_contra)
            indices.drift.contra(l).sfloc= find (stimulus_drift_contra(:,1)==unique_sf_drift_contra(l)); %index to find this trial in  
            indices.drift.contra(l).sf=unique_sf_drift_contra(l); %what is the actual spatial frequency value
        end 
    % now organize for ori
        for m= 1:length(unique_ori_drift_contra)
            indices.drift.contra(m).oriloc= find (stimulus_drift_contra(:,2)==unique_ori_drift_contra(m)); %index to find this trial in  
            indices.drift.contra(m).ori=unique_ori_drift_contra(m); %what is the actual orientation value
        end 

    % now index into dfoF file to make a new structure for each cell ROI  
        for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
            dFoF.drift.contra.conds(j).cells(k).trial_num=indices.drift.contra(j).trial_rep; %unique trial ID 
           % dFoF.drift.contra.conds(j).cells(k).peak=max(abs(mean(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),3)),[], 3); 
            dFoF.drift.contra.conds(j).cells(k).peak=dFoF_on_peak_drift_contra(k, indices.drift.contra(j).trial_rep); 

           % dFoF.drift.contra.conds(j).cells(k).mean_peak=mean(max(abs(mean(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),3)),[], 3));
            dFoF.drift.contra.conds(j).cells(k).mean_peak=mean(dFoF_on_peak_drift_contra(k, indices.drift.contra(j).trial_rep)); 

            dFoF.drift.contra.conds(j).cells(k).var=var(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:), 0); 
            dFoF.drift.contra.conds(j).cells(k).traces=dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:); 
            dFoF.drift.contra.conds(j).cells(k).avg_trace=mean(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),2); %mean along 2nd dimension (trial reps)
            dFoF.drift.contra.conds(j).cells(k).std_trace=std(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),0, 2);
            
            dFoF.drift.contra.conds(j).cells(k).off_mean=mean(dFoF_off_drift_contra(k, indices.drift.contra(j).trial_rep)); 
            dFoF.drift.contra.conds(j).cells(k).off_traces=dFoF_off_drift_contra(k, indices.drift.contra(j).trial_rep);
            dFoF.drift.contra.conds(j).cells(k).off_std=std(dFoF_off_drift_contra(k, indices.drift.contra(j).trial_rep)); 
            dFoF.drift.contra.conds(j).cells(k).trace=alldFoF_drift_contra(k, indices.drift.contra(j).trial_rep); %whole trace 
    %   dFoF_conds(j).cells(k).std_trace=std(abs(dFoF_during(k, indices(j).drift_trial_rep),2));
        end 
    end


%for drifting gratings, IPSILATERAL   
    for j=1:unique_trialnum_drift_ipsi % for every unique trial , one field in index 
      ind_drift_ipsi(:,j)= ismember(stimulus_drift_ipsi, unique_trial_drift_ipsi (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
      indices.drift.ipsi(j).trial_rep= find(ind_drift_ipsi(:,j)==1); % index of where j trial is in entire trial sequence 
      indices.drift.ipsi(j).pos= stimulus_drift_ipsi(j,:); 

    %now organize for sf 
        for l= 1:length(unique_sf_drift_ipsi)
            indices.drift.ipsi(l).sfloc= find (stimulus_drift_ipsi(:,1)==unique_sf_drift_ipsi(l)); %index to find this trial in  
            indices.drift.ipsi(l).sf=unique_sf_drift_ipsi(l); %what is the actual spatial frequency value
        end 
    % now organize for ori
        for m= 1:length(unique_ori_drift_ipsi)
            indices.drift.ipsi(m).oriloc= find (stimulus_drift_ipsi(:,2)==unique_ori_drift_ipsi(m)); %index to find this trial in  
            indices.drift.ipsi(m).ori=unique_ori_drift_ipsi(m); %what is the actual orientation value
        end 

    % now index into dfoF file to make a new structure for each cell ROI  
        for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
            dFoF.drift.ipsi.conds(j).cells(k).trial_num=indices.drift.ipsi(j).trial_rep; %unique trial ID 
         

            dFoF.drift.ipsi.conds(j).cells(k).peak=dFoF_on_peak_drift_ipsi(k, indices.drift.ipsi(j).trial_rep); 
           
           dFoF.drift.ipsi.conds(j).cells(k).mean_peak= mean(dFoF_on_peak_drift_ipsi(k, indices.drift.ipsi(j).trial_rep)); 
            dFoF.drift.ipsi.conds(j).cells(k).var=var(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep), 0); 
            dFoF.drift.ipsi.conds(j).cells(k).traces=dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:); 
            dFoF.drift.ipsi.conds(j).cells(k).avg_trace=mean(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:),2);
            dFoF.drift.ipsi.conds(j).cells(k).std_trace=std(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:),0,2);
            
            dFoF.drift.ipsi.conds(j).cells(k).off_mean=mean(dFoF_off_drift_ipsi(k, indices.drift.ipsi(j).trial_rep)); 
            dFoF.drift.ipsi.conds(j).cells(k).off_traces=dFoF_off_drift_ipsi(k, indices.drift.ipsi(j).trial_rep);
            dFoF.drift.ipsi.conds(j).cells(k).off_std=std(dFoF_off_drift_ipsi(k, indices.drift.ipsi(j).trial_rep)); 
            dFoF.drift.ipsi.conds(j).cells(k).trace=alldFoF_drift_ipsi(k,indices.drift.ipsi(j).trial_rep); %whole trace 
    %   dFoF_conds(j).cells(k).std_trace=std(abs(dFoF_during(k, indices(j).drift_trial_rep),2));
        end
    end

%% get dFoF for each eye for FLASHING gratings, if binocular experiment  

%for contralateral eye 
[dFoF_on_peak_flash_contra,dFoF_on_flash_contra, bs_flash_contra, alldFoF_flash_contra, numTrialsFlash] = dFoF_flashing(...
    stim_frame_contra,F_corr_cells_contra, ca_delay,numCells);

%for ipsilateral eye 
[dFoF_on_peak_flash_ipsi,dFoF_on_flash_ipsi, bs_flash_ipsi, alldFoF_flash_ipsi,numTrialsFlash] = dFoF_flashing(...
    stim_frame_ipsi,F_corr_cells_ipsi, ca_delay,numCells);

%for both eyes 
[spks_trial_contra, spks_trial_ipsi, numTrials_contra, numTrials_ipsi]=getspks(spks_contra, stim_frame_contra, spks_ipsi, stim_frame_ipsi, numCells);

%do a correction because sometimes stops logging TTL pulses 
stimulus_flash_contra=stimulus_flash_contra(1:numTrials_contra,:,:); 
stimulus_flash_ipsi=stimulus_flash_ipsi(1:numTrials_ipsi,:,:); 

%for flashing gratings, CONTRALATERAL  
    for j=1:unique_trialnum_flash_contra % for every unique trial , one field in index 
      ind_flash_contra(:,j)= ismember(stimulus_flash_contra, unique_trial_flash_contra (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
      indices.flash.contra(j).trial_rep= find(ind_flash_contra(:,j)==1); % index of where j trial is in entire trial sequence 
      indices.flash.contra(j).pos= stimulus_flash_contra(j,:); 
    
    %now organize for sf 
     for l= 1:length(unique_sf_flash_contra)
            indices.flash.contra(l).sfloc= find (stimulus_flash_contra(:,1)==unique_sf_flash_contra(l)); %index to find this trial in  
            indices.flash.contra(l).sf=unique_sf_flash_contra(l); %what is the actual spatial frequency value
        end 
    % now organize for ori
        for m= 1:length(unique_ori_flash_contra)
            indices.flash.contra(m).oriloc= find (stimulus_flash_contra(:,2)==unique_ori_flash_contra(m)); %index to find this trial in  
            indices.flash.contra(m).ori=unique_ori_flash_contra(m); %what is the actual orientation value
        end 

    % now index into dfoF file AND SPKS to make a new structure for each cell ROI  
        for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
%             dFoF.flash.contra.conds(j).cells(k).trial_num=indices.flash.contra(j).trial_rep; %unique trial ID 
%             dFoF.flash.contra.conds(j).cells(k).peak=dFoF_on_peak_flash_contra(k, indices.flash.contra(j).trial_rep); 
%             dFoF.flash.contra.conds(j).cells(k).mean_peak=mean(dFoF_on_peak_flash_contra(k, indices.flash.contra(j).trial_rep));
%             dFoF.flash.contra.conds(j).cells(k).var=var(dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep), 0); 
%             dFoF.flash.contra.conds(j).cells(k).traces=dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep); 
%             dFoF.flash.contra.conds(j).cells(k).avg_trace=mean(dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep),2);
%             dFoF.flash.contra.conds(j).cells(k).std_trace=std(dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep));
            spks.conds(j).cells(k).contra.trial_num= indices.flash.contra(j).trial_rep;
            spks.conds(j).cells(k).contra.spks= spks_trial_contra(i, indices.flash.contra(j).trial_rep, :); 

    %   dFoF_conds(j).cells(k).std_trace=std(abs(dFoF_during(k, indices(j).flash_trial_rep),2));
        end 
    end


%for flashing gratings, IPSILATERAL   
    for j=1:unique_trialnum_flash_ipsi % for every unique trial , one field in index 
      ind_flash_ipsi(:,j)= ismember(stimulus_flash_ipsi, unique_trial_flash_ipsi (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
      indices.flash.ipsi(j).trial_rep= find(ind_flash_ipsi(:,j)==1); % index of where j trial is in entire trial sequence 
      indices.flash.ipsi(j).pos= stimulus_flash_ipsi(j,:); 
    
    %now organize for sf 
        for l= 1:length(unique_sf_flash_ipsi)
            indices.flash.ipsi(l).sfloc= find (stimulus_flash_ipsi(:,1)==unique_sf_flash_ipsi(l)); %index to find this trial in  
            indices.flash.ipsi(l).sf=unique_sf_flash_ipsi(l); %what is the actual spatial frequency value
        end 
    % now organize for ori
        for m= 1:length(unique_ori_flash_ipsi)
            indices.flash.ipsi(m).oriloc= find (stimulus_flash_ipsi(:,2)==unique_ori_flash_ipsi(m)); %index to find this trial in  
            indices.flash.ipsi(m).ori=unique_ori_flash_ipsi(m); %what is the actual orientation value
        end 

    % now index into dfoF file to make a new structure for each cell ROI  
        for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
%             dFoF.flash.ipsi.conds(j).cells(k).trial_num=indices.flash.ipsi(j).trial_rep; %unique trial ID 
%             dFoF.flash.ipsi.conds(j).cells(k).peak=dFoF_on_peak_flash_ipsi(k, indices.flash.ipsi(j).trial_rep); 
%             dFoF.flash.ipsi.conds(j).cells(k).mean_peak=mean(dFoF_on_peak_flash_ipsi(k, indices.flash.ipsi(j).trial_rep));
%             dFoF.flash.ipsi.conds(j).cells(k).var=var(dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep), 0); 
%             dFoF.flash.ipsi.conds(j).cells(k).traces=dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep); 
%             dFoF.flash.ipsi.conds(j).cells(k).avg_trace=mean(dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep),2);
%             dFoF.flash.ipsi.conds(j).cells(k).std_trace=std(dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep));

            spks.conds(j).cells(k).ipsi.trial_num= indices.flash.ipsi(j).trial_rep;
            spks.conds(j).cells(k).ipsi.spks= spks_trial_ipsi(i, indices.flash.ipsi(j).trial_rep, :); 
        end
    end
%% organize conditions- DRIFTING GRATINGS 

%for contralateral eye 
for qq=1:unique_trialnum_drift_contra 
    for kk=1:numCells
        stimconds_drift_contra(qq, 1:(length(dFoF.drift.contra.conds(qq).cells(kk).peak)), kk)= cat(1,dFoF.drift.contra.conds(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
        stimconds_drift_contra_trials(qq,1:(length(dFoF.drift.contra.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.drift.contra.conds(qq).cells(kk).trial_num); 
        stimconds_drift_contra_off(qq, 1:(length(dFoF.drift.contra.conds(qq).cells(kk).off_traces)), kk)= cat(1,dFoF.drift.contra.conds(qq).cells(kk).off_traces); %each slice is a cell, each row a unique trial and column a rep of that trial         
    end
end

%for ipsilateral eye 
for qq=1:unique_trialnum_drift_ipsi
    for kk=1:numCells
        stimconds_drift_ipsi(qq, 1:(length(dFoF.drift.ipsi.conds(qq).cells(kk).peak)), kk)= cat(1,dFoF.drift.ipsi.conds(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
        stimconds_drift_ipsi_trials(qq,1:(length(dFoF.drift.ipsi.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.drift.ipsi.conds(qq).cells(kk).trial_num); 
        stimconds_drift_ipsi_off(qq, 1:(length(dFoF.drift.ipsi.conds(qq).cells(kk).off_traces)), kk)= cat(1,dFoF.drift.ipsi.conds(qq).cells(kk).off_traces); %each slice is a cell, each row a unique trial and column a rep of that trial         
    end
end

%make stimconds matrix will be 5 (reps)x 32(unique trials)x  (cells) 
%for contralateral eye 
stimconds_drift_contra(stimconds_drift_contra==0)=nan;
stimconds_drift_contra= permute(stimconds_drift_contra, [2 1 3]);% make column-wise so reps are in the same column

stimconds_drift_contra_off(stimconds_drift_contra_off==0)=nan;
stimconds_drift_contra_off= permute(stimconds_drift_contra_off, [2 1 3]);% make column-wise so reps are in the same column

stimconds_drift_contra_trials(stimconds_drift_contra_trials==0)=nan;
stimconds_drift_contra_trials= permute(stimconds_drift_contra_trials, [2 1 3]);

%for ipsilateral eye 
stimconds_drift_ipsi(stimconds_drift_ipsi==0)=nan;
stimconds_drift_ipsi= permute(stimconds_drift_ipsi, [2 1 3]);% make column-wise so reps are in the same column

stimconds_drift_ipsi_off(stimconds_drift_ipsi_off==0)=nan;
stimconds_drift_ipsi_off= permute(stimconds_drift_ipsi_off, [2 1 3]);% make column-wise so reps are in the same column

stimconds_drift_ipsi_trials(stimconds_drift_ipsi_trials==0)=nan;
stimconds_drift_ipsi_trials= permute(stimconds_drift_ipsi_trials, [2 1 3]);

%Calculate reliability metrics for each eye : 
for j=1:unique_trialnum_drift_contra
    for q=1:numCells
        response_CV_contra(j,q)= std(stimconds_drift_contra(:,j,q)) ./ mean(stimconds_drift_contra(:,j,q)); %response reliability metric for each stimulus condition 
    end
end

for j=1:unique_trialnum_drift_ipsi
    for q=1:numCells
        response_CV_ipsi(j,q)= std(stimconds_drift_ipsi(:,j,q)) ./ mean(stimconds_drift_ipsi(:,j,q)); %response reliability metric for each stimulus condition 
    end
end

% %% organize conditions- FLASHING gratings 
% 
% %for contralateral eye 
% for qq=1:unique_trialnum_flash_contra 
%     for kk=1:numCells
%         stimconds_flash_contra(qq, 1:(length(dFoF.flash.contra.conds(qq).cells(kk).peak)), kk)= cat(1,dFoF.flash.contra.conds(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
%         stimconds_flash_contra_trials(qq,1:(length(dFoF.flash.contra.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.flash.contra.conds(qq).cells(kk).trial_num); 
%                 
%     end
% end
% 
% %for ipsilateral eye 
% for qq=1:unique_trialnum_flash_ipsi
%     for kk=1:numCells
%         stimconds_flash_ipsi(qq, 1:(length(dFoF.flash.ipsi.conds(qq).cells(kk).peak)), kk)= cat(1,dFoF.flash.ipsi.conds(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
%         stimconds_flash_ipsi_trials(qq,1:(length(dFoF.flash.ipsi.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.flash.ipsi.conds(qq).cells(kk).trial_num); 
%         
%     end
% end
% 
% %make stimconds matrix will be 5 (reps)x 32(unique trials)x  (cells) 
% %for contralateral eye 
% stimconds_flash_contra(stimconds_flash_contra==0)=nan;
% stimconds_flash_contra= permute(stimconds_flash_contra, [2 1 3]);% make column-wise so reps are in the same column
% 
% stimconds_flash_contra_trials(stimconds_flash_contra_trials==0)=nan;
% stimconds_flash_contra_trials= permute(stimconds_flash_contra_trials, [2 1 3]);
% 
% %for ipsilateral eye 
% stimconds_flash_ipsi(stimconds_flash_ipsi==0)=nan;
% stimconds_flash_ipsi= permute(stimconds_flash_ipsi, [2 1 3]);% make column-wise so reps are in the same column
% 
% stimconds_flash_ipsi_trials(stimconds_flash_ipsi_trials==0)=nan;
% stimconds_flash_ipsi_trials= permute(stimconds_flash_ipsi_trials, [2 1 3]);
% 
% %Calculate reliability metrics for each eye : 
% for j=1:unique_trialnum_flash_contra
%     for q=1:numCells
%         response_CV_flash_contra(j,q)= std(stimconds_flash_contra(:,j,q)) ./ mean(stimconds_flash_contra(:,j,q)); %response reliability metric for each stimulus condition 
%     end
% end
% 
% for j=1:unique_trialnum_flash_ipsi
%     for q=1:numCells
%         response_CV_flash_ipsi(j,q)= std(stimconds_flash_ipsi(:,j,q)) ./ mean(stimconds_flash_ipsi(:,j,q)); %response reliability metric for each stimulus condition 
%     end
% end


%% DRIFTING GRATINGS- now look at orientation and spatial frequency preferences 
%for visually responsive cells 
%contralateral eye 
for kk=1:numCells 
        for j=1:length(unique_sf_drift_contra) %spatial freq
            dFoF.drift.contra.sf(j).cells(kk).peak= dFoF_on_peak_drift_contra(kk, indices.drift.contra(j).sfloc); 
            dFoF.drift.contra.sf(j).cells(kk).traces= dFoF_on_drift_contra(kk, indices.drift.contra(j).sfloc,:); 
            dFoF.drift.contra.sf(j).cells(kk).avgtrace= mean(dFoF_on_drift_contra(kk, indices.drift.contra(j).sfloc,:),2);
        end
        
        for k=1:length(unique_ori_drift_contra) %orientation
            dFoF.drift.contra.ori(k).cells(kk).peak= dFoF_on_peak_drift_contra(kk, indices.drift.contra(k).oriloc);
            dFoF.drift.contra.ori(k).cells(kk).traces= dFoF_on_drift_contra(kk, indices.drift.contra(k).oriloc,:);
            dFoF.drift.contra.ori(k).cells(kk).avgtrace= mean(dFoF_on_drift_contra(kk, indices.drift.contra(k).oriloc,:),2);
        end
end
%ipsilateral eye 
for kk=1:numCells
        for j=1:length(unique_sf_drift_ipsi) %spatial freq
            dFoF.drift.ipsi.sf(j).cells(kk).peak= dFoF_on_peak_drift_ipsi(kk, indices.drift.ipsi(j).sfloc);
            dFoF.drift.ipsi.sf(j).cells(kk).traces= dFoF_on_drift_ipsi(kk, indices.drift.ipsi(j).sfloc,:);
            dFoF.drift.ipsi.sf(j).cells(kk).avgtrace= mean(dFoF_on_drift_ipsi(kk, indices.drift.ipsi(j).sfloc,:),2);
        end
        for k=1:length(unique_ori_drift_ipsi) %orientation
            dFoF.drift.ipsi.ori(k).cells(kk).peak=dFoF_on_peak_drift_ipsi(kk, indices.drift.ipsi(k).oriloc);
            dFoF.drift.ipsi.ori(k).cells(kk).traces= dFoF_on_drift_ipsi(kk, indices.drift.ipsi(k).oriloc,:);
            dFoF.drift.ipsi.ori(k).cells(kk).avgtrace= mean(dFoF_on_drift_ipsi(kk, indices.drift.ipsi(k).oriloc,:),2);
        end
end

% CONTRALATERAL EYE 
%organize by sf 
for qq=1:length(unique_sf_drift_contra)
    for kk=1:numCells
        resp_sf_drift_contra(qq, 1:(length(dFoF.drift.contra.sf(qq).cells(kk).peak)), kk)= cat(1,dFoF.drift.contra.sf(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
    end
end
%organize by ori 
for qq=1:length(unique_ori_drift_contra)
    for kk=1:numCells
        resp_ori_drift_contra(qq, 1:(length(dFoF.drift.contra.ori(qq).cells(kk).peak)), kk)= cat(1,dFoF.drift.contra.ori(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
    end
end

% IPSILATERAL EYE 
%organize by sf 
for qq=1:length(unique_sf_drift_ipsi)
    for kk=1:numCells
        resp_sf_drift_ipsi(qq, 1:(length(dFoF.drift.ipsi.sf(qq).cells(kk).peak)), kk)= cat(1,dFoF.drift.ipsi.sf(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
    end
end
%organize by ori 
for qq=1:length(unique_ori_drift_ipsi)
    for kk=1:numCells
        resp_ori_drift_ipsi(qq, 1:(length(dFoF.drift.ipsi.ori(qq).cells(kk).peak)), kk)= cat(1,dFoF.drift.ipsi.ori(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
    end
end

%rearrange so that reps are in a column, each slice is a cell, and each
%trial is a row 

%CONTRALATERAL EYE 
%spatial frequency 
resp_sf_drift_contra(resp_sf_drift_contra==0)=nan;
resp_sf_drift_contra= permute(resp_sf_drift_contra, [2 1 3]);
sf_trialnum_drift_contra=length(dFoF.drift.contra.sf(1).cells(1).peak); %how many times is each sf presented? 

%orientation
resp_ori_drift_contra(resp_ori_drift_contra==0)=nan;
resp_ori_drift_contra= permute(resp_ori_drift_contra, [2 1 3]);
ori_trialnum_drift_contra=length(dFoF.drift.contra.ori(1).cells(1).peak); %how many times is each ori presented? 

%IPSILATERAL EYE 
%spatial frequency
resp_sf_drift_ipsi(resp_sf_drift_ipsi==0)=nan;
resp_sf_drift_ipsi= permute(resp_sf_drift_ipsi, [2 1 3]);
sf_trialnum_drift_ipsi=length(dFoF.drift.ipsi.sf(1).cells(1).peak); %how many times is each sf presented?

%orientation
resp_ori_drift_ipsi(resp_ori_drift_ipsi==0)=nan;
resp_ori_drift_ipsi= permute(resp_ori_drift_ipsi, [2 1 3]);
ori_trialnum_drift_ipsi=length(dFoF.drift.ipsi.ori(1).cells(1).peak); %how many times is each ori presented

%% does each eye have a significant visual response to any drifting grating condition? 
%test again the set threshold "threshold_active_contra" or
%"threshold_active_ipsi" 
%this method is from Rose, Jaepel, Hubener, and Bonhoeffer, 2016.
%"Cell-specific restoration of stimulus preference after monocular deprivation in the visual cortex"
%Science, doi: 10.1126/science.aad3358

%make a separate threshold for drifting and flashing gratings just in case
%there is any photobleaching 

median_contra_dFoF= zeros(1, numCells); 
median_ipsi_dFoF= zeros(1, numCells);

%Do this for both eyes     
for i=1:numCells
    median_contra_dFoF(i)=median(alldFoF_contra(i,:),'all'); %contralateral eye
    median_ipsi_dFoF(i)= median(alldFoF_ipsi (i,:),'all'); % ipsilateral eye 
end 

%set different threshold for drifting or flashing 
std_lowerdFoF_contra_flash= zeros(1, numCells); 
std_lowerdFoF_contra_drift= zeros(1, numCells); 

for i=1:numCells
    indices.drift.cells(i).contra.std = find(alldFoF_drift_contra(i,:)<0); %contralateral eye
    std_lowerdFoF_contra_drift(i)= std(alldFoF_drift_contra(i,indices.drift.cells(i).contra.std));
    indices.drift.cells(i).ipsi.std = find(alldFoF_drift_ipsi(i,:)<0); %ipsilateral eye 
    std_lowerdFoF_ipsi_drift(i)= std(alldFoF_drift_ipsi(i,indices.drift.cells(i).ipsi.std));   
end

%threshold of activity/ visual responsivity for each eye 

threshold_active_contra_drift=std_lowerdFoF_contra_drift*2; 
threshold_active_ipsi_drift=std_lowerdFoF_ipsi_drift*2; 

visresp_cells_drift_contra=zeros(16, numCells); 
visresp_cells_drift_ipsi=zeros(ori_trialnum_drift_ipsi, numCells); 

%for contralateral eye responses 
for q=1:numCells
    for j=1:16 
        mean_resp_ori_drift_contra(j,q)= squeeze(mean(resp_ori_drift_contra(:,j,q))); 
        if length(find(mean_resp_ori_drift_contra(j,q)>= threshold_active_contra_drift(q)))>=1
            visresp_cells_drift_contra(j,q)=1; %matrix of vis resp cells, 0/1
        end
    end
end

%for ipsilateral eye responses 
for q=1:numCells
    for j=1:16    
        mean_resp_ori_drift_ipsi(j,q)= squeeze(mean(resp_ori_drift_ipsi(:,j,q))); 
        if length(find(mean_resp_ori_drift_ipsi(j,q)>= threshold_active_ipsi_drift(q)))>=1
            visresp_cells_drift_ipsi(j,q)=1; %matrix of vis resp cells, 0/1
        end
    end
end

%check to see in how many cells there is a threshold cross 
visresp_cells_total_contra_drift=zeros(1,numCells); 
visresp_cells_total_ipsi_drift =zeros(1,numCells); 

%contralateral eye 
for q=1:numCells
    if length(find(visresp_cells_drift_contra(:,q)==1))>=1
        visresp_cells_total_contra_drift(q)=1; 
    end
end

%ipsilateral eye 
for q=1:numCells
    if length(find(visresp_cells_drift_ipsi(:,q)==1))>=1
        visresp_cells_total_ipsi_drift(q)=1; 
    end
end

%make matrix to code for whether cell was responsive to neither eye (0),
%contralateral (1), ipsilateral (2), or both (3) 

visresp_cells_total_drift=zeros(1,numCells);
for q=1:numCells 
    if (length(find(visresp_cells_total_contra_drift(q)==1))==0) && (length(find(visresp_cells_total_ipsi_drift(q)==1))==0) 
        visresp_cells_total_drift(q)=0; %then not responsive to input from either eye 
    elseif (length(find(visresp_cells_total_contra_drift(q)==1))==1) && (length(find(visresp_cells_total_ipsi_drift(q)==1))==0) 
        visresp_cells_total_drift(q)=1; %only contralateral eye 
    elseif (length(find(visresp_cells_total_contra_drift(q)==1))==0) && (length(find(visresp_cells_total_ipsi_drift(q)==1))==1) 
        visresp_cells_total_drift(q)=2; %only ipsilateral eye 
    elseif (length(find(visresp_cells_total_contra_drift(q)==1))==1) && (length(find(visresp_cells_total_ipsi_drift(q)==1))==1) 
        visresp_cells_total_drift(q)=3; %both eyes 
    end
end
%% plot percent visually responsive to DRIFTING GRATINGS

num_visresp_drift=length(find(visresp_cells_total_drift>0));
percent_visresp_drift=num_visresp_drift/numCells; 
plotresponsivecells(num_visresp_drift,numCells,'drift');   

 %% Flashing gratings- visual responsivity 
% get spiking during stim on 
%get std for all trial reps
%find where max std is- this is the optimal delay (tmax)
%signal= mean of spiking standard deviation 4-8 frames after stim 

 %contralateral eye 
 for kk=1:numCells
         for j=1:length(unique_sf_flash_contra) %spatial freq
             spks.sf(j).cells(kk).contra.spks=squeeze(spks_trial_contra(kk,indices.flash.contra(j).sfloc,:)); 
             q=spks.sf(j).cells(kk).contra.spks;   
             l=std(q,1,1);    
             l(l==0)=nan;
            [kmax,t] = max(l);
             s= mean(l(9:13)); 
             snr = s/mean(l([2 3 4 20:25]));
             tmax = t;
            spks.sf(j).cells(kk).contra.snr=snr; 
            spks.sf(j).cells(kk).contra.stdmax=kmax; 
            spks.sf(j).cells(kk).contra.std=l; 
            spks.sf(j).cells(kk).contra.tmax=tmax; 

            % find preferred orientation and spatial frequency 

         end
         for k=1:length(unique_ori_flash_contra) %orientation
             spks.ori(k).cells(kk).contra.spks=spks_trial_contra(kk,indices.flash.contra(k).oriloc,:);
             q=spks.ori(k).cells(kk).contra.spks;   
             l=std(q,1,1); 
             l(l==0)=nan;
            [kmax,t] = max(l);
            s=mean(l(9:13)); 
             snr = s/mean(l([2 3 4 20:25]));
             tmax = t;
            spks.ori(k).cells(kk).contra.snr=snr; 
            spks.ori(k).cells(kk).contra.stdmax=kmax; 
            spks.ori(k).cells(kk).contra.std=l; 
            spks.ori(k).cells(kk).contra.tmax=tmax; 

            % find preferred orientation and spatial frequency 

         end
 end
 %ipsilateral eye 
 %contralateral eye 
 for kk=1:numCells
         for j=1:length(unique_sf_flash_ipsi) %spatial freq
             spks.sf(j).cells(kk).ipsi.spks=squeeze(spks_trial_ipsi(kk,indices.flash.ipsi(j).sfloc,:)); 
             q=spks.sf(j).cells(kk).ipsi.spks;   
             l=std(q,1,1);    
             l(l==0)=nan; 
            [kmax,t] = max(l);
             s= mean(l(9:13)); 
             snr = s/mean(l([2 3 4 20:25]),'omitnan');
             tmax = t;
            spks.sf(j).cells(kk).ipsi.snr=snr; 
            spks.sf(j).cells(kk).ipsi.stdmax=kmax; 
            spks.sf(j).cells(kk).ipsi.std=l; 
            spks.sf(j).cells(kk).ipsi.tmax=tmax; 
         end
         for k=1:length(unique_ori_flash_ipsi) %orientation
             spks.ori(k).cells(kk).ipsi.spks=spks_trial_ipsi(kk,indices.flash.ipsi(k).oriloc,:);
             q=spks.ori(k).cells(kk).ipsi.spks;   
             l=std(q,1,1);   
             l(l==0)=nan;
            [kmax,t] = max(l);
            s=mean(l(9:13)); 
             snr = s/mean(l([2 3 4 20:25]),'omitnan');
             tmax = t;
            spks.ori(k).cells(kk).ipsi.snr=squeeze(snr); 
            spks.ori(k).cells(kk).ipsi.stdmax=kmax; 
            spks.ori(k).cells(kk).ipsi.std=l; 
            spks.ori(k).cells(kk).ipsi.tmax=tmax; 
         end
 end





% for kk=1:numCells
%         for j=1:length(unique_sf_flash_ipsi) %spatial freq
%             dFoF.flash.ipsi.sf(j).cells(kk).peak= dFoF_on_peak_flash_ipsi(kk, indices.flash.ipsi(j).sfloc);
%             dFoF.flash.ipsi.sf(j).cells(kk).traces= dFoF_on_flash_ipsi(kk, indices.flash.ipsi(j).sfloc);
%             dFoF.flash.ipsi.sf(j).cells(kk).avgtrace= mean(dFoF_on_flash_ipsi(kk, indices.flash.ipsi(j).sfloc),2);
%         end
%         for k=1:length(unique_ori_flash_ipsi) %orientation
%             dFoF.flash.ipsi.ori(k).cells(kk).peak= dFoF_on_peak_flash_ipsi(kk, indices.flash.ipsi(k).oriloc);
%             dFoF.flash.ipsi.ori(k).cells(kk).traces= dFoF_on_flash_ipsi(kk, indices.flash.ipsi(k).oriloc);
%             dFoF.flash.ipsi.ori(k).cells(kk).avgtrace= mean(dFoF_on_flash_ipsi(kk, indices.flash.ipsi(k).oriloc),2);
%         end
% end
% 
% % CONTRALATERAL EYE 
% %pad matrices 
% resp_sf_flash_contra=zeros(length(unique_sf_flash_contra), length(dFoF.flash.contra.sf(1).cells(1).peak), numCells); 
% resp_ori_flash_contra=zeros(length(unique_ori_flash_contra), length(dFoF.flash.contra.ori(1).cells(1).peak), numCells); 
% 
% %organize by sf 
% for qq=1:length(unique_sf_flash_contra)
%     for kk=1:numCells
%         resp_sf_flash_contra(qq, 1:(length(dFoF.flash.contra.sf(qq).cells(kk).peak)), kk)= cat(1,dFoF.flash.contra.sf(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
%     end
% end
% %organize by ori 
% for qq=1:length(unique_ori_flash_contra)
%     for kk=1:numCells
%         resp_ori_flash_contra(qq, 1:(length(dFoF.flash.contra.ori(qq).cells(kk).peak)), kk)= cat(1,dFoF.flash.contra.ori(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
%     end
% end
% 
% % IPSILATERAL EYE 
% %pad matrices 
% resp_sf_flash_ipsi=zeros(length(unique_sf_flash_ipsi), length(dFoF.flash.ipsi.sf(1).cells(1).peak), numCells); 
% resp_ori_flash_ipsi=zeros(length(unique_ori_flash_ipsi), length(dFoF.flash.ipsi.ori(1).cells(1).peak), numCells); 
% 
% %organize by sf 
% for qq=1:length(unique_sf_flash_ipsi)
%     for kk=1:numCells
%         resp_sf_flash_ipsi(qq, 1:(length(dFoF.flash.ipsi.sf(qq).cells(kk).peak)), kk)= cat(1,dFoF.flash.ipsi.sf(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
%     end
% end
% %organize by ori 
% for qq=1:length(unique_ori_flash_ipsi)
%     for kk=1:numCells
%         resp_ori_flash_ipsi(qq, 1:(length(dFoF.flash.ipsi.ori(qq).cells(kk).peak)), kk)= cat(1,dFoF.flash.ipsi.ori(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
%     end
% end
% 
% %rearrange so that reps are in a column, each slice is a cell, and each
% %trial is a row 
% 
% %CONTRALATERAL EYE 
% %spatial frequency 
% resp_sf_flash_contra(resp_sf_flash_contra==0)=nan;
% resp_sf_flash_contra= permute(resp_sf_flash_contra, [2 1 3]);
% sf_trialnum_flash_contra=size(resp_sf_flash_contra); %how many times is each sf presented? 
% 
% %orientation
% resp_ori_flash_contra(resp_ori_flash_contra==0)=nan;
% resp_ori_flash_contra= permute(resp_ori_flash_contra, [2 1 3]);
% ori_trialnum_flash_contra=size(resp_ori_flash_contra); %how many times is each ori presented? 
% 
% 
% %IPSILATERAL EYE 
% %spatial frequency
% resp_sf_flash_ipsi(resp_sf_flash_ipsi==0)=nan;
% resp_sf_flash_ipsi= permute(resp_sf_flash_ipsi, [2 1 3]);
% sf_trialnum_flash_ipsi=size(resp_sf_flash_ipsi); %how many times is each sf presented?
% 
% %orientation
% resp_ori_flash_ipsi(resp_ori_flash_ipsi==0)=nan;
% resp_ori_flash_ipsi= permute(resp_ori_flash_ipsi, [2 1 3]);
% ori_trialnum_flash_ipsi=size(resp_ori_flash_ipsi); %how many times is each ori presented
% 
% visresp_cells_flash_contra=zeros(16, numCells); 
% visresp_cells_flash_ipsi=zeros(16, numCells); 
% 
% %for contralateral eye responses 
% for q=1:numCells
%     for j=1:18 
%         mean_resp_ori_flash_contra(j,q)= squeeze(mean(resp_ori_flash_contra(:,j,q))); 
%         if length(find(mean_resp_ori_flash_contra(j,q)>= threshold_active_contra_flash(q)))>=1
%             visresp_cells_flash_contra(j,q)=1; %matrix of vis resp cells, 0/1
%         end
%     end
%    
% end
% 
% %for ipsilateral eye responses 
% for q=1:numCells
%     for j=1:18    
%         mean_resp_ori_flash_ipsi(j,q)= squeeze(mean(resp_ori_flash_ipsi(:,j,q))); 
%         if length(find(mean_resp_ori_flash_ipsi(j,q)>= threshold_active_ipsi_flash(q)))>=1
%             visresp_cells_flash_ipsi(j,q)=1; %matrix of vis resp cells, 0/1
%         end
%     end
% end
% 
% %check to see in how many cells there is a threshold cross 
% visresp_cells_total_contra_flash=zeros(1,numCells); 
% visresp_cells_total_ipsi_flash =zeros(1,numCells); 
% 
% %contralateral eye 
% for q=1:numCells
%     if length(find(visresp_cells_flash_contra(:,q)==1))>=1
%         visresp_cells_total_contra_flash(q)=1; 
%     end
% end
% 
% %ipsilateral eye 
% for q=1:numCells
%     if length(find(visresp_cells_flash_ipsi(:,q)==1))>=1
%         visresp_cells_total_ipsi_flash(q)=1; 
%     end
% end
% 
% %make matrix to code for whether cell was responsive to neither eye (0),
% %contralateral (1), ipsilateral (2), or both (3) 
% 
% visresp_cells_total_flash=zeros(1,numCells);
% for q=1:numCells 
%     if (length(find(visresp_cells_total_contra_flash(q)==1))==0) && (length(find(visresp_cells_total_ipsi_flash(q)==1))==0) 
%         visresp_cells_total_flash(q)=0; %then not responsive to input from either eye 
%     elseif (length(find(visresp_cells_total_contra_flash(q)==1))==1) && (length(find(visresp_cells_total_ipsi_flash(q)==1))==0) 
%         visresp_cells_total_flash(q)=1; %only contralateral eye 
%     elseif (length(find(visresp_cells_total_contra_flash(q)==1))==0) && (length(find(visresp_cells_total_ipsi_flash(q)==1))==1) 
%         visresp_cells_total_flash(q)=2; %only ipsilateral eye 
%     elseif (length(find(visresp_cells_total_contra_flash(q)==1))==1) && (length(find(visresp_cells_total_ipsi_flash(q)==1))==1) 
%         visresp_cells_total_flash(q)=3; %both eyes 
%     end
% end

%% plot percent visually responsive to DRIFTING GRATINGS

num_visresp_flash=length(find(visresp_cells_total_flash>0));
percent_visresp_flash=num_visresp_flash/numCells; 
plotresponsivecells(num_visresp_flash,numCells,'flash');  


%% store data so far in structure
%across all conditions 
AllConds.drift.contra.ResponseCV=response_CV_contra; 
AllConds.drift.ipsi.ResponseCV=response_CV_ipsi; 
AllConds.drift.contra.peak=stimconds_drift_contra; %peak responses by unique trial x reps x cells 
AllConds.drift.contra.off=stimconds_drift_contra_off; %off trials dFoF by unique trial x reps x cells
AllConds.drift.contra.trials=stimconds_drift_contra_trials; %indices for trials by unique trial x reps x cells
AllConds.drift.ipsi.peak=stimconds_drift_ipsi; %peak responses by unique trial x reps x cells 
AllConds.drift.ipsi.off=stimconds_drift_ipsi_off; %off trials dFoF by unique trial x reps x cells
AllConds.drift.ipsi.trials=stimconds_drift_ipsi_trials; %indices for trials by unique trial x reps x cells
AllConds.drift.cellID=visresp_cells_total_drift; 

%across all conditions 
AllConds.contra.ResponseCV=response_CV_flash_contra; 
AllConds.flash.ipsi.ResponseCV=response_CV_flash_ipsi; 
AllConds.flash.contra.peak=stimconds_flash_contra; %peak responses by unique trial x reps x cells 
AllConds.flash.contra.trials=stimconds_flash_contra_trials; %indices for trials by unique trial x reps x cells
AllConds.flash.ipsi.peak=stimconds_flash_ipsi; %peak responses by unique trial x reps x cells 
AllConds.flash.ipsi.trials=stimconds_flash_ipsi_trials; %indices for trials by unique trial x reps x cells
AllConds.flash.cellID=visresp_cells_total_drift; 


%% DRIFTING gratings- organize based on monocular/ binocular neurons 

%Select ALL cells, if they were responsive to either eye
%this is for the OD score calculation

indices.drift.respcells=find(visresp_cells_total_drift>0); %indices of responsive cells  
ori_all_drift_contra= zeros(ori_trialnum_drift_contra, length(unique_ori_drift_contra), num_visresp_drift); %these should theoretically be the same size
ori_all_drift_ipsi= zeros(ori_trialnum_drift_ipsi, length(unique_ori_drift_ipsi), num_visresp_drift); 

for i=1:num_visresp_drift %for any responsive cell  
    ori_all_drift_contra(:,:,i)= resp_ori_drift_contra(:,:,indices.drift.respcells(i)); %the contralateral responses
    ori_all_drift_ipsi(:,:,i)= resp_ori_drift_ipsi(:,:,indices.drift.respcells(i)); %the ipsilateral responses 
end

%select only CONTRALATERAL responsive cells 
%indices 
indices.drift.contraresp = find(visresp_cells_total_drift==1); %indices of responsive cells 
numDrift_contra= length(find(visresp_cells_total_drift==1)); 
sf_respcells_drift_contra=zeros(sf_trialnum_drift_contra, length(unique_sf_drift_contra), numDrift_contra); %initialize matrices
ori_respcells_drift_contra=zeros(ori_trialnum_drift_contra, length(unique_ori_drift_contra), numDrift_contra); 

for i=1:numDrift_contra 
    sf_respcells_drift_contra(:,:,i)= resp_sf_drift_contra(:,:,indices.drift.contraresp(i));
    ori_respcells_drift_contra(:,:,i)= resp_ori_drift_contra(:,:,indices.drift.contraresp(i));
end

%select only IPSILATERAL responsive cells 
%indices 
indices.drift.ipsiresp = find(visresp_cells_total_drift==2); %indices of responsive cells 
numDrift_ipsi= length(find(visresp_cells_total_drift==2)); 
sf_respcells_drift_ipsi=zeros(sf_trialnum_drift_ipsi, length(unique_sf_drift_ipsi), numDrift_ipsi); %initialize matrices
ori_respcells_drift_ipsi=zeros(ori_trialnum_drift_ipsi, length(unique_ori_drift_ipsi), numDrift_ipsi); 

for i=1:numDrift_ipsi
    sf_respcells_drift_ipsi(:,:,i)= resp_sf_drift_ipsi(:,:,indices.drift.ipsiresp(i));
    ori_respcells_drift_ipsi(:,:,i)= resp_ori_drift_ipsi(:,:,indices.drift.ipsiresp(i));
end

%select  BINOCULAR cells 
%indices -- 
indices.drift.binocresp = find(visresp_cells_total_drift==3); %indices of responsive cells 
numDrift_binoc= length(find(visresp_cells_total_drift==3)); 

sf_respcells_drift_binoc_add= zeros(sf_trialnum_drift_contra, length(unique_sf_drift_contra), numDrift_binoc); %initialize matrices
ori_respcells_drift_binoc_add= zeros(ori_trialnum_drift_contra, length(unique_ori_drift_contra), numDrift_binoc); 
sf_respcells_drift_binoc_contra=zeros(sf_trialnum_drift_contra, length(unique_sf_drift_contra), numDrift_binoc); 
sf_respcells_drift_binoc_ipsi=zeros(sf_trialnum_drift_ipsi, length(unique_sf_drift_ipsi), numDrift_binoc); 
ori_respcells_drift_binoc_contra=zeros(ori_trialnum_drift_contra, length(unique_ori_drift_contra), numDrift_binoc); 
ori_respcells_drift_binoc_ipsi=zeros(ori_trialnum_drift_ipsi, length(unique_ori_drift_ipsi), numDrift_binoc);

for i=1:numDrift_binoc
    %added responses
    sf_respcells_drift_binoc_add (:,:,i)= resp_sf_drift_contra(:,:,indices.drift.binocresp(i)) + resp_sf_drift_ipsi(:,:,indices.drift.binocresp(i));
    ori_respcells_drift_binoc_add (:,:,i)= resp_ori_drift_contra(:,:,indices.drift.binocresp(i))+ resp_ori_drift_ipsi(:,:,indices.drift.binocresp(i)); 
    
    %binocular neurons' responses to either eye individually 
    sf_respcells_drift_binoc_contra(:,:,i)= resp_sf_drift_contra(:,:,indices.drift.binocresp(i));  
    sf_respcells_drift_binoc_ipsi(:,:,i)=resp_sf_drift_ipsi(:,:,indices.drift.binocresp(i));
    ori_respcells_drift_binoc_contra(:,:,i)= resp_ori_drift_contra(:,:,indices.drift.binocresp(i));
    ori_respcells_drift_binoc_ipsi(:,:,i)= resp_ori_drift_ipsi(:,:,indices.drift.binocresp(i));
end

%output= 3 matrices containing responses peak to spatial frequency and
%orientations (in sorted order) for every cell (responsive or not), if cell
%is not responsive then value of array will be 0 

%% FLASHING GRATINGS- now look at orientation and spatial frequency preferences 
%for visually responsive cells 


%Select ALL cells, if they were responsive to either eye
%this is for the OD score calculation
indices.flash.respcells=find(visresp_cells_total_drift>0); %indices of responsive cells 

ori_all_flash_contra= zeros(ori_trialnum_flash_contra(1), length(unique_ori_flash_contra), num_visresp_drift); %these should theoretically be the same size
ori_all_flash_ipsi= zeros(ori_trialnum_flash_ipsi(1), length(unique_ori_flash_ipsi), num_visresp_drift); 
sf_all_flash_contra= zeros(sf_trialnum_flash_contra(1), length(unique_sf_flash_contra), num_visresp_drift); %these should theoretically be the same size
sf_all_flash_ipsi= zeros(sf_trialnum_flash_ipsi(1), length(unique_sf_flash_ipsi), num_visresp_drift); 

for i=1:num_visresp_drift %for any responsive cell  
    ori_all_flash_contra(:,:,i)= resp_ori_flash_contra(:,:,indices.flash.respcells(i)); %the contralateral responses
    ori_all_flash_ipsi(:,:,i)= resp_ori_flash_ipsi(:,:,indices.flash.respcells(i)); %the ipsilateral responses 
    sf_all_flash_contra(:,:,i)= resp_sf_flash_contra(:,:,indices.flash.respcells(i)); %the contralateral responses
    sf_all_flash_ipsi(:,:,i)= resp_sf_flash_ipsi(:,:,indices.flash.respcells(i)); %the ipsilateral responses 
end

%select only CONTRALATERAL responsive cells 
%indices 
indices.flash.contraresp = find(visresp_cells_total_drift==1); %indices of responsive cells 
numFlash_contra= length(find(visresp_cells_total_drift==1)); 
sf_respcells_flash_contra=zeros(sf_trialnum_flash_contra(1), length(unique_sf_flash_contra), numFlash_contra); %initialize matrices
ori_respcells_flash_contra=zeros(ori_trialnum_flash_contra(1), length(unique_ori_flash_contra), numFlash_contra); 

for i=1:numFlash_contra 
    sf_respcells_flash_contra(:,:,i)= resp_sf_flash_contra(:,:,indices.flash.contraresp(i));
    ori_respcells_flash_contra(:,:,i)= resp_ori_flash_contra(:,:,indices.flash.contraresp(i));
end

%select only IPSILATERAL responsive cells 
%indices 
indices.flash.ipsiresp = find(visresp_cells_total_drift==2); %indices of responsive cells 
numFlash_ipsi= length(find(visresp_cells_total_drift==2)); 
sf_respcells_flash_ipsi=zeros(sf_trialnum_flash_ipsi(1), length(unique_sf_flash_ipsi), numFlash_ipsi); %initialize matrices
ori_respcells_flash_ipsi=zeros(ori_trialnum_flash_ipsi(1), length(unique_ori_flash_ipsi), numFlash_ipsi); 

for i=1:numFlash_ipsi
    sf_respcells_flash_ipsi(:,:,i)= resp_sf_flash_ipsi(:,:,indices.flash.ipsiresp(i));
    ori_respcells_flash_ipsi(:,:,i)= resp_ori_flash_ipsi(:,:,indices.flash.ipsiresp(i));
end

%select  BINOCULAR cells 
%indices -- 
indices.flash.binocresp = find(visresp_cells_total_drift==3); %indices of responsive cells 
numFlash_binoc= length(find(visresp_cells_total_drift==3)); 

sf_respcells_flash_binoc_add= zeros(sf_trialnum_flash_contra(1), length(unique_sf_flash_contra), numFlash_binoc); %initialize matrices
ori_respcells_flash_binoc_add= zeros(ori_trialnum_flash_contra(1), length(unique_ori_flash_contra), numFlash_binoc); 
sf_respcells_flash_binoc_contra=zeros(sf_trialnum_flash_contra(1), length(unique_sf_flash_contra), numFlash_binoc); 
sf_respcells_flash_binoc_ipsi=zeros(sf_trialnum_flash_ipsi(1), length(unique_sf_flash_ipsi), numFlash_binoc); 
ori_respcells_flash_binoc_contra=zeros(ori_trialnum_flash_contra(1), length(unique_ori_flash_contra), numFlash_binoc); 
ori_respcells_flash_binoc_ipsi=zeros(ori_trialnum_flash_ipsi(1), length(unique_ori_flash_ipsi), numFlash_binoc);

for i=1:numFlash_binoc
    %added responses
  %  sf_respcells_flash_binoc_add (:,:,i)= resp_sf_flash_contra(:,:,indices.flash.binocresp(i)) + resp_sf_flash_ipsi(:,:,indices.flash.binocresp(i));
  %  ori_respcells_flash_binoc_add (:,:,i)= resp_ori_flash_contra(:,:,indices.flash.binocresp(i))+ resp_ori_flash_ipsi(:,:,indices.flash.binocresp(i)); 
    
    %binocular neurons' responses to either eye individually 
    sf_respcells_flash_binoc_contra(:,:,i)= resp_sf_flash_contra(:,:,indices.flash.binocresp(i));  
    sf_respcells_flash_binoc_ipsi(:,:,i)=resp_sf_flash_ipsi(:,:,indices.flash.binocresp(i));
    ori_respcells_flash_binoc_contra(:,:,i)= resp_ori_flash_contra(:,:,indices.flash.binocresp(i));
    ori_respcells_flash_binoc_ipsi(:,:,i)= resp_ori_flash_ipsi(:,:,indices.flash.binocresp(i));
end

%output= 3 matrices containing responses peak to spatial frequency and
%orientations (in sorted order) for every cell (responsive or not), if cell
%is not responsive then value of array will be 0 

%nan in place of 0 
ori_all_flash_contra(ori_all_flash_contra==0)=nan; 
ori_all_flash_ipsi(ori_all_flash_ipsi==0)=nan; 
sf_all_flash_contra(sf_all_flash_contra==0)=nan; 
sf_all_flash_ipsi(sf_all_flash_ipsi==0)=nan; 

sf_respcells_flash_contra(sf_respcells_flash_contra==0)=nan;
sf_respcells_flash_ipsi(ori_respcells_flash_ipsi==0)=nan;
ori_respcells_flash_contra(sf_respcells_flash_contra==0)=nan;
ori_respcells_flash_ipsi(ori_respcells_flash_ipsi==0)=nan;

sf_respcells_flash_binoc_contra(sf_respcells_flash_binoc_contra==0)=nan;
sf_respcells_flash_binoc_ipsi(sf_respcells_flash_binoc_ipsi==0)=nan;
ori_respcells_flash_binoc_contra(ori_respcells_flash_binoc_contra==0)=nan;
ori_respcells_flash_binoc_ipsi(ori_respcells_flash_binoc_ipsi==0)=nan;

%%  OD score -DRIFTING GRATINGS
%citation: Cell-specific restoration of stimulus preference after monocular
%deprivation in the visual cortex. Rose et al., (2016), Science
%DOI:10.1126/science.aad3358

%----ANY RESPONSIVE NEURONS----FOR OD calculation 
%average by direction  

for i=1:num_visresp_drift
    for j=1:length(unique_ori_drift_contra)
        avg_ori_all_drift_contra(j,i)= mean (ori_all_drift_contra(:,j,i));%all the contra responses
        
    end
    for k=1:length(unique_ori_drift_ipsi) %all the ipsilateral responses 
        avg_ori_all_drift_ipsi(k,i)= mean (ori_all_drift_ipsi(:,k,i));
    end
end

%find peak mean responses
for i=1:num_visresp_drift
    peak_ori_all_drift_contra(i)=max(avg_ori_all_drift_contra(:,i));
    peak_ori_all_drift_ipsi(i)=max(avg_ori_all_drift_ipsi(:,i));
end

%store data in a structure for all responsive cells, not sorted by
%monocular/binocular cells 

for i=1:num_visresp_drift
    AllCellsDrift(i).ID= indices.drift.respcells(i); 
    AllCellsDrift(i).alloris.contra=avg_ori_all_drift_contra(:,i); 
    AllCellsDrift(i).alloris.ipsi=avg_ori_all_drift_ipsi(:,i);
    AllCellsDrift(i).oripeak.contra= peak_ori_all_drift_contra(i);
    AllCellsDrift(i).oripeak.ipsi=peak_ori_all_drift_ipsi(i); 
    
     for j=1:length(unique_ori_drift_contra)
        AllCellsDrift(i).ori(j).cond.contra=unique_ori_drift_contra(j); %what was the unique ori trial 
        AllCellsDrift(i).ori(j).peak.contra=mean(ori_all_drift_contra(:,j,i));%peak responses for each condition 
        AllCellsDrift(i).ori(j).trace.contra= dFoF.drift.contra.ori(j).cells(indices.drift.respcells(i)).traces; 
        AllCellsDrift(i).ori(j).avgtrace.contra= dFoF.drift.contra.ori(j).cells(indices.drift.respcells(i)).avgtrace;
    end
    for k=1:length(unique_ori_drift_ipsi)
        AllCellsDrift(i).ori(k).cond.ipsi=unique_ori_drift_ipsi(k); %what was the unique ori trial 
        AllCellsDrift(i).ori(k).peak.ipsi=mean(ori_all_drift_ipsi(:,k,i));%peak responses for each condition 
        AllCellsDrift(i).ori(k).trace.ipsi= dFoF.drift.ipsi.ori(k).cells(indices.drift.respcells(i)).traces; 
        AllCellsDrift(i).ori(k).avgtrace.ipsi= dFoF.drift.ipsi.ori(k).cells(indices.drift.respcells(i)).avgtrace;
    end
end

%get OD score for each cell
ODscore_drift=getODscore(AllCellsDrift);
for i=1:num_visresp_drift
    AllCellsDrift(i).odscore=ODscore_drift(i);
end

%plot OD score
plotODscore(ODscore_drift, SaveDir); 

%% direction tuning for monocular and binocular neurons 
%direction orientation preference for contralateral, ipsilateral eye 
%use Tan et al., 2021 Current Biology for orientation and spatial frequency
%preference calcultion 

%----FOR ALL NEURONS REGARDLESS OF MONOCULAR/BINOCULAR 

%orientation tuning and circular variance for ocontralateral responses
[ori_all_contra_est, cv_all_contra]= getdirtuning(unique_ori_drift_contra, avg_ori_all_drift_contra); 
%orientation tuning and circular variance for ipsilateral responses
[ori_all_ipsi_est, cv_all_ipsi]= getdirtuning(unique_ori_drift_ipsi, avg_ori_all_drift_ipsi); 

%put in structure
for i=1:num_visresp_drift
    AllCellsDrift(i).pref_ori.contra=ori_all_contra_est(i);
    AllCellsDrift(i).pref_ori.ipsi=ori_all_ipsi_est(i);
    AllCellsDrift(i).cv_ori.contra=cv_all_contra(i);
    AllCellsDrift(i).cv_ori.ipsi=cv_all_ipsi(i);
end

%-----CONTRALATERAL MONOCULAR NEURONS-----for cells that are CONTRALATERAL responsive, find preferred orientation

%average by SF and orientation 
for i=1:numDrift_contra
    for j=1:length(unique_sf_drift_contra)
        avg_sf_drift_contra(j,i)=mean(sf_respcells_drift_contra(:,j,i)); 
    end
    for k=1:length (unique_ori_drift_contra)
        avg_ori_drift_contra(k,i)=mean(ori_respcells_drift_contra(:,k,i));
    end
end

%orientation tuning and circular variance 
[ori_contra_est, cv_contra]= getdirtuning(unique_ori_drift_contra, avg_ori_drift_contra); 

%spatial frequency tuning

%---------IPSILATERAL MONOCULAR NEURONS------for cells that are ipsilateral responsive, find  preferred orientation

for i=1:numDrift_ipsi
    for j=1:length(unique_sf_drift_ipsi)
        avg_sf_drift_ipsi(j,i)=mean(sf_respcells_drift_ipsi(:,j,i)); %get trial averaged responses 
    end
    for k=1:length (unique_ori_drift_ipsi)
        avg_ori_drift_ipsi(k,i)=mean(ori_respcells_drift_ipsi(:,k,i)); %get trial averaged responses 
    end
end

%orientation tuning 
[ori_ipsi_est, cv_ipsi]= getdirtuning(unique_ori_drift_ipsi, avg_ori_drift_ipsi); 

%------BINOCULAR NEURONS-----for cells that are binocular, find preferred orientation and spatial
%frequency for either eye separately 

for i=1:numDrift_binoc
    for j=1:length(unique_sf_drift_ipsi)
        avg_sf_drift_binoc_contra(j,i)=mean(sf_respcells_drift_binoc_contra(:,j,i)); 
        avg_sf_drift_binoc_ipsi(j,i)=mean(sf_respcells_drift_binoc_ipsi(:,j,i)); 
    end
    for k=1:length (unique_ori_drift_ipsi)
        avg_ori_drift_binoc_contra(k,i)=mean(ori_respcells_drift_binoc_contra(:,k,i));
        avg_ori_drift_binoc_ipsi(k,i)=mean(ori_respcells_drift_binoc_ipsi(:,k,i));
    end
end

%contralateral eye responses
[ori_binoc_contra_est, cv_binoc_contra]= getdirtuning(unique_ori_drift_contra, avg_ori_drift_binoc_contra); 

%ipsilateral eye responses 
[ori_binoc_ipsi_est, cv_binoc_ipsi]= getdirtuning(unique_ori_drift_ipsi, avg_ori_drift_binoc_ipsi); 


ori_drift_pref=struct('contra_all', ori_all_contra_est, 'ipsi_all', ori_all_ipsi_est, 'contra', ori_contra_est, 'ipsi', ori_ipsi_est,...
    'binoc_contra',ori_binoc_contra_est, 'binoc_ipsi', ori_binoc_ipsi_est,...
    'cv_contra_all', cv_all_contra, 'cv_ipsi_all', cv_all_ipsi,...
    'cv_contra', cv_contra, 'cv_ipsi', cv_ipsi, 'cv_binoc_contra', cv_binoc_contra,...
    'cv_binoc_ipsi', cv_binoc_ipsi); 
ori_drift_responses= struct('contra_all', avg_ori_all_drift_contra,...
    'ipsi_all', avg_ori_all_drift_ipsi, 'contra', avg_ori_drift_contra, 'ipsi', avg_ori_drift_ipsi,...
    'binoc_contra',avg_ori_drift_binoc_contra, 'binoc_ipsi', avg_ori_drift_binoc_ipsi); 

%% store data so far in a structure 
%store orientation and sf matrices 

%only the cells that had significant visual responses above threshold 
%num_visresp
for i=1:numDrift_contra  %for CONTRALATERAL responsive neurons
    ContraCellDrift(i).ID=indices.drift.contraresp(i); %ID of monocular contralateral cell 
    ContraCellDrift(i).pref_ori= ori_contra_est(i); 
    ContraCellDrift(i).cv_ori= cv_contra(i); 
    for j=1:length(unique_sf_drift_contra)
        ContraCellDrift(i).sf(j).cond=unique_sf_drift_contra(j); %what was the unique SF trial 
        ContraCellDrift(i).sf(j).peak=mean(sf_respcells_drift_contra(:,j,i));%peak responses for each condition 
        ContraCellDrift(i).sf(j).trace= dFoF.drift.contra.sf(j).cells(indices.drift.contraresp(i)).traces; 
        ContraCellDrift(i).sf(j).avgtrace= dFoF.drift.contra.sf(j).cells(indices.drift.contraresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_drift_contra)
        ContraCellDrift(i).ori(k).cond=unique_ori_drift_contra(k); %what was the unique ori trial 
        ContraCellDrift(i).ori(k).peak=mean(ori_respcells_drift_contra(:,k,i));%peak responses for each condition 
        ContraCellDrift(i).ori(k).trace= dFoF.drift.contra.ori(k).cells(indices.drift.contraresp(i)).traces; 
        ContraCellDrift(i).ori(k).avgtrace= dFoF.drift.contra.ori(k).cells(indices.drift.contraresp(i)).avgtrace;
    end
end

for i=1:numDrift_ipsi  %for IPSILATERAL neurons
    IpsiCellDrift(i).ID=indices.drift.ipsiresp(i); %ID of monocular contralateral cell 
    IpsiCellDrift(i).pref_ori= ori_ipsi_est(i); 
    IpsiCellDrift(i).cv_ori= cv_ipsi(i); 
    for j=1:length(unique_sf_drift_ipsi)
        IpsiCellDrift(i).sf(j).cond=unique_sf_drift_ipsi(j); %what was the unique SF trial 
        IpsiCellDrift(i).sf(j).peak=mean(sf_respcells_drift_ipsi(j,:,i));%peak responses for each condition 
        IpsiCellDrift(i).sf(j).trace= dFoF.drift.ipsi.sf(j).cells(indices.drift.ipsiresp(i)).traces ;
        IpsiCellDrift(i).sf(j).avgtrace= dFoF.drift.ipsi.sf(j).cells(indices.drift.ipsiresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_drift_ipsi)
        IpsiCellDrift(i).ori(k).cond=unique_ori_drift_ipsi(k); %what was the unique ori trial 
        IpsiCellDrift(i).ori(k).peak=mean(ori_respcells_drift_ipsi(:,k,i));%peak responses for each condition 
        IpsiCellDrift(i).ori(k).trace= dFoF.drift.ipsi.ori(k).cells(indices.drift.ipsiresp(i)).traces ;
        IpsiCellDrift(i).ori(k).avgtrace= dFoF.drift.ipsi.ori(k).cells(indices.drift.ipsiresp(i)).avgtrace;
    end
end

for i=1:numDrift_binoc  %for BINOCULAR neurons
    BinocCellDrift(i).ID=indices.drift.binocresp(i); %ID of monocular contralateral cell 
    BinocCellDrift(i).pref_ori.contra= ori_binoc_contra_est(i); 
    BinocCellDrift(i).pref_ori.ipsi= ori_binoc_ipsi_est(i); 
    BinocCellDrift(i).cv_ori.contra= cv_binoc_contra(i); 
    BinocCellDrift(i).cv_ori.ipsi= cv_binoc_ipsi(i); 
    for j=1:length(unique_sf_drift_contra) %contralateral eye responses
            BinocCellDrift(i).sf(j).cond.contra=unique_sf_drift_contra(j);
            BinocCellDrift(i).sf(j).peak.contra= mean(sf_respcells_drift_binoc_contra(:,j,i)); %peak responses for each condition 
            BinocCellDrift(i).sf(j).trace.contra= dFoF.drift.contra.sf(j).cells(indices.drift.binocresp(i)).traces;
            BinocCellDrift(i).sf(j).avgtrace.contra= dFoF.drift.contra.sf(j).cells(indices.drift.binocresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_drift_contra)
            BinocCellDrift(i).ori(k).cond.contra=unique_ori_drift_contra(k);
            BinocCellDrift(i).ori(k).peak.contra= mean(ori_respcells_drift_binoc_contra(:,k,i)); %peak responses for each condition 
            BinocCellDrift(i).ori(k).trace.contra= dFoF.drift.contra.ori(k).cells(indices.drift.binocresp(i)).traces;
            BinocCellDrift(i).ori(k).avgtrace.contra= dFoF.drift.contra.ori(k).cells(indices.drift.binocresp(i)).avgtrace;
    end

    for j=1:length(unique_sf_drift_ipsi) %ipsilateral eye responses
            BinocCellDrift(i).sf(j).cond.ipsi=unique_sf_drift_ipsi(j);
            BinocCellDrift(i).sf(j).peak.ipsi= mean(sf_respcells_drift_binoc_ipsi(j,:,i)); %peak responses for each condition 
            BinocCellDrift(i).sf(j).trace.ipsi= dFoF.drift.ipsi.sf(j).cells(indices.drift.binocresp(i)).traces;
            BinocCellDrift(i).sf(j).avgtrace.ipsi= dFoF.drift.ipsi.sf(j).cells(indices.drift.binocresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_drift_ipsi)
            BinocCellDrift(i).ori(k).cond.ipsi=unique_ori_drift_ipsi(k);
            BinocCellDrift(i).ori(k).peak.ipsi= mean(ori_respcells_drift_binoc_ipsi(:,k,i)); %peak responses for each condition 
            BinocCellDrift(i).ori(k).trace.ipsi= dFoF.drift.ipsi.ori(k).cells(indices.drift.binocresp(i)).traces;
            BinocCellDrift(i).ori(k).avgtrace.ipsi= dFoF.drift.ipsi.ori(k).cells(indices.drift.binocresp(i)).avgtrace;
    end
end

% save this structure  
SigCellsDrift=struct('ContraCell', ContraCellDrift, 'IpsiCell', IpsiCellDrift, 'BinocCell', BinocCellDrift, 'AllCells', AllCellsDrift); 
fsave=fullfile(SaveDir, strcat(anim, '_SigCellsDrift.mat')); 
save(fsave,'SigCellsDrift'); 

%% plot preferred orientation 

%a polar plot per cell with DSI 
%direction tuning 

%plot_dir_polar(SigCellsDrift); 

%%  OD score - FLASHING GRATINGS 
%citation: Cell-specific restoration of stimulus preference after monocular
%deprivation in the visual cortex. Rose et al., (2016), Science
%DOI:10.1126/science.aad3358

%----ANY RESPONSIVE NEURONS----FOR OD calculation 
%average by orientation 
for i=1:num_visresp_drift
    for j=1:length(unique_ori_flash_contra)
        avg_ori_all_flash_contra(j,i)= mean (ori_all_flash_contra(:,j,i), 'omitnan');%all the contra responses
        
    end
    for k=1:length(unique_ori_flash_ipsi) %all the ipsilateral responses 
        avg_ori_all_flash_ipsi(k,i)= mean (ori_all_flash_ipsi(:,k,i), 'omitnan');
    end
end

%find peak mean responses
for i=1:num_visresp_drift
    peak_ori_all_flash_contra(i)=max(avg_ori_all_flash_contra(:,i));
    peak_ori_all_flash_ipsi(i)=max(avg_ori_all_flash_ipsi(:,i));
end

%store data in a structure 
for i=1:num_visresp_drift
    AllCellsFlash(i).ID= indices.flash.respcells(i); 
    %for OD calculation 
    AllCellsFlash(i).alloris.contra=avg_ori_all_flash_contra(:,i); 
    AllCellsFlash(i).alloris.ipsi=avg_ori_all_flash_ipsi(:,i);
    AllCellsFlash(i).oripeak.contra= peak_ori_all_flash_contra(i);
    AllCellsFlash(i).oripeak.ipsi=peak_ori_all_flash_ipsi(i); 
    
     for j=1:length(unique_ori_flash_contra)
        AllCellsFlash(i).ori(j).cond.contra=unique_ori_flash_contra(j); %what was the unique ori trial 
        AllCellsFlash(i).ori(j).peak.contra=mean(ori_all_flash_contra(:,j,i), 'omitnan');%peak responses for each condition 
        AllCellsFlash(i).ori(j).trace.contra= dFoF.flash.contra.ori(j).cells(indices.flash.respcells(i)).traces; 
        AllCellsFlash(i).ori(j).avgtrace.contra= dFoF.flash.contra.ori(j).cells(indices.flash.respcells(i)).avgtrace;
    end
    for k=1:length(unique_ori_flash_ipsi)
        AllCellsFlash(i).ori(k).cond.ipsi=unique_ori_flash_ipsi(k); %what was the unique ori trial 
        AllCellsFlash(i).ori(k).peak.ipsi=mean(ori_all_flash_ipsi(:,k,i), 'omitnan');%peak responses for each condition 
        AllCellsFlash(i).ori(k).trace.ipsi= dFoF.flash.ipsi.ori(k).cells(indices.flash.respcells(i)).traces; 
        AllCellsFlash(i).ori(k).avgtrace.ipsi= dFoF.flash.ipsi.ori(k).cells(indices.flash.respcells(i)).avgtrace;
    end
end

%get OD score for each cell
ODscore_flash=getODscore(AllCellsFlash);
for i=1:num_visresp_drift
    AllCellsFlash(i).odscore.flash=ODscore_flash(i);
end

%plot OD score
plotODscore(ODscore_flash, SaveDir1); 

%% orientation tuning and spatial frequency tuning for monocular and binocular neurons --FLASHING GRATINGS
%orientation orientation preference for contralateral, ipsilateral eye 
%use Tan et al., 2021 Current Biology for orientation and spatial frequency
%preference calcultion 

%----FOR ALL NEURONS REGARDLESS OF MONOCULAR/BINOCULAR 

%average by sf 
for i=1:num_visresp_drift
    for j=1:length(unique_sf_flash_contra)
        avg_sf_all_flash_contra(j,i)= mean (sf_all_flash_contra(:,j,i), 'omitnan');%all the contra responses
        
    end
    for k=1:length(unique_sf_flash_ipsi) %all the ipsilateral responses 
        avg_sf_all_flash_ipsi(k,i)= mean (sf_all_flash_ipsi(:,k,i), 'omitnan');
    end
end

%orientation tuning and circular variance for ocontralateral responses
[ori_all_contra_est_flash, cv_all_contra_flash]= getorituning(unique_ori_flash_contra, avg_ori_all_flash_contra); 
%orientation tuning and circular variance for ipsilateral responses
[ori_all_ipsi_est_flash, cv_all_ipsi_flash]= getorituning(unique_ori_flash_ipsi, avg_ori_all_flash_ipsi); 

%spatial frequency tuning 
[sf_all_contra_est_flash]=getsftuning(unique_sf_flash_contra, avg_sf_all_flash_contra); 
[sf_all_ipsi_est_flash]=getsftuning(unique_sf_flash_ipsi, avg_sf_all_flash_ipsi); 

%put in structure
for i=1:num_visresp_drift
    AllCellsFlash(i).pref_ori.contra=ori_all_contra_est_flash(i);
    AllCellsFlash(i).pref_ori.ipsi=ori_all_ipsi_est_flash(i);
    AllCellsFlash(i).cv_ori.contra=cv_all_contra_flash(i);
    AllCellsFlash(i).cv_ori.ipsi=cv_all_ipsi_flash(i);
    AllCellsFlash(i).pref_sf.contra=sf_all_contra_est_flash(i);
    AllCellsFlash(i).pref_sf.ipsi=sf_all_ipsi_est_flash(i);
end

%-----CONTRALATERAL MONOCULAR NEURONS-----for cells that are CONTRALATERAL responsive, find preferred orientation

%average by SF and orientation 
for i=1:numFlash_contra
    for j=1:length(unique_sf_flash_contra)
        avg_sf_flash_contra(j,i)=mean(sf_respcells_flash_contra(:,j,i), 'omitnan'); 
    end
    for k=1:length (unique_ori_flash_contra)
        avg_ori_flash_contra(k,i)=mean(ori_respcells_flash_contra(:,k,i), 'omitnan');
    end
end

%orientation tuning and circular variance 
[ori_contra_est_flash, cv_contra_flash]= getorituning(unique_ori_flash_contra, avg_ori_flash_contra); 

%spatial frequency tuning 
[sf_contra_est_flash]=getsftuning(unique_sf_flash_contra, avg_sf_flash_contra); 

%---------IPSILATERAL MONOCULAR NEURONS------for cells that are ipsilateral responsive, find  preferred orientation

for i=1:numFlash_ipsi
    for j=1:length(unique_sf_flash_ipsi)
        avg_sf_flash_ipsi(j,i)=mean(sf_respcells_flash_ipsi(:,j,i), 'omitnan'); %get trial averaged responses 
    end
    for k=1:length (unique_ori_flash_ipsi)
        avg_ori_flash_ipsi(k,i)=mean(ori_respcells_flash_ipsi(:,k,i), 'omitnan'); %get trial averaged responses 
    end
end

%orientation tuning 
[ori_ipsi_est_flash, cv_ipsi_flash]= getorituning(unique_ori_flash_ipsi, avg_ori_flash_ipsi); 

%spatial frequency tuning 
[sf_ipsi_est_flash]=getsftuning(unique_sf_flash_ipsi, avg_sf_flash_ipsi); 

%------BINOCULAR NEURONS-----for cells that are binocular, find preferred orientation and spatial
%frequency for either eye separately 

for i=1:numFlash_binoc
    for j=1:length(unique_sf_flash_ipsi)
        avg_sf_flash_binoc_contra(j,i)=mean(sf_respcells_flash_binoc_contra(:,j,i), 'omitnan'); 
        avg_sf_flash_binoc_ipsi(j,i)=mean(sf_respcells_flash_binoc_ipsi(:,j,i), 'omitnan'); 
    end
    for k=1:length (unique_ori_flash_ipsi)
        avg_ori_flash_binoc_contra(k,i)=mean(ori_respcells_flash_binoc_contra(:,k,i),'omitnan');
        avg_ori_flash_binoc_ipsi(k,i)=mean(ori_respcells_flash_binoc_ipsi(:,k,i), 'omitnan');
    end
end

%contralateral eye responses
[ori_binoc_contra_est_flash, cv_binoc_contra_flash]= getorituning(unique_ori_flash_contra, avg_ori_flash_binoc_contra); 

%ipsilateral eye responses 
[ori_binoc_ipsi_est_flash, cv_binoc_ipsi_flash]= getorituning(unique_ori_flash_ipsi, avg_ori_flash_binoc_ipsi); 

%spatial frequency tuning 
[sf_binoc_contra_est_flash]=getsftuning(unique_sf_flash_contra, avg_sf_flash_binoc_contra); 
[sf_binoc_ipsi_est_flash]=getsftuning(unique_sf_flash_ipsi, avg_sf_flash_binoc_ipsi); 

ori_flash_pref=struct('contra_all', ori_all_contra_est_flash, 'ipsi_all', ori_all_ipsi_est_flash,...
    'contra', ori_contra_est_flash, 'ipsi', ori_ipsi_est_flash,...
    'binoc_contra',ori_binoc_contra_est_flash, 'binoc_ipsi', ori_binoc_ipsi_est_flash,...
    'cv_contra_all', cv_all_contra_flash, 'cv_ipsi_all', cv_all_ipsi_flash,...
    'cv_contra', cv_contra_flash, 'cv_ipsi', cv_ipsi_flash, 'cv_binoc_contra', cv_binoc_contra_flash,...
    'cv_binoc_ipsi', cv_binoc_ipsi_flash); 
ori_flash_responses= struct('contra_all', avg_ori_all_flash_contra, 'ipsi_all', avg_ori_all_flash_ipsi,...
    'contra', avg_ori_flash_contra, 'ipsi', avg_ori_flash_ipsi,...
    'binoc_contra',avg_ori_flash_binoc_contra, 'binoc_ipsi', avg_ori_flash_binoc_ipsi); 

%% store data so far in a structure 
%store orientation and sf matrices 

%only the cells that had significant visual responses above threshold 
%num_visresp
%only the cells that had significant visual responses above threshold 
%num_visresp
for i=1:numFlash_contra  %for CONTRALATERAL responsive neurons
    ContraCellFlash(i).ID=indices.flash.contraresp(i); %ID of monocular contralateral cell 
    ContraCellFlash(i).pref_ori= ori_contra_est_flash(i); 
    ContraCellFlash(i).cv_ori= cv_contra_flash(i); 
    ContraCellFlash(i).pref_sf= sf_contra_est_flash(i);
    for j=1:length(unique_sf_flash_contra)
        ContraCellFlash(i).sf(j).cond=unique_sf_flash_contra(j); %what was the unique SF trial 
        ContraCellFlash(i).sf(j).peak=mean(sf_respcells_flash_contra(:,j,i), 'omitnan');%peak responses for each condition 
        ContraCellFlash(i).sf(j).trace= dFoF.flash.contra.sf(j).cells(indices.flash.contraresp(i)).traces; 
        ContraCellFlash(i).sf(j).avgtrace= dFoF.flash.contra.sf(j).cells(indices.flash.contraresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_flash_contra)
        ContraCellFlash(i).ori(k).cond=unique_ori_flash_contra(k); %what was the unique ori trial 
        ContraCellFlash(i).ori(k).peak=mean(ori_respcells_flash_contra(:,k,i), 'omitnan');%peak responses for each condition 
        ContraCellFlash(i).ori(k).trace= dFoF.flash.contra.ori(k).cells(indices.flash.contraresp(i)).traces; 
        ContraCellFlash(i).ori(k).avgtrace= dFoF.flash.contra.ori(k).cells(indices.flash.contraresp(i)).avgtrace;
    end
end

for i=1:numFlash_ipsi  %for IPSILATERAL neurons
    IpsiCellFlash(i).ID=indices.flash.ipsiresp(i); %ID of monocular contralateral cell 
    IpsiCellFlash(i).pref_ori= ori_ipsi_est_flash(i); 
    IpsiCellFlash(i).cv_ori= cv_ipsi_flash(i); 
    IpsiCellFlash(i).pref_sf= sf_ipsi_est_flash(i); 
    for j=1:length(unique_sf_flash_ipsi)
        IpsiCellFlash(i).sf(j).cond=unique_sf_flash_ipsi(j); %what was the unique SF trial 
        IpsiCellFlash(i).sf(j).peak=mean(sf_respcells_flash_ipsi(j,:,i), 'omitnan');%peak responses for each condition 
        IpsiCellFlash(i).sf(j).trace= dFoF.flash.ipsi.sf(j).cells(indices.flash.ipsiresp(i)).traces ;
        IpsiCellFlash(i).sf(j).avgtrace= dFoF.flash.ipsi.sf(j).cells(indices.flash.ipsiresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_flash_ipsi)
        IpsiCellFlash(i).ori(k).cond=unique_ori_flash_ipsi(k); %what was the unique ori trial 
        IpsiCellFlash(i).ori(k).peak=mean(ori_respcells_flash_ipsi(:,k,i),'omitnan');%peak responses for each condition 
        IpsiCellFlash(i).ori(k).trace= dFoF.flash.ipsi.ori(k).cells(indices.flash.ipsiresp(i)).traces ;
        IpsiCellFlash(i).ori(k).avgtrace= dFoF.flash.ipsi.ori(k).cells(indices.flash.ipsiresp(i)).avgtrace;
    end
end

for i=1:numFlash_binoc  %for BINOCULAR neurons
    BinocCellFlash(i).ID=indices.flash.binocresp(i); %ID of monocular contralateral cell 
    BinocCellFlash(i).pref_ori.contra= ori_binoc_contra_est_flash(i); 
    BinocCellFlash(i).pref_ori.ipsi= ori_binoc_ipsi_est_flash(i); 
    BinocCellFlash(i).cv_ori.contra= cv_binoc_contra_flash(i); 
    BinocCellFlash(i).cv_ori.ipsi= cv_binoc_ipsi_flash(i); 
    BinocCellFlash(i).pref_sf.contra= sf_binoc_contra_est_flash(i); 
    BinocCellFlash(i).pref_sf.ipsi= sf_binoc_ipsi_est_flash(i); 
    for j=1:length(unique_sf_flash_contra) %contralateral eye responses
            BinocCellFlash(i).sf(j).cond.contra=unique_sf_flash_contra(j);
            BinocCellFlash(i).sf(j).peak.contra= mean(sf_respcells_flash_binoc_contra(:,j,i), 'omitnan'); %peak responses for each condition 
            BinocCellFlash(i).sf(j).trace.contra= dFoF.flash.contra.sf(j).cells(indices.flash.binocresp(i)).traces;
            BinocCellFlash(i).sf(j).avgtrace.contra= dFoF.flash.contra.sf(j).cells(indices.flash.binocresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_flash_contra)
            BinocCellFlash(i).ori(k).cond.contra=unique_ori_flash_contra(k);
            BinocCellFlash(i).ori(k).peak.contra= mean(ori_respcells_flash_binoc_contra(:,k,i), 'omitnan'); %peak responses for each condition 
            BinocCellFlash(i).ori(k).trace.contra= dFoF.flash.contra.ori(k).cells(indices.flash.binocresp(i)).traces;
            BinocCellFlash(i).ori(k).avgtrace.contra= dFoF.flash.contra.ori(k).cells(indices.flash.binocresp(i)).avgtrace;
    end

    for j=1:length(unique_sf_flash_ipsi) %ipsilateral eye responses
            BinocCellFlash(i).sf(j).cond.ipsi=unique_sf_flash_ipsi(j);
            BinocCellFlash(i).sf(j).peak.ipsi= mean(sf_respcells_flash_binoc_ipsi(j,:,i),'omitnan'); %peak responses for each condition 
            BinocCellFlash(i).sf(j).trace.ipsi= dFoF.flash.ipsi.sf(j).cells(indices.flash.binocresp(i)).traces;
            BinocCellFlash(i).sf(j).avgtrace.ipsi= dFoF.flash.ipsi.sf(j).cells(indices.flash.binocresp(i)).avgtrace;
    end
    for k=1:length(unique_ori_flash_ipsi)
            BinocCellFlash(i).ori(k).cond.ipsi=unique_ori_flash_ipsi(k);
            BinocCellFlash(i).ori(k).peak.ipsi= mean(ori_respcells_flash_binoc_ipsi(:,k,i),'omitnan'); %peak responses for each condition 
            BinocCellFlash(i).ori(k).trace.ipsi= dFoF.flash.ipsi.ori(k).cells(indices.flash.binocresp(i)).traces;
            BinocCellFlash(i).ori(k).avgtrace.ipsi= dFoF.flash.ipsi.ori(k).cells(indices.flash.binocresp(i)).avgtrace;
    end
end

% save this structure 
SigCellsFlash=struct('ContraCell', ContraCellFlash, 'IpsiCell', IpsiCellFlash, 'BinocCell', BinocCellFlash, 'AllCells', AllCellsFlash); 

%% plot preferred orientation 
%a polar plot per cell with OSI 
%direction tuning 

%plot_ori_polar(SigCellsFlash); 

%% plot OSI, DSI, and spatial frequency preference 
plotsftuning(SigCellsFlash); 
plotOSI(SigCellsFlash); 
plotDSI(SigCellsDrift); 

plotdFoF_traces(SigCellsDrift,'drift'); 

%% save structures 
fsave1=fullfile(SaveDir1, strcat(anim, '_SigCellsFlash.mat')); 
save(fsave1, 'SigCellsFlash');
save(fullfile(SaveDir, strcat(anim, '_indices.mat')), 'indices'); %save indices structure
save(fullfile(SaveDir, strcat(anim, '_dFoF.mat')), 'dFoF'); %save dFoF structure

clear anim
clear SaveDir
clear SaveDir1

end


