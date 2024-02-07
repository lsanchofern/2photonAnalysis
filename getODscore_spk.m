function [ODscore] = getODscore_spk(spks,spk_id_resp)
%ODI = (C-I)/(C+I);  
%normalize to min, max first 

    
for i=1: length(spk_id_resp) %for each cell at max ori response 
    %normalize to min, max
       all_contrapeaks(i)=max(spks.cells(spk_id_resp(i)).contra.oriresps); 
       all_ipsipeaks(i)=max(spks.cells(spk_id_resp(i)).ipsi.oriresps); 
     
end

for i=1:length(spk_id_resp)
    %normalize
    contra_norm(i)=(all_contrapeaks(i)-min(all_contrapeaks))/(max(all_contrapeaks)-min(all_contrapeaks)); 
    ipsi_norm(i)=(all_ipsipeaks(i)-min(all_ipsipeaks))/(max(all_ipsipeaks)-min(all_ipsipeaks)); 
end

%get OD score 
ODscore=(contra_norm-ipsi_norm)./(contra_norm+ipsi_norm);
end