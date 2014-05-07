%@(#)   xy2ij.m 1.1	 95/04/03     09:59:20
%
%Transforms from coordinates given in metres with 
%origin in center of core to i,j coordinates referring
%to fuel channels.
function IJ=xy2ij(XY)
IJ(:,1)=-XY(:,2)/.15375+15.5;
IJ(:,2)=XY(:,1)/.15375+15.5;
end
