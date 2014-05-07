%@(#)   getblock.m 1.1	 05/07/13     10:29:31
%
function block=getblock(distfile);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton]=readdist7(distfile);
i=find(abs(staton)<58 & abs(staton>47));
block=[staton(1,1) staton(1,i)];
