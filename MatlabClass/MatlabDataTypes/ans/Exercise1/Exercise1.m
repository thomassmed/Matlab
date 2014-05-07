%% Exercise 1 - Highest Grossing Films

%% 1.1 Import data
[data,textdata] = xlsread('Exercise1.xls');
% or use Import Wizard

%% 1.2 Extract movie titles
titles = textdata(6:end,1);

%% 1.3 For each movie, compute its total revenue
us_receipts = data(:,2);
intl_receipts = data(:,3);
total_receipts = us_receipts + intl_receipts;

%% 1.4 Sort the movie titles according to total revenues
[sorted_revenue1, sortIdx1] = sort(total_receipts,'descend'); 
sorted_titles = titles(sortIdx1);

%% 1.5 Create serial date numbers
dates = data(:,4)+693960;
strdates=datestr(dates);

%% 1.6 Sort release dates and revenue
[sorted_dates,sortIdx2] = sort(dates);
sorted_revenue2 = total_receipts(sortIdx2);