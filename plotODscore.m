function  plotODscore(ODscore, directory, condition)
%make a distribution of the ODScore 


%bin size
step=.1; 

bins_OD=min(ODscore):step:max(ODscore); 
dist_OD=hist(ODscore,bins_OD); %get the distribution
ndist_OD= dist_OD/ sum(dist_OD); %normalize to 0 -1 
cdist_OD=cumsum(ndist_OD); %cumulative distribution 


%plot distribution  
fOD=figure('Visible','on'); 
plot(bins_OD, cdist_OD, 'LineWidth',1.5, 'Color', 'black');
ylim ([0 1])
xlim ([-1 1])
title ('ODI')
ylabel('cumulative probability', 'FontSize',10)
xlabel ('OD score', 'FontSize',12)
set(gca, 'TickLength', [.01 .05],'TickDir', 'out')
box off 
title(condition)

saveas(fOD, fullfile(directory, strcat(condition, '_ODScore_prob')), 'tif');
saveas(fOD, fullfile(directory, strcat(condition, '_ODScore_prob')), 'pdf');
saveas(fOD, fullfile(directory, strcat(condition, '_ODScore_prob')), 'fig');

%plot histogram 
h1=histogram(ODscore, 10, 'FaceColor', [0.4660 0.6740 0.1880]);
xlim([-1 1]); 
title(condition)
saveas(h1, fullfile(directory,strcat(condition, '_ODScore_prob')), 'tif'); 
saveas(h1, fullfile(directory,strcat(condition, '_ODScore_prob')), 'pdf'); 
saveas(h1, fullfile(directory,strcat(condition, '_ODScore_prob')), 'fig'); 

end