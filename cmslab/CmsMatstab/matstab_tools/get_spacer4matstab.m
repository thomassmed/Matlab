function [vhspx,rhspx,zspx,ispac]=get_spacer4matstab(fue_new)
% prepare spacer data for matstab from Simulate 3 restart file data
%
% Input:
%   fue_new - structured variable that is output from read_estart_bin
%
%
% Output 


%% 
% This function is really not good, but it is compatible with matstab and
% that's what it's for
nhyd=fue_new.nhyd;
zspx=[];
kan=fue_new.kan;
for i=unique(nhyd)
    bspa=fue_new.zspacr(i,:);bspa(find(isnan(bspa)))=[];  % Remove NaN
    zspa=bspa(1:end)';nspac(i)=length(zspa);
    Zspa{i}=zspa;
    zspx=[zspx;zspa];     
end
zspx=unique(zspx);
vhspx=zeros(kan,length(zspx));
%%
index=0;
xkspac=fue_new.xkspac;
xxkspa=fue_new.xxkspa;
inan=find(xxkspa==-10000);xxkspa(inan)=NaN;
for i=unique(nhyd),
     ii=find(nhyd==i);
     bspk=xxkspa(i,:);bspk(find(isnan(bspk)))=[];  % Remove NaN
     if isempty(bspk),
         bspk=xkspac(i)*ones(size(Zspa{i}));
     end
     Bspk{i}=bspk;
     for j=1:nspac(i)
        izz=find(Zspa{i}(j)==zspx);
        vhspx(ii,izz)=bspk(j);
     end
end
%%
idum=find(~any(vhspx));
zspx(idum)=[];
vhspx(:,idum)=[];
ibort=find(~diff(zspx));
vbort=vhspx(:,ibort);
vhspx(:,ibort+1)=vhspx(:,ibort+1)+vbort;
vhspx(:,ibort)=[];
zspx(ibort)=[];
ispac=length(zspx);
rhspx=0.0*(vhspx>0);
vhspx=-vhspx;
zspx=zspx/100;