%% 1 Run matstab on c13-2.inp include Harmonics
matstab ../c13-2.inp Harmonics 2
%% 
cmsplot ../c13-2.mat
%% 2 Select shallow control rods (a group of four) to insert and change the rod pattern
matstab ../c13-2-shallow.inp Harmonics 2
%% 3 Split the group in 2 and try with the NW-SE pair and the NE-SW pair
matstab ../c13-2-shallow-half.inp Harmonics 2


