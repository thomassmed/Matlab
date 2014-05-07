function Eulerex(dt)
%% Illustrate how explicit and implicit integration impacts the damping
%% First define the variables
A=[0      1
  -9.01  -.2];
t=0:dt:10;
N=length(t);
x=zeros(2,N);
x(:,1)=[1;0]; % The string is pulled down and released
%% Exact solution I
x0=[1 0]';
X=nan(2,N);
[V,D]=eig(A);
for i=1:N,
    X(:,i)=V*expm(D*t(i))*(V\x0);
end
%% Exact solution II
y=exp(-.1*t).*cos(3*t)+.1/3*exp(-.1*t).*sin(3*t);
%% Explicit integration or Euler forward
for i=2:N
    x(:,i)=x(:,i-1)+(t(i)-t(i-1))*A*x(:,i-1);
end
%% Implicit integration or Euler backward
xb=zeros(2,N);
xb(:,1)=[1;0];
for i=2:N,
    xb(:,i)=(eye(2)-(t(i)-t(i-1))*A)\xb(:,i-1);
end
%% Exact Predictor - Corrector
xp=zeros(2,N);
xp(:,1)=[1;0];
for i=2:N
    xp(:,i)=(eye(2)-(t(i)-t(i-1))*A/2)\(eye(2)+(t(i)-t(i-1))*A/2)*xp(:,i-1);
end
%% practical predictor-corrector
xpp=xp;
for i=1:N-1
    h=t(i+1)-t(i);
    fti=A*xpp(:,i);
    yi=xpp(:,i);
    yg=yi+fti*h;
    for j=1:10,
        ygp=yi+h/2*(fti+A*yg);
        if norm(ygp-yg)<1e-6, break;end
        yg=ygp;
    end
    xpp(:,i+1)=ygp;
end  
%% Now plot
hold off
plot(t,y)
hold on
he=plot(t,x(1,:),'color',[0 .8 0]);
plot(t,xb(1,:),'r');
plot(t,xp(1,:),'m');
plot(t,xpp(1,:),'k');
legend('Exact','Explicit','Implicit','Exact P-C','Practical P-C');
%set(he,'linewidth',2);
figure(gcf)
%%
[d,f]=p2drfd(-.1+3j);
[~,~,~,~,drx]=get_phasor(t',x(1,:)',d,f,0);
[~,~,~,~,drb]=get_phasor(t',xb(1,:)',d,f,0);
[~,~,~,~,drp]=get_phasor(t',xp(1,:)',d,f,0);
[~,~,~,~,drpp]=get_phasor(t',xpp(1,:)',d,f,0);
fprintf('Time step (ms)  Correct dr   Euler forward  Euler Backward  Pred-corr  Pract Pred-corr \n');
fprintf('      %5i    %8.4f       %8.4f        %8.4f    %8.4f        %8.4f\n',round(1000*(t(2)-t(1))),d,drx,drb,drp,drpp);
er=drx-d;
