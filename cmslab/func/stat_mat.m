function stat_mat(matfile)
% skapar tabell med statistik för samtliga signaler i mätfilen matfile
% tabellen innehåller medel-, max-, min- värde och standardavvikelse och 
% skrivs ner på filen stat_matfile.txt

if length(findstr(matfile,'.mat'))>0,
  if ~isempty(who('-file',matfile,'sampl')) % F3 mätfil 
    [c,mtext,b,mvarb,sampl]=getf3(matfile);
    staton='f3';
    T=1/sampl(2,1);
  else
    [a,b,c]=ldracs(matfile);
    staton='f12';
    T=c(3,1)-c(2,1);
  end
else
  [a,b,c]=ldracs(matfile);
  staton='f12';
  T=c(3,1)-c(2,1);
end

[id,jd]=find(abs(c)>1e10); %Hantera avvikande samples som kan förekomma på F12
c(id,jd)=(c(id+1,jd)+c(id-1,jd))/2;

m=mean(c,1);
mh=max(c,[],1);
ml=min(c,[],1);
ms=std(c,[],1);
[kpkt,enhet,com]=fixb(b);
com(find(com==0))=32; % Lägg in mellanslag där det inte är något tecken

p=4;
sm=num2str(m',p);
smh=num2str(mh',p);
sml=num2str(ml',p);
sms=num2str(ms',p);

fid=fopen(strcat('stat_',strrep(matfile,'.mat','.txt')),'w');

hkpkt=header('Kpunkt',size(kpkt,2)); 
henh=header('Enhet',size(enhet,2)); 
hcom=header('Beskrivning',size(com,2)); 
hsm=header('Medel',size(sm,2)); 
hsmh=header('Max',size(smh,2)); 
hsml=header('Min',size(sml,2)); 
hsms=header('Std',size(sms,2)); 

fprintf(fid,'Statistik för mätfilen: %s \n', matfile);
fprintf(fid,'%s %s  %s %s  %s  %s  %s\n',hkpkt,henh,hcom,hsm,hsmh,hsml,hsms);
for i=1:length(m)
  fprintf(fid,'%s %s  %s %s  %s  %s  %s\n',...
  kpkt(i,:),enhet(i,:),com(i,:),sm(i,:),smh(i,:),sml(i,:),sms(i,:));
end
fclose(fid);

function h=header(text,fieldsize);
h=text;
if length(h)+1<fieldsize
  h(length(h)+1:fieldsize)=' ';
end
