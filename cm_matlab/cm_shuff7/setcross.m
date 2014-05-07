%@(#)   setcross.m 1.1	 05/07/13     10:29:39
%
%
%function hcross=setcross(IJ,color)
%function hcross=setcross(I,J,color)
%Input:
%     IJ - i and j-index in a n by 2 vector
%     i,j- i and j-index in two n by 1 vectors
%  color - color (string or rbg-values), default='bla' for black
function hcross=setcross(I,J,farg)
if min(size(I))==1,
  if nargin<3,
    farg='bla';
  end
  if size(I,2)>1, I=I';end
else
  if size(I,2)~=2
    I=I';
  end
  if nargin<2,
    farg='bla';
  else
    farg=J;
  end
  J=I(:,2);
  I=I(:,1);
end
J1=0*J;
J2=J1;
JJ=J/2-round(J/2);
Jamn=find(JJ==0);
Udda=find(JJ);
J1(Udda)=J(Udda)+1;
J2(Udda)=J(Udda);
J1(Jamn)=J(Jamn);
J2(Jamn)=J(Jamn)+1;
xl=[J1';J2';J2';J1'];
yl=[I';I'+1;I';I'+1];
hcross=line(xl,yl,'color',farg,'erasemode','none');
