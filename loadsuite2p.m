function [Fall] = loadsuite2p(anim,day,varargin)
%load suite2p data
%suite2p generates a .mat file called "Fall" with separate variables
%these variables are F, Fneu, iscell, ops, redcell, spks, stat
%each row is a separate cell

if length(varargin)==1 %if retinotopy experiment 
    exp=varargin{1}; 
    AnalDir1= strcat('L:\Laura\ToAnalyze\', anim,'\', day, '\',exp,'\'); 
    if ~exist(AnalDir1,'dir') 
         mkdir (AnalDir1)
    end
else %if not retinotopy experiment 
     AnalDir1= strcat('L:\Laura\ToAnalyze\', anim,'\', day, '\'); 
    if ~exist(AnalDir1,'dir') 
         mkdir (AnalDir1)
    end
end 


%import Fall files from that directory into the workspace 
Fall= load (fullfile (AnalDir1, 'Fall.mat')); 


end