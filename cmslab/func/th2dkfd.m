function [dk,fd,sigma]=th2dkfd(th, sd);
%[dk,fd,sigma]=th2dkfd(th);
%
% Beräknar dämpkvot och frekvens med standardavvikelser
% för alla poler i en theta-modell.

% Gustav van den Bussche 1998-09-24

if nargin<2 sd=1; end

fs=1/gett(th);

% Hämta poler och nollställen
zepo=th2zp(th);
[nzp,k]=size(zepo);
zp=zepo(2:nzp,:);
p=zepo(2:nzp,3:4);
z=zepo(2:nzp,1:2);

% Bygger om z och p
iz=find(imag(z(:,1))>0); %komplexa nollställen
ip=find(imag(p(:,1))>0); %komplexa poler

if ~isempty(iz), z=[z(iz,:) z(iz+1,2)]; end
if ~isempty(ip), p=[p(ip,:) p(ip+1,2)];end

nz=size(z,1);
np=size(p,1);
zp=[z;p];

if ~isempty(zp)
  % frekvens och dämpkvotsberäkning
  fd=angle(zp(:,1))*fs/2/pi;
  dk=exp(2*pi*log(abs(zp(:,1)))./angle(zp(:,1)));

  % beräkning av standardavvikelser i xy-planet
  rx=real(zp(:,2));ry=imag(zp(:,2));rr=zp(:,3);
  vx=rx.*rx;vy=ry.*ry;cxy=ry.*rx.*rr;
  r=abs(zp(:,1));
  fi=angle(zp(:,1));
  x=real(zp(:,1));y=imag(zp(:,1));
  % beräkning av derivator
  ddkdr=2*pi./fi.*r.^(2*pi./fi-1);
  drdx=x./r;
  ddkdfi=-2*pi./(fi.^2).*log(r).*r.^(2*pi./fi);
  dfidx=-y./(r.^2);
  drdy=y./r;
  dfidy=x./(r.^2);
  
  ddkdx=ddkdr.*drdx+ddkdfi.*dfidx;
  ddkdy=ddkdr.*drdy+ddkdfi.*dfidy;

  dfddr=0;
  dfddfi=fs/2/pi;

  dfddx=dfddr.*drdx+dfddfi.*dfidx;
  dfddy=dfddr.*drdy+dfddfi.*dfidy;

  om=2.1*pi*[1:100]/100;  % unit circle
  w=exp(om*sqrt(-1));

  newplot
  for i=1:nz+np
    hesinv=[vx(i) cxy(i);cxy(i) vy(i)];
    % standardavvikelse dämpkvot
    LL=[ddkdx(i); ddkdy(i)];
    L=LL/norm(LL);
    S=((L'*hesinv*L)^0.5)*L;
    sigma(i,1)=S'*LL; % längden på dk-axeln

    % standardavvikelse frekvens
    LL=[dfddx(i); dfddy(i)];
    L=LL/norm(LL);
    S=((L'*hesinv*L)^0.5)*L;
    sigma(i,2)=S'*LL; % längden på fd-axeln

    % plottning av dk och fd med respektive standardavvikelser.
    if i<=nz, mark='o';
    else mark='x';
    end
  
    plot(dk(i), fd(i), mark)
    hold on;

    [V,D]=eig(hesinv);
    z1=real(w)*sd*sqrt(D(1,1));
    z2=imag(w)*sd*sqrt(D(2,2)); X=V*[z1;z2];
    X=[X(1,:)+dk(i);X(2,:)+fd(i)];
    plot(X(1,:),X(2,:))

  end
  axis('square')
  ax=axis;
  flo=0.3; %Stabilitetsområdet
  fhi=0.7;
  line(ax(1,1:2)', [flo, flo])
  line(ax(1,1:2)', [fhi, fhi])
  xlabel('dk'), ylabel('fd')
  
  else
    dk=0;
    fd=0;
    sigma=1;
end


