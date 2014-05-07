%@(#)   lowkinf.m 1.2	 94/02/08     12:31:34
%
%function lowkinf(filename)
function lowkinf(filename)
[buidnt,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
 distlist,staton,masfil,rubrik,detpos,fu]=readdist(filename,'buidnt');
sym=mz(2);
[right,left]=knumhalf(mminj);
buntyp=readdist(filename,'buntyp');
kinf=kinf2mlab(filename);
[kinf,k]=sort(kinf);
if sym==3
  i=find(findint(k,left));
  kinf(i)='';
  k(i)='';
end
fprintf('\n SYMME %i\n',sym);
fprintf('%3s%9s%8s%8s%8s\n\n','Nr','BUNTYP','BUIDNT','kinf','pos');
for j=20:-1:1
  yx=knum2cpos(k(j),mminj);
  fprintf('%3i%7s%10s%9.5f%5i%3i\n',j,buntyp(k(j),:)...
   ,buidnt(k(j),:),kinf(j),yx(1),yx(2))
end
