%% Exercise 1 - World's Tallest Buildings

%% 1.1 Import data
load Exercise1.mat

%% 1.2 Convert height from feet to meters
height_meters = height_feet * 0.3048;

%% 1.3 How many buildings are over 400 m high?
nnz(height_meters > 400)
% What are their heights?
height_meters(height_meters > 400)
% What are their names and where are they located?
[bldg_name(height_meters > 400),city(height_meters > 400),country(height_meters > 400)]

%% 1.4 Which buildings over 400 m high were topped out before 2000?
bldg_name((height_meters > 400) & (year < 2000))

%% 1.5 Which buildings were topped out before 1950 and are higher than 250 m?
bldg_name((year < 1950) & (height_meters > 250))
% In which cities are they located?
city((year < 1950) & (height_meters > 250))
% When were they topped off?
year((year < 1950) & (height_meters > 250))

%% 1.6 How many buildings are in Australia?
nnz(strcmp('Australia', country))