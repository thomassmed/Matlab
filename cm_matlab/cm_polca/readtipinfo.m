%@(#)   readtipinfo.m 1.2	 97/12/29     10:19:20
%
%function [tipnr,tipmat,inter,tippar]=readtipinfo(infofile);
function [tipnr,tipmat,inter,tippar]=readtipinfo(infofile);
if nargin==0,
  infofile=[findreakdir 'fil/tip-info.txt'];
end
fid=fopen(infofile,'r');
rad=fgetl(fid);
ti1=sscanf(rad,'%i');
ti1=ti1';
rad=fgetl(fid);
fclose(fid);
ti2=sscanf(rad,'%i');
ti2=ti2';
tipnr=ti2(1:ti1(1));
tipmat=zeros(ti1(1),ti1(2));
inter=ti1(3);
tippar=ti1;
for i=1:ti1(2)
  v=find(ti2(1:ti1(1))==i)';
  ii=find(v==inter);
  if ~isempty(ii),v(ii)=[];end
  tipmat(1:length(v),i)=v;
end
[i,j]=find(tipmat);
for ii=ti1(1):-1:max(i)+1,tipmat(ii,:)=[];end
