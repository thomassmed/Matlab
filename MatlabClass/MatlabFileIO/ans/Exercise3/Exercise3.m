%% Exercise 3 - Read and write text files
%% Open file
rfid = fopen('Exercise3.txt','r');

%% Create new file
wfid = fopen('Exercise3_reorder.txt','w');

%% Read (skip) the headers
fgetl(rfid);

%% Write new headers
fprintf(wfid,'Rank Sex Age   Name\n');

%% Read, re-order and save lines
while(~feof(rfid))
    % Read line.
    % Note: use of %6c
    line = fscanf(rfid,'%6c %u %f %c\n',4);

    % Write data to new file in new order
    fprintf(wfid, ' %2u  %s   %4.1f  %s\n', ...
	    line(7),char(line(9)),line(8),strtrim(char(line(1:6))));
end

%% Close the files
fclose(rfid);
fclose(wfid);