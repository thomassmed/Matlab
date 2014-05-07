%@(#)   ddcomp7.m 1.1	 06/01/10     12:00:29
%
%function crnums=ddcomp7(infil)
function crnums=ddcomp7(infil)
tx=readtextfile(infil);
i=bucatch('DRIDON',tx(:,1:6));
ind=0;
for j=1:length(i)
  [t,n]=sscanf(tx(i(j),:),'%s');
  antal=n-1;
  for ii=1:antal
    ind=ind+1;
    crlist(ind,1:3)=t(7+(ii-1)*3:6+ii*3);
  end
end
i=bucatch('COMFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
ddcompfile=t(7:length(t));
i=bucatch('REFCOM',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
refcompfile=t(7:length(t));
i=bucatch('SDMDIS',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
refdistfile=t(7:length(t));
[dist,mminj,konrod]=readdist(refdistfile);
[map,mpos]=cr2map(konrod,mminj);
tx=readtextfile(refcompfile);
ind=0;
i=bucatch('INIT',tx(:,1:4));
i=i(1);
initc=tx(i,:);
for dd=1:size(crlist,1)
  fprintf('%5s%10i%s\n',crlist(dd,:),fix(100*dd/size(crlist,1)),'%')
  cpos=axis2crpos(crlist(dd,:));
  cnum=crpos2crnum(cpos,mminj);
  ddnum=crnum2dd(cnum,mminj);
  ddnum(find(ddnum==0))='';
  for nei=1:length(ddnum)
    if cnum~=ddnum(nei),
      ind=ind+1;
      convec=zeros(1,length(konrod));
      convec(cnum)=100;
      crnums(ind,1)=cnum;
      convec(ddnum(nei))=100;
      crnums(ind,2)=ddnum(nei);
      if ind==1,i=bucatch('CONROD',tx(:,1:6))+1;
      else
        i=bucatch('END',tx(:,1:3))+3;
        tx(i(1)-3,1:31)=sprintf('%s%s','TITLE  ASM-Kontroll drivdon ',crlist(dd,:));
        tx(i(1)-2,:)=initc;
        tx(i(1)-1,1:6)='CONROD';
      end
      i=i(1);
      stx=size(tx);
      tx(i:i+size(map,1)-1,:)=crwd2ascmap(convec,mminj,stx(2));
      if dd==1 & nei==1,i=i+5;end % i+1 innan ändring
      tx(i+size(map,1),:)=setstr(32*ones(1,stx(2)));
      tx(i+size(map,1),1:3)='END';
    end
  end
end
writxfile(ddcompfile,tx);
