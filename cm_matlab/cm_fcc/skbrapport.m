%@(#)   skbrapport.m 1.2	 94/08/12     12:15:41
%
%function skbrapport(prifil,matfil)
%Respons to letter from SKB
% 
% Input:
%      prifil - printfile, default='skb-rapport.lis'
%      matfil - output file from bunhist, default=/cm/fx/div/bunhist/utfil.mat
%
function skbrapport(prifil,matfil)
reakdir=findreakdir;
if nargin<1,
  prifil='skb-rapport.lis';
  disp('results will be printed on skb-rapport.lis');
end
if nargin<2,
  matfil=[reakdir,'div/bunhist/utfil.mat'];
end
if isstr(prifil),
  fid=fopen(prifil,'w');
else
  fid=prifil;
end
load(matfil);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton]=readdist(DISTFIL(1,:));
nbu=length(ITOT);
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
[eladd,garburn,antot,levyear,enr,buntot,weight,eta]=readbatch(batchfile);
imax=size(buntot,1);
irad=findeladd(BUNTYP,buntot,levyear);
garbun=garburn(irad)';
weibun=weight(irad)';
i1=find(lastcyc<max(lastcyc)&ONSITE&kinf<0.93); %Utbrant
i2=find(lastcyc<max(lastcyc)&ONSITE&kinf>0.93); %Aterins.
i3=find(lastcyc==max(lastcyc)); %Hard
vikt1=round(sum(weibun(i1)));
vikt2=round(sum(weibun(i2)));
ant1=length(i1);
ant2=length(i2);
rest2=(garbun(i2)-burnup(i2)/1000).*weibun(i2).*2.4e-5*eta;
rest2=sum(rest2);
rest3=(garbun(i3)-burnup(i3)/1000).*weibun(i3).*2.4e-5*eta;
rest3=sum(rest3);
fprintf(fid,'\n\n');
fprintf(fid,'\t%s%s',staton,':  Rapport till SKB');
fprintf(fid,'\n\n');
fprintf(fid,'\t%s\t%s\t\t%s','Fardigutbrant','Aterins.','Hard');
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%s\t%s\t%s\t%s','kgU','Antal','kgU','Antal','TWhe','TWhe');
fprintf(fid,'\n');
fprintf(fid,'\t%i\t%i\t%i\t%i\t%5.2f\t%5.2f',vikt1,ant1,vikt2,ant2,rest2,rest3);
fprintf(fid,'\n');
end
