function yp=Ex10_4(t,y,al,beta)

%% More Parameters
L=5e-5;
raa=0.00080;
%%
n=y(1); % Power 
C=y(2); % Delayed neutrons

dndt=(raa-beta)/L*n+al*C; 
dCdt=beta*n/L-al*C; 

yp=[dndt;dCdt];
