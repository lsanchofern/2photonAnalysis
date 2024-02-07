function  analyze_retinotopyexp(anim,day,fov,exp)
%calculate the response properties of every cell 

%requires the following files:
   % 1. Scanbox .mat file that contains the TTL pulse frame numbers for
   % stim on/off
   % 2. Suite2p folder that contains fluorescence traces for each ROI and
   % deconvolved spiking
   % 3. CSV file contain specific sequence of stimuli and their parameters,
   % ori, sf, and sp-> this file is exported by Psychopy upon completion of
   % experiment

%which indicator
indicator='f'; %gCamp6f 

%baseline frame window
bsF= 2; %number of frames for baseline 

%if 1, then this is a retinotopy experiment 
analyze_retinotopy=1; 

%% load data 

%set SaveDir 
global SaveDir
%animal ID, should be in form in "L001" (aka with an initial and then a
%number)
global anim 

SaveDir = ['L:\Laura\AnalyzedData\calcium\Retinotopy','\', anim, '\', day,'\', exp,'\'];

if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

%load the sbx .mat file with the stimulus frame on/off index
[stim_info] = loadsbxmat(anim,day, fov, exp); 

%load the suite2p data 
[Fall] = loadsuite2p(anim,day, exp); 

%load the stimulus information (stim parameters), loaded as a table
[stim_table] = loadstimid(anim,day, exp); %for retinotopy experiment 

%get stim on/off indices
[stim_frame] = trialinfo_retinotopy(stim_info); %for retinotopy experiment 

%% extract imaging data
%neuropil correction factor 
corr_factor=.7; %according to suite2p documentation, we can start with this
ca_delay=7; %ca indicator delay in frames, 7 frames ~= 0.5s 

%get the indices of cells, don't do this analysis for non-cell ROIs 
iscellind= find (Fall.iscell(:,1)==1); %indices of cells 

for i=1:length(iscellind)
    if max(Fall.F(i,:))-min(Fall.F(i,:))==0
        iscellind(i)=0; %remove any traces that are zero
    end
end 
iscellind(iscellind==0)=[]; 

numCells=length(iscellind); % count all 'iscell'= total ROIs that are cells
cells.total.GCaMP=numCells; %make structure with cell information 

%neuropil correction of F
F_corr_cells= Fall.F(iscellind,:)-(corr_factor*Fall.Fneu(iscellind,:)); %extract info only for cells 

%normalize fluorescences (you don't want negative fluorescence), make min 0
F_corr_cells=F_corr_cells-min(F_corr_cells, [], 2); 
%F_corr_cells=F_corr_cells(:,1:16000);
Fneu_cell=Fall.Fneu(iscellind,:); %neuropil for cells 
F_cell=Fall.F(iscellind,:); %F raw for cells 


%% get unique trial   information

%depends on type of experiment, if retinotopy experiment then the others
%are set to 0

if analyze_retinotopy==1
    [unique_trial,checkermat] = uniquetrial_retinotopy(stim_table);
    unique_trialnum= size (unique_trial,1); %number of unique  trial conditions
    unique_azimuth= unique (unique_trial(:,1)); % unique azimuth
    unique_altitude= unique (unique_trial(:,2)); % unique altitude 
end

numstd=2; %thresholding for response amplitude
 

%% get dF/F for retinotopy

%if retinotopic experiment 

[dFoF_on_peak,dFoF_on, dFoF_off, bs, alldFoF] = dFoF_retinotopy(numCells, stim_frame,F_corr_cells, ca_delay);
%use stim_frame to index into fluo trace 


%indices for trials will also become indices for df/f trace since we used
%trial onset to make this file 


for j=1:unique_trialnum % for every unique trial , one field in index 
    ind(:,j)= ismember(checkermat, unique_trial (j,:), 'rows'); % where is jth unique trial in the whole trial sequence? 
    indices(j).trial_rep= find(ind(:,j)==1); % index of where j trial is in entire trial sequence 
    indices(j).pos= checkermat(j,:); 

    %now organize for azimuth 
    for l= 1:length(unique_azimuth)
        indices(l).azimuthloc= find (checkermat(:,1)==unique_azimuth(l)); %index to find this trial in  
        indices(l).azimuth=unique_azimuth(l); %what is the actual orientation value
    end 
    % now organize for altitude
    for m= 1:length(unique_altitude)
        indices(m).altitudeloc= find (checkermat(:,2)==unique_altitude(m)); %index to find this trial in  
        indices(m).altitude=unique_altitude(m); %what is the actual sf value
    end 

    % now index into dfoF file to make a new structure for each cell ROI  
    for k=1: numCells %for every cell, per each unique trial (a row in dfof trace)
        dFoF.conds(j).cells(k).trial_num=indices(j).trial_rep; %unique trial ID 
        dFoF.conds(j).cells(k).peak=dFoF_on_peak(k, indices(j).trial_rep); 
        dFoF.conds(j).cells(k).mean_peak=mean(dFoF_on_peak(k, indices(j).trial_rep));
        dFoF.conds(j).cells(k).var=var(dFoF_on(k, indices(j).trial_rep), 0); 
        dFoF.conds(j).cells(k).traces=(squeeze(dFoF_on(k, indices(j).trial_rep,:)))'; 
        dFoF.conds(j).cells(k).avg_trace=squeeze(mean(dFoF_on(k, indices(j).trial_rep,:),3));
        dFoF.conds(j).cells(k).std_trace=std(dFoF_on(k, indices(j).trial_rep));

        dFoF.conds(j).cells(k).off_mean=squeeze(mean(dFoF_off(k, indices(j).trial_rep,:),3)); 
        dFoF.conds(j).cells(k).off_traces=(squeeze(dFoF_off(k, indices(j).trial_rep,:)))';
        dFoF.conds(j).cells(k).off_std=std(dFoF_off(k, indices(j).trial_rep)); 
       %dFoF_conds(j).cells(k).std_trace=std(abs(dFoF_during(k, indices(j).drift_trial_rep),2));
    end 
end

%% organize condition for test of visually responsivity for retinotopy 
  
% for i=1:numCells
%     median_dFoF(i)=median(alldFoF(i,:),'all');     
% end 
% 
% for i=1:numCells
%     indices(i).std = find(alldFoF(i,:)<0); 
%     std_lowerdFoF(i)= std(alldFoF(i,indices(i).std));
% end

% std_lowerdFoF= zeros(1, numCells); 


for qq=1:unique_trialnum
    for kk=1:numCells
        stimconds(qq, 1:(length(dFoF.conds(qq).cells(kk).peak)), kk)= cat(1,dFoF.conds(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
        stimconds_trials(qq,1:(length(dFoF.conds(qq).cells(kk).trial_num)), kk)= cat(1,dFoF.conds(qq).cells(kk).trial_num); 
        stimconds_off(qq, 1:(length(dFoF.conds(qq).cells(kk).off_mean)), kk)= cat(1,dFoF.conds(qq).cells(kk).off_mean); %each slice is a cell, each row a unique trial and column a rep of that trial         
        for i=1:8 %number of reps 
            wspval(kk,qq,i)=ranksum(dFoF.conds(qq).cells(kk).traces(:,i),dFoF.conds(qq).cells(kk).off_traces(:,i)); 
        end
    end

end

%calculate cell reliability per unique trial 



%adjust for multiple comparisons for each trial 
% for i=1:numCells 
%     for qq=1:unique_trialnum
%         [h(:,qq,i),crit_p,adj_ci_cvrg,adj_p]=fdr_bh(wspval(i,qq,:),0.05,'pdep','yes');
%     end 
% end 

%stimconds matrix will be 45(unique trials)x 8(reps)x n(cells) 

stimconds(stimconds==0)=nan;
stimconds= permute(stimconds, [2 1 3]);% make column-wise so reps are in the same column

stimconds_off(stimconds_off==0)=nan;
stimconds_off= permute(stimconds_off, [2 1 3]);% make column-wise so reps are in the same column

wspval=permute(wspval,[2 3 1]); %make so that it's the same as stimconds

%make reps x unique trial x cells number 

% %Calculate reliability metrics: 
% for j=1:unique_trialnum
%     for q=1:numCells
%         response_CV(j,q)= std(stimconds(:,j,q)) ./ mean(stimconds(:,j,q)); %response reliability metric for each stimulus condition 
%     end
% end

%% significant visual response? 

%threshold as 2 standard deviations above the noise mean for all trials for
%a single cell 
dFoF_off(isnan(dFoF_off))=0;

%threshold_active=mean(dFoF_off,2)+2.*(std(dFoF_off,0,2));
threshold_active=3.*std(dFoF_off,0,2); 

%test stim on vs. threshold 
%check to see if visual response crosses threshold 
visresp_cells=zeros(unique_trialnum, numCells); 
% for q=1:numCells
%     for j=1:unique_trialnum % done across reps and stim on vs. stim off        
%         if length(find(stimconds(:,j,q)>= threshold_active(q)))>1 
%             visresp_cells(j,q)=1; %matrix of vis resp cells, 0/1
%         end
%     end
% end

% for q=1:numCells
%     for j=1:unique_trialnum
%         mean_stimconds(j,q)= squeeze(mean(stimconds(:,j,q))); 
%         mean_stimconds_off(j,q)=squeeze(mean(stimconds_off(:,j,q)));       
%         if length(find(mean_stimconds(j,q)>= threshold_active(q)))>=1
%             visresp_cells(j,q)=1; %matrix of vis resp cells, 0/1
%         end
%     end
% end

%response significance depending on p value 
for q=1:numCells
    for j=1:unique_trialnum
        if length(find(wspval(j,:,q)<0.01))>=2 % correct for multiple comparison- number of unique stimuli 
            visresp_cells(j,q)=1; 
        end 
    end
end


%check to see in how many cells there is a threshold cross 
visresp_cells_total=zeros(1,numCells); 
for q=1:numCells
    if length(find(visresp_cells(:,q)==1))>=1
        visresp_cells_total(q)=1; 
    end
end

%

%% plot percent visually responsive 

num_visresp=length(find(visresp_cells_total==1));
percent_visresp=num_visresp/numCells; 

plotresponsivecells(num_visresp,numCells,'Retinotopy'); 

%% put data in a structure 

%allcells.response_CV= response_CV; %store response CV 
allcells.uniquetrials= unique_trial; %store unique trials 
for n=1:unique_trialnum
    allcells(n).uniquetrials_ID=indices(n).trial_rep; 
end
%store unique trials indices

allcells(1).uniqueazimuth= unique_azimuth; %store unique azimuth
allcells(1).uniquealititude=unique_altitude; %store unique altitude 

for n=1:unique_azimuth
    allcells(n).uniqueazimuth_ID=indices(n).azimuthloc; %store indices 
end
for n=1:unique_altitude
    allcells(n).uniquealtitude_ID=indices(n).altitudeloc; %store indices 
end


%save structures in Retinotopy folder for animal 



%% plotting retinotopy for all cells that had responses for a particular trial 
%if a responsive cell, then look at retinotopy  
%order by azimuth 
%use indices(x).azimuthloc and indices(x).azimuth to index into dFoF.conds(index) file for
%each cell, then order by altitude 

%find unique azimuth and altitude trials 
for kk=1:numCells
        for j=1:length(unique_azimuth)
            dFoF.azimuth(j).cells(kk).peak= squeeze(mean(dFoF_on(kk, indices(j).azimuthloc,:),3)); %all the peaks for the reps 
        end
        for j=1:length(unique_altitude)
            dFoF.altitude(j).cells(kk).peak= squeeze(mean(dFoF_on(kk, indices(j).altitudeloc,:),3));
        end
end

%organize by azimuth 
for qq=1:length(unique_azimuth)
    for kk=1:numCells
        resp_azimuth(qq, 1:(length(dFoF.azimuth(qq).cells(kk).peak)), kk)= cat(1,dFoF.azimuth(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
    end
end

%organize by altitude 
for qq=1:length(unique_altitude)
    for kk=1:numCells
        resp_altitude(qq, 1:(length(dFoF.altitude(qq).cells(kk).peak)), kk)= cat(1,dFoF.altitude(qq).cells(kk).peak); %each slice is a cell, each row a unique trial and column a rep of that trial  
    end
end

%rearrange so that reps are in a column, each slice is a cell, and each
%trial is a row 
resp_azimuth(resp_azimuth==0)=nan;
resp_azimuth= permute(resp_azimuth, [2 1 3]);

azimuth_trialnum=length(dFoF.azimuth(1).cells(1).peak); 
azimuth_respcells=zeros(azimuth_trialnum, length(unique_azimuth), num_visresp); 

resp_altitude(resp_altitude==0)=nan;
resp_altitude= permute(resp_altitude, [2 1 3]);

altitude_trialnum=length(dFoF.altitude(1).cells(1).peak); 
altitude_respcells=zeros(altitude_trialnum, length(unique_altitude), num_visresp); 


%select only responsive cells 
%indices 
indices(1).respcells = find(visresp_cells_total==1);

for i=1:num_visresp
    azimuth_respcells(:,:,i)= resp_azimuth(:,:,indices(1).respcells(i));
    altitude_respcells(:,:,i)= resp_altitude(:,:,indices(1).respcells(i));
end

%% test for retinotopy 

%peak responses as a measure of position- azimuth/ altitude 
%average by azimuth, trials 
avg_azimuth_responses= zeros(length(unique_azimuth),num_visresp);
for i=1:num_visresp
    for j=1:length(unique_azimuth)
        avg_azimuth_responses(j,i)= mean(azimuth_respcells(:,j,i)); 
    end 
end

%what are the peak responses 
for i=1:num_visresp
    [peak_azimuth_responses(i),indices(i).azimuth_peak]=max(avg_azimuth_responses(:,i)); 

end
for i=1:num_visresp
    azimuth_peak(i)=unique_azimuth(indices(i).azimuth_peak); 
end 

%average by altitude, trials 
avg_altitude_responses= zeros(length(unique_altitude),num_visresp);
for i=1:num_visresp
    for j=1:length(unique_altitude)
        avg_altitude_responses(j,i)= mean(altitude_respcells(:,j,i)); 
    end 
end

%what was the peak response and which was it? 
for i=1:num_visresp
    [peak_altitude_responses(i),indices(i).altitude_peak]=max(avg_altitude_responses(:,i)); 
end
for i=1:num_visresp
    altitude_peak(i)=unique_altitude(indices(i).altitude_peak); 
end

%convert to degrees
azimuth_peak_degrees=azimuth_peak;
altitude_peak_degrees=altitude_peak;

%% store data in a structure for significant cells 

SigCells.ID=  indices(1).respcells; %save IDs of significant cells

for i=1:num_visresp 
    SigCells(i).azimuth=unique_azimuth; 
    SigCells(i).azimuthResponses=avg_azimuth_responses(:,i); 
    SigCells(i).azimuth_ID=indices(i).azimuthloc; 
    SigCells(i).Azimuthpref=azimuth_peak_degrees; 
    SigCells(i).altitude=unique_altitude; 
    SigCells(i).altitudeResponses=avg_altitude_responses(:,i); 
    SigCells(i).altitude_ID=indices(i).altitudeloc; 
    SigCells(i).Altitudepref=altitude_peak_degrees;
end

%save it 
fsave=fullfile(SaveDir, strcat(anim, '_SigCellsRetinotopy.mat')); 
save(fsave,'SigCells'); 

%% get cell ROI positions for retinotopy 

for n=1:numCells %get location info for each cell ROI
	cell_stat{1,n}.xpix=Fall.stat{1,iscellind(n)}.xpix; %xpixels
    cell_stat{1,n}.ypix=Fall.stat{1,iscellind(n)}.ypix; %ypixels
    cell_stat{1,n}.xcirc=Fall.stat{1,iscellind(n)}.xcirc; %neuropil mask xpix
    cell_stat{1,n}.ycirc=Fall.stat{1,iscellind(n)}.ycirc; %neuropil mask ypix
end

%% Preferred retinotopy 

%color code cells according to preferred retinotopy and plot them on the
%image of the cells 
plot_im_retinotopy(Fall.ops, cell_stat, num_visresp, indices, azimuth_peak_degrees, altitude_peak_degrees); 

%make histograms for preferred position

f3=figure ('Name', 'Distribution of Responses', 'NumberTitle', 'off'); 
tiledlayout(1,2); 

nexttile
histogram(azimuth_peak_degrees,'NumBins',9); 
title('Horizontal Retinotopy')

nexttile
histogram(altitude_peak_degrees,'NumBins',7); 
title('Vertical Retinotopy')

saveas(f3, fullfile(SaveDir, strcat(anim, '_Histogram')), 'pdf'); 
saveas(f3, fullfile(SaveDir, strcat(anim, '_Histogram')), 'tif'); 
saveas(f3, fullfile(SaveDir, strcat(anim, '_Histogram')), 'fig'); 

%make histograms for all positions, magnitudes 


%% end of retinotopy experiment 

%Save structures
save(fullfile(SaveDir, strcat(anim, '_indices.mat')), 'indices'); %save indices structure
save(fullfile(SaveDir, strcat(anim, '_dFoF.mat')), 'dFoF'); %save dFoF structure
save(fullfile(SaveDir, strcat(anim, '_allcells.mat')), 'allcells'); %save allcells structures
save(fullfile(SaveDir, strcat(anim, '_SigCells.mat')), 'allcells');
save(fullfile(SaveDir, strcat(anim, '_cellstat.mat')), 'cell_stat');

clear anim
clear SaveDir

clear all 
end
