%%
% y(t)=y(t-1)*(1-h)+h*u(t-1)
h=0.01;
t=0:h:20;
u=sin(t);
y0=zeros(1,length(t));
y0(1)=0;

for i=2:length(t)
    y0(i)=y0(i-1)*(1-h)+h*u((i-1));
end

plot(t,y0);

%%
%y=u/(1+s)

G=tf(1,[1,1]);
y1=lsim(G,u,t);

hold on
plot(t,y1,'r')

legend('Euler framåt','Lsim')
shg

%%

