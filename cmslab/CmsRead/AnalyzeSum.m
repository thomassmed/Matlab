function [suminfo,TEXT]=AnalyzeSum(sumfile)
%% if TEXT is a filename rather than the scanned text:
if ~iscell(sumfile),
    fid=fopen(sumfile,'r');
    TEXT = textscan(fid,'%s','delimiter','\n');
    TEXT = TEXT{1};
    fclose(fid);
else
    TEXT=sumfile;
end
%%
% TODO: Allow for different data for different cases
lwr=TEXT{5}(end-2:end);
t6=sscanf(TEXT{6},'%g');
t7=sscanf(TEXT{7},'%g');
ida=t6(6); % Number of assemblies in the i-direction for the calculated problem, 
           % see S3 manual 'FILES' page 25-8
jda=t6(7);
kmax=t6(8);
iafull=t7(1);
irmx=t7(2);
ilmx=t7(3);
ioffset=t7(4);
iwant=t7(5);
if2x2=t7(6);
nref=t7(7);
nics=t7(8);
symc=t7(9);
%%
TEXT=ReadAscii(sumfile);
iest=findrow(TEXT,'^END STEP');
fid=fopen(sumfile,'r');fil=fread(fid);fclose(fid);
irad=find(fil==10);
newcase=irad(iest);
newcase=[0;newcase;length(fil)];
suminfo.fileinfo.type='sum';
suminfo.fileinfo.fullname=file('normalize', sumfile);
suminfo.fileinfo.name=file('tail',suminfo.fileinfo.fullname);
% get dates
datepos = strfind(TEXT,'CASE    1');
datestr = TEXT{~cellfun(@isempty,datepos)};
suminfo.fileinfo.date = char(sscanf(datestr,'%*s %*d %s')');
suminfo.fileinfo.time = char(sscanf(datestr,'%*s %*d %*s %s')');
suminfo.fileinfo.simver = char(sscanf(datestr,'%*s%*d%*s%*s%*s%*s %s')');
suminfo.file.newcase_byte=newcase;
suminfo.file.newcase_row=[0;iest];
[suminfo.misclist,suminfo.distlist,suminfo.fileinfo.adr]=getcards(TEXT);
suminfo.cards=[suminfo.misclist;suminfo.distlist];
%%
icrd=find(~cellfun(@isempty,regexp(TEXT,'^CRD.DAT')));
crdnum=sscanf(TEXT{icrd(1)+1},'%g');
crmax=crdnum(1);
%dzstep=crdnum(2);
%%
ilab=find(~cellfun(@isempty,regexp(TEXT,'^FUE.LAB')));
mminj=nan(iafull,1);
for i=1:iafull
    row=TEXT{ilab(1)+i}(6:end);
    mminj(i)=ceil(find(row>32,1,'first')/7);
end

kan=sum(iafull-2*(mminj-1)); %no of channels
%%
istart=iafull-ida+1;
jstart=iafull-jda+1;
[knum,sym]=Sum2knum(mminj,iafull,istart,jstart);
%% Package core variables for future use
core.mminj=mminj;
core.iafull=iafull;
core.kmax=kmax;
core.istart=istart;
core.jstart=jstart;
core.knum=knum;
core.kan=kan;
core.symc=symc;
core.iwant=iwant;
core.sym=sym;
core.if2x2=if2x2;
core.crmax=crmax;
if if2x2==2,
    core.crmminj=mminj;
    core.mminj2x2=zeros(length(mminj)*2,1);
    core.mminj2x2(1:2:end)=2*mminj-1;
    core.mminj2x2(2:2:end)=2*mminj-1;
    if strcmp(sym,'SE'), istart=iafull+1;jstart=iafull+1;end
    if strcmp(sym,'E'), jstart=iafull+1;end
    if strcmp(sym,'S'), istart=iafull+1;end
    core.knum2x2=Sum2knum(core.mminj2x2,iafull*2,istart,jstart);
else
    core.crmminj=mminj2crmminj(mminj,irmx);
    core.NoteOnCrmmminj='Generated from mminj2crmminj(mminj,irmx), Not good enough for Cooper';
end
core.irmx=irmx;
core.ilmx=ilmx;
core.nref=nref;
core.ilmx=ilmx;
core.ioffset=ioffset;
core.nics=nics;
core.lwr=lwr;
suminfo.core=core;
Sum=PickUpFixedCards(TEXT,'^SUMMARY',13);
suminfo.sum=Sum;
xpo=zeros(1,length(Sum));
for i=1:length(Sum),
    temp=sscanf(Sum{i}{2},'%g');
    xpo(i)=temp(3);
end
suminfo.Xporaw=xpo;
isum=findrow(TEXT,'^SUMMARY');
irpf=findrow(TEXT,'^RPF 2D MAP');
xporeal=zeros(1,length(irpf));xpoindex=xporeal;
for i=1:length(irpf)
    xpoindex(i)=find(isum-irpf(i)<0&isum-irpf(i)>-100);
    xporeal(i)=xpo(xpoindex(i));
end
suminfo.Xpo=xporeal;
bwrhyd=PickUpFixedCards(TEXT,'^BWR HYDRAULICS',9);
if ~isempty(bwrhyd), suminfo.bwrhyd=bwrhyd;end
bwrheat=PickUpFixedCards(TEXT,'^BWR HEAT BALANCE',5);
if ~isempty(bwrheat), suminfo.bwrheat=bwrheat;end
if ~isempty(find(~cellfun(@isempty,strfind(suminfo.distlist,'FUE.SER')), 1))
    iser=find(~cellfun('isempty',regexp(TEXT,'^FUE.SER')));
    if length(iser)>1,
        ser=cell(1,length(iser));
        for i=1:length(iser),
            ser{i}=PickUpText(core,iser(i),TEXT);
        end
    else
        ser=PickUpText(core,iser,TEXT);
    end
    
    suminfo.serial=ser;
end


function [cards,distlist,adr]=getcards(TEXT)

map2d=strtrim(unique(TEXT(~cellfun(@isempty,regexp(TEXT,'^[A-Z][A-Z][A-Z]\W2D MAP')))));

pinsum=strtrim(unique(TEXT(~cellfun(@isempty,regexp(TEXT,'^PIN.SUM\W')))));

priso=strtrim(unique(TEXT(~cellfun(@isempty,regexp(TEXT,'^PRI.ISO\W')))));

cards={'FUE.LAB';'FUE.SER';'CRD.GRP';'DET.LOC';'FUE.BAT';'FUE.ROT';'FUE.TYP';};
distlist=[map2d;pinsum;priso;{'CRD.POS'}];
newcase=findrow(TEXT,'^END STEP')+1;
newcase=newcase(:);
newcase=[1;newcase];
icrd=findrow(TEXT,'^CRD.POS');
crdexp=icrd;
for i=1:length(icrd)
    crdexp(i)=find(icrd(i)>newcase,1,'last');
end
adr.newcase=newcase;
adr.icrd=icrd;
adr.crdexp=crdexp;

function carddata=PickUpFixedCards(TEXT,card,nrows)
isum=find(~cellfun(@isempty,regexp(TEXT,card)));
Ncase=length(isum);
carddata=cell(1,Ncase);
for i=1:Ncase, %Just store the summaries as a cell array then we can pull out whatever we want
    carddata{i}=TEXT(isum(i):isum(i)+nrows-1);
end
