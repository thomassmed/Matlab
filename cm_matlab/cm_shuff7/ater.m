%@(#)   ater.m 1.1	 05/07/13     10:29:27
%
%
%function ater(curfil,bocfil,infil)
%Generates an infil for reloading fuel
function ater(curfil,bocfil,infil)
[buidboc,mminj,konrod]=readdist7(bocfil,'asyid');
ikan=filtcr(ones(size(konrod)),mminj,0,2);
i1=size(buidboc,1);
plvec=dramap(curfil,bocfil);
l=find(plvec>0);l=l(1);
klar=plvec(l);
lto=find(plvec==0);
lbuid=buidboc(lto,:);
lfrom=0*lto;
fid=fopen(infil,'w');
for i=1:length(lto)
  %Check if bundle is first in supercell
  forsta=0;
  [ik,jk]=find(ikan==lto(i));
  if length(ik)>0,
    l=find((1:4)~=jk);
    if max(plvec(ikan(ik,l)))==0,
      forsta=1;
    end;
  end
  if forsta==1,
    printsfg(fid,lfrom(i),lto(i),'dummy',mminj,'',2);
  end
  printsfg(fid,lfrom(i),lto(i),lbuid(i,:),mminj);
  plvec(lto(i))=klar;
end
fclose(fid);
