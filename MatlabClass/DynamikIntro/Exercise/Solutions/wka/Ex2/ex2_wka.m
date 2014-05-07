%% Första pappret
% Övning 2 & 3
% Konstanter
k=1.01;
c=0.2;
A=[0 1; -k -c];
dt = 1e-3;
x_init = [1 -0.1]';
t_start = 0;
t_end = 20;

% Tidsvektor
t = t_start:dt:t_end;

% Allokerar x
x = zeros(length(A), length(t));

% Loop
x(:,1)=x_init;
for k =1:length(t)-1
    x(:,k+1) = x(:,k) + dt*A*x(:,k);
end

figure(1)
plot(t,x(1,:),t,x(2,:),'r')
legend('Läge', 'Hastighet')
shg

%% Övning 4
[v,e]=eig(A)

exp_comp = x_init(1)*exp(real(e(1,1))*t);

figure(2)
plot(t,x(1,:),t,x(2,:),'r', t,exp_comp,'k')
legend('Läge', 'Hastighet','Dämpning')

grid on
shg

figure(3),clf
subplot(1,2,1)
compass(v(:,1))
subplot(1,2,2)
compass(v(:,2),'r')

%% Test
for k=1:length(t)
    x_test(k,:) = v*expm(e*t(k))*inv(v)*x_init;
end
figure(4)
plot(t,real(x_test))
shg

%% Andra pappret
% Övning 3 & 4
close all, clear all
y_init = 0;
h =1e-2;
t=0:h:20;

y = zeros(size(t));
y(1) = y_init;
u=sin(t);
for k=1:length(t)-1
    y(k+1)=(1-h)*y(k)+h*u(k);
end

s=tf('s');
G = 1/(1+s);
y_lsim = lsim(G,u,t);

figure(1)
plot(t,y, t, y_lsim, t, u)
legend('y Euler framåt', 'y lsim', 'u')

% Övning 5
[mag,phase] = bode(G,1);