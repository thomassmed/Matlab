function konrod2fil(konrod,mminj,fid)
% konrod2fil(konrod,mminj,fid)
% konrod2fil(konrod,mminj,filename)
filflag=0;
if nargin<3, fid=1;end
if isstr(fid), filflag=1; fid=fopen(fid,'w'); end

if max(konrod)==100, konrod=10*konrod; end

[map,mpos]=cr2map(konrod,mminj);
n=1;
for i=1:max(mpos(:,1)),
   for j=1:mpos(n,2)-1
     fprintf(fid,'    ');
   end
   while mpos(n)==i,  
     fprintf(fid,'%4i',round(konrod(n)/10));
     n=n+1;
   end
   fprintf(fid,'\n');
end

if filflag==1, fclose(fid); end
