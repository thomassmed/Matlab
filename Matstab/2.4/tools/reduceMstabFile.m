function reduceMstabFile
% reduceMstabFile
% Reduces the size of the MstabFile to a minimum by only saving 
% msopt, keff, lam, and the distributions Ppower, Pvoid, efi1, evoid 


global msopt stab steady

% save original structures
org.steady=steady;
org.stab=stab;

% create distributions
edist=matstab2polca(stab.e);
efi1=edist.fa1;
evoid=edist.void;

if msopt.Harmonics>0,
  lamh=stab.lamh;
  eh=stab.eh;
end
stab=struct('lam',stab.lam);
if msopt.Harmonics>0,
  stab.lamh=lamh;
  stab.eh=eh;
end
steady=struct('Ppower',steady.Ppower,'Pvoid',steady.Pvoid','keff',steady.keff);

save(msopt.MstabFile,'msopt','evoid','efi1','stab','steady')

% reset the original structures
steady=org.steady;
stab=org.stab;
