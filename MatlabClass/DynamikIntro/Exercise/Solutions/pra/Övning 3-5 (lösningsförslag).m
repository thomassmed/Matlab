%% Övning 3. Lös dy/dt=-y+sin(t), med y(0)=0 från 0s till 10 s
h=0.001;
t=0:h:20;t=t';
u=sin(t);
y=zeros(size(u));
for i=2:length(t),
    y(i)=y(i-1)+h*(-y(i-1)+u(i-1));
end
plot(t,u)
hold
plot(t,y,'r')
%% Övning 4 Lös övn 3 genom att använda tf och lsim
G=tf(1,[1 1])
y1=lsim(G,u,t);
figure
plot(t,u)
hold on
plot(t,y1,'r')
%% Övning 5. Bestäm föstärkning och fasförskjutning genom att utnyttja G(jw)
Gjw=1/(1+1j);
abs(Gjw)
angle(Gjw)*180/pi