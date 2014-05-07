function crdpos=ReadCrd(TEXT,crmminj)
%%
icrdpos=find(~cellfun(@isempty,regexp(TEXT,['^''CRD.POS'''])));


irmx=length(crmminj);
crdpos=NaN(irmx);
for i=1:length(icrdpos),
    read_more=1;
    aa=[];
    rad=TEXT{icrdpos(i)};
    rad=strrep(rad,',',' ');
    if strcmpi(rad(1:9),'''CRD.POS'''), rad(1:9)=[];end
    [iindex,count,errmsg,nextindex]=sscanf(rad,'%i',1);
    rad(1:nextindex-1)=[];
    while ~isempty(rad),
        [a,count,errmsg,nextindex]=sscanf(rad,'%i');
        aa=[aa;a];
        rad=rad(nextindex:end);
        if length(aa)==irmx, break;end
        if strcmp(rad(1),'/'), read_more=0;break;end
        if strcmp(rad(1),'*'),
            rad(1)=[];
            [amul,rad]=parse_star(rad);
            la=length(aa);na=aa(la);
            aa(la:la+na-1,1)=amul;
        end
    end
    crdpos(iindex,:)=aa';
    if read_more,
        icount=0;
        for i1=iindex:irmx,
            icount=icount+1;
            rad=TEXT{icrdpos(i)+icount};
            if isempty(rad), break;end
            if strcmp(rad(1),''''), break;end
            aa=[];
            while ~isempty(rad),
                [a,count,errmsg,nextindex]=sscanf(rad,'%i');
                aa=[aa;a];
                rad=rad(nextindex:end);
                if length(aa)==irmx, break;end
                if strcmp(rad(1),'/'), break;end
                if strcmp(rad(1),'*'),
                    rad(1)=[];
                    [amul,rad]=parse_star(rad);
                    la=length(aa);na=aa(la);
                    aa(la:la+na-1,1)=amul;
                end
            end
            crdpos(i1,:)=aa';
        end
    end
end

crdpos=cor2vec(crdpos,crmminj);
%%
function [amul,rad]=parse_star(rad) 
[amul,count,errms,nextindex]=sscanf(rad,'%i',1);
rad=rad(nextindex:end);
