% �vning 3-5 samt �vning Simpel Models 1-4

%% �vning 3-5
% �vning 3
% L�s dy/dt = -y + u numeriskt med Euler fram�t i tidsintervallet [0,20], 
% d�r u = sin(t) och y(0) = 0. Best�m f�rst�rkning och fasf�rskjutning.

clear all;
h = 0.01;                               %tidssteg
t = 0:h:20;                             %tidsvektor
y = zeros(size(t));                     %pre-allokering samt y(1)=yinit = 0
u = sin(t);                             %

for i=1:length(t)-1
    y(i+1) = (1-h)*y(i)+h*u(i);         %Euler fram�t
end

%% �vning 4
%Upprepa �vning 3 men anv�nd tf och lsim kommandona ist�llet.

s=tf('s');
G = 1/(1+s);
y_lsim = lsim(G,u,t);

% �vning 5
[mag,phase] = bode(G,1);

figure(1)
plot(t,y,'go', t, y_lsim,'k', t, u,'b')
%plot(t,y,'k')
%plot(t,y_lsim,'b')
%plot(t,u,'r')
legend('y Euler fram�t', 'y lsim', 'u')
title('�vning 3-5: dy/dt = -y + u, u=sin t')
xlabel('t')
ylabel('y')
text(3,0.8,num2str(mag))
text(4,0.6,num2str(phase))