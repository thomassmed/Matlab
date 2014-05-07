function [dat,num]=ramin2mat(f_ramona);

% [dat,num]=ramin2mat(f_ramona);
%
% reads all lines that start with a cardnumber from a ramona inputdesk.
%
% num = vector with card numbers
% dat = corresponding data
%
% ex: i=find(num==200000); KMAX=mat(i,3);
%

%@(#)   ramin2mat.m 1.8   99/05/31     13:53:29

f_ramona=expand(f_ramona,'inp');
fid=fopen(f_ramona);
file = fread(fid);
po=[0;find(file==10)];
dat=zeros(1600,40);
j=1;

spacer_p7=[];

for i = 1:length(po)-1
  [dat1,nout]=sscanf(setstr(file(po(i)+1:po(i+1)-1)'),'%f');
  if ~isempty(dat1)
    if dat1(1)==332000
    elseif dat1(1)==339900,
    elseif dat1(1)==289900,
    else
       dat(j,1:nout)=dat1';
    end
    j=j+1;
  end
end

i=find(dat(:,1)>99999 & dat(:,1) < 1000000);
dat=dat(i,:);
num=dat(:,1);
dat(:,1)=[];
fclose(fid);



