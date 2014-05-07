function f1delss(dkm,hcm,qm,dkp,hcp,qp,dkw,hcw,qw)
%f1delss(dkm,hcm,qm,dkp,hcp,qp,qp,dkw,hcw,qw)
%
%dk: Decay-Ratio
%hc: Core flow [kg/s]
%q: Thermal power [%]
%
%xm : Measured data
%xp : Predicted data at corresponding point
%xw : Worst case during the cycle
%
%Plots the "del-SS" line for F1/F2
%The line has a maximal whithdrawal in the operating map

%@(#)   f1delss.m 1.2   02/07/29     15:02:59

k1 = 0.000225;
k2 = 0.0083;
c = dkm + k1*hcm - k2*qm;  
c = c + dkw - dkm + k1*(hcw - hcm) - k2*(qw - qm);	%Worst case
c = c + dkm - dkp + k1*(hcm - hcp) - k2*(qm - qp);	%Reference case
c = max(c,1.118);  % limit on c to avoid a SS-line too far to the left

p = [k1  0.8-c]/k2;
HC = (2000:10:8000);
aprm = polyval(p,HC);
i1 = find(aprm<60);
i1 = i1(length(i1));
y = polyval([0.0058667 58.267],HC);	%SS-line
i2 = find(y>aprm);
i2 = i2(length(i2));
x = [HC(i1) HC(i2)];
y = [aprm(i1) aprm(i2)];
line(x,y)
line([2250 HC(i1)],[60 60])
text(2500,65,'DEL-SS')

