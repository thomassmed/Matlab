%@(#)   readcomp7.m 1.1	 06/04/23     11:36:08
%
%function [MANGRP,mangrp,crut,crantal,distfil,nrad,ierr]=readcomp7(compfile,compwork)
function [MANGRP,mangrp,crut,crantal,distfil,nrad,ierr]=readcomp7(compfile,compwork)
if nargin<2, compwork='comp-slask.txt';end
fut=fopen(compwork,'w');
fid=fopen(compfile,'r');
nrad=0;
rad=fgetl(fid);nrad=nrad+1;
fprintf(fut,'%s\n',rad);
while ~strcmp(upper(rad(1:4)),'SAVE')
  rad=fgetl(fid);nrad=nrad+1;
  fprintf(fut,'%s\n',rad);
end
[A,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
rad=rad(NEXTINDEX:length(rad));
[distfil,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
i=find(distfil=='=');
if length(i)>0, distfil=distfil(1:i-1); end
rad=fgetl(fid);nrad=nrad+1;
fprintf(fut,'%s\n',rad);
mgrp=[];
mangrp=[];
bryt=0;
crut=[];
while rad~=-1,
  if length(remblank(rad))==0, bryt=1;nrad=nrad-1;end
  if strcmp(upper(remblank(rad)),'END'), bryt=1;nrad=nrad-1; end
  if bryt==1,
    rad=-1;
  else
    rad=fgetl(fid);nrad=nrad+1;
    if length(rad)>6,
      if strcmp(upper(rad(1:6)),'MANGRP'),
        mgrp=[mgrp  sscanf(rad(8:find(rad=='=')-1),'%i')];
        i=length(mgrp);crantal(i)=length(find(rad==','))+1;
      end
      if strcmp(upper(rad(1:6)),'CONROD'),
        istop=find(rad=='=');
	istart=find(rad==',');
	slutflag=0;
        if max(istop)>max(istart),slutflag=1;end
	if isempty(istart), slutflag=1; end
	if strcmp(rad(7),'*'),
	  istart=[8 istart];
	  for i=1:length(istop),
	     mangrp=[mangrp sscanf(rad(istart(i)+1:istop(i)-1),'%i')];
	  end
          istart(1)=[];
	  if length(istop)>length(istart), istart=[istart length(deblank(rad))+1]; end
          for i=1:length(istop),
	     crut=[crut sscanf(rad(istop(i)+1:istart(i)-1),'%f')];
	  end
	  if slutflag, rad=[rad,',']; end
        else
          if ~findstr(upper(rad),'ALL')|length(find(rad=='='))>1,
	    ierr=1;
	    error('First CONROD statement MUST be: CONROD  ALL=0');
	  end
          if slutflag, rad=[rad,',']; end
	end
      end
    end
  end
  if isstr(rad),
    if ~strcmp(upper(remblank(rad)),'END'),
      fprintf(fut,'%s\n',rad);
    end
  end
end
MANGRP=mgrp;
ierr=0;
fclose(fut);
fclose(fid);
