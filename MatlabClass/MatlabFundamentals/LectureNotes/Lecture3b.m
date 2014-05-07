%% load some data
load ../gasprices
%% Determining size
s=size(data)
[m,n]=size(data)
%% Understanding the difference between size and length
Year=data(:,1);
size(Year)
%% Understanding the difference between size and length
length(Year)
%% Understanding the difference between size and length
length(data)
%% Number of elements is another useful command
numel(Year)
%% Number of elements is another useful command
numel(data)
%% Produce the same result as numel with length:
length(data(:))
