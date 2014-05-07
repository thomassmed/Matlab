%% Exakt lösning av N
h=.01;
t=0:h:5;

N=exp(-t);
plot(t,N);

%% Euler framåt

NE=zeros(size(t));
NE(1)=1;

for i=2:length(t)
    NE(i)=NE(i-1)-h*NE(i-1);
end

hold off
plot(t,NE);
hold on
plot(t,N,'m');
shg