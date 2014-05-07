%@(#)   hcor2fil.m 1.2	 94/08/12     12:10:31
%
%function hcor2fil(dis2d,mminj,lr,fil,FORMAT)
%writes a vector of dis2d in coremap 
%if lr=2 the left half of the core is printed, else the right half of the core is printed 
%if fil is specified as a string, the result is written on that file
%if fil is a number, fil is taken as a fid-identifier and written to that file
%FORMAT can e.g. be '%8.3f ', '%4i' etc
function hcor2fil(dis2d,mminj,lr,fil,FORMAT)
iimax=length(mminj);
index=0;
iiss=fix((iimax+1)/2);
iiss1=fix(iimax/2);
if nargin<5,
  FORMAT='%4i';
  kk=4;
  dis2d=round(dis2d);
else
  s=sprintf(FORMAT,dis2d(1));
  kk=length(s);
end
if isstr(fil),
  FIL=1;
  fid=fopen(fil,'w');
  clo=1;
elseif fil~=0
  FIL=1;
  fid=fil;
  clo=0;
end;
fprintf(fid,'  ');
if lr ==2,
  for i=1:iiss
    if kk>2,
      for jj=1:kk-2
        fprintf(fid,' ');
      end
    end
    fprintf(fid,'%2i',i);
  end
  fprintf(fid,'\n');
  fprintf(fid,'\n');
  for i=1:iimax,
    fprintf(fid,'%2i  ',i);
    for j=1:mminj(i)-1
      for jj=1:kk
        fprintf(fid,' ');
      end
    end
    for j=mminj(i):iiss
      index=index+1;
      fprintf(fid,FORMAT,dis2d(index));
    end     
    index=index+iimax-iiss+1-mminj(i);
    fprintf(fid,'\n');
  end
else
  for i=iiss1+1:iimax
    if kk>2,
      for jj=1:kk-2
        fprintf(fid,' ');
      end
    end
    fprintf(fid,'%2i',i);
  end
  fprintf(fid,'\n');
  fprintf(fid,'\n');
  index=0;
  for i=1:iimax,
    fprintf(fid,'%2i  ',i);
    index=index+iimax-iiss1+1-mminj(i);
    for j=iiss1+1:iimax+1-mminj(i)
      index=index+1;
      fprintf(fid,FORMAT,dis2d(index));
    end     
    fprintf(fid,'\n');
  end
if clo==1,fclose(fid);end;
end
