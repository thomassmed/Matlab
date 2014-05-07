%@(#)   ij2xy.m 1.1	 95/04/03     09:59:28
%
% XY=ij2xy(IJ)  IJ is n by 2
% XY=ij2xy(I,J)
%Transforms TO coordinates given in metres with 
%origin in center FROM core  i,j coordinates referring
%to fuel channels.
function XY=ij2xy(IJ,arg2)
if nargin==2,
  if size(IJ,1)==1&size(IJ,2)>1,
    IJ=IJ';
  end
  IJ=[IJ,arg2];
end
XY(:,1)=(IJ(:,2)-15.5)*.15375;
XY(:,2)=(-IJ(:,1)+15.5)*.15375;
end
