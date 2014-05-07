function [PINPOW3,fuel_data,PINEXP3,pin_data,PINFLU3,PINPOW2,PINEXP2,PINFLU2]=read_pinfile(pinfile,ISTA)
% read_pinfile - reads binary data from pinfile created by Simulate 3, 4 or 5
%
% [pow3,fuel_data,exp3,pin_data,flu3,pow2,exp2,flu2]=read_pinfile(pinfile,ISTA);
%
% Input:
%  pinfile - name on pinfile, eg. 'recalcs.pin'
%  ISTA    - State points to be read (integer vector), default all state points are read
% Output:
%  Note: ista is number of state points on file, IAFULL the span of the core, 
%        KDFUEL is number of nodes in axial direction, NPIN is number of pins in one direction (may
%        be different for different assemblies, OK since we use cell arrays)
%        If there is only one state-point in the file, the first layer will be removed,
%        eg PINPOW3{1}{8,8} gets the NPIN by NPIN by KDFUEL matrix for the 8,8 fuel bundle if there
%        are more than one state point. If there is only one state point,
%        PINPOW3{8,8} get the same NPIN by NPIN by KDFUEL matrix
%  pow3      - Pin powers   {ista}{IAFULL,IAFULL} cell, each cell contains a matrix NPIN by NPIN by KDFUEL
%  fuel_data - Contain summary info, structured variable
%  exp3      - Pin exposure {ista}{IAFULL,IAFULL} cell, each cell contains a matrix NPIN by NPIN by KDFUEL
%  pin_data  - pin data, structured variable 
%  flu3      - Pin fluence  {ista}{IAFULL,IAFULL} cell, each cell contains a matrix NPIN by NPIN by KDFUEL
%  pow2      - Pin power average    {ista}{IAFULL,IAFULL} cell, each cell contains a matrix NPIN by NPIN 
%  exp2      - Pin exposure average {ista}{IAFULL,IAFULL} cell, each cell contains a matrix NPIN by NPIN 
%  flu2      - Pin fluence average  {ista}{IAFULL,IAFULL} cell, each cell contains a matrix NPIN by NPIN 
%
% Examples:
%  pinpow3=read_pinfile('recalcs.pin');
%  ptraj=pmap2ptraj(pinpow3);
%  plot(ptraj{8,8})
%  plot(ptraj{1}{8,8}) % If there are more than one state point on the file
% Comparing two files
%  pinpow1=read_pinfile('pinfile1.pin');
%  pinpow2=read_pinfile('pinfile2.pin');
%  [AbsDiff,RelDiff]=pin_delta(pinpow1,pinpow2);
%
% See also read_pinfile_asyid, pmap2ptraj, pindis2cordis, pin_delta, pin_oper

% Extra help 
%  fuel_data.HEADER    - HEADER from Fortran program S3PIN (all useful stuff can be found in fuel_data, not really needed)
%  pin_data.PPIN  - Peak pin power. {ista} cell, each cell contains kan-by-KDFUEL matrix
%  pin_data.PPIN  - Peak pin power location. {ista} cell, each cell contains kan-by-KDFUEL matrix
%                       Location will be given by ii.jj, i.e. 16.1700 means location is at 16,17
%  pin_data.PCHA  - Channel power, {ista} cell, each cell contains kan-by-KDFUEL matrix
%  pin_data.LPCHA - Location peak power, {ista} cell, each cell contains kan-by-KDFUEL matrix
%                       Location will be given by ii.jj, i.e. 16.1700 means location is at 16,17
%  pin_data.FLUX1 - ask Tamer or look in the FORTRAN code
%  pin_data.FLUX2 - see above
%% Establish parameters
% LIPINPOW3MIDA = 32;
% LIMKD  = 52;
% LIMSTA = 150;
% LIMRAY = 150;
% LIMPIN = 20*PINPOW320;
% LIMHED = 350;
% LIMARA = 11;
%%
[fid,msg] = fopen(pinfile,'r','ieee-be');
NBYTES = 4;
% TODO: fread(fid,1,'float');NBYTES=ftell(fid); % In the future
%% Read the first record
% Set the file position at 0 in case it has moved
fseek(fid, 0, -1);
MAXREC = fread(fid, 1, 'int');
MAXSTA = fread(fid, 1, 'int');
MAXPIN = fread(fid, 1, 'int');
MAXHED = fread(fid, 1, 'int');
IAFULL = fread(fid, 1, 'int');
PINVER = fread(fid, 1, 'float');
SIMVER = fread(fid, 8, '*char')';
SIMDAT = fread(fid, 8, '*char')';
ADATE  = fread(fid, 8, '*char')';
ATIME  = fread(fid, 8, '*char')';
ASYSTM = fread(fid, 8, '*char')';
ITITLE = fread(fid, 80, '*char')';
CUSTOM = fread(fid, 8, '*char')';
IRMX   = fread(fid, 1, 'int');
if abs(IRMX)>100,  % Sometimes CUSTOM contain 10 characters
    fseek(fid,-12,0);
    CUSTOM = fread(fid, 10, '*char')';
    IRMX   = fread(fid, 1, 'int');
end
if nargin<2,
    ISTA=1:MAXSTA;
else
    ISTA=ISTA(:)'; % make sure ISTA is a row vector
end
numdata = length(ISTA);
    % TODO: find file with IRMX >= 0
% Set the record length
HEADER = NaN(20,MAXSTA);
MAXREC = (MAXPIN * NBYTES);
%% Read the header records
% Move to the starting position of the second record
fseek(fid, MAXREC, -1);

for irec = 2:20
    HEADER(irec,1:MAXSTA) = fread(fid, MAXSTA, 'float');
    fseek(fid, MAXREC*irec, -1);
end
%% Preallocate
%     XPO   =HEADER( 2,ista);
%     EBAR  =HEADER( 3,ista);
%     PERCTP=HEADER( 4,ista);
%     PERCWT=HEADER( 5,ista);
%     XNOTWT=HEADER( 6,ista);
%     FQ    =HEADER( 7,ista);
%     FXY   =HEADER( 8,ista);
%     AO    =HEADER( 9,ista);
MAXVAR=round(HEADER(10,1));
MAXASS=round(HEADER(11,1));
KDFUEL=round(HEADER(12,1));
PINPOW2= cell(1,numdata);
PINPOW3= cell(1,numdata);
PINEXP2= cell(1,numdata);
PINEXP3= cell(1,numdata);
PINFLU2= cell(1,numdata);
PINFLU3= cell(1,numdata);
SERIAL=cell(1,numdata);
LABEL=cell(1,numdata);
NPNASS=NaN(numdata,numdata);
IIAS=NaN(numdata,numdata);
JJAS=IIAS;
LPPIN=cell(1,numdata);
PPIN=cell(1,numdata);
LPCHA=cell(1,numdata);
PCHA=cell(1,numdata);
PEXP=cell(1,numdata);
EXP=cell(1,numdata);
SRC=cell(1,numdata);
RR1=cell(1,numdata);
FLUX1=cell(1,numdata);
FLUX2=cell(1,numdata);
IBAT  = NaN(MAXASS,numdata);
NPIN  = NaN(MAXASS,numdata);
NPINAV= NaN(MAXASS,numdata);
NHPIN = NaN(MAXASS,numdata);
S_AVE  = NaN(MAXASS,numdata);
EAVE  = NaN(MAXASS,numdata);
ISEG  = NaN(MAXASS,numdata);
IROT  = NaN(MAXASS,numdata);
RPD   = NaN(MAXASS,numdata);
RKWF  = NaN(MAXASS,numdata);
WCM   = NaN(MAXASS,numdata);
%% Loop over the statepoints
fseek(fid,MAXREC*MAXHED,-1);

for ista = ISTA,
    % Preallocate
    SERIAL{ista}=cell(IAFULL,IAFULL);
    PINPOW2{ista}= cell(IAFULL,IAFULL);
    PINPOW3{ista}=cell(IAFULL,IAFULL);
    PINEXP2{ista}= cell(IAFULL,IAFULL);
    PINEXP3{ista}=cell(IAFULL,IAFULL);
    PINFLU2{ista}= cell(IAFULL,IAFULL);
    PINFLU3{ista}=cell(IAFULL,IAFULL);
    if nargout>3, % pin_data required
        LPPIN{ista} = NaN(MAXSTA,KDFUEL);
        PPIN{ista} = NaN(MAXSTA,KDFUEL);
        LPCHA{ista} = NaN(MAXSTA,KDFUEL);
        PCHA{ista} = NaN(MAXSTA,KDFUEL);
        PEXP{ista} = NaN(MAXSTA,KDFUEL);
        EXP{ista}   = NaN(MAXSTA,KDFUEL);
        SRC{ista}   = NaN(MAXSTA,KDFUEL);
        RR1{ista}   = NaN(MAXSTA,KDFUEL);
        FLUX1{ista} = NaN(MAXSTA,KDFUEL);
        FLUX2{ista} = NaN(MAXSTA,KDFUEL);
    end
    % Loop over the assemblies
    for iasm = 1:MAXASS
        irec=MAXHED+((ista-1)*MAXASS+(iasm-1))*(1+MAXVAR+MAXVAR*KDFUEL);
        fseek(fid, MAXREC*irec,-1);
        iarray=fread(fid,3,'int');
        NPNASS(iasm,ista) = iarray(1);
        IIAS(iasm,ista)  = iarray(2);
        JJAS(iasm,ista)  = iarray(3);
        charray=fread(fid,16,'*char')';
        SERIAL{ista}{IIAS(iasm,ista),JJAS(iasm,ista)}=charray([1:3 5:7]);
        LABEL{ista}{IIAS(iasm,ista),JJAS(iasm,ista)} =charray([9:11 13:15]);
        IBAT(iasm,ista)  = fread(fid,1,'int');
        NPIN(iasm,ista)  = fread(fid,1,'int');
        NPINAV(iasm,ista)= fread(fid,1,'float');
        NHPIN(iasm,ista) = fread(fid,1,'int');

        S_AVE(iasm,ista) = fread(fid,1,'float');
        EAVE(iasm,ista)  = fread(fid,1,'float');
        ISEG(iasm,ista)  = fread(fid,1,'int');
        IROT(iasm,ista)  = fread(fid,1,'int');
        RPD(iasm,ista)   = fread(fid,1,'float');
        RKWF(iasm,ista)  = fread(fid,1,'float');
        WCM(iasm,ista)   = fread(fid,1,'float');

        NP=NPIN(iasm,ista);NP2=NP*NP;
        not_full=NP2~=MAXPIN;
        
        % Get assembly-wise data
        if nargout>3, % pin_data required
            for k = 1:KDFUEL
                iarray=fread(fid,3,'int');
                % unpack and unpck2 is done immediately
                x=iarray/10000;
                xr=round(x);
                PPIN{ista}(iasm,k) = xr(1)/1000;
                LPPIN{ista}(iasm,k) = (x(1)-xr(1))*100; % Location will be ii.jj
                PCHA{ista}(iasm,k) = xr(2)/1000;
                LPCHA{ista}(iasm,k) = (x(2)-xr(2))*100; % Location will be ii.jj
                PEXP{ista}(iasm,k) = xr(3)/100;
                EXP{ista}(iasm,k) = (x(3)-xr(3))*100; 
                farray=fread(fid,4,'float');                
                SRC{ista}(iasm,k) = farray(1);
                RR1{ista}(iasm,k) = farray(2);
                FLUX1{ista}(iasm,k) = farray(3);
                FLUX2{ista}(iasm,k) = farray(4);
            end
            % Move to the end of the assembly data block
            irec=irec+1;
            fseek(fid, MAXREC*irec, -1);
            
            % Get 2-D pin-wise data
            PINPOW2{ista}{IIAS(iasm,ista),JJAS(iasm,ista)} = reshape(fread(fid, NP2, 'float=>real*4'),NP,NP);
            
            % Get 2-D exposure data (if present)
            if (MAXVAR >= 2)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                PINEXP2{ista}{IIAS(iasm,ista),JJAS(iasm,ista)} = reshape(fread(fid, NP2, 'float=>real*4'),NP,NP);
            end
            
            % Get 2-D fluence data (if present)
            if (MAXVAR >= 3)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                PINFLU2{ista}{IIAS(iasm,ista),JJAS(iasm,ista)} = reshape(fread(fid, NP2, 'float=>real*4'),NP,NP);
            end
        else
            irec=irec+MAXVAR;
            fseek(fid,(irec+1)*MAXREC,-1);
        end
        % Get 3-D pin-wise data, pre-allocate
        PINPOW3{ista}{IIAS(iasm,ista),JJAS(iasm,ista)}=single(nan(NP,NP,KDFUEL));
        if (MAXVAR >= 2),
            PINEXP3{ista}{IIAS(iasm,ista),JJAS(iasm,ista)}=single(nan(NP,NP,KDFUEL));
        end
        if (MAXVAR >= 3),
            PINFLU3{ista}{IIAS(iasm,ista),JJAS(iasm,ista)}=single(nan(NP,NP,KDFUEL));
        end        
        for k = 1:KDFUEL
            irec=irec+1;
            if not_full, fseek(fid, MAXREC*irec, -1); end
            PINPOW3{ista}{ IIAS(iasm,ista), JJAS(iasm,ista)}(:,:,k) = reshape(fread(fid, NP2, 'float=>real*4'), NP, NP);
            % Get 3-D exposure data (if present)
            if (MAXVAR >= 2)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end                
                PINEXP3{ista}{ IIAS(iasm,ista), JJAS(iasm,ista)}(:,:,k) = reshape(fread(fid, NP2, 'float=>real*4'), NP, NP);
            end
            % Get 3-D fluence data (if present)
            if (MAXVAR >= 3)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end                
                PINFLU3{ista}{ IIAS(iasm,ista), JJAS(iasm,ista)}(:,:,k) = reshape(fread(fid, NP2, 'float=>real*4'), NP, NP);
            end
        end
    end
end
fclose(fid);
if nargout>1,
    fuel_data.pinfile=pinfile;
    fuel_data.NPNASS=NPNASS;
    fuel_data.IIAS=IIAS;
    fuel_data.JJAS=JJAS;
    fuel_data.IJAS=[IIAS;JJAS];
    fuel_data.SERIAL=SERIAL;
    fuel_data.LABEL=LABEL;
    fuel_data.IBAT=IBAT;
    fuel_data.NPIN=NPIN;
    fuel_data.NPINAV=NPINAV;
    fuel_data.NHPIN=NHPIN;
    fuel_data.S_AVE=S_AVE;
    fuel_data.EAVE=EAVE;
    fuel_data.ISEG=ISEG;
    fuel_data.IROT=IROT;
    fuel_data.RPD=RPD;
    fuel_data.RKWF=RKWF;
    fuel_data.WCM=WCM;
    fuel_data.PINVER=PINVER;
    fuel_data.SIMVER=SIMVER;
    fuel_data.SIMDAT=SIMDAT;
    fuel_data.ADATE=ADATE;
    fuel_data.ATIME=ATIME;
    fuel_data.ASYSTM=ASYSTM;
    fuel_data.ITITLE=ITITLE;
    fuel_data.CUSTOM=CUSTOM;
    fuel_data.IRMX=IRMX;
    fuel_data.XPO   =HEADER( 2,:);
    fuel_data.EBAR  =HEADER( 3,:);
    fuel_data.PERCTP=HEADER( 4,:);
    fuel_data.PERCWT=HEADER( 5,:);
    fuel_data.NOTWT=HEADER( 6,:);
    fuel_data.FQ    =HEADER( 7,:);
    fuel_data.FXY   =HEADER( 8,:);
    fuel_data.AO    =HEADER( 9,:);
    fuel_data.MAXSTA=MAXSTA;
    fuel_data.MAXVAR=MAXVAR;
    fuel_data.MAXASS=MAXASS;
    fuel_data.KDFUEL=KDFUEL;
    fuel_data.HEADER=HEADER;
    i1=find(IIAS(:,ISTA(1)));
    fuel_data.mminj=ij2mminj(IIAS(i1,ISTA(1)),JJAS(i1,ISTA(1)));
    %IIAS(i1,1) rather than IIAS(:,1) for the possibility that
    %the first case on file is a half-core or quarter core and later cases
    %has more bundles in place
end
if nargout>3,
    pin_data.PPIN=PPIN;
    pin_data.LPPIN=LPPIN;
    pin_data.PCHA=PCHA;
    pin_data.LPCHA=LPCHA;
    pin_data.EXP=EXP;
    pin_data.PEXP=PEXP;
    pin_data.SRC=SRC;
    pin_data.RR1=RR1;
    pin_data.FLUX1=FLUX1;
    pin_data.FLUX2=FLUX2;
end
if length(ISTA)==1, %If number of state-points is = 1, the state-point level is overkill, so remove it
    fuel_data.SERIAL=fuel_data.SERIAL{1};
    fuel_data.LABEL=fuel_data.LABEL{1};
    PINPOW2=PINPOW2{ISTA};
    PINPOW3=PINPOW3{ISTA};
    PINEXP2=PINEXP2{ISTA};
    PINEXP3=PINEXP3{ISTA};
    PINFLU2=PINFLU2{ISTA};
    PINFLU3=PINFLU3{ISTA};
    LPPIN=LPPIN{1};
    PPIN=PPIN{1};
    LPCHA=LPCHA{1};
    PCHA=PCHA{1};
    PEXP=PEXP{1};
    EXP=EXP{1};
    SRC=SRC{1};
    RR1=RR1{1};
    FLUX1=FLUX1{1};
    FLUX2=FLUX2{1};
end

