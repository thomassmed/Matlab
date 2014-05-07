%% Exercise 2 - Read data using textscan
%% Open file
fid = fopen('Exercise2.txt','r');

%% Read the four headers
header = textscan(fid,'%s',4);

%% Read the data
data = textscan(fid,'%s%u%f%s');

%% Close the file
fclose(fid);

%% 2.1 How many females competed?
nfemales = numel(find(strcmp('F',data{4})));

%% 2.2a Average age of contenders
avg_age = mean(data{3});

%% 2.2b Average age of male contenders
avg_age_male = mean(data{3}(strcmp('M',data{4})));

%% 2.2c Average age of female contenders
avg_age_female = mean(data{3}(strcmp('F',data{4})));

%% 2.2d How many men are between 30 and 50 years old?
nmen30_50 = numel(data{3}(data{3} >= 30 & data{3} <= 50 & strcmp('M',data{4})));