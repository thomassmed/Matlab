%@(#)   setpix.m 1.2	 94/08/12     12:11:01
%
%function setpix(IJ,color)
%function setpix(I,J,color)
%Input:
%     IJ - i and j-index in a n by 2 vector
%     I,J- i and j-index in two n by 1 vectors
%  color - color (string or rbg-values), default='bla' for black
function setpix(I,J,color)
if min(size(I))==1,
  if nargin<3,
    color='bla';
  end
else
  if nargin==2
    color=J(1:length(J));
  end
  if size(I,2)==1,
    I=I';
  end
  J=I(:,2);
  I=I(:,1);
  if nargin<2,
    color='bla';
  end
end
for i=1:length(I)
  X=[J(i)+.49 J(i)+.51];
  Y=[I(i)+.5 I(i)+.5];
  patch(X,Y,color,'erasemode','none')
end
