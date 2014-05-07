%@(#)   readindatasim.m 1.6	 97/11/11     13:11:55
%
%function [distfiler,efph,crpos,crstr,titel,typ,typer,tmolburn,tmollhgr,reffile,styp,straff,istraff]=...
%readindatasim(infil)
function [distfiler,efph,crpos,crstr,titel,typ,typer,tmolburn,tmollhgr,reffile,styp,straff,istraff]=...
readindatasim(infil)
lhtyp=[];styp=[];straff=[];istraff=[];
fid=fopen(infil);
titel=fgetl(fid);
if length(titel)>5,
  if strcmp(upper(titel(1:5)),'TITLE'),
    titel=titel(6:length(titel));
  end
end
lin=fgetl(fid);
nd=0;
%*********************** DISTFILER *********************
ledord=sscanf(lin,'%s',1);
if length(ledord)>7,ledord=ledord(1:7);end
while length(bucatch(ledord,['CRMODUL';'TMOL   ';'REFF   ']))==0,
  if ~strcmp(lin(1),'!')
    nd=nd+1;
    i=find(lin==' ');
    if nd==1,
      distfiler=lin(1:i(1)-1);
    else
      distfiler=str2mat(distfiler,lin(1:i(1)-1));
    end
    efph(nd,1)=str2num(remblank(lin(i(1):length(lin))));
  end
  lin=fgetl(fid);
  ledord=sscanf(lin,'%s',1);
  if length(ledord)>7,ledord=ledord(1:7);end
end
reffile=0;
imol=0;ityp=0;
lin=remleadblank(lin);
while isstr(lin),
  if length(lin)<7, lin=setstr([abs(lin),ones(1,7-length(lin))*32]);end
  if strcmp(lin(1),'!'),
    dum=0;
  elseif strcmp(upper(lin(1:7)),'CRMODUL'),
    i=find(lin(8:length(lin))~=' ');
    for j=1:length(i)/3,
      crstr(j,:)=lin(7+i(j*3-2):7+i(j*3));
    end
    for j=1:size(crstr,1),
      crpos(j,:)=axis2crpos(crstr(j,:));
    end
         %*********************** TMOL *****************************
  elseif strcmp(upper(lin(1:4)),'TMOL'),
    imol=imol+1;
    [ledord,n,errmsg,count]=sscanf(lin,'%s',1);  
    rad=remleadblank(lin(count:length(lin)));
    [temp,n,errmsg,count]=sscanf(rad,'%s',1);  
    it=find(temp==',');    
    if length(it)==0,
      rad=remleadblank(rad(count:length(rad)));
      lhtyp=str2mat(lhtyp,temp);
    else    
      lhtyp=str2mat(lhtyp,'alla');
    end
    it=find(rad==',');    
    rad(it)=32*ones(size(it));  
    rad=setstr(rad);
    xy=sscanf(rad,'%f');
    tempburn(imol,:)=[xy(1) xy(3)];
    templhgr(imol,:)=[xy(2) xy(4)];
    if length(xy)>4, 
      disp('Warning!')
      disp('More than 4 values (2 points) are given for TMOL, only 4 will be used!');
      disp(['Fuel: ',lhtyp(imol+1,:)]);
    end  
   %*********************** REF-FILE ****************************
  elseif strcmp(upper(lin(1:4)),'REFF'),
    i=find(lin==' ');  
    reffile=remblank(lin(i(1):length(lin)));
  elseif strcmp(upper(lin(1:6)),'STRAFF'),
    rad=fgetl(fid);
    rad=fgetl(fid);
    if length(rad)<3, rad=setstr([rad,32*ones(1,3-length(rad))]);end
    while isstr(rad)&~strcmp(upper(rad(1:3)),'END'),
      typ0=sscanf(rad,'%s',1);
      it=find(typ0==',');
      for j=1:length(it),
        it=find(typ0==',');
        typ0=[typ0(1:it(j)-1),''',''',typ0(it(j)+1:length(typ0))];
      end
      typ0=['''',typ0,''''];
      styp=str2mat(styp,typ0);      
      rad=fgetl(fid);
      [temp,n,errmsg,count]=sscanf(rad,'%s',1);
      rad=remleadblank(rad(count:length(rad)));
      s=sscanf(rad,'%f')';
      straff=[straff;[0 s]];
      istraff=[istraff;size(straff,1)];
      while  length(s)>0,
        rad=fgetl(fid);
        if ~strcmp(rad(1),'!'),
          s=sscanf(rad,'%f')';
          straff=[straff;s];
        end
      end     
      if length(rad)<3, rad=setstr([rad,32*ones(1,3-length(rad))]);end
    end
  else
    ityp=ityp+1;
    ii=find(lin==' ');
    typ0=remblank(lin(ii(1):length(lin)));
    it=find(typ0==',');
    for j=1:length(it),      
      it=find(typ0==',');
      typ0=[typ0(1:it(j)-1),''',''',typ0(it(j)+1:length(typ0))];
    end
    typ0=['''',typ0,''''];
    if ityp==1,
      typ=lin(1:ii(1)-1);
      typer=typ0;
    else
      typ=str2mat(typ,lin(1:ii(1)-1));
      typer=str2mat(typer,typ0);
    end
  end
  lin=fgetl(fid);
  if isstr(lin), lin=remleadblank(lin);end
end
if length(straff)>0,
  styp(1,:)='';
  istraff=[istraff;size(straff,1)+1];
end
lhtyp(1,:)='';
[it,jt]=size(typ);
% set default TMOL-curve
if imol==0,
  disp('Input TMOL is missing in indata-file');
  disp('(burnup1,lhgr1) = (10000, 41500)');
  disp('(burnup2,lhgr2) = (60000, 26000)');
  disp('is assumed');
  tempburn=[10000*ones(it,1) 60000*ones(it,1)];
  templhgr=[41500*ones(it,1) 26000*ones(it,1)];
end
i=max(bucatch('alla',lhtyp(:,1:4)));
if length(i)>0
  tmolburn(:,1)=tempburn(i,1)*ones(it,1);
  tmolburn(:,2)=tempburn(i,2)*ones(it,1);
  tmollhgr(:,1)=templhgr(i,1)*ones(it,1);
  tmollhgr(:,2)=templhgr(i,2)*ones(it,1);
end
evstr=['leta=sprintf(''%',num2str(jt),'s'',lhtyp(j,:));'];
for j=1:size(lhtyp,1),
  eval(evstr);
  i=max(findstring(leta,typ));
  if length(i)>0,
    tmolburn(i,:)=tempburn(j,:);
    tmollhgr(i,:)=templhgr(j,:);
  end
end
fclose(fid);
