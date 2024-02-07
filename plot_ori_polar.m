function plot_ori_polar(spks)
%INPUTS:
%spks: structure containing trial averaged responses to each
%orientation per cell 
%preferred_ori: structure containing preferred orientation per cell and cv
%(length of vector) 
%unique_ori_conditions: all the orientations presented in this experiment 
%indices: indices for each cell (for plot naming purposes) 
%OUTPUT: a polar plot for each cell 

oris=(0:10:170)'; %orientations presented 
oris=180+oris; 

global SaveDir1

oris_rad=deg2rad(oris); 

%For all responsive cells, regardless of "binocularity" or not 
for i=1:length(spks)
    peak_ori_all_contra(i)=spks.cells(i).contra.pref_ori; 
    cv_ori_all_contra(i)=spks.cells(i).contra.cv; 
    peak_ori_all_ipsi(i)=spks.cells(i).ipsi.pref_ori; 
    cv_ori_all_ipsi(i)=spks.cells(i).ipsi.cv; 
    for k=1:length(oris)
        responses_ori_all_contra(k,i)=SigCellsFlash.AllCells(i).ori(k).peak.contra;
        responses_ori_all_ipsi(k,i)=SigCellsFlash.AllCells(i).ori(k).peak.ipsi;
    end
end

%contralateral responses
%min max normalization 
responses_ori_all_contra_norm = (responses_ori_all_contra-max(responses_ori_all_contra,[],1)) ./ (max (responses_ori_all_contra,[],1)-min(responses_ori_all_contra,[],1)); %normalize to max response 
AllcontraDir= strcat(SaveDir1, 'Figures\Ori_tuning\all_contra\');

if iscell(AllcontraDir)
    AllcontraDir=AllcontraDir{1}; 
end
if ~exist(AllcontraDir)
    mkdir(AllcontraDir)
end

for h=1:length(spks)
    f(h)=figure ('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_all_contra_norm(:,h); responses_ori_all_contra_norm(1,h)],...
        'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
    hold on
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_all_contra(h));
    polarplot ([0 theta], [0 1-cv_ori_all_contra(h)], 'Color', 'black'); %length of vector is 1-cirvar
    
    rticklabels ({});
    hold off
    cellname=strcat('cellID_', num2str(h));
    saveas(f(h),fullfile(AllcontraDir,strcat('Ori_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(AllcontraDir,strcat('Ori_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(AllcontraDir,strcat('Ori_polarplot_', cellname)), 'tif');
end 

%ipsilateral responses
responses_ori_all_ipsi_norm = (responses_ori_all_ipsi-max(responses_ori_all_ipsi,[],1)) ./ (max (responses_ori_all_ipsi,[],1)-min(responses_ori_all_ipsi,[],1)); %normalize to max response 
AllipsiDir= strcat(SaveDir1, 'Figures\Ori_tuning\all_ipsi\');

if iscell(AllipsiDir)
    AllipsiDir=AllipsiDir{1}; 
end
if ~exist(AllipsiDir)
    mkdir(AllipsiDir)
end

for h=1:length(spks)
    f(h)=figure ('Visible', 'off');
    polarplot ([oris_rad oris_rad(1)], [responses_ori_all_ipsi_norm(:,h); responses_ori_all_ipsi_norm(1,h)],...
        'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
    hold on
    rlim([0 1]); %make 1 upper limit
    theta=deg2rad(peak_ori_all_ipsi(h));
    
    polarplot ([0 theta], [0 1-cv_ori_all_ipsi(h)], 'Color', 'black'); 
   
    rticklabels ({});
    hold off
    cellname=strcat('cellID_', num2str((h)));
    saveas(f(h),fullfile(AllipsiDir,strcat('Ori_polarplot_', cellname)), 'png');
     saveas(f(h),fullfile(AllipsiDir,strcat('Ori_polarplot_', cellname)), 'pdf');
     saveas(f(h),fullfile(AllipsiDir,strcat('Ori_polarplot_', cellname)), 'tif');
end 



% %CONTRALATERAL MONOCULAR CELLS 
% for i=1:length(SigCellsFlash.ContraCell)
%     peak_ori_contra(i)=SigCellsFlash.ContraCell(i).pref_ori; 
%     cv_ori_contra(i)=SigCellsFlash.ContraCell(i).cv_ori; 
%     for k=1:length(oris)
%         responses_ori_contra(k,i)=SigCellsFlash.ContraCell(i).ori(k).peak;
%     end
% end
% 
% responses_ori_contra_norm = (responses_ori_contra-max(responses_ori_contra,[],1)) ./ (max (responses_ori_contra,[],1)-min(responses_ori_contra,[],1)); %normalize to max response 
% contraDir= strcat(SaveDir1, 'Figures\Ori_tuning\mon_contra\');
% 
% if iscell(contraDir)
%     contraDir=contraDir{1}; 
% end
% if ~exist(contraDir)
%     mkdir(contraDir)
% end
% 
% for h=1:length(SigCellsFlash.ContraCell)
%     f(h)=figure ('Visible', 'off');
%     polarplot ([oris_rad oris_rad(1)], [responses_ori_contra_norm(:,h); responses_ori_contra_norm(1,h)],...
%         'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
%     hold on
%     rlim([0 1]); %make 1 upper limit
%     theta=deg2rad(peak_ori_contra(h)); 
%     polarplot ([0 theta], [0 1-cv_ori_contra(h)], 'Color', 'black'); 
%   
%     rticklabels ({});
%     hold off
%     cellname=strcat('cellID_', num2str(SigCellsFlash.ContraCell(h).ID));
%     saveas(f(h),fullfile(contraDir,strcat('Ori_polarplot_', cellname)), 'png');
%      saveas(f(h),fullfile(contraDir,strcat('Ori_polarplot_', cellname)), 'pdf');
%      saveas(f(h),fullfile(contraDir,strcat('Ori_polarplot_', cellname)), 'tif');
% end 
% 
% %IPSILATERAL MONOCULAR CELLS 
% 
% for i=1:length(SigCellsFlash.IpsiCell)
%     peak_ori_ipsi(i)=SigCellsFlash.IpsiCell(i).pref_ori; 
%     cv_ori_ipsi(i)=SigCellsFlash.IpsiCell(i).cv_ori; 
%     for k=1:length(oris)
%         responses_ori_ipsi(k,i)=SigCellsFlash.IpsiCell(i).ori(k).peak;
%     end
% end
% 
% responses_ori_ipsi_norm (:,:)= (responses_ori_ipsi-min(responses_ori_ipsi,[],1)) ./ (max (responses_ori_ipsi,[],1)-min(responses_ori_ipsi,[],1)); %normalize to max response 
% ipsiDir= strcat(SaveDir1, 'Figures\Ori_tuning\mon_ipsi\');
% 
% if iscell(ipsiDir)
%     ipsiDir=ipsiDir{1}; 
% end
% if ~exist(ipsiDir)
%     mkdir(ipsiDir)
% end
% 
% for h=1:length(SigCellsFlash.IpsiCell)
%     f(h)=figure ('Visible', 'off');
%     polarplot ([oris_rad oris_rad(1)], [responses_ori_ipsi_norm(:,h); responses_ori_ipsi_norm(1,h)],...
%         'Color',[0 0.4470 0.7410], 'LineWidth', 1); %plot like this to close line 
%     hold on 
%    
%     theta=deg2rad(peak_ori_ipsi(h)); 
%     polarplot ([0 theta], [0 1-cv_ori_ipsi(h)], 'Color', 'black'); 
%     rticklabels ({});
%     hold off
%     cellname=strcat('cellID_', num2str(indices.flash.ipsiresp(h)));
%     saveas(f(h),fullfile(ipsiDir,strcat('Ori_polarplot_', cellname)), 'png');
%      saveas(f(h),fullfile(ipsiDir,strcat('Ori_polarplot_', cellname)), 'pdf');
%      saveas(f(h),fullfile(ipsiDir,strcat('Ori_polarplot_', cellname)), 'tif');
% end 
% 
% %BINOCULAR CELLS- CONTRALATERAL RESPONSES
% for i=1:length(SigCellsFlash.BinocCell)
%     responses_ori_binoc_contra(i)=SigCellsFlash.BinocCell(i).pref_ori.contra; 
%     cv_ori_binoc_contra(i)=SigCellsFlash.BinocCell(i).cv_ori.contra; 
%     for k=1:length(oris)
%         responses_ori_binoc_contra(k,i)=SigCellsFlash.BinocCell(i).ori(k).peak.contra;
%     end
% end
% 
% responses_ori_binoc_contra_norm (:,:)= (responses_ori_binoc_contra-max(responses_ori_binoc_contra,[],1)) ./ (max (responses_ori_binoc_contra,[],1)-min(responses_ori_binoc_contra,[],1)); %normalize to max response 
% contraBinocDir= strcat(SaveDir1, 'Figures\Ori_tuning\binoc_contra\');
% 
% if iscell(contraBinocDir)
%     contraBinocDir=contraBinocDir{1}; 
% end
% if ~exist(contraBinocDir)
%     mkdir(contraBinocDir)
% end
% 
% for h=1:length(SigCellsFlash.BinocCell)
%     f(h)=figure('Visible', 'off');
%     polarplot ([oris_rad oris_rad(1)], [responses_ori_binoc_contra_norm(:,h); responses_ori_binoc_contra_norm(1,h)],...
%         'Color',[0.4660 0.6740 0.1880], 'LineWidth', 1); %plot like this to close line 
%     hold on 
%   
%      theta=deg2rad(peak_ori_binoc_contra(h)); 
%     polarplot ([0 theta], [0 1-cv_ori_binoc_contra(h)], 'Color', 'black'); 
%     rticklabels ({});
%     hold off 
%     cellname=strcat('cellID_', num2str(SigCellsFlash.BinocCell(h).ID));
%     saveas(f(h),fullfile(contraBinocDir,strcat('Ori_polarplot_', cellname)), 'png');
%      saveas(f(h),fullfile(contraBinocDir,strcat('Ori_polarplot_', cellname)), 'pdf');
%      saveas(f(h),fullfile(contraBinocDir,strcat('Ori_polarplot_', cellname)), 'tif');
% end 
% 
% %BINOCULAR CELLS- IPSILATERAL RESPONSES 
% for i=1:length(SigCellsFlash.BinocCell)
%     responses_ori_binoc_ipsi(i)=SigCellsFlash.BinocCell(i).pref_ori.ipsi; 
%     cv_ori_binoc_ipsi(i)=SigCellsFlash.BinocCell(i).cv_ori.ipsi; 
%     for k=1:length(oris)
%         responses_ori_binoc_ipsi(k,i)=SigCellsFlash.BinocCell(i).ori(k).peak.ipsi;
%     end
% end
% 
% responses_ori_binoc_ipsi_norm (:,:)= (responses_ori_binoc_ipsi-max (responses_ori_binoc_ipsi,[],1)) ./ (max (responses_ori_binoc_ipsi,[],1)-min(responses_ori_binoc_ipsi,[],1)); %normalize to max response 
% ipsiBinocDir= strcat(SaveDir1, 'Figures\Ori_tuning\binoc_ipsi\');
% 
% if iscell(ipsiBinocDir)
%     ipsiBinocDir=ipsiBinocDir{1}; 
% end
% if ~exist(ipsiBinocDir)
%     mkdir(ipsiBinocDir)
% end
% 
% for h=1:length(SigCellsFlash.BinocCell)
%     f(h)=figure('Visible', 'off');
%     polarplot ([oris_rad oris_rad(1)], [responses_ori_binoc_ipsi_norm(:,h); responses_ori_binoc_ipsi_norm(1,h)],...
%         'Color',[0 0.4470 0.7410], 'LineWidth', 1); %plot like this to close line 
%     hold on 
%     
%     theta=deg2rad(peak_ori_binoc_ipsi(h)); 
%     polarplot ([0 theta], [0 1-cv_ori_binoc_ipsi(h)], 'Color', 'black'); 
%     rticklabels ({});
%     hold off 
%     cellname=strcat('cellID_', num2str(SigCellsFlash.BinocCell(h).ID));
%     saveas(f(h),fullfile(ipsiBinocDir,strcat('Ori_polarplot_', cellname)), 'png');
%      saveas(f(h),fullfile(ipsiBinocDir,strcat('Ori_polarplot_', cellname)), 'pdf');
%      saveas(f(h),fullfile(ipsiBinocDir,strcat('Ori_polarplot_', cellname)), 'tif');
% end
end