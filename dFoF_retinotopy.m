function [dFoF_on_peak,dFoF_on, dFoF_off, bs, alldFoF] = dFoF_retinotopy(numCells, stim_frame,F_corr_cells, ca_delay)
%get dF/F for different time windows during stimulus presentation 
%inputs:
%   stim_frame: indices for stim on/off. structure containing 4 fields: drift_stim_on, drift_stim_off, 
%                flash_stim_on and flash_stim_off 
%   F_corr_cells: fluo traces for cells 
%   bsF: frame number over with to baseline 
%   ca_delay: delay kinetics of ca indicator in frames
%   numCells: the number of cells 

%outputs:
%   dFoF_on_peak: dF/F for the peak post-stimulus
%   dFoF_on: dF/F for the stim on duration
%   dFoF_off: dF/F for the stim off duration 
%   bs: the baseline dF/F- I don't really use this, but just in case 
%   alldFoF: the entire dF/F trace for each cell (could be useful for
%       presentations, etc. 

%Laura edited 2/5/23

%----First, do some magic in case there were errors in stimulus logging 
stim_on=stim_frame.stim_on; 
stim_off=stim_frame.stim_off;
if stim_on(1)==stim_off(1) %if they are simultaneous skip first one 
    stim_on=stim_on(2:end); 
    stim_off=stim_off(2:end); 
end 

if stim_on(1)<stim_off(1) %if stim on before stim off, 
    stim_on=stim_on(1:end); 
    stim_off=stim_off(1:end); 
elseif stim_on(1)>=stim_off(1) %if stim off before stim on this is a mistake  
    stim_on=stim_on(1:end); 
    stim_off=stim_off(2:end); %skip first one because sometimes it logs black screen 
end

if diff(stim_on(1:2))>40
    stim_on=stim_on(2:end); %skip first one
end
if diff(stim_off(1:2))>40
    stim_off=stim_off(2:end); 
end 

%stim_on=stim_on(1:end-1); 
%stim_off=stim_off(2:end); 

if length(stim_on)>504
    stim_on=stim_on(1:504); 
end 

%---now we can calculate stuff 
numTrials=size (stim_on); %number of trials 

%stim_on_int= ceil(max(stim_off(1:end)-stim_on(1:end))); %sometimes have different frame n between stim on/of 
trial_during_df =zeros(numCells, numTrials(1), 7); %pad matrix 

%stim_off_int=ceil(max(stim_on(2:end)-stim_off(1:end-1)))-1; %sometimes have different frame n duration of stim off- gray screen
trial_during_off_df= zeros(numCells, numTrials(1), 30); %pad matrix 

%correct for slow changes in signals from raw fluorescence, subtract 0.08%
%value from raw fluo 

corr_win= 225; %+/- 15s in frames
%baseline is the median of the entire fluorescence distribution of each cell


for i=1: numCells %for each cell 
%     trial_bs(i,:)= median(F_corr_cells(i, :)); %trial_bs is median of entire fluo distribution of each cell 
%      
%     alldFoF(i,:)= (F_corr_cells(i,:)-trial_bs(i,:))./trial_bs(i,:); %dFoF of the entire fluo distribution 
%     alldFoF_std(i)= std(alldFoF(i,:)); 
    
    %Rank Order Filtering method- Weiler et al., 2022 (current Biology);
    %Li et al., (Frontiers in Neural Circuits) 2018; Rose et al., 2016
    %(Science), Schoenfeld et al. 2021 (eNeuro)

    trial_bs(i,:) = (RankOrderFilter(F_corr_cells(i,1:stim_off(end)+30)', 500, 25))'; %baseline using a rank order filter of the 25% percentile (can change depending on data) 
    alldFoF(i,:)= (F_corr_cells(i,1:stim_off(end)+30)-trial_bs(i,:))./trial_bs(i,:); %dFoF of the entire fluo distribution, normalize to median during drifting gratings
    alldFoF_std(i)= std(alldFoF(i,:)); 


    for j=1: numTrials(1) %for each  trial
      %  if stim_on(j)<225
      %      bs_correction=mean(0.08*F_corr_cells(i,stim_on(j)-100: stim_on(j)+225)); 
      %  elseif (stim_on(j)>225) && (stim_on(j)<(length(F_corr_cells)-225))
      %      bs_correction=mean(0.08*F_corr_cells(i,stim_on(j)-225: stim_on(j)+225)); 
     %   else 
      %      bs_correction=mean (0.08*F_corr_cells(i, stim_on(j)-225: stim_on(j)));
      %  end 

       % if stim_off(j)>stim_on(j) %if stim_on index before stim_off index, no errors in TTL logging             
%              [~,tmp]=max(alldFoF(i, stim_on(j)+ca_delay: stim_on(j)+7+ca_delay)); 
%             trial_df(i,j)= mean(alldFoF(i, stim_on(j)+tmp:stim_on(j)+tmp+4)); 
%             trial_off_df(i,j)=mean (alldFoF(i, stim_off(j)+ca_delay: stim_off(j)+30)); %when stim is off 
            
             [~,tmp]=max(alldFoF(i, stim_on(j): stim_on(j)+7+ca_delay)); 
             trial_df(i,j)= mean(alldFoF(i, stim_on(j)+tmp:stim_on(j)+tmp+4)); %peak mean response during the stimulus, taking into account delay of indicator 
             trial_df(i,j)=(trial_df(i,j))-median(alldFoF(i,stim_on(j)-5:stim_on(j)-1)); %trial response= peak- baseline 
             
             trial_off_df(i,j)= median(alldFoF(i, stim_off(j)+15:stim_off(j)+30)); %when stim is off "NOISE" 
             trial_off_df(i,j)= (trial_off_df(i,j))-median(alldFoF(i,stim_on(j)-5:stim_on(j)-1)); %NOISE - baseline 
             trial_off_df_std(i,j)= std(alldFoF(i, stim_off(j)+25:stim_off(j)+30)); %std of response to when stimulus is off 

            for k=1:15              
                trial_during_df(i,j , k)= alldFoF(i, stim_on(j) + k); % during the stimulus        
            end 
            
            for q=1:30 
                trial_during_off_df(i,j , q)= alldFoF(i, stim_off(j)+q); % during stimulus off
            end


%         else %if there were errors in TTL logging, skip first in stim_off 
%             trial_df(i,j)= mean(F_corr_cells(i, stim_on(j)+ca_delay: stim_off(j+1)));  %during the stimulus
%             trial_during_df(j,:,i)= F_corr_cells(i, stim_on(j): stim_off(j+1)); % skip first stim off during the stimulus 
%            trial_off_df(i,j)=mean (F_corr_cells(stim_off(j+1)-1: stim_on(j+1)-1)); %when stim is off 
%         end 
    end 
end 

%trial_df(trial_df<0)=0; %take peak mean 
dFoF_on_peak= trial_df; %take peak mean 

%trial_during_df(trial_df<0)=0;
dFoF_on= trial_during_df; %(F-F0)/F0 for when stimulus is on 
dFoF_off= trial_during_off_df; %(F-F0)/F0 for when stimulus is off (aka NOISE)


bs=trial_bs; %baseline median 
alldFoF=alldFoF; %entire dFoF trace


end