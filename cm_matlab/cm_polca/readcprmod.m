%@(#)   readcprmod.m 1.8	 07/07/03     12:29:00
%
function [cprmin,medel,stand,forboj,distfile,buidnt,lhrstraff,cprstraff]=readcprmod(indatafil);
mbui=[];
lhrstraff=[];
cprstraff=[];
fid=fopen(indatafil);
lin=fgetl(fid);
for i=1:1000,
  ll=length(lin);
  if ~isstr(lin),
    break;
  elseif ll>3,
    if strcmp(lin(1:8),'DISTFILE')
      distfile=remblank(lin(9:length(lin)));
      fid1=fopen(distfile,'r');
      a=fread(fid1,50,'int');
      fclose(fid1);
      lin=fgetl(fid);
    elseif strcmp(lin(1:8),'FUELFILE')   % Att anvandas i en framtid
      fuelfile=remblank(lin(9:length(lin)));
      iii=find(fuelfile=='.');
      if length(iii)==0, fuelfile=[fuelfile,'.txt'];end
      lin=fgetl(fid);
    elseif strcmp(lin(1:6),'COMMEN')
      lin=fgetl(fid);
    elseif strcmp(lin(1:6),'BUNTYP')
      for ibun=1:1000,     
        lin=fgetl(fid);ll1=length(lin);
        if ll1<5, break;end
        if strcmp(upper(lin(1:3)),'END')|strcmp(upper(lin(1:6)),'STRAFF'), break;end
        bu(ibun,:)=sprintf(lin(1:4),'%4s');
        v=sscanf(lin(5:length(lin)),'%f');
        lowbun(ibun)=v(1);
        uppbun(ibun)=v(2);        
        mbun(ibun)=v(3);
        sbun(ibun)=v(4);
        fbun(ibun)=v(5);
        cpbun(ibun)=v(6);
      end
    elseif strcmp(lin(1:6),'BUIDNT')
      buidnt=readdist7(distfile,'asyid');
      for ibui=1:1000,
        lin=fgetl(fid);ll1=length(lin);
        if ll1<5, break;end
        if strcmp(upper(lin(1:3)),'END')|strcmp(upper(lin(1:6)),'BUNTYP'), break;end
        buid(ibui,:)=sprintf('%6s',remblank(lin(1:6)));
        v=sscanf(lin(7:length(lin)),'%f');
        mbui(ibui)=v(1);
        sbui(ibui)=v(2);
      end
    elseif strcmp(lin(1:6),'STRAFF')
      for ibui=1:1000,
        lin=fgetl(fid);ll1=length(lin);
        if ll1<5, break;end
        if strcmp(lin(1:3),'END'), break;end
        s=sscanf(lin,'%s%f%f');
        b=setstr(s(1:length(s)-2)');
        if a(50)==12348
          buidnt(ibui,:)=[setstr(32*ones(1,16-length(b))) b];
        else
          buidnt(ibui,:)=[b setstr(32*ones(1,16-length(b)))];
        end
        lhrstraff(ibui)=s(length(s)-1);
        cprstraff(ibui)=s(end);
      end
    end
  end
end
[burnup,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
 distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile,'burnup');
burnup=mean(burnup)';
nbun=length(uppbun);
forboj=zeros(mz(14),1);
cprmin=forboj;
medel=forboj;
stand=forboj;
for i=1:nbun
  mult=filtbun(buntyp,remblank(bu(i,:))).*(burnup>lowbun(i)&burnup<uppbun(i));
  k=find(mult==1);
  if length(k)>0,
    onk=ones(size(k));
    cprmin(k)=onk*cpbun(i);
    medel(k)=onk*mbun(i);
    stand(k)=onk*sbun(i);
    forboj(k)=onk*fbun(i);
  end  
end  
%Tag nu alla med egen buidnt
l=length(mbui);
for i=1:l,
  j=bucatch(buid(i,:),buidnt);
  if length(j)==1,
    medel(j)=mbui(i);    
    stand(j)=sbui(i);    
  else
    disp('Something is wrong there are more than one bundle with');
    disp(['Bundle identity ',buid(i,:),' in ',distfile]);
  end
end
