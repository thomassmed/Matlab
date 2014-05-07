function [y2,y3,y4,y5,y6,y7,y8]=showeq(A0,B0,ieq,ee,lam,ee0,LAM)
% [ja,xa,cc,cc0,shown,shown0,varname]=showeq(A0,B0,ieq,ee,lam,ee0,LAM)
%
% Shows  the phasordiagram associated with each equation
% Input:
%    A0  - The A-matrix
%    B0  - The B-matrix
%    ieq - The equation number
%    ee  - The right eigenvector calculated by matstab
%    lam - The eigenvalue associated with ee
%    ee0 - The right eigenvector constructed from ramona (all_traj)
%    LAM - The eigenvalue derived from RAMONA time-trajectories
% Output:
%    ja  - A(ieq,ja) is different from zero
%    xa  - A(ieq,ja)=xa
%    cc  - A(ieq,ja).*ee(ja)
%    cc0 - A(ieq,ja).*ee0(ja)
%  shown - only those of cc that are > 0.1*max(abs(cc) are shown)
%  shown0- only those of cc0 that are > 0.1*max(abs(cc0) are shown)
% varname- Variable name corresponding to column ja
%

%@(#)   showeq.m 1.2   96/08/21     13:57:40

eqname=getvarname(ieq);eqname=eqname(2,5:8);
B00=diag(B0);
[ia,ja,xa]=find(A0(ieq,:));
cc=xa.*ee(ja);
varname=getvarname(ja);
varname=[varname;['      d/dt          ']];
cc=[cc;-B00(ieq)*lam*ee(ieq)];
cc0=xa.*ee0(ja);
cc0=[cc0;-B00(ieq)*LAM*ee0(ieq)];
selec=abs(cc);
ms=max(selec);
selec=selec/ms;
shown=(selec>0.1);
is=find(shown);
hold off
compass(cc(is)/ms,'y');
text(1.1*real(cc(is))/ms,1.1*imag(cc(is))/ms,varname(is+1,7:10));
hold on
compass(sum(cc),'w');
selec=abs(cc0);
selec=selec/max(selec);
shown0=(selec>0.1);
is=find(shown0);
compass(cc0(is)/ms,'g');
%ext(1.1*real(cc(is))/ms,1.1*imag(cc(is))/ms,varname(is+1,7:10));
compass(sum(cc0)/ms,'r');
title(['Equation: ',eqname,'  Scale: ',num2str(ms)]);
if nargout>0,
  y2=ja;y3=xa;y4=cc;
  y5=cc0;y6=shown;y7=shown0;
  y8=varname(2:size(varname,1),7:10);
end
end
