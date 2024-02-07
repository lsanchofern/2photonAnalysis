function plotROIandtrace(ops,cell_stat,alldFoF,num_visresp, indices)
%plot each cell ROI and a section of the dFoF trace

global anim 
global SaveDir
global SaveDir1 

AnalDir= strcat(SaveDir, 'Figures\ROIsanddFoFtraces\');
    if iscell(AnalDir)
        AnalDir=AnalDir{1}; 
    end
    if ~exist(AnalDir)
        mkdir(AnalDir)
    end


meanImg=ops.meanImg; 

for n=1:num_visresp
    f(n)=figure ('Visible', 'off');
    tiledlayout(f(n),2,1)
    nexttile
    c1=gray; colormap(c1);
    top=min(cell_stat{1,indices(1).respcells(n)}.ypix); 
    bottom= max(cell_stat{1,indices(1).respcells(n)}.ypix);
    left=min(cell_stat{1,indices(1).respcells(n)}.xpix); 
    right=max(cell_stat{1,indices(1).respcells(n)}.xpix); 
    imagesc(meanImg(top:bottom, left:right));    
    set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', ''); 
    box off

    nexttile
    plot(alldFoF(n,5000:20000),'black')
    set(gca, 'XTick', [], 'XTickLabel', '',  'YTick', [], 'YTickLabel', '');
    box off 
    hold on 
    plot ([10000;10000],[-.5; -.4],'k', [10000; 10750],[-.5;-.5],'k', 'LineWidth', 2); %scale bar 
    text(10100, -.4, '10% dF/F', 'FontSize',10) %scale bar label 
    text (10050, -.47, '50 s') %scale bar 
    hold off 


    cellname=strcat('cellID_', num2str(indices(1).respcells(n)));
    saveas (f(n), fullfile(AnalDir, strcat('ROIdFoF_', cellname)), 'pdf'); 
    saveas (f(n), fullfile(AnalDir, strcat('ROIdFoF_', cellname)), 'fig'); 
    saveas (f(n), fullfile(AnalDir, strcat('ROIdFoF_', cellname)), 'tif');

end



end