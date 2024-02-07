function plot_dir_polar(SigCellsDrift)
%citation Mazurek, Kager, Hooser, 2014. Robust quantification of
%orientation selectivity and direction selectivity. Frontiers in Neural
%Circuits 
%INPUTS:
%responses_ori: structure containing trial averaged responses to each
%orientation per cell 
%preferred_ori: structure containing preferred orientation per cell and cv
%(length of vector) = 1-cv (cirvar)
%unique_ori_conditions: all the orientations presented in this experiment 
%indices: indices for each cell (for plot naming purposes) 
%OUTPUT: a polar plot for each cell 

global SaveDir

for k=1:length(SigCellsDrift.AllCells(1).ori)
    oris(k)=SigCellsDrift.AllCells(1).ori(k).cond.contra; 
end
oris_rad=deg2rad(oris); 

%for all responsive cells. 
for i=1:length(SigCellsDrift.AllCells)
    peak_ori_all_contra(i)=SigCellsDrift.AllCells(i).pref_ori.contra; 
    cv_ori_all_contra(i)=SigCellsDrift.AllCells(i).cv_ori.contra; 
    peak_ori_all_ipsi(i)=SigCellsDrift.AllCells(i).pref_ori.ipsi; 
    cv_ori_all_ipsi(i)=SigCellsDrift.AllCells(i).cv_ori.ipsi; 
    for k=1:length(oris)
        responses_ori_all_contra(k,i)=SigCellsDrift.AllCells(i).ori(k).peak.contra;
        responses_ori_all_ipsi(k,i)=SigCellsDrift.AllCells(i).ori(k).peak.ipsi;
    end
end

%contralateral responses
responses_ori_all_contra_norm = (responses_ori_all_contra-min(responses_ori_all_ipsi,[],1)) ./ (max (responses_ori_all_contra,[],1)-min(responses_ori_all_ipsi,[],1)) ; %normalize to 1
AllcontraDir= strcat(SaveDir, 'Figures\Dir_tuning\all_contra\'); %make a new save director for the response type 

if iscell(AllcontraDir)
    AllcontraDir=AllcontraDir{1}; 
end
if ~exist(AllcontraDir)
    mkdir(AllcontraDir)
end

for h=1:length(SigCellsDrift.AllCells)
    f(h)=figure('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_all_contra_norm(:,h); responses_ori_all_contra_norm(1,h)],...
        'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
    hold on
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_all_contra(h));
    polarplot ([0 theta], [0 1-cv_ori_all_contra(h)], 'Color', 'black'); %length of vector is 1-cirvar
   
    rticklabels ({});
    hold off
    cellname=strcat('cellID_', num2str(SigCellsDrift.AllCells(h).ID));
   % saveas(f(h),fullfile(AllcontraDir,strcat('Dir_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(AllcontraDir,strcat('Dir_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(AllcontraDir,strcat('Dir_polarplot_', cellname)), 'tif');
end 

%ipsilateral responses
responses_ori_all_ipsi_norm = (responses_ori_all_ipsi-min(responses_ori_all_ipsi,[],1)) ./ (max (responses_ori_all_ipsi,[],1)-min(responses_ori_all_ipsi,[],1)); %normalize to max response 
AllipsiDir= strcat(SaveDir, 'Figures\Dir_tuning\all_ipsi\');

if iscell(AllipsiDir)
    AllipsiDir=AllipsiDir{1}; 
end
if ~exist(AllipsiDir)
    mkdir(AllipsiDir)
end

for h=1:length(SigCellsDrift.AllCells)
    f(h)=figure ('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_all_ipsi_norm(:,h); responses_ori_all_ipsi_norm(1,h)],...
        'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
    hold on
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_all_ipsi(h));
    len=cv_ori_all_ipsi(h);
    polarplot ([0 theta], [0 1-cv_ori_all_ipsi(h)], 'Color', 'black'); 
   
    rticklabels ({});
    hold off
    cellname=strcat('cellID_', num2str(SigCellsDrift.AllCells(h).ID));
  %  saveas(f(h),fullfile(AllipsiDir,strcat('Dir_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(AllipsiDir,strcat('Dir_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(AllipsiDir,strcat('Dir_polarplot_', cellname)), 'tif');
end 

%CONTRALATERAL MONOCULAR CELLS 
for i=1:length(SigCellsDrift.ContraCell)
    peak_ori_contra(i)=SigCellsDrift.ContraCell(i).pref_ori; 
    cv_ori_contra(i)=SigCellsDrift.ContraCell(i).cv_ori; 
    for k=1:length(oris)
        responses_ori_contra(k,i)=SigCellsDrift.ContraCell(i).ori(k).peak;
    end
end

responses_ori_contra_norm = (responses_ori_contra-min(responses_ori_contra,[],1)) ./ (max (responses_ori_contra,[],1)-min(responses_ori_contra,[],1)); %normalize to max response 
contraDir= strcat(SaveDir, 'Figures\Dir_tuning\mon_contra\');

if iscell(contraDir)
    contraDir=contraDir{1}; 
end
if ~exist(contraDir)
    mkdir(contraDir)
end

for h=1:length(SigCellsDrift.ContraCell)
    f(h)=figure ('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_contra_norm(:,h); responses_ori_contra_norm(1,h)],...
        'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
    hold on
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_contra(h));
    polarplot ([0 theta], [0 1-cv_ori_contra(h)], 'Color', 'black'); 
   
    rticklabels ({});
    hold off
    cellname=strcat('cellID_', num2str(SigCellsDrift.ContraCell(h).ID));
 %   saveas(f(h),fullfile(contraDir,strcat('Dir_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(contraDir,strcat('Dir_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(contraDir,strcat('Dir_polarplot_', cellname)), 'tif');
end 

%IPSILATERAL MONOCULAR CELLS 

for i=1:length(SigCellsDrift.IpsiCell)
    peak_ori_ipsi(i)=SigCellsDrift.IpsiCell(i).pref_ori; 
    cv_ori_ipsi(i)=SigCellsDrift.IpsiCell(i).cv_ori; 
    for k=1:length(oris)
        responses_ori_ipsi(k,i)=SigCellsDrift.IpsiCell(i).ori(k).peak;
    end
end

responses_ori_ipsi_norm (:,:)= (responses_ori_ipsi-min(responses_ori_ipsi,[],1)) ./ (max (responses_ori_ipsi,[],1)-min(responses_ori_ipsi,[],1)); %normalize to max response 
ipsiDir= strcat(SaveDir, 'Figures\Dir_tuning\mon_ipsi\');

if iscell(ipsiDir)
    ipsiDir=ipsiDir{1}; 
end
if ~exist(ipsiDir)
    mkdir(ipsiDir)
end

for h=1:length(SigCellsDrift.IpsiCell)
    f(h)=figure('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_ipsi_norm(:,h); responses_ori_ipsi_norm(1,h)],...
        'Color',[0 0.4470 0.7410], 'LineWidth', 1); %plot like this to close line 
    hold on
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_ipsi(h));
    polarplot ([0 theta], [0 1-cv_ori_ipsi(h)], 'Color', 'black'); 
    rticklabels ({}); 
    hold off
    cellname=strcat('cellID_', num2str(SigCellsDrift.IpsiCell(h).ID));
  %  saveas(f(h),fullfile(ipsiDir,strcat('Dir_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(ipsiDir,strcat('Dir_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(ipsiDir,strcat('Dir_polarplot_', cellname)), 'tif');
end 

%BINOCULAR CELLS- CONTRALATERAL RESPONSES
for i=1:length(SigCellsDrift.BinocCell)
    peak_ori_binoc_contra(i)=SigCellsDrift.BinocCell(i).pref_ori.contra; 
    cv_ori_binoc_contra(i)=SigCellsDrift.BinocCell(i).cv_ori.contra; 
    for k=1:length(oris)
        responses_ori_binoc_contra(k,i)=SigCellsDrift.BinocCell(i).ori(k).peak.contra;
    end
end

responses_ori_binoc_contra_norm (:,:)= (responses_ori_binoc_contra-max(responses_ori_binoc_contra, [],1)) ./ (max (responses_ori_binoc_contra,[],1)-min(responses_ori_binoc_contra,[],1)); %normalize to max response 
contraBinocDir= strcat(SaveDir, 'Figures\Dir_tuning\binoc_contra\');

if iscell(contraBinocDir)
    contraBinocDir=contraBinocDir{1}; 
end
if ~exist(contraBinocDir)
    mkdir(contraBinocDir)
end

for h=1:length(SigCellsDrift.BinocCell)
    f(h)=figure ('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_binoc_contra_norm(:,h); responses_ori_binoc_contra_norm(1,h)],...
        'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
    hold on 
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_binoc_contra(h));
    polarplot ([0 theta], [0 1-cv_ori_binoc_contra(h)], 'Color', 'black'); 
    rticklabels ({})
    hold off
    cellname=strcat('cellID_', num2str(SigCellsDrift.BinocCell(h).ID));
   % saveas(f(h),fullfile(contraBinocDir,strcat('Dir_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(contraBinocDir,strcat('Dir_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(contraBinocDir,strcat('Dir_polarplot_', cellname)), 'tif');
end 

%BINOCULAR CELLS- IPSILATERAL RESPONSES 
for i=1:length(SigCellsDrift.BinocCell)
    peak_ori_binoc_ipsi(i)=SigCellsDrift.BinocCell(i).pref_ori.ipsi; 
    cv_ori_binoc_ipsi(i)=SigCellsDrift.BinocCell(i).cv_ori.ipsi; 
     for k=1:length(oris)
        responses_ori_binoc_ipsi(k,i)=SigCellsDrift.BinocCell(i).ori(k).peak.ipsi;
    end
end

responses_ori_binoc_ipsi_norm (:,:)= (responses_ori_binoc_ipsi-min(responses_ori_binoc_ipsi,[],1)) ./ (max (responses_ori_binoc_ipsi,[],1)-min(responses_ori_binoc_ipsi,[],1)); %normalize to max response 
ipsiBinocDir= strcat(SaveDir, 'Figures\Dir_tuning\binoc_ipsi\');

if iscell(ipsiBinocDir)
    ipsiBinocDir=ipsiBinocDir{1}; 
end
if ~exist(ipsiBinocDir)
    mkdir(ipsiBinocDir)
end

for h=1:length(SigCellsDrift.BinocCell)
    f(h)=figure ('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_binoc_ipsi_norm(:,h); responses_ori_binoc_ipsi_norm(1,h)],...
        'Color',[0 0.4470 0.7410], 'LineWidth', 1); %plot like this to close line 
    hold on 
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_binoc_ipsi(h));
    polarplot ([0 theta], [0 1-cv_ori_binoc_ipsi(h)], 'Color', 'black'); 
    rticklabels ({})
    hold off
    cellname=strcat('cellID_', num2str(SigCellsDrift.BinocCell(h).ID));
%    saveas(f(h),fullfile(ipsiBinocDir,strcat('Dir_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(ipsiBinocDir,strcat('Dir_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(ipsiBinocDir,strcat('Dir_polarplot_', cellname)), 'tif');
end
end