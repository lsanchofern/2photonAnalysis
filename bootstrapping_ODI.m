function bootstrapping_ODI (n_runs, n_cells_long, n_cells, param)
%% bootstrapping
%2-level data set
% level 1: mouse (pre or post) 
% level 2: neurons
% 4 datasets= WT pre, WT post, KO pre, KO post. may have NaN in case the upper level 
%units have different numbers of lower level units, but at the end 
% n_runs=number of bootstrap samples 
% n_cells_long= number of bootstrap samples for longitudinal track
% param - mean or median 
%num-cells= sample size for lower level. samples will be drawn with
%replacement from the actual data points in level 2 (NaNs not included) 

%% some set up 

%set save directory 

global SaveDir
SaveDir = ['L:\Laura\AnalyzedData\calcium\groupstats\'];
if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

%% Pre MD 

%set data origin directory for preMD 
AnalDirWTpre= ['L:\Laura\MouseMeasures\WT\preMD']; 
AnalDirKOpre= ['L:\Laura\MouseMeasures\KO\preMD']; 
 if ~exist(AnalDirWTpre,'dir') 
         mkdir (AnalDirWTpre)
 end

if ~exist(AnalDirKOpre,'dir') 
         mkdir (AnalDirKOpre)
end

%read in structures from each mouse 

%read-in SigCellsDrift (for DSI measurements- drifting grating stimulus)
%this is based off the dFoF- calcium signal 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpre,'*OD_pre.mat')); 
for i=1:numel(WTfile)
    WTDrift_pre(i)=load(fullfile(AnalDirWTpre, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpre,'*OD_pre.mat')); 
for i=1:numel(KOfile)
    KODrift_pre(i)=load(fullfile(AnalDirKOpre, KOfile(i).name)); 
end 

%ODI for all cells (regardless of longitudinal) 

%WT mice 
WTfile_all=dir(fullfile(AnalDirWTpre,'*_OD_pre_AllCells.mat')); 
for i=1:numel(WTfile_all)
    WTDrift_pre_all(i)=load(fullfile(AnalDirWTpre, WTfile_all(i).name)); 
end 

%KO mice 
KOfile_all=dir(fullfile(AnalDirKOpre,'*_OD_pre_AllCells.mat')); 
for i=1:numel(KOfile_all)
    KODrift_pre_all(i)=load(fullfile(AnalDirKOpre, KOfile_all(i).name)); 
end 

%binoc for all binoc cells (regardless of longitudinal) 

%WT mice 
WTfile_all_binoc_contra=dir(fullfile(AnalDirWTpre,'*_Oripref_pre_contra_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_contra)
    WTDrift_all_binoc_contra_pre(i)=load(fullfile(AnalDirWTpre, WTfile_all_binoc_contra(i).name)); 
end 

%KO mice 
KOfile_all_binoc_contra=dir(fullfile(AnalDirKOpre,'*_Oripref_pre_contra_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_contra)
    KODrift_all_binoc_contra_pre(i)=load(fullfile(AnalDirKOpre, KOfile_all_binoc_contra(i).name)); 
end 

%WT mice 
WTfile_all_binoc_ipsi=dir(fullfile(AnalDirWTpre,'*_Oripref_pre_ipsi_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_ipsi)
    WTDrift_all_binoc_ipsi_pre(i)=load(fullfile(AnalDirWTpre, WTfile_all_binoc_ipsi(i).name)); 
end 

%KO mice 
KOfile_all_binoc_ipsi=dir(fullfile(AnalDirKOpre,'*_Oripref_pre_ipsi_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_ipsi)
    KODrift_all_binoc_ipsi_pre(i)=load(fullfile(AnalDirKOpre, KOfile_all_binoc_ipsi(i).name)); 
end 


%binocular matching 

%WT mice 
WTfile_contra=dir(fullfile(AnalDirWTpre,'*Oripref_pre_contra.mat')); 
for i=1:numel(WTfile_contra)
    WTDrift_pre_contra(i)=load(fullfile(AnalDirWTpre, WTfile_contra(i).name)); 
end 
WTfile_ipsi=dir(fullfile(AnalDirWTpre,'*Oripref_pre_ipsi.mat')); 
for i=1:numel(WTfile_ipsi)
    WTDrift_pre_ipsi(i)=load(fullfile(AnalDirWTpre, WTfile_ipsi(i).name)); 
end 

%KO mice 
KOfile_contra=dir(fullfile(AnalDirKOpre,'*Oripref_pre_contra.mat')); 
for i=1:numel(KOfile_contra)
    KODrift_pre_contra(i)=load(fullfile(AnalDirKOpre, KOfile_contra(i).name)); 
end 

KOfile_ipsi=dir(fullfile(AnalDirKOpre,'*Oripref_pre_ipsi.mat')); 
for i=1:numel(KOfile_ipsi)
    KODrift_pre_ipsi(i)=load(fullfile(AnalDirKOpre, KOfile_ipsi(i).name)); 
end

%% post MD 

%set data origin directory for postMD 
AnalDirWTpost= ['L:\Laura\MouseMeasures\WT\postMD']; 
AnalDirKOpost= ['L:\Laura\MouseMeasures\KO\postMD']; 
 if ~exist(AnalDirWTpost,'dir') 
         mkdir (AnalDirWTpost)
 end

if ~exist(AnalDirKOpost,'dir') 
         mkdir (AnalDirKOpost)
end

%read in structures from each mouse 

%read-in SigCellsDrift (for DSI measurements- drifting grating stimulus)
%this is based off the dFoF- calcium signal 

%WT mice 
WTfile=dir(fullfile(AnalDirWTpost,'*_OD_post.mat')); 
for i=1:numel(WTfile)
    WTDrift_post(i)=load(fullfile(AnalDirWTpost, WTfile(i).name)); 
end 

%KO mice 
KOfile=dir(fullfile(AnalDirKOpost,'*_OD_post.mat')); 
for i=1:numel(KOfile)
    KODrift_post(i)=load(fullfile(AnalDirKOpost, KOfile(i).name)); 
end 

%ODI for all cells (regardless of longitudinal) 

%WT mice 
WTfile_all=dir(fullfile(AnalDirWTpost,'*_OD_post_AllCells.mat')); 
for i=1:numel(WTfile_all)
    WTDrift_post_all(i)=load(fullfile(AnalDirWTpost, WTfile_all(i).name)); 
end 

%KO mice 
KOfile_all=dir(fullfile(AnalDirKOpost,'*_OD_post_AllCells.mat')); 
for i=1:numel(KOfile_all)
    KODrift_post_all(i)=load(fullfile(AnalDirKOpost, KOfile_all(i).name)); 
end 

%binocular matching for all binoc cells (regardless of long. tracked)

%WT mice 
WTfile_all_binoc_contra=dir(fullfile(AnalDirWTpost,'*_Oripref_post_contra_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_contra)
    WTDrift_all_binoc_contra_post(i)=load(fullfile(AnalDirWTpost, WTfile_all_binoc_contra(i).name)); 
end 

%KO mice 
KOfile_all_binoc_contra=dir(fullfile(AnalDirKOpost,'*_Oripref_post_contra_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_contra)
    KODrift_all_binoc_contra_post(i)=load(fullfile(AnalDirKOpost, KOfile_all_binoc_contra(i).name)); 
end 

%WT mice 
WTfile_all_binoc_ipsi=dir(fullfile(AnalDirWTpost,'*_Oripref_post_ipsi_AllCells.mat')); 
for i=1:numel(WTfile_all_binoc_ipsi)
    WTDrift_all_binoc_ipsi_post(i)=load(fullfile(AnalDirWTpost, WTfile_all_binoc_ipsi(i).name)); 
end 

%KO mice 
KOfile_all_binoc_ipsi=dir(fullfile(AnalDirKOpost,'*_Oripref_post_ipsi_AllCells.mat')); 
for i=1:numel(KOfile_all_binoc_ipsi)
    KODrift_all_binoc_ipsi_post(i)=load(fullfile(AnalDirKOpost, KOfile_all_binoc_ipsi(i).name)); 
end 


%for the binocular matching (longitudinal)

%WT mice 
WTfile_contra=dir(fullfile(AnalDirWTpost,'*Oripref_post_contra.mat')); 
for i=1:numel(WTfile_contra)
    WTDrift_post_contra(i)=load(fullfile(AnalDirWTpost, WTfile_contra(i).name)); 
end 
WTfile_ipsi=dir(fullfile(AnalDirWTpost,'*Oripref_post_ipsi.mat')); 
for i=1:numel(WTfile_ipsi)
    WTDrift_post_ipsi(i)=load(fullfile(AnalDirWTpost, WTfile_ipsi(i).name)); 
end


%KO mice 
KOfile_contra=dir(fullfile(AnalDirKOpost,'*Oripref_post_contra.mat')); 
for i=1:numel(KOfile_contra)
    KODrift_post_contra(i)=load(fullfile(AnalDirKOpost, KOfile_contra(i).name)); 
end 

KOfile_ipsi=dir(fullfile(AnalDirKOpost,'*Oripref_post_ipsi.mat')); 
for i=1:numel(KOfile_ipsi)
    KODrift_post_ipsi(i)=load(fullfile(AnalDirKOpost, KOfile_ipsi(i).name)); 
end


%% WT pre dataset 
WT_nmice=length(WTDrift_pre_all); 

WT_empty_pre_all=zeros(WT_nmice,1); 
for i=1:WT_nmice
    WT_empty_pre_all(i,1)=length(WTDrift_pre_all(i).preMD_OD); 
end

%padding with NaNs, NaNs must be at the end 
max_n_WT_pre_all=max(WT_empty_pre_all); 
WT_data_pre_all=NaN(WT_nmice,max_n_WT_pre_all); 

%make data array for WT pre 
for i=1:WT_nmice
    for j=1:length(WTDrift_pre_all(i).preMD_OD)
        WT_data_pre_all(i,j)=(WTDrift_pre_all(i).preMD_OD(j)); 
    end
end

bootstats_WT_pre_all = NaN(1,n_runs);

for i =1:n_runs
    a = size(WT_data_pre_all);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(WT_data_pre_all(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = WT_data_pre_all(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_WT_pre_all(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_WT_pre_all(i) = median(temp(:));
    else
    end
    
end

%% KO pre dataset 

KO_nmice=length(KODrift_pre_all); 

KO_empty_pre_all=zeros(KO_nmice,1); 
for i=1:KO_nmice
    KO_empty_pre_all(i,1)=length(KODrift_pre_all(i).preMD_OD); 
end

%padding with NaNs, NaNs must be at the end 
max_n_KO_pre_all=max(KO_empty_pre_all); 
KO_data_pre_all=NaN(KO_nmice,max_n_KO_pre_all); 

%make data array for KO pre 
for i=1:KO_nmice
    for j=1:length(KODrift_pre_all(i).preMD_OD)
        KO_data_pre_all(i,j)=(KODrift_pre_all(i).preMD_OD(j)); 
    end
end

bootstats_KO_pre_all = NaN(1,n_runs);

for i =1:n_runs
    a = size(KO_data_pre_all);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(KO_data_pre_all(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = KO_data_pre_all(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_KO_pre_all(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_KO_pre_all(i) = median(temp(:));
    else
    end
    
end

%% WT post 

WT_empty_post_all=zeros(WT_nmice,1); 
for i=1:WT_nmice
    WT_empty_post_all(i,1)=length(WTDrift_post_all(i).postMD_OD); 
end

%padding with NaNs, NaNs must be at the end 
max_n_WT_post_all=max(WT_empty_post_all); 
WT_data_post_all=NaN(WT_nmice,max_n_WT_post_all); 

%make data array for WT post 
for i=1:WT_nmice
    for j=1:length(WTDrift_post_all(i).postMD_OD)
        WT_data_post_all(i,j)=(WTDrift_post_all(i).postMD_OD(j)); 
    end
end

bootstats_WT_post_all = NaN(1,n_runs);

for i =1:n_runs
    a = size(WT_data_post_all);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(WT_data_post_all(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = WT_data_post_all(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_WT_post_all(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_WT_post_all(i) = median(temp(:));
    else
    end
    
end

%% KO post 

KO_empty_post_all=zeros(KO_nmice,1); 
for i=1:KO_nmice
    KO_empty_post_all(i,1)=length(KODrift_post_all(i).postMD_OD); 
end

%padding with NaNs, NaNs must be at the end 
max_n_KO_post_all=max(KO_empty_post_all); 
KO_data_post_all=NaN(KO_nmice,max_n_KO_post_all); 

%make data array for KO post 
for i=1:KO_nmice
    for j=1:length(KODrift_post_all(i).postMD_OD)
        KO_data_post_all(i,j)=(KODrift_post_all(i).postMD_OD(j)); 
    end
end

bootstats_KO_post_all = NaN(1,n_runs);

for i =1:n_runs
    a = size(KO_data_post_all);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(KO_data_post_all(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = KO_data_post_all(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_KO_post_all(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_KO_post_all(i) = median(temp(:));
    else
    end
    
end

%% are the proportions different?
%type-1 error rate= alpha =0.05
%1- (alpha/2)

p=0.05; %alpha value we are setting 
%significance threshold is p>0.975

%Calculate probability of bootstats2 >= bootstats1: as 
% get_direct_prob (bootstats1, bootstats2)
p_boot_WT_all= get_direct_prob(bootstats_WT_post_all(:),bootstats_WT_pre_all(:));
p_boot_KO_all= get_direct_prob(bootstats_KO_post_all(:),bootstats_KO_pre_all(:));

p_boot_pre_all = get_direct_prob(bootstats_WT_pre_all(:),bootstats_KO_pre_all(:));
p_boot_post_all= get_direct_prob(bootstats_WT_post_all(:),bootstats_KO_post_all(:));

%% ODI score - ALL CELLS , regardless of longitudinally tracked or not 

%WT, preMD
WT_preOD_All=[]; 
for i=1:length(WTDrift_pre_all) %for all the mice 
    WT_preOD_All=[WT_preOD_All; WTDrift_pre_all(i).preMD_OD'];
end 

%WT,postMD
WT_postOD_All=[]; 
for i=1:length(WTDrift_post_all) %for all the mice 
    WT_postOD_All=[WT_postOD_All; WTDrift_post_all(i).postMD_OD'];
end 

%KO,preMD
KO_preOD_All=[]; 
for i=1:length(KODrift_pre_all) %for all the mice 
    KO_preOD_All=[KO_preOD_All; KODrift_pre_all(i).preMD_OD'];
end 

%KO,postMD
KO_postOD_All=[]; 
for i=1:length(KODrift_post_all) %for all the mice 
    KO_postOD_All=[KO_postOD_All; KODrift_post_all(i).postMD_OD'];
end 

%Plot the distribution of Pre vs Post 

f1=figure(1);
t=tiledlayout(1,2); 
%WT pre 
nexttile
h1=histogram(WT_preOD_All, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3]);
hold on 
xlim([-1 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre vs post MD')
box off 
%WT post 
h2=histogram(WT_postOD_All, 10,'Normalization','probability','FaceColor', [0.7 0.7 0.7]);
hold off 

%KO pre 
nexttile
h3=histogram(KO_preOD_All, 10, 'Normalization','probability','FaceColor', [.8 0 1]);
hold on 
xlim([-1 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre MD')
box off 
%KO post 
h4=histogram(KO_postOD_All, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);
hold off
title(t,'Ocular Dominance- Experimental Values')
xlabel(t,'ODI-All Cells')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f1, fullfile(SaveDir, 'AllCells_ODI-preVSpost-histograms'), 'pdf');
saveas(f1, fullfile(SaveDir, 'AllCells_ODI-preVSpost-histograms'), 'tif');
saveas(f1, fullfile(SaveDir, 'AllCells_ODI-preVSpost-histograms'), 'fig');

%Plot the distribution of WT vs KO 

f2=figure(2);
t=tiledlayout(1,2); 
%PRE 
nexttile
h5=histogram(WT_preOD_All, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3]);
hold on 
xlim([-1 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('Pre MD- WT vs KO')
box off  
h6=histogram(KO_preOD_All, 10,'Normalization','probability','FaceColor', [.8 0 1]);
hold off 

%Post 
nexttile
h7=histogram(WT_postOD_All, 10, 'Normalization','probability','FaceColor', [0.7 0.7 0.7]);
hold on 
xlim([-1 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('Post MD- WT vs KO')
box off 
%KO post 
h8=histogram(KO_postOD_All, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);
hold off
title(t,'Ocular Dominance- Experimental Values')
xlabel(t,'ODI-All Cells')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f2, fullfile(SaveDir, 'AllCells_ODI-WTvsKO-histograms'), 'pdf');
saveas(f2, fullfile(SaveDir, 'AllCells_ODI-WTvsKO-histograms'), 'tif');
saveas(f2, fullfile(SaveDir, 'AllCells_ODI-WTvsKO-histograms'), 'fig');


%% make some plots 

%Get mean and SEM of bootstrapped samples:
bootstats_WT_pre_sem = std(bootstats_WT_pre_all,'',2);
bootstats_WT_pre_center = mean(bootstats_WT_pre_all,2);

bootstats_KO_pre_sem = std(bootstats_KO_pre_all,'',2);
bootstats_KO_pre_center = mean(bootstats_KO_pre_all,2);

bootstats_WT_post_sem = std(bootstats_WT_post_all,'',2);
bootstats_WT_post_center = mean(bootstats_WT_post_all,2);

bootstats_KO_post_sem = std(bootstats_KO_post_all,'',2);
bootstats_KO_post_center = mean(bootstats_KO_post_all,2);


%Plot the distribution of Pre vs Post 

f3=figure(3);
t=tiledlayout(1,2); 
%WT pre 
nexttile
h9=histogram(bootstats_WT_pre_all, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3],'EdgeColor', 'none');
line([mean(bootstats_WT_pre_all) mean(bootstats_WT_pre_all)],[0 0.5],'Color',[0.1 0.1 0.1],'LineWidth',2);
hold on 
xlim([0 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre vs post MD')
box off 
%WT post 
h10=histogram(bootstats_WT_post_all, 10,'Normalization','probability','FaceColor', [0.7 0.7 0.7],'EdgeColor','none');
line([mean(bootstats_WT_post_all) mean(bootstats_WT_post_all)],[0 0.5],'Color',[0.4 0.4 0.4],'LineWidth',2);

hold off 

%KO pre 
nexttile
h11=histogram(bootstats_KO_pre_all, 10, 'Normalization','probability','FaceColor', [.8 0 1],'EdgeColor','none');
line([mean(bootstats_KO_pre_all) mean(bootstats_KO_pre_all)],[0 0.5],'Color',[0.4 0.0 0.4],'LineWidth',2);

hold on 
xlim([0 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre vs post MD')
box off 
%KO post 
h12=histogram(bootstats_KO_post_all, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1],'EdgeColor','none');
line([mean(bootstats_KO_post_all) mean(bootstats_KO_post_all)],[0 0.5],'Color',[0.6 0.2 0.8],'LineWidth',2);

hold off
title(t,'All Cells Ocular Dominance- Resampled')
xlabel(t,'ODI-All Cells')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f3, fullfile(SaveDir, 'AllCells_ODI-preVSpostResampling-histograms'), 'pdf');
saveas(f3, fullfile(SaveDir, 'AllCells_ODI-preVSpostResampling-histograms'), 'tif');
saveas(f3, fullfile(SaveDir, 'AllCells_ODI-preVSpostResampling-histograms'), 'fig');

%Plot the distribution of WT vs KO 

f4=figure(4);
t=tiledlayout(1,2); 
%PRE 
nexttile
h13=histogram(bootstats_WT_pre_all, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3],'EdgeColor','none');
hold on 
xlim([0 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
line([mean(bootstats_WT_pre_all) mean(bootstats_WT_pre_all)],[0 0.5],'Color',[0.1 0.1 0.1],'LineWidth',2);

set(gca,'TickDir','out');
title ('Resampled Pre MD- WT vs KO')
box off  
h14=histogram(bootstats_KO_pre_all, 10,'Normalization','probability','FaceColor', [.8 0 1],'EdgeColor','none'); 
line([mean(bootstats_KO_pre_all) mean(bootstats_KO_pre_all)],[0 0.5],'Color',[0.4 0.0 0.4],'LineWidth',2);
hold off 

%Post 
nexttile
h15=histogram(bootstats_WT_post_all, 10, 'Normalization','probability','FaceColor', [0.7 0.7 0.7],'EdgeColor','none');
line([mean(bootstats_WT_post_all) mean(bootstats_WT_post_all)],[0 0.5],'Color',[0.4 0.4 0.4],'LineWidth',2);

hold on 
xlim([0 1]); 
ylim([0 0.3])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('Resampled Post MD- WT vs KO')
box off 
%KO post 
h16=histogram(bootstats_KO_post_all, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1],'EdgeColor','none');
line([mean(bootstats_KO_post_all) mean(bootstats_KO_post_all)],[0 0.5],'Color',[0.6 0.2 0.8],'LineWidth',2);
hold off
title(t,'All Cells Ocular Dominance- Resampled')
xlabel(t,'ODI-All Cells')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f4, fullfile(SaveDir, 'AllCells_ODI-WTvsKOResampling-histograms'), 'pdf');
saveas(f4, fullfile(SaveDir, 'AllCells_ODI-WTvsKOResampling-histograms'), 'tif');
saveas(f4, fullfile(SaveDir, 'AllCells_ODI-WTvsKOResampling-histograms'), 'fig');



%% do for only longitudinally tracked cells 


%% WT pre dataset 
WT_nmice=length(WTDrift_pre_all); 

WT_empty_pre=zeros(WT_nmice,1); 
for i=1:WT_nmice
    WT_empty_pre(i,1)=length(WTDrift_pre(i).OD_pre); 
end

%padding with NaNs, NaNs must be at the end 
max_n_WT_pre=max(WT_empty_pre); 
WT_data_pre=NaN(WT_nmice,max_n_WT_pre); 

%make data array for WT pre 
for i=1:WT_nmice
    for j=1:length(WTDrift_pre(i).OD_pre)
        WT_data_pre(i,j)=(WTDrift_pre(i).OD_pre(j)); 
    end
end

bootstats_WT_pre = NaN(1,n_runs);

for i =1:n_runs
    a = size(WT_data_pre);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells_long);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(WT_data_pre(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells_long); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = WT_data_pre(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_WT_pre(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_WT_pre(i) = median(temp(:));
    else
    end
    
end

%% KO pre dataset 

KO_nmice=length(KODrift_pre_all); 

KO_empty_pre=zeros(KO_nmice,1); 
for i=1:KO_nmice
    KO_empty_pre(i,1)=length(KODrift_pre(i).OD_pre); 
end

%padding with NaNs, NaNs must be at the end 
max_n_KO_pre=max(KO_empty_pre); 
KO_data_pre=NaN(KO_nmice,max_n_KO_pre); 

%make data array for KO pre 
for i=1:KO_nmice
    for j=1:length(KODrift_pre(i).OD_pre)
        KO_data_pre(i,j)=(KODrift_pre(i).OD_pre(j)); 
    end
end

bootstats_KO_pre = NaN(1,n_runs);

for i =1:n_runs
    a = size(KO_data_pre);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells_long);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(KO_data_pre(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells_long); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = KO_data_pre(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_KO_pre(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_KO_pre(i) = median(temp(:));
    else
    end
    
end

%% WT post 

WT_empty_post=zeros(WT_nmice,1); 
for i=1:WT_nmice
    WT_empty_post(i,1)=length(WTDrift_post(i).OD_post); 
end

%padding with NaNs, NaNs must be at the end 
max_n_WT_post=max(WT_empty_post); 
WT_data_post=NaN(WT_nmice,max_n_WT_post); 

%make data array for WT post 
for i=1:WT_nmice
    for j=1:length(WTDrift_post(i).OD_post)
        WT_data_post(i,j)=(WTDrift_post(i).OD_post(j)); 
    end
end

bootstats_WT_post = NaN(1,n_runs);

for i =1:n_runs
    a = size(WT_data_post_all);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells_long);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(WT_data_post(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells_long); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = WT_data_post(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_WT_post(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_WT_post(i) = median(temp(:));
    else
    end
    
end

%% KO post 

KO_empty_post=zeros(KO_nmice,1); 
for i=1:KO_nmice
    KO_empty_post(i,1)=length(KODrift_post(i).OD_post); 
end

%padding with NaNs, NaNs must be at the end 
max_n_KO_post=max(KO_empty_post); 
KO_data_post=NaN(KO_nmice,max_n_KO_post); 

%make data array for KO post 
for i=1:KO_nmice
    for j=1:length(KODrift_post(i).OD_post)
        KO_data_post(i,j)=(KODrift_post(i).OD_post(j)); 
    end
end

bootstats_KO_post = NaN(1,n_runs);

for i =1:n_runs
    a = size(KO_data_post);
    num_lev1 = a(1);
    temp = NaN(num_lev1,n_cells_long);
    rand_lev1 = randi(num_lev1,num_lev1,1);
    for j = 1:length(rand_lev1)
        num_lev2 = find(~isnan(KO_data_post(rand_lev1(j),:)),1,'last'); %We need to calculate this again here because there is a different number of trials for each neuron
        rand_lev2 = randi(num_lev2,1,n_cells_long); %Resample only from trials with data but same number of sample trials for all
        temp(j,:) = KO_data_post(rand_lev1(j),rand_lev2);
    end
    
    if strcmp(param,'mean')
        bootstats_KO_post(i) = mean(temp(:));
    elseif strcmp(param,'median')
        bootstats_KO_post(i) = median(temp(:));
    else
    end
    
end

%% are the proportions different?
%type-1 error rate= alpha =0.05
%1- (alpha/2)

p=0.05; %alpha value we are setting 
%significance threshold is p>0.975

%Calculate probability of bootstats2 >= bootstats1: as 
% get_direct_prob (bootstats1, bootstats2)
p_boot_WT= get_direct_prob(bootstats_WT_post(:),bootstats_WT_pre(:));
p_boot_KO= get_direct_prob(bootstats_KO_post(:),bootstats_KO_pre(:));

p_boot_pre = get_direct_prob(bootstats_WT_pre(:),bootstats_KO_pre(:));
p_boot_post= get_direct_prob(bootstats_WT_post(:),bootstats_KO_post(:));

%% ODI score - 
%WT, preMD
WT_preOD=[]; 
for i=1:length(WTDrift_pre) %for all the mice 
    WT_preOD=[WT_preOD; WTDrift_pre(i).OD_pre];
end 

%WT,postMD
WT_postOD=[]; 
for i=1:length(WTDrift_post) %for all the mice 
    WT_postOD=[WT_postOD; WTDrift_post(i).OD_post];
end 

%KO,preMD
KO_preOD=[]; 
for i=1:length(KODrift_pre) %for all the mice 
    KO_preOD=[KO_preOD; KODrift_pre(i).OD_pre];
end 

%KO,postMD
KO_postOD=[]; 
for i=1:length(KODrift_post) %for all the mice 
    KO_postOD=[KO_postOD; KODrift_post(i).OD_post];
end 

%Plot the distribution of Pre vs Post 

f5=figure(5);
t=tiledlayout(1,2); 
%WT pre 
nexttile
h20=histogram(WT_preOD, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3]);
hold on 
xlim([-1 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre vs post MD longitudinally tracked')
box off 
%WT post 
h21=histogram(WT_postOD, 10,'Normalization','probability','FaceColor', [0.7 0.7 0.7]);
hold off 

%KO pre 
nexttile
h22=histogram(KO_preOD, 10, 'Normalization','probability','FaceColor', [.8 0 1]);
hold on 
xlim([-1 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre vs post MD longitudinally tracked')
box off 
%KO post 
h23=histogram(KO_postOD, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);
hold off
title(t,'Ocular Dominance- Experimental Values')
xlabel(t,'ODI')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f5, fullfile(SaveDir, 'LongCells_ODI-preVSpost-histograms'), 'pdf');
saveas(f5, fullfile(SaveDir, 'LongCells_ODI-preVSpost-histograms'), 'tif');
saveas(f5, fullfile(SaveDir, 'LongCells_ODI-preVSpost-histograms'), 'fig');

%Plot the distribution of WT vs KO 

f6=figure(6);
t=tiledlayout(1,2); 
%PRE 
nexttile
h24=histogram(WT_preOD, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3]);
hold on 
xlim([-1 1]);
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('Pre MD- WT vs KO longitudinally tracked')
box off  
h25=histogram(KO_preOD, 10,'Normalization','probability','FaceColor', [.8 0 1]);
hold off 

%Post 
nexttile
h26=histogram(WT_postOD, 10, 'Normalization','probability','FaceColor', [0.7 0.7 0.7]);
hold on 
xlim([-1 1]);
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('Post MD- WT vs KO longitudinally tracked')
box off 
%KO post 
h27=histogram(KO_postOD, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1]);
hold off
title(t,'Ocular Dominance- Experimental Values')
xlabel(t,'ODI')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f6, fullfile(SaveDir, 'LongCells_ODI-WTvsKO-histograms'), 'pdf');
saveas(f6, fullfile(SaveDir, 'LongCells_ODI-WTvsKO-histograms'), 'tif');
saveas(f6, fullfile(SaveDir, 'LongCells_ODI-WTvsKO-histograms'), 'fig');


%% make some plots 

%Get mean and SEM of bootstrapped samples:
bootstats_WT_pre_sem = std(bootstats_WT_pre_all,'',2);
bootstats_WT_pre_center = mean(bootstats_WT_pre_all,2);

bootstats_KO_pre_sem = std(bootstats_KO_pre_all,'',2);
bootstats_KO_pre_center = mean(bootstats_KO_pre_all,2);

bootstats_WT_post_sem = std(bootstats_WT_post_all,'',2);
bootstats_WT_post_center = mean(bootstats_WT_post_all,2);

bootstats_KO_post_sem = std(bootstats_KO_post_all,'',2);
bootstats_KO_post_center = mean(bootstats_KO_post_all,2);


%Plot the distribution of Pre vs Post 

f7=figure(7);
t=tiledlayout(1,2); 
%WT pre 
nexttile
h30=histogram(bootstats_WT_pre, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3],'EdgeColor', 'none');
hold on 
xlim([0 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('WT- pre vs post MD')
box off 
%WT post 
h31=histogram(bootstats_WT_post, 10,'Normalization','probability','FaceColor', [0.7 0.7 0.7],'EdgeColor','none');
hold off 

%KO pre 
nexttile
h32=histogram(bootstats_KO_pre, 10, 'Normalization','probability','FaceColor', [.8 0 1],'EdgeColor','none');
hold on 
xlim([0 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('KO- pre vs post MD')
box off 
%KO post 
h33=histogram(bootstats_KO_post, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1],'EdgeColor','none');
hold off
title(t,'Long. Cells Ocular Dominance- Resampled')
xlabel(t,'ODI')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f7, fullfile(SaveDir, 'LongCells_ODI-preVSpostResampling-histograms'), 'pdf');
saveas(f7, fullfile(SaveDir, 'LongCells_ODI-preVSpostResampling-histograms'), 'tif');
saveas(f7, fullfile(SaveDir, 'LongCells_ODI-preVSpostResampling-histograms'), 'fig');

%Plot the distribution of WT vs KO 

f8=figure(8);
t=tiledlayout(1,2); 
%PRE 
nexttile
h34=histogram(bootstats_WT_pre, 10,'Normalization','probability','FaceColor', [0.3 0.3 0.3],'EdgeColor','none');
hold on 
xlim([0 1]); 
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title ('Resampled Pre MD- WT vs KO')
box off  
h35=histogram(bootstats_KO_pre, 10,'Normalization','probability','FaceColor', [.8 0 1],'EdgeColor','none');
hold off 

%Post 
nexttile
h36=histogram(bootstats_WT_post, 10, 'Normalization','probability','FaceColor', [0.7 0.7 0.7],'EdgeColor','none');
hold on 
xlim([0 1]);
ylim([0 0.5])
ytix=get(gca,'YTick');
set(gca,'YTick',ytix,'YTickLabel', ytix*100); 
set(gca,'TickDir','out');
title('Resampled Post MD- WT vs KO')
box off 
%KO post 
h37=histogram(bootstats_KO_post, 10,'Normalization','probability', 'FaceColor', [.8 0.7 1],'EdgeColor','none');
hold off
title(t,'Long. Cells Ocular Dominance- Resampled')
xlabel(t,'ODI')
ylabel(t,'Percentage of Neurons')

%save figure1 
saveas(f8, fullfile(SaveDir, 'LongCells_ODI-WTvsKOResampling-histograms'), 'pdf');
saveas(f8, fullfile(SaveDir, 'LongCells_ODI-WTvsKOResampling-histograms'), 'tif');
saveas(f8, fullfile(SaveDir, 'LongCells_ODI-WTvsKOResampling-histograms'), 'fig');

%% save p values 
char_p=strings(4,1);
char_p(1)='WT pre vs post'; 
char_p(2)='KO pre vs post';
char_p(3)='Pre WT vs KO';
char_p(4)='Post WT vs KO'; 

char_p_long=strings(4,1);
char_p_long(1)='Long. WT pre vs post'; 
char_p_long(2)='Long. KO pre vs post';
char_p_long(3)='Long. Pre WT vs KO';
char_p_long(4)='Long. Post WT vs KO'; 

char_p_boot=vertcat (char_p, char_p_long); 

p_boot=vertcat(p_boot_WT_all,p_boot_KO_all,p_boot_pre_all,p_boot_post_all,...
    p_boot_WT, p_boot_KO, p_boot_pre, p_boot_post); 

p_values_boot=table(char_p_boot,p_boot); 

%save table 
save(fullfile(SaveDir,'p_values_boot.mat'),'p_values_boot'); 
writetable(p_values_boot,fullfile(SaveDir, 'p_values_boot.xls')); 



end
