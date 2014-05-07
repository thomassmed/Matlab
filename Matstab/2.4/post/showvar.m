function showvar(ee,ee0,jchoice)
% showvar(ee,ee0,jchoice)
%
% Shows the phasordiagram of variables jchoice 
% Input:
%    ee  - The right eigenvector calculated by matstab
%    ee0 - The right eigenvector constructed from ramona (all_traj)
% Output:
%  The phasor diagram 

%@(#)   showvar.m 1.2   96/08/21     13:57:42

hh=ishold;
varname=getvarname(jchoice);
ivs=size(varname,1);
varname=varname(2:ivs,7:10);
compass(ee(jchoice),'y');
text(1.1*real(ee(jchoice)),1.1*imag(ee(jchoice)),varname);
hold on
compass(ee0(jchoice),'r');
text(1.1*real(ee0(jchoice)),1.1*imag(ee0(jchoice)),varname);
ax=axis;
text(0.999*ax(1)+0.001*ax(2),0.1*ax(3)+0.9*ax(4),'yellow - ee');
text(0.999*ax(1)+0.001*ax(2),0.2*ax(3)+0.8*ax(4),'red    - ee0');
if hh==0, hold off;end
