function e=dist2mstab(dist,distfil)
% e=dist2mstab(dist,distfil)
% Translates "POLCA-distribution" matrix, ( i.e. a (25,676)-matrix for Forsmark 1 and 2)
% to a vector of matstab
%
% Input:
%  dist    - POLCA-distribution
%  distfil - Distribution file
%
% Input from global:
%  ISYM    - Symmetry according to RAMONA
%  NTOT    - Number of elements in matstab-vector
%
%
% Output:
% e        - MATSTAB  NTOT by 1-vector

global NTOT ISYM

%@(#)   dist2mstab.m 1.3   99/02/08     07:28:53

isym=ISYM;
[dum,mminj,konrod,bb,hy,mz]=readdist7(distfil);
iimax=length(mminj); 
kan=sum(iimax-2*(mminj-1)); 
%kmax=mz(4);
kmax = mz(17);	%Korrigerat, eml 060425
kanramona=NTOT/kmax;
knum=ramnum2knum(mminj,1:kanramona,isym);
e=dist(:,knum(:,1));
e=e(:);
