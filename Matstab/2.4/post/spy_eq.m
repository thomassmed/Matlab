function [y2,y3,y4,y5,y6,y7,y8]=spy_eq(A0,B0,ieq,ee,lam)
% [ja,xa,cc,cc0,shown,shown0,varname]=spy_eq(A0,B0,ieq,ee,lam)
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
%@(#)   spy_eq.m 1.2   96/08/21     13:57:49

eqname=getvarname(ieq);eqname=eqname(2,5:8);
B00=diag(B0);
[ia,ja,xa]=find(A0(ieq,:));
cc=xa.*ee(ja);
varname=getvarname(ja);
varname=[varname;['      d/dt          ']];
cc=[cc;-B00(ieq)*lam*ee(ieq)];
selec=abs(cc);
ms=max(selec);
selec=selec/ms;
shown=(selec>0.05);
is=find(shown);
compass(cc(is)/ms,'y');
hold on
text(1.1*real(cc(is))/ms,1.1*imag(cc(is))/ms,varname(is+1,7:10));
compass(sum(cc),'w');
hold off
title(['Equation: ',eqname,'  Scale: ',num2str(ms)]);
if nargout>0,
  y2=ja;y3=xa;y4=cc;
  y5=cc0;y6=shown;y7=shown0;
  y8=varname(2:size(varname,1),7:10);
end
