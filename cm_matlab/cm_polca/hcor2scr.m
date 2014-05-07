%@(#)   hcor2scr.m 1.2	 94/08/12     12:10:32
%
%function hcor2scr(dis2d,mminj,lr,FORMAT)
%writes a vector of dis2d in coremap on screen
%if lr=2 the left half of the core is printed, else the right half of the core is printed 
%if fil is specified as a string, the result is written on that file
%if fil is a number, fil is taken as a fid-identifier and written to that file
%FORMAT can e.g. be '%8.3f ', '%4i' etc
function hcor2scr(dis2d,mminj,lr,FORMAT)
iimax=length(mminj);
index=0;
iiss=fix((iimax+1)/2);
iiss1=fix(iimax/2);
if nargin<3, lr=0;end
if nargin<4,
  FORMAT='%4i';
  kk=4;
  dis2d=round(dis2d);
else
  s=sprintf(FORMAT,dis2d(1));
  kk=length(s);
end
fprintf('  ');
if lr ==2,
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
  for i=1:iimax,
    fprintf('%2i  ',i);
    for j=1:mminj(i)-1
      for jj=1:kk
        fprintf(' ');
      end
    end
    for j=mminj(i):iiss
      index=index+1;
      fprintf(FORMAT,dis2d(index));
    end     
    index=index+iimax-iiss+1-mminj(i);
    fprintf('\n');
  end
else
  for i=iiss1+1:iimax
    if kk>2,
      for jj=1:kk-2
        fprintf(' ');
      end
    end
    fprintf('%2i',i);
  end
  fprintf('\n');
  fprintf('\n');
  index=0;
  for i=1:iimax,
    fprintf('%2i  ',i);
    index=index+iimax-iiss1+1-mminj(i);
    for j=iiss1+1:iimax+1-mminj(i)
      index=index+1;
      fprintf(FORMAT,dis2d(index));
    end     
    fprintf('\n');
  end
end
