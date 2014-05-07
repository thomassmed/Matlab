%% Assume we have the following data
t=[0 .3 .8 1.1 1.6 2.3]';
y=[.5 .82 1.14 1.25 1.35 1.4]';
plot(t,y,'x')
%% Polynomial fit:
A=[ones(size(t)) t t.*t];
A1=[ones(size(t)) exp(-t) t.*exp(-t)];

c=A\y
c1=A1\y
%% Evaluate at equally spaced point and plot
T=(0:.1:3)';
Y1=[ones(size(T)) exp(-T) T.*exp(-T)]*c1;
Y=[ones(size(T)) T T.*T]*c
hold on
plot(T,Y);
hold on
plot(T,Y1,'r');
figure(gcf)
