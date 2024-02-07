function [varargout] = loadstimid(anim,day,varargin)
%reads in the stimulus parameters in order of presentation
%varagin contains the exp number. length is 1 if retinotopy experiment or 2
%if gratings experiment
%exp1 is contralateral eye and exp2 ipsilateral eye 

if length(varargin)==1 % if retinotopy experiment
    exp=varargin{1};
    AnalDir3= strcat('L:\Laura\ToAnalyze\', anim,'\', day,'\', exp,'\'); %change to real directory after trial
    if ~exist(AnalDir3,'dir') 
      mkdir (AnalDir3)
    end
    stim_csv=dir(fullfile (AnalDir3, '*.csv'));
    stim_table=readtable(fullfile(AnalDir3, stim_csv.name));
    varargout{1}=stim_table; 

elseif length(varargin)==2 %if gratings experiment
    exp1=varargin{1}; %contralateral eye
    exp2=varargin{2}; %ipsilateral eye 

    AnalDir3= strcat('L:\Laura\ToAnalyze\', anim,'\', day,'\', exp1,'\'); %contralateral
    if ~exist(AnalDir3,'dir') 
      mkdir (AnalDir3)
    end
    stim_csv_contra=dir(fullfile (AnalDir3, '*.csv'));
    stim_table_contra=readtable(fullfile(AnalDir3, stim_csv_contra.name));

     AnalDir4= strcat('L:\Laura\ToAnalyze\', anim,'\', day,'\', exp2,'\'); %ipsilateral eye 
    if ~exist(AnalDir4,'dir') 
      mkdir (AnalDir4)
    end
    stim_csv_ipsi=dir(fullfile (AnalDir4, '*.csv'));
    stim_table_ipsi=readtable(fullfile(AnalDir4, stim_csv_ipsi.name));
    
    varargout{1}= stim_table_contra; 
    varargout{2}=stim_table_ipsi; 

end


end