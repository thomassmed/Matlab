hold all
%%
w=100*pi;
H=.5*73559*w*w/1e6/580;
tc=0.21805;
[t,y]=ode45(@(t,y) Generator(t,y,tc,H),[-0.5 2],[pi*40/180;0]);
plot(t,y(:,1)*180/pi);grid on
%% Reconstruct all variables:
Y=zeros(length(t),3);
for i=1:length(t),
    Y(i,:)=Generator(t(i),y(i,:),tc,H,0);
end
figure;
subplot(2,1,1);
plot(t,Y(:,1),'linew',2);
ylim([-.1 1.2])
title('Voltage (pu)')
subplot(2,1,2);
plot(t,Y(:,3),'linew',2);
title('Pe (pu)')
%% En plot till
figure
subplot(211)
plot(t,y(:,2)*3000+3000)
grid
ylabel('Varvtal (rpm)')
subplot(212)
plot(t,y(:,1)*180/pi)
ylabel('delta (grader)')
xlabel('tid (s)')
grid