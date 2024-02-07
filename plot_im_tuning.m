function  plot_im_tuning(ops, cell_stat, numCells, indices,SigCellsDrift, SigCellsFlash)
% plot color coded map of preferred positions against the mean image

global SaveDir
global SaveDir1

im=zeros(512,756); 
im2=zeros(512,756); 
im3=zeros(512,756); 
for n=1:length(SigCellsDrift.All)
    for q=1:length(cell_stat{1,indices(1).respcells(n)}.ypix)
        ydata(n,q)= cell_stat{1,indices(1).respcells(n)}.ypix(q); 
        xdata(n,q)=cell_stat{1,indices(1).respcells(n)}.xpix(q);
        im(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= 1; 
        im2(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= sp_peak(n);
        im3(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= ori_peak(n)+100;  
        im3(cell_stat{1,indices(1).respcells(n)}.ypix(q), cell_stat{1, indices(1).respcells(n)}.xpix(q))= ori_peak(n)+100; 
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
tiledlayout(1,3)
nexttile
p2=imagesc(im2, 'AlphaDataMapping','none');
set(p2, 'AlphaData', roimask); %make background transparent
CellColorMap=turbo(256);
CellColorMap(1,:) = 1;
colormap(CellColorMap)
bar1=colorbar; 
bar1.Label.String= 'Spatial frequency'; 
bar1.Label.FontSize= 10; 
bar1.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 

nexttile
p3=imagesc(im3, 'AlphaDataMapping','none');
set(p3, 'AlphaData', roimask); %make background transparent
CellColorMap=turbo(256);
CellColorMap(1,:) = 1;
colormap(CellColorMap)
bar3=colorbar; 
bar3.Label.String= 'Orientation'; 
bar3.Label.FontSize= 10; 
bar3.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
clim([100 460]); 

nexttile
p4=imagesc(im4, 'AlphaDataMapping','none');
set(p3, 'AlphaData', roimask); %make background transparent
CellColorMap=turbo(256);
CellColorMap(1,:) = 1;
colormap(CellColorMap)
bar3=colorbar; 
bar3.Label.String= 'Orientation'; 
bar3.Label.FontSize= 10; 
bar3.Location="southoutside";
set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
clim([100 460]); 


%colorbar scale is modified so that 0 is not the background 

%save plots 

SaveDir; 

saveas(f2, fullfile(SaveDir,'MeanImage'), 'tif'); 
saveas(f2, fullfile(SaveDir,'MeanImage'), 'pdf'); 
saveas(f2, fullfile(SaveDir,'MeanImage'), 'fig'); 

saveas(f3, fullfile(SaveDir,'MeanResponsesRetinotopy'), 'tif'); 
saveas(f3, fullfile(SaveDir,'MeanResponsesRetinotopy'), 'pdf'); 
saveas(f3, fullfile(SaveDir,'MeanResponsesRetinotopy'), 'fig'); 

