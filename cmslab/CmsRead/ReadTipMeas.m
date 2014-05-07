function [A,sond_nr]=ReadTipMeas(filename)
% [A,sond_nr]=ReadTipMeas(filename)
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
str='DET.DIS MEASURED--  TRR1';
fid=fopen(filename,'r');
blob=fread(fid,'*char')';
TEXT=blob2cell(blob);
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
   [ii,ff,exp]=parseformat(formatrow);
   prec=strfun('range', regexpi(formatrow,'[fFeE][0-9]+[.][0-9]+', 'match', 'once'), 2, 'end');
   A{i}=nan(kmax(i),nsond(i));
   sond_nr{i}=cell(1,nsond(i));
   for i1=1:nsond(i),
       icount=icount+1;
       rad=TEXT{icount};
       sond_nr{i}{i1}=rad(1:ii);
       rad(1:ii)=[];
       temp=str2num(reshape(rad',ff,length(rad)/ff)');
       kcount=0;
       A{i}(1:length(temp),i1)=temp;
       kcount=kcount+length(temp);
       for i2=1:nrows,
           icount=icount+1;
           rad=TEXT{icount};
           %rad(1:ii)=[];
           %temp=str2double(reshape(rad',ff,length(rad)/ff)');
           %temp=sscanf(rad,'%g');
           if(exp)
               % Exponential format must be read by sscanf
               temp=sscanf(rad,['%',num2str(ff),'f']);
           else
               % strread also works when there's no space between the
               % numbers
               temp=textscan(rad,['%',num2str(prec),'f']);
               temp=temp{1};
           end
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


function [ii,ff,exp]=parseformat(formatrow)
%%
ifind=regexp(formatrow,'[iI]');
ii=sscanf(formatrow(ifind(1)+1:end), '%i');
%%
ffind=regexp(formatrow,'[fFeE]');
ff=sscanf(formatrow(ffind(1)+1:end), '%i');
exp=0;
if(formatrow(ffind(1)) == 'e' || formatrow(ffind(1)) == 'E')
    exp=1;
end