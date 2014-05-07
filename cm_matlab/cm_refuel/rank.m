%@(#)   rank.m 1.1	 04/09/16     14:51:35
%
%function rank(eocfil,rankfil,asyprefix,asytyp,asywei,nfresh)
%
%
%asytypmap and asyweimap will be written on asytyp.txt
%asyidmap will be written on asyid.txt
%ASYWEI must exist on eocfile.
%
%ex rank('/cm/f2/c21/dist/eoc21.dat','rankmap.txt','aa','N203',177.8,130)
function rank(eocfil,rankfil,asysuffix,typ,wei,nfresh)
[d,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(eocfil);
imitt=length(mminj)/2+.5;
jmitt=length(mminj)/2+.5;
asyideoc=readdist7(eocfil,'asyid');
asyweieoc=readdist7(eocfil,'asywei');
asytypeoc=readdist7(eocfil,'asytyp');
khoteoc=readdist7(eocfil,'khot');
asytyp=asytypeoc;
asywei=asyweieoc;
asyid=asyideoc;
fid=fopen(rankfil,'r');
[r,n]=fscanf(fid,'%d');
if n==mz(14)/2,
  r1=zeros(1,mz(14));
  [right,left]=knumhalf(mminj);
  r1(right)=2*r;
  r1(left)=2*r-1;
  [i1,r]=sort(r1);
end

for ii=1:nfresh
  asytypeoc=[asytypeoc;typ];
  asyweieoc=[asyweieoc wei];
  if ii>99 & ii<1000, asystr=sprintf('%d',ii);end
  if ii>9 & ii<100, asystr=['0' sprintf('%d',ii)];end
  if ii<10, asystr=['00' sprintf('%d',ii)];end
  asyideoc=[asyideoc;asysuffix asystr ' '];
  khoteoc=[khoteoc 2];
end

[ieoc,reoc]=sort(-khoteoc);

a1=asytypeoc(reoc,:);
a2=asyweieoc(reoc);
a3=asyideoc(reoc,:);

asytyp(r,:)=a1(1:mz(14),:);
asywei(r)=a2(1:mz(14));
asyid(r,:)=a3(1:mz(14),:);

fa=fopen('asytyp.txt','w');
typfil='crtyp-f2.txt';
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

fa=fopen('asyid.txt','w');
l=length(mminj);
fprintf(fa,'ASYID\n');
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    fprintf(fa,'       ');
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    fprintf(fa,' %s',asyid(ind,:));
    ind=ind+1;
  end
  fprintf(fa,'\n');
end
fclose(fa);
