function [t,y]=ode1(f,ti,y0)

N=1000;
h=diff(ti)/N;
t=linspace(ti(1),ti(2),N);
y=zeros(length(t),length(y0));
y(1,:)=y0';
for i=2:length(t),
    y(i,:)=y(i-1,:)+h*f(t(i-1),y(i-1,:))';
end
