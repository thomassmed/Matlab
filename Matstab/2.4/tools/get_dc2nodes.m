function k=get_dcnodes
%get_dcnodes
%
%k=get_dcnodes
%Hämtar noderna i fallspalten
 
%@(#)   get_dc2nodes.m 2.2   02/02/27     12:08:57

global geom

k = geom.nin(2):geom.nout(2);
