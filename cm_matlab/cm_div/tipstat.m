%@(#)   tipstat.m 1.4	 05/12/08     15:55:24
%
%function [dev,keff,emed,efph,keofp,pow,hc]=tipstat(tipfiles,skip,skip2)
% Calculates  deviations, and keff for the specified files
%
% Input:
% tipfiles - vector of tipfiles to be processed
%
% Output:
%
%  dev - Matrix of POLCA-TIP deviations
%        Each row corresponds to a TIP-evaluation
%        The columns contain the following:
%           Nodal      Radial    Axial 
%        RMS    Max   RMS  Max  RMS Max
%         1      2     3    4    5   6 
%
%  keff - K-effective for each TIP
%  emed - Mean burnup (MWd/tU)
%  efph - EFPH in current cycle
%  keofp- K-effective for last TIP with Qrel>0.95*QMax
%
function [dev,keff,emed,efph,keofp,pow,hc]=tipstat(tipfiles,skip,skip2)
if nargin==0,
  tipfiles=findfile;
end
if nargin<2,skip=0;end
if nargin<3,skip2=0;end
ld=size(tipfiles,1);
keff=zeros(ld,1);
pow=keff;hc=keff;
efph=keff;emed=keff;dev=zeros(ld,8);
powmax=0;
for i=1:ld
  fil=tipfiles(i,:);id=find(fil==' ');fil(id)='';
  [burnup,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,staton,masfil]=...
  readdist7(fil,'burnup');
  emed(i)=mean(mean(burnup));
  keff(i)=bb(96);
  e=readdist7(fil,'EFPH');
%  efph(i)=min(e);
  efph(i)=bb(73);
  pow(i)=hy(11);
  hc(i)=hy(2);
  tipmea=readdist7(fil,'tipmea');
  tipmea=100*tipmea/mean(mean(tipmea));
  m=mean(tipmea);
  ii=find(m<0);
  it=strmatch('TIPGAM',distlist);
  if length(it)==0,
    itt=strmatch('TIPNEU',distlist);
    if length(itt)==0,
       disp(['Warning ',fil,' contains neither TIPGAM nor TIPNEU']);
       tipgam=tipmea;
    else
      tipgam=readdist7(fil,'tipneu');
    end
  else
    tipgam=readdist7(fil,'tipgam');
  end
  if ~isempty(ii),tipmea(:,ii)=[];tipgam(:,ii)=[];end
  for ii=1:skip
    s=size(tipmea);
    tipmea(s(1),:)=[];
    tipgam(s(1),:)=[];
  end
  for ii=1:skip2
    tipmea(1,:)=[];
    tipgam(1,:)=[];
  end
  tipmea=100*tipmea/mean(mean(tipmea));
  tipgam=100*tipgam/mean(mean(tipgam));
  ditip=tipgam-tipmea;
  dev(i,1)=std(ditip(:));
  dev(i,2)=minmax(ditip(:));
  dr=mean(ditip);
  dev(i,3)=std(dr);
  dev(i,4)=minmax(dr');
  da=mean(ditip');
  dev(i,5)=std(da);
  dev(i,6)=minmax(da');
%  if strcmp(masfil(5:6),'f1')|strcmp(masfil(5:6),'f2'),
%    keofpn=bb(51)+1e-3*(.0011*(9900-bb(2))+(bb(10)-273.0));
%  else    
   keofpn=bb(96);
%  end
  if nargout>4,
    powmax=max(hy(11),powmax);
    if hy(11)>0.95*powmax,  
       keofp=keofpn;
    end
  end
end
