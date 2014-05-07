%@(#)   sortbatchclab.m 1.2	 94/08/12     12:15:42
%
function [enr,typ,stav]=sortbatchclab(bunclab,batchfil);
[eladd,garburn,antal,levyear,enr0,buntot,weight,eta,typ0,stav0]=readbatch(batchfil);
imax=size(buntot,1);
typ=32*ones(size(bunclab,1),size(typ0,2));
setstr(typ);
for i=1:imax
  ii=find(buntot(i,:)==',');
  if length(ii)==0,
    bun=remblank(buntot(i,:));
    mult=filtbun(bunclab,bun);
  else
     bun=remblank(buntot(i,1:ii(1)-1));
     mult=filtbun(bunclab,bun);
     for k=1:length(ii)-1,
       bun=remblank(buntot(i,ii(k)+1:ii(k+1)-1));
       mult=mult+filtbun(bunclab,bun);
     end
     bun=remblank(buntot(i,ii(length(ii))+1:size(buntot,2)));
     mult=mult+filtbun(bunclab,bun);
  end
  ibun=find(mult>0);
  if length(ibun)>0,
     enr(ibun)=enr0(i)*ones(size(ibun));  
     stav(ibun)=stav0(i)*ones(size(ibun));
  end
  for j=1:length(ibun),
     typ(ibun(j),:)=typ0(i,:);
  end
end
