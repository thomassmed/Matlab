%@(#)   cr2fil.m 1.2	 94/08/12     12:10:01
%
%function cr2fil(konrod,mminj,fil,FORMAT)
%writes a vector of konrod in coremap 
%if fil is specified as a string, the result is written on that file
%if fil is a number, fil is taken as a fid-identifier and written to that file
%FORMAT can e.g. be '%8.3f ', '%4i' etc
function cr2fil(konrod,mminj,fil,FORMAT)
iimax=length(mminj);
iiss=iimax/2;
index=0;
if nargin<4,
  FORMAT='%4i';
  kk=4;
  konrod=round(konrod);
else
  s=sprintf(FORMAT,konrod(1));
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
fprintf(fid,'   ');
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
for i=1:2:iimax,
  ii=i+1;
  fprintf(fid,'%2i  ',ii/2);
  jsta=fix(max(mminj(i)/2,mminj(ii)/2));
  jsto=iiss-jsta;
  jind(i/2,:)=[jsta+1,jsto];
  for j=1:jsta
    for jj=1:kk
      fprintf(fid,' ');
    end
  end
  for j=jsta+1:jsto
    index=index+1;
    fprintf(fid,FORMAT,konrod(index));
  end     
  fprintf(fid,'\n');
end
if clo==1,fclose(fid);end;
end
