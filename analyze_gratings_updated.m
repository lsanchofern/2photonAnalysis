function analyze_gratings_updated(anim,day,fov,exp1, exp2)
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
SaveDir = ['L:\Laura\AnalyzedData\calcium\drifting_gratings\', anim, '\', day, '\'];
if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

%set SaveDir for flashing gratings
global SaveDir1
SaveDir1 = ['L:\Laura\AnalyzedData\calcium\flashing_gratings\', anim, '\', day, '\'];
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
%order of files:  contra,  ipsi

contra_end=Fall.ops.frames_per_file(1); %last frame of contra file 
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

spks_cells=Fall.spks(iscellind,:); 
Fneu_cell=Fall.Fneu(iscellind,:); %neuropil for cells 
F_cell=Fall.F(iscellind,:); %F raw for cells 

%fs=15.5; %15.5 Hertz acquisition (frame rate)
%F_corr_cells=lowpass(F_corr_cells,10,fs); 

%now we must split F and Fneu, and spks into contralateral and ipsilateral
%if a binocular experiment
 
F_contra= F_cell(:,1:contra_end); %raw F for cells 
Fneu_contra=Fneu_cell(:,1:contra_end); %raw neuropil for cells  
F_corr_cells_contra= F_corr_cells(:,1:contra_end);%neuropil correct F for cells 
spks_contra=spks_cells(:,1:contra_end); %spikes for 
    
F_ipsi=F_cell (:, contra_end+1:end); %raw F for cells 
Fneu_ipsi=Fneu_cell(:,contra_end+1:end);%raw neuropil for cells  
F_corr_cells_ipsi=F_corr_cells(:, contra_end+1:end); % neuropil corrected 
spks_ipsi=spks_cells(:,contra_end+1:end);
   
    
%% Get trial information, e.g. orientations, sfs used 

%if driftinggrup and flashing gratings experiment  
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

% %% get dFoF for each eye for drifting gratings, if binocular experiment  
% 
% %for contralateral eye 
[dFoF_on_peak_drift_contra,dFoF_on_drift_contra, dFoF_off_drift_contra, dFoF_noise_drift_contra...
    bs_drift_contra, alldFoF_drift_contra,stim_all_contra, trial_baseline_contra, trial_off_std_contra] = dFoF_drifting(...
    stim_frame_contra,F_corr_cells_contra, ca_delay,numCells);
% 
% %for ipsilateral eye 
[dFoF_on_peak_drift_ipsi,dFoF_on_drift_ipsi, dFoF_off_drift_ipsi,dFoF_noise_drift_ipsi...
    bs_drift_ipsi, alldFoF_drift_ipsi,stim_all_ipsi, trial_baseline_ipsi, trial_off_std_ipsi] = dFoF_drifting(...
    stim_frame_ipsi,F_corr_cells_ipsi, ca_delay,numCells);
% 
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
            dFoF.drift.contra.conds(j).cells(k).peak=squeeze(dFoF_on_peak_drift_contra(k, indices.drift.contra(j).trial_rep)); 

           % dFoF.drift.contra.conds(j).cells(k).mean_peak=mean(max(abs(mean(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),3)),[], 3));
            dFoF.drift.contra.conds(j).cells(k).mean_peak=squeeze(mean(dFoF_on_peak_drift_contra(k, indices.drift.contra(j).trial_rep))); 

            dFoF.drift.contra.conds(j).cells(k).var=squeeze(var(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:), 0)); 
            dFoF.drift.contra.conds(j).cells(k).traces=squeeze(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:)); 
            dFoF.drift.contra.conds(j).cells(k).avg_trace=squeeze(mean(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),2)); %mean along 2nd dimension (trial reps)
            dFoF.drift.contra.conds(j).cells(k).std_trace=squeeze(std(dFoF_on_drift_contra(k, indices.drift.contra(j).trial_rep,:),0, 2));
            
            %noise-4th second after stimulus closure  
            dFoF.drift.contra.conds(j).cells(k).noise=squeeze(dFoF_noise_drift_contra(k, indices.drift.contra(j).trial_rep)); 
            dFoF.drift.contra.conds(j).cells(k).noise_std=squeeze(std(dFoF_noise_drift_contra(k, indices.drift.contra(j).trial_rep))); 
            
            %off trace- trace during gray blank 
            dFoF.drift.contra.conds(j).cells(k).off_traces=squeeze(dFoF_off_drift_contra(k, indices.drift.contra(j).trial_rep,:));
            dFoF.drift.contra.conds(j).cells(k).avg_off_traces=squeeze(mean(dFoF_off_drift_contra(k, indices.drift.contra(j).trial_rep,:),2));
            dFoF.drift.contra.conds(j).cells(k).trace=squeeze(alldFoF_drift_contra(k, indices.drift.contra(j).trial_rep)); %whole trace including on and off period  
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
           
           dFoF.drift.ipsi.conds(j).cells(k).mean_peak= squeeze(mean(dFoF_on_peak_drift_ipsi(k, indices.drift.ipsi(j).trial_rep))); 
            dFoF.drift.ipsi.conds(j).cells(k).var=squeeze(var(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep), 0)); 
            dFoF.drift.ipsi.conds(j).cells(k).traces=squeeze(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:)); 
            dFoF.drift.ipsi.conds(j).cells(k).avg_trace=squeeze(mean(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:),2));
            dFoF.drift.ipsi.conds(j).cells(k).std_trace=squeeze(std(dFoF_on_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:),0,2));
            
            %noise 
            dFoF.drift.ipsi.conds(j).cells(k).noise=squeeze(dFoF_noise_drift_ipsi(k, indices.drift.ipsi(j).trial_rep)); 
            dFoF.drift.ipsi.conds(j).cells(k).off_std=squeeze(std(dFoF_noise_drift_ipsi(k, indices.drift.ipsi(j).trial_rep))); 
            
            %stimulus off 
            dFoF.drift.ipsi.conds(j).cells(k).off_traces=squeeze(dFoF_off_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:));
            dFoF.drift.ipsi.conds(j).cells(k).avg_off_traces=squeeze(mean(dFoF_off_drift_ipsi(k, indices.drift.ipsi(j).trial_rep,:),2));
            dFoF.drift.ipsi.conds(j).cells(k).off_std=squeeze(std(dFoF_off_drift_ipsi(k, indices.drift.ipsi(j).trial_rep))); 

            dFoF.drift.ipsi.conds(j).cells(k).trace=squeeze(alldFoF_drift_ipsi(k,indices.drift.ipsi(j).trial_rep)); %whole trace 
    %   dFoF_conds(j).cells(k).std_trace=std(abs(dFoF_during(k, indices(j).drift_trial_rep),2));
        end
    end

%% get dFoF and spks for each eye for FLASHING gratings, if binocular experiment  

%for contralateral eye 
% [dFoF_on_peak_flash_contra,dFoF_on_flash_contra, bs_flash_contra, alldFoF_flash_contra, numTrialsFlash] = dFoF_flashing(...
%     stim_all_contra,F_corr_cells_contra, ca_delay,numCells);
% 
% %for ipsilateral eye 
% [dFoF_on_peak_flash_ipsi,dFoF_on_flash_ipsi, bs_flash_ipsi, alldFoF_flash_ipsi,numTrialsFlash] = dFoF_flashing(...
%     stim_all_ipsi,F_corr_cells_ipsi, ca_delay,numCells);

% for both eyes 
 [spks_trial_contra, spks_trial_ipsi, spks_trace_contra, spks_trace_ipsi, numTrials_contra, numTrials_ipsi] = getspks_flash(spks_contra, stim_frame_contra, spks_ipsi, stim_frame_ipsi);

[spks_trial_drift_contra,spks_trace_drift_contra,  numTrials_drift_contra]=getspks_drift(spks_contra, stim_all_contra);

[spks_trial_drift_ipsi,  spks_trace_drift_ipsi,  numTrials_drift_ipsi]=getspks_drift( spks_ipsi, stim_all_ipsi);


%do a correction because sometimes stops logging TTL pulses 
% stimulus_flash_contra=stimulus_flash_contra(1:numTrials_contra(1),:,:); 
% stimulus_flash_ipsi=stimulus_flash_ipsi(1:numTrials_ipsi(1),:,:); 
% 
% %for flashing gratings, CONTRALATERAL  
%     for j=1:unique_trialnum_flash_contra % for every unique trial , one field in index 
%       ind_flash_contra(:,j)= ismember(stimulus_flash_contra, unique_trial_flash_contra (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
%       indices.flash.contra(j).trial_rep= find(ind_flash_contra(:,j)==1); % index of where j trial is in entire trial sequence 
%       indices.flash.contra(j).pos= stimulus_flash_contra(j,:); 
% 
%     %now organize for sf 
%         for l= 1:length(unique_sf_flash_contra)
%             indices.flash.contra(l).sfloc= find (stimulus_flash_contra(:,1)==unique_sf_flash_contra(l)); %index to find this trial in  
%             indices.flash.contra(l).sf=unique_sf_flash_contra(l); %what is the actual spatial frequency value
%             if length(indices.flash.contra(l).sfloc)<288 %pad if not the appropriate length 
%                 indices.flash.contra(l).sfloc(288)=0; 
%             end
%         end 
%     % now organize for ori
%         for m= 1:length(unique_ori_flash_contra)
%             indices.flash.contra(m).oriloc=zeros(192,1); %pad with zeros 
%             indices.flash.contra(m).oriloc= find (stimulus_flash_contra(:,2)==unique_ori_flash_contra(m)); %index to find this trial in  
%             indices.flash.contra(m).ori=unique_ori_flash_contra(m); %what is the actual orientation value
%             if length(indices.flash.contra(m).oriloc)<192 %pad if not the appropriate length 
%                 indices.flash.contra(m).oriloc(192)=0; 
%             end
%         end 
%         %spatial phase 
%         for q= 1:length(unique_sp_flash_contra)
%             indices.flash.contra(q).sploc= find (stimulus_flash_contra(:,3)==unique_sp_flash_contra(q)); %index to find this trial in  
%             indices.flash.contra(q).sp=unique_sp_flash_contra(q); %what is the actual orientation value
%             if length(indices.flash.contra(q).sploc)<384 %pad if not the appropriate length 
%                 indices.flash.contra(q).sploc(384)=0; 
%             end
%         end 
% 
% 
%     % now index into dfoF file AND SPKS to make a new structure for each cell ROI  
%         for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
% %             dFoF.flash.contra.conds(j).cells(k).trial_num=indices.flash.contra(j).trial_rep; %unique trial ID 
% %             dFoF.flash.contra.conds(j).cells(k).peak=dFoF_on_peak_flash_contra(k, indices.flash.contra(j).trial_rep); 
% %             dFoF.flash.contra.conds(j).cells(k).mean_peak=mean(dFoF_on_peak_flash_contra(k, indices.flash.contra(j).trial_rep));
% %             dFoF.flash.contra.conds(j).cells(k).var=var(dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep), 0); 
% %             dFoF.flash.contra.conds(j).cells(k).traces=dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep); 
% %             dFoF.flash.contra.conds(j).cells(k).avg_trace=mean(dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep),2);
% %             dFoF.flash.contra.conds(j).cells(k).std_trace=std(dFoF_on_flash_contra(k, indices.flash.contra(j).trial_rep));
%             spks.cells(k).conds(j).contra.trial_num= indices.flash.contra(j).trial_rep;
%             spks.cells(k).conds(j).contra.spks= squeeze(spks_trial_contra(k, indices.flash.contra(j).trial_rep, :)); 
% 
%     %   dFoF_conds(j).cells(k).std_trace=std(abs(dFoF_during(k, indices(j).flash_trial_rep),2));
%         end 
%     end
% 
% 
% %for flashing gratings, IPSILATERAL   
%     for j=1:unique_trialnum_flash_ipsi % for every unique trial , one field in index 
%      ind_flash_ipsi(:,j)= ismember(stimulus_flash_ipsi, unique_trial_flash_ipsi (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
%       indices.flash.ipsi(j).trial_rep_sp= find(ind_flash_ipsi(:,j)==1); % index of where j trial is in entire trial sequence 
%       indices.flash.ipsi(j).pos= stimulus_flash_ipsi(j,:); 
% 
%       ind_flash_ipsi_nosp(:,j)= ismember(stimulus_flash_ipsi(:,1:2), unique_trial_flash_ipsi (j,1:2), 'rows'); % where is jth unique trial in the whole trial sequence? 
%       indices.flash.ipsi(j).trial_rep= find(ind_flash_ipsi_nosp(:,j)==1); % index of where j trial is in entire trial sequence 
%       indices.flash.ipsi(j).pos_nosp= stimulus_flash_ipsi(j,:); 
% 
%     %now organize for sf 
%         for l= 1:length(unique_sf_flash_ipsi)
%             indices.flash.ipsi(l).sfloc= find (stimulus_flash_ipsi(:,1)==unique_sf_flash_ipsi(l)); %index to find this trial in  
%             indices.flash.ipsi(l).sf=unique_sf_flash_ipsi(l); %what is the actual spatial frequency value
%             if length(indices.flash.ipsi(l).sfloc)<288 %pad if not the appropriate length 
%                 indices.flash.ipsi(l).sfloc(288)=0; 
%             end
%         end 
%     % now organize for ori
%         for m= 1:length(unique_ori_flash_ipsi)
%             indices.flash.ipsi(m).oriloc= find (stimulus_flash_ipsi(:,2)==unique_ori_flash_ipsi(m)); %index to find this trial in  
%             indices.flash.ipsi(m).ori=unique_ori_flash_ipsi(m); %what is the actual orientation value
%             if length(indices.flash.ipsi(m).oriloc)<192 %pad if not the appropriate length 
%                 indices.flash.ipsi(m).oriloc(192)=0; 
%             end
%         end 
%     %spatial phase 
%         for q= 1:length(unique_sp_flash_ipsi)
%             indices.flash.ipsi(q).sploc= find (stimulus_flash_ipsi(:,3)==unique_sp_flash_ipsi(q)); %index to find this trial in  
%             indices.flash.ipsi(q).sp=unique_sp_flash_ipsi(q); %what is the actual orientation value
%             if length(indices.flash.ipsi(q).sploc)<432 %pad if not the appropriate length 
%                 indices.flash.ipsi(q).sploc(432)=0; 
%             end
%         end 
% 
%     % now index into dfoF file to make a new structure for each cell ROI  
%         for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
% %             dFoF.flash.ipsi.conds(j).cells(k).trial_num=indices.flash.ipsi(j).trial_rep; %unique trial ID 
% %             dFoF.flash.ipsi.conds(j).cells(k).peak=dFoF_on_peak_flash_ipsi(k, indices.flash.ipsi(j).trial_rep); 
% %             dFoF.flash.ipsi.conds(j).cells(k).mean_peak=mean(dFoF_on_peak_flash_ipsi(k, indices.flash.ipsi(j).trial_rep));
% %             dFoF.flash.ipsi.conds(j).cells(k).var=var(dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep), 0); 
% %             dFoF.flash.ipsi.conds(j).cells(k).traces=dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep); 
% %             dFoF.flash.ipsi.conds(j).cells(k).avg_trace=mean(dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep),2);
% %             dFoF.flash.ipsi.conds(j).cells(k).std_trace=std(dFoF_on_flash_ipsi(k, indices.flash.ipsi(j).trial_rep));
% 
%             spks.cells(k).conds(j).ipsi.trial_num= indices.flash.ipsi(j).trial_rep;
%             spks.cells(k).conds(j).ipsi.spks= squeeze(spks_trial_ipsi(k, indices.flash.ipsi(j).trial_rep, :)); 
%         end
%     end

   

%% organize conditions- DRIFTING GRATINGS 



%initialize matrices 
stimconds_drift_contra=zeros(unique_trialnum_drift_contra,length(mean(dFoF.drift.contra.conds(1).cells(1).traces(:,7:end-1),2)),numCells); %unique trials x reps x cells
stimconds_drift_contra_trials=zeros(unique_trialnum_drift_contra,length(mean(dFoF.drift.contra.conds(1).cells(1).traces(:,7:end-1),2)),numCells);
stimconds_drift_contra_off=zeros(unique_trialnum_drift_contra,length(mean(dFoF.drift.contra.conds(1).cells(1).traces(:,7:end-1),2)),numCells);

stimconds_drift_ipsi=zeros(unique_trialnum_drift_ipsi,length(mean(dFoF.drift.ipsi.conds(1).cells(1).traces(:,7:end-1),2)),numCells); %unique trials x reps x cells
stimconds_drift_ipsi_trials=zeros(unique_trialnum_drift_ipsi,length(mean(dFoF.drift.ipsi.conds(1).cells(1).traces(:,7:end-1),2)),numCells);
stimconds_drift_ipsi_off=zeros(unique_trialnum_drift_ipsi,length(mean(dFoF.drift.ipsi.conds(1).cells(1).traces(:,7:end-1),2)),numCells);

%for contralateral eye 
for qq=1:unique_trialnum_drift_contra 
    for kk=1:numCells
        stimconds_drift_contra(qq, 1:(length(mean(dFoF.drift.contra.conds(qq).cells(kk).traces(:,7:end-1),2))), kk)= cat(1,mean(dFoF.drift.contra.conds(qq).cells(kk).traces(:,7:end-1),2)); %each slice is a cell, each row a unique trial and column a rep of that trial  
        stimconds_drift_contra_trials(qq,1:(length(dFoF.drift.contra.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.drift.contra.conds(qq).cells(kk).trial_num); 
        stimconds_drift_contra_off(qq, 1:(length(mean(dFoF.drift.contra.conds(qq).cells(kk).off_traces,2))), kk)= cat(1,mean(dFoF.drift.contra.conds(qq).cells(kk).off_traces,2)); %each slice is a cell, each row a unique trial and column a rep of that trial         
         for i=1:5 %number of reps 
%             wspval_contra(kk,qq)=ranksum((dFoF.drift.contra.conds(qq).cells(kk).avg_trace)',(dFoF.drift.contra.conds(qq).cells(kk).avg_off_traces)');  
        wspval_contra(kk,qq,i)=ranksum((dFoF.drift.contra.conds(qq).cells(kk).traces(i,:))',(dFoF.drift.contra.conds(qq).cells(kk).off_traces(i,:))');  
         end
    end
end

%for ipsilateral eye 
for qq=1:unique_trialnum_drift_ipsi
    for kk=1:numCells
        stimconds_drift_ipsi(qq, 1:(length(mean(dFoF.drift.ipsi.conds(qq).cells(kk).traces(:,7:end-1),2))), kk)= cat(1,mean(dFoF.drift.ipsi.conds(qq).cells(kk).traces(:,7:end-1),2)); %each slice is a cell, each row a unique trial and column a rep of that trial  
        stimconds_drift_ipsi_trials(qq,1:(length(dFoF.drift.ipsi.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.drift.ipsi.conds(qq).cells(kk).trial_num); 
        stimconds_drift_ipsi_off(qq, 1:(length(mean(dFoF.drift.ipsi.conds(qq).cells(kk).off_traces,2))), kk)= cat(1,mean(dFoF.drift.ipsi.conds(qq).cells(kk).off_traces,2)); %each slice is a cell, each row a unique trial and column a rep of that trial         
                 for i=1:5 %number of reps 
           % wspval_ipsi(kk,qq)=ranksum((dFoF.drift.ipsi.conds(qq).cells(kk).avg_trace)',(dFoF.drift.ipsi.conds(qq).cells(kk).avg_off_traces)'); 
           wspval_ipsi(kk,qq,i)=ranksum((dFoF.drift.ipsi.conds(qq).cells(kk).traces(i,:))',(dFoF.drift.ipsi.conds(qq).cells(kk).off_traces(i,:))'); 
         end
    end
end
% 
% wspval_contra=permute(wspval_contra,[3 2 1]);
% wspval_ipsi=permute(wspval_ipsi,[3 2 1]);

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

% visresp_cells_contra=zeros(1, numCells); 
% visresp_cells_ipsi=zeros(1, numCells); 

visresp_cells_contra=zeros(unique_trialnum_drift_contra, numCells); 
visresp_cells_ipsi=zeros(unique_trialnum_drift_ipsi, numCells); 


%adjust p value for multiple comparisons, (32 unique trials)
%methods for determining cell responsivity: Allen Brain atlas technical
%white papers, Salinas et al. 2021 (JNeuro). Jenks & Shepherd, 2023 (Cell
%Reports) 

for q=1:numCells 
    for k=1:unique_trialnum_drift_contra
    if length(find(wspval_contra(q,k,:)<0.00156))>2 %for at least one condition %for at least 2 trials 
        visresp_cells_contra(k,q)=1; 
    end 
    end
end

for q=1:numCells
    for k=1:unique_trialnum_drift_ipsi
    if length(find(wspval_ipsi(q,k,:)<0.00156))>2%for at least one condition %for at least 2 trials 
        visresp_cells_ipsi(k,q)=1; 
    end    
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
%         response_CV_flash_contra(j,q)= std(stimconds_flash_contra(:,j,q)) ./ mean(stimconds_flash_contra(:,j,q),'omitnan'); %response reliability metric for each stimulus condition 
%     end
% end
% 
% for j=1:unique_trialnum_flash_ipsi
%     for q=1:numCells
%         response_CV_flash_ipsi(j,q)= std(stimconds_flash_ipsi(:,j,q)) ./ mean(stimconds_flash_ipsi(:,j,q),'omitnan'); %response reliability metric for each stimulus condition 
%     end
% end


%% DRIFTING GRATINGS- now look at orientation and spatial frequency preferences 
%for visually responsive cells 
%contralateral eye 
for kk=1:numCells 
        for j=1:length(unique_sf_drift_contra) %spatial freq
            dFoF.drift.contra.sf(j).cells(kk).peak= squeeze(dFoF_on_peak_drift_contra(kk, indices.drift.contra(j).sfloc)); % 
            dFoF.drift.contra.sf(j).cells(kk).traces= squeeze(dFoF_on_drift_contra(kk, indices.drift.contra(j).sfloc,:)); 
            dFoF.drift.contra.sf(j).cells(kk).avgtrace= squeeze(mean(dFoF_on_drift_contra(kk, indices.drift.contra(j).sfloc,:),2,'omitnan'));
        end
        
        for k=1:length(unique_ori_drift_contra) %orientation
            dFoF.drift.contra.ori(k).cells(kk).peak= squeeze(dFoF_on_peak_drift_contra(kk, indices.drift.contra(k).oriloc)); % ;
            dFoF.drift.contra.ori(k).cells(kk).traces= squeeze(dFoF_on_drift_contra(kk, indices.drift.contra(k).oriloc,:));
            dFoF.drift.contra.ori(k).cells(kk).avgtrace= squeeze(mean(dFoF_on_drift_contra(kk, indices.drift.contra(k).oriloc,:),2,'omitnan'));
        end
end
%ipsilateral eye 
for kk=1:numCells
        for j=1:length(unique_sf_drift_ipsi) %spatial freq
            dFoF.drift.ipsi.sf(j).cells(kk).peak= squeeze(dFoF_on_peak_drift_ipsi(kk, indices.drift.ipsi(j).sfloc)); % 
            dFoF.drift.ipsi.sf(j).cells(kk).traces= squeeze(dFoF_on_drift_ipsi(kk, indices.drift.ipsi(j).sfloc,:));
            dFoF.drift.ipsi.sf(j).cells(kk).avgtrace= squeeze(mean(dFoF_on_drift_ipsi(kk, indices.drift.ipsi(j).sfloc,:),2,'omitnan'));
        end
        for k=1:length(unique_ori_drift_ipsi) %orientation
            dFoF.drift.ipsi.ori(k).cells(kk).peak=squeeze(dFoF_on_peak_drift_ipsi(kk, indices.drift.ipsi(k).oriloc)); % 
            dFoF.drift.ipsi.ori(k).cells(kk).traces= squeeze(dFoF_on_drift_ipsi(kk, indices.drift.ipsi(k).oriloc,:));
            dFoF.drift.ipsi.ori(k).cells(kk).avgtrace= squeeze(mean(dFoF_on_drift_ipsi(kk, indices.drift.ipsi(k).oriloc,:),2,'omitnan'));
        end
end

resp_sf_drift_contra=zeros(length(unique_sf_drift_contra), 80, numCells); 
resp_sf_drift_ipsi=zeros(length(unique_sf_drift_ipsi), 80, numCells);
resp_ori_drift_contra=zeros(length(unique_ori_drift_contra), 10, numCells); 
resp_ori_drift_ipsi=zeros(length(unique_ori_drift_ipsi), 10, numCells);

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
ori_trialnum_drift_contra=length(dFoF.drift.contra.ori(1).cells(1).traces(:,1)); %how many times is each ori presented? 

%IPSILATERAL EYE 
%spatial frequency
resp_sf_drift_ipsi(resp_sf_drift_ipsi==0)=nan;
resp_sf_drift_ipsi= permute(resp_sf_drift_ipsi, [2 1 3]);
sf_trialnum_drift_ipsi=length(dFoF.drift.ipsi.sf(1).cells(1).traces(:,1)); %how many times is each sf presented?

%orientation
resp_ori_drift_ipsi(resp_ori_drift_ipsi==0)=nan;
resp_ori_drift_ipsi= permute(resp_ori_drift_ipsi, [2 1 3]);
ori_trialnum_drift_ipsi=length(dFoF.drift.ipsi.ori(1).cells(1).traces(:,1)); %how many times is each ori presented




%% does each eye have a significant visual response to any drifting grating condition? or flashing grating via dFoF
%test again the set threshold "threshold_active_contra" or
%"threshold_active_ipsi" 
%this method is from Rose, Jaepel, Hubener, and Bonhoeffer, 2016.
%"Cell-specific restoration of stimulus preference after monocular deprivation in the visual cortex"
%Science, doi: 10.1126/science.aad3358

%make a separate threshold for drifting and flashing gratings just in case
%there is any photobleaching 

% %Do this for both eyes     
% for i=1:numCells
%     median_contra_dFoF(i)=median(alldFoF_drift_contra(i,:),'all'); %contralateral eye
%     median_ipsi_dFoF(i)= median(alldFoF_drift_ipsi (i,:),'all'); % ipsilateral eye 
% end 
% 
%set different threshold for drifting or flashing 
% std_lowerdFoF_contra_flash= zeros(1, numCells); 
std_lowerdFoF_contra_drift= zeros(1, numCells); 
std_lowerdFoF_ipsi_drift= zeros(1, numCells); 
% std_lowerdFoF_ipsi_flash= zeros(1, numCells); 


%for i=1:numCells
    %drifting gratings 
%     indices.drift.cells(i).contra.std = find(alldFoF_drift_contra(i,:)<0); %contralateral eye
%     std_lowerdFoF_contra_drift(i)= std(alldFoF_drift_contra(i,indices.drift.cells(i).contra.std));
%     indices.drift.cells(i).ipsi.std = find(alldFoF_drift_ipsi(i,:)<0); %ipsilateral eye 
%     std_lowerdFoF_ipsi_drift(i)= std(alldFoF_drift_ipsi(i,indices.drift.cells(i).ipsi.std));

%     std_contra_drift(i)=std(dFoF_off_drift_contra(i,:)); 
%     std_ipsi_drift(i)=std(dFoF_off_drift_ipsi(i,:)); 
% 
%threshold as 2 standard deviations above the noise mean for all trials for
%a single cell 
% dFoF_noise_drift_contra(isinf(dFoF_noise_drift_contra))=0;
% dFoF_noise_drift_ipsi(isinf(dFoF_noise_drift_ipsi))=0;
% 
% threshold_active_contra_drift=median(dFoF_noise_drift_contra,2)+2*(std(dFoF_noise_drift_contra,0,2));
% threshold_active_ipsi_drift=median(dFoF_noise_drift_ipsi,2)+2*(std(dFoF_noise_drift_ipsi,0,2));

% threshold_active_ipsi_drift(i)=median(dFoF_off_drift_ipsi(i,:))+(std_ipsi_drift(i).*2); 


%     %flashing gratings
%    indices.flash.cells(i).contra.std = find(alldFoF_flash_contra(i,:)<0); %contralateral eye
%     std_lowerdFoF_contra_flash(i)= std(alldFoF_flash_contra(i,indices.flash.cells(i).contra.std));
%     indices.flash.cells(i).ipsi.std = find(alldFoF_flash_ipsi(i,:)<0); %ipsilateral eye 
%     std_lowerdFoF_ipsi_flash(i)= std(alldFoF_flash_ipsi(i,indices.flash.cells(i).ipsi.std)); 

%end

%threshold of activity/ visual responsivity for each eye 

% threshold_active_contra_drift=std_lowerdFoF_contra_drift*3; 
% threshold_active_ipsi_drift=std_lowerdFoF_ipsi_drift*3; 



% visresp_cells_drift_contra=zeros(unique_trialnum_drift_contra, numCells); 
% visresp_cells_drift_ipsi=zeros(unique_trialnum_drift_ipsi, numCells); 
% visresp_cells_flash_contra=zeros(18, numCells); 
% visresp_cells_flash_ipsi=zeros(18, numCells); 


%for contralateral eye responses 
% for q=1:numCells
%     for j=1:unique_trialnum_drift_contra 
%         mean_stimconds_drift_contra(j,q)= squeeze(mean(stimconds_drift_contra(:,j,q))); 
%         if length(find(mean_stimconds_drift_contra(j,q)>= threshold_active_contra_drift(q)))>=1
%             visresp_cells_drift_contra(j,q)=1; %matrix of vis resp cells, 0/1
%         end
%     end
% end
% 
% %for ipsilateral eye responses 
% for q=1:numCells
%     for j=1:unique_trialnum_drift_ipsi   
%         mean_stimconds_drift_ipsi(j,q)= squeeze(mean(stimconds_drift_ipsi(:,j,q))); 
%         if length(find(mean_stimconds_drift_ipsi(j,q)>= threshold_active_ipsi_drift(q)))>=1
%             visresp_cells_drift_ipsi(j,q)=1; %matrix of vis resp cells, 0/1
%         end
%     end
% end

%check to see in how many cells there is a threshold cross 
visresp_cells_total_contra_drift=zeros(1,numCells); 
visresp_cells_total_ipsi_drift =zeros(1,numCells); 



%contralateral eye 
for q=1:numCells
    if length(find(visresp_cells_contra(:,q)==1))>=1
        visresp_cells_total_contra_drift(q)=1; 
    end
end

%ipsilateral eye 
for q=1:numCells
    if length(find(visresp_cells_ipsi(:,q)==1))>=1
        visresp_cells_total_ipsi_drift(q)=1; 
    end
end

% reliability metrics for only responsive cells 
%response_CV_contra/ ipsi(unique stimulus, cell)

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

response_CV_contra_resp=response_CV_contra(:,logical(visresp_cells_total_drift)); 
response_CV_ipsi_resp=response_CV_ipsi(:,logical(visresp_cells_total_drift)); 

response_CV_contra_resp_mean=mean(response_CV_contra_resp,1); 
response_CV_ipsi_resp_mean=mean(response_CV_ipsi_resp,1); 

%save reliability metrics 

 writematrix(response_CV_contra_resp_mean,fullfile(SaveDir,strcat(anim, '_response_CV_contra_resp_mean.csv'))); 
 writematrix(response_CV_ipsi_resp_mean,fullfile(SaveDir,strcat(anim, '_response_CV_ipsi_resp_mean.csv'))); 

 save(fullfile(SaveDir, strcat(anim, '_response_CV_contra_resp_mean.mat')), 'response_CV_contra_resp_mean');
  save(fullfile(SaveDir, strcat(anim, '_response_CV_ipsi_resp_mean.mat')), 'response_CV_ipsi_resp_mean');

%% plot percent visually responsive to DRIFTING GRATINGS

num_visresp_drift=length(find(visresp_cells_total_drift>0));
percent_visresp_drift=num_visresp_drift/numCells; 
plotresponsivecells(num_visresp_drift,numCells,'drift');   

%% Spiking during drifting gratings 
% get spiking during stim on 
% get std for all trial reps
% find where max std is- this is the optimal delay (tmax)
% signal= mean of spiking standard deviation 4-8 frames after stim 
% get SNR



% % reslice to have ori x sf x sp x tau x 2 (rep)x cell 
% r_contra=zeros(16,2,2,20,numCells); 
% r_ipsi=zeros(16,2,2,20,numCells); 
% 
% 
% %indices for re-slicing matrix --CONTRALATERAL 
% for k=1:length(unique_sf_drift_contra) 
%     for i=1:length(unique_ori_drift_contra)
%         for j=1:length(unique_sp_drift_contra)
%             temp_contra=intersect(intersect(indices.drift.contra(j).sploc, indices.drift.contra(i).oriloc),indices.drift.contra(k).sfloc); 
%             temp_contra(3)=0; 
%             ind_mat_contra(i,k,j,1:length(temp_contra))=temp_contra; %hack because some stimuli are missing  
%         end
%     end
% end 
% 
% %indices for re-slicing matrix --IPSILATERAL 
% for k=1:length(unique_sf_drift_ipsi) 
%     for i=1:length(unique_ori_drift_ipsi)
%         for j=1:length(unique_sp_drift_ipsi)
%             temp_ipsi=intersect(intersect(indices.drift.ipsi(j).sploc, indices.drift.ipsi(i).oriloc),indices.drift.ipsi(k).sfloc); 
%             temp_ipsi(3)=0; 
%             ind_mat_ipsi(i,k,j,1:length(temp_ipsi))=temp_ipsi; %hack because some stimuli are missing           
%         end
%     end
% end 
% 
% % index in contralateral 
% for q=1:numCells
%     for k=1:length(unique_sf_drift_contra) 
%     for i=1:length(unique_ori_drift_contra)
%         for j=1:length(unique_sp_drift_contra)
%             temp2_contra=squeeze(ind_mat_contra(i,k,j,:));
%             temp2_contra(temp2_contra==0)=nan; 
%             r_contra(i,k,j,:,q)=squeeze(mean(spks_trial_contra(q,rmmissing(temp2_contra),:),2));        
%         end
%     end
% end 
% end
% 
% % index in ipsilateral 
% for q=1:numCells
%     for k=1:length(unique_sf_drift_ipsi) 
%     for i=1:length(unique_ori_drift_ipsi)
%         for j=1:length(unique_sp_drift_ipsi)
%             temp2_ipsi=squeeze(ind_mat_ipsi(i,k,j,:));
%             temp2_ipsi(temp2_ipsi==0)=nan; 
%             r_ipsi(i,k,j,:,q)=squeeze(mean(spks_trial_ipsi(q,rmmissing(temp2_ipsi),:),2));        
%         end
%     end
% end 
% end
% 
% %average across spatial phase 
% r_contra=squeeze(mean(r_contra,3)); 
% r_ipsi=squeeze(mean(r_ipsi,3));
% 
% oris_rad=deg2rad(unique_ori_drift_contra);
% 
% %now you have ori x sf x tau (20) x cells
% 
% %For CONTRALATERAL EYE RESPONSES 
% for i=1:numCells 
%     z=squeeze(r_contra(:,:,:,i));
%     q=reshape(z, 18*12, []); 
%     k=std(q); 
%     [kmax, t]= max(k); 
%     snr=kmax/mean(k([1 2 18:20])); 
%     tmax=t; 
%     spks.drift.cells(i).contra.snr=squeeze(snr); 
%     spks.drift.cells(i).contra.stdmax=squeeze(kmax); 
%     spks.drift.cells(i).contra.std=squeeze(q); 
%     spks.drift.cells(i).contra.tmax=squeeze(tmax);  
%     spks.drift.cells(i).contra.kern=squeeze(z(:,:,t)); %slice through max std deviation (may or may not be visually responsive)
% 
%     %get orientation and spatial frequency tuning
%     %take slice through max  response 
% 
%     [ii,jj] = find(spks.drift.cells(i).contra.kern == max(spks.drift.cells(i).contra.kern(:))); 
%     % ii is index for max ori slice 
%     % jj is index for max sf slice 
% 
%     resp_ori_contra= spks.drift.cells(i).contra.kern(:,jj(1)); %take slice through ori responses at max sf response 
%     resp_sf_contra= spks.drift.cells(i).contra.kern(ii(1),:)'; %take slice through sf responses at max ori value 
%     spks.drift.cells(i).contra.oriresps= resp_ori_contra;
%     spks.drift.cells(i).contra.sfresps=resp_sf_contra; 
%    
%     resp_sf_contra(resp_sf_contra<0) = 0; %set baseline at zero or else this doesn't work 
%     spks.drift.cells(i).contra.pref_sf = 10^(sum(resp_sf_contra.*log10(unique_sf_drift_contra))/sum(resp_sf_contra));
%     
%   %  orientation tuning
%     resp_ori_contra(resp_ori_contra<0)=0; %set baseline at zero or else this doesn't work 
%     pref_ori(i)= rad2deg(0.5 .*(angle(sum(resp_ori_contra.*exp(2.*1i*oris_rad))))); %calculate preferred orientation in rad, then convert to degrees
%     if (pref_ori(i))<0
%         pref_ori(i)= pref_ori(i)+180; %correction for orientation  
%     end
% 
%     spks.drift.cells(i).contra.pref_ori=pref_ori(i); 
%     spks.drift.cells(i).contra.cv=1-abs(sum(resp_ori_contra.*exp(2.*1i.*unique_ori_drift_contra))./sum(resp_ori_contra)); %circular variance 
%    
% end 
% 
% clear z; clear q; clear k; clear i; clear tmax; clear t; clear snr; clear ii; clear jj; clear pref_ori; 
% 
% %For IPSILATERAL EYE RESPONSES 
% for i=1:numCells 
%     z=squeeze(r_ipsi(:,:,:,i));
%     q=reshape(z, 18*12, []); 
%     k=std(q); 
%     [kmax, t]= max(k); 
%     snr=kmax/mean(k([1 2 18:20])); 
%     tmax=t; 
%     spks.drift.cells(i).ipsi.snr=squeeze(snr); 
%     spks.drift.cells(i).ipsi.stdmax=squeeze(kmax); 
%     spks.drift.cells(i).ipsi.std=squeeze(q); 
%     spks.drift.cells(i).ipsi.tmax=squeeze(tmax);  
%     spks.drift.cells(i).ipsi.kern=squeeze(z(:,:,t)); %slice through max std deviation (may or may not be visually responsive)
% 
%     %get orientation and spatial frequency tuning
%     %take slice through max  response 
% 
%     [ii,jj] = find(spks.drift.cells(i).ipsi.kern == max(spks.drift.cells(i).ipsi.kern(:))); 
%     % ii is index for max ori slice 
%     % jj is index for max sf slice 
% 
%     resp_ori_ipsi= spks.drift.cells(i).ipsi.kern(:,jj(1)); %take slice through ori responses at max sf response 
%     resp_sf_ipsi= spks.drift.cells(i).ipsi.kern(ii(1),:)'; %take slice through sf responses at max ori value 
%     spks.drift.cells(i).ipsi.oriresps= resp_ori_ipsi;
%     spks.drift.cells(i).ipsi.sfresps=resp_sf_ipsi; 
%    
%     resp_sf_ipsi(resp_sf_ipsi<0) = 0; %set baseline at zero or else this doesn't work 
%     spks.drift.cells(i).ipsi.pref_sf = 10^(sum(resp_sf_ipsi.*log10(unique_sf_drift_ipsi))/sum(resp_sf_ipsi));
%     
%   %  orientation tuning
%     resp_ori_ipsi(resp_ori_ipsi<0)=0; %set baseline at zero or else this doesn't work 
%     pref_ori(i)= rad2deg(0.5 .*(angle(sum(resp_ori_ipsi.*exp(2.*1i*oris_rad))))); %calculate preferred orientation in rad, then convert to degrees
%     if (pref_ori(i))<0
%         pref_ori(i)= pref_ori(i)+180; %correction for orientation  
%     end
% 
%     spks.drift.cells(i).ipsi.pref_ori=pref_ori(i); 
%     spks.drift.cells(i).ipsi.cv=1-abs(sum(resp_ori_ipsi.*exp(2.*1i.*unique_ori_drift_ipsi))./sum(resp_ori_ipsi)); %circular variance   
% end 
% 
% % Visual responsivity for spiking data for prelim OD score

indices.drift.respcells=find(visresp_cells_total_drift>0); 
% 
% %% save spiking data for Drifting gratings
% 
% writematrix(spk_resp,fullfile(SaveDir,strcat(anim, '_spk_resp.csv'))); 
% writematrix(spks_contra,fullfile(SaveDir,strcat(anim, '_spks_contra.csv'))); 
% writematrix(spks_ipsi,fullfile(SaveDir,strcat(anim, '_spks_ipsi.csv'))); 
% writematrix(spks_trial_contra,fullfile(SaveDir,strcat(anim, '_spks_trial_contra.csv'))); 
% writematrix(spks_trial_ipsi,fullfile(SaveDir,strcat(anim, '_spks_trial_ipsi.csv'))); 

%% Flashing gratings- organize trials 
% get spiking during stim on 
%get std for all trial reps
%find where max std is- this is the optimal delay (tmax)
%signal= mean of spiking standard deviation 4-8 frames after stim 
%get SNR
% 


%reslice to have ori x sf x sp x tau x 2 (rep)x cell 
% r_contra=zeros(18,12,8,20,numCells); 
% r_ipsi=zeros(18,12,8,20,numCells); 
% 
% 
% %indices for re-slicing matrix --CONTRALATERAL 
% for k=1:length(unique_sf_flash_contra) 
%     for i=1:length(unique_ori_flash_contra)
%         for j=1:length(unique_sp_flash_contra)
%             temp_contra=intersect(intersect(indices.flash.contra(j).sploc, indices.flash.contra(i).oriloc),indices.flash.contra(k).sfloc); 
%             temp_contra(3)=0; 
%             ind_mat_contra(i,k,j,1:length(temp_contra))=temp_contra; %hack because some stimuli are missing  
%         end
%     end
% end 
% 
% %indices for re-slicing matrix --IPSILATERAL 
% for k=1:length(unique_sf_flash_ipsi) 
%     for i=1:length(unique_ori_flash_ipsi)
%         for j=1:length(unique_sp_flash_ipsi)
%             temp_ipsi=intersect(intersect(indices.flash.ipsi(j).sploc, indices.flash.ipsi(i).oriloc),indices.flash.ipsi(k).sfloc); 
%             temp_ipsi(3)=0; 
%             ind_mat_ipsi(i,k,j,1:length(temp_ipsi))=temp_ipsi; %hack because some stimuli are missing           
%         end
%     end
% end 
% 
% % index in contralateral 
% for q=1:numCells
%     for k=1:length(unique_sf_flash_contra) 
%     for i=1:length(unique_ori_flash_contra)
%         for j=1:length(unique_sp_flash_contra)
%             temp2_contra=squeeze(ind_mat_contra(i,k,j,:));
%             temp2_contra(temp2_contra==0)=nan; 
%             r_contra(i,k,j,:,q)=squeeze(mean(spks_trial_contra(q,rmmissing(temp2_contra),:),2));        
%         end
%     end
% end 
% end
% 
% % index in ipsilateral 
% for q=1:numCells
%     for k=1:length(unique_sf_flash_ipsi) 
%     for i=1:length(unique_ori_flash_ipsi)
%         for j=1:length(unique_sp_flash_ipsi)
%             temp2_ipsi=squeeze(ind_mat_ipsi(i,k,j,:));
%             temp2_ipsi(temp2_ipsi==0)=nan; 
%             r_ipsi(i,k,j,:,q)=squeeze(mean(spks_trial_ipsi(q,rmmissing(temp2_ipsi),:),2));        
%         end
%     end
% end 
% end
% 
% %average across spatial phase 
% r_contra=squeeze(mean(r_contra,3)); 
% r_ipsi=squeeze(mean(r_ipsi,3));
% 
% oris_rad=deg2rad(unique_ori_flash_contra);
% 
% %now you have ori x sf x tau (20) x cells
% 
% %For CONTRALATERAL EYE RESPONSES 
% for i=1:numCells 
%     z=squeeze(r_contra(:,:,:,i));
%     q=reshape(z, 18*12, []); 
%     k=std(q); 
%     [kmax, t]= max(k); 
%     snr=kmax/mean(k([1 2 18:20])); 
%     tmax=t; 
%     spks.cells(i).contra.snr=squeeze(snr); 
%     spks.cells(i).contra.stdmax=squeeze(kmax); 
%     spks.cells(i).contra.std=squeeze(q); 
%     spks.cells(i).contra.tmax=squeeze(tmax);  
%     spks.cells(i).contra.kern=squeeze(z(:,:,t)); %slice through max std deviation (may or may not be visually responsive)
% 
%     %get orientation and spatial frequency tuning
%     %take slice through max  response 
% 
%     [ii,jj] = find(spks.cells(i).contra.kern == max(spks.cells(i).contra.kern(:))); 
%     % ii is index for max ori slice 
%     % jj is index for max sf slice 
% 
%     resp_ori_contra= spks.cells(i).contra.kern(:,jj(1)); %take slice through ori responses at max sf response 
%     resp_sf_contra= spks.cells(i).contra.kern(ii(1),:)'; %take slice through sf responses at max ori value 
%     spks.cells(i).contra.oriresps= resp_ori_contra;
%     spks.cells(i).contra.sfresps=resp_sf_contra; 
%    
%     resp_sf_contra(resp_sf_contra<0) = 0; %set baseline at zero or else this doesn't work 
%     spks.cells(i).contra.pref_sf = 10^(sum(resp_sf_contra.*log10(unique_sf_flash_contra))/sum(resp_sf_contra));
%     
%   %  orientation tuning
%     resp_ori_contra(resp_ori_contra<0)=0; %set baseline at zero or else this doesn't work 
%     pref_ori(i)= rad2deg(0.5 .*(angle(sum(resp_ori_contra.*exp(2.*1i*oris_rad))))); %calculate preferred orientation in rad, then convert to degrees
%     if (pref_ori(i))<0
%         pref_ori(i)= pref_ori(i)+180; %correction for orientation  
%     end
% 
%     spks.cells(i).contra.pref_ori=pref_ori(i); 
%     spks.cells(i).contra.cv=1-abs(sum(resp_ori_contra.*exp(2.*1i.*unique_ori_flash_contra))./sum(resp_ori_contra)); %circular variance 
%    
% end 
% 
% clear z; clear q; clear k; clear i; clear tmax; clear t; clear snr; clear ii; clear jj; clear pref_ori; 
% 
% %For IPSILATERAL EYE RESPONSES 
% for i=1:numCells 
%     z=squeeze(r_ipsi(:,:,:,i));
%     q=reshape(z, 18*12, []); 
%     k=std(q); 
%     [kmax, t]= max(k); 
%     snr=kmax/mean(k([1 2 18:20])); 
%     tmax=t; 
%     spks.cells(i).ipsi.snr=squeeze(snr); 
%     spks.cells(i).ipsi.stdmax=squeeze(kmax); 
%     spks.cells(i).ipsi.std=squeeze(q); 
%     spks.cells(i).ipsi.tmax=squeeze(tmax);  
%     spks.cells(i).ipsi.kern=squeeze(z(:,:,t)); %slice through max std deviation (may or may not be visually responsive)
% 
%     %get orientation and spatial frequency tuning
%     %take slice through max  response 
% 
%     [ii,jj] = find(spks.cells(i).ipsi.kern == max(spks.cells(i).ipsi.kern(:))); 
%     % ii is index for max ori slice 
%     % jj is index for max sf slice 
% 
%     resp_ori_ipsi= spks.cells(i).ipsi.kern(:,jj(1)); %take slice through ori responses at max sf response 
%     resp_sf_ipsi= spks.cells(i).ipsi.kern(ii(1),:)'; %take slice through sf responses at max ori value 
%     spks.cells(i).ipsi.oriresps= resp_ori_ipsi;
%     spks.cells(i).ipsi.sfresps=resp_sf_ipsi; 
%    
%     resp_sf_ipsi(resp_sf_ipsi<0) = 0; %set baseline at zero or else this doesn't work 
%     spks.cells(i).ipsi.pref_sf = 10^(sum(resp_sf_ipsi.*log10(unique_sf_flash_ipsi))/sum(resp_sf_ipsi));
%     
%   %  orientation tuning
%     resp_ori_ipsi(resp_ori_ipsi<0)=0; %set baseline at zero or else this doesn't work 
%     pref_ori(i)= rad2deg(0.5 .*(angle(sum(resp_ori_ipsi.*exp(2.*1i*oris_rad))))); %calculate preferred orientation in rad, then convert to degrees
%     if (pref_ori(i))<0
%         pref_ori(i)= pref_ori(i)+180; %correction for orientation  
%     end
% 
%     spks.cells(i).ipsi.pref_ori=pref_ori(i); 
%     spks.cells(i).ipsi.cv=1-abs(sum(resp_ori_ipsi.*exp(2.*1i.*unique_ori_flash_ipsi))./sum(resp_ori_ipsi)); %circular variance   
% end 
% 
% %% Visual responsivity for spiking data for prelim OD score
% 
% noise_contra=[]; 
% noise_ipsi=[]; 
% for i=1:numCells 
%     if (spks.cells(i).contra.tmax<6) || (spks.cells(i).contra.tmax>10) %then not in responsive range
%         noise_contra(i)=spks.cells(i).contra.snr; 
%     end 
%     if (spks.cells(i).ipsi.tmax<6) ||(spks.cells(i).ipsi.tmax>10) %then not in responsive range
%         noise_ipsi(i)=spks.cells(i).ipsi.snr; 
%     end 
% end 
% 
% noise_contra(noise_contra==0)=nan; 
% noise_ipsi(noise_ipsi==0)=nan; 
% 
% noise=horzcat(noise_contra, noise_ipsi); 
% noise_mean_contra=mean(noise_contra,'omitnan'); 
% noise_std_contra=std(noise_contra,'omitnan'); 
% 
% noise_mean_ipsi=mean(noise_ipsi,'omitnan'); 
% noise_std_ipsi=std(noise_ipsi,'omitnan');
% 
% threshold_contra=1+(2*noise_std_contra); 
% threshold_ipsi=1+(2*noise_std_ipsi); 
% 
% for i=1:numCells
%     if spks.cells(i).contra.snr>threshold_contra && spks.cells(i).contra.tmax>=6 && spks.cells(i).contra.tmax<=10
%         contra_resp(i)=1; 
%     else
%         contra_resp(i)=0;
%     end 
% end 
% 
% for i=1:numCells
%     if spks.cells(i).ipsi.snr>threshold_ipsi && spks.cells(i).ipsi.tmax>=6 && spks.cells(i).ipsi.tmax<=10
%         ipsi_resp(i)=1; 
%     else
%         ipsi_resp(i)=0;
%     end 
% end 
% 
% for i=1:numCells
%     if contra_resp(i)==1||ipsi_resp(i)==1
%      spk_resp(i)=1; 
%     end 
% end
% 
% spk_id_resp=find(spk_resp>0); 

%% OD with spiking data 

% [ODScore_spiking]=getODscore_spk(spks, spk_id_resp); 
% 
% plotODscore(ODScore_spiking, SaveDir1, 'spikes');

%FLASHING GRATINGS- responsivity via dFoF
% 
% for kk=1:numCells
%         for j=1:length(unique_sf_flash_contra) %spatial freq
%             dFoF.flash.contra.sf(j).cells(kk).peak= dFoF_on_peak_flash_contra(kk, indices.flash.contra(j).sfloc);
%             dFoF.flash.contra.sf(j).cells(kk).traces= dFoF_on_flash_contra(kk, indices.flash.contra(j).sfloc);
%             dFoF.flash.contra.sf(j).cells(kk).avgtrace= mean(dFoF_on_flash_contra(kk, indices.flash.contra(j).sfloc),2,'omitnan');
%         end
%         for k=1:length(unique_ori_flash_contra) %orientation
%             dFoF.flash.contra.ori(k).cells(kk).peak= dFoF_on_peak_flash_contra(kk, indices.flash.contra(k).oriloc);
%             dFoF.flash.contra.ori(k).cells(kk).traces= dFoF_on_flash_contra(kk, indices.flash.contra(k).oriloc);
%             dFoF.flash.contra.ori(k).cells(kk).avgtrace= mean(dFoF_on_flash_contra(kk, indices.flash.contra(k).oriloc),2,'omitnan');
%         end
% end
% 
% 
% for kk=1:numCells
%         for j=1:length(unique_sf_flash_ipsi) %spatial freq
%             dFoF.flash.ipsi.sf(j).cells(kk).peak= dFoF_on_peak_flash_ipsi(kk, indices.flash.ipsi(j).sfloc);
%             dFoF.flash.ipsi.sf(j).cells(kk).traces= dFoF_on_flash_ipsi(kk, indices.flash.ipsi(j).sfloc);
%             dFoF.flash.ipsi.sf(j).cells(kk).avgtrace= mean(dFoF_on_flash_ipsi(kk, indices.flash.ipsi(j).sfloc),2,'omitnan');
%         end
%         for k=1:length(unique_ori_flash_ipsi) %orientation
%             dFoF.flash.ipsi.ori(k).cells(kk).peak= dFoF_on_peak_flash_ipsi(kk, indices.flash.ipsi(k).oriloc);
%             dFoF.flash.ipsi.ori(k).cells(kk).traces= dFoF_on_flash_ipsi(kk, indices.flash.ipsi(k).oriloc);
%             dFoF.flash.ipsi.ori(k).cells(kk).avgtrace= mean(dFoF_on_flash_ipsi(kk, indices.flash.ipsi(k).oriloc),2,'omitnan');
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
%         mean_resp_ori_flash_contra(j,q)= squeeze(mean(resp_ori_flash_contra(:,j,q),'omitnan')); 
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
%         mean_resp_ori_flash_ipsi(j,q)= squeeze(mean(resp_ori_flash_ipsi(:,j,q),'omitnan')); 
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

%% save spiking data 

% save(fullfile(SaveDir, strcat(anim, '_spks.mat')), 'spks'); %save indices structure
% 
% writematrix(spk_resp,fullfile(SaveDir,strcat(anim, '_spk_resp.csv'))); 
% writematrix(spks_trace_contra,fullfile(SaveDir,strcat(anim, '_spks_contra.csv'))); 
% writematrix(spks_trace_ipsi,fullfile(SaveDir,strcat(anim, '_spks_ipsi.csv'))); 
% 
% writematrix(spks_trial_contra,fullfile(SaveDir,strcat(anim, '_spks_trial_contra.csv'))); 
% writematrix(spks_trial_ipsi,fullfile(SaveDir,strcat(anim, '_spks_trial_ipsi.csv'))); 

%% save drifting spiking data 
% writematrix(spks_trace_drift_contra,fullfile(SaveDir,strcat(anim, '_drift_spks_contra.csv'))); 
% writematrix(spks_trace_drift_ipsi,fullfile(SaveDir,strcat(anim, '_drift_spks_ipsi.csv'))); 
% 
% writematrix(spks_trial_drift_contra,fullfile(SaveDir,strcat(anim, '_drift_spks_trial_contra.csv'))); 
% writematrix(spks_trial_drift_ipsi,fullfile(SaveDir,strcat(anim, '_drift_spks_trial_ipsi.csv'))); 


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


%% DRIFTING gratings- organize based on monocular/ binocular neurons 

%Select ALL cells, if they were responsive to either eye
%this is for the OD score calculation

% indices.drift.respcells=find(visresp_cells_total_drift>0); %indices of responsive cells  
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

%% FLASHING GRATINGS- now organize by orientation and spatial frequency 
%for visually responsive cells 
%Select ALL cells, if they were responsive to either eye
%get preferred orientation and spatial frequency tuning 

%%  OD score -DRIFTING GRATINGS
%citation: Cell-specific restoration of stimulus preference after monocular
%deprivation in the visual cortex. Rose et al., (2016), Science
%DOI:10.1126/science.aad3358

%----ANY RESPONSIVE NEURONS----FOR OD calculation 
%average by direction  

for i=1:num_visresp_drift
    for j=1:length(unique_ori_drift_contra)
        avg_ori_all_drift_contra(j,i)= squeeze(mean (ori_all_drift_contra(:,j,i),1));%all the contra responses
        
    end
    for k=1:length(unique_ori_drift_ipsi) %all the ipsilateral responses 
        avg_ori_all_drift_ipsi(k,i)= squeeze(mean (ori_all_drift_ipsi(:,k,i),1));
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
plotODscore(ODscore_drift, SaveDir,'Drifting'); 

%% direction and orientation tuning for monocular and binocular neurons 
%direction orientation preference for contralateral, ipsilateral eye 
%use Tan et al., 2021 Current Biology for orientation and spatial frequency
%preference calculation 

%----FOR ALL NEURONS REGARDLESS OF MONOCULAR/BINOCULAR 

%make indices for re-slicing matrices 
%indices will sf x ori x reps 
for i=1:length(unique_sf_drift_contra) %should be 2
    for j=1:length(unique_ori_drift_contra) %should be 16
        tmp_contra=intersect(indices.drift.contra(i).sfloc, indices.drift.contra(j).oriloc); 
        ind_mat_contra(i,j,1:length(tmp_contra))=tmp_contra;
    end
end

for i=1:length(unique_sf_drift_ipsi) %should be 2
    for j=1:length(unique_ori_drift_ipsi) %should be 16
        tmp_ipsi=intersect(indices.drift.ipsi(i).sfloc, indices.drift.ipsi(j).oriloc); 
        ind_mat_ipsi(i,j,1:length(tmp_ipsi))=tmp_ipsi;
    end
end

allresp_contra=zeros(2,16,num_visresp_drift);
allresp_ipsi=zeros(2,16,num_visresp_drift);

%index in contralateral
for i=1:num_visresp_drift %for any responsive cell  
    for j=1:length(unique_sf_drift_contra)
        for q=1:length(unique_ori_drift_contra)
            allresp_contra(j,q,i)= mean(dFoF_on_peak_drift_contra(indices.drift.respcells(i), ind_mat_contra(j,q,:)),2); %the contralateral responses     
        end
    end
end    

%index in ipsilateral
for i=1:num_visresp_drift %for any responsive cell  
    for j=1:length(unique_sf_drift_ipsi)
        for q=1:length(unique_ori_drift_ipsi)
            allresp_ipsi(j,q,i)= mean(dFoF_on_peak_drift_ipsi(indices.drift.respcells(i), ind_mat_ipsi(j,q,:)),2); %the contralateral responses     
        end
    end
end  

%direction/ orientation tuning and circular variance for contra/ ipsi
%responses 

%sf x ori x cells 
for i=1:num_visresp_drift 
    [ii,jj]=find(allresp_contra(:,:,i)==max(allresp_contra(:,:,i),[],'all')); 
    [kk,qq]=find(allresp_ipsi(:,:,i)==max(allresp_ipsi(:,:,i),[],'all'));
    %ii/kk is slice for max sf
    %jj/qq is for max ori 
    
    %take slice through ori responses at max sf response 
    resp_max_ori_drift_contra(:,i)=allresp_contra(ii,:,i); 
    resp_max_ori_drift_ipsi(:,i)=allresp_ipsi(kk,:,i);
end

    %direction tuning and circular variance for ocontralateral responses
    [dir_all_contra_est, cv_dir_all_contra]= getdirtuning(unique_ori_drift_contra, resp_max_ori_drift_contra); 
    %direction tuning and circular variance for ipsilateral responses
    [dir_all_ipsi_est, cv_dir_all_ipsi]= getdirtuning(unique_ori_drift_ipsi, resp_max_ori_drift_ipsi); 

    %orientation tuning and circular variance for ocontralateral responses
    [ori_all_contra_est, cv_ori_all_contra]= getorituning(unique_ori_drift_contra, resp_max_ori_drift_contra); 
    %orientation tuning and circular variance for ipsilateral responses
    [ori_all_ipsi_est, cv_ori_all_ipsi]= getorituning(unique_ori_drift_ipsi, resp_max_ori_drift_ipsi); 

% put in structure
for i=1:num_visresp_drift
    AllCellsDrift(i).pref_dir.contra=dir_all_contra_est(i);
    AllCellsDrift(i).pref_dir.ipsi=dir_all_ipsi_est(i);
    AllCellsDrift(i).cv_dir.contra=cv_dir_all_contra(i);
    AllCellsDrift(i).cv_dir.ipsi=cv_dir_all_ipsi(i);

    AllCellsDrift(i).pref_ori.contra=ori_all_contra_est(i);
    AllCellsDrift(i).pref_ori.ipsi=ori_all_ipsi_est(i);
    AllCellsDrift(i).cv_ori.contra=cv_ori_all_contra(i);
    AllCellsDrift(i).cv_ori.ipsi=cv_ori_all_ipsi(i);
end

%-----CONTRALATERAL MONOCULAR NEURONS-----for cells that are CONTRALATERAL responsive, find preferred orientation

resp_contra=zeros(2,16,numDrift_contra);
%index in contralateral
for i=1:numDrift_contra %for any responsive cell  
    for j=1:length(unique_sf_drift_contra)
        for q=1:length(unique_ori_drift_contra)
            resp_contra(j,q,i)= mean(dFoF_on_peak_drift_contra(indices.drift.contraresp(i), ind_mat_contra(j,q,:)),2); %the contralateral responses     
        end
    end
end    

%direction/ orientation tuning and circular variance for contra/ ipsi
%responses 

%sf x ori x cells 
for i=1:numDrift_contra 
    [ii,jj]=find(resp_contra(:,:,i)==max(resp_contra(:,:,i),[],'all')); 
   
    %ii/kk is slice for max sf
    %jj/qq is for max ori 
    
    %take slice through ori responses at max sf response 
    resp_max_ori_drift_justcontra(:,i)=resp_contra(ii,:,i); 
end


% 
% %average by SF and orientation 
% for i=1:numDrift_contra
%     for j=1:length(unique_sf_drift_contra)
%         avg_sf_drift_contra(j,i)=mean(sf_respcells_drift_contra(:,j,i)); 
%     end
%     for k=1:length (unique_ori_drift_contra)
%         avg_ori_drift_contra(k,i)=mean(ori_respcells_drift_contra(:,k,i));
%     end
% end

%DIRECTion tuning and circular variance 
[dir_contra_est, cv_dir_contra]= getdirtuning(unique_ori_drift_contra, resp_max_ori_drift_justcontra); 
%orientation tuning and circular variance
[ori_contra_est, cv_ori_contra]= getorituning(unique_ori_drift_contra, resp_max_ori_drift_justcontra);

%spatial frequency tuning

%---------IPSILATERAL MONOCULAR NEURONS------for cells that are ipsilateral responsive, find  preferred orientation

% if numDrift_ipsi>0
%     for i=1:numDrift_ipsi
%         for j=1:length(unique_sf_drift_ipsi)
%             avg_sf_drift_ipsi(j,i)=mean(sf_respcells_drift_ipsi(:,j,i)); %get trial averaged responses 
%         end
%         for k=1:length (unique_ori_drift_ipsi)
%             avg_ori_drift_ipsi(k,i)=mean(ori_respcells_drift_ipsi(:,k,i)); %get trial averaged responses 
%         end
%     end
% end

resp_ipsi=zeros(2,16,numDrift_ipsi);
%index in contralateral
for i=1:numDrift_ipsi %for any responsive cell  
    for j=1:length(unique_sf_drift_ipsi)
        for q=1:length(unique_ori_drift_ipsi)
            resp_ipsi(j,q,i)= mean(dFoF_on_peak_drift_ipsi(indices.drift.ipsiresp(i), ind_mat_ipsi(j,q,:)),2); %the contralateral responses     
        end
    end
end    

%direction/ orientation tuning and circular variance for contra/ ipsi
%responses 

%sf x ori x cells 
for i=1:numDrift_ipsi 
    [ii,jj]=find(resp_ipsi(:,:,i)==max(resp_ipsi(:,:,i),[],'all')); 
   
    %ii/kk is slice for max sf
    %jj/qq is for max ori 
    
    %take slice through ori responses at max sf response 
    resp_max_ori_drift_justipsi(:,i)=resp_ipsi(ii,:,i); 
end

if numDrift_ipsi>0
%direction tuning 
[dir_ipsi_est, cv_dir_ipsi]= getdirtuning(unique_ori_drift_ipsi, resp_max_ori_drift_justipsi); 

%direction tuning 
[ori_ipsi_est, cv_ori_ipsi]= getorituning(unique_ori_drift_ipsi, resp_max_ori_drift_justipsi); 
end


%------BINOCULAR NEURONS-----for cells that are binocular, find preferred orientation and spatial
%frequency for either eye separately 

% for i=1:numDrift_binoc
%     for j=1:length(unique_sf_drift_ipsi)
%         avg_sf_drift_binoc_contra(j,i)=mean(sf_respcells_drift_binoc_contra(:,j,i)); 
%         avg_sf_drift_binoc_ipsi(j,i)=mean(sf_respcells_drift_binoc_ipsi(:,j,i)); 
%     end
%     for k=1:length (unique_ori_drift_ipsi)
%         avg_ori_drift_binoc_contra(k,i)=mean(ori_respcells_drift_binoc_contra(:,k,i));
%         avg_ori_drift_binoc_ipsi(k,i)=mean(ori_respcells_drift_binoc_ipsi(:,k,i));
%     end
% end

binocresp_contra=zeros(2,16,numDrift_binoc);
binocresp_ipsi=zeros(2,16,numDrift_binoc);

%index in contralateral
for i=1:numDrift_binoc %for any responsive cell  
    for j=1:length(unique_sf_drift_contra)
        for q=1:length(unique_ori_drift_contra)
            binocresp_contra(j,q,i)= mean(dFoF_on_peak_drift_contra(indices.drift.binocresp(i), ind_mat_contra(j,q,:)),2); %the contralateral responses     
        end
    end
end    

%index in ipsilateral
for i=1:numDrift_binoc %for any responsive cell  
    for j=1:length(unique_sf_drift_ipsi)
        for q=1:length(unique_ori_drift_ipsi)
            binocresp_ipsi(j,q,i)= mean(dFoF_on_peak_drift_ipsi(indices.drift.binocresp(i), ind_mat_ipsi(j,q,:)),2); %the contralateral responses     
        end
    end
end  

%direction/ orientation tuning and circular variance for contra/ ipsi
%responses 

%sf x ori x cells 
for i=1:numDrift_binoc 
    [ii,jj]=find(binocresp_contra(:,:,i)==max(binocresp_contra(:,:,i),[],'all')); 
    [kk,qq]=find(binocresp_ipsi(:,:,i)==max(binocresp_ipsi(:,:,i),[],'all'));
    %ii/kk is slice for max sf
    %jj/qq is for max ori 
    
    %take slice through ori responses at max sf response 
    resp_max_ori_drift_binoc_contra(:,i)=binocresp_contra(ii,:,i); 
    resp_max_ori_drift_binoc_ipsi(:,i)=binocresp_ipsi(kk,:,i);
end

%contralateral eye responses
if numDrift_binoc~=0
    [dir_binoc_contra_est, cv_dir_binoc_contra]= getdirtuning(unique_ori_drift_contra, resp_max_ori_drift_binoc_contra); 
    [ori_binoc_contra_est, cv_ori_binoc_contra]= getorituning(unique_ori_drift_contra, resp_max_ori_drift_binoc_contra); 
%ipsilateral eye responses 
    [dir_binoc_ipsi_est, cv_dir_binoc_ipsi]= getdirtuning(unique_ori_drift_ipsi, resp_max_ori_drift_binoc_ipsi); 
    [ori_binoc_ipsi_est, cv_ori_binoc_ipsi]= getorituning(unique_ori_drift_ipsi, resp_max_ori_drift_binoc_ipsi);  

% dir_drift_pref=struct('contra_all', dir_all_contra_est, 'ipsi_all', dir_all_ipsi_est, 'contra', dir_contra_est, 'ipsi', dir_ipsi_est,...
%     'binoc_contra',dir_binoc_contra_est, 'binoc_ipsi', dir_binoc_ipsi_est,...
%     'cv_contra_all', cv_dir_all_contra, 'cv_ipsi_all', cv_dir_all_ipsi,...
%     'cv_contra', cv_dir_contra, 'cv_ipsi', cv_dir_ipsi, 'cv_binoc_contra', cv_dir_binoc_contra,...
%     'cv_binoc_ipsi', cv_dir_binoc_ipsi); 
% dir_drift_responses= struct('contra_all', avg_ori_all_drift_contra,...
%     'ipsi_all', avg_ori_all_drift_ipsi, 'contra', avg_ori_drift_contra, 'ipsi', avg_ori_drift_ipsi,...
%     'binoc_contra',avg_ori_drift_binoc_contra, 'binoc_ipsi', avg_ori_drift_binoc_ipsi); 
% 
% ori_drift_pref=struct('contra_all', ori_all_contra_est, 'ipsi_all', ori_all_ipsi_est, 'contra', ori_contra_est, 'ipsi', ori_ipsi_est,...
%     'binoc_contra',ori_binoc_contra_est, 'binoc_ipsi', ori_binoc_ipsi_est,...
%     'cv_contra_all', cv_ori_all_contra, 'cv_ipsi_all', cv_ori_all_ipsi,...
%     'cv_contra', cv_ori_contra, 'cv_ipsi', cv_ori_ipsi, 'cv_binoc_contra', cv_ori_binoc_contra,...
%     'cv_binoc_ipsi', cv_ori_binoc_ipsi); 
end 
%% store data so far in a structure 
%store orientation and sf matrices 

%only the cells that had significant visual responses above threshold 
%num_visresp
for i=1:numDrift_contra  %for CONTRALATERAL responsive neurons
    ContraCellDrift(i).ID=indices.drift.contraresp(i); %ID of monocular contralateral cell 
    ContraCellDrift(i).pref_dir= dir_contra_est(i); 
    ContraCellDrift(i).cv_dir= cv_dir_contra(i); 
    ContraCellDrift(i).pref_ori= ori_contra_est(i); 
    ContraCellDrift(i).cv_ori= cv_ori_contra(i); 
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

if numDrift_ipsi~=0
    for i=1:numDrift_ipsi  %for IPSILATERAL neurons
        IpsiCellDrift(i).ID=indices.drift.ipsiresp(i); %ID of monocular contralateral cell 
        IpsiCellDrift(i).pref_dir= dir_ipsi_est(i); 
        IpsiCellDrift(i).cv_dir= cv_dir_ipsi(i); 
        IpsiCellDrift(i).pref_ori= ori_ipsi_est(i); 
        IpsiCellDrift(i).cv_ori= cv_ori_ipsi(i); 
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
end 
if numDrift_binoc~=0
    for i=1:numDrift_binoc  %for BINOCULAR neurons
        BinocCellDrift(i).ID=indices.drift.binocresp(i); %ID of monocular contralateral cell 
        BinocCellDrift(i).pref_dir.contra= dir_binoc_contra_est(i); 
        BinocCellDrift(i).pref_dir.ipsi= dir_binoc_ipsi_est(i); 
        BinocCellDrift(i).cv_dir.contra= cv_dir_binoc_contra(i); 
        BinocCellDrift(i).cv_dir.ipsi= cv_dir_binoc_ipsi(i); 
        BinocCellDrift(i).pref_ori.contra= ori_binoc_contra_est(i); 
        BinocCellDrift(i).pref_ori.ipsi= ori_binoc_ipsi_est(i); 
        BinocCellDrift(i).cv_ori.contra= cv_ori_binoc_contra(i); 
        BinocCellDrift(i).cv_ori.ipsi= cv_ori_binoc_ipsi(i); 
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
end

% save this structure
if numDrift_binoc~=0 && numDrift_ipsi~=0
    SigCellsDrift=struct('ContraCell', ContraCellDrift, 'IpsiCell', IpsiCellDrift, 'AllCells', AllCellsDrift, 'BinocCell', BinocCellDrift); 
   
elseif numDrift_ipsi==0 && numDrift_binoc~=0
    SigCellsDrift=struct('ContraCell', ContraCellDrift, 'AllCells', AllCellsDrift, 'BinocCell', BinocCellDrift);     
elseif numDrift_ipsi==0  && numDrift_binoc==0
    SigCellsDrift=struct('ContraCell', ContraCellDrift, 'AllCells', AllCellsDrift); 
elseif numDrift_binoc==0 
    SigCellsDrift=struct('ContraCell', ContraCellDrift, 'IpsiCell', IpsiCellDrift, 'AllCells', AllCellsDrift); 
end

fsave=fullfile(SaveDir, strcat(anim, '_SigCellsDrift.mat')); 
save(fsave,'SigCellsDrift'); 

%% plot preferred orientation 
%a polar plot per cell with OSI 
%direction tuning 

%plot_ori_polar(spks); 

%% plot OSI, DSI, and spatial frequency preference 
% plotsftuning(SigCellsFlash); 
% plotOSI(spks); 
% plotDSI(SigCellsDrift); 
% plotdFoF_traces(SigCellsDrift,'drift'); 

for n=1:numCells %get location info for each cell ROI
	cell_stat{1,n}.xpix=Fall.stat{1,iscellind(n)}.xpix; %xpixels
    cell_stat{1,n}.ypix=Fall.stat{1,iscellind(n)}.ypix; %ypixels
    cell_stat{1,n}.xcirc=Fall.stat{1,iscellind(n)}.xcirc; %neuropil mask xpix
    cell_stat{1,n}.ycirc=Fall.stat{1,iscellind(n)}.ycirc; %neuropil mask ypix
end

%plotROIandtrace(Fall.ops,cell_stat,alldFoF_drift_contra,num_visresp_drift, indices)
meanImg=Fall.ops.meanImg; %mean image 

save(fullfile(SaveDir, strcat(anim, '_meanImage.mat')), 'meanImg'); %save mean image 
save(fullfile(SaveDir,strcat(anim, '_cellstats.mat')),'cell_stat'); %save cell stats


%% plot preferred orientation 

%a polar plot per cell with DSI 
%direction tuning 

%plot_dir_polar(SigCellsDrift); 

%% save structures 
% fsave1=fullfile(SaveDir1, strcat(anim, '_SigCellsFlash.mat')); 
% save(fsave1, 'SigCellsFlash');
save(fullfile(SaveDir, strcat(anim, '_indices.mat')), 'indices'); %save indices structure
save(fullfile(SaveDir, strcat(anim, '_dFoF.mat')), 'dFoF'); %save dFoF structure
% save(fullfile(SaveDir1, strcat(anim, '_SpksCellsFlash.mat')),'spks'); 

%%

clear all 
clear anim
clear SaveDir
clear SaveDir1
clear exp1
clear exp2
clear fov 
clear day
end


