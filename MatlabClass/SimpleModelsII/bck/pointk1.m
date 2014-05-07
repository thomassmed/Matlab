function yp=pointk1(t,y,f,beta,dtc,Sph,usd)

lam=log(2)/8;
L=5e-5;
n=y(1); % Power 
C=y(2); % Delayed neutrons
T=y(3); % Temperature

raa=f(t,T,dtc,beta,usd);

dndt=(raa-beta)/L*n+lam*C; 
dCdt=beta*n/L-lam*C;       
dTdt=Sph*n; % Simplified Temperature
yp=[dndt;dCdt;dTdt];

