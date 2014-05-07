function [t,y]=Euler(f,tint,y0,h)

t=tint(1):h:tint(2);
y=zeros(length(y0),length(t));
y(:,1)=y0;

for i=2:length(t),
    y(:,i)=y(:,i-1)+h*f(t(i),y(:,i-1));
end
t=t(:);
y=y';