%@(#)   vttcor3.m 1.1   95/04/03     09:36:07
function [Xw,X]=vttcor3(Xsep,separeg);
%
% VTT:s 3-region correlation
%
%
%
%
%
Xli=0.25;
%VTT:s original korrelation
a0=.0640;
a=[-0.0516   0.0465  0.0354];
% Var anpassning med TVO:s antagande om Qtotal
a0=0.06480959333629;
a=[-0.05187990592066   0.04679819094977   0.03542308984765];
% Var anpassning
a0=-0.00655646954347;
a=[-0.04884413817088   0.03836298862985   0.04198872450192];
X=zeros(3,1);
for i=1:3,
  ireg=find(separeg==i);
  X(i)=sum(max(0,Xli-Xsep(ireg)));
end
Xw=a0+a*X;
end
