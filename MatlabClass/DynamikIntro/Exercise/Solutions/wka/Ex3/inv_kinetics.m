%
% Inverse point kinetics example
%
% Read in pairings for (time,flux) and solve for period and reactivity
% as a function of time.
%
function [tstar,rho,conc,omega]=inv_kinetics(time,nd,beta,lam)
if nargin==0,
    incdata = importdata('incore.dat');
    time = incdata(:,1);
    nd =   incdata(:,2);
end
if nargin<3,
    beta = [2.030000e-04;1.273000e-03;1.115400e-03;2.487000e-03;9.130000e-04;2.210000e-04];
    lam =  [1.277900e-02;3.165000e-02;1.217490e-01;3.228930e-01;1.404693e+00;3.881428e+00];
end
pnl =   1.6825000e-05;

lognd = log(nd);
dt = time(2:length(time))-time(1:length(time)-1);
dtime = min(dt);
tstar = min(time):dtime:max(time);
tstar = tstar';
%
logndstar = interp1(time,lognd,tstar,'linear');
ndstar = exp(logndstar)/exp(logndstar(1));

%
% Pre-cursor equations integration. Define delayed groups constant terms.
%
Xi = (beta ./ lam) / pnl;
Dk = exp(-lam * dtime);
conc = zeros(length(beta),length(tstar));
%
% Initialize to steady-state concentration. Solve for time-dependent pre-cursor
% concentrations using analytic form
%
conc(:,1) = Xi * ndstar(1);
for i=2:length(tstar)
   Gk = 0.5*(ndstar(i)+ndstar(i-1)) * Xi .* (1.-Dk);
   conc(:,i) = conc(:,i-1) .* Dk + Gk;
end
%
% Solve for reactity using implicit time differencing of point kinetics and
% known pre-cursor concentrations.
%
tb = sum(beta);
rho = zeros(length(tstar),1);
rho(1) = tb - sum(lam .* conc(:,1))*pnl/ndstar(1);
for i=2:length(tstar)
    deriv = (ndstar(i)-ndstar(i-1))/dtime;
    rho(i) = tb + (deriv - sum(lam .* conc(:,i)))*pnl/ndstar(i);
end
%
% Calculate inverse of reactor period using input response
% Period is calculated based on exponential behavior for each time step dt
%
omega = zeros(length(tstar),1);
omega(1) = 0.;
for i=2:length(tstar)
    omega(i) = log(ndstar(i)/ndstar(i-1))/dtime;
end
    
end

