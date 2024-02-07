function [spks_trial_contra, spks_trial_ipsi, spks_trace_contra, spks_trace_ipsi, numTrials_contra, numTrials_ipsi] = getspks_flash(spks_contra, stim_frame_contra, spks_ipsi, stim_frame_ipsi)

global numCells

%contralateral eye 
stim_on_contra=stim_frame_contra.stim_on;
stim_off_contra=stim_frame_contra.stim_off;

if stim_on_contra(161)==stim_off_contra(161) %if they are simultaneous skip first one 
    stim_on_contra=stim_on_contra(2:end); 
    stim_off_contra=stim_off_contra(2:end); 
end 

if stim_on_contra(161)<stim_off_contra(161) %if stim on before stim off, 
    stim_on_contra=stim_on_contra(161:end-1); 
    stim_off_contra=stim_off_contra(161:end-1); 
elseif stim_on_contra(161)>stim_off_contra(161) %if stim off before stim on this is a mistake  
    stim_on_contra=stim_on_contra(161:end-1); 
    stim_off_contra=stim_off_contra(162:end-1); %skip first one because sometimes it logs black screen 
end

%ok now check that last stim on is not random (sometimes from screen going
%blank, it is logged as a stim on 
if length(stim_on_contra)>length(stim_off_contra)
    stim_on_contra(end)=nan; 
    stim_on_contra=rmmissing(stim_on_contra); 
end 



numTrials_contra=length (stim_on_contra); %number of trials, should be ~3000

spks_trial_contra =zeros(numCells, numTrials_contra, 20); %pad matrix 

%contralateral   
for i=1: numCells %for each cell
    j=1; 
    while stim_on_contra(j) < length(spks_contra(i,:))-21 && stim_on_contra(j)<stim_on_contra(end)  %for each  trial
        spks_trial_contra(i,j,:)= spks_contra(i, stim_on_contra(j)-1: stim_on_contra(j)+18); %take into account the lag 
         j=j+1;                  
    end 
end 

spks_trace_contra=spks_contra(:,stim_on_contra(1):stim_off_contra(end)); 

%ipsilateral 
stim_on_ipsi=stim_frame_ipsi.stim_on;
stim_off_ipsi=stim_frame_ipsi.stim_off;

if stim_on_ipsi(161)==stim_off_ipsi(161) %if they are simultaneous skip first one 
    stim_on_ipsi=stim_on_ipsi(2:end); 
    stim_off_ipsi=stim_off_ipsi(2:end); 
end 

if stim_on_ipsi(161)<stim_off_ipsi(161) %if stim on before stim off, 
    stim_on_ipsi=stim_on_ipsi(161:end-1); 
    stim_off_ipsi=stim_off_ipsi(161:end); 
elseif stim_on_ipsi(161)>stim_off_ipsi(161) %if stim off before stim on this is a mistake  
    stim_on_ipsi=stim_on_ipsi(161:end-1); 
    stim_off_ipsi=stim_off_ipsi(162:end); %skip first one because sometimes it logs black screen 
end

%ok now check that last stim on is not random (sometimes from screen going
%blank, it is logged as a stim on 
if length(stim_on_ipsi)>length(stim_off_ipsi)
    stim_on_ipsi(end)=nan; 
    stim_on_ipsi=rmmissing(stim_on_ipsi); 
end 

numTrials_ipsi=size (stim_on_ipsi); %number of trials, should be ~3000
spks_trial_ipsi =zeros(numCells, numTrials_ipsi(1), 20); %pad matrix 
 %pad matrix 

%ipsilateral 
for i=1: numCells %for each cell  
    j=1; 
    while stim_on_ipsi(j) < length(spks_ipsi(i,:))-21 && stim_on_contra(j)<stim_on_contra(end) %for each  trial
        spks_trial_ipsi(i,j,:)= spks_ipsi(i, stim_on_ipsi(j)-1: stim_on_ipsi(j)+18); 
         j=j+1;                  
    end 
end 

spks_trace_ipsi=spks_ipsi(:,stim_on_ipsi(1):stim_off_ipsi(end)); 

end