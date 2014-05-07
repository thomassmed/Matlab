%@(#)   rankbyt.m 1.6	 06/02/20     08:50:31
%
%function rankbyt(eocfil,rankfil,symme,asyprefix,asytyp,asywei,nfresh,asytyp2,asywei2,nfresh2)
%
%
%asytypmap and asyweimap will be written on asytyp.txt
%asyidmap will be written on asyid.txt
%KHOT must exist on rankfile, ASYWEI must exist on eocfile.
%
%ex rankbyt('/cm/f2/c21/dist/eoc21.dat','/cm/f1/c23/dist/boc23.dat',1,'aa','N203',177.8,130)
function rankbyt(eocfil,rankfil,symme,asysuffix,typ,wei,nfresh,typ2,wei2,nfresh2)
if nargin<8, nfresh2=0;end
[burnup,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(rankfil,'burnup');
imitt=length(mminj)/2+.5;
jmitt=length(mminj)/2+.5;
khot=readdist7(rankfil,'khot');
asyideoc=readdist7(eocfil,'asyid');
asyweieoc=readdist7(eocfil,'asywei');
asytypeoc=readdist7(eocfil,'asytyp');
khoteoc=readdist7(eocfil,'khot');
crid=readdist7(eocfil,'crid');
asytyp=asytypeoc;
asywei=asyweieoc;
asyid=asyideoc;
[right,left]=knumhalf(mminj);
if symme==1,chan=[right;left];end
if symme==3,chan=right;end
i=find(mean(burnup(:,chan))==0);
if ~isempty(i)
  khot(chan(i))=2*ones(1,length(i));
  if symme==3,khot(left(i))=2*ones(1,length(i));end
  for j=1:length(i)
    ij=knum2cpos(chan(i(j)),mminj);
    amitt=sqrt((ij(1)-imitt)^2+(ij(2)-jmitt)^2);
    khot(chan(i(j)))=khot(chan(i(j)))-amitt*1e-2+j*1e-5;
    if symme==3
      khot(left(i(j)))=khot(chan(i(j)));
    end
  end
end
[i,r]=sort(-khot);

for ii=1:nfresh+nfresh2
  if ii<=nfresh
    asytypeoc=[asytypeoc;typ];
    asyweieoc=[asyweieoc wei];
  else
    asytypeoc=[asytypeoc;typ2];
    asyweieoc=[asyweieoc wei2];
  end
  if ii>99 & ii<1000, asystr=sprintf('%d',ii);end
  if ii>9 & ii<100, asystr=['0' sprintf('%d',ii)];end
  if ii<10, asystr=['00' sprintf('%d',ii)];end
  asyideoc=[asyideoc;asysuffix asystr '           '];
  khoteoc=[khoteoc 2];
end

[ieoc,reoc]=sort(-khoteoc);

a1=asytypeoc(reoc,:);
a2=asyweieoc(reoc);
a3=asyideoc(reoc,:);

asytyp(r,:)=a1(1:mz(14),:);
asywei(r)=a2(1:mz(14));
asyid(r,:)=a3(1:mz(14),:);

fa=fopen('pol/asytyp.txt','w');
typfil='templ/crtyp.txt';
ft=fopen(typfil,'r');
while 1
  line = fgetl(ft);
  if ~isstr(line), break, end
  fprintf(fa,'%s\n',line);
end
l=length(mminj);
fprintf(fa,'ASYTYP\n');
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    fprintf(fa,'     ');
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    fprintf(fa,' %s',asytyp(ind,:));
    ind=ind+1;
  end
  fprintf(fa,'\n');
end
fprintf(fa,'COMMENT ------ ASYWEI -------\n');
fprintf(fa,'ASYWEI\n');
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    fprintf(fa,'       ');
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    fprintf(fa,' %5.2f',asywei(ind));
    ind=ind+1;
  end
  fprintf(fa,'\n');
end
fclose(fa);

fa=fopen('refu/asyid.txt','w');
l=length(mminj);
fprintf(fa,'ASYID\n');
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    fprintf(fa,'                 ');
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    fprintf(fa,' %s',asyid(ind,:));
    ind=ind+1;
  end
  fprintf(fa,'\n');
end
fprintf(fa,'CRID\n');
crmminj=mminj2crmminj(mminj);
ind=1;
for i=1:length(crmminj),
  for j=1:crmminj(i)-1,
    fprintf(fa,'                 ');
  end
  for j=crmminj(i):length(crmminj)-crmminj(i)+1
    fprintf(fa,' %s',crid(ind,:));
    ind=ind+1;
  end
  fprintf(fa,'\n');
end
fclose(fa);
