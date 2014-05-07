%@(#)   modmap.m 1.1	 02/06/03     14:48:00
%
%function modmap(dis2d,mminj,fil,FORMAT)
%writes a vector of dis2d in coremap 
%if fil is specified as a string, the result is written on that file
%if fil is a number, fil is taken as a fid-identifier and written to that file
%FORMAT can e.g. be '%8.3f ', '%4i' etc
function modmap(dis2d,mminj,fil,FORMAT)
iimax=length(mminj);
index=0;
if nargin<4,
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
if strcmp(fil,'cprmod.lis'),
  fprintf(fid,'CPRMOD\n');
elseif strcmp(fil,'lhrmod.lis'),
  fprintf(fid,'LHRMOD\n');
end
for i=1:iimax,
  for j=1:mminj(i)-1
    for jj=1:kk
      fprintf(fid,' ');
    end
  end
  for j=mminj(i):iimax-mminj(i)+1
    index=index+1;
    fprintf(fid,FORMAT,dis2d(index));
  end     
  fprintf(fid,'\n');
end
if clo==1,fclose(fid);end;
