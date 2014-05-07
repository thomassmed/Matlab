%% load the data
[data,textdata,raw]=xlsread('../gasprices.xls');
%% Define colheaders
colheaders=textdata(end,:);
%% save into gasprices.mat
save gasprices
%% Define variables for prices in Germany and Mexico and a vector with the years 
Germany=data(:,5);
Mexico=data(:,8);
Year=data(:,1);
Prices=data(:,2:end);
%% Compute simple statistics
mean(Germany)
%% Average price/country
mean(Prices)
%% Median
median(Germany)
%% Max
max(Germany)
%% Max and grab the the index
[MaxGer,Maxindex]=max(Germany)
%% Min
min(Germany)
%% Of course the same goes for min
[MinGer,Minindex]=min(Germany)
%% Standard deviation
std(Germany)
%% Or rms
std(Germany,1)
%% Compute the average price in France and Germany
France=data(:,4);
FraGer=0.5*France+0.5*Germany;
plot(Year,France)
hold all
plot(Year,Germany)
plot(Year,FraGer)
legend('France','Germany','Av price Fra & Ger')
%% Sometimes, you want to remove the average value
Gervar=Germany-mean(Germany)
Gerdetrend=detrend(Germany,1);
figure
plot(Year,Gervar);
hold all
plot(Year,Gerdetrend,'r')

