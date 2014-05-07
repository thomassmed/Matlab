function [data,desc]=ReadEnigmacsv(csvfile)
% ReadEnigmacsv - Reads Enigma data from a csv file
%
% Input
%   csvfile - file name on csv file
%
% Output
%   data    - Nvar-by-N matrix with the numerical data where Nvar is the
%             number of variables stored
%   desc    - Struct containing labels for the stored variabels, number of
%             data points, title etc
%
%  Example
%   [data,desc]=ReadEnigmacsv('e78-01.csv');
%   plot(data(:,1));title(['Plot of ',desc.labels{1}]);
%
% See also ReadEnigma



%% Open the file and read the data;
fid=fopen(csvfile);
header=textscan(fid,'%s',3,'delimiter','\n');
header=header{1};
numberscell=textscan(fid,'%f','delimiter',',');
numbers=numberscell{1};
fclose(fid);
%% Analyze the header
desc.titel=header{1};
ikeyf=strfind(header{2},'KEYF=');
keyf=sscanf(header{2}(ikeyf+5:ikeyf+8),'%i');
ikeyr=strfind(header{2},'KEYR=');
keyr=sscanf(header{2}(ikeyr+5:ikeyr+8),'%i');
ikeyz=strfind(header{2},'KEYZ=');
istop=min(ikeyz+8,length(header{2}));
keyz=sscanf(header{2}(ikeyz+5:istop),'%i');
%%
ilab=strfind(header{3},'#');
icomma=strfind(header{3},',');
Nvar=length(ilab);
desc.labels=cell(20,1);
for i=1:Nvar,
    desc.labels{i}=header{3}(ilab(i)+1:icomma(i)-1);
end
desc.keyf=keyf;
desc.keyr=keyr;
desc.keyz=keyz;
desc.Nvar=Nvar;
%% Fix the data
desc.N=length(numbers)/Nvar;
data=reshape(numbers,desc.Nvar,desc.N)';