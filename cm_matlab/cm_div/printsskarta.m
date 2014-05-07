%@(#)   printsskarta.m 	 2004/09/01     12:31:48
%
%  function printsskarta(distfiler,efph,titel,sskartfil)
%  Input:
%       distfiler - names on distr.-files under consideration
%            efph - EFPH at time of distfiles
%  Example:
%       printsskarta('distfiler','efph','titel','sskartfil')
function printsskarta(distfiler,efph,titel,sskartfil)
if nargin<2,
  efph=readdist7(distfiler(1,:),'efph');
  if length(efph)==1,
    efph=zeros(size(distfiler,1),1);
  else
    efph=min(efph);
    for i=2,size(distfiler,1)
      efph(i)=min(readdist7(distfiler(i,:),'efph'));
    end
  end
end
if nargin<3, titel=' ';end
if nargin<4, sskartfil='sskarta.ss';disp('Control-maps will be printed on sskarta.ss');end
ndist=size(distfiler,1);
nd2=fix(ndist/2);
fullpag=fix(nd2/3);
index=0;
fid=fopen(sskartfil,'w');
fprintf(fid,'                %s',titel);
fprintf(fid,'\n');
for i=1:fullpag,
   if i>1, fprintf(fid,'\n');end
   for j=1:3, 
     index=index+2;    
     fprintf(fid,'\n');     
     [dist,mminj,konrod1,bb1,hy1]=readdist7(distfiler(index-1,:)); 
     [dist,mminj,konrod2,bb2,hy2]=readdist7(distfiler(index,:));
     fprintf(fid,'   ');
     fprintf(fid,'%-5u EFPH Qrel %4.1f SS %u Keff %8.5f',efph(index-1),hy1(11)*100,bb1(18),bb1(96));
     fprintf(fid,'       ');
     fprintf(fid,'%-5u EFPH Qrel %4.1f SS %u Keff %8.5f',efph(index),hy2(11)*100,bb2(18),bb2(96));
     fprintf(fid,'\n');     
     fprintf(fid,'\n');
     crpat2fil(konrod1,mminj,fid,konrod2);
     fprintf(fid,'\n');     
   end
   fprintf(fid,'\f');
   % fprintf(fid,'1'); bortkommenterad eftersom den "aldrig" skrivs ut direkt.
end
for i=fullpag*3+1:nd2,  
   index=index+2;
   fprintf(fid,'\n');
   [dist,mminj,konrod1,bb1,hy1]=readdist7(distfiler(index-1,:));
   [dist,mminj,konrod2,bb2,hy2]=readdist7(distfiler(index,:));
   fprintf(fid,'   ');
   fprintf(fid,'%-5u EFPH Qrel %4.1f SS %u Keff %8.5f',efph(index-1),hy1(11)*100,bb1(18),bb1(96));
   fprintf(fid,'       ');
   fprintf(fid,'%-5u EFPH Qrel %4.1f SS %u Keff %8.5f',efph(index),hy2(11)*100,bb2(18),bb2(96));  
   fprintf(fid,'\n');
   fprintf(fid,'\n');
   crpat2fil(konrod1,mminj,fid,konrod2);
   fprintf(fid,'\n');
end
if ndist>nd2*2,
  index=index+1;
  fprintf(fid,'\n');
  [dist,mminj,konrod1,bb1,hy1]=readdist7(distfiler(index,:));
  fprintf(fid,'   ');
  fprintf(fid,'%-5u EFPH Qrel %4.1f SS %u Keff %8.5f',efph(index),hy1(11)*100,bb1(18),bb1(96));
  fprintf(fid,'\n');
  fprintf(fid,'\n');
  crpat2fil(konrod1,mminj,fid,0);
  fprintf(fid,'\n');
end  
fclose(fid);
