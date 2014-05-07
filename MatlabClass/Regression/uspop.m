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
%% Polynomial fit:
A=[ones(size(t)) t t.*t];
c=A\usp