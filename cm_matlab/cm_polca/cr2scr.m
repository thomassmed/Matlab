%@(#)   cr2scr.m 1.2	 94/08/12     12:10:04
%
%function cr2scr(konrod,mminj,FORMAT)
%writes a vector of konrod in coremap 
%FORMAT can e.g. be '%8.3f ', '%4i' etc
function cr2scr(konrod,mminj,FORMAT)
iimax=length(mminj);
iiss=iimax/2;
index=0;
if nargin<3,
  FORMAT='%4i';
  kk=4;
  konrod=round(konrod);
else
  s=sprintf(FORMAT,konrod(1));
  kk=length(s);
end
fprintf('   ');
for i=1:iiss
  if kk>2,
    for jj=1:kk-2
      fprintf(' ');
    end
  end
  fprintf('%2i',i);
end
fprintf('\n');
fprintf('\n');
for i=1:2:iimax,
  ii=i+1;
  fprintf('%2i  ',ii/2);
  jsta=fix(max(mminj(i)/2,mminj(ii)/2));
  jsto=iiss-jsta;
  jind(i/2,:)=[jsta+1,jsto];
  for j=1:jsta
    for jj=1:kk
      fprintf(' ');
    end
  end
  for j=jsta+1:jsto
    index=index+1;
    fprintf(FORMAT,konrod(index));
  end     
  fprintf('\n');
end
end
