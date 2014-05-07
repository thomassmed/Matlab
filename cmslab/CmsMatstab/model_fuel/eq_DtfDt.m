function y = eq_DtfDt(tfm,qtrissf,tcm,tl,rocfx,rfx,e1x,e2x,gca0,gca1,gca2,...
   gcamxx,rlcax,rcax,drcax,rccax,P,tw,Wl,A,Iboil,Dh,dx,cmpfrc,nrodsx)
%
%y = eq_DtfDt1(tfm,qtrissf,tcm,tl,rocfx,rfx,e1x,e2x,gca0,gca1,gca2,...
%   gcamxx,rlcax,rcax,drcax,rccax,P,tw,Wl,A,Iboil,Dh,ihydr,dx,cmpfrc,nrodsx);
%
% INPUT per fueltype=[1:max_fuel_nr]' :
%
% bränsletemperatur,nodeffekt/m3,kapslingstemperatur,moderatortemperatur,
% konstanter för fuel volumetric heat capacity,kutsradie,konstant 1 för
% thermal conductivity,konstant 2 för thermal conductivity,nodhöjd,konstant 0 
% för gap heat transfer,konstant 1 för gap heat transfer,konstant 2 för
% gap heat transfer,maxvärde för gap heat transfer coefficient, thermal
% conductivity for the cladding, outer radius of cladding, cladding thickness,
% volumetric heat capacity for the cladding,systemtrycket,väggtemperatur,
% vattenmassflöde,area,kokningsvektor,hydraulisk diameter,konverteringsvektor,
% nodbredd,andel energi som går utanför bränslet samt antalet stavar i varje
% kanal.
%
% UTDATA : Tidsderivatan för medeltemperaturen i varje skikt
%
% 

% Ekvation 6.3.27-6.3.29, 6.3.31-6.3.33

%@(#)   eq_DtfDt.m 1.3   02/02/27     11:51:17

global fuel

mm=fuel.mm;
mmc=fuel.mmc;

ntot = size(tfm,1);

y=zeros(ntot,mm+mmc);

%  ********  Ekvation 3.4.19    Thermal conductance of the gap  *******
ttmed = mean(tfm')'; % Medeltemperaturen i kutsen. ekv. 6.3.26

gca = gca0 + (gca1 + gca2.*ttmed).*ttmed; % 3.4.19
temp=find(gca>gcamxx);
gca(temp) = gcamxx(temp);

temp = find(gca==0);
gca(temp) = ones(size(temp));

tsat = cor_tsat(P);
rocf = cor_rocf(tfm,rocfx);

kf = eq_kf(tfm,tcm,gca,drcax,rlcax,e1x,e2x,rfx,1);

temp = find(Iboil);
tl(temp) = tsat(temp);

haac = eq_haac(P,tw,Wl,A,Iboil,Dh);

rfx2 = rfx.*rfx;

% Omvandling av Qtrissf från ekv. 6.2.106 till 6.2.108
qtrissf = (1 - cmpfrc)*(dx^2)*qtrissf/pi./rfx2./nrodsx/10000;


%%%%%%%%%%   B r ä n s l e t e m p e r a t u r   %%%%%%%%%
%some coefficients are diffrent as in the wulff report, because 
%eq 6.3.13 and 6.3.16 are slightly wrong

% ekv 6.3.27
y(:,1) = 4.*mm.*kf(:,2).*(tfm(:,2)-tfm(:,1))./rfx2./rocf(:,1)./(2^0.5)...
         + qtrissf./rocf(:,1);

% ekv 6.3.28
for i = 2:mm-1
  y(:,i) = 4.*mm./rfx2./rocf(:,i).*( kf(:,i).*(tfm(:,i-1)-tfm(:,i))...
          ./( ((i)/(i-1))^0.5 - ((i-2)/(i-1))^0.5 ) - kf(:,i+1)...
          .*( tfm(:,i)-tfm(:,i+1) )...
           /( ((i+1)/i)^0.5-((i-1)/i)^0.5 ) ) + qtrissf./rocf(:,i);
end;

% ekv 6.3.29
y(:,mm) = 4.*mm./rfx2./rocf(:,mm).*( kf(:,mm).*(tfm(:,mm-1)-tfm(:,mm))...
          ./( ((mm)/(mm-1))^0.5 -((mm-2)/(mm-1))^0.5  ) - rfx.*(tfm(:,mm)-tcm(:,1))...
          ./( rfx.*(1-(1-1/mm)^0.5)./kf(:,mm+1) + 2./gca + drcax./mmc./rlcax))...
          + qtrissf./rocf(:,mm); 

%%%%%%%%%%%  K a p s l i n g s t e m p e r a t u r  %%%%%%%%%%%%%

drcax2 = (drcax./mmc).*(drcax./mmc);

% ekv 6.3.31
y(:,mm+1) =...
 rlcax.*(tcm(:,2)-tcm(:,1))./drcax2./rccax+(tfm(:,mm)-tcm(:,1))...
 ./drcax.*mmc./rccax./( rfx.*(1-(1-1/mm)^0.5)./2./kf(:,mm)...
 + 1./gca + drcax./mmc./2./rlcax );

% ekv 6.3.32
  for j=2:mmc-1
    y(:,mm+j) = rlcax.*( tcm(:,j+1) - 2*tcm(:,j) + tcm(:,j-1) )...
                ./rccax./drcax2;
  end;


y(:,mm+mmc) = -haac.*(tw-tl)./rccax./(drcax./mmc)...
  -rlcax./rccax./drcax2.*(tcm(:,mmc)-tcm(:,mmc-1));


