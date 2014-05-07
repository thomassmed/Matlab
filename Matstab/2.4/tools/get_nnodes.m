function k=get_nnodes
%get_nnodes
%
%k=get_nnodes
%Gets the neutronic nodeskorresponding
%to the thermo hydraulik vektor
%thermo = 1 2 3 1 2 3 1 2 3 ...
%neutronics = 1 1 1 2 2 2 3 3 3 ...

%P„r Lans…ker, Forsmark, 1995-10-04

global geom

k = 1:(geom.ncc*geom.kmax);
k = reshape(k,geom.kmax,geom.ncc)';
k = k(:)';
