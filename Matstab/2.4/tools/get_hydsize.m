function l=get_hydsize
%l=get_hydsize
%
%Hämtar matrisstorleken på termohydrauliken

%@(#)   get_hydsize.m 2.2   02/02/27     12:09:20

global geom

l = get_thsize*get_varsize+4+geom.ncc;
