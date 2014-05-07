function y=bakerjust(T,W,t);
%y=bakerjust(T,W,t);
%
%Baker-Just correlation for the cladding two side 
%oxidation criterion, 17%
%
%T  -  Oxidation temperature [K]
%W  -  Wall thickness [mm]
%t  -  Oxidation time [s]
%
%y  -  Oxidation ratio [%]


y = 3250./W.*exp(-11690./T).*sqrt(t);
