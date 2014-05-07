%% Read in gasprices
[data,textdata]=xlsread('../gasprices.xls');
%% Get the columnheaders
colheaders=textdata(end,:);
%% Put the variables in reasonable names
for i=1:length(colheaders),
    evstr=[genvarname(colheaders{i}),'=data(:,i);'];
    eval(evstr);
end
%% Take a look at the last evstr:
disp(evstr)
%% Explore what  variables we have in workspace
whos