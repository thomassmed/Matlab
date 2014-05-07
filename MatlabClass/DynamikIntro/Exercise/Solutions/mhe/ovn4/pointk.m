function yp=pointk(t,y,fcnraa)

%% Parameters
al=log(2)/8;
beta=0.00600;
L=1.6825e-05;
%% More Parameters
if nargin<3, fcnraa=0.00080;end
if isnumeric(fcnraa),
    raa=fcnraa;
else
    raa=fcnraa(t);
end
%raa=0.00080;
%%
n=y(1); % Concentration of neutrons 
C=y(2); % Delayed neutrons

dndt=(raa-beta)/L*n+al*C; 
dCdt=beta*n/L-al*C; 

yp=[dndt;dCdt];
