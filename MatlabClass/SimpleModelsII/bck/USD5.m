%% Specific heat
%Sph=piV/raaf/Cf;
Sph=1.25;
%% Input Data
dtc=-2e-5;
beta=0.006;
lam=log(2)/8;
L=5e-5;
usd=5;
%% Run
options=odeset;
[t,y]=ode45(@pointk1,[0 .2],[1e-5;1e-5*beta/L/lam;500],options,...
    @fcn_raa,beta,dtc,Sph,usd);
%% Plot Power
figure('position',[200 490 560 420]);
plot(t,y(:,1))
xlabel('time(s)');
ylabel('Power (relative)')
t1=title('Rod ejection 5$');
set(t1,'fontsize',14)
set(t1,'fontweight','bold');
figure(gcf)
%% Plot Temperature 
figure('position',[820 490 560 420]);
plot(t,y(:,3))
xlabel('time(s)');
ylabel('Temperature (K)')
t2=title('Rod ejection 5$');
set(t2,'fontsize',14)
set(t2,'fontweight','bold');
figure(gcf)