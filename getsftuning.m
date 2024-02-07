function [pref_sf] = getsftuning(sfs, resp_sfs)


resp_sfs(resp_sfs<0)=0; 
pref_sf= zeros (1, numCellsresp(2)); %estimated best sf for each cell 

for j=1:numCellsresp(2) % do for each cell 
   resp_sf= resp_sfs(:,j);     
    pref_sf(j)  = 10^(sum(resp_sf.*log10(sfs))/sum(resp_sf));
end 


end
