%@(#)   crpat2fil.m 1.3	 97/11/11     13:09:54
%
%function crpat2fil(konrod,mminj,fil,konrod2)
%writes a vector of konrod in coremap konrod is dived by 10
%if fil is specified as a string, the result is written on that file
%if fil is a number, fil is taken as a fid-identifier and written to that file
function crpat2fil(konrod,mminj,fil,konrod2)
par=0;
if nargin>3, par=1;konrod2=round(konrod2/10);else,konrod2=0;end
iimax=length(mminj);
iiss=iimax/2;
index=0;
index2=0;
FORMAT='%3i';
kk=3;
konrod=round(konrod/10);
if isstr(fil),
  FIL=1;
  fid=fopen(fil,'w');
  clo=1;
elseif fil~=0
  FIL=1;
  fid=fil;
  clo=0;
end;
if par==0,
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
end
for i=1:2:iimax,
  ii=i+1;
  if par==0,
    fprintf(fid,'%3i  ',ii/2);
  else
    fprintf(fid,' ');
  end
  jsta=fix(max(mminj(i)/2,mminj(ii)/2));
  jsto=iiss-jsta;
  jind(round(i/2),:)=[jsta+1,jsto];
  for j=1:jsta
    for jj=1:kk
      fprintf(fid,' ');
    end
  end
  for j=jsta+1:jsto
    index=index+1;
    if konrod(index)<100,
      fprintf(fid,FORMAT,konrod(index));
    else
      fprintf(fid,'%s',' --');
    end     
  end     
  if par==1,
    if length(konrod2)>1,
      for j=jsto+1:iiss+2+jsta,
        for jj=1:kk
          fprintf(fid,' ');
        end
      end
      for j=jsta+1:jsto
        index2=index2+1;
        if konrod2(index2)<100,
          fprintf(fid,FORMAT,konrod2(index2));
        else
          fprintf(fid,'%s',' --');
        end     
      end     
    end
  end
  fprintf(fid,'\n');
end
if clo==1,fclose(fid);end;
