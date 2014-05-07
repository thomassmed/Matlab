%%
lambda=log(2)/8;
beta=0.00600;
L=1.6825e-5;

y0 = [1;beta./(lambda * L)];
rho = 80e-5;
A = [(rho-beta)./L lambda;beta/L -lambda];

%%


[t1,y1] = ode45(@pointk,[0 60], y0);
[t2,y2] = ode15s(@pointk,[0 60], y0);

plot(t1,y1(:,1),t2,y2(:,1));

%%

e = eig(A);


plot(t2,(1+0.153).*exp(t2.*e(2)),t2,y2(:,1));
axis([-0 0.03 1 1.2])

plot(t2,exp(t2.*e(1))+exp(t2.*e(2)));