%@(#)   readtipfiles.m 1.7	 05/12/08     15:59:08
%
function [tipfiles,nc,cycles,efphc]=readtipfiles(tipfil)
tipfiles=[];cycles=[];
fid=fopen(tipfil,'r');
if fid~=-1
  titel=fgetl(fid);
  if ~strcmp(upper(titel(1:3)),'TIT')
    tipfiles=str2mat(tipfiles,titel);
  end
  for i=1:1000,
    rad=fgetl(fid);
    if ~isstr(rad), break;end
    if strcmp(upper(rad(1:3)),'END'), break;end
    tipfiles=str2mat(tipfiles,rad);
  end
  tipfiles(1,:)='';
  nc(1)=1;
  lt=size(tipfiles,1);
  id=find(tipfiles(1,:)=='/');
  [CYCLES,efph]=getcycles(tipfiles(1,1:id(3)));
  CYCLES=lower(CYCLES);
  for i=1:100,
    id=find(tipfiles(nc(i),:)=='/');
    lid=id(length(id));
    cycdir=tipfiles(nc(i),1:lid);
    cycle=cycdir(id(3)+1:id(4)-1);
    c=[cycle setstr(32*ones(1,size(CYCLES,2)-length(cycle)))];
    icyc=strmatch(c,CYCLES);
    efphc(i)=efph(icyc);
    cycles=str2mat(cycles,remblank(CYCLES(icyc,:)));
    nnc=nc(i)+1;
    for j=nc(i)+1:lt
        if ~strcmp(tipfiles(j,1:lid),cycdir), break;end;
      nnc=nnc+1;
    end
    if nnc<=lt,
      nc(i+1)=nnc;  
    else
      break;
    end
  end  
  nc=[nc lt+1]';
  cycles(1,:)='';
  fclose(fid);
else
  tipfiles=[];
  nc=[];
  cycles=[];
  efphc=[];
end
