function k=get_risernodes
%get_risernodes
%
%k=get_risernodes
%Hämtar ångseparatornoderna
 
%@(#)   get_risernodes.m 2.2   02/02/27     12:10:23

global geom

k = geom.nin(6+geom.ncc):geom.nout(6+geom.ncc);
