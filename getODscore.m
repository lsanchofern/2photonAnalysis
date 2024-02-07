function [ODscore] = getODscore(AllCells)
%ODI = (C-I)/(C+I);  
%normalize to min, max first 


for i=1: length(AllCells) %for each cell 
    %normalize to min, max
       all_contrapeaks(i)=AllCells(i).oripeak.contra; 
       all_ipsipeaks(i)=AllCells(i).oripeak.ipsi; 
end

% for i=1:length(AllCells)
%     %normalize
%     contra_norm(i)=(all_contrapeaks(i)-min(all_contrapeaks))/(max(all_contrapeaks)-min(all_contrapeaks)); 
%     ipsi_norm(i)=(all_ipsipeaks(i)-min(all_ipsipeaks))/(max(all_ipsipeaks)-min(all_ipsipeaks)); 
% end

%get OD score 
% ODscore=(contra_norm-ipsi_norm)./(contra_norm+ipsi_norm);
ODscore=(all_contrapeaks-all_ipsipeaks)./(all_contrapeaks+all_ipsipeaks); 




for i=1:length(ODscore)
    if ODscore(i)<-1
        ODscore(i)=-1;
    elseif ODscore(i)>1
        ODscore(i)=1;
    end
end

ODscore; 
end