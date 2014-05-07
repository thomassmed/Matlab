function dist = spy_eig(filename)
%dist = spy_eig(filename)
%
%Displays the eigenvektor e in a userfriendly
%format. filename is the result-filename generated
%by MATSTAB.

mwin,drawnow
fig = gcf;

nvn=12;
nvt=13;

%load(filename,'e','f_polca','r','k','ISYM')
load(filename,'stab','msopt','geom')
e = stab.e;
f_polca = msopt.DistFile;
r = geom.r;
k = geom.k;
ISYM = msopt.CoreSym;

[dum,mminj,konrod,bb,hy,mz]=readdist(f_polca);
kan=sum(length(mminj)+2-2*mminj);
if ISYM==1, 
  ramnum=1:kan;
elseif ISYM==2, 
  ramnum=1:kan/2;
elseif ISYM>4
  ramnum=1:kan/4;
end

KNUM=ramnum2knum(mminj,ramnum,ISYM);

iimax=length(mminj); kan=sum(iimax-2*(mminj-1)); kmax=mz(4);

kanram = length(r)/kmax;

for n=1:nvt,
  dist(n).data=zeros(kmax,kan);
  dist(n).data(:,KNUM(:,1))=reshape(e(r+n-1),kmax,kanram);
  if ISYM==2,
    dist(n).data(:,KNUM(:,2))=dist(n).data(:,KNUM(:,1));
  end
end

for n=(1+nvt):(nvn+nvt),
  dist(n).data=zeros(kmax,kan);
  dist(n).data(:,KNUM(:,1))=reshape(e(k+n-1-nvt),kmax,kanram);
  if ISYM==2,
    dist(n).data(:,KNUM(:,2))=dist(n).data(:,KNUM(:,1));
  end
end

set(fig,'UserData',dist)

set(findobj(fig,'Tag','StaticText7'),'String',filename)
