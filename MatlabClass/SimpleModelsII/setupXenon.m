%% This file is just for checking of some parameters, not neccerily needed
Rf=3300*1e6/3.2041e-11/62280000; %fission/cm3/s
% 200 MeV/fission
fi2=4.5e13;
Xeq=1.483e15;
Ieq=3.668e15;
lamXe=1/9.2/3600*log(2);
lamI=1/6.57/3600*log(2);
gamI=Ieq*lamI/Rf;
gamXe=gamI/25;
sig1=0.0015;
sig2=0.03;
fi1=2e14;
ny=2.57;
sigXe=((gamI+gamXe)*Rf/Xeq-lamXe)/fi2