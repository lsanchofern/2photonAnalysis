function Y_fit = gaussian_fit(x,parameters)

% PARAMETERS = [Rsp Rp Op sig Rn]
% 
% parameters correspond to Carrandini fit parameters where
% Rsp=offset,Rp=peak parameter of first gaussian, 0p=location of first
% peak, sig=width parameter, Rn=peak parameter of second gaussian
% and takes the angle difference between the first peak and second peak

Rsp = parameters(1);
Rp = parameters(2);
Op = parameters(3);
sig = parameters(4);
Rn = parameters(5);

dg = Rsp+Rp*exp(-angdiff(Op-x).^2/(2*sig^2));
dg = reshape(dg, size(x));

end