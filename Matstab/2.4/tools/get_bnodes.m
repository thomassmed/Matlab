function k=get_bnodes
%k=get_bnodes
%
%Hämtar noderna för bypasskanalen

%@(#)   get_bnodes.m 2.2   02/02/27     12:07:57

global geom
k=get_corenodes;
index=(geom.ncc+1):(geom.ncc+1):length(k);
k=k(index);
