function [y,t]=ex6_23(N,T,dt)
%% Exercise 6.3
if nargin<1, N=5;end
if nargin<2, T=10;end
if nargin<3, dt=0.01;end
% 56.4
if length(T)>1
    t=T;
else
    t=0:dt:T;
end

% Exercise 6.2
v=randn(size(t));
y = 0.5*t.^2 + 2*t + 10*sin(pi*t/N)+ 2*v;
plot(t,y);
figure(gcf)