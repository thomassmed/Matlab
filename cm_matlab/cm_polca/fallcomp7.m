%@(#)   fallcomp7.m 1.2	 06/01/02     15:39:20
%
%function [cases,crnums]=fallcomp7('infil')
function [cases,crnums]=fallcomp7(infil)
dm=[];cases=[];
tx=readtextfile(infil);
i=bucatch('SUPFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
supfil=t(7:length(t));
i=bucatch('CMNFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
cmanfil=t(7:length(t));
i=bucatch('COMFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
fallcompfile=t(7:length(t));
i=bucatch('REFCOM',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
refcompfile=t(7:length(t));
i=bucatch('REFDIS',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
refdistfile=t(7:length(t));
i=bucatch('SYMME',tx(:,1:5));
[t,n]=sscanf(tx(i,:),'%s');
sym=str2num(t(6:length(t)));
if ~(sym==1 | sym==3),error('Only SYMME 1 or SYMME 3 accepted');end
i=bucatch('INTERV',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
i=find(t==',');
patta=str2num(t(7:i(1)-1));
if length(i)>1
   pattb=upper(t(i(1)+1:i(2)-1));
   dm=upper(t(i(2)+1:length(t)));
else
   pattb=upper(t(i(1)+1:length(t)));
end
pattb=str2num(pattb);
t=readtextfile(supfil);
pattvec=str2num(t(2:size(t,1)-1,17:23));
rowa=find(patta==pattvec);
rowb=find(pattb==pattvec);
if isempty(rowa) | isempty(rowb),error('Illegal patterns');end
crnums=[];
[dist,mminj,konrod]=readdist(refdistfile);
[map,mpos]=cr2map(konrod,mminj);

tx=readtextfile(refcompfile);
ind=0;
i=bucatch('INIT',tx(:,1:4));
i=i(1);
initc=tx(i,:);
[map,mpos]=cr2map(konrod,mminj);
for row=rowa:rowb
   fprintf('%s%3.0f%s\n','Creating patterns...  ',100*(row-rowa)/(1+rowb-rowa),'% done');
   ch=sscanf(t(row+1,:),'%s');
   ll=length(ch);
   if (strcmp(upper(dm),'DM') & strcmp(ch(ll-1:ll),'DM')) | ~strcmp(upper(dm),'DM')
      [cnums,patts]=createpatts(supfil,row,refdistfile,cmanfil,sym);
      crnums=[crnums;cnums];
      cases=[cases; size(patts,1)];
      for ipatt=1:size(patts,1)
         ind=ind+1;
         if ind==1,i=bucatch('CONROD',tx(:,1:6))+1;
         else
            i=bucatch('END',tx(:,1:3))+3;
            tx(i(1)-3,1:48)=sprintf('%s%5.0f','TITLE  Kontroll av fallande stav i monster ',pattvec(row));
            tx(i(1)-2,:)=initc;
            tx(i(1)-1,1:6)='CONROD';
         end
         i=i(1);
         stx=size(tx);
         tx(i:i+size(map,1)-1,:)=crwd2ascmap(patts(ipatt,:),mminj,stx(2));
         if ind==1,i=i+5;end  % i+1 innan ändring
         tx(i+size(map,1),:)=setstr(32*ones(1,stx(2)));
         tx(i+size(map,1),1:3)='END';
      end
   end
end
fprintf('Patterns finished, %3.0f patterns done, writing complement file\n',sum(cases));
writxfile(fallcompfile,tx);
