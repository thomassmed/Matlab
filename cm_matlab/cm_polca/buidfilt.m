%@(#)   buidfilt.m 1.3	 05/12/08     10:31:34
%
%function filtvec=buidfilt(buidvec,distfile)
function filtvec=buidfilt(buidvec,distfile)
[dist,mminj]=readdist7(distfile,'asyid');
i=mbucatch(dist,buidvec);
filtvec=i>0;
