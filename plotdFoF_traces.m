function plotdFoF_traces(SigCells,varargin)
%plot dFoF during the stimulus presentation, with the average cell response
%in bold 
%INPUTS:
%SigCells structures containing the significant cells and the traces 

global anim 
global SaveDir
global SaveDir1 

if varargin{1}=='drift'
    AnalDir= strcat(SaveDir, 'Figures\dFoFtraces\');
    if iscell(AnalDir)
        AnalDir=AnalDir{1}; 
    end
    if ~exist(AnalDir)
        mkdir(AnalDir)
    end
elseif varargin{1}=='flash'
    AnalDir= strcat(SaveDir1, 'Figures\dFoFtraces\');
    if iscell(AnalDir)
        AnalDir=AnalDir{1}; 
    end
    if ~exist(AnalDir)
        mkdir(AnalDir)
    end
end

if varargin{1}=='drift' %plot only responses for directions 
    oris=zeros(1,length(SigCells.AllCells(1).ori)); 

    for k=1:length(SigCells.AllCells(1).ori)
    oris(k)=SigCells.AllCells(1).ori(k).cond.contra; 
    end

% all cells 
AllcontraDir= strcat(AnalDir, 'AllCells\Contra');
if iscell(AllcontraDir)
    AllcontraDir=AllcontraDir{1}; 
end
if ~exist(AllcontraDir)
    mkdir(AllcontraDir)
end

AllcontraIpsi= strcat(AnalDir, 'AllCells\Ipsi');

if iscell(AllcontraIpsi)
    AllcontraIpsi=AllcontraIpsi{1}; 
end
if ~exist(AllcontraIpsi)
    mkdir(AllcontraIpsi)
end

%For all responsive cells, regardless of "binocularity" or not 
for i=1:length(SigCells.AllCells)
    f=figure ('Visible', 'off'); %contra
    t=tiledlayout(f, 4,4); %contra 

    f1=figure ('Visible', 'off'); %ipsi
    t1=tiledlayout(f1, 4,4); %ipsi 

    for j=1:length(oris)%contralateral responses 
        ax(j)=nexttile(t);
        sizegraph=size(SigCells.AllCells(i).ori(j).trace.contra);
        for k=1:sizegraph(1) %for each rep/trace
            plot(squeeze(SigCells.AllCells(i).ori(j).trace.contra(k,:)), 'Color', [.7 .7 .7]); 
            
            hold on 
        end 
        plot(squeeze(SigCells.AllCells(i).ori(j).avgtrace.contra), 'Color', 'black','LineWidth', 1.5);
        title(ax(j),['Direction: ', num2str(oris(j))]); 
        hold off
    end 
    for p=1:length(oris) %ipsilateral responses 
        ax1(p)=nexttile(t1); 
        sizegraph2=size(SigCells.AllCells(i).ori(p).trace.ipsi);
        for k=1:sizegraph2(1) %for each rep/trace
            plot(squeeze(SigCells.AllCells(i).ori(p).trace.ipsi(k,:)), 'Color', [.7 .7 .7]); 
            hold on 
        end  
        plot(squeeze(SigCells.AllCells(i).ori(p).avgtrace.ipsi), 'Color', 'black','LineWidth', 1.5);
        title(ax1(p), ['Direction: ', num2str(oris(p))]);
        hold off 
    end
    cellname=strcat('cellID_', num2str(SigCells.AllCells(i).ID));
    saveas (f, fullfile(AllcontraDir, strcat('dFoF_', cellname)), 'pdf'); 
    saveas (f, fullfile(AllcontraDir, strcat('dFoF_', cellname)), 'fig'); 
    saveas (f, fullfile(AllcontraDir, strcat('dFoF_', cellname)), 'tif');
    saveas (f1, fullfile(AllcontraIpsi, strcat('dFoF_', cellname)), 'pdf'); 
    saveas (f1, fullfile(AllcontraIpsi, strcat('dFoF_', cellname)), 'fig'); 
    saveas (f1, fullfile(AllcontraIpsi, strcat('dFoF_', cellname)), 'tif'); 
end

%monocular-contralateral/ipsilateral
ContraCell= strcat(AnalDir, 'ContraCells');
if iscell(ContraCell)
    ContraCell=ContraCell{1}; 
end
if ~exist(ContraCell)
    mkdir(ContraCell)
end

IpsiCell= strcat(AnalDir, 'IpsiCells');

if iscell(IpsiCell)
    IpsiCell=IpsiCell{1}; 
end
if ~exist(IpsiCell)
    mkdir(IpsiCell)
end

for i=1:length(SigCells.ContraCell)
    f=figure ('Visible', 'off'); %contra
    t=tiledlayout(f, 4,4); %contra 
    for j=1:length(oris)%contralateral responses 
        ax(j)=nexttile(t);
        sizegraph=size(SigCells.ContraCell(i).ori(j).trace);
        for k=1:sizegraph(1) %for each rep/trace
            plot(squeeze(SigCells.ContraCell(i).ori(j).trace(k,:)), 'Color', [.7 .7 .7]); 
            
            hold on 
        end 
        plot(squeeze(SigCells.ContraCell(i).ori(j).avgtrace), 'Color', 'black','LineWidth', 1.5);
        title(ax(j),['Direction: ', num2str(oris(j))]); 
        hold off
    end 
    cellname=strcat('cellID_', num2str(SigCells.ContraCell(i).ID));
    saveas (f, fullfile(ContraCell, strcat('dFoF_', cellname)), 'pdf'); 
    saveas (f, fullfile(ContraCell, strcat('dFoF_', cellname)), 'fig'); 
    saveas (f, fullfile(ContraCell, strcat('dFoF_', cellname)), 'tif');

end 

for i=1:length(SigCells.IpsiCell)
    f1=figure ('Visible', 'off'); %ipsi
    t1=tiledlayout(f1, 4,4); %ipsi 
    for p=1:length(oris) %ipsilateral responses 
        ax1(p)=nexttile(t1); 
        sizegraph2=size(SigCells.IpsiCell(i).ori(p).trace);
        for k=1:sizegraph2(1) %for each rep/trace
            plot(squeeze(SigCells.IpsiCell(i).ori(p).trace(k,:)), 'Color', [.7 .7 .7]); 
            hold on 
        end  
        plot(squeeze(SigCells.IpsiCell(i).ori(p).avgtrace), 'Color', 'black','LineWidth', 1.5);
        title(ax1(p), ['Direction: ', num2str(oris(p))]);
        hold off 
    end
    cellname=strcat('cellID_', num2str(SigCells.IpsiCell(i).ID));
    saveas (f1, fullfile(IpsiCell, strcat('dFoF_', cellname)), 'pdf'); 
    saveas (f1, fullfile(IpsiCell, strcat('dFoF_', cellname)), 'fig'); 
    saveas (f1, fullfile(IpsiCell, strcat('dFoF_', cellname)), 'tif'); 
end

%BINOCULAR 

BinocContra= strcat(AnalDir, 'Binoc\Contra');
if iscell(BinocContra)
    BinocContra=BinocContra{1}; 
end
if ~exist(BinocContra)
    mkdir(BinocContra)
end

BinocIpsi= strcat(AnalDir, 'Binoc\Ipsi');

if iscell(BinocIpsi)
    BinocIpsi=BinocIpsi{1}; 
end
if ~exist(BinocIpsi)
    mkdir(BinocIpsi)
end

%For all responsive cells, regardless of "binocularity" or not 
for i=1:length(SigCells.BinocCell)
    f=figure ('Visible', 'off'); %contra
    t=tiledlayout(f, 4,4); %contra 

    f1=figure ('Visible', 'off'); %ipsi
    t1=tiledlayout(f1, 4,4); %ipsi 

    for j=1:length(oris)%contralateral responses 
        ax(j)=nexttile(t);
        sizegraph=size(SigCells.BinocCell(i).ori(j).trace.contra);
        for k=1:sizegraph(1) %for each rep/trace
            plot(squeeze(SigCells.BinocCell(i).ori(j).trace.contra(k,:)), 'Color', [.7 .7 .7]); 
            
            hold on 
        end 
        plot(squeeze(SigCells.BinocCell(i).ori(j).avgtrace.contra), 'Color', 'black','LineWidth', 1.5);
        title(ax(j),['Direction: ', num2str(oris(j))]); 
        hold off
    end 
    for p=1:length(oris) %ipsilateral responses 
        ax1(p)=nexttile(t1); 
        sizegraph2=size(SigCells.BinocCell(i).ori(p).trace.ipsi);
        for k=1:sizegraph2(1) %for each rep/trace
            plot(squeeze(SigCells.BinocCell(i).ori(p).trace.ipsi(k,:)), 'Color', [.7 .7 .7]); 
            hold on 
        end  
        plot(squeeze(SigCells.BinocCell(i).ori(p).avgtrace.ipsi), 'Color', 'black','LineWidth', 1.5);
        title(ax1(p), ['Direction: ', num2str(oris(p))]);
        hold off 
    end
    cellname=strcat('cellID_', num2str(SigCells.BinocCell(i).ID));
    saveas (f, fullfile(BinocContra, strcat('dFoF_', cellname)), 'pdf'); 
    saveas (f, fullfile(BinocContra, strcat('dFoF_', cellname)), 'fig'); 
    saveas (f, fullfile(BinocContra, strcat('dFoF_', cellname)), 'tif');
    saveas (f1, fullfile(BinocIpsi, strcat('dFoF_', cellname)), 'pdf'); 
    saveas (f1, fullfile(BinocIpsi, strcat('dFoF_', cellname)), 'fig'); 
    saveas (f1, fullfile(BinocIpsi, strcat('dFoF_', cellname)), 'tif'); 
end


end




end