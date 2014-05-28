function [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,acj,dhcj,phcj,pwcj,vhicj,vhocj,Xcin]=get_thdata7_src
% [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,acj,dhcj,phcj,pwcj,vhicj,vhocj]=get_thdata7;

%code translated from rm1day

%@(#)   get_thdata.m 1.13   99/02/11     18:08:07

%bypass outlet pres. loss coefficient
vhoby=0;
vhiby=-1200;

global polcadata msopt geom termo srcdata

distfile=msopt.DistFile;
soufil=msopt.SourceFile;
asytyp=polcadata.buntyp;
staton=polcadata.staton;
kmax=geom.kmax;
kan=geom.kan;
isym=msopt.CoreSym;
%	mz=polcadata.mz;			% Eliminerar samtliga läsningar direkt ur "polca-vektorer"
						% mz(44) läses in i get_polcadata som parameter geom.nastyp
						% Emma Lundgren, 05-12-09

% Total number of fuel-types in distfile
%	ntot=mz(44);
ntot = geom.nastyp;				% användandet av ntot ej lämpligt då ntot tidigare satts
						% till totala antalet neutroniknoder... eml, 05-12-09

% Axial node height = core height/nr of nodes
height=srcline2num(srcdata.SIZE,'HEIGHT');
zmesh=srcline2num(srcdata.ZMESH,'ZMESH');
czmesh=height(1)/zmesh(1);

asytypesrc=srcline2char(srcdata.ASMBLY,'ASYTYP');
% Create index for finding asytypes in source-file (asyref-list from dist-file)
for i=1:size(asytyp,1)
	for n=1:size(asytypesrc,1)
		if ~isempty(strfind(asytypesrc(n,:),asytyp(i,:))),
			ifm(i)=n;
		end
	end
end


% Check if all asytypes exists in source-file
if any(ifm==0)
  error(['Error, some fueltypes are missing in the source file ', soufil]);
end

% Read oritype-map
orityp=[];
for i=1:size(srcdata.ORIFIC.ORIFIC,1)
	orityp=[orityp remblank(srcdata.ORIFIC.ORIFIC(i,:))];
end
orityp=str2num(orityp');


%knum=geom.knum(:,1);
knum=1:geom.tot_kan; %make selecton for core geometry later
orityp=orityp(knum);
ifm=ifm(knum)';


iad=unique(ifm);
for i=1:size(ifm,1)
	iad_chan(i,1)=find(ifm(i)==iad);
end

% decode thermo hydralic data from sourcefile
% variable names as in Polca 7

nasyd=size(unique(ifm),1);   % No. of thermo-hydraulic data sets

% 2-D distributions
%
dzsegdata=srcline2num(srcdata.ASMBLY,'SEGMEN');
a=unique(ifm);
nthseg=sum(((dzsegdata(unique(ifm),:))~=0)');
%
inletdata=srcline2num(srcdata.ASMBLY,'INLET');
outletdata=srcline2num(srcdata.ASMBLY,'OUTLET');
cruddata=srcline2num(srcdata.ASMBLY,'CRUD');
throtldata=srcline2num(srcdata.ASMBLY,'THROT');
watchadata=srcline2cell(srcdata.ASMBLY,'WATCHA');

areain=10E-5*inletdata(ifm,2)';
rcltp=inletdata(ifm,3)';
reltp=inletdata(ifm,4)';
arltp=10E-5*inletdata(ifm,5)';
rcnoz=inletdata(ifm,6)';
renoz=inletdata(ifm,7)';
vhocj=outletdata(ifm,2)';

crultp=cruddata(ifm,3)';
crultp(find(crultp==0))=1;  % use default value if no value in src-file

difthr=throtldata(ifm,1)';
rethr=throtldata(ifm,2)';

%wcipos=watchadata{ifm,13}';    %  Behövs denna???
wcpipe=zeros(5,size(ifm,1));
for i=1:size(ifm)
	tmp=str2num(cell2mat(watchadata{ifm(i)}(:,16)));
	wcpipe(1:size(tmp,1),i)=tmp;    % 16
end
wcpipe=sum(wcpipe);

% 3-D distributions, decoded and treated by node segments in for-loop below

flareadata=srcline2num(srcdata.ASMBLY,'FLAREA');
hyddiadata=srcline2num(srcdata.ASMBLY,'HYDDIA');
nfpin1data=srcline2num(srcdata.ASMBLY,'NFPIN1');
nfpin2data=srcline2num(srcdata.ASMBLY,'NFPIN2');
dfpin1data=srcline2num(srcdata.ASMBLY,'DFPIN1');
dfpin2data=srcline2num(srcdata.ASMBLY,'DFPIN2');

dzseg=10E-3*dzsegdata(iad,:)';
flarea=10E-5*flareadata(iad,:)';
hyddia=10E-3*hyddiadata(iad,:)';

% Calculate fuel-pins total perimiter
fuperi=(nfpin1data(iad,:).*dfpin1data(iad,:).*pi)+(nfpin2data(iad,:).*dfpin2data(iad,:).*pi);
fuperi=10E-3*fuperi';


% If sum of all segment does not agree with SIZE:HEIGHT,
% adjust last segment to fullfill that requirement
for i=1:nasyd
	if sum(dzseg(:,i)) ~= 10E-3*height(1)
		padl=10E-3*height(1)-sum(dzseg(:,i));
		dzseg(max(find(0~=(dzseg(:,i)))),i)=dzseg(max(find(0~=(dzseg(:,i)))),i)+padl;
	end
end


% initialize some MATSTAB 3-D distributions 
acj=zeros(kmax,nasyd);
dhcj=zeros(kmax,nasyd);
phcj=zeros(kmax,nasyd);


% calculate 3-D distributions, use mean values in each node 
dz=10E-3*czmesh(1);
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
acj=acj(:,iad_chan);
dhcj=dhcj(:,iad_chan);
phcj=phcj(:,iad_chan);


% inlet calculations
% Polca 7 flows are used to calculate flow dependant coefficients
reyref=1.5e+5;  % Reference Reynolds number
tlowp=termo.tlp;
chflow=readdist7(distfile,'chflow');
chflow=chflow(knum);
flwwc=readdist7(distfile,'flwwc');  % Water channel coolant flow (kg/s)
flwwc=flwwc(knum);
lekbp2=readdist7(distfile,'lekbp2');
lekbp2=lekbp2(knum);
lekbp3=readdist7(distfile,'lekbp3');
lekbp3=lekbp3(knum);
flwori=chflow+flwwc+lekbp2+lekbp3; % flow through orifice



% Read throtl-data from source file
throtl=srcline2num(srcdata.THROTL,'THROTL')';

etaf=cor_myl(tlowp);                % dynamic viscosity
re=flwori/etaf;                      % Reynolds number
if re==0, re=reyref; end
arean=throtl(1)*10E-5;
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

vhicj=-(znoz+zltp);                   % total flow resistance for inlet
Xcin=-akin;

%wetted, non-heated perimeter
pwcj=4*acj./dhcj-phcj;


%spacers
% using get_spacer in get_inp
vhspx=[];
rhspx=[];
ispac=[];
zsp=[];


% bypass calculations
% total bypass area
wcarea=zeros(10,size(ifm,1));
wchdia=zeros(10,size(ifm,1));
for i=1:size(ifm)
	tmp=sum(str2num(char(watchadata{ifm(i)}(:,5))));
	tmp2=sum(str2num(char(watchadata{ifm(i)}(:,6))));
	wcarea(1:size(tmp,1),i)=10E-5*tmp;
	wchdia(1:size(tmp2,1),i)=tmp2*10E-3;
end

bypassdata=srcline2num(srcdata.HYDRO,'BYPASS');
aby0=10E-5*bypassdata(1)/get_sym;     % Bypass flow area (m)
aby=aby0+sum(sum(wcarea));

% check data
l1area=bypassdata(7);           	% Area (m2) of path 1 for leakage from main channel
if any(l1area)
  warning('The use of L1AREA in bypass is not implemented');
end
	% if any(inletdata(:,8))	%ändrad 05-12-09, Testar hur stort läckaget är istället, Emma Lundgren
if any(lekbp2>0.2)
  warning('The use of L2AREA is not implemented');
end
	%if any(inletdata(:,12))	%ändrad 05-12-09, Testar hur stort läckaget är istället, Emma Lundgren
if any(lekbp3>0.2)	
  % Leakage bp3 is used in the flwori calculation but loss coeff, vhicj, is not corrected. 
  % This is OK for small lakages (<0.2 kg/s). Reevaluate if lager flows appear.
  warning('The use of L3COFA is not implemented yet (bypass leakage 3)');
end
if any(outletdata(:,3))
  warning('The use of REUTP is not implemented');
end
if any(outletdata(:,5))
  warning('The use of RCCHIM is not implemented');
end 


% bypass perimeter and hydraulic diameter
hydibp=10E-3*bypassdata(2)/get_sym;  % Bypass hydraulic diameter (m)
peribp=4*(10E-5*bypassdata(1))/(10E-3*bypassdata(2));   %Bypass perimeter (m)  
% remove zeros to avoid division by zero
wchdia=wchdia(:);
i=find(wchdia==0);
wchdia(i)=1e100; % set to something large, wcarea is zero anyway for these elements 
wcperi=4*wcarea(:)./wchdia; % Water channel perimeter;
dhby=4*aby/(peribp+sum(sum(wcperi)));

