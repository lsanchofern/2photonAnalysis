function [dFoF_on_peak, dFoF_on, dFoF_off, dFoF_noise, bs, alldFoF, stim_all, trial_bs, trial_off_df_std] = dFoF_drifting(stim_frame,F_corr_cells, ca_delay,numCells)
%get dF/F for different time windows during DRIFTING stimulus presentation 
%inputs:
%   stim_frame: indices for stim on/off. structure containing 2 fields: stim_on and stim_off
%   F_corr_cells: fluo traces for cells 
%   ca_delay: delay kinetics of ca indicator in frames

%outputs:
%   dFoF_on_peak: peak of dFoF response after stimulation
%   dFoF_on: trace during stimulus presentation 
%   dFoF_off: trace during stimulus off 
%   bs: baseline, background fluorescence used to calculate dFoF 
%   alldFoF: the entire fluorescence trace for each cell 
% stim_all: corrected stim frame structure, for consequent use in getspks

%Laura edited 12/7/22 

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

if diff(stim_on(1:2))<85
    stim_on=stim_on(2:end); %skip first one
end
if diff(stim_off(1:2))<85
    stim_off=stim_off(2:end); 
end 


%drifting
stim_all=struct('stim_on', stim_on,'stim_off',stim_off); 

stim_on=stim_on(1:160); 
stim_off=stim_off(1:160); 

numTrials=length (stim_on); %number of trials 

%stim_on=stim_on(1:end-1); 
%stim_off=stim_off(2:end); 

stim_on_int= ceil(max(stim_off(1:end)-stim_on(1:end))); %sometimes have different frame n between stim on/of 
trial_during_df =zeros(numCells, numTrials(1), stim_on_int); %pad matrix 

stim_off_int=ceil(max(stim_on(2:end)-stim_off(1:end-1))); %sometimes have different frame n duration of stim off- gray screen
trial_during_off_df= zeros(numCells, numTrials(1), stim_off_int); %pad matrix 

%correct for slow changes in signals from raw fluorescence, subtract 0.08%
%value from raw fluo 

corr_win= 225; %+/- 15s in frames
%baseline is the median of the entire fluorescence distribution of each cell


for i=1: numCells %for each cell 
    
      %Rank Order Filtering method- Weiler et al., 2022 (current Biology);
    %Li et al., (Frontiers in Neural Circuits) 2018; Rose et al., 2016
    %(Science), Schoenfeld et al. 2021 (eNeuro)

   % trial_bs(i,:)= median(F_corr_cells(i, 1:stim_off(end)+62)); %trial_bs is median of entire fluo distribution of each cell for drifting gratings      
    trial_bs(i,:) = (RankOrderFilter(F_corr_cells(i,1:stim_off(end)+62)', 300, 25))'; %baseline using a rank order filter of the 25% percentile   
    alldFoF(i,:)= (F_corr_cells(i,1:stim_off(end)+62)-trial_bs(i,:))./trial_bs(i,:); %dFoF of the entire fluo distribution, normalize to median during drifting gratings
    alldFoF_std(i)= std(alldFoF(i,:)); 

    for j=1: numTrials %for each  trial
     
             [~,tmp]=max(alldFoF(i, stim_on(j)+ca_delay: stim_on(j)+stim_on_int+ca_delay)); 
             trial_df(i,j)= mean(alldFoF(i, stim_on(j)+tmp:stim_on(j)+tmp+4)); %peak mean response during the stimulus, taking into account delay of indicator 
             trial_df(i,j)=(trial_df(i,j))-mean(alldFoF(i,stim_on(j)-16:stim_on(j))); %trial response= peak- baseline 
             
             trial_off_df(i,j)= mean(alldFoF(i, stim_off(j)+50:stim_off(j)+60)); %when stim is off "NOISE" 
             % trial_off_df(i,j)= (trial_off_df(i,j))-mean(alldFoF(i,stim_on(j)-16:stim_on(j))); %NOISE - baseline 
             trial_off_df_std(i,j)= std(alldFoF(i, stim_off(j)+50:stim_off(j)+60)); %std of response to when stimulus is off 

             % trial_baseline(i,j)= mean(F_corr_cells(i,stim_on(j)-16:stim_on(j)-1)); %baseline 
             % trial_baseline_bs(i,j,:)= (F_corr_cells(i,stim_on(j)-16:stim_on(j)-1))./trial_baseline(i,j); 
             % trial_baseline_std(i,j)=std((F_corr_cells(i,stim_on(j)-16:stim_on(j)-1))./trial_baseline(i,j)); 
             % trial_off_df(i,j)=(F_corr_cells(i,stim_off(j)+55))./(trial_baseline(i,j)); %dFoF noise for baseline 
             % [~,tmp]=max(F_corr_cells(i, stim_on(j): stim_on(j)+stim_on_int+ca_delay));
             % trial_df(i,j)= (mean(F_corr_cells(i,stim_on(j)+(tmp-2): stim_on(j)+(tmp+4))))./trial_baseline(i,j); 
             

            for k=1:stim_on_int             
                 trial_during_df(i,j,k)= alldFoF(i, stim_on(j) + k); % during the stimulus        
%                    trial_during_df(i,j,k)= (F_corr_cells(i, stim_on(j) + k))./trial_baseline(i,j); % during the stimulus 
            end 
          
            for q=1:(stim_off_int-2) 
                trial_during_off_df(i,j , q)= alldFoF(i, stim_off(j)+q); % during stimulus off
                  
            end
    end 
end 
%trial_df(trial_df<0)=0; %take peak mean 
dFoF_on_peak= trial_df; %take peak mean 

%trial_during_df(trial_df<0)=0;
dFoF_on= trial_during_df; %(F-F0)/F0 for when stimulus is on 
dFoF_noise= trial_off_df; %(F-F0)/F0 for during NOISE 
dFoF_off=trial_during_off_df; %(F-F0)/F0 when stimulus is off 


bs=trial_bs; %baseline median 
alldFoF=alldFoF; %entire dFoF trace


end