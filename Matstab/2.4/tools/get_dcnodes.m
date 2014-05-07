function k=get_dcnodes
%get_dcnodes
%
%k=get_dcnodes
%Hämtar noderna i fallspalten
 
%Pär Lansåker, Forsmark, 1995-02-02
%Rev:

global geom

k = geom.nin(1):geom.nout(2);
