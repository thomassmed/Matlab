%
% read_polca_bin  Reads from Polca distribution-files into CMS-datastructures
%
% [fue_new,Oper,distout,distlist,cases]=read_polca_bin(distfile,distname,pcase)
%
% Input
%   distfile - dist or sum file name (.dat)
%   pcase    - case nr on sum file
%
% Output
%   fue_new     - Structured variable with history data (burnup, vhist, crdhist, etc
%   Oper        - Structured variable with operating data (power, flow, tinlet etc)
%
% See also read_restart_bin, reads3_out
%
function [fue_new,Oper,distout,distlist,cases]=read_polca_bin(distfile,distname,pcase)

if nargin >0
  filename=deblank(distfile);
else
    error('No filename given!');
end

%% Open file
fid=fopen(filename,'r','b');
ind=fread(fid,50,'int32');
if ind(1)~=1
  fclose(fid);
  fid=fopen(filename,'r','l');
  ind=fread(fid,50,'int32');
end

%% Check if filetype is dist- or sum-file
isdistfile=0; issumfile=0;
if ind(50)==92348
    isdistfile=1;
else
    ind=[ind; fread(fid,50,'int32')];
    if ind(100)==921106
        issumfile=1;
    end
end


% ---- Input is distfile ----
if isdistfile==1
    
    %% Read distlist
    distlist=setstr(fread(fid,[8,ind(46)]));
    distlist=flipud(rot90(distlist));

    %% Start reading filehead-data
    fseek(fid,4*ind(3)-4,-1);
    iadr=fread(fid,3*ind(46),'int32');
    fseek(fid,4*ind(7)-4,-1);
    rubrik=setstr(fread(fid,80))';
    fseek(fid,4*ind(8)-4,-1);
    mz=fread(fid,200,'int32');
    ks=fread(fid,200,'int32');
    op=fread(fid,150,'int32');
    bb=fread(fid,200,'float32');
    hy=fread(fid,250,'float32');
    au=fread(fid,100,'float32');
    fu=fread(fid,100,'float32');
    fseek(fid,4*ind(16)-4,-1);
    konrod=10*fread(fid,mz(69),'float32');
    fseek(fid,4*ind(19)-4,-1);
    mminj=fread(fid,2*mz(13),'int32');
    mminj=mminj(1:2:length(mminj));
    mminjrefl=mminj;
    fseek(fid,4*ind(23)-4,-1);
    detpos=fread(fid,mz(14),'int32');
    fseek(fid,4*ind(25)-4,-1);
    flopos=fread(fid,2*mz(97),'int32');
    fseek(fid,4*ind(26)-4,-1);
    iaf=fread(fid,4*mz(12),'char');
    iaf=char(reshape(iaf,4,mz(12))');
    fseek(fid,4*ind(27)-4,-1);
    jaf=fread(fid,4*mz(13),'char');
    jaf=char(reshape(jaf,4,mz(13))');
    fseek(fid,4*ind(28)-4,-1);
    soufil=remblank(setstr(fread(fid,80))');
    fseek(fid,4*ind(30)-4,-1);
    masfil=remblank(setstr(fread(fid,80))');
    fseek(fid,4*ind(31)-4,-1);
    asyref=setstr(fread(fid,4*mz(44)));
    asyref=reshape(asyref,4,mz(44))';
    asyref(strmatch(char(32),asyref),:)=[];
    fseek(fid,4*ind(37)-4,-1);
    spacerdat=fread(fid,mz(57),'float32');
    fseek(fid,4*ind(38)-4,-1);
    spaceradr=fread(fid,mz(57),'int32');
    fseek(fid,4*48-4,-1);
    staton=remblank(setstr(fread(fid,4))');

    % Read ASYDAT
    %[asydat,asyadr] = read_asydat(distfile);
    
    % Read SPACERDAT
    % TO BE IMPLEMENTED
    
    %% Make a list of the distributions we need in fue_new
    fuedistlist=['ASYID '; 'ASYROT'; 'POWER '; 'XENON '; 'IODINE'; ...
                 'SM149 '; 'PM149 '; 'BURNUP'; 'DNSHIS'; 'CRHIS '; ...
                 'ASYTYP'];
    
    ascdist=['ASYTYP';'ASYID ';'CRID  ';'CRTYP ';];
    lstrs=[4 16 16 4];
    
    %% Add distribution given as input to fuedistlist
    if nargin>1
        if isempty(strmatch(distname,fuedistlist))
            fuedistlist=strvcat(fuedistlist,distname);
        end
    end
    
    %% Start reading distributions
    for n=1:size(fuedistlist,1)
        inddis=strmatch(fuedistlist(n,:),distlist);
        %inddis=n;
        
        if ~isempty(inddis)
            fseek(fid,4*(iadr(inddis*3-2)-1),-1);
            fseek(fid,5*4,0);
            dsize=fread(fid,1,'int32');
            subsize=fread(fid,1,'int32');
            kmxval=fread(fid,1,'int32');
            kmxnod=fread(fid,1,'int32');
            isym=fread(fid,1,'int32');
       
            fseek(fid,4,0);
            sidref=fread(fid,1,'int32');
            
            if sidref==1
                mminjrefl=[mminj(1:mz(12)/2); mminj(mz(12)/2); mminj(mz(12)/2+1); mminj(mz(12)/2+1:mz(12))];
                reflec=sort(findrefl(mminjrefl));
                
                kfullh=half2full(1:mz(20)/2,mminjrefl);
                kfullq=quart2full(1:mz(20)/4,mminjrefl);
            else
                reflec=[];
                kfullh=half2full(1:mz(14)/2,mminj);
                kfullq=quart2full(1:mz(14)/4,mminj);
            end    
            
            fseek(fid,4*(iadr(inddis*3-2)-1)+4*subsize,-1);
            
            if strmatch(fuedistlist(n,:),ascdist)        % ASCII dist data
                i=strmatch(fuedistlist(n,:),ascdist);
                if ~isempty(i),lstr=lstrs(i);end
                dist=char(fread(fid,4*dsize))';
                if isym==3
                    asyfull=setstr(32*ones(1,2*length(dist)));
                    for i=1:lstr
                        asyfull((kfullh(:,1)-1)*lstr+i)=dist((i:lstr:end));
                        asyfull((kfullh(:,2)-1)*lstr+i)=dist((i:lstr:end));
                    end
                    dist=asyfull;
                end
                if sidref==1 & size(dist,2)==lstr*mz(20)
                    pos=lstr*(reflec-1)+1;
                    for i=length(pos):-1:1
                        dist(pos(i):(pos(i)+lstr-1))=[];
                    end
                end
            else                                  % Floating point dist data
                dist=fread(fid,dsize,'float32');
                dist=reshape(dist,kmxval,dsize/kmxval);
                if isym==3
                    distfull=zeros(kmxval,2*dsize/kmxval);
                    for i=1:kmxval
                        distfull((kfullh(:,1)-1)*kmxval+i)=dist((i:kmxval:end));
                        distfull((kfullh(:,2)-1)*kmxval+i)=dist((i:kmxval:end));
                    end
                    dist=distfull;
                end
                if isym==5
                    distfull=zeros(kmxval,4*dsize/kmxval);
                    for i=1:kmxval
                        distfull((kfullq(:,1)-1)*kmxval+i)=dist((i:kmxval:end));
                        distfull((kfullq(:,2)-1)*kmxval+i)=dist((i:kmxval:end));
                        distfull((kfullq(:,3)-1)*kmxval+i)=dist((i:kmxval:end));
                        distfull((kfullq(:,4)-1)*kmxval+i)=dist((i:kmxval:end));
                    end
                    dist=distfull;
                end
                if size(dist,2)==mz(20),dist(:,reflec)=[];end
            end
            
            distdata.(lower(deblank(fuedistlist(n,:))))=dist;
        else
            %fprintf(1,'\nCould not find distribution %s in file %s\n',fuedistlist(n,:),filename);
        end
    end
    
    
    %% Special treatment of asytyp
    inddis=strmatch('ASYTYP',distlist);
    
    fseek(fid,4*(iadr(inddis*3-2)-1),-1);
    fseek(fid,5*4,0);
    dsize=fread(fid,1,'int32');
    subsize=fread(fid,1,'int32');
    kmxval=fread(fid,1,'int32');
    kmxnod=fread(fid,1,'int32');
    isym=fread(fid,1,'int32');
    
    fseek(fid,4*(iadr(inddis*3-2)-1)+4*subsize,-1);
    
    asytyp=char(fread(fid,4*dsize))';
    if isym==3
        asyfull=setstr(32*ones(1,2*length(asytyp)));
        for i=1:4
            asyfull((kfullh(:,1)-1)*4+i)=asytyp((i:4:end));
            asyfull((kfullh(:,2)-1)*4+i)=asytyp((i:4:end));
        end
        asytyp=asyfull;
    end
    if isym==5
        asyfull=setstr(32*ones(1,2*length(asytyp)));
        for i=1:4
            asyfull((kfullq(:,1)-1)*4+i)=asytyp((i:4:end));
            asyfull((kfullq(:,2)-1)*4+i)=asytyp((i:4:end));
            asyfull((kfullq(:,3)-1)*4+i)=asytyp((i:4:end));
            asyfull((kfullq(:,4)-1)*4+i)=asytyp((i:4:end));
        end
        asytyp=asyfull;
    end
    if sidref==1
        pos=4*(reflec-1)+1;
        for i=length(pos):-1:1
            asytyp(pos(i):(pos(i)+4-1))=[];
        end
    end
    
    setfield(distdata,'asytyp',asytyp);
    
    
    %% Do some sorting of data
    [tmp,i]=sortrows(-asyref(:,3:4));
    asyref=asyref(i,:);
    asyref=reshape(rot90(asyref,-1),1,size(asyref,1)*size(asyref,2));
    
    distlist=sortrows(distlist);
    distlist=reshape(rot90(distlist,-1),1,size(distlist,1)* ...
                     size(distlist,2));
    
    ll=length(distlist)/8;
    distlist=rot90(reshape(distlist,8,ll));
    
    % Done reading from file
    fclose(fid);
    
    
    cases=[{1} {rubrik} {filename} {1}]; % Only one case if distfile
    
    
    
    
    %% Start buildning Oper struct from polca-data
    Oper.Qrel = 100*hy(11);                                % Relative thermal reactor power [%]
    Oper.Qtot = hy(11)*hy(1); 
    Oper.Qnom = hy(1);                                     % Nominal thermal reactor power [watt]
    Oper.Wtot = hy(2);                                     % Total reactor coolant flow [kg/s] 
    Oper.Wrel = 100*hy(2)/hy(6);                           % Relative reactor coolant flow [-]
    Oper.Wnom = hy(10);                                    % Nominal core coolant flow (BWR) [kg/s]
    Oper.powden = bb(27)/1e6;                              % Nominal power density [MW/m3] 
    Oper.floden = hy(111);                                 % Core average coolant density [kg/m3]
    Oper.floden_hour = [];
    Oper.p = hy(3);                                        % Top of reactor vessel pressure [pascal]
    Oper.Hinlet = hy(13)/1000;                             % Coolant inlet avg enthalpy [kJ/kg]
    Oper.Hinlet_BTU_lb = [];
    Oper.keff = bb(96);                                    % Effective multiplication constant
    if Oper.keff<0.8||Oper.keff>1.2, Oper.keff=bb(91);end
    if Oper.keff<0.8||Oper.keff>1.2, Oper.keff=1;end
    Oper.Power = distdata.power;

    Oper.wlt_cwt = [];                                     % NOT USED? Bypass: Nr of flow points
    Oper.wlt_ctp = [];                                     % NOT USED? Bypass: Nr of power points
    Oper.wlt_bypass_frac = [];                             % NOT USED? Total bypass flow table
                                                           % of size: wlt_cwt*wlt_ctp
    
    Oper.wby = [];                                         % Bypass flow per bundle
    Oper.wlk_wt = hy(151);                                 % Total bypass flow as percentage of total core flow
    Oper.p_psia = pas2psi(hy(3));                          % Total Pressure in psia
    Oper.pr1 = Oper.p_psia;                                % Pressure, constant part, for POLCA same as total pressure
    Oper.pr2 = [];                                         % NOT USED? Pressure, power dependent part
    Oper.pr3 = [];                                         % NOT USED? Pressure, flow dependent part
    Oper.tlp = hy(14);                                     % Coolant inlet avg temperature [C]
    Oper.tlp_F = C2F(Oper.tlp);

    %% Set fields in fue_new
    fue_new.C = [];                                        % NOT USED Simulate variable

    %% Coordinates
    fue_new.iaf = zeros(mz(14),1);                          % Assembly x-coordinate
    fue_new.jaf = zeros(mz(14),1);                          % Assembly y-coordinate
    sum = 0;
    for i=1:length(mminj)
        len = length(mminj)-2*(mminj(i)-1);
        fue_new.iaf(sum+1:sum+len) = repmat(str2double(iaf(i,:)),len,1);
        fue_new.jaf(sum+1:sum+len) = repmat(str2double(jaf(i,:)),len,1);
        sum = sum + len;
    end
    
    %% Assembly history and nuclide tracking
    if isfield(distdata,'xenon')
        fue_new.xenon = distdata.xenon;                    % Xenon
    end
    fue_new.ibat = [];                                     % Batch number
    if isfield(distdata,'iodine')
        fue_new.iodine = distdata.iodine;                  % Iodine
    end
    fue_new.promethium = distdata.pm149;                   % Promethium
    fue_new.samarium = distdata.sm149;                     % Samarium
    fue_new.burnup = distdata.burnup;                      % Burnup
    fue_new.vhist = [];                                    % Void history 
    fue_new.crdhist = distdata.crhis;                      % Control rod history
    fue_new.tfuhist = [];                                  % Average fuel temperature history
    
    %% Assembly type and identity
    fue_new.nload = [];                                    % [700x1 double]
    fue_new.nfta = [];                                     % Assembly type number
    %fue_new.lab = reshape(distdata.asyid,lstrs(2),mz(14))';% Fuel assembly labels
    fue_new.ser = [];                                      % Fuel assembly serial numbers
    fue_new.nfra = distdata.asyrot;                        % Assembly Rotation
    fue_new.nhyd = [];                                     % Mechanical design type
    
    fue_new.asmnam = asyref;                               % [9x20 char]
    
    %% Reactor and nodal geometry
    fue_new.mminj = mminj;
    fue_new.sym = get_sym_name(mz(2));
    fue_new.isymc = mz(2);
    fue_new.knum = knumsym(mminj, mz(2));
    fue_new.kan_res = mz(14);
    fue_new.kan = mz(14);
    fue_new.kmax = mz(17);
    fue_new.iafull = size(mminj,1);
    fue_new.hx = bb(13)*100;
    fue_new.hz = (100*bb(1))/mz(11);                      % CZMESH
    fue_new.dxassm = bb(2);
    fue_new.hcore = bb(11)*100;
    fue_new.active_hcore = bb(1)*100;
    
    fue_new.lwr = get_reatyp_name(mz(1));
    fue_new.chanel = [];                                   % [5x20 double]
    fue_new.elevat = [0 0 0 0 0 0 0];                      % Not available in POLCA, BWR-elevationlevels
    
    %% Path to cross-section data file
    fue_new.cd_file = [];                                  % Not available in dist file
    
    %% Segment data
    fue_new.Core_Seg = [];                                 % {[25x700 double]  [25x700 double]  [25x700 double]}
    fue_new.Seg_w = [];                                    % {[25x700 double]  [25x700 double]  [25x700 double]}
    fue_new.Segment = [];                                  % [200x20 char]
    
    %% Fuel data
    fue_new.afuel = [];                                    % [25x700 double]
    fue_new.dhfuel = [];                                   % [25x700 double]
    fue_new.phfuel = [];                                   % [25x700 double]
    fue_new.xxcin = [];                                    % [20x3 double]

    fue_new.A_wr = [];                                     % Flow area of zone {[1x700 double]}
    fue_new.Ph_wr = [];                                    % Heated perimeter {[1x700 double]}
    fue_new.Dhy_wr = [];                                   % Hydraulic diameter {[1x700 double]}
    fue_new.Kin_wr = [];                                   % Water tube inlet loss coefficent {[1x700 double]}
    fue_new.Kex_wr = [];                                   % Water tube exit loss coefficent {[1x700 double]}
    fue_new.Kin_wtr = [];                                  % Inlet loss coefficent {[1x700 double]}
    fue_new.Kex_wtr = [];                                  % Exit loss coefficent {[1x700 double]}
    
    fue_new.vhifuel = [];                                  % [1x700 double]
    fue_new.vhofuel = [];                                  % [1x700 double]
    fue_new.Xcin = [];                                     % [1x700 double]
    fue_new.orityp = [];                                   % [1x700 double]
    
    %% Control rod data
    fue_new.crtyp = [];                                    % [1x169 double]
    fue_new.crmminj = mminj2crmminj(mminj);
    fue_new.konrod = konrod/10;
    
    fue_new.dzstep = [];                                   % 3.6480
    fue_new.crdsteps = 1000;                               % 100
    fue_new.crdzon = [];                                   % [7x20 double]
    fue_new.crd_gray = [];                                 % [7x20 double]
    fue_new.ncrd = [];                                     % [7x20 double]
    
    fue_new.irmx = size(fue_new.crmminj,1);                % 15

    %% Detector data
    fue_new.detloc = detpos2detloc(detpos,mminj);
    % Needs master data: mad_DETLEV
    fue_new.idetz = [];                                    % [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    fue_new.ddetz = [];                                    % [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    fue_new.det_axloc = [];                                % []
    
    %% Spacer data
    fue_new.xxkspa = [];                                   % [20x20 double]
    fue_new.xkspac = [];                                   % [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    fue_new.zspacr = [];                                   % [20x8 double]
    
    %% Support plate leakage
    fue_new.casup = [];                                    % Flow path coefficient i for square root term
    fue_new.cbsup = [];                                    % Flow path coefficient i for linear term
    fue_new.ccsup = [];                                    % Flow path coefficient i for squared term
    fue_new.rhoref_bypass = [];                            % Reference density

    %% Options
    fue_new.if2x2 = [];                                    % Option: Intranodal mesh, 1=one node per assembly
                                                           %                          2=2x2 mesh per assembly
    fue_new.if_wlt = [];                                   % Option: 
    fue_new.ifmeti = 1;                                    % Option: Use metric units
    
    
    
    % Output requested distribution
    if nargin>1
        distname=lower(deblank(distname));
        if isfield(distdata,distname)
            distout = distdata.(distname);
        end
    else
        distout=Oper.Power;
    end
    
% ---- Input is sumfile ----    
elseif issumfile==1
    
    % Initialize some sizes and constants
    CASESZ = 800;
    DATASETSTART=1600;
    TITLEWORDNO = 404;
    DISTWORDNO = 480;
    TITLESZ = 32;
    DISTNAMESZ = 32;
    
    %% Get list of all cases on sum-file
    nrecords=ind(1);
    
    %% Get filelist
    cases = [];
    distfiles = [];
    for i=1:nrecords
       fseek(fid,DATASETSTART+((i-1)*CASESZ)+TITLEWORDNO,-1);
       title =  char(fread(fid,TITLESZ,'uint8'))';
       fseek(fid,DATASETSTART+((i-1)*CASESZ)+DISTWORDNO,-1);
       distfile = deblank(char(fread(fid,DISTNAMESZ,'uint8'))');
       fexist=exist(distfile,'file');
       if fexist>0
           cases = [cases; [{i} {title} {distfile} {fexist}]];
       else
           cases = [cases; [{-1} {title} {distfile} {fexist}]];
       end
    end
    
    %%  If case specified as argument get filename of that case
    %  else get filename of first case
    if nargin>2
        if pcase>length(cases)
            pcase = 1;
            warning(['Only ' length(cases) ' cases on file, defaulting to first case']);
        end
    else
        pcase = 1;
    end
    
    %% Read fue_new and Oper from the distfile of the specified case
    %  by doing a recursive call to read_polca_dist
    if cases{pcase,4}~=0
        [fue_new,Oper,distout,distlist,dcase] = read_polca_bin(cases{pcase,3});
    else
        warning(['Dist file ' cases{pcase,3} ' does not exist!']);
        fue_new=[];
        Oper=[];
        distout=[];
        distlist=[];
    end
    
else
    
    error('Unknown filetype!');
    
end