%% Övning 1
al = log(2)/8;
beta = 0.00600;
L = 1.6825e-5;
y0 = [1; beta./al/L];

[t,y] = ode45(@pointk,[0 60],y0);

figure(1)
subplot(2,1,1)
plot(t,y(:,1))
legend('Prompt neutrons ')
subplot(2,1,2)
plot(t,y(:,2))
legend('Delayed neutrons')

%% Övning 2
al=log(2)/8;
beta=0.00600;
L=1.6825e-05;
raa=80e-6;


A = [(raa-beta)/L al; beta/L -al];
[V,D] = eig(A);
diag(D)

%% Övning 3
if 0
    p = D(2,2); % 3a
else
    p = D(2,2)*12; % 3b
end

figure(2)
subplot(2,1,1)
plot(t,y(:,1),t, y0(1)*exp(t*p))
legend('Prompt neutrons ')
subplot(2,1,2)
plot(t,y(:,2))
legend('Delayed neutrons')

%% Övning 4
t2 = 10:100;
raa = dub2raa(t2);
figure(3)
plot(t2, raa)
shg
xlabel('Dubbleringstid')
ylabel('Reaktivitet')

%% Övning 5
[t, y] = ode45(@pointk,[0 60], [1; beta/L/al]);
[t1, rho, conc] = inv_kinetics(t,y(:,1));
figure(4)
subplot(3,1,1)
plot(t1,rho)

[t1, rho1, conc1] = inv_kinetics(t,y(:,1),beta,al);
subplot(3,1,2)
plot(t1,rho1)

subplot(3,1,3)
plot(t1, conc1, t, y(:,2))
