%@(#)   autsek.m 1.2	 98/10/27     13:22:32
%
%function autsek
function autsek
dpcm=17;
load simfile
tx=readtextfile('sekv.sim');
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
efph=str2num(get(hval(6),'string'));
point=find(blist==efph);
powstep('fg');
[dist,mminj,konrod,bb]=readdist(filenames(point,:));
k=bb(51);
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
%if sign(dk)<0,ind=ind+1;end
while sign(dk)==sign(dk1)&abs(dk)>dpcm
  ind=ind+sign(dk1);
  con=' ';
  sc=size(grps);
  for j=1:sc(2)
    con=sprintf('%s%i=%i,',con,grps(j),patt(ind,j));
  end
  con=con(2:length(con)-1);
  sc=size(conrod);
  bl=setstr(32*ones(1,sc(2)));
  conrod(point,:)=bl;
  conrod(point,1:length(con))=con;
  set(hval(1),'string',conrod(point,:));
  powstep('fg');
  [dist,mminj,konrod,bb]=readdist(filenames(point,:));
  k=k1;
  k1=bb(51);
  dk1=(keff(point)-k1)*1e5;
end
if ind>1,w=patt(ind-sign(dk),:);end
while abs(dk)>dpcm
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
  con=' ';
  sc=size(grps);
  for j=1:sc(2)
    con=sprintf('%s%i=%i,',con,grps(j),w(j));
  end
  con=con(2:length(con)-1);
  sc=size(conrod);
  bl=setstr(32*ones(1,sc(2)));
  c=bl;
  c(1,1:length(con))=con;
  set(hval(1),'string',c);
  powstep('fg');
  [dist,mminj,konrod,bb]=readdist(filenames(point,:));
  oldk=k;
  k=bb(51);
  dk=(k-keff(point))*1e5;
end
con=get(hval(1),'string');
lcon=length(con);
sc=size(conrod);
conrod(point,:)=setstr(32*ones(1,sc(2)));
conrod(point,1:lcon)=get(hval(1),'string');
save simfile blist bocfile conrod filenames hc pow tlowp
