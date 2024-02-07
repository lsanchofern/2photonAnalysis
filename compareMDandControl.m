function compareMDandControl()
%function to compare MD mice and control, longitudinal imaging 

%compare OD change and cell proportions 
%% set Save directory and analysis directory 

global SaveDir
SaveDir = ['L:\Laura\AnalyzedData\calcium\groupstats-MDvsControl\'];
if exist(SaveDir,'dir') == 0
            mkdir(SaveDir)
end

AnalDirKO_md= ['L:\Laura\AnalyzedData\calcium\groupstats-MD experiment\']; 
AnalDirKO_cont= ['L:\Laura\AnalyzedData\calcium\groupstats\'];

if ~exist(AnalDirKO_md,'dir') 
         mkdir (AnalDirKO_md)
 end

if ~exist(AnalDirKO_cont,'dir') 
         mkdir (AnalDirKO_cont)
end

%% load data sets from data folders - KO mice 

%load OD 
%KO mice 
OD_md=load(fullfile(AnalDirKO_md,'ODscoretable_all.mat')); 
OD_cont=load(fullfile(AnalDirKO_cont,'ODscoretable_all.mat')); 

%load cell proportions- MD CONDITION 
KO_Iconv_MD=load(fullfile(AnalDirKO_md,'KO_Iconversion.mat')); 
KO_Bconv_MD=load(fullfile(AnalDirKO_md,'KO_Bconversion.mat'));
KO_Uconv_MD=load(fullfile(AnalDirKO_md,'KO_Uconversion.mat'));

KO_pre_C_MD=load(fullfile(AnalDirKO_md,'KO_pre_C.mat')); 
KO_pre_B_MD=load(fullfile(AnalDirKO_md,'KO_pre_B.mat')); 
KO_pre_I_MD=load(fullfile(AnalDirKO_md,'KO_pre_I.mat')); 
KO_pre_U_MD=load(fullfile(AnalDirKO_md,'KO_pre_U.mat')); 
KO_post_C_MD=load(fullfile(AnalDirKO_md,'KO_post_C.mat')); 
KO_post_B_MD=load(fullfile(AnalDirKO_md,'KO_post_B.mat')); 
KO_post_I_MD=load(fullfile(AnalDirKO_md,'KO_post_I.mat')); 
KO_post_U_MD=load(fullfile(AnalDirKO_md,'KO_post_U.mat'));  



KO_C2U_MD=load(fullfile(AnalDirKO_md, 'KO_C2C.mat'));
KO_C2I_MD=load(fullfile(AnalDirKO_md, 'KO_C2I.mat')); 
KO_C2B_MD=load(fullfile(AnalDirKO_md, 'KO_C2B.mat'));
KO_C2U_MD=load(fullfile(AnalDirKO_md, 'KO_C2U.mat'));

KO_I2U_MD=load(fullfile(AnalDirKO_md, 'KO_I2C.mat'));
KO_I2I_MD=load(fullfile(AnalDirKO_md, 'KO_I2I.mat')); 
KO_I2B_MD=load(fullfile(AnalDirKO_md, 'KO_I2B.mat'));
KO_I2U_MD=load(fullfile(AnalDirKO_md, 'KO_I2U.mat'));

KO_B2U_MD=load(fullfile(AnalDirKO_md, 'KO_B2C.mat'));
KO_B2I_MD=load(fullfile(AnalDirKO_md, 'KO_B2I.mat')); 
KO_B2B_MD=load(fullfile(AnalDirKO_md, 'KO_B2B.mat'));
KO_B2U_MD=load(fullfile(AnalDirKO_md, 'KO_B2U.mat'));

KO_U2U_MD=load(fullfile(AnalDirKO_md, 'KO_U2C.mat'));
KO_U2I_MD=load(fullfile(AnalDirKO_md, 'KO_U2I.mat')); 
KO_U2B_MD=load(fullfile(AnalDirKO_md, 'KO_U2B.mat'));
KO_U2U_MD=load(fullfile(AnalDirKO_md, 'KO_U2U.mat'));



%load from control datasets
KO_Iconv_CONT=load(fullfile(AnalDirKO_cont,'KO_Iconversion.mat')); 
KO_Bconv_CONT=load(fullfile(AnalDirKO_cont,'KO_Bconversion.mat'));
KO_Uconv_CONT=load(fullfile(AnalDirKO_cont,'KO_Uconversion.mat'));

KO_pre_C_CONT=load(fullfile(AnalDirKO_cont,'KO_pre_C.mat')); 
KO_pre_B_CONT=load(fullfile(AnalDirKO_cont,'KO_pre_B.mat')); 
KO_pre_I_CONT=load(fullfile(AnalDirKO_cont,'KO_pre_I.mat')); 
KO_pre_U_CONT=load(fullfile(AnalDirKO_cont,'KO_pre_U.mat')); 
KO_post_C_CONT=load(fullfile(AnalDirKO_cont,'KO_post_C.mat')); 
KO_post_B_CONT=load(fullfile(AnalDirKO_cont,'KO_post_B.mat')); 
KO_post_I_CONT=load(fullfile(AnalDirKO_cont,'KO_post_I.mat')); 
KO_post_U_CONT=load(fullfile(AnalDirKO_cont,'KO_post_U.mat'));  

KO_C2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_C2C.mat'));
KO_C2I_CONT=load(fullfile(AnalDirKO_cont, 'KO_C2I.mat')); 
KO_C2B_CONT=load(fullfile(AnalDirKO_cont, 'KO_C2B.mat'));
KO_C2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_C2U.mat'));

KO_I2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_I2C.mat'));
KO_I2I_CONT=load(fullfile(AnalDirKO_cont, 'KO_I2I.mat')); 
KO_I2B_CONT=load(fullfile(AnalDirKO_cont, 'KO_I2B.mat'));
KO_I2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_I2U.mat'));

KO_B2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_B2C.mat'));
KO_B2I_CONT=load(fullfile(AnalDirKO_cont, 'KO_B2I.mat')); 
KO_B2B_CONT=load(fullfile(AnalDirKO_cont, 'KO_B2B.mat'));
KO_B2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_B2U.mat'));

KO_U2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_U2C.mat'));
KO_U2I_CONT=load(fullfile(AnalDirKO_cont, 'KO_U2I.mat')); 
KO_U2B_CONT=load(fullfile(AnalDirKO_cont, 'KO_U2B.mat'));
KO_U2U_CONT=load(fullfile(AnalDirKO_cont, 'KO_U2U.mat'));

%% compare OD scores 
%MD
MD_ODtable=OD_md.ODscoretable_all;
MD_ODtable.group_all= categorical(MD_ODtable.group_all); 

i= (MD_ODtable.group_all=='pre KO'); 
KO_pre_MD=(MD_ODtable(i,:)); 

j=(MD_ODtable.group_all=='post KO');
KO_post_MD=(MD_ODtable(j,:));

%control, no MD 
CONT_ODtable=OD_cont.ODscoretable_all;
CONT_ODtable.group_all= categorical(CONT_ODtable.group_all); 

i= (CONT_ODtable.group_all=='pre KO'); 
KO_pre_CONT=(CONT_ODtable(i,:)); 

j=(CONT_ODtable.group_all=='post KO');
KO_post_CONT=(CONT_ODtable(j,:));

save(fullfile(SaveDir,'KO_pre_MD.mat'),'KO_pre_MD');
save(fullfile(SaveDir,'KO_post_MD.mat'),'KO_post_MD');
save(fullfile(SaveDir,'KO_pre_CONT.mat'),'KO_pre_CONT');
save(fullfile(SaveDir,'KO_post_CONT.mat'),'KO_post_CONT');

KO_totalcells_MD=load(fullfile(AnalDirKO_md, 'KO_totalcells.mat'));
KO_totalcells_CONT=load(fullfile(AnalDirKO_cont, 'KO_totalcells.mat'));

MD_KO_totalcells=KO_totalcells_MD.KO_totalcells; 
CONT_KO_totalcells=KO_totalcells_CONT.KO_totalcells; 


%% compare proportions of cells - contralateral

%compare contralateral 

%unresponsive
MD_KO_pre_U=KO_pre_U_MD.KO_pre_U; 
MD_KO_post_U=KO_post_U_MD.KO_post_U; 
CONT_KO_pre_U=KO_pre_U_CONT.KO_pre_U; 
CONT_KO_post_U=KO_post_U_CONT.KO_post_U;

MD_KO_pre_C=KO_pre_C_MD.KO_pre_C; 
MD_KO_post_C=KO_post_C_MD.KO_post_C; 
CONT_KO_pre_C=KO_pre_C_CONT.KO_pre_C; 
CONT_KO_post_C=KO_post_C_CONT.KO_post_C;

categoriesCtotal=categorical({'Pre', 'Post'}); 
categoriesCtotal=reordercats(categoriesCtotal, {'Pre', 'Post'});  

pre_Ctotal=[MD_KO_pre_C/(MD_KO_totalcells-MD_KO_pre_U)  CONT_KO_pre_C/(CONT_KO_totalcells-CONT_KO_pre_U)]; 
post_Ctotal=[MD_KO_post_C/(MD_KO_totalcells-MD_KO_post_U)  CONT_KO_post_C/(CONT_KO_totalcells-CONT_KO_post_U)]; 

fig_contralateral=figure(1); 

y_Ctotal=[pre_Ctotal; post_Ctotal]; 
bIC=bar(categoriesCtotal,y_Ctotal, 0.9); 
hold on 
bIC(1).FaceColor=[0.3 0.3 0.3]; 
bIC(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
ylabel('Proportion of Responsive Neurons')
title('Total Contralateral')
legend('MD', 'CONT'); 
box off; 

saveas(fig_contralateral, fullfile(SaveDir,'TotalContra'),'pdf'); 
saveas(fig_contralateral, fullfile(SaveDir,'TotalContra'),'tif');
saveas(fig_contralateral, fullfile(SaveDir,'TotalContra'),'fig');

%%  ipsilateral

MD_KO_pre_I=KO_pre_I_MD.KO_pre_I; 
MD_KO_post_I=KO_post_I_MD.KO_post_I; 
CONT_KO_pre_I=KO_pre_I_CONT.KO_pre_I; 
CONT_KO_post_I=KO_post_I_CONT.KO_post_I;

categoriesItotal=categorical({'Pre', 'Post'}); 
categoriesItotal=reordercats(categoriesItotal, {'Pre', 'Post'}); 

pre_Itotal=[MD_KO_pre_I/(MD_KO_totalcells-MD_KO_pre_U)  CONT_KO_pre_I/(CONT_KO_totalcells-CONT_KO_pre_U)]; 
post_Itotal=[MD_KO_post_I/(MD_KO_totalcells-MD_KO_post_U)  CONT_KO_post_I/(CONT_KO_totalcells-CONT_KO_post_U)]; 

fig_ipsilateral=figure(2); 

y_Itotal=[pre_Itotal; post_Itotal]; 
bI=bar(categoriesItotal,y_Itotal, 0.9); 
hold on 
bI(1).FaceColor=[0.3 0.3 0.3]; 
bI(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
ylabel('Proportion of Responsive Neurons')
title('Total Ipsilateral')
legend('MD', 'CONT'); 
box off; 

saveas(fig_ipsilateral, fullfile(SaveDir,'TotalIpsi'),'pdf'); 
saveas(fig_ipsilateral, fullfile(SaveDir,'TotalIpsi'),'tif');
saveas(fig_ipsilateral, fullfile(SaveDir,'TotalIpsi'),'fig');

%% binocular 

MD_KO_pre_B=KO_pre_B_MD.KO_pre_B; 
MD_KO_post_B=KO_post_B_MD.KO_post_B; 
CONT_KO_pre_B=KO_pre_B_CONT.KO_pre_B; 
CONT_KO_post_B=KO_post_B_CONT.KO_post_B;

categoriesBtotal=categorical({'Pre', 'Post'}); 
categoriesBtotal=reordercats(categoriesBtotal, {'Pre', 'Post'}); 

pre_Btotal=[MD_KO_pre_B/(MD_KO_totalcells-MD_KO_pre_U)  CONT_KO_pre_B/(CONT_KO_totalcells-CONT_KO_pre_U)]; 
post_Btotal=[MD_KO_post_B/(MD_KO_totalcells-MD_KO_post_U)  CONT_KO_post_B/(CONT_KO_totalcells-CONT_KO_post_U)]; 

fig_binocular=figure(3); 

y_Btotal=[pre_Btotal; post_Btotal]; 
bB=bar(categoriesBtotal,y_Btotal, 0.9); 
hold on 
bB(1).FaceColor=[0.3 0.3 0.3]; 
bB(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
ylabel('Proportion of Responsive Neurons')
title('Total Binocular')
legend('MD', 'CONT'); 
box off; 

saveas(fig_binocular, fullfile(SaveDir,'TotalBinoc'),'pdf'); 
saveas(fig_binocular, fullfile(SaveDir,'TotalBinoc'),'tif');
saveas(fig_binocular, fullfile(SaveDir,'TotalBinoc'),'fig');

%% unresponsive 

fig_unresponsive=figure(4); 


categoriesURtotal=categorical({'Pre', 'Post'}); 
categoriesURtotal=reordercats(categoriesURtotal, {'Pre', 'Post'}); 

pre_URtotal=[(MD_KO_pre_U/MD_KO_totalcells)  CONT_KO_pre_U/CONT_KO_totalcells ]; 
post_URtotal=[(MD_KO_post_U/MD_KO_totalcells)  CONT_KO_post_U/CONT_KO_totalcells]; 

y_URtotal=[pre_URtotal; post_URtotal]; 
b1=bar(categoriesURtotal,y_URtotal, 0.9); 
hold on 
b1(1).FaceColor=[0.3 0.3 0.3]; 
b1(2).FaceColor=[.8 0 1]; 
set(gca,'TickDir','out');
ylim([0 1]); 
title('Total Unresponsiveness')
legend('WT', 'KO'); 
box off; 

saveas(fig_unresponsive, fullfile(SaveDir,'UnresponsiveTotal'),'pdf'); 
saveas(fig_unresponsive, fullfile(SaveDir,'UnresponsiveTotal'),'tif');
saveas(fig_unresponsive, fullfile(SaveDir,'UnresponsiveTotal'),'fig');

%% Unresponsive tests 

%total prop unresp- pre, MD VS CONTROL
p0_U_pre=(MD_KO_pre_U+CONT_KO_pre_U)/((MD_KO_totalcells)+(CONT_KO_totalcells));
MD_U_exp_pre=(MD_KO_totalcells)*p0_U_pre; 
CONT_U_exp_pre=(CONT_KO_totalcells)*p0_U_pre;

observed_U_pre=[MD_KO_pre_U (MD_KO_totalcells-MD_KO_pre_U) CONT_KO_pre_U (CONT_KO_totalcells-CONT_KO_pre_U)]; 
expected_U_pre=[MD_U_exp_pre MD_KO_totalcells-MD_U_exp_pre CONT_U_exp_pre CONT_KO_totalcells-CONT_U_exp_pre]; 

chi2stat_U_pre=sum((observed_U_pre-expected_U_pre).^2 ./expected_U_pre); 
p_U_pre = 1 - chi2cdf(chi2stat_U_pre,1);

%total prop unresp - post
p0_U_post=(MD_KO_post_U+ CONT_KO_post_U)/((MD_KO_totalcells)+(CONT_KO_totalcells));
MD_U_exp_post=(MD_KO_totalcells)*p0_U_post; 
CONT_U_exp_post=(CONT_KO_totalcells)*p0_U_post;

observed_U_post=[MD_KO_post_U (MD_KO_totalcells)-MD_KO_post_U CONT_KO_post_U (CONT_KO_totalcells)-CONT_KO_post_U]; 
expected_U_post=[MD_U_exp_post (MD_KO_totalcells)-MD_U_exp_post CONT_U_exp_post (CONT_KO_totalcells)-CONT_U_exp_post]; 

chi2stat_U_post=sum((observed_U_post-expected_U_post).^2 ./expected_U_post); 
p_U_post = 1 - chi2cdf(chi2stat_U_post,1);


%MD prop unresp- pre vs post 
p0_MD_U=(MD_KO_pre_U+ MD_KO_post_U)/(MD_KO_totalcells+MD_KO_totalcells);
MD_U_exp_pre=(MD_KO_totalcells)*p0_MD_U; 
MD_U_exp_post=(MD_KO_totalcells)*p0_MD_U;

observed_MD_U=[MD_KO_pre_U (MD_KO_totalcells-MD_KO_pre_U) MD_KO_post_U (MD_KO_totalcells-MD_KO_post_U)]; 
expected_MD_U=[MD_U_exp_pre (MD_KO_totalcells-MD_U_exp_pre) MD_U_exp_post (MD_KO_totalcells-MD_U_exp_post)]; 

chi2stat_MD_U=sum((observed_MD_U-expected_MD_U).^2 ./expected_MD_U); 
p_MD_U = 1 - chi2cdf(chi2stat_MD_U,1);

%CONT pre vs post unresp
p0_CONT_U=(CONT_KO_pre_U+ CONT_KO_post_U)/(CONT_KO_totalcells+CONT_KO_totalcells);
CONT_U_exp_pre=(CONT_KO_totalcells)*p0_CONT_U; 
CONT_U_exp_post=(CONT_KO_totalcells)*p0_CONT_U;

observed_CONT_U=[CONT_KO_pre_U (CONT_KO_totalcells-CONT_KO_pre_U) CONT_KO_post_U (CONT_KO_totalcells-CONT_KO_post_U)]; 
expected_CONT_U=[CONT_U_exp_pre (CONT_KO_totalcells-CONT_U_exp_pre) CONT_U_exp_post (CONT_KO_totalcells-CONT_U_exp_post)]; 

chi2stat_CONT_U=sum((observed_CONT_U-expected_CONT_U).^2 ./expected_CONT_U); 
p_CONT_U = 1 - chi2cdf(chi2stat_CONT_U,1);

%% contralateral 


%total prop contra- pre, MD VS CONTROL
p0_C_pre=(MD_KO_pre_C+CONT_KO_pre_C)/((MD_KO_totalcells-MD_KO_pre_U)+(CONT_KO_totalcells-CONT_KO_pre_U));
MD_C_exp_pre=(MD_KO_totalcells-MD_KO_pre_U)*p0_C_pre; 
CONT_C_exp_pre=(CONT_KO_totalcells-CONT_KO_pre_U)*p0_C_pre;

observed_C_pre=[MD_KO_pre_C (MD_KO_totalcells-MD_KO_pre_U)-MD_KO_pre_C CONT_KO_pre_C (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_KO_pre_C]; 
expected_C_pre=[MD_C_exp_pre (MD_KO_totalcells-MD_KO_pre_U)-MD_C_exp_pre CONT_C_exp_pre (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_C_exp_pre]; 

chi2stat_C_pre=sum((observed_C_pre-expected_C_pre).^2 ./expected_C_pre); 
p_C_pre = 1 - chi2cdf(chi2stat_C_pre,1);

%total prop contra - post
p0_C_post=(MD_KO_post_C+ CONT_KO_post_C)/((MD_KO_totalcells-MD_KO_post_U)+(CONT_KO_totalcells-CONT_KO_post_U));
MD_C_exp_post=(MD_KO_totalcells-MD_KO_post_U)*p0_C_post; 
CONT_C_exp_post=(CONT_KO_totalcells-CONT_KO_post_U)*p0_C_post;

observed_C_post=[MD_KO_post_C (MD_KO_totalcells-MD_KO_post_U)-MD_KO_post_C CONT_KO_post_C (CONT_KO_totalcells-CONT_KO_post_U)-CONT_KO_post_C]; 
expected_C_post=[MD_C_exp_post (MD_KO_totalcells-MD_KO_post_U)-MD_C_exp_post CONT_C_exp_post (CONT_KO_totalcells-CONT_KO_post_U)-CONT_C_exp_post]; 

chi2stat_C_post=sum((observed_C_post-expected_C_post).^2 ./expected_C_post); 
p_C_post = 1 - chi2cdf(chi2stat_C_post,1);


%MD prop contra- pre vs post 
p0_MD_C=(MD_KO_pre_C+ MD_KO_post_C)/((MD_KO_totalcells-MD_KO_pre_U)+(MD_KO_totalcells-MD_KO_post_U));
MD_C_exp_pre=(MD_KO_totalcells-MD_KO_pre_U)*p0_MD_C; 
MD_C_exp_post=(MD_KO_totalcells-MD_KO_post_U)*p0_MD_C;

observed_MD_C=[MD_KO_pre_C (MD_KO_totalcells-MD_KO_pre_U)-MD_KO_pre_C MD_KO_post_C (MD_KO_totalcells-MD_KO_post_U)-MD_KO_post_C]; 
expected_MD_C=[MD_C_exp_pre (MD_KO_totalcells-MD_KO_pre_U)-(MD_C_exp_pre) MD_C_exp_post (MD_KO_totalcells-MD_KO_post_U)-MD_C_exp_post]; 

chi2stat_MD_C=sum((observed_MD_C-expected_MD_C).^2 ./expected_MD_C); 
p_MD_C = 1 - chi2cdf(chi2stat_MD_C,1);

%CONT pre vs post contra
p0_CONT_C=(CONT_KO_pre_C+ CONT_KO_post_C)/((CONT_KO_totalcells-CONT_KO_pre_U)+(CONT_KO_totalcells-CONT_KO_post_U));
CONT_C_exp_pre=(CONT_KO_totalcells-CONT_KO_pre_U)*p0_CONT_C; 
CONT_C_exp_post=(CONT_KO_totalcells-CONT_KO_post_U)*p0_CONT_C;

observed_CONT_C=[CONT_KO_pre_C (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_KO_pre_C CONT_KO_post_C (CONT_KO_totalcells-CONT_KO_post_U)-CONT_KO_post_C]; 
expected_CONT_C=[CONT_C_exp_pre (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_C_exp_pre CONT_C_exp_post (CONT_KO_totalcells-CONT_KO_post_U)-CONT_C_exp_post]; 

chi2stat_CONT_C=sum((observed_CONT_C-expected_CONT_C).^2 ./expected_CONT_C); 
p_CONT_C = 1 - chi2cdf(chi2stat_CONT_C,1);



%% ipsilateral
%total prop contra- pre, MD VS CONTROL
p0_I_pre=(MD_KO_pre_I+CONT_KO_pre_I)/((MD_KO_totalcells-MD_KO_pre_U)+(CONT_KO_totalcells-CONT_KO_pre_U));
MD_I_exp_pre=(MD_KO_totalcells-MD_KO_pre_U)*p0_I_pre; 
CONT_I_exp_pre=(CONT_KO_totalcells-CONT_KO_pre_U)*p0_I_pre;

observed_I_pre=[MD_KO_pre_I (MD_KO_totalcells-MD_KO_pre_U)-MD_KO_pre_I CONT_KO_pre_I (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_KO_pre_I]; 
expected_I_pre=[MD_I_exp_pre (MD_KO_totalcells-MD_KO_pre_U)-MD_I_exp_pre CONT_I_exp_pre (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_I_exp_pre]; 

chi2stat_I_pre=sum((observed_I_pre-expected_I_pre).^2 ./expected_I_pre); 
p_I_pre = 1 - chi2cdf(chi2stat_I_pre,1);

%total prop contra - post
p0_I_post=(MD_KO_post_I+ CONT_KO_post_I)/((MD_KO_totalcells-MD_KO_post_U)+(CONT_KO_totalcells-CONT_KO_post_U));
MD_I_exp_post=(MD_KO_totalcells-MD_KO_post_U)*p0_I_post; 
CONT_I_exp_post=(CONT_KO_totalcells-CONT_KO_post_U)*p0_I_post;

observed_I_post=[MD_KO_post_I (MD_KO_totalcells-MD_KO_post_U)-MD_KO_post_I CONT_KO_post_I (CONT_KO_totalcells-CONT_KO_post_U)-CONT_KO_post_I]; 
expected_I_post=[MD_I_exp_post (MD_KO_totalcells-MD_KO_post_U)-MD_I_exp_post CONT_I_exp_post (CONT_KO_totalcells-CONT_KO_post_U)-CONT_I_exp_post]; 

chi2stat_I_post=sum((observed_I_post-expected_I_post).^2 ./expected_I_post); 
p_I_post = 1 - chi2cdf(chi2stat_I_post,1);


%MD prop contra- pre vs post 
p0_MD_I=(MD_KO_pre_I+ MD_KO_post_I)/((MD_KO_totalcells-MD_KO_pre_U)+(MD_KO_totalcells-MD_KO_post_U));
MD_I_exp_pre=(MD_KO_totalcells-MD_KO_pre_U)*p0_MD_I; 
MD_I_exp_post=(MD_KO_totalcells-MD_KO_post_U)*p0_MD_I;

observed_MD_I=[MD_KO_pre_I (MD_KO_totalcells-MD_KO_pre_U)-MD_KO_pre_I MD_KO_post_I (MD_KO_totalcells-MD_KO_post_U)-MD_KO_post_I]; 
expected_MD_I=[MD_I_exp_pre (MD_KO_totalcells-MD_KO_pre_U)-(MD_I_exp_pre) MD_I_exp_post (MD_KO_totalcells-MD_KO_post_U)-MD_I_exp_post]; 

chi2stat_MD_I=sum((observed_MD_I-expected_MD_I).^2 ./expected_MD_I); 
p_MD_I = 1 - chi2cdf(chi2stat_MD_I,1);

%CONT pre vs post contra
p0_CONT_I=(CONT_KO_pre_I+ CONT_KO_post_I)/((CONT_KO_totalcells-CONT_KO_pre_U)+(CONT_KO_totalcells-CONT_KO_post_U));
CONT_I_exp_pre=(CONT_KO_totalcells-CONT_KO_pre_U)*p0_CONT_I; 
CONT_I_exp_post=(CONT_KO_totalcells-CONT_KO_post_U)*p0_CONT_I;

observed_CONT_I=[CONT_KO_pre_I (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_KO_pre_I CONT_KO_post_I (CONT_KO_totalcells-CONT_KO_post_U)-CONT_KO_post_I]; 
expected_CONT_I=[CONT_I_exp_pre (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_I_exp_pre CONT_I_exp_post (CONT_KO_totalcells-CONT_KO_post_U)-CONT_I_exp_post]; 

chi2stat_CONT_I=sum((observed_CONT_I-expected_CONT_I).^2 ./expected_CONT_I); 
p_CONT_I = 1 - chi2cdf(chi2stat_CONT_I,1);


%% binocular 

%total prop binoc- pre, MD VS CONTROL
p0_B_pre=(MD_KO_pre_B+CONT_KO_pre_B)/((MD_KO_totalcells-MD_KO_pre_U)+(CONT_KO_totalcells-CONT_KO_pre_U));
MD_B_exp_pre=(MD_KO_totalcells-MD_KO_pre_U)*p0_B_pre; 
CONT_B_exp_pre=(CONT_KO_totalcells-CONT_KO_pre_U)*p0_B_pre;

observed_B_pre=[MD_KO_pre_B (MD_KO_totalcells-MD_KO_pre_U)-MD_KO_pre_B CONT_KO_pre_B (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_KO_pre_B]; 
expected_B_pre=[MD_B_exp_pre (MD_KO_totalcells-MD_KO_pre_U)-MD_B_exp_pre CONT_B_exp_pre (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_B_exp_pre]; 

chi2stat_B_pre=sum((observed_B_pre-expected_B_pre).^2 ./expected_B_pre); 
p_B_pre = 1 - chi2cdf(chi2stat_B_pre,1);

%total prop binoc - post
p0_B_post=(MD_KO_post_B+ CONT_KO_post_B)/((MD_KO_totalcells-MD_KO_post_U)+(CONT_KO_totalcells-CONT_KO_post_U));
MD_B_exp_post=(MD_KO_totalcells-MD_KO_post_U)*p0_B_post; 
CONT_B_exp_post=(CONT_KO_totalcells-CONT_KO_post_U)*p0_B_post;

observed_B_post=[MD_KO_post_B (MD_KO_totalcells-MD_KO_post_U)-MD_KO_post_B CONT_KO_post_B (CONT_KO_totalcells-CONT_KO_post_U)-CONT_KO_post_B]; 
expected_B_post=[MD_B_exp_post (MD_KO_totalcells-MD_KO_post_U)-MD_B_exp_post CONT_B_exp_post (CONT_KO_totalcells-CONT_KO_post_U)-CONT_B_exp_post]; 

chi2stat_B_post=sum((observed_B_post-expected_B_post).^2 ./expected_B_post); 
p_B_post = 1 - chi2cdf(chi2stat_B_post,1);


%MD prop BINOC- pre vs post 
p0_MD_B=(MD_KO_pre_B+ MD_KO_post_B)/((MD_KO_totalcells-MD_KO_pre_U)+(MD_KO_totalcells-MD_KO_post_U));
MD_B_exp_pre=(MD_KO_totalcells-MD_KO_pre_U)*p0_MD_B; 
MD_B_exp_post=(MD_KO_totalcells-MD_KO_post_U)*p0_MD_B;

observed_MD_B=[MD_KO_pre_B (MD_KO_totalcells-MD_KO_pre_U)-MD_KO_pre_B MD_KO_post_B (MD_KO_totalcells-MD_KO_post_U)-MD_KO_post_B]; 
expected_MD_B=[MD_B_exp_pre (MD_KO_totalcells-MD_KO_pre_U)-(MD_B_exp_pre) MD_B_exp_post (MD_KO_totalcells-MD_KO_post_U)-MD_B_exp_post]; 

chi2stat_MD_B=sum((observed_MD_B-expected_MD_B).^2 ./expected_MD_B); 
p_MD_B = 1 - chi2cdf(chi2stat_MD_B,1);

%CONT pre vs post BINOC
p0_BONT_B=(CONT_KO_pre_B+ CONT_KO_post_B)/((CONT_KO_totalcells-CONT_KO_pre_U)+(CONT_KO_totalcells-CONT_KO_post_U));
CONT_B_exp_pre=(CONT_KO_totalcells-CONT_KO_pre_U)*p0_BONT_B; 
CONT_B_exp_post=(CONT_KO_totalcells-CONT_KO_post_U)*p0_BONT_B;

observed_CONT_B=[CONT_KO_pre_B (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_KO_pre_B CONT_KO_post_B (CONT_KO_totalcells-CONT_KO_post_U)-CONT_KO_post_B]; 
expected_CONT_B=[CONT_B_exp_pre (CONT_KO_totalcells-CONT_KO_pre_U)-CONT_B_exp_pre CONT_B_exp_post (CONT_KO_totalcells-CONT_KO_post_U)-CONT_B_exp_post]; 

chi2stat_CONT_B=sum((observed_CONT_B-expected_CONT_B).^2 ./expected_CONT_B); 
p_CONT_B = 1 - chi2cdf(chi2stat_CONT_B,1);




%% save and store
% Bonferroni correction 
%n=number of pairwise comparisons for binocular cells, which is n 
%alpha/n = new p-value for significance

p_corr_4WAYtotal=0.05/4; 

%put in mat file and save 
char_pvalues_UandIandBandC=strings(17,1); 
char_pvalues_UandIandBandC(1)= 'U_pre'; 
char_pvalues_UandIandBandC(2)= 'U_post'; 
char_pvalues_UandIandBandC(3)= 'CONT_U'; 
char_pvalues_UandIandBandC(4)= 'MD_U'; 

char_pvalues_UandIandBandC(5)= 'I_pre'; 
char_pvalues_UandIandBandC(6)= 'I_post'; 
char_pvalues_UandIandBandC(7)= 'CONT_I'; 
char_pvalues_UandIandBandC(8)= 'MD_I'; 

char_pvalues_UandIandBandC(9)= 'C_pre'; 
char_pvalues_UandIandBandC(10)= 'C_post'; 
char_pvalues_UandIandBandC(11)= 'CONT_C'; 
char_pvalues_UandIandBandC(12)= 'MD_C'; 

char_pvalues_UandIandBandC(13)= 'B_pre'; 
char_pvalues_UandIandBandC(14)= 'B_post'; 
char_pvalues_UandIandBandC(15)= 'CONT_B'; 
char_pvalues_UandIandBandC(16)= 'MD_B'; 

char_pvalues_UandIandBandC(17)= 'p_corr'; 
 

pvalues_cellprop_UandIandBandC=vertcat(p_U_pre, p_U_post, p_CONT_U, p_MD_U,...
    p_I_pre, p_I_post, p_CONT_I, p_MD_I,...
    p_C_pre, p_C_post, p_CONT_C, p_MD_C,...
    p_B_pre, p_B_post, p_CONT_B, p_MD_B,...
    p_corr_4WAYtotal);
chi2_cellprop_UandIandBandC_results=table(char_pvalues_UandIandBandC, pvalues_cellprop_UandIandBandC);

%save
save(fullfile(SaveDir,'chi2_cellprop_UandIandBandC_results.mat'),'chi2_cellprop_UandIandBandC_results'); 
writetable(chi2_cellprop_UandIandBandC_results, fullfile(SaveDir,'chi2_cellprop_UandIandBandC_results.xls')); 
% 

end