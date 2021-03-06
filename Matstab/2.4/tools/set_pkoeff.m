function k=set_pkoeff(vh,avhspx,arhspx,zsp,ispac,Wl,Wg,Dh,P,A,Hz);
%set_pkoeff
%
%k=set_pkoeff(vh,avhspx,arhspx,zsp,ispac,Wl,Wg,Dh,P,A,Hz)
%S�tter in tryckfallskoefficienterna
%f�r eng�ngstryckfallen till en termohydraulisk
%vektor.
%vh �r k i ekvationen
%
%             2
%      1     G       2        2        Rol
% dp = - k ------ phi    , phi = 1 + x(--- - 1), x �r flow quality
%      2    Rol                        Rog
%
%avhspx och arhspx �r spridarkoefficienterna s1 och s2 i ekvationen
%               -s2
% k = s1(Nre/1e5)
%
%zsp spridarnas position i h�jdled
%ispac �r antalet spridare

%@(#)   set_pkoeff.m 2.3   02/02/27     12:11:35

global geom

nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;
nsec=geom.nsec;

%tryckfallskoefficeinter
k=zeros(get_thsize,1);
k(1+nin(3)) = -vh(4);
k(1+ncc+nin(5:(ncc+5))) = vh(9:(ncc+9)); 
%vh from RAMONA different from get_inp: 
k(nout(5:(ncc+5))) = -vh((ncc+10):(2*ncc+10)).*sign(vh((ncc+10):(2*ncc+10)));
k(nout(ncc+6)) = -vh(2*ncc+12);

%Spridarkoefficienterna
s1 = avhspx(1:ispac,1:ncc);
s2 = arhspx(1:ispac,1:ncc);
h = sum(Hz(get_ch(1)));
zsp = zsp(1:ispac);
plac = floor(zsp/h*nsec(5)+1);
spi = zeros(ispac,ncc);
for n=1:ncc,
  nz = find(s1(:,n)~=0);
  spi(nz,n) = nin(n+4) + plac(nz)*(ncc+1);
end
spi = spi(:);nz = find(spi);spi = spi(nz);
s1 = s1(:);s1 = s1(nz);
s2 = s2(:);s2 = s2(nz);

nre = eq_Nre(Wl(spi),Wg(spi),Dh(spi),P(spi),A(spi));
k(spi)  = 2*s1./((nre*1e-5).^s2);


