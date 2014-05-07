function [A,sond_nr]=ReadTip(filename,calc)
% [A,sond_nr]=ReadTip(filename,type)
%
% Input
%   filename - filename, typically .sum or .det
%   type     - read type    1 - 'DET.DIS MEASURED--  TRR1'
%                           2 - 'DET.DIS CALCULATED- TRR1'
%                           3 - 'DET.DIS CALCULATED- TRR2'
%                           4 - 'DET.DIS CALCULATED- TGMW'
% Output
%   A       - (cell array of) Detector readings
% sond_nr   - (cell array of) Detector numbers
if nargin==1, calc=1;end
if ischar(calc),
    str=calc;
else
    switch calc
        case 1
            str='DET.DIS MEASURED--  TRR1';
        case 2
            str='DET.DIS CALCULATED- TRR1';
        case 3
            str='DET.DIS CALCULATED- TRR2';
        case 4
            str='DET.DIS CALCULATED- TGMW';
    end
end
if strcmp(str,'DET.DIS MEASURED--  TRR1'),
    [A,sond_nr]=ReadTipMeas(filename);
    return;
end
TEXT=ReadAscii(filename);
idis=find(~cellfun(@isempty,regexp(TEXT,['^',str])));
N=length(idis);
A=cell(1,N);sond_nr=cell(1,N);
nsond=zeros(1,N);kmax=nsond;
for i=1:N,
   formatrow=TEXT{idis(i)+1};
   icount=idis(i)+1;
   nrows=length(strfind(formatrow,'/'));
   nn=sscanf(formatrow,'%g');
   nsond(i)=nn(1);kmax(i)=nn(2);
   A{i}=nan(kmax(i),nsond(i));
   sond_nr{i}=nan(1,nsond(i));
   for i1=1:nsond(i),
       icount=icount+1;
       temp=sscanf(TEXT{icount},'%g');
       sond_nr{i}(i1)=temp(1);temp(1)=[];
       kcount=0;
       A{i}(1:length(temp),i1)=temp;
       kcount=kcount+length(temp);
       for i2=1:nrows,
           icount=icount+1;
           temp=sscanf(TEXT{icount},'%g')';
           A{i}(kcount+1:length(temp)+kcount,i1)=temp;
           kcount=kcount+length(temp);
       end
   end
end
if length(A)==1,
    A=A{1};
end
if length(sond_nr)==1,
    sond_nr=sond_nr{1};
end
