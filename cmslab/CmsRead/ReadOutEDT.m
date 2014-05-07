function Corval=ReadOutEDT(TEXT,str,core)
% ReadOutEDT - Flexible reading of TLM and PIN (and maybe more) from .out files
% Corval=ReadOutEDT(TEXT,str,core)

if ~iscell(TEXT),
    fid=fopen(TEXT,'r');
    TEXT = textscan(fid,'%s','delimiter','\n');
    TEXT = TEXT{1};
    fclose(fid);
end
%% 
mminj=core.mminj;
iafull=core.iafull;
%%
ii= find(~cellfun(@isempty,regexp(TEXT,str)));
%%
nread=length(ii);
jcoor=cell(1,nread);
icoor=cell(1,nread);
TEMP=cell(1,nread);
for i=1:nread,
    ioff1=0;
    TEMP{i}=zeros(iafull,iafull);
    rad=TEXT{ii(i)+1};
    if isempty(rad), ioff1=ioff1+1 ;rad=TEXT{ii(i)+1+ioff1};end
    rad(rad=='*')=[];
    jcoor{i}=sscanf(rad,'%i');
    icoor{i}=nan(iafull,1);
    lhs=min(jcoor{i})==1;
    %Check if there is normalization 
    ioffset=0;
    for i1=1:iafull,
        rad=TEXT{ii(i)+1+ioffset+i1+ioff1};
        if isempty(rad), ioff1=ioff1+1 ;rad=TEXT{ii(i)+1+ioffset+i1+ioff1};end
        rad(rad=='*')=[];
        temp=sscanf(rad,'%g');
        rl=iafull/2-mminj(i1)+1;
        icoor{i}(i1)=temp(1);
        if lhs,
            jind=iafull/2-rl+1:iafull/2;
        else
            jind=iafull/2+1:iafull/2+rl;
        end
        TEMP{i}(icoor{i}(i1),jind)=temp(2:rl+1)';
    end
end
%%
TEMP1=cell(1,nread/2);
Corval=cell(1,nread/2);
for i=1:nread/2,
    TEMP1{i}=TEMP{2*i-1}+TEMP{2*i};
    Corval{i}=cor2vec(TEMP1{i},mminj);
end


    
    