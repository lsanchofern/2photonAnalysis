function plotDSI(SigCells)
%plot DSI 
%DSI: 1-cirvar

global SaveDir 
global anim 

%contralateral cells monocular 
for i=1:length(SigCells.ContraCell)
    dsi_contra(i)=1-SigCells.ContraCell(i).cv_ori; 
end
%ipsilateral cells monocular 
for i=1:length(SigCells.IpsiCell)
    dsi_ipsi(i)=1-SigCells.IpsiCell(i).cv_ori; 
end
%Binocular- contralateral
for i=1:length(SigCells.BinocCell)
    dsi_binoc_contra(i)=1-SigCells.BinocCell(i).cv_ori.contra; 
end
%Binocular- ipsilateral  
for i=1:length(SigCells.BinocCell)
    dsi_binoc_ipsi(i)=1-SigCells.BinocCell(i).cv_ori.ipsi; 
end

avg_dsi_contra=mean(dsi_contra, 'omitnan'); 
avg_dsi_ipsi=mean(dsi_ipsi,'omitnan');
avg_dsi_binoc_contra=mean(dsi_binoc_contra, 'omitnan');
avg_dsi_binoc_ipsi=mean(dsi_binoc_ipsi, 'omitnan');
x1=ones(1,length(dsi_contra));
x2=2*ones(1,length(dsi_ipsi));
x3=3*ones(1,length(dsi_binoc_contra));
x4=4*ones(1,length(dsi_binoc_ipsi));

figDSI=figure('Visible', 'on'); 
c=[0.4660 0.6740 0.1880]; 
swarmchart (x1, dsi_contra, 50, c); 
hold on 
c2=[0.3010 0.7450 0.9330];
swarmchart (x2, dsi_ipsi, 50, c2);
hold on
c3=[0.4660 0.6740 0.1880]; 
swarmchart (x3, dsi_binoc_contra, 50, c3);
hold on 
c4=[0.3010 0.7450 0.9330];
swarmchart (x4, dsi_binoc_ipsi, 50, c4);
hold on 

swarmchart (x1, avg_dsi_contra, 100, c, 'filled', 'MarkerEdgeColor','black'); 
hold on 
swarmchart (x2, avg_dsi_ipsi, 100, c2, 'filled', 'MarkerEdgeColor','black');
hold on
swarmchart (x3, avg_dsi_binoc_contra, 100, c3, 'filled', 'MarkerEdgeColor','black');
hold on 
swarmchart (x4, avg_dsi_binoc_ipsi, 100, c4, 'filled', 'MarkerEdgeColor','black');
ylim([0 1]); 
title('Direction Selectivity Index')
hold off 

name2=strcat(anim, '_DSI');
saveas(figDSI,fullfile(SaveDir,name2), 'pdf');
saveas(figDSI,fullfile(SaveDir,name2), 'tif');


end

