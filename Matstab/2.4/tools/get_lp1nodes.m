function k=get_lp1nodes
%get_lp1nodes
%
%k=get_lp1nodes
%Hämtar noderna i lower plenum 1.
 
%@(#)   get_lp1nodes.m 2.2   02/02/27     12:09:41

global geom

k = geom.nin(3):geom.nout(3);
