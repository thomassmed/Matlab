%@(#)   getcrbui.m 1.3	 05/12/08     10:31:35
%
%function buidvec=getcrbui(distfile)
function buidvec=getcrbui(distfile)
[buid,mminj,konrod]=readdist7(distfile,'asyid');
[ikan,ikancr]=filtcr(konrod,mminj,0,99);
s=size(buid,2);
for i=1:size(ikan,1);
  buidvec(4*i-3,1:s)=buid(ikan(i,1),1:s);
  buidvec(4*i-2,1:s)=buid(ikan(i,2),1:s);
  buidvec(4*i-1,1:s)=buid(ikan(i,3),1:s);
  buidvec(4*i,1:s)=buid(ikan(i,4),1:s);
end
