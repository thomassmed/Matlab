function k=get_dcnodes
%get_dcnodes
%
%k=get_dcnodes
%H�mtar noderna i fallspalten
 
%P�r Lans�ker, Forsmark, 1995-02-02
%Rev:

global geom

k = geom.nin(1):geom.nout(2);
