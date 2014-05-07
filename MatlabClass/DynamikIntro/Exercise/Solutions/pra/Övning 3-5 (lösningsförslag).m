%% �vning 3. L�s dy/dt=-y+sin(t), med y(0)=0 fr�n 0s till 10 s
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
%% �vning 4 L�s �vn 3 genom att anv�nda tf och lsim
G=tf(1,[1 1])
y1=lsim(G,u,t);
figure
plot(t,u)
hold on
plot(t,y1,'r')
%% �vning 5. Best�m f�st�rkning och fasf�rskjutning genom att utnyttja G(jw)
Gjw=1/(1+1j);
abs(Gjw)
angle(Gjw)*180/pi