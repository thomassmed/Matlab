% function [efi1,evoid,efi2]=en_vs_pow(disfil)
function [efi1,evoid,efi2]=en_vs_pow(matfil)	% Korrigerat fr�n disfil till matfil d� det �r matstabfilen 
						% som ges som indata till f_matstab2dist, eml 060425

load(matfil,'msopt');				% H�mtar distfil ur matstabfil, eml 060425
disfil=msopt.DistFile;

[efi1,evoid,efi2]=f_matstab2dist(matfil);

en_dis=abs(efi1);
distplot(disfil,'power',upleft);
distplot(disfil,'power',upright,en_dis);
