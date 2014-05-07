%@(#)   cor2scr.m 1.2	 94/08/12     12:09:55
%
%function cor2scr(dis2d,mminj,FORMAT)
%writes a vector of dis2d in coremap 
%FORMAT can e.g. be '%8.3f ', '%4i' etc
function cor2scr(dis2d,mminj,FORMAT)
iimax=length(mminj);
index=0;
if nargin<3,
  FORMAT='%4i';
  kk=4;
  dis2d=round(dis2d);
else
  s=sprintf(FORMAT,dis2d(1));
  kk=length(s);
end
fprintf('  ');
for i=1:iimax
  if kk>2,
    for jj=1:kk-2
      fprintf(' ');
    end
  end
  fprintf('%2i',i);
end
fprintf('\n');
fprintf('\n');
for i=1:iimax,
  fprintf('%2i  ',i);
  for j=1:mminj(i)-1
    for jj=1:kk
      fprintf(' ');
    end
  end
  for j=mminj(i):iimax-mminj(i)+1
    index=index+1;
    fprintf(FORMAT,dis2d(index));
  end     
  fprintf('\n');
end
