function [efi1,evoid,efi2,vfi1,vfi2]=f_matstab2dist(matfil,harmonics);
% [efi1,evoid,efi2]=f_matstab2dist(matfil);
% Uses matfil for matstab results and 'f_polca' saved on matfil  
if nargin < 2
  harmonics=0;
end

% lagt till nedladdning av polcadata nedan då denna krävs i nya mstab2dist
load(matfil,'msopt','stab','geom','steady','termo','polcadata');
distfile=msopt.DistFile;

global msopt geom termo

disp(['POLCA distr. file: ',distfile]);

e=stab.e;
k=geom.k;
r=geom.r;
fa1=steady.fa1;
fa2=steady.fa2;
isym=msopt.CoreSym;


if harmonics
    eh=stab.eh;
    efi1=mstab2disth(eh(k,harmonics),distfile,isym);
    if nargout>1,
      evoid=mstab2disth(eh(r,harmonics),distfile,isym);
    end
    if nargout>2,
      efi2=mstab2disth(eh(k,harmonics).*fa2./fa1,distfile,isym);
    end
    if nargout>3,
      vh=stab.vh;
      vfi1=mstab2disth(vh(r,harmonics),distfile,isym);
    end
    if nargout>4,
      vfi2=mstab2disth(vh(k,harmonics).*fa2./fa1,distfile,isym);
    end
else
  efi1=mstab2dist(e(k),distfile,isym);
  if nargout>1,
    evoid=mstab2dist(e(r),distfile,isym);
  end
  if nargout>2,
    efi2=mstab2dist(e(k).*fa2./fa1,distfile,isym);
  end
  if nargout>3,
    v=stab.v;
    vfi1=mstab2dist(v(r),distfile,isym);
  end
  if nargout>4,
    vfi2=mstab2dist(v(k).*fa2./fa1,distfile,isym);
  end
end
