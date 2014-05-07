function k=get_lp2nodes
%get_lp2nodes
%
%k=get_lp2nodes
%Hämtar noderna i lower plenum 2.
 
%@(#)   get_lp2nodes.m 2.2   02/02/27     12:08:30

global geom

k = geom.nin(4):geom.nout(4);
