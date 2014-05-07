%% Exercise1 - Using xlsread
%% Open file
[num,txt,raw] = xlsread('Exercise1.xls');

%% 1.1 What was the average price of gas in the U.S. for 2006?
us_2006 = num((num(:,1) == 1996),11);

%% 1.2 What was the average price of gas in Italy from 1995-2005?
italy_avg = mean(num((num(:,1) >= 1995 & num(:,1) <= 2005),6));

%% 1.3 Which country had the highest average fuel prices in 1998?
[max_val,max_idx] = max(num((num(:,1) == 1998),2:11));
% The index value is now relative to columns 2:11, not the whole array
% so we have to add 1 to it when referencing the original array
high_1998 = txt{5,max_idx+1};