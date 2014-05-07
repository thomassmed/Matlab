function k=get_corenodes
%k=get_corenodes
%
%Hämtar härdnoderna

%@(#)   get_corenodes.m 2.2   02/02/27     12:08:17

global geom

k=geom.nin(5):geom.nout(geom.ncc+5);
