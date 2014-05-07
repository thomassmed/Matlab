function raa=fcn_raa(t,T,dtc,beta,usd)
T0=500;
rodworth=usd*beta;
raa=rodworth+dtc*(T-T0);
