function [spks_trial, spks_trace, numTrials] = getspks_drift(spks, stim_frame)

global numCells

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

numTrials=length (stim_on); %number of trials, should be ~3000

spks_trial=zeros(numCells, numTrials, 30); %pad matrix 

%contralateral   
for i=1: numCells %for each cell
    j=1; 
    while stim_on(j) < length(spks(i,:))-21 && stim_on(j)<stim_on(end)  %for each  trial
        spks_trial(i,j,:)= spks(i, stim_on(j)+7: stim_on(j)+36); 
         j=j+1;                  
    end 
end 

spks_trace=spks(:,stim_on(1):stim_off(end)); 

end