function [pow3,fuel_data,exp3,pin_data,flu3,PINPOW2,PINEXP2,PINFLU2]=read_pinfile_asyid(pinfile,asyid,ISTA)
% read_pinfile_asyid - reads binary data from pinfile created by Simulate 3, 4 or 5
%
% [pow3,fuel_data,exp3,pin_data,flu3,pow2,exp2,flu2]=read_pinfile_asyid(pinfile,asyid);
%
% Input:
%  pinfile - name on pinfile, eg. 'recalcs.pin'
%  asyid   - assembly identity ('SERIAL')
%
% Output:
%  pow3      - Pin powers   {NPIN,NPIN} cell, each cell contains a matrix ISTA by KDFUEL
%  fuel_data - Contain summary info, structured variable
%  exp3      - Pin exposure {NPIN,NPIN} cell, each cell contains a matrix ISTA by KDFUEL
%  pin_data  - pin data, structured variable 
%  flu3      - Pin fluence  
%  pow2      - Pin power average  {ISTA} cell, each cell contains NPIN by NPIN, empty if assembly is
%              not in the core at this state point
%  exp2      - Pin exposure average {ISTA} cell, each cell contains NPIN by NPIN
%  flu2      - Pin fluence average  {ISTA} cell, each cell contains NPIN by NPIN 
% Examples:
% [pow3,fuel_data,exp3,pin_data,flu3,pow2,exp2,flu2]=read_pinfile_asyid(pinfile,'0AB2');
% plot(pp{17,17}(:,[2 6])) % Plot power of pin 17,17
% plot(pin_data.EXP(:,[2 6]),pp{17,17}(:,[2 6])) % power vs node exp
%
% See also read_pinfile, pmap2ptraj, pindis2cordis, pin_delta, pin_oper

% Extra help TODO: update the text below
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
% TODO: Check if exp and fluency has been mixed up!
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
MAXVAR=round(HEADER(10,1));
MAXASS=round(HEADER(11,1));
KDFUEL=round(HEADER(12,1));
PINPOW2= cell(1,MAXSTA);
PINEXP2= cell(1,MAXSTA);
PINFLU2= cell(1,MAXSTA);
SERIAL=cell(1,MAXSTA);
SERIAL1=cell(MAXASS,MAXSTA);
LABEL=cell(1,MAXSTA);
NPNASS=NaN(MAXASS,MAXSTA);
IIAS=NaN(MAXASS,1);
JJAS=IIAS;
LPPIN=cell(1,MAXSTA);
PPIN=cell(1,MAXSTA);
LPCHA=cell(1,MAXSTA);
PCHA=cell(1,MAXSTA);
PEXP=cell(1,MAXSTA);
EXP=cell(1,MAXSTA);
SRC=cell(1,MAXSTA);
RR1=cell(1,MAXSTA);
FLUX1=cell(1,MAXSTA);
FLUX2=cell(1,MAXSTA);
IBAT  = NaN(1,MAXSTA);
NPIN  = NaN(1,MAXSTA);
NPINAV= NaN(1,MAXSTA);
NHPIN = NaN(1,MAXSTA);
S_AVE  = NaN(1,MAXSTA);
EAVE  = NaN(1,MAXSTA);
ISEG  = NaN(1,MAXSTA);
IROT  = NaN(1,MAXSTA);
RPD   = NaN(1,MAXSTA);
RKWF  = NaN(1,MAXSTA);
WCM   = NaN(1,MAXSTA);
%% Loop over the statepoints
fseek(fid,MAXREC*MAXHED,-1);
if nargin<3,
    ISTA=1:MAXSTA;
else
    ISTA=ISTA(:)'; % make sure ISTA is a row vector
end
for ista = ISTA,
    % Preallocate
    SERIAL{ista}=cell(MAXASS,1);
    % Loop over the assemblies
    for iasm = 1:MAXASS
        irec=MAXHED+((ista-1)*MAXASS+(iasm-1))*(1+MAXVAR+MAXVAR*KDFUEL);
        fseek(fid, MAXREC*irec,-1);
        iarray=fread(fid,3,'int');
        NPNASS(ista) = iarray(1);
        IIAS(iasm)  = iarray(2);
        JJAS(iasm)  = iarray(3);
        charray=fread(fid,16,'*char')';
        SERIAL{ista}{iasm}=remblank(charray([1:3 5:7]));
        SERIAL1{iasm,ista}=SERIAL{ista}{iasm};
        fseek(fid,4,0);
        NPIN(iasm,ista)  = fread(fid,1,'int');        
    end
    asyknum{ista}=find(strcmpi(strtrim(asyid),SERIAL{ista}));
end
icount=0;
for i=1:length(asyknum),
    if isempty(asyknum{i}), continue;end
    icount=icount+1;
    Asyknum(icount)=asyknum{i};
    ISTA(icount)=i;
end
Np=NPIN(Asyknum(1),ISTA(1));

% Preallocate
pow3=cell(Np,Np);
lenISTA=length(ISTA);
for i=1:Np,
    for j=1:Np,
        pow3{i,j}=nan(lenISTA,KDFUEL);
    end
end
exp3=pow3;flu3=pow3;
npin=nan(1,lenISTA);
ser=cell(lenISTA,1);
lab=cell(lenISTA,1);

if nargout>3, % pin_data required
    LPPIN = NaN(lenISTA,KDFUEL);
    PPIN = NaN(lenISTA,KDFUEL);
    LPCHA = NaN(lenISTA,KDFUEL);
    PCHA = NaN(lenISTA,KDFUEL);
    PEXP = NaN(lenISTA,KDFUEL);
    EXP   = NaN(lenISTA,KDFUEL);
    SRC   = NaN(lenISTA,KDFUEL);
    RR1   = NaN(lenISTA,KDFUEL);
    FLUX1 = NaN(lenISTA,KDFUEL);
    FLUX2 = NaN(lenISTA,KDFUEL);
end

icount=0;
for ista = ISTA,   
    for iasm = asyknum{ista}
        if isempty(iasm),continue;end
        icount=icount+1;
        SERIAL1{iasm,ista}='******';
        irec=MAXHED+((ista-1)*MAXASS+(iasm-1))*(1+MAXVAR+MAXVAR*KDFUEL);
        fseek(fid, MAXREC*irec,-1);
        iarray=fread(fid,3,'int');
        NPNASS(ista) = iarray(1);
        IIAS(ista)  = iarray(2);
        JJAS(ista)  = iarray(3);
        charray=fread(fid,16,'*char')';
        ser{ista}=remblank(charray([1:3 5:7]));
        lab{ista} =remblank(charray([9:11 13:15]));
        IBAT(ista)  = fread(fid,1,'int');
        npin(ista)  = fread(fid,1,'int');
        NPINAV(ista)= fread(fid,1,'float');
        NHPIN(ista) = fread(fid,1,'int');
        
        S_AVE(ista) = fread(fid,1,'float');
        EAVE(ista)  = fread(fid,1,'float');
        ISEG(ista)  = fread(fid,1,'int');
        IROT(ista)  = fread(fid,1,'int');
        RPD(ista)   = fread(fid,1,'float');
        RKWF(ista)  = fread(fid,1,'float');
        WCM(ista)   = fread(fid,1,'float');
        
        NP=NPIN(iasm,ista);NP2=NP*NP;
        not_full=NP2~=MAXPIN;
       
        % Get assembly-wise data
        if nargout>3, % pin_data required
            for k = 1:KDFUEL
                iarray=fread(fid,3,'int');
                % unpack and unpck2 is done immediately
                x=iarray/10000;
                xr=round(x);
                PPIN(icount,k) = xr(1)/1000;
                LPPIN(icount,k) = (x(1)-xr(1))*100; % Location will be ii.jj
                PCHA(icount,k) = xr(2)/1000;
                LPCHA(icount,k) = (x(2)-xr(2))*100; % Location will be ii.jj
                PEXP(icount,k) = xr(3)/100;
                EXP(icount,k) = (x(3)-xr(3))*100;
                farray=fread(fid,4,'float');
                SRC(icount,k) = farray(1);
                RR1(icount,k) = farray(2);
                FLUX1(icount,k) = farray(3);
                FLUX2(icount,k) = farray(4);
            end
            % Move to the end of the assembly data block
            irec=irec+1;
            fseek(fid, MAXREC*irec, -1);
            
            % Get 2-D pin-wise data
            PINPOW2{ista} = reshape(fread(fid, NP2, 'float'),NP,NP);
            
            % Get 2-D exposure data (if present)
            if (MAXVAR >= 2)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                PINEXP2{ista} = reshape(fread(fid, NP2, 'float'),NP,NP);
            end
            
            % Get 2-D fluence data (if present)
            if (MAXVAR >= 3)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                PINFLU2{ista} = reshape(fread(fid, NP2, 'float'),NP,NP);
            end
        else           
            irec=irec+MAXVAR;
            fseek(fid,(irec+1)*MAXREC,-1);
        end
        % Get 3-D pin-wise data, pre-allocate
        for k = 1:KDFUEL
            irec=irec+1;
            if not_full, fseek(fid, MAXREC*irec, -1); end
            temp = reshape(fread(fid, NP2, 'float'), NP, NP);
            for i=1:Np,
                for j=1:Np,
                    pow3{i,j}(icount,k)=temp(i,j);
                end
            end
            % Get 3-D exposure data (if present)
            if (MAXVAR >= 2)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                temp = reshape(fread(fid, NP2, 'float'), NP, NP);
                for i=1:Np,
                    for j=1:Np,
                        exp3{i,j}(icount,k)=temp(i,j);
                    end
                end
            end
            % Get 3-D fluence data (if present)
            if (MAXVAR >= 3)
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                irec=irec+1;
                if not_full, fseek(fid, MAXREC*irec, -1); end
                temp = reshape(fread(fid, NP2, 'float'), NP, NP);
                for i=1:Np,
                    for j=1:Np,
                        exp3{i,j}(icount,k)=temp(i,j);
                    end
                end                
            end
        end
    end
end
    %}
fclose(fid);
if nargout>1,
    fuel_data.pinfile=pinfile;
    fuel_data.Asyknum=Asyknum;
    ipos=IIAS(Asyknum);ipos=ipos(:);
    jpos=JJAS(Asyknum);jpos=jpos(:);
    fuel_data.corpos=[ipos jpos];
    fuel_data.ISTA=ISTA;
    fuel_data.NPNASS=NPNASS;
    IIAS(isnan(IIAS))=[];
    JJAS(isnan(JJAS))=[];
    fuel_data.IIAS=IIAS;
    fuel_data.JJAS=JJAS;
    fuel_data.SERIAL=SERIAL;
    fuel_data.SERIAL1=SERIAL1;
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
    fuel_data.mminj=ij2mminj(IIAS,JJAS);
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

