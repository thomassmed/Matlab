%%
% Here is the US Census data from 1900 to 2000.

% Time interval
t = (1900:10:2000)';

% Population
usp = [75.995 91.972 105.711 123.203 131.669 ...
     150.697 179.323 203.212 226.505 249.633 281.422]';

% Plot
plot(t,usp,'bo');
axis([1900 2020 0 400]);
title('Population of the U.S. 1900-2000');
ylabel('Millions');
hold on
%% Manual polynomial fit and svd
N=length(t);
A=[ones(N,1) t t.^2]
%% 
s=svd(A)
%% 
s(2:3)
%% svd
[u,s,v]=svd(A,0)
%% Center and scale:
z=(t-1950)/50;
A2=[ones(N,1) z z.^2]
%% Check the singular values
svd(A2)
%% and the matrices
[u2,s2,v2]=svd(A2,0)
%% 
x2=A\usp
plot(t,A*x2)
figure(gcf)
%% Now try third order
A3=[A2 z.^3];
svd(A3)
x3=A3\usp
plot(t,A3*x3,'r')
figure(gcf)
%%


