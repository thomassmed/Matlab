function [mg,romum] = getstate(x,Eci)
%[mg,romum] = getstate(x,Eci);
%Extracts dynamic variables from
%state vector in the steady state solution

global geom

nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;

k = get_corenodes;
[kn,k0]=get_thneig(k);
sx = length(x);
k1 = sx/2;

mg = zeros(get_thsize,1);
mg(k0) = x(1:k1);mg = mg.*(mg>0);
romum = zeros(get_thsize,1);
romum(k0) = x((k1+1):sx);
romum(nin(5):nin(5+ncc))=Eci;
romum(1:nout(4)) = ones(nout(4),1)*Eci(1);

