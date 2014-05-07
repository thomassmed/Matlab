function yp=Ex10_5(t,y,al,beta,raafcn)

%% More Parameters
L=5e-5;
raa=raafcn(t);
%%
n=y(1); % Power 
C=y(2); % Delayed neutrons

dndt=(raa-beta)/L*n+al*C; 
dCdt=beta*n/L-al*C; 

yp=[dndt;dCdt];
