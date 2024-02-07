function  plot_im_retinotopy(ops, cell_stat, numvisresp, indices,azimuth_peak_degrees,altitude_peak_degrees)
% plot color coded map of preferred positions against the mean image

global SaveDir 
global anim 

im=zeros(512,756); 
im2=zeros(512,756); 
im3=zeros(512,756); 
for n=1:numvisresp
    for q=1:length(cell_stat{1,indices(1).respcells(n)}.ypix)
        ydata(n,q)= cell_stat{1,indices(1).respcells(n)}.ypix(q); 
        xdata(n,q)=cell_stat{1,indices(1).respcells(n)}.xpix(q);
        im(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= 1; 
        im2(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= azimuth_peak_degrees(n)+100;
        im3(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= altitude_peak_degrees(n)+100;    
    end    
end

%im is binary mask for transparency
roimask=im; 

%plot meanImg 
f1= figure; 
c1=gray; 
ax1=axes; 
colormap(c1); 
imagesc(ops.meanImg); %this image is 512x 796
set(gca, 'XTickLabel',  '', 'YTickLabel', ''); 

f2=figure('Name', 'Color coded responses', 'NumberTitle','off'); 
tiledlayout(1,2)
nexttile
p2=imagesc(im2, 'AlphaDataMapping','none');
set(p2, 'AlphaData', roimask); %make background transparent
CellColorMap=turbo(256); %make colormap
CellColorMap(1,:) = 1; %make first value white 
colormap(CellColorMap)
bar1=colorbar; 
bar1.Label.String= 'Azimuth (degrees)'; 
bar1.Label.FontSize= 10; 
bar1.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
set(bar1, 'XTickLabel', {'20','40','60', '80', '100','120', '140'},...
    'XTick', 20:20:140); 
clim([20 140]); 
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 

nexttile
f3=imagesc(im3, 'AlphaDataMapping','none');
set(f3, 'AlphaData', roimask); %make background transparent
CellColorMap=turbo(256);
CellColorMap(1,:) = 1;
colormap(CellColorMap)
bar3=colorbar; 
bar3.Label.String= 'Elevation (degrees)'; 
bar3.Label.FontSize= 10; 
bar3.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
set(bar3, 'XTickLabel', {'65','75','85', '95', '105','115'},...
    'XTick', 65:10:115); 
clim([65 115]); 

%colorbar scale is modified so that 0 is not the background 

%save plots 
saveas(f1, fullfile(SaveDir, strcat(anim, '_MeanImage')), 'tif'); 
saveas(f1, fullfile(SaveDir, strcat(anim, '_MeanImage')), 'pdf'); 
saveas(f1, fullfile(SaveDir,strcat(anim, '_MeanImage')), 'fig'); 

saveas(f2, fullfile(SaveDir, strcat(anim, '_MeanResponsesRetinotopy')), 'tif'); 
saveas(f2, fullfile(SaveDir,strcat(anim, '_MeanResponsesRetinotopy')), 'pdf'); 
saveas(f2, fullfile(SaveDir,strcat(anim, '_MeanResponsesRetinotopy')), 'fig'); 

