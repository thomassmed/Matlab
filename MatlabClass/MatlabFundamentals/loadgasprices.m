%% Read in gasprices
[data,textdata]=xlsread('gasprices.xls');
%% Get the columnheaders
colheaders=textdata(end,:);
%% Put the variables in reasonable names
for i=1:length(colheaders),
    evstr=[genvarname(colheaders{i}),'=data(:,i);'];
    eval(evstr);
end
%% Save everything to file, clear i and evstr first
clear i evstr
save gasprices
