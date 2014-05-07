function [outinfo,TEXT]=AnalyzeOut(TEXT)
%% if TEXT is a filename rather than the scanned text: 
if ~iscell(TEXT),
    outfile=TEXT;
    outinfo.fileinfo.type = identfile(outfile);
    outinfo.fileinfo.name=file('tail',outfile);
    outinfo.fileinfo.fullname=file('normalize',outfile);
    fid=fopen(outfile,'r');
    TEXT = textscan(fid,'%s','delimiter','\n');
    TEXT = TEXT{1};
    fclose(fid);
end
%% Find IAFULL, IRMX, KD, KMAX
iaf=find(~cellfun(@isempty,regexpi(TEXT,'IAFULL')));
rad=TEXT{iaf(1)};
ifind=strfind(rad,'IAFULL');
iend=min(ifind+9,length(rad));
iafull=sscanf(rad(ifind+6:iend),'%i');
rad=TEXT{iaf(1)+1};
ifind=strfind(rad,'IRMX');
irmx=sscanf(rad(ifind+4:ifind+7),'%i');
rad=TEXT{iaf(1)+4};
ifind=strfind(rad,'KD');
kd=sscanf(rad(ifind+2:ifind+5),'%i');
rad=TEXT{iaf(1)+5};
ifind=strfind(rad,'IHAVE');
ihave=sscanf(rad(ifind+5:ifind+8),'%i');
rad=TEXT{iaf(1)+6};
ifind=strfind(rad,'IF2X2');
iend=min(ifind+8,length(rad));
if2x2=sscanf(rad(ifind+5:iend),'%i');
rad=TEXT{iaf(1)+7};
ifind=strfind(rad,'NREF');
iend=min(ifind+7,length(rad));
nref=sscanf(rad(ifind+4:iend),'%i');
kmax=kd-2*nref;
ibwr=findrow(TEXT,'^Reading BWR Restart file');
if isempty(ibwr),
    lwr='PWR';
else
    lwr='BWR';
end
corsym='ROT';
isymrad=findrow(TEXT,'Core Symmetry =');
if ~isempty(isymrad),
    iloc=strfind(TEXT{isymrad(1)},'Core Symmetry');
    corsym=TEXT{isymrad(1)}(iloc+16:iloc+18);
end
%%
ifuelab=strcmp('FUE.LAB',TEXT);
ifueser=strcmp('FUE.SER',TEXT);
ifuetyp=strcmp('FUE.TYP',TEXT);
fue=[unique(TEXT(ifuelab));unique(TEXT(ifueser));unique(TEXT(ifuetyp))];
%%
iprista= ~cellfun(@isempty,regexp(TEXT,'^PRI.STA'));
prista=strtrim(unique(TEXT(iprista)));
prista=prista(~cellfun(@isempty,regexp(prista,'-')));
ibort= ~cellfun(@isempty,regexp(prista,'PRI.STA - State Point Edits'));
prista(ibort)=[];
%% 
iaprista= ~cellfun(@isempty,regexp(TEXT,'^A-PRI.STA'));
aprista=strtrim(unique(TEXT(iaprista)));
aprista=aprista(~cellfun(@isempty,regexp(aprista,'-')));
ibort= ~cellfun(@isempty,regexp(aprista,'A-PRI.STA - State Point Edits'));
aprista(ibort)=[];
%%
ipriiso= ~cellfun(@isempty,regexp(TEXT,'^PRI.ISO'));
priiso=strtrim(unique(TEXT(ipriiso)));
priiso=priiso(~cellfun(@isempty,regexp(priiso,'-')));
ibort= ~cellfun(@isempty,regexp(priiso,'PRI.ISO - State Point Edits'));
priiso(ibort)=[];
%% 
ii= ~cellfun(@isempty,regexp(TEXT,'^TLM.EDT'));
tlmedt=strtrim(unique(TEXT(ii)));
tlmedt=tlmedt(~cellfun(@isempty,regexp(tlmedt,'-')));
ibort= ~cellfun(@isempty,regexp(tlmedt,' ON '));
tlmedt(ibort)=[];
ibort= ~cellfun(@isempty,regexp(tlmedt,'Thermal Limits Module Summary'));
tlmedt(ibort)=[];
%%
ii= ~cellfun(@isempty,regexp(TEXT,'^PIN.EDT'));
pinedt=strtrim(unique(TEXT(ii)));
pinedt=pinedt(~cellfun(@isempty,regexp(pinedt,'-')));
ibort= ~cellfun(@isempty,regexp(pinedt,' ON '));
pinedt(ibort)=[];
ibort= ~cellfun(@isempty,regexp(pinedt,'PIN.EDT 2PLO')); %TODO fix this one too
pinedt(ibort)=[];
%%
iprimac= ~cellfun(@isempty,regexp(TEXT,'^PRI.MAC'));
primac=strtrim(unique(TEXT(iprimac)));
primac=primac(~cellfun(@isempty,regexp(primac,'-')));
ikeep= ~cellfun(@isempty,regexp(primac,'for core plane K =   1'));
primac=primac(ikeep);
%%
icrdpos= ~cellfun(@isempty,regexp(TEXT,'^CRD.POS'));
crdpos=strtrim(unique(TEXT(icrdpos)));
%% Exposure points
Findstr = 'Summary File Name';
idep = find(strncmpi(Findstr,TEXT,17));
iend = find(strncmpi('Report on CPU Time in',TEXT,21));
if isempty(iend)
    xpotext = TEXT(idep(1):end);
else
    xpotext = TEXT(idep(1):iend-1);
end

xpotext(cellfun(@isempty,xpotext)) = [];
xpotext(strncmpi(Findstr,xpotext,17)) = [];

xpotext(strncmpi('1S I M U L A T E',xpotext,16)) = [];
xpotext(strncmpi('TIT:',xpotext,4)) = [];
xpotext(strncmpi('Case',xpotext,4)) = [];
xpotext(strncmpi('Step',xpotext,4)) = [];
xpotext(strncmpi('B W R',xpotext,5)) = [];
xpotext(strncmpi('S u m m a r y',xpotext,13)) = [];
convdat = cellfun(@(x) sscanf(x,'%g',3) ,xpotext,'uniformoutput',0);
convdat(cellfun('isempty',convdat))=[];
Xpo = cellfun(@(x) x(3),convdat);
Xpo=unique(Xpo(:)');



%% figure out mminj
if ~isempty(prista)
    imap=find(strncmp(prista{1},TEXT,length(prista{1})));
    ok=1;
elseif ~isempty(pinedt)
    imap=find(strncmp(pinedt{1},TEXT,length(pinedt{1})));
    ok=1;
    imap=imap+1;
else
    Warning('cannot find Map to figure out mminj');
    ok=0;
end
if ok,
    lefthalf=false;
    if length(imap)>1,
        if min(diff(imap))<100,
            lefthalf=true;
        else
            lefthalf=false;
        end
        imap=imap(1);
    end
    rad=TEXT{imap+1};
    rad=strrep(rad,'**','  ');
    cols=sscanf(rad,'%i');
    jstart=min(cols);
    mminj=zeros(iafull,1);
    for i=1:iafull,
        rad=TEXT{imap+1+i};
        if i==1, istart=sscanf(rad(1:2),'%i');end
        rad(end-1:end)=[];
        rowval=sscanf(rad,'%g');
        rowval(1)=[];%Remove the row number
        if lefthalf,
            mminj(i)=iafull/2-length(rowval)+1;
        else
            mminj(i)=(iafull-length(rowval))/2+1;
        end
    end
else
    mminj=zeros(iafull);
end
%%
kan=sum(iafull-2*(mminj-1));
[knum,sym]=Sum2knum(mminj,iafull,istart,jstart);
core.mminj=mminj;
core.iafull=iafull;
core.kmax=kmax;
core.istart=istart;
core.knum=knum;
core.kan=kan;
core.sym=sym;
if strcmp(corsym,'ROT'), isymc=1;else isymc=2; end
core.isymc=isymc;
core.if2x2=if2x2;
if core.if2x2==2,
    mminj2x2=zeros(2*iafull,1);
    mminj2x2(1:2:end)=2*mminj-1;
    mminj2x2(2:2:end)=2*mminj-1;
    core.mminj2x2=mminj2x2;
    core.knum2x2=crnum2knum(1:kan,mminj2x2);
end
core.lwr=lwr;
core.iwant=ihave;
core.irmx=irmx;
core.crmminj=mminj2crmminj(mminj,irmx);
core.NoteOnCrmmminj='Generated from mminj2crmminj(mminj,irmx), Not good enough for Cooper';
outinfo.core=core;
outinfo.distlist=[prista;aprista;priiso;tlmedt;pinedt;primac];%;crdpos];
outinfo.misclist=fue;
outinfo.prista=prista;
outinfo.aprista=aprista;
outinfo.priiso=priiso;
outinfo.tlmedt=tlmedt;
outinfo.pinedt=pinedt;
outinfo.primac=primac;
outinfo.Xpo = Xpo;

%% figure out the date
datestr = TEXT{1};
month = char(sscanf(datestr,'%*s%s%*s%*s%*s%*s'));
day = char(sscanf(datestr,'%*s%*s%s%*s%*s%*s'));
year = char(sscanf(datestr,'%*s%*s%*s%*s%*s%s'));
time = char(sscanf(datestr,'%*s%*s%*s%s%*s%*s'));
if isempty(str2double(month))|isnan(str2double(month)),
%     ii=findrow(TEXT,'^Run: RUN NAME');
    ii=findrow(TEXT,'Run Time');
    daterow=TEXT{ii(1)};
    itime=strfind(daterow,'Run Time:');
    time=daterow(itime+10:itime+17);
    idate=strfind(daterow,'Date:');
    outinfo.fileinfo.date=daterow(idate+8:idate+15);
else 
    tempdat = datevec([month day year]);
    month = tempdat(2);
    outinfo.fileinfo.date = [year(3:4) '/' num2str(month) '/' day];
end
outinfo.fileinfo.time = time;
ic=strncmpi('average axial distributions for state point variables',TEXT,53);
ic=find(ic)+50;
irpfdl=find(strncmp('PRI.STA 2RPF',outinfo.distlist,12));
ic=[1;ic];
if isempty(irpfdl)
    newcase_row=ic;
else
    irpf=findrow(TEXT,['^',outinfo.distlist{irpfdl}]);
    idifrpf=diff(irpf);
    if any(idifrpf<100), irpf=irpf(1:2:end);end
    newcase_row=zeros(size(irpf))';
    for i=1:length(irpf),
        indx= find(irpf(i)>ic,1,'last');
        newcase_row(i)=ic(indx);
    end
    newcase_row(1)=1;
    newcase_row=[newcase_row ic(end)];
end
outinfo.file.newcase_row=newcase_row;
if nargout==1,
    clear TEXT
end
fid=fopen(outinfo.fileinfo.fullname,'r');
fil=fread(fid);
fclose(fid);
irad=find(fil==10);
newcase=irad(newcase_row);
newcase=[newcase;length(fil)];
outinfo.file.newcase_byte=newcase;