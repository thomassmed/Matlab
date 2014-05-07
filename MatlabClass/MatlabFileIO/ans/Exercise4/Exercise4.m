%% Exercise - Read binary file
%% Open file
fid = fopen('Exercise4.dat','rb');

%% Read 5x2 matrix of 32-bit integers
ia = fread(fid,[2,5],'*uint32');
ia_sum = sum(ia);

%% Read 5x2 matrix of single precision float values
fa = fread(fid,[2,5],'*float');
fa_sum = sum(fa);

%% Read random double precision values
ra = fread(fid,100,'*double');
ra_avg = mean(ra);

%% Move back to the single precision array (10 integers @ four bytes in)
fseek(fid,40,'bof');

%% Read it as a vector of size 10
fa2 = fread(fid,10,'*float');

%% Close file
fclose(fid);