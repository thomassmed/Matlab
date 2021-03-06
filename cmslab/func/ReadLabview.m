function dstruct=ReadLabview(filename)
% ReadMother - reads data from LABview
%
% Input:
%   filename - File name for file to be read
%
% Output:
%   dstruct  - Structure with data
%    .beskrivning -General description
%    .sig         - Description of signal contents
%    .varnam      - Variable names
%    .data        - data
%
%

%%
fid=fopen(filename,'r');

for i=1:200,
    rad=fgetl(fid);
    header1{i,1}=rad;
    if strncmp(rad,'***End_of_Header***',19);rawfile=true;break;end
    if strncmp(rad,'%***End_of_Header***',20);rawfile=false;break;end
end

%%
if rawfile, %get rid of tab if we are dealing with a raw data file
    rad=fgetl(fid); 
end

for i=1:200,
    rad=fgetl(fid);
    header2{i,1}=rad;
    if strncmp(rad,'***End_of_Header***',19);break;end
    if strncmp(rad,'%***End_of_Header***',20);break;end
end

%%
rad=fgetl(fid);
tabs=find(rad==9);
varnam=cell(length(tabs),1);
varnam{1}=rad(1:tabs(1)-1);
for i=2:length(tabs),
    varnam{i}=rad(tabs(i-1)+1:tabs(i)-1);
end
Nc=sscanf(header2{1}(10:end),'%i');
slask=textscan(fid,'%f\t');
fclose(fid);
%%
l=length(header1);
if exist('file','file'),
    header1{l+1}=file('normalize',filename);
else
    header1{l+1}=filename;
end
dstruct.beskrivning=header1;
dstruct.sig=header2;
dstruct.varnam=varnam;
dstruct.data=reshape(slask{1},(Nc+1),length(slask{1})/(Nc+1))';

