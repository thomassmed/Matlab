%@(#)   utgles7.m 1.1	 06/04/23     11:36:17
%
%function utgles7(compfile,resfil,resfil2,compwork)
function utgles7(compfile,resfil,resfil2,compwork)
%
if nargin<2,
  resfil='utgles.results';
  disp('results will be printed on utgles.results and utgles2.results');
end
if nargin<3,
  resfil2='utgles2.results';
  if nargin>1, disp('Results2 will be printed on utgles2.results');end
end
if nargin<4,
  compwork='comp-work.txt';
end
%
[MANGRP,mangrp,crut,crantal,distfil,nrad,ierr]=readcomp7(compfile,compwork);
if ierr==0,
  fid=fopen(resfil,'w');
  fid2=fopen(resfil2,'w');
  i=findint(MANGRP,mangrp);
  i=find(i==0);
  nextgrp=MANGRP(i);
  keff=[];
  ite=0;
  while length(nextgrp)>0,
    ite=ite+1;
    for i=1:length(nextgrp),
      keff(ite,i)=newpolca(nextgrp(i),compwork,distfil,nrad);
    end    
    [k,ibest]=min(keff(ite,find(keff(ite,:))));
    mangrp=[mangrp nextgrp(ibest)];
    if length(nextgrp>1),
      newiter(nextgrp(ibest),compwork,nrad);
    end
    i=findint(MANGRP,mangrp);i=find(i);crsum=100*sum(crantal(i));
    fprintf(fid,'%2i ',ite);fprintf(fid,'%6i%s',crsum,' % ');fprintf(fid,'%2i ',mangrp);fprintf(fid,'%9.5f',k);
    fprintf(fid2,'%2i ',ite);fprintf(fid2,'%6i ',nextgrp);fprintf(fid2,'\n');
    fprintf(fid2,'%2i ',ite);fprintf(fid2,'%7i',round(1e5*keff(ite,find(keff(ite,:)))));
    fprintf(fid,'\n');
    fprintf(fid2,'\n');
    nrad=nrad+1;
    nextgrp(ibest)=[];
  end
end
fclose(fid);
fclose(fid2);
