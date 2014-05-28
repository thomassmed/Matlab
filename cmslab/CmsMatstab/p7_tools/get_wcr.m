function wcr=get_wcr(konrod,mminj,czmesh,crcovr);

kmax=max(find(czmesh));
czmesh=czmesh(1:kmax);
cr_cow=(1-konrod/1000)*crcovr;
zsum=cumsum(czmesh);
yi=interp1([0;zsum],0:kmax,cr_cow);
ikan=filtcr(konrod,mminj,-1,1e5);
kan=sum((length(mminj)+2-2*mminj));
vec=zeros(kan,1);
for i=1:4,
 vec(ikan(:,i))=yi;
end
for i=1:kmax,
 wcr(i,:)=max(0,vec'+1-i);
end
wcr=min(wcr,1);
%@(#)   get_wcr.m 1.2   99/12/30     11:04:42
