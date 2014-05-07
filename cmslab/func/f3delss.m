function f3delss(dkm,hcm,qm,dkp,hcp,qp,dkw,hcw,qw,dkline)
%f3delss(dkm,hcm,qm,dkp,hcp,qp,qp,dkw,hcw,qw,dkline)
%
%dk: Decay-Ratio
%hc: Core flow [kg/s]
%q: Thermal power [%]
%
%xm : Measured data
%xp : Predicted data at corresponding point
%xw : Worst case during the cycle
%dkline : Line is adjusted to dekay-ratio dkline (default=0.8)
%
%Plots the "del-SS" line for F3
%The line has a maximal whithdrawal in the operating map

k1=0.0004334;
k2=0.02487;

if nargin < 10,
  dkline = 0.8;
end

c = dkm + k1*hcm - k2*qm;
c = c + dkw - dkm + k1*(hcw - hcm) - k2*(qw - qm);      %Worst case
c = c + dkm - dkp + k1*(hcm - hcp) - k2*(qm - qp);      %Reference case

p = [k1  dkline-c]/k2;
HC = (2000:10:10000);
aprm = polyval(p,HC);
i1 = find(aprm<60);
i1 = i1(length(i1));
i2 = find(109>aprm);
i2 = i2(length(i2));
x = [HC(i1) HC(i2)];
y = [aprm(i1) aprm(i2)];
line(x,y)
line([2250 HC(i1)],[60 60])
text(4000,75,'DEL-SS')
text(x(1),y(1),['(',num2str(x(1)),',60)'])
text(x(length(x)),y(length(y)),['(',num2str(x(length(x))),',109)'])
