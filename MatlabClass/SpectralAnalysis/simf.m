%% Translate from K,T to a,b:
K=1-gamma;
Ts=0.05;a=exp(-Ts/T);b=(1-a)*K;
opt=odeset;
%[tt,yy]=ode45(@f,t,Qc(1),opt,T,K-gamma,Qt,t);
yy=firstorder(Qt,a,b,Qc(1));
yy=yy+Qt*gamma;
figure
plot(t,Qc);
hold on
plot(t,yy,'r')
shg
%%
YY=mult*yy/QT0;
figure
compass(QC)



Hs=(1-gamma)/(1+lam*T);
YY1=Hs*QT+gamma*QT;
hold on
compass(YY1,'r')
compass(YY,'k')
