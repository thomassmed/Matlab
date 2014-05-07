% function [tdata]=readcd(cdfilename,tnames,fuesegnr,crtyp,sgtyp)
%
% Purpose:
%   To read data from a Polca7 cell-data file.
%   Multiple tables can be read at once.
%
% Input:
%   cdfilename - Path to cd-file
%   tnames     - Cards (tablenames) to read from cd-file
%                (Single string or cell array of strings)
%   fuesegnr   - Requested fuel segment type number
%   crtyp      - Control rod type number, only needed if reading CR-tables
%   sgtyp      - Spacer grip type number, only needed if reading SG-tables
%
% Output:
%   Struct array with the following field:
%    group     - Main celldata group
%    table     - Name of requested table
%    tabletype - Type of table {'default','pinmap','df','miscpar'}
%    fuetyp    - Fuel type number
%    crtypnr   - Control rod type number
%    spatyp    - Spacer grid type number
%    title     - Title of table in cd-file
%    date      - Date when table was added/modified in cd-file
%    dep       - Depletion points
%    dens      - Momentaneous moderator density
%    hdens     - Historical moderator density
%    values    - Data values in requested table, size:
%                  Normal tables: [ndep x ndens x nhden  double]
%                  Pin maps     : {ndep x ndens x nhden  cell  }
%                  Misc param.  : { no of param.         cell  }
%  
function [tdata]=readcd(cdfilename,tnames,fuesegnr,crtyp,sgtyp)


% Call script with parameters and table names
cdtdata;

 
% Open the file
fid=fopen(cdfilename,'r');

% Read cd-file address array
intad=fread(fid,INTSIZ,'uint32');

% Do some sanity checks
if intad(100) ~= 91415
    error(['File: ' cdfilename ' is not a legal cd-file!']);
end
if intad(77) ~= CDVERS
    error('This version of readcd() cannot read this version of the cd-file');
end
if intad(80) == -1
    warning('Error flag in cd-file is set!');
end

nmaint=intad(78);

% Read mainta array
fseek(fid,4*(intad(MAINPO)-1),-1);
mainta=fread(fid,4*IMASIZ,'char');
mainta=char(reshape(mainta,8,IMASIZ/2))';

% Read adradr adress array
fseek(fid,4*(intad(ADRAPO)-1),-1);
adradr=fread(fid,IADSIZ,'uint32');

% Build main address table
nuofoc=zeros(1,NROFMT);
nuofow=zeros(1,NROFMT);
cdaddr=zeros(1,NCDADD);
adr=cell(1,nmaint);
for i=1:NROFMT
    n=INTRCD(i);
    for ii=1:nmaint
       if strcmp(mainta(ii,:),MAINTAB{i,1})
           cdaddr(n+nuofoc(i))=ii;
           nuofoc(i)=nuofoc(i)+1;
           
           fseek(fid,4*(adradr(ii)-1),-1);
           adr{ii}=reshape(fread(fid,2*NFTMAX,'uint32'),2,NFTMAX)';
           nuofow(i)=sum(adr{ii}(:,1)>0);
           
       end
    end
end


if ~iscell(tnames)
    tnames={tnames};
end

% Loop over all requested (sub)tables
tdata=struct([]);
for i=1:length(tnames)
    ispin=false;
    isdf=false;
    iscrt=false;
    issgt=false;
    ismisc=false;
    tabletype='default';
    
    % Find index of requested (sub)table
    nr=strmatch(tnames{i},TABLES(:,1));
    
    % Check if requesting a misc par. group
    if sum(strcmp(tnames{i},strtrim(MANMISC)))
        miscnr=find(strcmp(tnames{i},strtrim(MANMISC))>0);
        nr=strmatch('MISC',TABLES(:,1));
        nr=nr(miscnr);
        ismisc=true;
        tabletype='miscpar';
    end
    
    % Check if the requested (sub)table exists in the cd-file
    if isempty(nr)
       warning(['Table: ' tnames{i} ' not found in cd-file!']);
       continue;
    end
    
    % Find maintable corresponding to the given subtable
    intnr=IREFAD(nr);
    intnr1=INTRCD(intnr);
    ntab1=MAINTAB{intnr,2};
    nam=TABLES{nr,1};
    mannam=MAINTAB{intnr,1};
    subtnr=nr-sum(cell2mat(MAINTAB(1:intnr-1,2)));
    
    % Check table type
    if sum(strcmp(mannam,MANPIN))
        ispin=true;
        tabletype='pinmap';
    end 
    if sum(strcmp(mannam,MANDF))
        isdf=true;
        tabletype='df';
    end
    if sum(strcmp(mannam,MANCRT))
        if isempty(crtyp)
            error('No control rod type specified in input!');
        end
        intn=intnr1+crtyp-1;
        iscrt=true;
        
    elseif sum(strcmp(mannam,MANSGT))
        if isempty(sgtyp)
            error('No spacer grid type specified in input!');
        end
        intn=intnr1+sgtyp-1;
        issgt=true;
    else
        intn=intnr1;  
    end
    
    % Find table address in cd-file
    iad=cdaddr(intn);
    adrt=adr{iad}; 
    iad=adrt(fuesegnr,1);
    nor=adrt(fuesegnr,2);
    
    % Check if the requested fuel type exists in cd-file
    if iad<=0
        error(['Fuel segment type ' num2str(fuesegnr) ' not found in cd-file!']);
    end
    
    % Read requested tables
    fseek(fid,4*((iad-1)*NCDREC),-1);   
    
    nhead=fread(fid,XNHEADCD,'float32');
    event=fread(fid,XNEVENT,'float32');
    status=fread(fid,XNSTATUS,'float32');
    title=char(fread(fid,4*XNTITLE,'char')');
    nscale=fread(fid,XNSCALES,'float32');
    
    scale=fread(fid,nscale,'float32');
    
    nsym=fread(fid,1,'float32');
    ngridf=fread(fid,1,'float32');
    nval=fread(fid,1,'float32');
    mmpar=fread(fid,1,'float32');
    
    tabexe=fread(fid,6,'float32')';
    
    ne=fread(fid,1,'float32');
    nv=fread(fid,1,'float32');
    nc=fread(fid,1,'float32');
    
    % Start building output
    tdata(i).group=strtrim(mannam);
    tdata(i).table=strtrim(nam);
    tdata(i).tabletype=tabletype;
    tdata(i).fuetyp=fuesegnr;
    if iscrt
        tdata(i).crtyp=crtyp;
    else
        tdata(i).crtyp=[];
    end
    if issgt
        tdata(i).spatyp=sgtyp;
    else
        tdata(i).spatyp=[];
    end
    
    tdata(i).title=strtrim(title);
    tdata(i).date=tabexe;
    tdata(i).dep=fread(fid,ne,'float32');
    tdata(i).dens=fread(fid,nv,'float32');
    tdata(i).hdens=fread(fid,nc,'float32');
    
    if ~ispin
        nval=1;
    end
    subsiz=ne*nv*nc*nval;
    
    % Find starting address of data for requested subtable
    fseek(fid,4*(subtnr-1)*subsiz,0);
    
    if ispin % Pin maps
        values=cell(1,ne*nv*nc);
        for ii=1:(ne*nv*nc)
            if nsym==1
                gridval=fread(fid,nval,'float32');
                gridval=reshape(gridval,ngridf,ngridf);
            elseif nsym==2
                gridval=zeros(ngridf);
                ind=reshape([1:ngridf^2],ngridf,ngridf);
                lind=tril(ind);
                gridval(lind(:)>0)=fread(fid,nval,'float32');
                gridval=gridval+triu(gridval',1);
            else
                error('Unsupported pin-map symmetry!');
            end
            values{ii}=gridval;
        end
        tdata(i).values=reshape(values,ne,nv,nc);
        
    elseif ismisc % Misc parameters
        values=cell(1,mmpar);
        for ii=1:mmpar
           values{ii}=fread(fid,1,'float32');
        end
        tdata(i).values=values;
        
    else % Normal tables and discont. factors
        values=fread(fid,subsiz,'float32');
        tdata(i).values=reshape(values,ne,nv,nc);
    end
    
end

fclose(fid);
