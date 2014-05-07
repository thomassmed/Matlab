function [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,acj,dhcj,phcj,pwcj,vhicj,vhocj]=get_thdata7
% [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,acj,dhcj,phcj,pwcj,vhicj,vhocj]=get_thdata7;

%code translated from rm1day

%@(#)   get_thdata.m 1.13   99/02/11     18:08:07

%bypass outlet pres. loss coefficient
vhoby=0;
vhiby=-1200;

global polcadata msopt geom termo

mastfile=msopt.MasterFile;
distfile=msopt.DistFile;
asytyp=polcadata.buntyp;
staton=polcadata.staton;
kmax=geom.kmax;
kan=geom.kan;
isym=msopt.CoreSym;

% Read data from master file
throtl=mast2mlab7(mastfile,9,'F');
bwrhyd=mast2mlab7(mastfile,22,'F');
asyref=mast2mlab7(mastfile,48,'C1');
asyrefI=mast2mlab7(mastfile,48,'I'); %needed to re-sort asydat
asyadr=mast2mlab7(mastfile,50,'I');
asydat=mast2mlab7(mastfile,51,'F');
orityp=mast2mlab7(mastfile,10,'I');
czmesh=mast2mlab7(mastfile,163,'F');
mz=mast2mlab7(mastfile,174,'I'); 

ntot=mz(44);

% re-structure data in better format
asyref=reshape(asyref(1:4*ntot),4,ntot)'; % reshape to matrix
asyrefI=asyrefI(1:ntot); % get rid of junk elements

ifm=mbucatch(asytyp,asyref);

if any(ifm==0)
  error(['Error, some fueltypes are missing in the polca master file ', mastfile]);
end

knum=geom.knum(:,1);

ifm=ifm(knum);
orityp=orityp(knum);

% sort asyadr by asyref
asyadr=reshape(asyadr(1:2*ntot)',2,ntot)'; % kolumn 1=asytyp i integer, kolumn2=ASMBLY nr
i=findint(asyrefI,asyadr(:,1)); % använder integers istället för char i asyadr och asyrefI
asyadr=asyadr(i,:);
iad=asyadr(ifm,2);     % index till asydat


% decode thermo hydralic data from asydat
% variable names as in Polca 7
% numbering described in polca7 source file polca-tb-thbwr.h 

nasyd=mz(137);   % No. of thermo-hydraulic data sets
asysiz=mz(138); % No. of parameters per asydat set

asydat=asydat(1:asysiz*nasyd); % tar bort nollor i slutet av asydat
asydat=reshape(asydat,asysiz,nasyd);


% 2-D distributions
nthseg=round(asydat(1,:)/1.4013e-45);
areain=asydat(9,iad);        % Assembly inlet flow area (m2) at leakage path 2
rcltp=asydat(10,iad);        % Flow resistance coeff, lower tie plate, base value
reltp=asydat(11,iad);        % Flow resistance coeff, lower tie plate, Reynold exponent
arltp=asydat(12,iad);        % Reference area (m2) of lower tie plate
rcnoz=asydat(13,iad);        % Flow resistance coeff, inlet nozzle, base value
renoz=asydat(14,iad);        % Flow resistance coeff, inlet nozzle, Reynold exponent
vhocj=asydat(25,iad);        % Flow resistance coeff, upper tie plate, base value
crultp=asydat(55,iad);
difthr=asydat(81,iad);       % Diffusor multiplier for core support plate throttling
rethr=asydat(82,iad);        % Reynolds exponent for core support plate throttling
wcipos=round(asydat(451,iad)/1.4013e-45);      % 
wcpipe=asydat(481,iad);     % Flow corection coeff. for CSP throttling loss

% 3-D distributions, decoded and treated by node segments in for-loop below
dzseg=asydat(131:140,:);   % Axial segment lengths (m)
flarea=asydat(141:150,:);  % Flow area (segmetwise) (m2)
hyddia=asydat(151:160,:);  % Hydraulic diameter (m)
fuperi=asydat(271:280,:);  % Total fuel pin perimeter (m)

% initialize some MATSTAB 3-D distributions 
acj=zeros(kmax,nasyd);
dhcj=zeros(kmax,nasyd);
phcj=zeros(kmax,nasyd);

% calculate 3-D distributions, use mean values in each node 
dz=czmesh(1);
z=(1:kmax)*dz;              % node segments
for i=1:nasyd
  zseg=cumsum(dzseg(1:nthseg(i),i));
  izseg=1;
  for n=1:kmax  
    z1=z(n)-dz;      
    while (z1+1e-5)<z(n) % do until new node
      z2=min(z(n),zseg(izseg)); % upper limit
      % calculate mean values
      weight=(z2-z1)/dz;
      acj(n,i)=acj(n,i)+flarea(izseg,i)*weight;
      dhcj(n,i)=dhcj(n,i)+hyddia(izseg,i)*weight;
      phcj(n,i)=phcj(n,i)+fuperi(izseg,i)*weight;
      if z2<z(n)
        izseg=izseg+1;
      end
      z1=z2;	
    end	
  end
end
      

% blow-up 3-D dist to core size
acj=acj(:,iad);
dhcj=dhcj(:,iad);
phcj=phcj(:,iad);


% inlet calculations
% Polca 7 flows are used to calculate flow dependant coefficients
reyref=1.5e+5;  % Reference Reynolds number
tlowp=termo.tlp;
chflow=readdist7(distfile,'chflow');
chflow=chflow(ifm);
flwwc=readdist7(distfile,'flwwc');  % Water channel coolant flow (kg/s)
flwwc=flwwc(ifm);
lekbp2=readdist7(distfile,'lekbp2');
lekbp2=lekbp2(ifm);
lekbp3=readdist7(distfile,'lekbp3');
lekbp3=lekbp3(ifm);
flwori=chflow+flwwc+lekbp2+lekbp3; % flow through orifice

etaf=cor_myl(tlowp);                % dynamic viscosity
re=flwori/etaf;                      % Reynolds number
if re==0, re=reyref; end
arean=throtl(1);
akin=throtl(orityp+1)'; % Throttling values
% akin, Inlet throttling with reynolds and low-reaching pipe correction 
% see polca code, file polca-401-thbwr.f90, subroutine ASSY_BWR
akin=akin./arean.^2.*difthr.*(reyref./re).^rethr.*(1+wcpipe.*flwwc./flwori).^2;
akin=akin.*acj(1,:).^2;    % Area correction for usage of massflux in first core node

dhydin=2*(areain/pi).^0.5; % hyd diameter for nozzle, assuming circular shape
re=(flwori-flwwc).*dhydin./(areain*etaf);
znoz=rcnoz.*(reyref./re).^renoz; % flow resistance coeff. for nozzle

zltp=rcltp.*(reyref./re).^reltp.*crultp; % flow resistance coeff. for lower tie plate
zltp=zltp.*(acj(1,:)./arltp).^2;        % normalize to area in node 1

vhicj=-(akin+znoz+zltp);                   % total flow resistance for inlet


%wetted, non-heated perimeter
pwcj=4*acj./dhcj-phcj;

%outlet calculations
% Implement reynolds dependant coeff here, ie rcutp.
% See polca-401-thbwr.f90, line 3133

%spacers
% using get_spacer in get_inp
vhspx=[];
rhspx=[];
ispac=[];
zsp=[];

% bypass calculations
% total bypass area
wcarea=asydat(311:320,iad);  % Water Channel Flow area (m2)
wchdia=asydat(321:330,iad);  % Water Channel Hydraulic Diameter (m)
aby0=bwrhyd(67)/get_sym;     % Bypass hydraulic diameter (m)
aby=aby0+sum(sum(wcarea));

% check data
l1area=bwrhyd(72);           % Area (m2) of path 1 for leakage from main channel
if any(l1area)
  warning('The use of L1AREA in bypass is not implemented');
end
if any(lekbp2>0.2)
  warning('The use of L2AREA is not implemented');
end
if any(lekbp3>0.2)
  % Leakage bp3 is used in the flwori calculation but loss coeff, vhicj, is not corrected. 
  % This is OK for small lakages (<0.2 kg/s). Reevaluate if lager flows appear.
  warning('The use of L3COFA is not implemented (bypass leakage 3)');
end
if any(asydat(26,:))
  warning('The use of REUTP is not implemented');
end
if any(asydat(28,:))
  warning('The use of RCCHIM is not implemented');
end 

% bypass perimeter and hydraulic diameter
hydibp=bwrhyd(68)/get_sym;  % Bypass hydraulic diameter (m)
peribp=bwrhyd(76);   %Bypass perimeter (m)  
% remove zeros to avoid division by zero
wchdia=wchdia(:);
i=find(wchdia==0);
wchdia(i)=1e100; % set to something large, wcarea is zero anyway for these elements 
wcperi=4*wcarea(:)./wchdia; % Water channel perimeter;
dhby=4*aby/(peribp+sum(sum(wcperi)));


% transpose all output variables
acj=acj';
dhcj=dhcj';
phcj=phcj';
pwcj=pwcj';
vhicj=vhicj';
vhocj=vhocj';
