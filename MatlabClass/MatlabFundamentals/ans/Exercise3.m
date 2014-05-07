%% Exercise 3
%% Define a matrix Prices from column 2 to the end of the matrix data
load ../gasprices
data(1,2)=data(2,2); % Fix the missing data in Australia
Prices=data(:,2:end);
%% 3.1 Calculate the average price for each country
mean(Prices)
%% 3.2 Plot the yearly average price for all countries
figure
plot(Year,mean(Prices'))
%% 3.3 Plot the yearly average price in Europe and the Americas
ieur=[3 4 5 9];
iam=[2 7 10];
figure
plot(Year,mean(Prices(:,ieur)'))
hold on
plot(Year,mean(Prices(:,iam)'),'r')
legend('Europe','America');
%% Exercise 3b
%% Calculate the number of elements that are greater than 0.8
A=rand(1000);
sum(A(:)>.8)/numel(A)
