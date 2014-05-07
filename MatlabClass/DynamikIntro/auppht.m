%% 
a=2;
t=0:0.01:2;
h=0.0001;
y=a.^t;
yp=(a.^(t+h)-y)/h;
plot(t,[y;yp])
shg
%%
plot(t,yp./y)
ylim([0 2])
%mean(yp./y)-1
%% Titta nu på exp(k*t)
k=0.5;
y=exp(k*t);
yp=(exp(k*(t+h))-y)/h;
plot(yp./y)
ylim([k-0.2 k+0.2])
shg


