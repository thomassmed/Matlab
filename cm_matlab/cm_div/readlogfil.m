%@(#)   readlogfil.m 1.3   97/02/24     12:53:15
%
%function [dat,signal]=readlogfil(sourcefil,kpunkt,tid)
% 
% Reads signal from a logfile stored by lnglog
%If a signal is marked with error ('*'), it is assigned the value -32000
%Example:[dat,signal]=readlogfil('log-24.txt','521K007');
%        [dat,signal]=readlogfil('log-24.txt',['521K007';'521K049']);
%To plot do:   tid=dat2tim(dat);datplot(tid,signal);
function [dat,signal]=readlogfil(sourcefil,kpunkt,tid)
fid=fopen(sourcefil,'r');
if nargin<3, tid=1e10;end
rad=fgetl(fid);
rad=fgetl(fid);
lk=size(kpunkt,1);
signal=zeros(1,lk);
while ~strcmp(upper(rad(1:3)),'DAT')
  rad=fgetl(fid);
end
j=zeros(lk,1);
for i=1:50,
  rad=fgetl(fid);
  if strcmp(upper(rad(1:3)),'LOG'), break;end
  jflag=zeros(lk,1);
  for ii=1:lk,
    jj=findstr(rad,remblank(kpunkt(ii,:)));  
    if length(jj)>0, i1(ii)=floor((i+1)/2);i2(ii)=5*(i+1-2*i1(ii))+floor(jj/10)+1;end
  end
end
for N=1:1000,
  i=find(rad=='-');
  dat(N,1:3)=[str2num(rad(i(1)-4:i(1)-1)) str2num(rad(i(1)+1:i(2)-1)) str2num(rad(i(2)+1:i(2)+2))];
  i=find(rad=='.');
  dat(N,4:5)=[str2num(rad(i(1)-2:i(1)-1)) str2num(rad(i(1)+1:i(2)-1))];
  if dat2tim(dat(N,:))>tid, dat(N,:)=[]; break;end
  rad=fgetl(fid);
  for i=1:50,
    rad=fgetl(fid);
    if ~isstr(rad), iflag=0; break;end
    if strcmp(upper(rad(1:3)),'LOG'), iflag=1;break;end
    ii=find(i1==i);
    islask=find(rad=='*');
    rad(islask)=[];
    islask=floor(islask/8);
    f=sscanf(rad,'%f');
    if length(ii)>0,
      signal(N,ii)=f(i2(ii))';
      ifel=[];
      if length(islask)>0,
        ifel=find(findint(i2(ii),islask));
      end
      if  length(ifel)>0,
         signal(N,ii(ifel))=-32000*ones(1,length(ifel));
      end
    end
  end
  if iflag==0, break;end  
end
