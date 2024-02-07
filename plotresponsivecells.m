function plotresponsivecells(num_visresp,numCells, exp)
%plot percent responsive cells as a bar graph 

global SaveDir 
global anim 

notresp=numCells-num_visresp; 
percent_visresp=(num_visresp/numCells)*100;
percent_notresp=(notresp/numCells)*100; 

y=[percent_visresp percent_notresp]; 

labels={'Responsive','Not responsive'};

f1=figure('Name', 'Visually responsive neurons', 'NumberTitle','off'); 

h= pie (y, '%.1f%%');
ldg=legend(labels, 'Location', 'southoutside'); 
newColors=[...
    0.3010, 0.7450, 0.9330;
    0.4660, 0.6740, 0.1880]; 

patchHand=findobj(h,'Type', 'Patch');
set(patchHand, {'FaceColor'}, mat2cell(newColors, ones(size(newColors,1),1), 3)); 
title(exp); %label depending on experiment type (drifting or flashing) 


%save plot 

saveas(f1, fullfile(SaveDir, strcat(anim, '_PercentResponsiveNeurons')), 'tif'); 
saveas(f1, fullfile(SaveDir,strcat(anim, '_PercentResponsiveNeurons')), 'pdf'); 
saveas(f1, fullfile(SaveDir,strcat(anim, '_PercentResponsiveNeurons')), 'fig'); 

end