function [pref_ori,cv] = getorituning(oris,resp_oris)
%INPUTS:
%oris: array containing unique oris (e.g. from 0 to 180)
%resp_oris: matrix containing avg cell responses to each condition. Each
%row is a different orientation and each column is a different cell 
%OUTPUTS: 
%Preferred orientation: pref_ori
%Circular variance, measure of orientation selectivity: cv 

numCellsresp=size(resp_oris);
pref_ori= zeros (1, numCellsresp(2)); %estimated best orientation for each cell 
cv=zeros(1,numCellsresp(2)); %circular variance for each cell, measure of orientation selectivity, 0 to 1 


oris_rad=deg2rad(oris);
resp_oris(resp_oris<0)=0; 

for j=1:numCellsresp(2) % do for each cell 
    resp_ori= resp_oris(:,j); 
    
    pref_ori(j)= rad2deg(0.5 .*(angle(sum(resp_ori.*exp(2.*1i*oris_rad))))); %calculate preferred orientation in rad, then convert to degrees
    if (pref_ori(j))<0
        pref_ori(j)= pref_ori(j)+180; %correction for orientation  
    end
     
    cv(j)=1-abs(sum(resp_ori.*exp(2*1i.*oris_rad))./sum(resp_ori)); %circular variance 
    
end 


end