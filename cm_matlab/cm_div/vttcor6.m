function [Xw,X]=vttcor6(Xsep,separeg);
%
%
%
%
%
%
%
Xli=0.25;
%VTT:s original korrelation
a0=-.0726;
a=[-0.0217   -0.0595  0.0219  0.1295  -0.066  0.1413];
% Var anpassning
a0=-.2887;
a=[-0.0072   -0.1128 -0.0139  0.2308  -0.1783 0.2821]; 
a0=-0.09449490245289;
a=[-0.02750443  -0.0445407  -0.0151126094   0.15737437 -0.05599753   0.124342457];
X=zeros(6,1);
for i=1:6,
  ireg=find(separeg==i);
  X(i)=sum(max(0,Xli-Xsep(ireg)));
end
Xw=a0+a*X;
end
