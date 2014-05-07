%@(#)   oresum.m 1.1	 09/11/13     15:31:49
%
%function oresum('sumfil',cases,crnums,'infil');
function oresum(sumfil,cases,crnums,infil);
tx=readtextfile(infil);
i=strmatch('PRIFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
printfile=t(7:length(t));
i=strmatch('REFDIS',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
disfil=t(7:length(t));
[d,mminj]=dist2mlab7(disfil);
fid=fopen(printfile,'w');
s=sum2mlab7(sumfil);
ind=1;

fprintf(fid,'%10s %10s %10s %10s\n\n','Monster','Max pcm','Stav','keff');
for i=1:length(cases) % loopar lika m�nga g�nger som det finns m�nster att kontrollera
   k=s(14,ind:ind+cases(i)-1); % keff fr�n alla fallen p� aktuellt m�nster
   	
        ind2=1;
   	for j=1:length(k)/2;
   	k1(j)=k(ind2);
   	k2(j)=k(ind2+1);
        ind2=ind2+2;
        end;
   
   delta1=(k2-k1);
   delta2=(k2.*k1);
   delta=(delta1./delta2)*1e5;
   [km(i),mpos]=max(delta); % position och v�rde p� v�rsta deltat
   mpos=mpos*2;
   keff(i)=k(mpos);         % returnerar keff i positionen d�r deltat �r st�rst.
   crnumspos=(ind-1)/2+mpos/2;
   cr(i,:)=crpos2axis(crnums(crnumspos,:),0); % returnerar namnet p� den elaka staven
   patt(i)=s(51,ind+1); % h�mtar styrstavsumma fr�n sumfilen
   fprintf(fid,'%10.0f %10.0f %10s %10.5f\n',patt(i),km(i),cr(i,:),keff(i));
   ind=ind+cases(i);
end
[elakast,elakpos]=max(km);
epatt=patt(elakpos);
ecr=cr(elakpos,:);
ekeff=keff(elakpos);
fprintf(fid,'\n')
fprintf(fid,'%s','Begr�nsande fall:')
fprintf(fid,'%10.0f %10.0f %10s %10.5f\n',epatt,elakast,ecr,ekeff);
fclose(fid);













