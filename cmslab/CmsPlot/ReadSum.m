function varargout=ReadSum(sumfile,varargin)
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
    varargout{1}=implemented_cards;
    return
end

% TODO: include id on unique keyword, e.g. flc=ReadSum(suminfo,'FLC')';

getcore=true;
if isstruct(sumfile),
    suminfo=sumfile;
    sumfile=suminfo.fileinfo.fullname;
    getcore=false;
end
TEXT=ReadAscii(sumfile);
%% Figure out some basics about the core (if core is not already given as input)
if  getcore
    core=AnalyzeSum(TEXT);
    suminfo.core=core;
    suminfo.fileinfo.type='sum';
    suminfo.fileinfo.fullname=file('normalize', sumfile);
    suminfo.fileinfo.name=file('tail',suminfo.fileinfo.fullname);
    [suminfo.cards,suminfo.distlist]=getcards(TEXT);
else
    core=suminfo.core;
end
%% Read the summary and find out how many cases there are on file
if getcore
    Sum=PickUpFixedCards(TEXT,'^SUMMARY',13);
    suminfo.sum=Sum;
    xpo=zeros(1,length(Sum));
    for i=1:length(Sum),
        temp=sscanf(Sum{i}{2},'%g');
        xpo(i)=temp(3);
    end
    suminfo.Xpo=xpo;
    bwrhyd=PickUpFixedCards(TEXT,'^BWR HYDRAULICS',9);
    if ~isempty(bwrhyd), suminfo.bwrhyd=bwrhyd;end
    bwrheat=PickUpFixedCards(TEXT,'^BWR HEAT BALANCE',5);
    if ~isempty(bwrheat), suminfo.bwrheat=bwrheat;end    
    if nargin<2
        varargout{1}=suminfo;
        return
    end
end
%% get itteration variables
if nargin == 3
    cards =[];
    nxp = [];
    if ischar(varargin{2})
        switch upper(varargin{2})
            case 'FIRST'
                stptit = 1;
                nxp = 1;
            case 'LAST'
                stptit = length(suminfo.Xpo);
                nxp = 1;
            case 'ALL'
                nxp = length(suminfo.Xpo);
                stptit = [1:nxp];
            otherwise
                cards = varargin;
        end
    elseif isnumeric(varargin{2})
        nxp = length(varargin{2});
        tmpr = 1;
        for i = 1:nxp
            [indic p] = max(abs(suminfo.Xpo - varargin{2}(i)) < 0.01); 
            if indic == 1
               stptit(tmpr) = p;
               tmpr = tmpr + 1;
            end
        end
        if varargin{2} == 10000 
            stptit = 1;
        elseif varargin{2} == 20000
            stptit = length(suminfo.Xpo);
        elseif 1< floor(varargin{2})-varargin{2}<150
            stptit = varargin{2};
        end
    end
    if isempty(nxp), nxp = length(suminfo.Xpo);end
    if isempty(cards), 
        if ischar(varargin{1})
            cards = varargin(1);
        else
            cards = varargin{1};
        end
    end
else
    if ischar(varargin{1})
        cards = varargin(1);
    else
        cards = varargin{1};
    end
    nxp = length(suminfo.Xpo);
	stptit = [1:nxp];
end

icards=cellstrmatch(cards,suminfo.cards,'find');
icards = icards{1};
for i=1:length(cards),
    if isempty(icards(i)),
        fprintf(1,'Available cards: \n');
        disp(suminfo.cards);
        error(['Card ''',cards{i},''' not found']);
    elseif length(icards(i))>1,
        disp(suminfo.cards(icards{i}));
        erstr=sprintf('Card ambiguous: ''%s'' ',...
           cards{i});
        error(erstr);
    else
        cardarg{i}=suminfo.cards{icards(i)};
    end
end
            
    

%% Make sure arguments are unique

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
    varargout{ifind}=label;
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
    varargout{ifind}=ser;
end
%% Read the Istopics
ifind=find(~cellfun(@isempty,strfind(cardarg,'PRI.ISO')));
if ~isempty(ifind)
    for i=1:length(ifind),
        varargout{ifind(i)}=PickUpMap(core,TEXT,cardarg{ifind(i)},7,0);
    end
end
%% Pick up 3Pin
ifind=find(~cellfun(@isempty,strfind(cardarg,'PIN.SUM')));
if ~isempty(ifind)
    for i=1:length(ifind),
        varargout{(i)}=PickUpPinSum3(core,TEXT,cardarg{ifind(i)});
    end
end
% Skip reading Pin2, can be calculated by Pin2{i}=mean(Pin3{i});
%% Pick up CRD.GRP
ifind=find(~cellfun(@isempty,strfind(cardarg,'CRD.GRP')));
if ~isempty(ifind),
    varargout{ifind}=PickUpFull(TEXT,'CRD.GRP',core.irmx,core.irmx,stptit);
end
%% Pick up CRD.POS
ifind=find(~cellfun(@isempty,strfind(cardarg,'CRD.POS')));
if ~isempty(ifind),
    varargout{ifind}=PickUpFull(TEXT,'CRD.POS',core.irmx,core.irmx,stptit);
end
%% Pick up DET.LOC
ifind=find(~cellfun(@isempty,strfind(cardarg,'DET.LOC')));
if ~isempty(ifind),
    varargout{ifind}=PickUpFull(TEXT,'DET.LOC',core.ilmx,core.ilmx,stptit);
end
%% Pick up FUE.TYP
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.TYP')));
if ~isempty(ifind),
    varargout{ifind}=PickUpFull(TEXT,'FUE.TYP',core.iafull+2*core.nref,core.iafull+2*core.nref+2,stptit);
end
%% Pick up FUE.BAT
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.BAT')));
if ~isempty(ifind),
    varargout{ifind}=PickUpFull(TEXT,'FUE.BAT',core.iafull,core.iafull+2,stptit);
end
%% Pick up FUE.ROT
ifind=find(~cellfun(@isempty,strfind(cardarg,'FUE.ROT')));
if ~isempty(ifind),
    varargout{ifind}=PickUpFull(TEXT,'FUE.ROT',core.iafull,core.iafull+2,stptit);
end
%% Pick up FLC
ifind=find(~cellfun(@isempty,strfind(cardarg,'2D MAP')));
if ~isempty(ifind),
    for i=1:length(ifind),
        if strncmpi('EXP',cardarg{ifind(i)},3),
            varargout{ifind(i)}=PickUpExpMap(suminfo.core,TEXT,cardarg{ifind(i)},6,1,stptit);
        else
            varargout{ifind(i)}=PickUpMap(suminfo.core,TEXT,cardarg{ifind(i)},6,1,stptit);
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


function Pin3=PickUpPinSum3(core,TEXT,card)
strlen=7;
offset=1;
iafull=core.iafull;
istart=core.istart;
jstart=core.jstart;
kmax=core.kmax;
N=size(core.knum,1);
Ncol=iafull+1-jstart;
ipin=find(~cellfun(@isempty,regexp(TEXT,['^',card])));
Ncase=length(ipin)/kmax;
Pin3=cell(1,Ncase);
if ~isempty(ipin)
    for i=1:Ncase,
        Pin3{i}=nan(kmax,N);
        for k=1:kmax,
            indx=ipin(k+(i-1)*kmax)+1;
            renorm=sscanf(TEXT{indx}(10:21),'%g');
            Pin3{i}(k,:)=renorm*Pickup(TEXT,indx,offset,strlen,Ncol,istart,iafull,N);
        end
    end
end

function [cards,distlist]=getcards(TEXT)

map2d=strtrim(unique(TEXT(~cellfun(@isempty,regexp(TEXT,'^[A-Z][A-Z][A-Z]\W2D MAP')))));

pinsum=strtrim(unique(TEXT(~cellfun(@isempty,regexp(TEXT,'^PIN.SUM\W')))));

priso=strtrim(unique(TEXT(~cellfun(@isempty,regexp(TEXT,'^PRI.ISO\W')))));

cards={'FUE.LAB';'FUE.SER';'CRD.GRP';'CRD.POS';'DET.LOC';'FUE.BAT';'FUE.ROT';'FUE.TYP';};
distlist=[map2d;pinsum;priso];
cards=[cards;distlist];

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


