function get_inp

global msopt polcadata geom fuel neu termo

distfile=msopt.DistFile;
parafile=msopt.ParaFile;
isym=msopt.CoreSym;

% read data from DistFile 
get_polcadata

kmax=geom.kmax;
kan=geom.kan;
hz=geom.hz;
hx=geom.hx;

buntyp=polcadata.buntyp;


bunref=polcadata.bunref;
staton=polcadata.staton;
mminj=polcadata.mminj;


disp(['Plant: ',staton, 10 ,'Polca file:  ',distfile])
disp(['Neu Model: ', neu.NeuModel])
disp(['Ramona file: ',parafile])

% read data from ParaFile
[dat,num,bunpol,bunnr,ptyp,nfustyp,fustyp,tt,bb,yy]=ramin2matotext(parafile);	

if staton(1)=='l'
  zero=find(~bunpol);
  bunpol(zero)=32;
end


i=find(num==202000);                         % hydraulic channel no. assigned to neutronic channel no.
if isempty(i)
  ihydr=(1:kan)';
else
  ihydr=dat(i,:)';
  ihydr=ihydr(:);
  tmp=find(ihydr==0);
  ihydr(tmp)=[];
end

nsec = zeros(6,1);
nsec(5)=kmax;                                % kmax
ncc=max(ihydr);                              % number of hydraulic channels
ntot=kmax*kan;                               % number of neutronic nodes


knum=ramnum2knum(mminj,1:kan,isym);
buntyp=buntyp(knum(:,1),:);



i=find(num==210000);                         % downcomer 1
nsec(1)=dat(i,1);
a(1)=dat(i,2);
height = zeros(6,1);
height(1)=dat(i,3);
dh(1)=dat(i,4);

i=find(num==220000);                         % downcomer 2
nsec(2)=dat(i,1);
a(2)=dat(i,2);
height(2)=dat(i,3);
dh(2)=dat(i,4);

i=find(num==230000);                         % lower plenum 1
nsec(3)=dat(i,1);
a(3)=dat(i,2);
height(3)=dat(i,3);
dh(3)=dat(i,4);
vh(4)=-dat(i,5);

i=find(num==240000);                         % lower plenum 2
nsec(4)=dat(i,1);
a(4)=dat(i,2);
height(4)=dat(i,3);
dh(4)=dat(i,4);

geom.knum=knum;
geom.ntot=ntot;
geom.ncc=ncc;
termo.ihydr=ihydr;

global srcdata;
if exist(msopt.SourceFile,'file')
  srcdata=readsrcdata(fixsrcfile(msopt.SourceFile));
else
  error('Could not find Polca source-file');
end
if isempty(msopt.MasterFile) | ~exist(msopt.MasterFile,'file')
  [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,afuel, ...
  dhfuel,phfuel,pmfuel,vhifuel,vhofuel]=get_thdata7_src;
else
  [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,afuel, ...
  dhfuel,phfuel,pmfuel,vhifuel,vhofuel]=get_thdata7;
end
if staton(1)~='l'
  [vhspx,rhspx,zsp,ispac]=get_spacer7(buntyp);
end

afuel(ihydr,:)=afuel;
dhfuel(ihydr,:)=dhfuel;
phfuel(ihydr,:)=phfuel;
pmfuel(ihydr,:)=pmfuel;
vhifuel(ihydr)=vhifuel;
vhofuel(ihydr)=vhofuel;

i=find(num==251000);                         % bypass
if isempty(i)
  a(ncc+5)=aby;
  dh(ncc+5)=dhby;
  vh(ncc+9)=vhiby;
  vh(2*ncc+10)=-vhoby;
else
  a(ncc+5)=dat(i,1);
  dh(ncc+5)=dat(i,2);
  vh(ncc+9)=dat(i,3);
  vh(2*ncc+10)=-dat(i,4);
end

i=find(num==260000);                         % riser
nsec(6)=dat(i,1);
a(ncc+6)=dat(i,2);
height(6)=dat(i,3);
dh(ncc+6)=dat(i,4);
vh(2*ncc+12)=-dat(i,5);


i=find(num==270000);                         % steamdom
a(ncc+7)=dat(i,1);
heightsd=dat(i,2);
dh(ncc+7)=dat(i,3);
ph(ncc+7)=0;
pm(ncc+7)=0;

i=find(num==290000);
nfw1=dat(i,1);                               % feedwater location
nfw2=dat(i,2);
np1=dat(i,3);                                % pump locations
np2=dat(i,4);

geom.nsec=nsec;
geom.nfw = sum(nsec(1:nfw2))-nsec(nfw2) + nfw2 - 1 + nfw1;
geom.nhcp = sum(nsec(1:np2))-nsec(np2) + np2 - 1 + np1;


i=find(num==490000);
if isempty(i)
  vel1=5e6;
  vel2=4e5;
  warning('Neutron velocities missing in parameter file, defaults used');
else
  ng=dat(i,1);                                 % number of delayed neutron groups
  vel1=dat(i,2);                               % velocity of fast neutrons
  vel2=dat(i,3);                               % velocity of thermal neutrons
end

i=find(num==491000);             
if isempty(i)
  b=[.2070e-3 .1163e-2 .1027e-2 .2222e-2 .6990e-3 .1420e-3]';
  warning('Fractions of delayed neutrons not defined in parameter file, defaults used');
else
  b=dat(i,1:ng);                               % fractions of delayed neutron
  b=b(1,:)';                                   % BOC
end

i=find(num==492000);
if isempty(i)
  al=[.127e-1 .317e-1 .115 .311 .14e1 .387e1]';
  warning('Decay constants of delayed neutrons not defined in parameter file, defaults used');
else
  al=dat(i,1:6)';                              % decay constant of delayed neutrons
end


i=find(num==499000);      % coefficients for betacorrelation b(burn,void,vhist)
if ~isempty(i)            % b and al are expanded and steady_state.m
  betacorr=dat(i,1:5);    % Polca 7: b and al are read from DistFile in steady_state.m if avaliabe
else
  betacorr=[2.835181e-03  -4.514440e-05  4.783549e-07  5.814993e-05  -6.998074e-05];
end
  
  
%Get fuel information
ifmpin=mbucatch(buntyp,bunpol);

%Find missing types
if0=find(ifmpin==0);
if length(if0)>0,
   warning(['The following buntyps cannot be found in ',parafile]);
   iref=mbucatch(bunref,bunpol);
   iborta=find(iref==0);
   burnup=readdist(distfile,'burnup');
   burnup=mean(burnup);
   fprintf(1,'\tBUNTYP\t\tmean(burnup)\tmin(burnup)\tmax(burnup)\tNo. of bundles\n');
   for i=1:length(iborta),
       ifm1=filtbun(buntyp,bunref(iborta(i),:));
       ifm1=find(ifm1);
       fprintf(1,'\t%s\t\t%8i\t%8i\t%8i\t%5i\n',bunref(iborta(i),:),round(mean(burnup(ifm1))),...
       round(min(burnup(ifm1))),round(max(burnup(ifm1))),length(ifm1));
   end
   disp([bunpol(1,:),' will be used for data from ',parafile]);
   ifmpin(if0)=ones(size(if0));
end 
if staton(1)~='l'
  ifmpin=bunnr(ifmpin);						
end

i=find(num==500000);                         			% global slip factor
cssgl=dat(i,1:4);
cssch=ones(ncc+1,1)*cssgl;

i=find(num>=500001&num<500100);              			% fuel dependent slip factors
if ~isempty(i),
  nr=num(i)-500000;
  cssfuel(nr,1:4)=dat(i,1:4);
  cssch=cssfuel(ifmpin,:);                     			% channelwise slip factor
  cssch(ncc+1,:)=cssgl;                        			% the bypass
end

i=find(num==501000);
cpb=dat(i,1:3)';                             			% boiling model parameters

i=find(num>=520000&num<520100);
if isempty(i)
  error('CARD 520000 in parameter file must be given')
else
  nr=num(i)-520000;
  nrodsx(nr,:)=dat(i,1)*ones(1,kmax);              		% number of fuelrodes (for different fueltypes), rad 1 i nrodsx innehåller
								% information om bränsletyp 1. För varje axial nod anges antalet fuelrods
  rcax(nr,:)=dat(i,2)*ones(1,kmax);                		% cladding outer radius
  drcax(nr,:)=dat(i,3)*ones(1,kmax);               		% cladding thicknes
  rfx=rcax-drcax;
end

i=find((num>=520100)&(num<520200));				% ändrar nrodsx för vissa axiala noder...
if ~isempty(i),
  for nn=i',
    nr = num(nn)-520100;
    nrodsx(nr,dat(nn,1):dat(nn,2))=dat(nn,3)*ones(1,dat(nn,2)-dat(nn,1)+1);
  end
end

%---------------------------------------------------------------%
i=find(num>=520100&num<520200);					%ONÖDIG??? denna loop gör väl exakt samma sak som den innan!!!!
nr=num(i)-520100;
inhom=[nr dat(i,1:3)];
for i=1:size(inhom,1)
  nrodsx(inhom(i,1),inhom(i,2):inhom(i,3))=inhom(i,4)*ones(1,(-inhom(i,2)+inhom(i,3)+1));
end
%---------------------------------------------------------------%

nrods=nrodsx(ifmpin,:)';nrods=nrods(:);				%nrods innehåller antal stavar för varje nod
drca=drcax(ifmpin,:)';drca=drca(:);				%drca = cladding thicknes för varje nod
rca=rcax(ifmpin,:)';rca=rca(:);					%rca = cladding outer radius för varje nod
rf=rfx(ifmpin,:)';rf=rf(:);					%rf = cladding inner radius för varje nod


i=find(num==523000);
mm=dat(i,1);                                 			% number of fuel zones
mmc=dat(i,2);                                			% number of cladding zones



% Inläsning av tabeller för bränsleindata
% Hämtar utbränningsvärden för noderna

burnup	=readdist(distfile,'burnup');
burnup	=burnup(:,knum(:,1));
burnup	=burnup(:);
burnup = burnup.*1e3;

ifmpin2	= ones(kmax,1)*ifmpin';
ifmpin2 = ifmpin2(:);
fuel.ifmpin2 = ifmpin2;
fuel.ifmpin = ifmpin2;
nfuel 	= max(ifmpin); 
nnn	= [];

lf = size(nfustyp,1);				% lf = antal tabeller
if lf						% om tabeller finns
  for i=1:lf					% läs in data från samtliga givna filer
    t = tt(:,:,i);
    b = bb(:,:,i);
    y = yy(:,:,i);
		
    %------------------------------------
    % 1- uo2c	fuel heat capacity table
    % 2- uo2k	fuel conductivity table
    % 3- gapk	gap conductivity table
    % 4- uo2r	fuel density table
    % 5- zrcc	clad heat capacity table
    % 6- zrck	clad conductivity table
    % 7- zrcr	clad density table
    %------------------------------------

    t1=t(1,:);t2=t(2,:);t3=t(3,:);t4=t(4,:);	% spara temperatur-vektor för olika parametrar och given fil
    t5=t(5,:);t6=t(6,:);t7=t(7,:);
    b1=b(1,:);b2=b(2,:);b3=b(3,:);b4=b(4,:);	% spara utbrännings-vektor för olika parametrar och given fil
    b5=b(5,:);b6=b(6,:);b7=b(7,:);
    y1=y(1,:);y2=y(2,:);y3=y(3,:);y4=y(4,:);	% spara tabell-matris för olika parametrar och given fil
    y5=y(5,:);y6=y(6,:);y7=y(7,:);
        
    nn = [];
    for j=1:nfustyp(i,1)
      nn = [nn ; find(ifmpin2 == fustyp(i,j))];	% noder vilka har bränslesort som inkluderas av tabell 'i'
    end
    
    nnsiz = size(nn,1);
    nnn = [nnn ; nn];
    
    tab1(nn,1:t1(1,1)) = lin_interp(t1(1,1),b1,y1,burnup(nn,1));	% tabeller med utbränningsberoendet reducerat
    tab2(nn,1:t2(1,1)) = lin_interp(t2(1,1),b2,y2,burnup(nn,1));	% tabi(n,m) motsvarar parameter i:s värde för tpi(n,m)	
    tab3(nn,1:t3(1,1)) = lin_interp(t3(1,1),b3,y3,burnup(nn,1));
    tab4(nn,1:t4(1,1)) = lin_interp(t4(1,1),b4,y4,burnup(nn,1));
    tab5(nn,1:t5(1,1)) = lin_interp(t5(1,1),b5,y5,burnup(nn,1));
    tab6(nn,1:t6(1,1)) = lin_interp(t6(1,1),b6,y6,burnup(nn,1));
    tab7(nn,1:t7(1,1)) = lin_interp(t7(1,1),b7,y7,burnup(nn,1));
	
    tp1(nn,1:t1(1,1)+1) = repmat(t1(1,1:t1(1,1)+1), nnsiz,1);		% tpi(n,:) motsvarar temperatur-ingångar för nod n och parameter i
    tp2(nn,1:t2(1,1)+1) = repmat(t2(1,1:t2(1,1)+1), nnsiz,1); 			
    tp3(nn,1:t3(1,1)+1) = repmat(t3(1,1:t3(1,1)+1), nnsiz,1);
    tp4(nn,1:t4(1,1)+1) = repmat(t4(1,1:t4(1,1)+1), nnsiz,1); 
    tp5(nn,1:t5(1,1)+1) = repmat(t5(1,1:t5(1,1)+1), nnsiz,1);
    tp6(nn,1:t6(1,1)+1) = repmat(t6(1,1:t6(1,1)+1), nnsiz,1);
    tp7(nn,1:t7(1,1)+1) = repmat(t7(1,1:t7(1,1)+1), nnsiz,1);
    
  end

  % sätter globala parametrar
	
  fuel.uo2c.t=tp1;		fuel.uo2c.tab=tab1;
  fuel.uo2k.t=tp2;		fuel.uo2k.tab=tab2;
  fuel.gapk.t=tp3;		fuel.gapk.tab=tab3;
  fuel.uo2r.t=tp4;		fuel.uo2r.tab=tab4;
  fuel.zrcc.t=tp5;		fuel.zrcc.tab=tab5;
  fuel.zrck.t=tp6;		fuel.zrck.tab=tab6;
  fuel.zrcr.t=tp7;		fuel.zrcr.tab=tab7;
  
  clear t1;
  clear t2;
	
end

% testar om samtliga noder inkluderats
if size(nnn,1) ~= ntot
  disp('Warning all fueltypes needed are not defined in tables');
end  
	


i=find(num==540000);
if dat(i,1)~=3
  error('Pump type not supported')
end
ijpump=dat(i,2);
i0=find(num==547000);
i1=find(num==547100);
i3=find(num==547300);
i4=find(num==547400);

pump = zeros(1,25);
pump(1:15) = [dat(i1,1:7),dat(i3,1:5),dat(i4,1:2),dat(i0,2)];
if ijpump
  ij0=find(num==542000);
  ij1=find(num==548100);
  pump(16:25)=[ijpump,dat(ij0,1:7),dat(ij1,1:2)];
  pump(25)=(termo.Wtot/termo.Wnom*100-16.25)/0.0225;  %KKL correlation between driving flow and core flow
end

i=find(num==547211);
lp = dat(i,1)+1;
h1(:,1) = dat(i,2:lp)';

i=find(num==547212);
lp = dat(i,1)+1;
h1(:,2) = dat(i,2:lp)';

i=find(num==547213);
lp = dat(i,1)+1;
h2(:,1) = dat(i,2:lp)';

i=find(num==547214);
lp = dat(i,1)+1;
h2(:,2) = dat(i,2:lp)';

i=find(num==547231);
lp = dat(i,1)+1;
t1(:,1) = dat(i,2:lp)';

i=find(num==547232);
lp = dat(i,1)+1;
t1(:,2) = dat(i,2:lp)';

i=find(num==547233);
lp = dat(i,1)+1;
t2(:,1) = dat(i,2:lp)';

i=find(num==547234);
lp = dat(i,1)+1;
t2(:,2) = dat(i,2:lp)';

%-------------------------------------------------------------------------------------------------------
% Nedanstående (bortkommenterade) förfarande skapade problem då mycket data från tryckuppsättningskurvan 
% gick förlorad.
% Har korrigerat så att samtliga indata-värden för både tryckuppsättningskurvor och momentkurvor bevaras
%
% Eventuell senare korrigering: Pumpkurvorna borde användas direkt som de är, dvs h1, h2, t1 och t2 
% bör användas direkt. Som det är nu paras h1 och t1 ihop i vektorn pk1, och h2 och t2 paras ihop i 
% vektorn pk2.
%
%	eml, 060822
%-------------------------------------------------------------------------------------------------------
%Fit data 
[m1,j1]=min([h1(1,1),t1(1,1)]);
		%if j1==2,
		%  pk1(:,[2 1]) = h1(:,1:2);
		%  pk1(:,3) = interp1(t1(:,1),t1(:,2),h1(:,1));
		%else
		%  pk1(:,[2 3]) = t1(:,[1 2]);
		%  pk1(:,1) = interp1(h1(:,1),h1(:,2),t1(:,1));
		%end
if j1 == 1 && h1(1,1) ~= t1(1,1)
  t1 = [h1(1,1) t1(1,2); t1];
elseif j1 == 2 && h1(1,1) ~= t1(1,1)
  h1 = [t1(1,1) h1(1,2); h1];
end 
t1_interp = interp1(t1(:,1),t1(:,2),h1(:,1));
h1_interp = interp1(h1(:,1),h1(:,2),t1(:,1)); 
pk1(:,1) = [h1(:,2);h1_interp];
pk1(:,2) = [h1(:,1);t1(:,1)];
pk1(:,3) = [t1_interp;t1(:,2)];
[pk1(:,2),position] = sort(pk1(:,2));
pk1(:,1) = pk1(position,1);
pk1(:,3) = pk1(position,3);
temp = [];
for j1 = 1:size(pk1,1)-1
  if pk1(j1,2) == pk1(j1+1,2)
    temp = [temp j1];
  end
end
pk1(temp,:) = [];

[m2,j2]=min([h2(1,1),t2(1,1)]);
		%if j2==2,
  		%pk2(:,[2 1]) = h2(:,1:2);
  		%pk2(:,3) = interp1(t2(:,1),t2(:,2),h2(:,1));
		%else
  		%pk2(:,[2 3]) = t2(:,[1 2]);
  		%pk2(:,1) = interp1(h2(:,1),h2(:,2),t2(:,1));
		%end
if j2 == 1 && h2(1,1) ~= t2(1,1)
  t2 = [h2(1,1) t2(1,2); t2];
elseif j2 == 2 && h2(1,1) ~= t2(1,1)
  h2 = [t2(1,1) h2(1,2); h2];
end 
t2_interp = interp1(t2(:,1),t2(:,2),h2(:,1));
h2_interp = interp1(h2(:,1),h2(:,2),t2(:,1)); 
pk2(:,1) = [h2(:,2);h2_interp];
pk2(:,2) = [h2(:,1);t2(:,1)];
pk2(:,3) = [t2_interp;t2(:,2)];
[pk2(:,2),position] = sort(pk2(:,2));
pk2(:,1) = pk2(position,1);
pk2(:,3) = pk2(position,3);
temp = [];
for j2 = 1:size(pk2,1)-1
  if pk2(j2,2) == pk2(j2+1,2)
    temp = [temp j2];
  end
end
pk2(temp,:) = [];

%-------------------------------------------------------------------------------------------------------

i=find(num==550000);
nsep=dat(i,1);                               % number of steam separators
asep=dat(i,2);                               % separator area
hsep=dat(i,3);                               % separator height
rleff0=dat(i,4);                             % effective L/A ratio for separators at zero quality

i=find(num==580000);
delta=dat(i,1);                              % fraction of heat generated directly in the coolant (incl. byp)
deltam=dat(i,2);                             % fraction of heat generated directly in the byp

i=find(num==581000);
cmpfrc=dat(i,1);                             % fraction of prompt heat deposited in coolant (incl. byp)
cmdfrc=dat(i,2);                             % fraction of delayed heat deposited in coolant (incl. byp)

temp(ihydr)=afuel(:,1);
a(5:(ncc+4))=temp;        % fuel area
temp(ihydr)=dhfuel(:,1);
dh(5:(ncc+4))=temp;       % fuel hydraulic diameter
temp(ihydr)=phfuel(:,1);
ph(5:(ncc+4))=temp;       % heated perimeter
temp(ihydr)=pmfuel(:,1);
pm(5:(ncc+4))=temp;       % weted perimeter (for temp calc in byp)
temp(ihydr)=vhifuel;
vh(9:(ncc+8))=temp; 
temp(ihydr)=vhofuel;
vh((ncc+10):(2*ncc+9))=temp; 
vh=vh';

height(5)=hz*kmax/100;                      % fuel height

%If height(2) does'nt match the overall loop
%one has to take account for that and make corrections
dc2corr = (height(6)+height(5)+height(4)-height(1))/height(2);
if dc2corr>=1, 
  height(2)=height(2)*dc2corr;
  dc2corr = 1;
elseif dc2corr<0,
  error('Lower plenum 2 has unreasonable height')
end
h=height./nsec;

h(ncc+6)=h(6);
h(6:(5+ncc))=ones(ncc,1)*h(5);
h(ncc+7)=heightsd;
h=set_geometri(h);

avhspx(:,ihydr)=vhspx'/2;
arhspx(:,ihydr)=rhspx';

nin=zeros(ncc+6,1);
nout=zeros(ncc+6,1);
nin(1)=2;
nout(1)=nin(1)+nsec(1);
nin(2)=nout(1)+1;
nout(2)=nin(2)+nsec(2);
nin(3)=nout(2)+1;
nout(3)=nin(3)+nsec(3);
nin(4)=nout(3)+1;
nout(4)=nin(4)+nsec(4);
nin(5:5+ncc)=nout(4)+(0:ncc)+1;
nout(5:5+ncc)=nin(5)+ntot+kmax+(0:ncc);
nin(6+ncc)=nout(5+ncc)+1;
nout(6+ncc)=nin(5+ncc)+ntot+kmax+nsec(6)+1;

geom.nsec=nsec;
geom.nin=nin;
geom.nout=nout;

acore=[afuel;a(ncc+5)*ones(1,kmax)];                  % adding bypass
dhcore=[dhfuel;dh(ncc+5)*ones(1,kmax)];
phcore=[phfuel;ph(ncc+5)*ones(1,kmax)];
pmcore=[pmfuel;pm(ncc+5)*ones(1,kmax)];

acore=[acore(:,1) acore]; 
dhcore=[dhcore(:,1) dhcore];                                     % adding nin
phcore=[phcore(:,1) phcore];                                     % adding nin
pmcore=[pmcore(:,1) pmcore];                                     % adding nin

A=set_geometri(a);
Dh=set_geometri(dh);
phm=set_geometri(ph);
pbm=set_geometri(pm);
css(:,1)=set_geometri([ones(1,5)*cssgl(1),cssch(:,1)',cssgl(1)]);                 %MAXSS
css(:,2)=set_geometri([ones(1,5)*cssgl(2),cssch(:,2)',cssgl(2)]);                 %CSS
css(:,3)=set_geometri([ones(1,5)*cssgl(3),cssch(:,3)',cssgl(3)]);                 %C14
css(:,4)=set_geometri([cssgl(4),-0.35,-0.35,-0.35,-0.35,cssch(:,4)',cssgl(4)]);   %C15

%Added to compensate for part length rods with different flow areas
clear temp
temp([ihydr;ncc+1],:)=acore;
A(nin(5):(nin(5)+kmax*(ncc+1)+ncc))=temp(:);
temp([ihydr;ncc+1],:)=dhcore;
Dh(nin(5):(nin(5)+kmax*(ncc+1)+ncc))=temp(:);
temp([ihydr;ncc+1],:)=phcore;
phm(nin(5):(nin(5)+kmax*(ncc+1)+ncc))=temp(:);
temp([ihydr;ncc+1],:)=pmcore;
pbm(nin(5):(nin(5)+kmax*(ncc+1)+ncc))=temp(:);
V=A.*h;
V(1)=V(1)-asep*hsep;

[x,i]=sort(knum(:,1));
clear temp
temp(x)=i;

corec=vec2core(temp,mminj);
core=zeros(length(mminj)+2);

if isym==1
  core(2:length(mminj)+1,2:length(mminj)+1)=corec;
  [i,j]=find(core~=0);
  for k=1:length(i),
    neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
  end
elseif isym==2
  core(2:length(mminj)+1,2:length(mminj)+1)=rot90(corec,3);
  core(2:length(mminj)+1,2:length(mminj)+1)=core(2:length(mminj)+1,2:length(mminj)+1)+rot90(corec);
  [i,j]=find(core~=0);
  for k=1:length(i)
    if i(k)> length(mminj)/2+1
      neig(core(i(k),j(k)),:)=[core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1) core(i(k)-1,j(k))];
    end
  end
elseif isym==7
  corec=corec+rot90(corec);
  corec=corec+rot90(rot90(corec));
  core(2:length(mminj)+1,2:length(mminj)+1)=corec;
  [i,j]=find(core~=0);
  for k=1:length(i)
    if i(k)> length(mminj)/2+1 & j(k)>length(mminj)/2+1
      neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
    end
  end
end

neig=(neig-1)*kmax;
i=find(neig<0);
neig(i)=(ntot+1)*ones(length(i),1);

neig=neig';
neig=neig(:);
A1=0;
rver=(hx/hz)^2;

nvt = get_varsize;
nvn = get_varsize('neut');


%-------------------------------------------------------
% Setting the majority of the globals
%
% Some globals are set before, bcause they are used 
% by some subfunctions

% Geometrical data

geom.h=h;
geom.height=height;
geom.src_size_height = srcline2num(srcdata.SIZE,'HEIGHT');
geom.src_zmesh_zmesh = srcline2num(srcdata.ZMESH,'ZMESH');
geom.Hz=set_nodeheight(height);
geom.A=A;
geom.V=V;
geom.Dh=Dh;
geom.phm=phm;
geom.pbm=pbm;
geom.nsep=nsep;
geom.asep=asep;
geom.hsep=hsep;
geom.ind_rows= 1 + 1:get_varsize:(get_thsize*get_varsize+1);
geom.ind_cols= geom.ind_rows;
geom.nvt=nvt;
geom.nvn=nvn;
[geom.r,geom.k]=get_neutnodes;


% Thermohydraulical data

termo.pump=pump;
termo.pk1=pk1;
termo.pk2=pk2;
termo.twophasekorr='mnelson';
termo.slipkorr='bmalnes';
%Task: is slipkorr used?
termo.css=css;
termo.cpb=cpb;
termo.vh=vh;
termo.avhspx=avhspx;
termo.arhspx=arhspx;
termo.zsp=zsp;
termo.ispac=ispac;
termo.dc2corr=dc2corr;
termo.rleff0=rleff0;
termo.nhyd=get_hydsize;
termo.P=termo.p*ones(get_thsize,1);

% Data of the neutronics

neu.b=b;
neu.betacorr=betacorr;
neu.al=al;
neu.vel1=vel1;
neu.vel2=vel2;
neu.ng=ng;
neu.delta=delta;
neu.deltam=deltam;
neu.cmpfrc=cmpfrc;
neu.n_neu_tfuel=12;
neu.k1=0.00190851655;
neu.t1=0.8337;
neu.k1h0=3.2041e-11*0.93*1.0e+6;
neu.ibas=(0:ntot-1)'*geom.nvn+termo.nhyd;
neu.rver=rver;;
neu.neig=neighbour(neig,kmax);
neu.B1=3*A1/(3*A1+(1-A1)*(rver+2));
neu.C1=(1-A1)/(4*(3*A1+(1-A1)*(rver+2)));
neu.src_albedo_abot = srcline2num(srcdata.ALBEDO,'ABOT');
neu.src_albedo_atop = srcline2num(srcdata.ALBEDO,'ATOP');
neu.src_albedo_asid = srcline2num(srcdata.ALBEDO,'ASID');


% Data of the fuel

fuel.mm=mm;
fuel.mmc=mmc;
fuel.rf=rf;
fuel.rca=rca;
fuel.drca=drca;
fuel.nrods=nrods;

