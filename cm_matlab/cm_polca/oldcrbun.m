%@(#)   oldcrbun.m 1.4	 05/12/08     10:31:36
%
%function filt=oldcrbun(distfile,prevfile)
function filt=oldcrbun(distfile,prevfile)
[buidnt,mminj,konrod]=readdist7(distfile,'asyid');
ikan=filtcr(konrod,mminj,0,99);
ikan=reshape(ikan,size(ikan,1)*size(ikan,2),1);
buprev=readdist7(prevfile,'asyid');
buvec=buidnt(ikan,:);
filt=zeros(size(buidnt,1),1);
i=mbucatch(buvec,buprev);
filt(i)=ones(length(i),1);
