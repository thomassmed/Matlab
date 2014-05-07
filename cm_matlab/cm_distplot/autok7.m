%@(#)   autok7.m 1.7	 09/05/05     07:58:05
%
%function autok7
function autok7
dpcm=17;
load sim/simfile
if ~exist('sdmfiles','var'),sdmfiles=[];end
tx=readtextfile('sim/sekv.sim');
i=strmatch('KEF',tx);
for j=1:length(blist)-1
  keff(j)=str2num(tx(i+j,:));
end
i=strmatch('SEK',tx);
ii=strmatch('END',tx);
grps=str2num(tx(i+1,:));
n=1;
patt=[];
for j=i+2:ii-1
  p=str2num(tx(j,:));
  patt(n,1:length(p))=p;
  n=n+1;
end
hval=get(gcf,'userdata');
efph=str2num(get(hval(21),'string'));
point=find(blist==efph);
burstep7('fg');
%prestep7('bwd');
[dist,mminj,konrod,bb]=readdist7(filenames(point,:));
k=bb(96);
ll=find(conrod(point,:)=='=');
lk=find(conrod(point,:)==',');
lk=[0 lk size(conrod,2)+1];
g=[];w=[];
for i=1:length(ll)
  g=[g str2num(conrod(point,lk(i)+1:ll(i)-1))];
  w=[w str2num(conrod(point,ll(i)+1:lk(i+1)-1))];
end
while length(w)<size(patt,2)
  w=[w 100];
end
sw=sum(w);
sp=sum(patt');
patt=[w; patt];
[y,i]=sort([sw sp]);
patt=patt(i,:);
dk=(keff(point)-k)*1e5;
dk1=dk;
k1=k;
ind=find(y==sw)-1;
ind=ind(1)+1;
while sign(dk)==sign(dk1)&abs(dk)>dpcm
  ind=ind+sign(dk1);
  if ind>size(patt,1),break;end
  sc=size(grps);
  con=[];
  for j=1:sc(2)
    con=[con ',' num2str(grps(j)) '=' num2str(patt(ind,j))];
  end
  con=con(2:length(con));
  lc=length(con);
  sc=size(conrod);
  if lc>sc(2),conrod=[conrod setstr(32*ones(sc(1),lc-sc(2)))];end
  sc=size(conrod);
  bl=setstr(32*ones(1,sc(2)));
  conrod(point,:)=bl;
  conrod(point,1:length(con))=con;
  save sim/simfile bustep blist bocfile conrod filenames sdmfiles hc pow tlowp mangrpfile
  burstep7('fg');
%  prestep7('bwd');
  [dist,mminj,konrod,bb]=readdist7(filenames(point,:));
  k=k1;
  k1=bb(96);
  dk1=(keff(point)-k1)*1e5;
end
if ind>1 & ind<size(patt,1),w=patt(ind-sign(dk),:);end
while abs(dk)>dpcm
  if ind>size(patt,1),break;end
  y=1-(keff(point)-k)/(k1-k);
  if y>1,
    k1=k;
    k=oldk;
    patt(ind,:)=w;
    w=patt(ind+1,:);
    y=1-(keff(point)-k)/(k1-k);
  end
  p=[];
  for i=1:length(grps)
    p=[p patt(ind,i)+y*(w(i)-patt(ind,i))];
  end
  patt(ind+1,:)=w;
  w=round(p);
  sc=size(grps);
  con=[];
  for j=1:sc(2)
    con=[con ',' num2str(grps(j)) '=' num2str(w(j))];
  end
  con=con(2:length(con));
  lc=length(con);
  sc=size(conrod);
  if lc>sc(2),conrod=[conrod setstr(32*ones(sc(1),lc-sc(2)))];end
  sc=size(conrod);
  bl=setstr(32*ones(1,sc(2)));
  conrod(point,:)=bl;
  conrod(point,1:length(con))=con;
  save sim/simfile bustep blist bocfile conrod filenames sdmfiles hc pow tlowp mangrpfile
  burstep7('fg');
%  prestep7('bwd');
  [dist,mminj,konrod,bb]=readdist7(filenames(point,:));
  oldk=k;
  k=bb(96);
  dk=(k-keff(point))*1e5;
end
preed7(30);
