function k=get_dcnodes
% k=get_dcnodes
% Get the downcomer nodes for DC1 and DC2
 
global geom
nin=geom.nin;
nout=geom.nout;

k = nin(1):nout(1);
