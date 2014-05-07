function [dk,fd,sdr]=th2dk(th);
%[dk,fd,sdr]=th2dk(th);
%
% BerÌknar dÌmpkvoten och egenfrekvensen fÎr th (theta-format)
% Om th-modellen Ìr otillrÌcklig sÌtts  dk=0, fd=0.5 och sdr=1

%PÌr LansÔker   1994-02-21
fs=1/gett(th);

%HÌmta poler och nollstÌllen
zepo=th2zp(th);
[nzp,k]=size(zepo);
p=zepo(2:nzp,3:4);
z=zepo(2:nzp,1:2);
i=find(imag(p(:,1)));
j=find(imag(z(:,1)));
p=p(i,:);
z=z(j,:);

%Ta bort polerna som ligger pÔ den negativa komplexa sidan (z-plan)
%Lagra varianserna fÎr varje enskillt polpar
if ~isempty(p),i=find(imag(p(:,1))>0);p=[p(i,:) p(i+1,2)];end
if ~isempty(z),j=find(imag(z(:,1))>0);z=z(j,1);end
[sz,k]=size(z);

if ~isempty(p),
%FrekvensberÌkning 
  flo=0.3; %StabilitetsomrÔdet
  fhi=0.7;
  fd=angle(p(:,1))*fs/2/pi;
  if ~isempty(fd),
    j=find((fd>flo)&(fd<fhi));
  end
  if length(j)~=1,    %Fler Ìn en pol i stab.omrÔdet
    dk=0;
    fd=0.5;
    sdr=1;
    return
  end
  fd=fd(j);

%dÌmpkvotsberÌkning
  dk=exp(2*pi*log(abs(p(:,1)))./angle(p(:,1)));
  dk=dk(j);
  p=p(j,:);

  %BerÌkning av dÌmpkvotens standardavvikelse
  rx=real(p(:,2));ry=imag(p(:,2));rr=p(:,3);
  vx=rx.*rx;vy=ry.*ry;cxy=ry.*rx.*rr;
  hesinv=[vx cxy;cxy vy];
  r=abs(p(:,1));
  fi=angle(p(:,1));
  x=real(p(:,1));y=imag(p(:,1));
  ddkdr=2*pi/fi*r^(2*pi/fi-1);
  drdx=x/r;
  ddkdfi=-2*pi/(fi^2)*log(r)*r^(2*pi/fi);
  dfidx=-y/(r^2);
  drdy=y/r;
  dfidy=x/(r^2);
 
  ddkdx=ddkdr*drdx+ddkdfi*dfidx;
  ddkdy=ddkdr*drdy+ddkdfi*dfidy;

  LL=[ddkdx;ddkdy];
  L=LL/norm(LL);
  S=((L'*hesinv*L)^0.5)*L;

% lÌngden pÔ dk-axeln:
  sdr=S'*LL;

% kontrollera om kancellering
% sÎk nollstÌllen som ligger nÌra ( < tol )  frekvensen fd
  tol=0.15;
  fz=angle(z)*fs/2/pi;
  dkz=[];
  for m=1:sz,
    if abs(fz(m)-fd)<tol,
      dkz=[dkz exp(2*pi*log(abs(z(m,1)))./angle(z(m)))];    %berÌkna nollstÌllets dÌmpning (kancellering)
    end
  end

% kontrollerar om nollstÌllet ligger nÌra polen i dÌmpning
  for n=1:length(dkz),
    if abs(dkz(n)-dk)<0.25,
      dk=0;fd=0.5;sdr=1;
      break
    end
  end 
else
  %Inga poler funna
  dk=0;fd=0.5;sdr=1;
end
