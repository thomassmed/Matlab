function dists=ReadSum(suminfo,cards,stpt)
% ReadSum - Reads from summary file
% 
%  [cardvalue1,cardvalue2,...]=ReadSum(sumfile,card1,card2,...)
%  or alternative
%  suminfo=ReadSum(sumfile)
%  [cardvalue1,cardvalue2,...]=ReadSum(suminfo,card1,card2,...)
%
% Input
%   sumfile - name on summary file
%   card1   - first card
%   card2   - second card
%   ... etc
% Output
%   cardvalue1 - value for first card
%   cardvalue2 - value for second card
%    ... etc
%   
% Alternative:
% Input (1st call)
%  sumfile - name on summary file
% Output 1st call
%   suminfo - File metadata
% Input 2nd call
%   suminfo - File metadata
%   card1   - first card
%   card2   - second card
%   ... etc
% Example:
%   flc=ReadSum('sim-tip.sum','FLC 2D MAP');
%   [fuelab,fueser,crdgrp,crdpos]=ReadSum('sim-tip.sum','FUE.LAB','FUE.SER','CRD.GRP','CRD.POS'); 
%   Alternative:
%    1st call is to get the metadata
%    suminfo=ReadSum('sim-tip.sum');
%    2nd call is to pull out the variables
%    flc=ReadSum(suminfo,'FLC 2D MAP');
%    or
%   flc=ReadSum(suminfo,'FLC'); % If 'FLC' is unique in the list of available cards
%   [fuelab,fueser,crdgrp,crdpos]=ReadSum(suminfo,'FUE.LAB','FUE.SER','CRD.GRP','CRD.POS');
%   cards=ReadSum
%   with no input arguments generates a listing of implemented cards
%
% See also AnalyzeSum, ReadOut, ReadTip
if nargin==0,
    implemented_cards={'FUE.LAB','FUE.SER','PRI.ISO','PIN.SUM 3PIN','PIN.SUM 3XPO',...
        'CRD.GRP','CRD.POS','DET.LOC','FUE.BAT','FUE.ROT','FUE.TYP','XXX 2D MAP'};
        
    fprintf('Implemented cards are:\n');
    dists{1}=implemented_cards;
    return
end

% TODO: include id on unique keyword, e.g. flc=ReadSum(suminfo,'FLC')';

ReadSumFile=false;
if ischar(suminfo),
    sumfile=suminfo;
    [suminfo,TEXT]=AnalyzeSum(sumfile);
    ReadSumFile=true;
    if nargin==1, dists=suminfo;return;end
end

%% Figure out some basics about the core (if core is not already given as input)
if length(cards)==1 && strcmpi(char(cards),'power'),
    cards={'RPF 2D MAP'};
end

%% Read the summary and find out how many cases there are on file

%% get iteration variables
stpt=ParseStpt(stpt,suminfo);
[offset,Nrow]=GetOffset(stpt,suminfo);
stpt=stpt-min(stpt)+1;
if ReadSumFile,
    TEXT=TEXT(Nrow(1):Nrow(2));
else
    TEXT=ReadAscii(suminfo.fileinfo.fullname,offset,diff(Nrow)+1);
end

core=suminfo.core;
cards=cellstr(cards);
cardlist=[suminfo.distlist;suminfo.misclist];
icards=cellstrmatch(cards,cardlist,'find');
icards = icards{1};
for i=1:length(cards),
    if isempty(icards(i)),
        fprintf(1,'Available cards: \n');
        disp(cardlist);
        error(['Card ''',cards{i},''' not found']);
    elseif length(icards(i))>1,
        disp(cardlist);
        erstr=sprintf('Card ambiguous: ''%s'' ',...
           cards{i});
        error(erstr);
    else
        cardarg{i}=cardlist{icards(i)};
    end
end

%% Read the label and serial
% TODO Put the loop over cases in PickUpText
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.LAB')));
if ~isempty(ifind)
    ilab=find(~cellfun(@isempty,regexp(TEXT,'^FUE.LAB')));
    if length(ilab)>1,
        label=cell(1,length(ilab));
        for i=1:length(ilab),
            label{i}=PickUpText(core,ilab(i),TEXT);
        end
    else
        label=PickUpText(core,ilab,TEXT);
    end
    dists{ifind}=label;
end
%%
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.SER')));
if ~isempty(ifind)
    iser=find(~cellfun('isempty',regexp(TEXT,'^FUE.SER')));
    if length(iser)>1,
        ser=cell(1,length(iser));
        for i=1:length(iser),
            ser{i}=PickUpText(core,iser(i),TEXT);
        end
    else
        ser=PickUpText(core,iser,TEXT);
    end
    dists{ifind}=ser;
end
%% Read the Istopics
ifind=find(~cellfun(@isempty,strfind(cardarg,'PRI.ISO')));
if ~isempty(ifind)
    for i=1:length(ifind),
        dists{ifind(i)}=PickUpMap(core,TEXT,cardarg{ifind(i)},7,0);
    end
end
%% Pick up 3Pin
ifind=find(~cellfun(@isempty,strfind(cardarg,'PIN.SUM')));
if ~isempty(ifind)
    for i=1:length(ifind),
        dists{ifind(i)}=PickUpPinSum3(suminfo,TEXT,cardarg{ifind(i)},stpt);
        dists{ifind(i)}=PolishOutArg(dists{ifind(i)});
    end
end
% Skip reading Pin2, can be calculated by Pin2{i}=mean(Pin3{i});
%% Pick up CRD.GRP
ifind=find(~cellfun(@isempty,strfind(cardarg,'CRD.GRP')));
if ~isempty(ifind),
    dists{ifind}=PickUpFull(TEXT,'CRD.GRP',core.irmx,core.irmx,stpt);
    dists{ifind}=PolishOutArg(dists{ifind},core.crmminj);
end
%% Pick up CRD.POS
ifind=find(~cellfun(@isempty,strfind(cardarg,'CRD.POS')));
if ~isempty(ifind),
    temp=PickUpFull(TEXT,'CRD.POS',core.irmx,core.irmx,stpt);
    for i=stpt,
        itemp=find(stpt(i)>=suminfo.fileinfo.adr.crdexp,1,'last');
        if isnumeric(temp),
            dists{ifind}=cor2vec(temp,suminfo.core.crmminj);
        else
            dists{ifind}{i}=cor2vec(temp{itemp},suminfo.core.crmminj);
        end
    end
end
%% Pick up DET.LOC
ifind=find(~cellfun(@isempty,strfind(cardarg,'DET.LOC')));
if ~isempty(ifind),
    dists{ifind}=PickUpFull(TEXT,'DET.LOC',core.ilmx,core.ilmx,stpt);
    dists{ifind}=PolishOutArg(dists{ifind});
end
%% Pick up FUE.TYP
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.TYP')));
if ~isempty(ifind),
    if core.if2x2==2,
        dists{ifind}=PickUpFull(TEXT,'FUE.TYP',core.iafull*2+2*core.nref,core.iafull*2+2*core.nref+2,stpt);
        dists{ifind}=PolishOutArg(dists{ifind},core.mminj2x2,[3 1 1 1]);
    else   
        dists{ifind}=PickUpFull(TEXT,'FUE.TYP',core.iafull+2*core.nref,core.iafull+2*core.nref+2,stpt);
        dists{ifind}=PolishOutArg(dists{ifind},core.mminj,[3 1 1 1]);
    end
end
%% Pick up FUE.BAT
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.BAT')));
if ~isempty(ifind),
    dists{ifind}=PickUpFull(TEXT,'FUE.BAT',core.iafull,core.iafull+2,stpt);
    dists{ifind}=PolishOutArg(dists{ifind},core.mminj,[2 0 0 0]);
end
%% Pick up FUE.ROT
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.ROT')));
if ~isempty(ifind),
    dists{ifind}=PickUpFull(TEXT,'FUE.ROT',core.iafull,core.iafull+2,stpt);
    dists{ifind}=PolishOutArg(dists{ifind},core.mminj,[2 0 0 0]);
end
%% Pick up FLC
ifind=find(~cellfun(@isempty,strfind(cardarg,'2D MAP')));
if ~isempty(ifind),
    for i=1:length(ifind),
        if strncmpi('EXP',cardarg{ifind(i)},3),
            dists{ifind(i)}=PickUpExpMap(suminfo.core,TEXT,cardarg{ifind(i)},6,1,stpt);
        else
            dists{ifind(i)}=PickUpMap(suminfo.core,TEXT,cardarg{ifind(i)},6,1,stpt);
        end
    end
    if length(stpt)==1,
        for i=1:length(ifind),
            dists{ifind(i)}=dists{ifind(i)}{1};
        end
    end
end

if iscell(dists)&&length(cardarg)==1&&length(stpt)>1,
    if iscell(dists{1})
        if isnumeric(dists{1}{1})
            dists=dists{1};
        end
    end
end
%% Some help functions
function vec=Pickup(TEXT,index,offset,strlen,Ncol,istart,iafull,N)
vec=nan(1,N);
icount=0;
ivec=0;
for i=istart:iafull,
    icount=icount+1;
    row=TEXT{index+offset+icount};
    lr=length(row);
    start=min(regexp(row,'\W'));
    stop=start-1+strlen*Ncol;
    stop=min(stop,lr);
    row=row(start:stop);
    Row=sscanf(row,'%g');
    vec(ivec+1:ivec+length(Row))=Row';
    ivec=ivec+length(Row);
end

function vec=PickUpMap(core,TEXT,card,strlen,headerlines,stpts)
if nargin<4, strlen=6;end
if nargin<5, headerlines=1;end
iafull=core.iafull;
istart=core.istart;
jstart=core.jstart;
mminj=core.mminj;
irow=find(~cellfun(@isempty,regexp(TEXT,['^',card])));
if headerlines>0,
   dims=sscanf(TEXT{irow(1)+1},'%g');
   Npages=dims(1);
   Ncol=dims(2);
   istart=dims(3);
   scale=dims(7);
else
   scale=1;
   Npages=1;
   if (iafull-jstart)>16, Npages=2;end
   Ncol=iafull-jstart+1;
end
N=size(core.knum,1);
tempvec=nan(1,N);
if nargin<6
    Ncases = length(irow);
    Ncvec = 1:Ncases;
else 
    Ncases = length(stpts);
    Ncvec = stpts;
end
vec=cell(1,Ncases);
if Npages>1,
    [right,left]=knumhalf(mminj);
    left=sort(left);
    tempvec1=nan(1,N/2);
    tempvec2=nan(1,N/2);
end
scale=ones(Ncases,1);
for Nc=1:Ncases,
    if headerlines>0,
        dims=sscanf(TEXT{irow(Ncvec(Nc))+1},'%g');
        scale(Nc)=dims(7);
    end
    if Npages==1,
        tempvec=Pickup(TEXT,irow(Ncvec(Nc)),headerlines+1,strlen,Ncol,istart,iafull,N);
    else
        tempvec1=Pickup(TEXT,irow(Ncvec(Nc)),headerlines+1,strlen,Ncol,istart,iafull,N/2);
        offset=headerlines+iafull+2;
        tempvec2=Pickup(TEXT,irow(Ncvec(Nc)),offset,strlen,Ncol,istart,iafull,N/2);
        tempvec(left)=tempvec1;
        tempvec(right)=tempvec2;
    end
    vec{Nc}=scale(Nc)*tempvec;
end

function vec=PickUpExpMap(core,TEXT,card,strlen,headerlines,stpts)
% The exposure map os awkward, thus a special function
% Main problem: two bundles with 41.234 and 42.456 and exposure are printed
% as:  41.23442.456 (No white space in between).
if nargin<4, strlen=6;end
if nargin<5, headerlines=1;end
iafull=core.iafull;
istart=core.istart;
jstart=core.jstart;
mminj=core.mminj;
irow=find(~cellfun(@isempty,regexp(TEXT,['^',card])));
if headerlines>0,
   dims=sscanf(TEXT{irow(1)+1},'%g');
   Npages=dims(1);
   Ncol=dims(2);
   istart=dims(3);
else
   Npages=1;
   if (iafull-jstart)>16, Npages=2;end
   Ncol=iafull-jstart+1;
end
N=size(core.knum,1);
tempvec=nan(1,N);
if nargin<6
    Ncases = length(irow);
    Ncvec = 1:Ncases;
else 
    Ncases = length(stpts);
    Ncvec = stpts;
end
vec=cell(1,Ncases);
if Npages>1,
    [right,left]=knumhalf(mminj);
    left=sort(left);
    tempvec1=nan(1,N/2);
    tempvec2=nan(1,N/2);
end
scale=ones(Ncases,1);
for Nc=1:Ncases,    
    if headerlines>0, 
        dims=sscanf(TEXT{irow(Ncvec(Nc))+1},'%g');
        scale(Nc)=dims(7);
    end
    if Npages==1,
        TXT=TEXT(irow(Ncvec(Nc))+headerlines+2:irow(Ncvec(Nc))+iafull+headerlines+2);
        TXT=insertSpaces(TXT);
        tempvec=Pickup(TXT,0,0,strlen+1,Ncol,istart,iafull,N);
    else
        TXT=TEXT(irow(Ncvec(Nc))+headerlines+2:irow(Ncvec(Nc))+2*iafull+headerlines+3);
        TXT=insertSpaces(TXT);
        tempvec1=Pickup(TXT,0,0,strlen+1,Ncol,istart,iafull,N/2);
        offset=iafull+1;
        tempvec2=Pickup(TXT,0,offset,strlen+1,Ncol,istart,iafull,N/2);
        tempvec(left)=tempvec1;
        tempvec(right)=tempvec2;
    end
    vec{Nc}=scale(Nc)*tempvec;
end


function Pin3=PickUpPinSum3(coreinfo,TEXT,card,stpt)
strlen=7;
offset=1;
core=coreinfo.core;

if ~isempty(strfind(card,'NODAL 2D'))&&core.if2x2==2&&strcmp(core.lwr,'PWR'),
    iafull=core.iafull*2;
    istart=core.istart;
    jstart=core.jstart;
    kmax=core.kmax;
    N=size(core.knum2x2,1);
    mminj=core.mminj2x2;
else
    iafull=core.iafull;
    istart=core.istart;
    jstart=core.jstart;
    kmax=core.kmax;
    N=size(core.knum,1);
    mminj=core.mminj;
    Ncol=iafull+1-jstart;
end

    
card=strrep(card,'(','\(');
card=strrep(card,')','\)');
ipin=find(~cellfun(@isempty,regexp(TEXT,['^',card])));

if ~isempty(strfind(card,'2D')),
    kmax=1;
end

Ncase=length(ipin)/kmax;

read_rhs=false;
if iafull>17, 
    read_rhs=true;
    Ncol=iafull/2;
end
Pin3=cell(1,Ncase);
if nargin<4,
    Cases=1:Ncase;
else
    Cases=stpt;
end
coun=0;
if read_rhs,
    N2=N/2;
else
    N2=N;
end
if ~isempty(ipin)
    for i=Cases,
        coun=coun+1;
        Pin3{coun}=nan(kmax,N);
        for k=1:kmax,
            indx=ipin(k+(i-1)*kmax)+1;
            renorm=sscanf(TEXT{indx}(10:21),'%g');
            Pin3{coun}(k,1:N2)=renorm*Pickup(TEXT,indx,offset,strlen,Ncol,istart,iafull,N2);
            if read_rhs
                indx=indx+3+iafull;
                Pin3{coun}(k,N2+1:N)=renorm*Pickup(TEXT,indx,offset,strlen,Ncol,istart,iafull,N2);
            end
        end
    end
end

if read_rhs,
    [right,left]=knumhalf(mminj);
    left=left(end:-1:1);
    renum=[left(:);right(:)];
    for i=Cases,
        Pin3{i}(renum)=Pin3{i};
    end 
end

    


function TXT=insertSpaces(TXT)
for i=1:length(TXT),  %Insert the missing spaces
    temp=TXT{i};
    idot=strfind(temp,'.');
    for i1=length(idot):-1:1,
        temp=[temp(1:idot(i1)-3),' ',temp(idot(i1)-2:end)];
    end
    TXT{i}=temp;
end

function carddata=PickUpFixedCards(TEXT,card,nrows)
isum=find(~cellfun(@isempty,regexp(TEXT,card)));
Ncase=length(isum);
carddata=cell(1,Ncase);
for i=1:Ncase, %Just store the summaries as a cell array then we can pull out whatever we want
    carddata{i}=TEXT(isum(i):isum(i)+nrows-1);
end

function outarg=PolishOutArg(outarg,mminj,remov)
if nargin<2, mminj=[];end
if nargin<3, remov=[0 0 0 0];end
iremove=[];
if isnumeric(outarg), 
    temp=outarg;
    clear outarg;
    outarg{1}=temp;
end
for i=1:length(outarg)
    if  isempty(outarg{i})
        iremove=[iremove i];
    else
        if remov(1),outarg{i}(:,1:remov(1))=[];end
        if remov(2),outarg{i}(:,end-remov(2)+1:end)=[];end
        if remov(3),outarg{i}(1:remov(3),:)=[];end
        if remov(4),outarg{i}(end-remov(4)+1,:)=[];end
        if ~isempty(mminj),
            outarg{i}=cor2vec(outarg{i},mminj);
        end
    end
end
outarg(iremove)=[];
if length(outarg)==1&&iscell(outarg),
    outarg=outarg{1};
end


