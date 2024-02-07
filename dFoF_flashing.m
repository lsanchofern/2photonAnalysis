function [dFoF_on_peak, dFoF_on, bs, alldFoF, numTrials] = dFoF_flashing(stim_frame,F_corr_cells, ca_delay, numCells)
%get dF/F for different time windows during FLASHING stimulus presentation 
%inputs:
%   stim_frame: indices for stim on/off. structure containing 2 fields: stim_on and stim_off
%   F_corr_cells: fluo traces for cells 
%   ca_delay: delay kinetics of ca indicator in frames

%outputs:
%   dFoF_on_peak: peak of dFoF response after stimulation
%   dFoF_on: trace during stimulus presentation 
%   bs: baseline, background fluorescence used to calculate dFoF 
%   alldFoF: the entire fluorescence trace for each cell 

stim_on=stim_frame.stim_on; 
stim_off=stim_frame.stim_off;

if stim_on(161)<stim_off(161) %if stim on before stim off, 
    stim_on=stim_on(161:end-1); 
    stim_off=stim_off(161:end); 
elseif stim_on(161)>stim_off(161) %if stim off before stim on this is a mistake  
    stim_on=stim_on(161:end); 
    stim_off=stim_off(162:end); %skip first one because sometimes it logs black screen 
end


numTrials=size (stim_on); %number of trials, should be ~3000

stim_on_int= ceil(max(stim_off(1:end)-stim_on(1:end-1))); %sometimes have different frame n between stim on/of 
trial_during_df =zeros(numCells, numTrials(1), stim_on_int); %pad matrix 

%correct for slow changes in signals from raw fluorescence, subtract 0.08%
%value from raw fluo 

corr_win= 225; %+/- 15s in frames
%baseline is the median of the entire fluorescence distribution of each cell


for i=1: numCells %for each cell 
    trial_bs(i,:)= median(F_corr_cells(i, stim_on(1):end)); %trial_bs is median of entire fluo distribution of each cell for flashing gratings  
    alldFoF(i,:)= (F_corr_cells(i,1:end)-trial_bs(i,:))/trial_bs(i,:); %dFoF of the entire fluo distribution, normalize to median during flashing gratings 
    alldFoF_std(i)= std(alldFoF(i,:)); 
    

    for j=1: numTrials(1) %for each  trial
      %  if stim_on(j)<225
      %      bs_correction=mean(0.08*F_corr_cells(i,stim_on(j)-100: stim_on(j)+225)); 
      %  elseif (stim_on(j)>225) && (stim_on(j)<(length(F_corr_cells)-225))
      %      bs_correction=mean(0.08*F_corr_cells(i,stim_on(j)-225: stim_on(j)+225)); 
     %   else 
      %      bs_correction=mean (0.08*F_corr_cells(i, stim_on(j)-225: stim_on(j)));
      %  end             
        trial_df(i,j)= mean(alldFoF(i, stim_on(j)+4: stim_on(j)+8)); %peak mean response during the stimulus, taking into account delay of indicator 
            
            for k=1:stim_on_int+4              
                trial_during_df(i,j , k)= alldFoF(i, stim_on(j) + k); % during the stimulus        
            end 
          
    end 
end 

dFoF_on_peak= trial_df; %take peak mean 
dFoF_on= trial_during_df; %(F-F0)/F0 for when stimulus is on 
bs=trial_bs; %baseline median 
alldFoF=alldFoF; %entire dFoF trace


end