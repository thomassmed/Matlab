%@(#)   orecomp_enskild.m 1.4	 09/12/01     10:52:51
%
%function [cases,crnums]=orecomp_enskild('infil',crsum,'rod')
function [cases,crnums]=orecomp_enskild(infil,crsum,rod)
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
%if isempty(rowa) | isempty(rowb),error('Illegal patterns');end
crnums=[];
[dist,mminj,konrod]=readdist(refdistfile);
[map,mpos]=cr2map(konrod,mminj);

tx=readtextfile(refcompfile);
% fix av rader till case1
option1=bucatch('OPTION',tx(:,1:6));
option1=tx(option1,1:end);
init1=bucatch('INIT',tx(:,1:4));
init1=tx(init1,1:end);
save1=bucatch('SAVE',tx(:,1:4));
save1=tx(save1,1:end);
sumfil=bucatch('SUMFIL',tx(:,1:6));
sumfil= strtok(tx(sumfil,7:end));
% slut på detta fix
% fix av rader till case2
option2=bucatch('!OPTION',tx(:,1:7));
option2=tx(option2,2:end);
init2=bucatch('!INIT',tx(:,1:5));
init2=tx(init2,2:end);
save2=bucatch('!SAVE',tx(:,1:5));
save2=tx(save2,2:end);
% slut på detta fix
% bortstädning av rader i tx
%a=size(tx)
%tx(a(1),:)=[]
%tx(a(1)-1,:)=[]
%tx(a(1)-2,:)=[]
ind=0;
crnums=crpos2crnum(axis2crpos(rod),mminj);
[map,mpos]=cr2map(konrod,mminj);
row=rowa;
%for row=rowa:rowb
   fprintf('%s%3.0f%s\n','Creating patterns...  ',100*(row-rowa)/(1+rowb-rowa),'% done');
   ch=sscanf(t(row+1,:),'%s');
   ll=length(ch);
   if (strcmp(upper(dm),'DM') & strcmp(ch(ll-1:ll),'DM')) | ~strcmp(upper(dm),'DM')
      [patts]=orepatts_enskild(supfil,refdistfile,cmanfil,crsum,rod);
      cases=[cases; size(patts,1)]; 
      for ipatt=1:size(patts,1)
         ind=ind+1;
         if ind==1,i=bucatch('CONROD',tx(:,1:6))+1;
         else
            i=bucatch('END',tx(:,1:3))+5;
            tx(i(1)-5,1:48)=sprintf('%s%5.0f','TITLE  Kontroll av fallande stav i monster ',crsum);
              
            % atefix
              if ind==1
                optionc=option1;
                initc=init1;
                savec=save1;
              else
                optionc=option2;
                initc=init2;
                savec=save2;
              end
              %slut atefix 
            
            tx(i(1)-4,1:size(optionc,2))=optionc;   
            tx(i(1)-3,1:size(initc,2))=initc;
            tx(i(1)-2,1:size(savec,2))=savec;
            tx(i(1)-1,1:6)='CONROD';
         end
         i=i(1);
         stx=size(tx);
         tx(i:i+size(map,1)-1,:)=crwd2ascmap(patts(ipatt,:),mminj,stx(2));
         if ind==1,i=i+5;end
         tx(i+size(map,1),:)=setstr(32*ones(1,stx(2)));
         tx(i+size(map,1),1:3)='END';
      end
   end
%end
fprintf('Patterns finished, %3.0f patterns done, writing complement file\n',sum(cases));
writxfile(fallcompfile,tx);
eval(['!polca ',fallcompfile])

s=sum2mlab7(sumfil);
k=s(14,:);
ssprocent=[0 10 15 20 25 30 35 40 50 60 80 100];
ssprocent=ssprocent(1:length(k));
delta=diff(k)*1e5;
ssprocent=diff(ssprocent);
ssverkan=delta./ssprocent;
elakast=max(ssverkan);
entalpimax=(elakast*5.57)+87.38;

a=(['max styrstavsverkan: ',num2str(elakast),' pcm/styrstavsprocent']);
b=(['entalpimax: ',num2str(entalpimax),' kJ/kg']);
disp(a)
disp(b) 

