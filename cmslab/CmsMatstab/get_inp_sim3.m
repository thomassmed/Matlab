function [fue_new,Oper]=get_inp_sim3

% TODO: Fix CoreSym: 1 CommandLine, 2 S3kInput 3 RestartFile 
%%
global msopt geom fuel neu termo

isym=msopt.CoreSym;

disp(['S3K input file: ',msopt.s3kfile]);
disp(['Simulate restart file:  ',msopt.RestartFile])
fprintf(1,'%s %7.2f \n','Cycle Exposure: ',msopt.xpo);

if ~isempty(msopt.ParaFile)
  disp(['Ramona file: ',msopt.ParaFile])
end

CoreOnly=get_bool(msopt.CoreOnly);
NoPump=get_bool(msopt.NoPump);
% TODO: Do not read Pump cards if NoPump

% read data from RestartFile
resinfo = FindLabels(msopt.RestartFile,'nodata');
if resinfo.fileinfo.Sim==3,
    [fue_new,Oper]=read_restart_bin(msopt.RestartFile,msopt.xpo);
else
    [fue_new,Oper]=sim5_read_restart(msopt.RestartFile,msopt.xpo);
end
fue_new=expand_fuenew(fue_new);
fue_new.afuel=fue_new.afuel/1e4;        % Convert to m^2
fue_new.dhfuel=fue_new.dhfuel/1e2;      % Convert to m
fue_new.phfuel=fue_new.phfuel/1e2;      % Convert to m
fue_new.amdt=[];
fue_new.bmdt=[];
fue_new.cmdt=[]; % Make sure default values are used, huge impact!
for i=1:length(fue_new.A_wr),
    fue_new.A_wr{i}=fue_new.A_wr{i}/1e4;
    fue_new.Ph_wr{i}=fue_new.Ph_wr{i}/1e2;
    fue_new.Dhy_wr{i}=fue_new.Dhy_wr{i}/1e2;
end
if isempty(msopt.LibFile),
    msopt.LibFile=fue_new.cd_file;
end

if isempty(fue_new.casup)&&strcmpi(msopt.BYP,'SUP'),
    msopt.BYP='S3K';
end
    

disp(['Library file: ',msopt.LibFile]);
%fue_new.Xcin=0.8*fue_new.Xcin;
mminj=fue_new.mminj;
geom.mminj=mminj;
geom.kan=fue_new.kan/get_sym;       % # of bundles in symmetry
% To do fix symmetry once and for all, kill ramnum!!!
knum=ramnum2knum(mminj,1:geom.kan,msopt.CoreSym);
knum1=knum(:,1);
buntyp=fue_new.lab(knum1,:);
bunref=unique(buntyp,'rows');

geom.tot_kan=fue_new.kan;           % Core # of bundles

geom.kmax=fue_new.kmax;             % No. of axial nodes
geom.hx=fue_new.hx;                 % Node width (cm)
geom.hz=fue_new.hz;                 % Node height (cm)
geom.knum=knum;                     % Channel numbering
geom.crcovr=fue_new.crdsteps*fue_new.dzstep/100;    % Control rod cover (fix it later)

if ~isnan(msopt.Qrel),
    fprintf(1,'Power from command line used: %5.1f %% \n',msopt.Qrel);
    fprintf(1,'Power on Restart File:        %5.1f %% \n',Oper.Qrel);
    Oper.Qtot=Oper.Qtot*msopt.Qrel/Oper.Qrel;
    Oper.Qrel=msopt.Qrel;
end
if ~isnan(msopt.Wtot),
    fprintf(1,'Flow from command line used: %5i \n',round(msopt.Wtot));
    fprintf(1,'Flow on Restart File:        %5i \n',round(Oper.Wtot));
    Oper.Wrel=Oper.Wrel*msopt.Wtot/Oper.Wtot;
    Oper.Wtot=msopt.Wtot;
end
  
fprintf(1,'Power %5.1f %% Flow %5i kg/s \n', Oper.Qrel,round(Oper.Wtot));
termo.Qnom=Oper.Qnom;               % Core nominal thermal power
termo.Qrel=Oper.Qrel;               % Core relative power
termo.Qtot=Oper.Qtot;               % Thermal power
termo.Wtot=Oper.Wtot;               % Core flow (kg/s)
termo.Wrel=Oper.Wrel;               % Relative Core flow (%)
termo.Wnom=Oper.Wnom;               % Nominal core flow
Hinlet=Oper.Hinlet;                 % Inlet enthalpy in kg/kJ
tlp=fzero(@(x) h_v(x,Oper.p)-Hinlet,270+273.15)-273.15; % Find corresponding inlet temperature, 270 C is starting guess
if ~isnan(msopt.Tin)
    fprintf(1,'Inlet Temp from command line used: %5.1f \n',msopt.Tin);
    fprintf(1,'Inlet Temp on Restart File:        %5.1f \n',tlp);
    tlp=msopt.Tin;
end

% FIXME: Water properties may need to be consistent
termo.tlp=tlp;                      % temp lower plenum
termo.p=Oper.p;                     % top of reactor vessel pressure (Pa)

if ~isfield(fue_new,'rhoref_bypass')
    fue_new.rhoref_bypass=cor_rol(termo.p,termo.tlp);
end
if isempty(fue_new.rhoref_bypass)
    fue_new.rhoref_bypass=cor_rol(termo.p,termo.tlp);
end
if fue_new.rhoref_bypass(1)<0,
    fue_new.rhoref_bypass=cor_rol(termo.p,termo.tlp);
end
termo.htc=2000;                     % heat transfer coefficient channel/bypass
termo.Wfw=Oper.Qtot*.51/1e6;        % Feed water flow (kg/s) Rough guess, not important
if length(Oper.wlt_ctp)==1,
    termo.Wbyp_frac=interp1(Oper.wlt_cwt,Oper.wlt_bypass_frac,Oper.Wrel,'linear','extrap');
else
    termo.Wbyp_frac=interp2(Oper.wlt_cwt,Oper.wlt_ctp,Oper.wlt_bypass_frac,Oper.Wrel,Oper.Qrel);
end
if strcmpi(msopt.BYP,'S3K')
    termo.Wbyp_frac=fue_new.Wbyp_S3K;
    termo.Wbyp_S3K=fue_new.Wbyp_S3K;
end
if isnan(termo.Wbyp_frac), termo.Wbyp_frac=0.1;end
termo.Wbyp=termo.Wbyp_frac*termo.Wtot;
termo.spltot=termo.Wbyp_frac;
termo.spltwc=0;
termo.dpcore=0;
termo.dpavin=0; % Placeholders to avoid crash
neu.keffpolca=Oper.keff;            % keff simulate

nsec = zeros(6,1);
nsec(5)=geom.kmax;                           % kmax
ncc=geom.kan;                                % number of hydraulic channels
ntot=geom.kmax*geom.kan;                     % number of neutronic nodes

[vhspx,rhspx,zspx,ispac]=get_spacer4matstab(fue_new);
vhspx=vhspx(knum1,:);
rhspx=rhspx(knum1,:);

% Use default values for bypass, not important!
a_by=0.25*mean(fue_new.afuel);dh_by=4*a_by/(geom.kan*4*geom.hx/100*.95);vhi_by=-1200;vho_by=0;

if ~isempty(msopt.ParaFile),
    [dat,num]=ramin2mat(msopt.ParaFile);
    %[spacer_p7,bunpol,bunnr]=ramin2text(msopt.ParaFile);
        spacer_p7=[];bunpol=[];bunnr=[];
else
    dat=[];num=[];
    spacer_p7=[];bunpol=[];bunnr=[];
end


%%
blob=read_simfile(msopt.s3kfile);
%% Get Control Rod pattern if it exists on s3k input file
konrod=read_crdpos(blob,fue_new.crmminj);
if iscell(konrod), konrod=konrod{end};end
if ~isempty(konrod), fue_new.konrod=konrod;end
%% Get HYD.CND from s3k input
hydcnd=get_num_mcard(blob,'HYD.CND'); % TODO look for this in restart file
%% Steam Dome
if ~CoreOnly,
V_sd=get_num_card(blob,'PER.DOM');
%% downcomer 1
blk=get_num_card(blob,'PER.BLK');           % See card PER.BLK in S3K-manual
blk=set_defaults(blk,[6.96; 30.8;  50.8]);  % S3K defaults
zblk=blk(1);ablk=blk(2);vblk=blk(3);
lblk=vblk/ablk;
nsec(1)=3;                                  % 3 dc1 typical value used in ramona

% We need some data from dc2 and lp2 if no parameter file is given
dc=get_num_card(blob,'PER.DCR');            % See card PER.DCR in S3K-manual
zdcr=dc(1);vdcr=dc(2);dcmdia=dc(3);dcmlen=dc(4);
a_dc2=vdcr/dcmlen;         

lpl=get_num_card(blob,'PER.LPL');           
lpl=set_defaults(lpl,[lpl(1);66;2;-lpl(1)]);
zlpl=lpl(1);vlpl=lpl(2);                    % See card PER.LPL in S3K-manual
lpldiam=lpl(3);lpllen=lpl(4);

a_dc1=ablk;                               % downcomer 1
height = zeros(6,1);
height(1)=zblk-zdcr-0.2;                     % Assume RAMONA node length is same as S3K BLK height
                                          % Note Ramona needs a somewhat different number than S3K
                                          % a bit BELOW the actual level, thus the -0.2. Although at
                                            % least for the Forsmark 3 data I received also S3K data was
                                            % below the level I know exist at F3 (4.2 m above top of core)

dh_dc1=1.0;                                  % Typical in ramona
vh_dc1=0;                                    % Typical in ramona
i=find(num==210000);                        % downcomer 1 from ramona input file if found
if ~isempty(i),
    nsec(1)=dat(i,1);
    a_dc1=dat(i,2);
    height = zeros(6,1);
    height(1)=dat(i,3);
    dh_dc1=dat(i,4);
    vh_dc1=dat(i,5);
end
a_dc1=a_dc1*ones(nsec(1),1);
dh_dc1=dh_dc1*ones(nsec(1),1);
vh_dc1=vh_dc1*ones(nsec(1),1);
h_dc1=height(1)/nsec(1)*ones(nsec(1),1);
v_dc1=a_dc1.*h_dc1;
%% downcomer 2
% dc=get_num_card(blob,'PER.DCR');            % See card PER.DCR in S3K-manual
% statement is executed above
               % downcomer 2
nsec(2)=5;                                  % 5 Typical in ramona
height(2)=zdcr-zlpl;                           % Length, downcomer 2
%height(2)=-lpl(1);                           % esbwr
rcps3k=get_num_card(blob,'PER.RCP');        % lower plenum 1
nloops=rcps3k(1);nloops2=rcps3k(2);         % See card PER.RCP in S3K-manual
rcpdia=rcps3k(3);rcplen=rcps3k(4);
if length(rcps3k)==4,
    rcps3k(5)=1; % S3K default
end
rcploss=rcps3k(5);          
dh_dc2=min(dcmdia,rcpdia);                   % Hydraulic diameter   
vh_dc2=0;                                    % Typical in ramona

i=find(num==220000);                        % downcomer 2 from ramona input file if found
if ~isempty(i),
    nsec(2)=dat(i,1);
    a_dc2=dat(i,2);
    height(2)=dat(i,3);
    dh_dc2=dat(i,4);
    vh_dc2=dat(i,5);
end
a_dc2=a_dc2*ones(nsec(2),1);
dh_dc2=dh_dc2*ones(nsec(2),1);
vh_dc2=vh_dc2*ones(nsec(2),1);
h_dc2=height(2)/nsec(2)*ones(nsec(2),1);
v_dc2=a_dc2.*h_dc2;
%% lower plenum 1
lalpl=zlpl+lpllen;
a_lp1=vlpl/lpllen;
height(3)=lalpl;                            % Length, lower plenum
dh_lp1=lpldiam;                             % Hydraulic diameter
nsec(3)=2;                                  % Typical in ramona
height(3)=rcplen;                           % Length, lower plenum 1 (horisontal part)
vh_lp1=0;
i=find(num==230000);                         % lower plenum 1 from ramona input file if found
if ~isempty(i),
    nsec(3)=dat(i,1);
    a_lp1=dat(i,2);
    height(3)=dat(i,3);
    dh_lp1=dat(i,4);
    vh_lp1=dat(i,5);
end
a_lp1=a_lp1*ones(nsec(3),1);
dh_lp1=dh_lp1*ones(nsec(3),1);
vh_lp1=vh_lp1*ones(nsec(3),1);
h_lp1=height(3)/nsec(3)*ones(nsec(3),1);
v_lp1=a_lp1.*h_lp1;
%% lower plenum 2
a_lp2=a_lp1(1);                           
height(4)=-zlpl;                           % Length, lower plenum
dh_lp2=lpldiam;                              % Hydraulic diameter
nsec(4)=2;                                  % Typical in ramona
vh_lp2=0;
i=find(num==240000);                         % lower plenum 2 from ramona input file if found
if ~isempty(i),
    nsec(4)=dat(i,1);
    a_lp2=dat(i,2);
    height(4)=dat(i,3);
    dh_lp2=dat(i,4);
    vh_lp2=dat(i,5);
end
a_lp2=a_lp2*ones(nsec(4),1);
dh_lp2=dh_lp2*ones(nsec(4),1);
vh_lp2=vh_lp2*ones(nsec(4),1);
h_lp2=height(4)/nsec(4)*ones(nsec(4),1);
v_lp2=a_lp2.*h_lp2;
%% riser Read PER.UPP and PER.SEP and assign defaults if necessary
nsec(6)=4;          % Typical in Ramona
upl_data=get_num_card(blob,'PER.UPP');
%                               zupp  vupp   aupp la2upp
upl_data=set_defaults(upl_data,[4.87; 22.31;  0;  0]);
zupp=upl_data(1);
vupp=upl_data(2);
aupp=upl_data(3);
if aupp==0,
    aupp=upl_data(2)/upl_data(1);
end
sep_data=get_num_card(blob,'PER.SEP'); %TODO: fixa Tab enl Netterbrants erf
%                               nsep zstp zsep zspo astp  asep  ksep la1sep la2sep  slip
sep_data=set_defaults(sep_data,[121; 5.58; 7.1; 7.3; 5.45; 8.55; 37;     0;  0;     1.4]);
nsep=sep_data(1);
zstp=sep_data(2);
zsep=sep_data(3);
zspo=sep_data(4);
astp=sep_data(5);
asep=sep_data(6);
ksep=sep_data(7);
la1sep=sep_data(8);
rleff0=la1sep;
%rleff0=122;
%% Derived quantities
%hr1=zupp-fue_new.elevat(3)/100; %esbwr
hr1=zupp-geom.kmax*geom.hz/100;
hr2=zstp-zupp;
hr3=zblk-zstp;
hr=hr1+hr2+hr3;
height(6)=hr;
%height(6)=sum(height(1:2))-sum(height(3:4))-fue_new.hz*fue_new.kmax/100; % NB special for esbwr!
if aupp==0,
    r_core=length(fue_new.mminj)*fue_new.dxassm/2/100;
    aupp=r_core*r_core*pi;
end
LoA_upp=hr1/aupp;
LoA_stp=hr2/astp;
LoA_sep=hr3/asep;
a_upl=hr/(LoA_upp+LoA_stp+LoA_sep);
dh_upl=sqrt(astp/nsep/pi)*2;     % Use the diameter of the stand pipe as a measure of hydraulic diameter
                                        % phone call with Gerardo Grandi 2007-10-01
                                    
if 1,%a_upl>asep
    vh_upl=-ksep*(a_upl/asep)^2;
else
    vh_upl=-ksep;
end
%%
% If there is a parameter.inp from Ramona, those values will be used
i=find(num==260000);                         % riser
if ~isempty(i),
    nsec(6)=dat(i,1);
    a_upl=dat(i,2);
    height(6)=dat(i,3);
    dh_upl=dat(i,4);
    vh_upl=dat(i,5);
end
h_upl=height(6)/nsec(6)*ones(nsec(6),1);
a_upl=a_upl*ones(nsec(6),1);
dh_upl=dh_upl*ones(nsec(6),1);
v_upl=a_upl.*h_upl;

vh_upl(nsec(6),1)=vh_upl;vh_upl(1:nsec(6)-1,1)=zeros(nsec(6)-1,1);

%%
sd_data=get_num_card(blob,'PER.DOM');
if ~isempty(sd_data)
    v_sd=sd_data(1);
else
    v_sd=160.8;     % Default in S3K
end
heightsd=8;
a_sd=v_sd/heightsd;
dh_sd=1;

i=find(num==270000);                         % steamdome
if ~isempty(i),
    a_sd=dat(i,1);
    heightsd=dat(i,2);
    dh_sd=dat(i,3);
    v_sd=a_sd*heightsd;
end

hsep=hr3;
i=find(num==550000);
if ~isempty(i),
    nsep=dat(i,1);                               % number of steam separators
    asep=dat(i,2);                               % separator area
    hsep=dat(i,3);                               % separator height
    rleff0=dat(i,4);                             % effective L/A ratio for separators at zero quality
    v_sd=v_sd-asep*hsep;
end


%%
nfw1=1;                                         % Default values for feedwater
nfw2=2;
np1=3;
np2=1;

i=find(num==290000);
if ~isempty(i),
    nfw1=dat(i,1);                               % feedwater location
    nfw2=dat(i,2);
    np1=dat(i,3);                                % pump locations
    np2=dat(i,4);
end
geom.nsec=nsec;
geom.nfw = sum(nsec(1:nfw2))-nsec(nfw2) + nfw2 - 1 + nfw1;
geom.nhcp = sum(nsec(1:np2))-nsec(np2) + np2 - 1 + np1;

%% Standard pump curves given in S3K
pump_data=get_card(blob,'PER.PMP');
if ~isempty(pump_data), 
    pump_model_source='S3K_OLD';
else
    pump_data=get_card(blob,'PER.PRR');
    pump_model_source='S3K_NEW';
end

if strcmpi(pump_data{1},'JET')
    termo.per_jet=get_num_card(blob,'PER.JET');
    termo.per_pmp=pump_data;
else
    termo.per_jet=0;
end

i=find(num==540000, 1);
if ~isempty(i),
    pump_model_source='RAMONA';
end

switch pump_model_source
    case 'S3K_OLD'
        pump_model_source='S3K_OLD';
        pump_data_2=get_num_card(blob,'PER.TRQ'); %TODO: fix defaults
        pump_data_2=set_defaults(pump_data_2,[780,3270,0.009,15000]);
        pump_data_3=get_num_card(blob,'PER.RCP');
        pump_data_3=set_defaults(pump_data_3,[6,1,0.6,0,1]);        
        termo.per_trq=pump_data_2;
        termo.per_rcp=pump_data_3;
        nrcp=pump_data_3(1);
        pump_model=pump_data{1};
        pump(1)=pump_data{2}/60;
        pump(2)=pump_data_2(4);
        pump(3)=pump_data{3}*nrcp;
        pump(4)=pump_data{4};
        pump(5)=pump_data_2(1);
        pump(6)=pump_data_2(2);
        dh_pump=pump_data_3(3);
        rcplen=pump_data_3(4);
        rcploss=pump_data_3(5);
        reck=0.02*rcplen/dh_pump+rcploss;
        arec=(dh_pump/2)^2*pi;
        pump(7)=-reck/arec^2/2/9.81/nrcp/nrcp; % See SSP-07/119, p 22 and RAMONA input card 547100
                                                                       % /nrcp^2 is to account for the fact that we model one
                                                                       % equivalent pump
        pump(8)=pump_data_2(3)*(2*pi)^2;
        pump(9:15)=[8.05 25.6 1.6e-4 4.7 0.2 3580 0];   %Defaults from RAMONA, see card 547300
        larec=rcplen/arec/nrcp;
        termo.pump_larec=larec;       
        
        tabh=get_tab_card(blob,'PER.PCV');
        tabt=get_tab_card(blob,'PER.TCV');
        if  isempty(find(tabh(:,1)==1, 1)),
            h_ett=interp1(tabh(:,1),tabh(:,2),1);
            tabh=[tabh;1 h_ett];
            [x_h,i_h]=sort(tabh(:,1));
            tabh=tabh(i_h,:);
        end
        if isempty(find(tabt(:,1)==1, 1)),        
            t_ett=interp1(tabt(:,1),tabt(:,2),1);
            tabt=[tabt;1 t_ett];
            [x_t,i_t]=sort(tabt(:,1));
            tabt=tabt(i_t,:);
        end
        i1=find(tabh(:,1)<=1);
        h1=tabh(i1,:);
        i2=find(tabh(:,1)>=1);
        h2=tabh(i2,:);
        h2(:,1)=1./h2(:,1);
        h2(:,2)=h2(:,2).*h2(:,1).*h2(:,1);

        i1=find(tabt(:,1)<=1);
        t1=tabt(i1,:);
        i2=find(tabt(:,1)>=1);
        t2=tabt(i2,:);
        t2(:,1)=1./t2(:,1);
        [dum,it2]=sort(t2(:,1));
        t2=t2(it2,:);
        [dum,ih2]=sort(h2(:,1));
        h2=h2(ih2,:);
        t2(:,2)=t2(:,2).*t2(:,1).*t2(:,1); % Scaling to account for the fact that dependent variable now is h/q^2
    case 'S3K_NEW'
        pump_model_source='S3K_NEW';
        pump_data_2=get_num_card(blob,'PER.TRQ'); %TODO: fix defaults
        pump_data_2=set_defaults(pump_data_2,[780,3270,0.009,15000]);
        pump_data_3=get_num_card(blob,'PER.RCP');
        pump_data_3=set_defaults(pump_data_3,[6,1,0.6,0,1]);
        termo.per_trq=pump_data_2;
        termo.per_rcp=pump_data_3;
        nrcp=pump_data_3(1);
        pump_model=pump_data{1};
        pump(1)=pump_data{2}/60;
        pump(2)=pump_data_2(4);
        pump(3)=pump_data{3}*nrcp;
        pump(4)=pump_data{4};
        pump(5)=pump_data_2(1);
        pump(6)=pump_data_2(2);
        dh_pump=pump_data_3(3);
        rcplen=pump_data_3(4);
        rcploss=pump_data_3(5);
        reck=0.02*rcplen/dh_pump+rcploss;
        arec=(dh_pump/2)^2*pi;
        pump(7)=-reck/arec^2/2/9.81/nrcp/nrcp; % See SSP-07/119, p 22 and RAMONA input card 547100
                                                                       % /nrcp^2 is to account for the fact that we model one
                                                                       % equivalent pump
        pump(8)=pump_data_2(3)*(2*pi)^2;
        pump(9:15)=[8.05 25.6 1.6e-4 4.7 0.2 3580 0];   %Defaults from RAMONA, see card 547300
        larec=rcplen/arec/nrcp;
        termo.pump_larec=larec;
        per_prh=get_cards(blob,'PER.PRH');
        for i=1:length(per_prh)
            if per_prh{i}{1}==1,
                tabh=cell2mat(per_prh{i}(2:end));
                h1=reshape(tabh,2,length(tabh)/2)';
            end
            if per_prh{i}{1}==2,
                tabh=cell2mat(per_prh{i}(2:end));
                h2=reshape(tabh,2,length(tabh)/2)';
            end            
        end
        per_prt=get_cards(blob,'PER.PRT');
        for i=1:length(per_prt)
            if per_prt{i}{1}==1,
                tabt=cell2mat(per_prt{i}(2:end));
                t1=reshape(tabt,2,length(tabt)/2)';
            end
            if per_prt{i}{1}==2,
                tabt=cell2mat(per_prt{i}(2:end));
                t2=reshape(tabt,2,length(tabt)/2)';
            end            
        end 
    case 'RAMONA'
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
        termo.pump_larec=0;

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
end
%%
%Fit data 
[m1,j1]=min([h1(1,1),t1(1,1)]);
if j1==2,
  pk1(:,[2 1]) = h1(:,1:2);
  pk1(:,3) = interp1(t1(:,1),t1(:,2),h1(:,1));
else
  pk1(:,[2 3]) = t1(:,[1 2]);
  pk1(:,1) = interp1(h1(:,1),h1(:,2),t1(:,1));
end

[m2,j2]=min([h2(1,1),t2(1,1)]);
if j2==2,
  pk2(:,[2 1]) = h2(:,1:2);
  pk2(:,3) = interp1(t2(:,1),t2(:,2),h2(:,1));
else
  pk2(:,[2 3]) = t2(:,[1 2]);
  pk2(:,1) = interp1(h2(:,1),h2(:,2),t2(:,1));
end

end


i=find(num==490000);
if isempty(i)
  ng=6;
  vel1=5e6;
  vel2=4e5;
  %warning('Neutron velocities missing in parameter file, defaults used');
else
  ng=dat(i,1);                                 % number of delayed neutron groups
  vel1=dat(i,2);                               % velocity of fast neutrons
  vel2=dat(i,3);                               % velocity of thermal neutrons
end

i=find(num==491000);             
if isempty(i)
  b=[.2070e-3 .1163e-2 .1027e-2 .2222e-2 .6990e-3 .1420e-3]';
  %warning('Fractions of delayed neutrons not defined in parameter file, defaults used');
else
  b=dat(i,1:ng);                               % fractions of delayed neutron
  b=b(1,:)';                                   % BOC
end

i=find(num==492000);
if isempty(i)
  al=[.127e-1 .317e-1 .115 .311 .14e1 .387e1]';
  %warning('Decay constants of delayed neutrons not defined in parameter file, defaults used');
else
  al=dat(i,1:6)';                              % decay constant of delayed neutrons
end


i=find(num==499000);      % coefficients for betacorrelation b(burn,void,vhist)
if ~isempty(i)            % b and al are expanded and steady_state.m
  betacorr=dat(i,1:5);    % Polca 7: b and al are read from DistFile in steady_state.m if avaliabe
else
  betacorr=[2.835181e-03  -4.514440e-05  4.783549e-07  5.814993e-05  -6.998074e-05];
end

%% Void model
cssgl=[1.9   0.25   0.90   0.147]; % 'Default' from RAMONA
%cssgl=[1.9   0.25   0.95   0.147]; % 'Default' from RAMONA
i=find(num==500000);                         % global slip factor
if ~isempty(i),
    cssgl=dat(i,1:4);
end

cpb=[5.0E+6 4.0E+7 0.0];                     % Typical ramona values 
i=find(num==501000);
if ~isempty(i),
    cpb=dat(i,1:3)';                             % boiling model parameters
end

%% Get fuel information
if isempty(bunpol),                         % Data from CMS only, nothing from Ramona input file
  nhyd=unique(fue_new.nhyd);
  ntot=geom.kmax*geom.kan;
  rca=zeros(1,geom.kan);drca=rca;rlca=rca;
  rf=rca;e1=rca;e2=rca;gca0=rca;gca1=rca;gca2=rca;gcamx=rca;
  nrods=read_no_pins(msopt.LibFile,fue_new,knum1);
  rcca=ones(ntot,1)*2030100;                % Default volumtric heat capacity of cladding
  rocf=[2370900 2647 -2.8373 0.0012 -1.2066e-007];
  mm=4;
  mmc=2;
  if isempty(hydcnd),
      hydcnd=getdefaulthydcnd(nrods,fue_new.nhyd);
      warning('Default values for pellet and clad radius are used');
  end
  i_hydcnd=zeros(length(hydcnd),1);
  for i=1:length(hydcnd),
      i_hydcnd(i)=hydcnd{i}(1);
  end
  for i=1:length(nhyd),  % TODO: implement S3K values
      ii=find(nhyd(i)==fue_new.nhyd(:,knum(:,1)));
      if ~isempty(ii),
          iii=find(nhyd(i)==i_hydcnd);
          rca(ii)=hydcnd{iii}(4)/100;
          rf(ii)=hydcnd{iii}(3)/100;
          drca(ii)=rca(ii)-rf(ii);
          if rca(ii(1))<0.53,                   % Assume 10x10
              e1(ii)=9.9802;
              e2(ii)=2.1292e-3;
              rlca(ii)=16.0;
              gcamx(ii)=21000;
              gca0(ii)=4.9439e+3;
              gca1(ii)=-2.0730;
              gca2(ii)=6.2922e-3;
          elseif rca(ii(1))<0.58                % Assume 9x9
              e1(ii)=9.9802;
              e2(ii)=2.1292e-3;
              rlca(ii)=16.0;
              gcamx(ii)=21000;
              gca0(ii)=4.9439e+3;
              gca1(ii)=-2.0730;
              gca2(ii)=6.2922e-3;
          else                                  % Assume 8x8
              e1(ii)=10.0507;
              e2(ii)=2.1196e-3;
              rlca(ii)=16.0;
              gcamx(ii)=21000;
              gca0(ii)=3.8489e+3;
              gca1(ii)=-3.1009;
              gca2(ii)=5.7648e-3;
          end
      end
  end
  rca=ones(geom.kmax,1)*rca;
  rf=ones(geom.kmax,1)*rf;
  drca=ones(geom.kmax,1)*drca;
  rlca=ones(geom.kmax,1)*rlca;
  e1=ones(geom.kmax,1)*e1;
  e2=ones(geom.kmax,1)*e2;
  gca0=ones(geom.kmax,1)*gca0;
  gca1=ones(geom.kmax,1)*gca1;
  gca2=ones(geom.kmax,1)*gca2;
  gcamx=ones(geom.kmax,1)*gcamx;
  rf=rf(:);
  rca=rca(:);
  drca=drca(:);
  rlca=rlca(:);
  e1=e1(:);
  e2=e2(:);
  gca0=gca0(:);
  gca1=gca1(:);
  gca2=gca2(:);
  gcamx=gcamx(:);
  nrods=nrods(:);
else    
  ifmpin=mbucatch(buntyp,bunpol);
  %Find missing types
  if0=find(ifmpin==0);
  if ~isempty(if0),
    if length(if0)>50,                                   % Try something else, seems strange
        nfta_list=unique(fue_new.nfta);
        nfta=fue_new.nfta(knum1);
        buntyp_nfta=rensa(abs(fue_new.asmnam),32);
        [inan,jnan]=find(isnan(buntyp_nfta));
        iinan=find(isnan(buntyp_nfta(:)));
        buntyp_nfta(iinan)=zeros(length(iinan),1);
        buntyp_nfta=char(buntyp_nfta);
        buntyp=buntyp(:,1:size(buntyp_nfta,2));
        for i=1:length(nfta_list),
            ii=find(nfta==nfta_list(i));
            for iii=1:length(ii),
                buntyp(ii(iii),:)=buntyp_nfta(i,:);
            end
        end
        ifmpin=mbucatch(buntyp,bunpol);
        ifmpin1=mbucatch(buntyp(:,1:2),bunpol(:,1:2));
        if0=find(ifmpin==0);
        ifmpin(if0)=ifmpin1(if0);
        bunref=unique(buntyp,'rows');
    end
  end
  if0=find(ifmpin==0);
  if ~isempty(if0),
     warning(['The following buntyps cannot be found in ',msopt.ParaFile]);
     iref=mbucatch(bunref,bunpol);
     iborta=find(iref==0);
     burnup=fue_new.burnup;
     burnup=mean(burnup);
     fprintf(1,'\tBUNTYP\t\tmean(burnup)\tmin(burnup)\tmax(burnup)\tNo. of bundles\n');
     for i=1:length(iborta),
       ifm1=filtbun(buntyp,bunref(iborta(i),:));
       ifm1=find(ifm1);
       fprintf(1,'\t%s\t\t%8i\t%8i\t%8i\t%5i\n',bunref(iborta(i),:),round(mean(burnup(ifm1))),...
       round(min(burnup(ifm1))),round(max(burnup(ifm1))),length(ifm1));
     end
     disp([bunpol(1,:),' will be used for data from ',msopt.ParaFile]);
     ifmpin(if0)=ones(size(if0));
  end 
  ifmpin=bunnr(ifmpin);


  i=find(num>=520000&num<520100);
  if isempty(i)
    error('CARD 520000 in parameter file must be given')
  else
    nr=num(i)-520000;
    nrodsx(nr,:)=dat(i,1)*ones(1,geom.kmax);              % number of fuelrods (for different fueltypes)
    rcax(nr,:)=dat(i,2)*ones(1,geom.kmax);                % cladding radius
    drcax(nr,:)=dat(i,3)*ones(1,geom.kmax);               % cladding thickness
    rfx=rcax-drcax; 
  end

  i=find((num>=520100)&(num<520200));
  if ~isempty(i),
    for nn=i',
      nr = num(nn)-520100;
      nrodsx(nr,dat(nn,1):dat(nn,2))=dat(nn,3)*ones(1,dat(nn,2)-dat(nn,1)+1);
    end
  end

  i=find(num>=520100&num<520200);
  nr=num(i)-520100;
  inhom=[nr dat(i,1:3)];
  for i=1:size(inhom,1)
    nrodsx(inhom(i,1),inhom(i,2):inhom(i,3))=inhom(i,4)*ones(1,(-inhom(i,2)+inhom(i,3)+1)); 
  end

  nrods=nrodsx(ifmpin,:)';nrods=nrods(:);
  drca=drcax(ifmpin,:)';drca=drca(:);
  rca=rcax(ifmpin,:)';rca=rca(:);
  rf=rfx(ifmpin,:)';rf=rf(:);

  i=find(num==521000);
  if isempty(i)
    i=find(num>521000&num<522000);
    nr=num(i)-521000;
    e1x(nr)=dat(i,1);                                % parameters used in the correlation for the
    e2x(nr)=dat(i,2);                                % thermal conductivity of the fuel
    rlcax(nr)=dat(i,3);                              % thermal conductivity of the cladding
    gcamxx(nr)=dat(i,4);
    gca0x(nr)=dat(i,5);                              % parameters used in the correlation for the
    gca1x(nr)=dat(i,6);                              % thermal conductance of the gas gap
    gca2x(nr)=dat(i,7);
  else
    nmax=max(ifmpin);
    e1x=dat(i,1)*ones(1,nmax);
    e2x=dat(i,2)*ones(1,nmax);
    rlcax=dat(i,3)*ones(1,nmax);
    gcamxx=dat(i,4)*ones(1,nmax);
    gca0x=dat(i,5)*ones(1,nmax);
    gca1x=dat(i,6)*ones(1,nmax);
    gca2x=dat(i,7)*ones(1,nmax);
  end

  e1=ones(geom.kmax,1)*e1x(:,ifmpin);e1=e1(:);
  e2=ones(geom.kmax,1)*e2x(:,ifmpin);e2=e2(:);
  gcamx=ones(geom.kmax,1)*gcamxx(:,ifmpin);gcamx=gcamx(:);
  gca0=ones(geom.kmax,1)*gca0x(:,ifmpin);gca0=gca0(:);
  gca1=ones(geom.kmax,1)*gca1x(:,ifmpin);gca1=gca1(:);
  gca2=ones(geom.kmax,1)*gca2x(:,ifmpin);gca2=gca2(:);
  rlca=ones(geom.kmax,1)*rlcax(:,ifmpin);rlca=rlca(:);

  i=find(num==522000);
  rocf=dat(i,1:5);                            % volumetric heat capacity of the fuel
  rcca=dat(i,6);                              % volumetric heat capactiy of the cladding
  rcca=rcca*ones(ntot,1);

  i=find(num==523000);
  mm=dat(i,1);                                 % number of fuel zones
  mmc=dat(i,2);                                % number of cladding zones
end


%%

delta=0.037;
deltam=0.02;
i=find(num==580000);
if ~isempty(i),
    delta=dat(i,1);                              % fraction of heat generated directly in the coolant (incl. byp)
    deltam=dat(i,2);                             % fraction of heat generated directly in the byp
end

cmpfrc=0.037;
cmdfrc=0.037;
i=find(num==581000);
if ~isempty(i),
    cmpfrc=dat(i,1);                             % fraction of prompt heat deposited in coolant (incl. byp)
    cmdfrc=dat(i,2);                             % fraction of delayed heat deposited in coolant (incl. byp)
end

height(5)=geom.hz*geom.kmax/100;                      % fuel height

%%


geom.ntot=ntot;
geom.ncc=ncc;
geom.nsec=nsec;

avhspx=vhspx'/2; % TODO check this!
arhspx=rhspx';

%Added to compensate for part length rods with different flow areas
clear temp



[x,i]=sort(knum(:,1));
clear temp
temp(x)=i;

corec=vec2cor(temp,mminj);
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
    if i(k)> length(mminj)/2+1 && j(k)>length(mminj)/2+1
      neig(core(i(k),j(k)),:)=[core(i(k)-1,j(k)) core(i(k),j(k)+1) core(i(k)+1,j(k)) core(i(k),j(k)-1)];
    end
  end
end

neig=(neig-1)*geom.kmax;
i=find(neig<0);
neig(i)=(ntot+1)*ones(length(i),1);

neig=neig';
neig=neig(:);
A1=0;
rver=(geom.hx/geom.hz)^2;


%-------------------------------------------------------
% Setting the majority of the globals
%
% Some globals are set before, bcause they are used 
% by some subfunctions

% Geometrical data

geom.height=height;
geom.A=fue_new.afuel(:,knum(:,1));

if ~CoreOnly,
%If height(2) doesn't match the overall loop
%one has to take account for that and make corrections
dc2corr = (height(6)+height(5)+height(4)-height(1))/height(2);
if dc2corr>=1, 
  height(2)=height(2)*dc2corr;
  dc2corr = 1;
elseif dc2corr<0,
  error('Lower plenum 2 has unreasonable height')
end

geom.V_sd=V_sd; %TODO: kolla jfr v_sd

geom.a_dc1=a_dc1;
geom.h_dc1=h_dc1;
geom.v_dc1=v_dc1;
geom.dh_dc1=dh_dc1;
geom.vh_dc1=vh_dc1;

geom.a_dc2=a_dc2;
geom.h_dc2=h_dc2;
geom.v_dc2=v_dc2;
geom.dh_dc2=dh_dc2;
geom.vh_dc2=vh_dc2;

geom.a_lp1=a_lp1;
geom.h_lp1=h_lp1;
geom.v_lp1=v_lp1;
geom.dh_lp1=dh_lp1;
geom.vh_lp1=vh_lp1;

geom.a_lp2=a_lp2;
geom.h_lp2=h_lp2;
geom.v_lp2=v_lp2;
geom.dh_lp2=dh_lp2;
geom.vh_lp2=vh_lp2;

geom.a_upl=a_upl;
geom.h_upl=h_upl;
geom.v_upl=v_upl;
geom.dh_upl=dh_upl;
geom.vh_upl=vh_upl;

geom.a_sd=a_sd;
geom.h_sd=heightsd;
geom.v_sd=v_sd;
geom.dh_sd=dh_sd;

geom.nsep=nsep;
geom.asep=asep;
geom.hsep=hsep;

geom.a_by=a_by;
geom.dh_by=dh_by;
geom.vhi_by=vhi_by;
geom.vho_by=vho_by;

% Thermohydraulical data
termo.pump=pump;
termo.pk1=pk1;
termo.pk2=pk2;
termo.rleff0=rleff0;
termo.dc2corr=dc2corr;
end
termo.twophasekorr='mnelson';
termo.slipkorr='bmalnes';
%termo.slipkorr='bjones';
%Task: is slipkorr used?
termo.css=cssgl;
termo.cpb=cpb;
termo.avhspx=avhspx;
termo.arhspx=arhspx;
termo.zsp=zspx;
termo.ispac=ispac;
termo.Xcin=fue_new.Xcin(knum(:,1));
if isempty(fue_new.amdt)
    termo.amdt=[];
    termo.bmdt=[];
else
    termo.amdt=fue_new.amdt(:,knum(:,1));
    termo.bmdt=fue_new.bmdt(:,knum(:,1));
end
termo.phm=fue_new.phfuel(:,knum(:,1));
termo.Dh=fue_new.dhfuel(:,knum(:,1));
termo.pbm=4*geom.A./termo.Dh-termo.phm;
i_wr=length(fue_new.A_wr);
if i_wr==0,
    A_wr=[];Ph_wr=[];Dhy_wr=[];Kin_wr=[];Kex_wr=[];
end
for i=1:i_wr,
    A_wr(i,:)=fue_new.A_wr{i}(knum(:,1));
    Ph_wr(i,:)=fue_new.Ph_wr{i}(knum(:,1));
    Dhy_wr(i,:)=fue_new.Dhy_wr{i}(knum(:,1));
    Kin_wr(i,:)=fue_new.Kin_wr{i}(knum(:,1));
    Kex_wr(i,:)=fue_new.Kex_wr{i}(knum(:,1));
end
termo.A_wr=A_wr;
termo.Ph_wr=Ph_wr;
termo.Dhy_wr=Dhy_wr;
termo.Kin_wr=Kin_wr;
termo.Kex_wr=Kex_wr;
termo.vhifuel=fue_new.vhifuel(:,knum(:,1))';
termo.vhofuel=fue_new.vhofuel(:,knum(:,1))';
termo.casup=fue_new.casup;
termo.cbsup=fue_new.cbsup;
termo.ccsup=fue_new.ccsup;
termo.rhoref_bypass=fue_new.rhoref_bypass;

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
neu.k1=0.00190851655;
neu.t1=0.8337;
H0=0.07;
neu.k1h0=3.2041e-11*1e6*(1-H0); %1e6 is to take into account cm^3 => m^3 
neu.rver=rver;
neu.neig=neighbour(neig,geom.kmax);
neu.B1=3*A1/(3*A1+(1-A1)*(rver+2));
neu.C1=(1-A1)/(4*(3*A1+(1-A1)*(rver+2)));

% Data of the fuel
fuel.mm=mm;
fuel.mmc=mmc;
fuel.rf=rf;
fuel.rca=rca;
fuel.drca=drca;
fuel.nrods=nrods;
fuel.rocf=rocf;
fuel.rcca=rcca;
fuel.e1=e1;
fuel.e2=e2;
fuel.gcamx=gcamx;
fuel.gca0=gca0;
fuel.gca1=gca1;
fuel.gca2=gca2;
fuel.rlca=rlca;
