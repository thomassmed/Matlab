function k=get_chnodes
%k=get_chnodes
%
%Hämtar härdnoderna exlusive bypasskanalen

%@(#)   get_chnodes.m 2.2   02/02/27     12:07:02

global geom

k=get_corenodes;
index=(geom.ncc+1):(geom.ncc+1):length(k);
k(index)=[];
